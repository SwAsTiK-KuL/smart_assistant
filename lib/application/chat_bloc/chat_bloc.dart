import 'package:bharatnxt_app/domain/entities/chat_message_entities.dart';
import 'package:bharatnxt_app/domain/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;
  final List<ChatMessageEntity> _messages = [];

  ChatBloc(this._repository) : super(const ChatInitial()) {
    on<SendMessageEvent>(_onSend);
    on<ClearChatEvent>(_onClear);
  }

  Future<void> _onSend(SendMessageEvent event, Emitter<ChatState> emit) async {
    _messages.add(
      ChatMessageEntity(sender: MessageSender.user, message: event.message),
    );
    emit(ChatMessagesUpdated(messages: List.from(_messages), isTyping: true));

    try {
      final reply = await _repository.sendMessage(event.message);
      _messages.add(
        ChatMessageEntity(
          sender: MessageSender.assistant,
          message: reply.reply,
        ),
      );
      emit(
        ChatMessagesUpdated(messages: List.from(_messages), isTyping: false),
      );
    } catch (e) {
      emit(ChatError(messages: List.from(_messages), error: e.toString()));
    }
  }

  void _onClear(ClearChatEvent event, Emitter<ChatState> emit) {
    _messages.clear();
    emit(const ChatInitial());
  }
}
