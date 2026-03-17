import 'package:bharatnxt_app/domain/entities/chat_reply_entities.dart';

class ChatReplyModel {
  final String status;
  final String reply;

  const ChatReplyModel({required this.status, required this.reply});

  factory ChatReplyModel.fromJson(Map<String, dynamic> json) {
    return ChatReplyModel(
      status: json['status'] as String,
      reply: json['reply'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'reply': reply};

  ChatReplyEntity toEntity() => ChatReplyEntity(reply: reply);

  bool get isSuccess => status == 'success';

  @override
  String toString() => 'ChatReplyModel(status: $status, reply: "$reply")';
}
