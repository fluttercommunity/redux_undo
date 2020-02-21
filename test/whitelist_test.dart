import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';
import 'package:test/test.dart';

import 'test_data.dart';

final UndoableConfig config = UndoableConfig(whiteList: <Type>[
  WhitelistTestAction,
]);

// We create the State reducer by combining many smaller reducers into one!
TestState rootReducer(TestState state, dynamic action) {
  return TestState(
    counter: intReducer(state.counter, action),
    title: stringReducer(state.title, action),
  );
}

final Store<UndoableState<TestState>> store = Store<UndoableState<TestState>>(
  createUndoableReducer<TestState>(rootReducer, config: config),
  initialState: createUndoableState(TestState.initial(), false),
);

final String updatedTitle = 'Updated Title';
final String whiteListActionTitle = 'WhitelistAction Title';

void main() {
  group('StringAction', () {
    test('is performed correctly', () {
      store.dispatch(StringTestAction(value: updatedTitle));
      expect(store.state.present.title, equals(updatedTitle));
      expect(store.state.present.counter, equals(INITIAL_COUNTER));
    });

    test('past has length of 1', () {
      expect(store.state.past.length, equals(1));
    });

    test('adds TestState instance to past', () {
      expect(store.state.past[0] is TestState, equals(true));
    });
  });

  group('IntAction', () {
    test('is performed correctly', () {
      store.dispatch(IncrementTestAction());
      expect(store.state.present.counter, equals(1));
      expect(store.state.present.title, equals(updatedTitle));
    });

    test('past has length of 2', () {
      expect(store.state.past.length, equals(2));
    });

    test('adds TestState instance to past', () {
      expect(store.state.past[1] is TestState, equals(true));
    });
  });

  group('WhitelistAction', () {
    test('is performed correctly', () {
      store.dispatch(WhitelistTestAction(value: whiteListActionTitle));
      expect(store.state.present.counter, equals(0));
      expect(store.state.present.title, equals(whiteListActionTitle));
    });

    test('past has length of 1', () {
      expect(store.state.past.length, equals(1));
    });

    test('future has length of 1', () {
      expect(store.state.future.length, equals(1));
    });
  });
}
