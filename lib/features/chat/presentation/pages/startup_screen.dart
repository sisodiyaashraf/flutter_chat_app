import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/session_provider.dart';
import 'login_page.dart';
import 'chat_page.dart';

/// A lightweight startup screen that decides whether to show the login
/// flow or go straight to the chat based on persisted session data.
class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>();

    // Use a post‑frame callback so we can navigate after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (session.rememberMe && session.username != null && session.username!.isNotEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ChatPage(username: session.username!)),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    });

    // While the decision is being made we show a simple splash.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
