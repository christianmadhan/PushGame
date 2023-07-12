import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'push_game_bloc_event.dart';
part 'push_game_bloc_state.dart';

class PushGameBlocBloc extends Bloc<PushGameBlocEvent, PushGameBlocState> {
  PushGameBlocBloc() : super(PushGameBlocInitial()) {
    on<StartGame>(_onStartGame);
}
  FutureOr<void> _onStartGame(StartGame event, Emitter<PushGameBlocState> emit) {
    
  } 

}