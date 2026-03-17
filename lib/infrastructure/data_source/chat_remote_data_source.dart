import 'dart:convert';
import 'dart:math';
import 'package:bharatnxt_app/infrastructure/model/chat_history_response_model.dart';
import 'package:bharatnxt_app/infrastructure/model/chat_reply_model.dart';
import 'package:bharatnxt_app/infrastructure/model/chat_request_model.dart';
import 'package:http/http.dart' as http;

abstract class ChatRemoteDataSource {
  Future<ChatReplyModel> sendMessage(String message);

  Future<ChatHistoryResponseModel> getChatHistory();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client _client;

  static const String _baseUrl = '';

  const ChatRemoteDataSourceImpl(this._client);

  @override
  Future<ChatReplyModel> sendMessage(String message) async {
    final uri = Uri.parse('$_baseUrl/chat');

    final requestModel = ChatRequestModel(message: message);

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestModel.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ChatReplyModel.fromJson(json);
    } else {
      throw Exception(
        'POST /chat failed — '
        'status: ${response.statusCode}, body: ${response.body}',
      );
    }
  }

  @override
  Future<ChatHistoryResponseModel> getChatHistory() async {
    final uri = Uri.parse('$_baseUrl/chat/history');

    final response = await _client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ChatHistoryResponseModel.fromJson(json);
    } else {
      throw Exception(
        'GET /chat/history failed — '
        'status: ${response.statusCode}, body: ${response.body}',
      );
    }
  }
}

class ChatRemoteDataSourceMock implements ChatRemoteDataSource {
  static const List<String> _replies = [
    'Flutter state management separates UI from business logic using events and states. BLoC is the most structured approach — events go in, states come out.',
    'Clean architecture keeps your project layered: Presentation → Domain → Data. Each layer depends only inward, making your code testable and maintainable.',
    'GoRouter is Flutter\'s recommended navigation package. Define all routes declaratively and navigate with context.go() or context.push().',
    'Equatable overrides == and hashCode automatically. Use it on your entities, events, and states to avoid unnecessary widget rebuilds.',
    'The http package is Flutter\'s standard HTTP client. Use it with async/await to call REST APIs cleanly without extra overhead.',
    'Responsive layouts in Flutter use MediaQuery and LayoutBuilder. Target mobile (<600px), tablet (600–900px), and desktop (>900px) breakpoints.',
    'BlocConsumer combines BlocBuilder and BlocListener in one widget — use it when you need to both rebuild UI and trigger side-effects on state changes.',
    'Use const constructors wherever possible in Flutter. It tells the framework the widget won\'t change, cutting unnecessary rebuilds significantly.',
  ];

  @override
  Future<ChatReplyModel> sendMessage(String message) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final reply = _replies[Random().nextInt(_replies.length)];
    return ChatReplyModel.fromJson({'status': 'success', 'reply': reply});
  }

  @override
  Future<ChatHistoryResponseModel> getChatHistory() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return ChatHistoryResponseModel.fromJson({
      'status': 'success',
      'data': [
        {'sender': 'user', 'message': 'What is Flutter?'},
        {
          'sender': 'assistant',
          'message':
              'Flutter is an open-source UI toolkit by Google for building natively compiled apps for mobile, web, and desktop from a single Dart codebase.',
        },
        {'sender': 'user', 'message': 'How does BLoC work?'},
        {
          'sender': 'assistant',
          'message':
              'BLoC separates UI from business logic. You dispatch Events into the BLoC, it processes them and emits States, and your widgets rebuild based on those states.',
        },
        {'sender': 'user', 'message': 'What is clean architecture?'},
        {
          'sender': 'assistant',
          'message':
              'Clean Architecture splits your app into three layers — Presentation, Domain, and Data. Dependencies only point inward, keeping code testable and maintainable.',
        },
        {'sender': 'user', 'message': 'Explain GoRouter'},
        {
          'sender': 'assistant',
          'message':
              'GoRouter is the official Flutter routing package. It supports deep linking, nested routes, ShellRoute for shared UI (like bottom nav), and declarative route definitions.',
        },
      ],
    });
  }
}
