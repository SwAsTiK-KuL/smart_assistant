import 'package:bharatnxt_app/domain/entities/suggestion_page_entites.dart';
import 'package:bharatnxt_app/domain/repository/suggestion_repository.dart';
import 'package:bharatnxt_app/infrastructure/data_source/suggestions_remote_data_source.dart';

class SuggestionsRepositoryImpl implements SuggestionsRepository {
  final SuggestionsRemoteDataSource _remoteDataSource;

  const SuggestionsRepositoryImpl(this._remoteDataSource);

  @override
  Future<SuggestionsPageEntity> getSuggestions({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final responseModel = await _remoteDataSource.getSuggestions(
        page: page,
        limit: limit,
      );

      if (!responseModel.isSuccess) {
        throw Exception(
          'Suggestions API returned status: "${responseModel.status}"',
        );
      }

      return responseModel.toEntity();
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error fetching suggestions: $e');
    }
  }
}
