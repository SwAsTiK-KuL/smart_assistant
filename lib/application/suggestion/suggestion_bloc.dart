import 'package:bharatnxt_app/domain/entities/pagination_entites.dart';
import 'package:bharatnxt_app/domain/entities/sugeestion_entities.dart';
import 'package:bharatnxt_app/domain/repository/suggestion_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'suggestion_event.dart';
part 'suggestion_state.dart';

class SuggestionsBloc extends Bloc<SuggestionsEvent, SuggestionsState> {
  final SuggestionsRepository _repository;
  int _currentPage = 1;
  static const int _limit = 10;

  SuggestionsBloc(this._repository) : super(const SuggestionsInitial()) {
    on<LoadSuggestionsEvent>(_onLoad);
    on<NextPageEvent>(_onNext);
    on<PreviousPageEvent>(_onPrevious);
    on<GoToPageEvent>(_onGoToPage);
  }

  Future<void> _onLoad(
    LoadSuggestionsEvent event,
    Emitter<SuggestionsState> emit,
  ) async {
    _currentPage = event.page;
    emit(SuggestionsLoading(page: _currentPage));
    try {
      final result = await _repository.getSuggestions(
        page: event.page,
        limit: event.limit,
      );
      emit(
        SuggestionsLoaded(
          suggestions: result.suggestions,
          pagination: result.pagination,
        ),
      );
    } catch (e) {
      emit(SuggestionsError(e.toString()));
    }
  }

  Future<void> _onNext(
    NextPageEvent event,
    Emitter<SuggestionsState> emit,
  ) async {
    final current = state;
    if (current is SuggestionsLoaded && current.pagination.hasNext) {
      add(LoadSuggestionsEvent(page: _currentPage + 1, limit: _limit));
    }
  }

  Future<void> _onPrevious(
    PreviousPageEvent event,
    Emitter<SuggestionsState> emit,
  ) async {
    final current = state;
    if (current is SuggestionsLoaded && current.pagination.hasPrevious) {
      add(LoadSuggestionsEvent(page: _currentPage - 1, limit: _limit));
    }
  }

  Future<void> _onGoToPage(
    GoToPageEvent event,
    Emitter<SuggestionsState> emit,
  ) async {
    add(LoadSuggestionsEvent(page: event.page, limit: _limit));
  }
}
