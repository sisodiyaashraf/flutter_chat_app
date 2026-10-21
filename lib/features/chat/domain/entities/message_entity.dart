import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class MessageEntity extends Equatable {
  final String id;
  final String text;
  final String sender;
  final DateTime time;

  const MessageEntity({
    required this.id,
    required this.text,
    required this.sender,
    required this.time,
  });

  @override
  List<Object?> get props => [id, text, sender, time];
}