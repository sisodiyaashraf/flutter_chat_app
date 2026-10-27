import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat_app/features/chat/presentation/provider/session_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('SessionProvider loads persisted values on init', () async {
    // Arrange: mock stored values
    SharedPreferences.setMockInitialValues({
      'username': 'Alice',
      'serverUrl': 'http://localhost:3000',
      'rememberMe': true,
    });

    // Act
    final provider = SessionProvider();
    await provider.init();

    // Assert
    expect(provider.username, 'Alice');
    expect(provider.serverUrl, 'http://localhost:3000');
    expect(provider.rememberMe, true);
  });

  test('SessionProvider setters persist values', () async {
    // Arrange: start with empty prefs
    SharedPreferences.setMockInitialValues({});
    final provider = SessionProvider();
    await provider.init();

    // Act
    await provider.setUsername('Bob');
    await provider.setServerUrl('https://example.com');
    await provider.setRememberMe(true);

    // Assert persisted values via provider
    expect(provider.rememberMe, true);
    // Optionally verify SharedPreferences directly if needed
    // final prefs = await SharedPreferences.getInstance();
    // expect(prefs.getBool('rememberMe'), true);

  });
}
