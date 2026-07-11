import '../../domain/entities/message_entity.dart';

abstract class ChatView {
  void showNewMessage(MessageEntity message);
  void updateTypingStatus(String? typingStatusText);
}

abstract class ChatPresenter {
  void attachView(ChatView view);
  void detachView();

  // 1. UPDATE: initChat now requires the username from the Login Page
  void initChat(String username);

  void sendMessage(String text);
  void onTextChanged(String text);

  // 2. NEW: Getter to let the UI access the current user's name
  String get currentUsername;
}