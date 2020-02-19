import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';

int reducer(int state, dynamic action) {
  if (action is IncrementTestAction) {
    return state + 1;
  }

  if (action is DecrementTestAction) {
    return state - 1;
  }

  return state;
}

class IntReducer extends ReducerClass<int> {
  @override
  int call(int state, dynamic action) => reducer(state, action);
}

class IncrementTestAction {}

class DecrementTestAction {}

class CustomUndoAction extends UndoableUndoAction {}