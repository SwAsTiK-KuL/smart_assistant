import 'package:bharatnxt_app/domain/entities/chat_message_entities.dart';
import 'package:bharatnxt_app/domain/entities/chat_reply_entities.dart';

abstract class ChatRepository {
  Future<ChatReplyEntity> sendMessage(String message);

  Future<List<ChatMessageEntity>> getChatHistory();
}
