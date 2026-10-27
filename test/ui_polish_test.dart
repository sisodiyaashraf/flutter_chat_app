// test/ui_polish_test.dart
// UI‑polish verification: Settings slide transition & TypingIndicator animation.
// Updated to correctly provide a ChatProvider in the widget tree.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_chat_app/main.dart';
import 'package:flutter_chat_app/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter_chat_app/features/chat/presentation/pages/settings_page.dart';
import 'package:flutter_chat_app/features/chat/presentation/widgets/typing_indicator.dart';
import 'package:flutter_chat_app/features/chat/presentation/provider/chat_provider.dart';
import 'package:flutter_chat_app/features/chat/domain/entities/message_entity.dart';

/// Minimal mock implementation of ChatProvider for widget tests.
class MockChatProvider extends ChangeNotifier implements ChatProvider {
  String? _typingStatus;

  @override
  String? get typingStatusText => _typingStatus;

  void setTypingStatus(String? status) {
    _typingStatus = status;
    notifyListeners();
  }

  // ---------- Required members from ChatProvider (stubbed) ----------
  @override
  List<MessageEntity> get messages => [];

  @override
  bool get isConnected => true;

  @override
  void initChat(String username) {}

  @override
  void sendMessage(String text) {}

  @override
  void onTextChanged(String text) {}

  @override
  String? get currentUsername => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('UI Premium Polish Tests', () {
    testWidgets('Settings icon triggers slide‑in transition', (
      WidgetTester tester,
    ) async {
      // Provide MockChatProvider and build ChatPage directly.
      await tester.pumpWidget(
        ChangeNotifierProvider<ChatProvider>.value(
          value: MockChatProvider(),
          child: const MaterialApp(home: ChatPage(username: 'tester')),
        ),
      );
      await tester.pumpAndSettle();

      // Settings button should be present.
      final settingsIcon = find.byIcon(Icons.settings);
      expect(settingsIcon, findsOneWidget);

      // Tap the Settings button.
      await tester.tap(settingsIcon);
      await tester.pump(); // start navigation

      // Halfway through slide animation.
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.byType(SettingsPage), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('TypingIndicator animates on status change', (
      WidgetTester tester,
    ) async {
      final mockProvider = MockChatProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<ChatProvider>.value(
          value: mockProvider,
          child: MaterialApp(home: Scaffold(body: TypingIndicator())),
        ),
      );

      // Initially no typing indicator.
      expect(find.byKey(const ValueKey('empty')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Set typing status.
      mockProvider.setTypingStatus('Alice is typing...');
      await tester.pump(); // start AnimatedSwitcher transition
             expect(find.byKey(const ValueKey('typing')), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.text('Alice is typing...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Remove status.
      mockProvider.setTypingStatus(null);
      await tester.pump(); // start transition back to empty
      await tester.pump(const Duration(milliseconds: 300)); // wait for animation
      expect(find.byKey(const ValueKey('empty')), findsOneWidget);
      expect(find.byKey(const ValueKey('typing')), findsNothing);
    });
  });
}
