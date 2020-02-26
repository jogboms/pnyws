import 'package:pnyws/state/app_state.dart';
import 'package:rxdart/subjects.dart';

typedef Reducer = AppState Function(AppState state);

class StateMachine {
  StateMachine({
    this.initialState = const AppState(),
  }) : _controller = BehaviorSubject<AppState>.seeded(initialState);

  final BehaviorSubject<AppState> _controller;
  final AppState initialState;

  Stream<AppState> get stream => _controller.stream;

  void add(Reducer reducer) => _controller.add(reducer(_controller.value));
}
