import 'package:redux/redux.dart';

import 'counter_actions.dart';

final Reducer<List<int>> counterReducer = combineReducers<List<int>>(<Reducer<List<int>>>[
  TypedReducer<List<int>, CounterIncrement>(_increment),
  TypedReducer<List<int>, CounterDecrement>(_decrement),
]);

List<int> _increment(List<int> state, CounterIncrement action) {
  final List<int> newState = List<int>.from(state);
  newState.replaceRange(action.index, action.index + 1, <int>[state[action.index] + 1]);
  return newState;
}

List<int> _decrement(List<int> state, CounterDecrement action) {
  final List<int> newState = List<int>.from(state);
  if (newState[action.index] == 0) return newState;
  newState.replaceRange(action.index, action.index + 1, <int>[state[action.index] - 1]);
  return newState;
}
