import 'package:bharatnxt_app/domain/entities/chat_message_entities.dart';

import 'chat_message_model.dart';

class ChatHistoryResponseModel {
  final String status;
  final List<ChatMessageModel> data;

  const ChatHistoryResponseModel({required this.status, required this.data});

  factory ChatHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>;
    return ChatHistoryResponseModel(
      status: json['status'] as String,
      data:
          rawList
              .map(
                (item) =>
                    ChatMessageModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.map((m) => m.toJson()).toList(),
  };

  List<ChatMessageEntity> toEntities() =>
      data.map((m) => m.toEntity()).toList();

  bool get isSuccess => status == 'success';

  @override
  String toString() =>
      'ChatHistoryResponseModel(status: $status, count: ${data.length})';
}
