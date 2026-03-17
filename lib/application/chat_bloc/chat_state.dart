part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatMessagesUpdated extends ChatState {
  final List<ChatMessageEntity> messages;
  final bool isTyping;
  const ChatMessagesUpdated({required this.messages, this.isTyping = false});

  ChatMessagesUpdated copyWith({
    List<ChatMessageEntity>? messages,
    bool? isTyping,
  }) => ChatMessagesUpdated(
    messages: messages ?? this.messages,
    isTyping: isTyping ?? this.isTyping,
  );

  @override
  List<Object?> get props => [messages, isTyping];
}

class ChatError extends ChatState {
  final List<ChatMessageEntity> messages;
  final String error;
  const ChatError({required this.messages, required this.error});
  @override
  List<Object?> get props => [messages, error];
}
