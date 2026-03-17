import 'package:bharatnxt_app/domain/entities/pagination_entites.dart';
import 'package:bharatnxt_app/domain/entities/sugeestion_entities.dart';
import 'package:equatable/equatable.dart';

class SuggestionsPageEntity extends Equatable {
  final List<SuggestionEntity> suggestions;
  final PaginationEntity pagination;

  const SuggestionsPageEntity({
    required this.suggestions,
    required this.pagination,
  });

  bool get isEmpty => suggestions.isEmpty;

  int get count => suggestions.length;

  @override
  List<Object?> get props => [suggestions, pagination];

  @override
  String toString() =>
      'SuggestionsPageEntity(count: $count, pagination: $pagination)';
}
