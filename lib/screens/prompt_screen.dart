import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'chat_screen.dart';

class ApiKeyWidget extends StatelessWidget {
  ApiKeyWidget({
    super.key,
    required this.onSubmitted,
  });

  final ValueChanged onSubmitted;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/on_dark.png', width: 120),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'To use the Gemini API, you\'ll need an API key. '
                'If you don\'t already have one, '
                'create a key in Google AI Studio.',
                style: TextStyle(
                    fontFamily: 'NeueMachina',
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Link(
                uri: Uri.https('aistudio.google.com', '/app/apikey'),
                target: LinkTarget.blank,
                builder: (context, followLink) => TextButton(
                  onPressed: followLink,
                  child: const Text('Get an API Key',
                      style: TextStyle(
                          fontFamily: 'NeueMachina',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: textFieldDecoration(context, 'Enter your API key'),
                style: const TextStyle(
                    fontFamily: 'NeueMachina',
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 12),
                controller: _textController,
                obscureText: true,
                onSubmitted: (value) {
                  onSubmitted(value);
                },
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                onSubmitted(_textController.value.text);
              },
              child: Text('Submit',
                  style: TextStyle(
                      fontFamily: 'NeueMachina',
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary,
                      fontStyle: FontStyle.normal,
                      fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
