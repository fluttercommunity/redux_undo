import 'package:meta/meta.dart';
import 'package:redux_undo/redux_undo.dart';

/// Testing Variables
final int INITIAL_COUNTER = 0;
final String INITIAL_TITLE = 'initial Title';

/// Testing Reducer function
int intReducer(int state, dynamic action) {
  if (action is IncrementTestAction) {
    return state + 1;
  }

  if (action is DecrementTestAction) {
    return state - 1;
  }

  return state;
}

String stringReducer(String state, dynamic action) {
  if (action is StringTestAction) {
    return action.value;
  } else if (action is WhitelistTestAction) {
    return action.value;
  } else if (action is BlacklistTestAction) {
    return action.value;
  }

  return state;
}

/// Testing Actions
class IncrementTestAction {}

class DecrementTestAction {}

class StringTestAction {
  StringTestAction({
    @required this.value
  });

  // String value
  final String value;
}

class WhitelistTestAction extends UndoableUndoAction {
  WhitelistTestAction({
    @required this.value
  });

  // String value
  final String value;
}

class BlacklistTestAction {
  BlacklistTestAction({
    @required this.value
  });

  // String value
  final String value;
}

class CustomUndoAction extends UndoableUndoAction {}

/// Testing States
@immutable
class TestState {
  const TestState({
    this.counter,
    this.title,
  });

  factory TestState.initial() {
    return TestState(
      counter: INITIAL_COUNTER,
      title: INITIAL_TITLE,
    );
  }

  final int counter;
  final String title;

  TestState copyWith({
    int counter,
    String title,
  }) {
    return TestState(
      counter: counter ?? this.counter,
      title: title ?? this.title,
    );
  }

  @override
  int get hashCode => counter.hashCode ^ title.hashCode;

  @override
  bool operator ==(Object other) =>
    identical(this, other) || other is TestState && runtimeType == other.runtimeType && counter == other.counter && title == other.title;

  @override
  String toString() {
    return 'TestState: {counter: $counter, title: $title}';
  }
}