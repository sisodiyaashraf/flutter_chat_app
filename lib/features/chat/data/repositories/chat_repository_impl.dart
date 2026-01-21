import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<MessageEntity> get messageStream => remoteDataSource.messageStream;

  // 1. NEW: Expose the typing stream from the data source
  @override
  Stream<bool> get typingStream => remoteDataSource.typingStream;

  @override
  void connect() => remoteDataSource.connect();

  @override
  void disconnect() => remoteDataSource.disconnect();

  @override
  void sendMessage(String text, String username) =>
      remoteDataSource.sendMessage(text, username);

  // 2. NEW: Implement the sendTyping method
  @override
  void sendTyping(bool isTyping) => remoteDataSource.sendTyping(isTyping);
}