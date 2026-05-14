import 'package:flutter_bloc/flutter_bloc.dart';
import '../data_board.dart';
import '../services/api_client.dart';

sealed class BoardEvent {}

final class LoadBoard extends BoardEvent {}

sealed class BoardState {
  final String? error;
  final DataBoard? board;

  const BoardState({this.error, this.board});
}

final class BoardInitial extends BoardState {
  const BoardInitial();
}

final class BoardLoading extends BoardState {
  const BoardLoading();
}

final class BoardLoaded extends BoardState {
  const BoardLoaded(DataBoard b) : super(board: b);
}

final class BoardError extends BoardState {
  const BoardError(String e) : super(error: e);
}

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final ApiClient _api;

  BoardBloc({ApiClient? api})
      : _api = api ?? ApiClient(),
        super(const BoardInitial()) {
    on<LoadBoard>(_onLoad);
  }

  Future<void> _onLoad(LoadBoard event, Emitter<BoardState> emit) async {
    emit(const BoardLoading());
    try {
      final tasks = await _api.fetchTasks();
      if (tasks.isEmpty) {
        emit(BoardLoaded(const DataBoard(tasks: [])));
      } else {
        emit(BoardLoaded(DataBoard(tasks: tasks)));
      }
    } catch (e) {
      emit(BoardError(e.toString()));
    }
  }
}
