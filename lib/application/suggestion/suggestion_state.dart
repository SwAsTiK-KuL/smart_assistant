part of 'suggestion_bloc.dart';

abstract class SuggestionsState extends Equatable {
  const SuggestionsState();
  @override
  List<Object?> get props => [];
}

class SuggestionsInitial extends SuggestionsState {
  const SuggestionsInitial();
}

class SuggestionsLoading extends SuggestionsState {
  final int page;
  const SuggestionsLoading({this.page = 1});
  @override
  List<Object?> get props => [page];
}

class SuggestionsLoaded extends SuggestionsState {
  final List<SuggestionEntity> suggestions;
  final PaginationEntity pagination;
  const SuggestionsLoaded({
    required this.suggestions,
    required this.pagination,
  });
  @override
  List<Object?> get props => [suggestions, pagination];
}

class SuggestionsError extends SuggestionsState {
  final String message;
  const SuggestionsError(this.message);
  @override
  List<Object?> get props => [message];
}
