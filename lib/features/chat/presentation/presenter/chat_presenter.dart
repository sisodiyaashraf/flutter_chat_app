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
    _typingSubscription = repository.typingStream.listen((isTyping) {
      _view?.updateTypingStatus(isTyping);
    });
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
      repository.sendTyping(false);
      _typingTimer?.cancel();
    }
  }

  @override
  void onTextChanged(String text) {
    repository.sendTyping(true);
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      repository.sendTyping(false);
    });
  }

  @override
  String get currentUsername => _username;
}