import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';
import 'package:redux_undo/src/utils.dart';
import 'package:test/test.dart';

import 'test_data.dart';

// We create the State reducer by combining many smaller reducers into one!
TestState rootReducer(TestState state, dynamic action) {
  return TestState(
    counter: intReducer(state.counter, action),
    title: stringReducer(state.title, action),
  );
}

final Store<UndoableState<TestState>> store1 = Store<UndoableState<TestState>>(
  createUndoableReducer<TestState>(rootReducer),
  initialState: createUndoableState(TestState.initial(), true),
);

final Store<UndoableState<TestState>> store2 = Store<UndoableState<TestState>>(
  createUndoableReducer<TestState>(rootReducer),
  initialState: createUndoableState(TestState.initial(), false),
);

void main() {
  group('TestState: ', () {
    test('is initialized as UndoableState', () {
      expect(store1.state is UndoableState, equals(true));
      expect(store2.state is UndoableState, equals(true));
    });

    test('is sane', () {
      expect(isUndoableStateSane(store1.state), equals(true));
      expect(isUndoableStateSane(store2.state), equals(true));
    });

    test('present is  initialized as TestState', () {
      expect(store1.state.present is TestState, equals(true));
      expect(store2.state.present is TestState, equals(true));
    });

    test('latestUnfiltered is populated correctly if `ignoreInitialState === true`', () {
      expect(store1.state.latestUnfiltered == null, equals(true));
      expect(store2.state.latestUnfiltered is TestState, equals(true));
    });

    test('can neither be undone or redone', () {
      expect(store1.state.canUndo, equals(false));
      expect(store2.state.canUndo, equals(false));
      expect(store1.state.canRedo, equals(false));
      expect(store2.state.canRedo, equals(false));
    });

    test('past and future have length of 0', () {
      expect(store1.state.past.length, equals(0));
      expect(store2.state.past.length, equals(0));
      expect(store1.state.past.length, equals(0));
      expect(store2.state.past.length, equals(0));
    });

    test('initial values are correct', () {
      expect(store1.state.present.counter, equals(INITIAL_COUNTER));
      expect(store2.state.present.counter, equals(INITIAL_COUNTER));
      expect(store1.state.present.title, equals(INITIAL_TITLE));
      expect(store2.state.present.title, equals(INITIAL_TITLE));
    });

    test('index is given correctly', () {
      expect(store1.state.index, equals(0));
      expect(store2.state.index, equals(0));
    });

    test('lengthWithoutFuture is returning correct value', () {
      expect(lengthWithoutFuture(store1.state), equals(1));
      expect(lengthWithoutFuture(store2.state), equals(1));
    });

    test('size is calculated correctly', () {
      expect(store1.state.getSize, equals(1));
      expect(store2.state.getSize, equals(1));
    });

    test('toString method works as expected', () {
      final undoableStateString1 = 'UndoableState: List<TestState> past: [], TestState present: TestState: {counter: 0, title: initial Title}, List<TestState> future: [], TestState latestUnfiltered: null, int index: 0';
      final undoableStateString2 = 'UndoableState: List<TestState> past: [], TestState present: TestState: {counter: 0, title: initial Title}, List<TestState> future: [], TestState latestUnfiltered: TestState: {counter: 0, title: initial Title}, int index: 0';
      expect(store1.state.toString(), equals(undoableStateString1));
      expect(store2.state.toString(), equals(undoableStateString2));
    });
  });
}
