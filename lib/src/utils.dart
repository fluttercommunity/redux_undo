import './classes.dart';

/// helper for not mutating current [UndoableState], instead returning a new one
UndoableState<S> newHistory<S>(List<S> past, S present, List<S> future) {
  return UndoableState<S>(
    past: past,
    present: present,
    future: future,
    latestUnfiltered: present,
    index: past.length,
    size: past.length + future.length + 1,
  );
}

/// create a new [UndoableState]
UndoableState<S> createHistory<S>(S state, {bool ignoreInitialState = false}) {
  final history = newHistory(<S>[], state, <S>[]);

  if (ignoreInitialState) {
    history.latestUnfiltered = null;
  }

  return history;
}

/// isUndoableStateSane helper: check for a valid [UndoableState]
bool isUndoableStateSane(UndoableState history) {
  return history is UndoableState &&
      history.present != null &&
      history.future != null &&
      history.past != null &&
      history.future is List &&
      history.past is List;
}

/// lengthWithoutFuture: get length of [UndoableState]
int lengthWithoutFuture(UndoableState history) {
  return history.index + 1;
}

/// name says it all
UndoableState<S> jumpToPast<S>(UndoableState<S> history, int index) {
  if (index < 0 || index >= history.index) return history;

  final past = history.past;
  final future = history.future;
  final present = history.present;

  final newPast = past.sublist(0, index);
  final newPresent = past[index];
  final newFuture = List<S>.from(past.sublist(index + 1))
    ..add(present)
    ..addAll(future);

  return newHistory<S>(newPast, newPresent, newFuture);
}

/// name says it all
UndoableState<S> jumpToFuture<S>(UndoableState<S> history, int index) {
  if (index < 0 || index >= history.future.length) return history;

  final past = history.past;
  final future = history.future;
  final present = history.present;

  final newPast = List<S>.from(past)
    ..add(present)
    ..addAll(future.sublist(0, index));
  final newPresent = future[index];
  final newFuture = future.sublist(index + 1);

  return newHistory<S>(newPast, newPresent, newFuture);
}

/// jump to a certain index in the past or future
UndoableState<S> jump<S>(UndoableState<S> history, int index) {
  if (index > 0) return jumpToFuture<S>(history, index - 1);
  if (index < 0) return jumpToPast<S>(history, history.index + index);
  return history;
}

/// insert: insert `state` into history, which means adding the current state
///         into `past`, setting the new `state` as `present` and erasing
///         the `future`.
UndoableState<S> insert<S>(UndoableState<S> history, S state, int limit) {
  final past = history.past;
  final latestUnfiltered = history.latestUnfiltered;

  final historyOverflow = limit > 0 && lengthWithoutFuture(history) >= limit;

  final pastSliced = past.sublist(historyOverflow ? 1 : 0);
  final newPast = List<S>.from(pastSliced);

  if (latestUnfiltered != null) {
    newPast..add(latestUnfiltered);
  }

  return newHistory<S>(newPast, state, <S>[]);
}
