// Basic widget test for the chat app.
// Verifies that the app builds and shows the LoginPage.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat_app/main.dart';
import 'package:flutter_chat_app/features/chat/presentation/pages/login_page.dart';

void main() {
  testWidgets('App builds and shows LoginPage', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Allow any async init to settle.
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
