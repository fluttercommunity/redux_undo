import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';
import 'package:test/test.dart';

import 'test_data.dart';

final int historyLimit = 5;
final UndoableConfig config = UndoableConfig(limit: historyLimit);

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
  group('State preparation: ', () {
    test('past is filled to a max of $historyLimit', () {
      for (var i = 0; i < historyLimit; i++) {
        store.dispatch(IncrementTestAction());
      }

      expect(store.state.present.counter, equals(historyLimit));
      expect(store.state.present.title, equals(INITIAL_TITLE));
    });
  });

  group('Limit: ', () {
    test('past has length of ${historyLimit}', () {
      expect(store.state.past.length, equals(historyLimit));
    });

    test('future has length of 0', () {
      expect(store.state.future.length, equals(0));
    });

    test('oldest entry in past has a value of $INITIAL_COUNTER', () {
      expect(store.state.past[0].counter, equals(INITIAL_COUNTER));
    });

    test('additional state changes are added to past', () {
      store.dispatch(IncrementTestAction());
      expect(store.state.present.counter, equals(historyLimit + 1));
      expect(store.state.present.title, equals(INITIAL_TITLE));
    });

    test('past still has length of ${historyLimit}', () {
      expect(store.state.past.length, equals(historyLimit));
    });

    test('oldest entry in past now has a value of ${INITIAL_COUNTER + 1}', () {
      expect(store.state.past[0].counter, equals(INITIAL_COUNTER + 1));
    });
  });
}
