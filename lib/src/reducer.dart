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
    final isActionWhiteListed = config.whiteList.contains(action.runtimeType);

    UndoableState<S> reduceAnyways(UndoableState<S> res) {
      return isActionWhiteListed ? newHistory<S>(res.past, reducer(res.present, action), res.future) : res;
    }

    // handle all Undo-, Redo-, Jump- and ClearActions here
    if (action is UndoableUndoAction) {
      final res = jump<S>(state, -1);
      return reduceAnyways(res);
    } else if (action is UndoableRedoAction) {
      final res = jump(state, 1);
      return reduceAnyways(res);
    } else if (action is UndoableJumpAction) {
      final res = jump(state, action.index);
      return reduceAnyways(res);
    } else if (action is UndoableClearHistoryAction) {
      final res = newHistory(<S>[], state.present, <S>[]);
      return reduceAnyways(res);
    }

    final isActionBlacklisted = config.blackList.contains(action.runtimeType);

    final reducedState = reducer(state.present, action);

    // only update if the reduced state differs from the present state
    if (state.latestUnfiltered == reducedState) {
      return state;
    } else if (isActionBlacklisted) {
      return newHistory(state.past, reducedState, state.future);
    }

    state = insert(state, reducedState, config.limit);
    return state;
  };
}
