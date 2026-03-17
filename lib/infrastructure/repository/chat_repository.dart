import 'package:bharatnxt_app/domain/entities/chat_message_entities.dart';
import 'package:bharatnxt_app/domain/entities/chat_reply_entities.dart';
import 'package:bharatnxt_app/domain/repository/chat_repository.dart';
import 'package:bharatnxt_app/infrastructure/data_source/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  const ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<ChatReplyEntity> sendMessage(String message) async {
    try {
      final replyModel = await _remoteDataSource.sendMessage(message);

      if (!replyModel.isSuccess) {
        throw Exception('Chat API returned status: "${replyModel.status}"');
      }

      return replyModel.toEntity();
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error sending message: $e');
    }
  }

  @override
  Future<List<ChatMessageEntity>> getChatHistory() async {
    try {
      final historyModel = await _remoteDataSource.getChatHistory();

      if (!historyModel.isSuccess) {
        throw Exception(
          'Chat history API returned status: "${historyModel.status}"',
        );
      }

      return historyModel.toEntities();
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error fetching chat history: $e');
    }
  }
}
