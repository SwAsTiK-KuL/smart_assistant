import 'package:equatable/equatable.dart';

class ChatReplyEntity extends Equatable {
  final String reply;

  const ChatReplyEntity({required this.reply});

  bool get hasContent => reply.trim().isNotEmpty;

  @override
  List<Object?> get props => [reply];

  @override
  String toString() => 'ChatReplyEntity(reply: "$reply")';
}
