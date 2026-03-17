import 'package:equatable/equatable.dart';

enum MessageSender {
  user,
  assistant;

  bool get isUser => this == MessageSender.user;

  bool get isAssistant => this == MessageSender.assistant;

  static MessageSender fromString(String value) {
    return switch (value.toLowerCase()) {
      'user' => MessageSender.user,
      'assistant' => MessageSender.assistant,
      _ => throw ArgumentError('Unknown sender value: "$value"'),
    };
  }

  String toJson() => name;
}

class ChatMessageEntity extends Equatable {
  final MessageSender sender;
  final String message;

  const ChatMessageEntity({required this.sender, required this.message});

  factory ChatMessageEntity.fromRaw({
    required String sender,
    required String message,
  }) => ChatMessageEntity(
    sender: MessageSender.fromString(sender),
    message: message,
  );

  bool get isUser => sender.isUser;

  bool get isAssistant => sender.isAssistant;

  @override
  List<Object?> get props => [sender, message];

  @override
  String toString() =>
      'ChatMessageEntity(sender: ${sender.name}, message: "$message")';
}
