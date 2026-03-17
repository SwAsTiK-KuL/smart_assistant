import 'package:bharatnxt_app/domain/entities/chat_message_entities.dart';

class ChatMessageModel {
  final String sender;
  final String message;

  const ChatMessageModel({required this.sender, required this.message});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      sender: json['sender'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'sender': sender, 'message': message};

  ChatMessageEntity toEntity() => ChatMessageEntity(
    sender: MessageSender.fromString(sender),
    message: message,
  );

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      sender: entity.sender.toJson(),
      message: entity.message,
    );
  }

  ChatMessageModel copyWith({String? sender, String? message}) =>
      ChatMessageModel(
        sender: sender ?? this.sender,
        message: message ?? this.message,
      );

  @override
  String toString() => 'ChatMessageModel(sender: $sender, message: "$message")';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageModel &&
          other.sender == sender &&
          other.message == message;

  @override
  int get hashCode => Object.hash(sender, message);
}
