import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.apiKey,
  });

  final String apiKey;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final loading = ValueNotifier(false);
  final menu = ValueNotifier('');
  final messages = ValueNotifier<List<(Sender, String)>>([]);
  final controller = TextEditingController();
  late final _history = <Content>[];

  late final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: widget.apiKey,
    requestOptions: const RequestOptions(apiVersion: 'v1beta'),
    tools: [
      Tool(
        functionDeclarations: <FunctionDeclaration>[
          FunctionDeclaration(
            'ask_ai',
            'Ask the AI for a Generated Answer',
            Schema(
              SchemaType.object,
              properties: {
                'question': Schema(
                  SchemaType.string,
                ),
              },
            ),
          ),
        ],
      ),
    ],
  );

  late final ai = GenerativeModel(
    model: 'gemini-pro',
    apiKey: widget.apiKey,
    requestOptions: const RequestOptions(apiVersion: 'v1beta'),
  );

  Future<void> sendMessage() async {
    final message = controller.text.trim();
    if (message.isEmpty) return;
    controller.clear();
    addMessage(Sender.user, message);
    loading.value = true;
    try {
      final prompt = StringBuffer();
      prompt.writeln(
        'You are a super smart AI agent that can answer questions and '
        'generate responses based on the question. Break up the question '
        'into subtasks and call them in the correct order. If you need to think more '
        'or generate more output, call the ask_ai function to elaborate:',
      );
      prompt.writeln(message);
      final response = await callWithActions([Content.text(prompt.toString())]);
      if (response.text != null) {
        addMessage(Sender.system, response.text!);
      } else {
        addMessage(Sender.system, 'Something went wrong, please try again.');
      }
    } catch (e) {
      addMessage(Sender.system, 'Error sending message: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<GenerateContentResponse> callWithActions(
    Iterable<Content> prompt,
  ) async {
    final response = await model.generateContent(
      _history.followedBy(prompt),
    );
    print((response.text, response.functionCalls));
    if (response.candidates.isNotEmpty) {
      _history.addAll(prompt);
      _history.add(response.candidates.first.content);
    }
    final actions = <FunctionResponse>[];
    for (final fn in response.functionCalls) {
      final args = fn.args;
      switch (fn.name) {
        case 'ask_ai':
          final question = args['question'] as String;
          final response = await ai.generateContent([Content.text(question)]);
          final text = response.text ?? '';
          actions.add(FunctionResponse(
            fn.name,
            {"answer": text},
          ));
          break;
        default:
      }
    }
    if (actions.isNotEmpty) {
      return await callWithActions([
        ...prompt,
        if (response.functionCalls.isNotEmpty)
          Content.model(response.functionCalls),
        for (final res in actions)
          Content.functionResponse(res.name, res.response),
      ]);
    }
    return response;
  }

  void addMessage(Sender sender, String value, {bool clear = false}) {
    if (clear) {
      _history.clear();
      messages.value = [];
    }
    messages.value = messages.value.toList()..add((sender, value));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: messages,
      builder: (context, child) {
        final reversed = messages.value.reversed;
        return Scaffold(
          appBar: AppBar(
            title: Image.asset('assets/on_dark.png', width: 120),
            centerTitle: true,
          ),
          body: messages.value.isEmpty
              ? const Center(
                  child: Text('No questions asked',
                      style: TextStyle(
                          fontFamily: 'NeueMachina',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 12)))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  reverse: true,
                  itemCount: reversed.length,
                  itemBuilder: (context, index) {
                    final (sender, message) = reversed.elementAt(index);
                    return MessageWidget(
                      isFromUser: sender == Sender.user,
                      text: message,
                    );
                  },
                ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                        textFieldDecoration(context, 'Ask the AI anything'),
                    onEditingComplete: sendMessage,
                    onSubmitted: (value) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedBuilder(
                  animation: loading,
                  builder: (context, _) {
                    if (loading.value) {
                      return const CircularProgressIndicator();
                    }
                    return IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send),
                      tooltip: 'Send the question',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum Sender {
  user,
  system,
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    this.text,
    this.image,
    required this.isFromUser,
  });

  final Image? image;
  final String? text;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment:
            isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
              decoration: BoxDecoration(
                color: isFromUser
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 20,
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(children: [
                if (text case final text?)
                  MarkdownBody(
                    data: text,
                    selectable: true,
                  ),
                if (image case final image?) image,
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration textFieldDecoration(BuildContext context, String hintText) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(15),
    hintText: hintText,
    hintStyle: const TextStyle(
        fontFamily: 'NeueMachina',
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        fontSize: 12),
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(14),
      ),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(14),
      ),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
      ),
    ),
  );
}
