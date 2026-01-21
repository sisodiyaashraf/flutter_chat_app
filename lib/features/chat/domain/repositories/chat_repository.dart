import '../entities/message_entity.dart';

abstract class ChatRepository {
  Stream<MessageEntity> get messageStream;

  // 1. ADD THIS: Stream to listen for typing status
  Stream<bool> get typingStream;

  void connect();
  void disconnect();
  void sendMessage(String text, String username);

  // 2. ADD THIS: Function to tell server we are typing
  void sendTyping(bool isTyping);
}