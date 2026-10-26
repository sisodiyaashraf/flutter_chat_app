import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/service_locator.dart' as di;
import 'core/theme.dart';
import 'features/chat/presentation/pages/login_page.dart'; // 1. Import Login Page
import 'features/chat/presentation/provider/session_provider.dart';
import 'features/chat/presentation/provider/chat_provider.dart';

void main() {
  // Initialize Dependency Injection
  di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        // ChatProvider is registered via GetIt, we expose it here for the UI.
        ChangeNotifierProvider(create: (_) => di.sl<ChatProvider>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Socket MVP',
        theme: appTheme,
        // 2. Set Login Page as the starting screen
        home: const LoginPage(),
      ),
    );
  }
}
