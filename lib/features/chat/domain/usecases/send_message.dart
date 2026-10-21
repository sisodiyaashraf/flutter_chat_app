import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/message_entity.dart';

class SendMessage {
  final ChatRepository _repository;
  SendMessage(this._repository);

  Future<void> execute(String text, String username) async {
    _repository.sendMessage(text, username);
  }
}
