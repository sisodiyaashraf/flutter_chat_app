import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/service_locator.dart' as di;
import 'core/theme.dart';
import 'features/chat/presentation/pages/login_page.dart'; // 1. Import Login Page
import 'features/chat/presentation/provider/session_provider.dart';
import 'features/chat/presentation/provider/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Dependency Injection
  di.init();

  // Create and initialize SessionProvider before the UI starts.
  final sessionProvider = SessionProvider();
  await sessionProvider.init();

  runApp(MyApp(sessionProvider: sessionProvider));
}

class MyApp extends StatelessWidget {
  const MyApp({this.sessionProvider, super.key});

  final SessionProvider? sessionProvider;

  @override
  Widget build(BuildContext context) {
    // If no sessionProvider is supplied (e.g., in tests), create a fresh one.
    final provider = sessionProvider ?? SessionProvider();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SessionProvider>.value(value: provider),
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
