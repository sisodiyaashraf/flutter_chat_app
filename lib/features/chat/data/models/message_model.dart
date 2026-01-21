import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required String text,
    required String sender,
    required DateTime time,
  }) : super(text: text, sender: sender, time: time);

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      // 1. SAFETY: Convert to String, fallback to empty string if null
      text: json['text']?.toString() ?? '',

      // 2. SAFETY: Fallback to 'Unknown' if sender is missing
      sender: json['sender']?.toString() ?? 'Unknown',

      // 3. SAFETY: Try to parse date, fallback to 'now' if it fails
      time: DateTime.tryParse(json['time']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}