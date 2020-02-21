import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';
import 'package:test/test.dart';

import 'test_data.dart';

final UndoableConfig config = UndoableConfig(blackList: <Type>[
  BlacklistTestAction,
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

void main() {
  group('BlackList: ', () {
    test('is performed correctly', () {
      store.dispatch(BlacklistTestAction(value: updatedTitle));
      expect(store.state.present.counter, equals(0));
      expect(store.state.present.title, equals(updatedTitle));
    });

    test('past and future is not updated', () {
      expect(store.state.past.length, equals(0));
      expect(store.state.future.length, equals(0));
    });

    test('can neither be undone or redone', () {
      expect(store.state.canUndo, equals(false));
      expect(store.state.canRedo, equals(false));
    });
  });
}
