import 'package:redux/redux.dart';

import './actions.dart';
import './classes.dart';
import './utils.dart';

/// create a new [UndoableState] with this helper function which does make importing the utils needless by default
UndoableState<S> createUndoableState<S>(S initialState, bool ignoreInitialState) =>
    createHistory(initialState, ignoreInitialState: ignoreInitialState);

/// this is the core reducer that calls the given root reducer or skips it
/// depending on what action is provided and returns the new [UndoableState]
Reducer<UndoableState<S>> createUndoableReducer<S>(Reducer<S> reducer, {UndoableConfig config}) {
  config ??= UndoableConfig();

  return (UndoableState<S> state, dynamic action) {
    UndoableState<S> history;

    // first check if the passed state is [UndoableState]: If not
    if (state is! UndoableState<S>) {
      final S reducedState = reducer(state as S, UndoableInitAction());
      history = newHistory<S>(<S>[], reducedState, <S>[]);
    } else {
      history = state;
    }

    final bool isActionWhiteListed = config.whiteList.contains(action.runtimeType);

    UndoableState<S> reduceAnyways(UndoableState<S> res) {
      return isActionWhiteListed ? newHistory<S>(res.past, reducer(res.present, action), res.future) : res;
    }

    // handle all Undo-, Redo-, Jump- and ClearActions here
    if (action is UndoableUndoAction) {
      final UndoableState<S> res = jump<S>(history, -1);
      return reduceAnyways(res);
    } else if (action is UndoableRedoAction) {
      final UndoableState<S> res = jump(history, 1);
      return reduceAnyways(res);
    } else if (action is UndoableJumpAction) {
      final UndoableState<S> res = jump(history, action.index);
      return reduceAnyways(res);
    } else if (action is UndoableClearHistoryAction) {
      final UndoableState<S> res = newHistory(<S>[], history.present, <S>[]);
      return reduceAnyways(res);
    }

    final bool isActionBlacklisted = config.blackList.contains(action.runtimeType);

    final S reducedState = reducer(history.present, action);

    // only update if the reduced state differs from the present state
    if (history.latestUnfiltered == reducedState) {
      return history;
    } else if (isActionBlacklisted) {
      return newHistory(history.past, reducedState, history.future);
    }

    history = insert(history, reducedState, config.limit);

    return history;
  };
}
