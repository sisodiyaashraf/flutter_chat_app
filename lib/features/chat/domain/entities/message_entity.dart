import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String text;
  final String sender;
  final DateTime time;

  const MessageEntity({
    required this.text,
    required this.sender,
    required this.time,
  });

  @override
  List<Object?> get props => [text, sender, time];
}