import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';
import 'screens/prompt_screen.dart';
import 'util/dark_theme.dart';
import 'util/light_theme.dart';
import 'util/pallete.dart';

final themeColor = ValueNotifier<Color>(AppColor.tertiary);
int lastId = 0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData theme(Brightness brightness) {
    final colors = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: themeColor.value,
    );
    return ThemeData(
      brightness: brightness,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeColor,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          home: const Home(),
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? apiKey;

  @override
  Widget build(BuildContext context) {
    // return switch (apiKey) {
    //   final providedKey? => ChatScreen(
    //       apiKey: providedKey,
    //     ),
    //   _ => ApiKeyWidget(
    //       onSubmitted: (key) {
    //         setState(() => apiKey = key);
    //       },
    //     ),
    // };
    return const ChatScreen(apiKey: 'AIzaSyBjxxk5kxVVFMc8P2SJwFYlN17M-YL8Dog');
  }
}
