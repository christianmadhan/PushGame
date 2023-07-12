part of 'push_game_bloc_bloc.dart';

@immutable
abstract class PushGameBlocEvent {}


class StartGame extends PushGameBlocEvent {

}

class StopGame extends PushGameBlocEvent {
  
}

