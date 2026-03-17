import 'package:bharatnxt_app/domain/entities/suggestion_page_entites.dart';

abstract class SuggestionsRepository {
  Future<SuggestionsPageEntity> getSuggestions({int page = 1, int limit = 10});
}
