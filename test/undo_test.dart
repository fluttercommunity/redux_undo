import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';
import 'package:test/test.dart';

import 'test_data.dart';

final UndoableConfig config = UndoableConfig(
  whiteList: <Type>[],
);

final Store<UndoableState<int>> store = Store<UndoableState<int>>(
  createUndoableReducer<int>(IntReducer(), config: config),
  initialState: createUndoableState(0, false),
);

void main() {
  group('State', () {
    test('present is incremented by 1', () {
      store.dispatch(IncrementTestAction());
      expect(store.state.present, equals(1));
    });

    test('past has length of 1', () {
      expect(store.state.past.length, equals(1));
    });

    test('present is decremented by 1', () {
      store.dispatch(DecrementTestAction());
      expect(store.state.present, equals(0));
    });

    test('past has length of 2', () {
      expect(store.state.past.length, equals(2));
    });
  });

  group('Undo', () {
    test('is possible', () {
      expect(store.state.canUndo, equals(true));
    });

    test('is performed', () {
      store.dispatch(UndoableUndoAction());
      expect(store.state.present, equals(1));
    });

    test('past has length of 1', () {
      expect(store.state.past.length, equals(1));
    });

    test('future has length of 1', () {
      expect(store.state.future.length, equals(1));
    });
  });
}