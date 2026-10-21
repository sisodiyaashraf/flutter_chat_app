import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/listen_messages.dart';
import '../../domain/usecases/typing_status.dart';

/// ChatProvider replaces the old MVP presenter.
/// It manages socket connection, message streams, typing events,
/// and exposes state for the UI via ChangeNotifier.
class ChatProvider extends ChangeNotifier {
  final ChatRepository _repository;
  final SendMessage _sendMessage;
  final ListenMessages _listenMessages;
  final TypingStatus _typingStatus;

  // UI state
  final List<MessageEntity> _messages = [];
  List<MessageEntity> get messages => List.unmodifiable(_messages);
  String? _typingStatusText;
  String? get typingStatusText => _typingStatusText;
  String? _currentUsername;
  String? get currentUsername => _currentUsername;

  // Connection state
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  StreamSubscription<MessageEntity>? _msgSub;
  StreamSubscription<Map<String, dynamic>>? _typingSub;

  ChatProvider({required ChatRepository repository})
      : _repository = repository,
        _sendMessage = SendMessage(repository),
        _listenMessages = ListenMessages(repository),
        _typingStatus = TypingStatus(repository);

  /// Initialise the chat with the logged‑in username.
  void initChat(String username) {
    _currentUsername = username;
    _repository.connect();
    // Listen to incoming messages.
    _msgSub = _repository.messageStream.listen(_onMessageReceived);
    // Listen to typing events.
    _typingSub = _repository.typingStream.listen(_onTypingEvent);
  }

  void _onMessageReceived(MessageEntity message) {
    // Optimistic UI already added our own messages, filter them.
    if (message.sender != _currentUsername) {
      _messages.add(message);
      notifyListeners();
    }
  }

  void _onTypingEvent(Map<String, dynamic> data) {
    final isTyping = data['isTyping'] as bool? ?? false;
    final username = data['username'] as String? ?? '';
    if (username.isEmpty || username == _currentUsername) return;
    if (isTyping) {
      _typingStatusText = '$username is typing...';
    } else {
      _typingStatusText = null;
    }
    notifyListeners();
  }

  /// Send a message (optimistic UI handled by UI layer).
  void sendMessage(String text) {
    if (text.trim().isEmpty || _currentUsername == null) return;
    _sendMessage.execute(text, _currentUsername!);
    // Reset typing flag.
    _typingStatus.execute(isTyping: false);
  }

  /// Debounced typing notification.
  Timer? _debounceTimer;
  void onTextChanged(String text) {
    _typingStatus.execute(isTyping: true);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _typingStatus.execute(isTyping: false);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _msgSub?.cancel();
    _typingSub?.cancel();
    _repository.disconnect();
    super.dispose();
  }
}
