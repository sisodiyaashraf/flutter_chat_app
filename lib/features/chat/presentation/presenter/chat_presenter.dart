import 'dart:async';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../contract/chat_contract.dart';

class ChatPresenterImpl implements ChatPresenter {
  final ChatRepository repository;
  ChatView? _view;

  StreamSubscription? _msgSubscription;
  StreamSubscription? _typingSubscription;
  Timer? _typingTimer;

  // 1. UPDATE: Changed to 'late' because we set it in initChat()
  late String _username;
  final Set<String> _typingUsers = {};

  ChatPresenterImpl({required this.repository});

  @override
  void attachView(ChatView view) {
    _view = view;
  }

  @override
  void detachView() {
    _msgSubscription?.cancel();
    _typingSubscription?.cancel();
    _typingTimer?.cancel();

    repository.disconnect();
    _view = null;
  }

  // 2. UPDATE: Accept 'username' as a parameter
  @override
  void initChat(String username) {
    _username = username; // Save the logged-in username

    repository.connect();

    // Listen to Messages
    _msgSubscription = repository.messageStream.listen((message) {
      // Filter out our own messages (Optimistic UI handles them locally)
      if (message.sender != _username) {
        _view?.showNewMessage(message);
      }
    });

    // Listen to Typing Status
    _typingSubscription = repository.typingStream.listen((data) {
      final isTyping = data['isTyping'] as bool? ?? false;
      final typingUsername = data['username'] as String? ?? '';

      // Ignore our own typing events
      if (typingUsername.isEmpty || typingUsername == _username) return;

      if (isTyping) {
        _typingUsers.add(typingUsername);
      } else {
        _typingUsers.remove(typingUsername);
      }

      _notifyTypingStatus();
    });
  }

  void _notifyTypingStatus() {
    if (_typingUsers.isEmpty) {
      _view?.updateTypingStatus(null);
    } else if (_typingUsers.length == 1) {
      _view?.updateTypingStatus("${_typingUsers.first} is typing...");
    } else if (_typingUsers.length == 2) {
      _view?.updateTypingStatus("${_typingUsers.first} and ${_typingUsers.last} are typing...");
    } else {
      _view?.updateTypingStatus("Several people are typing...");
    }
  }

  @override
  void sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      // Optimistic Update
      final localMessage = MessageEntity(
          text: text,
          sender: _username,
          time: DateTime.now()
      );
      _view?.showNewMessage(localMessage);

      // Send to Server
      repository.sendMessage(text, _username);

      // Reset Typing Logic
      repository.sendTyping(false, _username);
      _typingTimer?.cancel();
    }
  }

  @override
  void onTextChanged(String text) {
    repository.sendTyping(true, _username);
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      repository.sendTyping(false, _username);
    });
  }

  @override
  String get currentUsername => _username;
}