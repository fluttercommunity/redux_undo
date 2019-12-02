import './classes.dart';

/// helper for not mutating current state, but returning a new one
UndoableState newHistory(List<dynamic> past, dynamic present, List<dynamic> future) {
  return UndoableState(
    past: past,
    present: present,
    future: future,
    latestUnfiltered: present,
    index: past.length,
    size: past.length + future.length + 1,
  );
}

/// create a new history
UndoableState createHistory(dynamic state, {bool ignoreInitialState = false}) {
  final UndoableState history = newHistory(<dynamic>[], state, <dynamic>[]);
  if (ignoreInitialState) {
    history.latestUnfiltered = null;
  }
  return history;
}

/// isHistory helper: check for a valid history object
bool isHistory(UndoableState history) {
  return history is UndoableState &&
    history.present != null &&
    history.future != null &&
    history.past != null &&
    history.future is List &&
    history.past is List;
}

/// lengthWithoutFuture: get length of history
int lengthWithoutFuture(UndoableState history) {
  return history.past.length + 1;
}

/// name says it all
UndoableState jumpToPast(UndoableState history, int index) {
  if (index < 0 || index >= history.past.length) return history;

  final List<dynamic> past = history.past;
  final List<dynamic> future = history.future;
  final dynamic present = history.present;

  final List<dynamic> newPast = past.sublist(0, index);
  final dynamic newPresent = past[index];
  final List<dynamic> newFuture = List<dynamic>.from(past.sublist(index + 1))
    ..add(present)
    ..addAll(future);

  return newHistory(newPast, newPresent, newFuture);
}

/// name says it all
UndoableState jumpToFuture(UndoableState history, int index) {
  if (index < 0 || index >= history.future.length) return history;

  final List<dynamic> past = history.past;
  final List<dynamic> future = history.future;
  final dynamic present = history.present;

  final List<dynamic> newPast = List<dynamic>.from(past)
    ..add(present)
    ..addAll(future.sublist(0, index));
  final dynamic newPresent = future[index];
  final List<dynamic> newFuture = future.sublist(index + 1);

  return newHistory(newPast, newPresent, newFuture);
}

/// jump to a certain index in the past or future
UndoableState jump(UndoableState history, int index) {
  if (index > 0) return jumpToFuture(history, index - 1);
  if (index < 0) return jumpToPast(history, history.past.length + index);
  return history;
}

/// insert: insert `state` into history, which means adding the current state
///         into `past`, setting the new `state` as `present` and erasing
///         the `future`.
UndoableState insert(UndoableState history, dynamic state, int limit) {
  final List<dynamic> past = history.past;
  final dynamic latestUnfiltered = history.latestUnfiltered;

  final bool historyOverflow = limit > 0 && lengthWithoutFuture(history) >= limit;

  final List<dynamic> pastSliced = past.sublist(historyOverflow ? 1 : 0);
  final List<dynamic> newPast = List<dynamic>.from(pastSliced);

  if (latestUnfiltered != null) {
    newPast..add(latestUnfiltered);
  }

  return newHistory(newPast, state, <dynamic>[]);
}