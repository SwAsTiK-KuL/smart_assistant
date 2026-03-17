part of 'suggestion_bloc.dart';

abstract class SuggestionsEvent extends Equatable {
  const SuggestionsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSuggestionsEvent extends SuggestionsEvent {
  final int page;
  final int limit;
  const LoadSuggestionsEvent({this.page = 1, this.limit = 10});
  @override
  List<Object?> get props => [page, limit];
}

class NextPageEvent extends SuggestionsEvent {
  const NextPageEvent();
}

class PreviousPageEvent extends SuggestionsEvent {
  const PreviousPageEvent();
}

class GoToPageEvent extends SuggestionsEvent {
  final int page;
  const GoToPageEvent(this.page);
  @override
  List<Object?> get props => [page];
}
