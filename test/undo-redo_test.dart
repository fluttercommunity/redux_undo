import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';
import 'package:test/test.dart';

import 'test_data.dart';

// We create the State reducer by combining many smaller reducers into one!
TestState rootReducer(TestState state, dynamic action) {
  return TestState(
    counter: intReducer(state.counter, action),
    title: stringReducer(state.title, action),
  );
}

final Store<UndoableState<TestState>> store = Store<UndoableState<TestState>>(
  createUndoableReducer<TestState>(rootReducer),
  initialState: createUndoableState(TestState.initial(), false),
);

void main() {
  group('UndoableState', () {
    test('present is incremented by 1', () {
      store.dispatch(IncrementTestAction());
      expect(store.state.present.counter, equals(1));
      expect(store.state.present.title, equals(INITIAL_TITLE));
    });

    test('past has length of 1', () {
      expect(store.state.past.length, equals(1));
    });

    test('present.counter is decremented by 1', () {
      store.dispatch(DecrementTestAction());
      expect(store.state.present.counter, equals(INITIAL_COUNTER));
    });

    test('past has length of 2', () {
      expect(store.state.past.length, equals(2));
    });

    test('future has length of 0', () {
      expect(store.state.future.length, equals(0));
    });
  });

  group('UndoableUndoAction', () {
    test('is possible', () {
      expect(store.state.canUndo, equals(true));
    });

    test('is performed', () {
      store.dispatch(UndoableUndoAction());
      expect(store.state.present.counter, equals(1));
      expect(store.state.present.title, equals(INITIAL_TITLE));
    });

    test('past and future have length of 1', () {
      expect(store.state.past.length, equals(1));
      expect(store.state.future.length, equals(1));
    });

    test('is performed again', () {
      store.dispatch(UndoableUndoAction());
      expect(store.state.present.counter, equals(INITIAL_COUNTER));
      expect(store.state.present.title, equals(INITIAL_TITLE));
    });

    test('past has length of 0', () {
      expect(store.state.past.length, equals(0));
    });

    test('future has length of 2', () {
      expect(store.state.future.length, equals(2));
    });

    test('is not possible anymore', () {
      expect(store.state.canUndo, equals(false));
    });
  });

  group('UndoableRedoAction', () {
    test('is possible', () {
      expect(store.state.canRedo, equals(true));
    });

    test('is performed', () {
      store.dispatch(UndoableRedoAction());
      expect(store.state.present.counter, equals(1));
    });

    test('past and future have length of 1', () {
      expect(store.state.past.length, equals(1));
      expect(store.state.future.length, equals(1));
    });

    test('is performed', () {
      store.dispatch(UndoableRedoAction());
      expect(store.state.present.counter, equals(INITIAL_COUNTER));
    });

    test('past has length of 2', () {
      expect(store.state.past.length, equals(2));
    });

    test('future has length of 0', () {
      expect(store.state.future.length, equals(0));
    });

    test('is not possible anymore', () {
      expect(store.state.canRedo, equals(false));
    });
  });
}