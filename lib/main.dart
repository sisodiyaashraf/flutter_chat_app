import 'package:flutter/material.dart';
import 'core/service_locator.dart' as di;
import 'features/chat/presentation/pages/login_page.dart'; // 1. Import Login Page

void main() {
  // Initialize Dependency Injection
  di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Socket MVP',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      // 2. Set Login Page as the starting screen
      home: const LoginPage(),
    );
  }
}