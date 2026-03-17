import 'dart:convert';
import 'package:bharatnxt_app/infrastructure/model/sugesstions_response_model.dart';
import 'package:http/http.dart' as http;

abstract class SuggestionsRemoteDataSource {
  Future<SuggestionsResponseModel> getSuggestions({
    required int page,
    required int limit,
  });
}

class SuggestionsRemoteDataSourceImpl implements SuggestionsRemoteDataSource {
  final http.Client _client;

  static const String _baseUrl = '';

  const SuggestionsRemoteDataSourceImpl(this._client);

  @override
  Future<SuggestionsResponseModel> getSuggestions({
    required int page,
    required int limit,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/suggestions',
    ).replace(queryParameters: {'page': '$page', 'limit': '$limit'});

    final response = await _client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return SuggestionsResponseModel.fromJson(json);
    } else {
      throw Exception(
        'GET /suggestions failed — '
        'status: ${response.statusCode}, body: ${response.body}',
      );
    }
  }
}

class SuggestionsRemoteDataSourceMock implements SuggestionsRemoteDataSource {
  static const int _totalItems = 50;

  static const List<Map<String, String>> _pool = [
    {
      'title': 'Summarize my notes',
      'description': 'Get a concise summary of your text notes quickly',
    },
    {
      'title': 'Generate email reply',
      'description': 'Create a professional and polished email response',
    },
    {
      'title': 'Explain a concept',
      'description': 'Break down complex topics into simple explanations',
    },
    {
      'title': 'Write a cover letter',
      'description': 'Draft a compelling cover letter for your job application',
    },
    {
      'title': 'Fix my code',
      'description': 'Debug and improve your code snippets with AI assistance',
    },
    {
      'title': 'Translate text',
      'description': 'Translate content into multiple languages accurately',
    },
    {
      'title': 'Create a to-do list',
      'description': 'Organize your tasks into a structured daily plan',
    },
    {
      'title': 'Analyze sentiment',
      'description': 'Understand the emotional tone behind any text',
    },
    {
      'title': 'Brainstorm ideas',
      'description': 'Generate creative ideas for any project or task',
    },
    {
      'title': 'Proofread document',
      'description': 'Check grammar, spelling, and style in your document',
    },
  ];

  @override
  Future<SuggestionsResponseModel> getSuggestions({
    required int page,
    required int limit,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final totalPages = (_totalItems / limit).ceil();
    final startIndex = (page - 1) * limit;
    final endIndex = (startIndex + limit).clamp(0, _totalItems);

    if (startIndex >= _totalItems) {
      throw Exception('Page $page out of range (total: $totalPages)');
    }

    final items = List.generate(endIndex - startIndex, (i) {
      final item = _pool[(startIndex + i) % _pool.length];
      return {
        'id': startIndex + i + 1,
        'title': item['title']!,
        'description': item['description']!,
      };
    });

    final json = <String, dynamic>{
      'status': 'success',
      'data': items,
      'pagination': {
        'current_page': page,
        'total_pages': totalPages,
        'total_items': _totalItems,
        'limit': limit,
        'has_next': page < totalPages,
        'has_previous': page > 1,
      },
    };

    return SuggestionsResponseModel.fromJson(json);
  }
}
