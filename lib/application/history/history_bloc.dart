import 'package:bharatnxt_app/domain/entities/chat_message_entities.dart';
import 'package:bharatnxt_app/domain/repository/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final ChatRepository _repository;

  HistoryBloc(this._repository) : super(const HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    try {
      final messages = await _repository.getChatHistory();
      emit(HistoryLoaded(messages));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
