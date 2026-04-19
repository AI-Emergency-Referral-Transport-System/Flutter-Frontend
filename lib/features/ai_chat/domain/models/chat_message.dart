import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isMine,
    required this.timestamp,
  });

  final String id;
  final String text;
  final bool isMine;
  final DateTime timestamp;

  @override
  List<Object?> get props => [id, text, isMine, timestamp];
}
