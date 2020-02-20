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
  group('TestState', () {
    test('is initialized as UndoableState', () {
      expect(store.state is UndoableState, equals(true));
    });

    test('present is  initialized as TestState', () {
      expect(store.state.present is TestState, equals(true));
    });

    test('can neither be undone or redone', () {
      expect(store.state.canUndo, equals(false));
      expect(store.state.canRedo, equals(false));
    });

    test('past and futurer have length of 0', () {
      expect(store.state.past.length, equals(0));
      expect(store.state.past.length, equals(0));
    });

    test('initial values are correct', () {
      expect(store.state.present.counter, equals(INITIAL_COUNTER));
      expect(store.state.present.title, equals(INITIAL_TITLE));
    });
  });
}