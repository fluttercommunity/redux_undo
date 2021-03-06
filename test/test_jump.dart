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

final String updatedTitle = 'Updated Title';
final int jumpAmount = 4;

void main() {
  group('State preparation: ', () {
    test('update title String', () {
      store.dispatch(StringTestAction(value: updatedTitle));
      expect(store.state.present.title, equals(updatedTitle));
      expect(store.state.present.counter, equals(INITIAL_COUNTER));
    });

    test('update counter', () {
      for (var i = 0; i < jumpAmount; i++) {
        store.dispatch(IncrementTestAction());
      }

      expect(store.state.present.counter, equals(jumpAmount));
      expect(store.state.past.length, equals(jumpAmount + 1));
    });
  });

  group('JumpAction: ', () {
    test('correctly jumps to past state', () {
      store.dispatch(UndoableJumpAction(index: -jumpAmount));
      expect(store.state.present.counter, equals(0));
      expect(store.state.present.title, equals(updatedTitle));
    });

    test('past has length of 1', () {
      expect(store.state.past.length, equals(1));
    });

    test('future has length of 4', () {
      expect(store.state.future.length, equals(jumpAmount));
    });

    test('correctly returns old state if `index === 0`', () {
      store.dispatch(UndoableJumpAction(index: 0));
      expect(store.state.present.counter, equals(0));
      expect(store.state.present.title, equals(updatedTitle));
    });

    test('correctly jumps to future', () {
      store.dispatch(UndoableJumpAction(index: 2));
      expect(store.state.present.counter, equals(2));
      expect(store.state.present.title, equals(updatedTitle));
    });

    test('past has length of 3', () {
      expect(store.state.past.length, equals(3));
    });

    test('future has length of 2', () {
      expect(store.state.future.length, equals(2));
    });
  });
}