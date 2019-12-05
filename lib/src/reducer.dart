import 'package:redux/redux.dart';

import './actions.dart';
import './classes.dart';
import './utils.dart';

/// create a new history with this helper function which does makes importing the utils needless by desfault
UndoableState createUndoableState(dynamic initialState, bool ignoreInitialState) =>
    createHistory(initialState, ignoreInitialState: ignoreInitialState);

/// this is the core reducer that calls the given root reducer or skips it
/// depending on what action is provided and returns the new UndoableState
Reducer<UndoableState> createUndoableReducer(dynamic reducer, {UndoableConfig config}) {
  config ??= UndoableConfig();

  return (UndoableState state, dynamic action) {
    UndoableState history = state;

    if (history is! UndoableState) {
      final dynamic reducedState = reducer(state, UndoableInitAction());
      history = newHistory(<dynamic>[], reducedState, <dynamic>[]);
    }

    final bool isActionWhiteListed = config.whiteList.contains(action.runtimeType);

    UndoableState reduceAnyways(UndoableState res) {
      return isActionWhiteListed ? newHistory(res.past, reducer(res.present, action), res.future) : res;
    }

    /// handle all Undo-, Redo-, Jump- and ClearActions here
    if (action is UndoableUndoAction) {
      final UndoableState res = jump(history, -1);
      return reduceAnyways(res);
    } else if (action is UndoableRedoAction) {
      final UndoableState res = jump(history, 1);
      return reduceAnyways(res);
    } else if (action is UndoableJumpAction) {
      final UndoableState res = jump(history, action.index);
      return reduceAnyways(res);
    } else if (action is UndoableClearHistoryAction) {
      final UndoableState res = newHistory(<dynamic>[], history.present, <dynamic>[]);
      return reduceAnyways(res);
    }

    final bool isActionBlacklisted = config.blackList.contains(action.runtimeType);

    final dynamic reducedState = reducer(history.present, action);

    /// only update if the reduced state differs from the present state
    if (history.latestUnfiltered == reducedState) {
      return history;
    } else if (isActionBlacklisted) {
      return newHistory(history.past, reducedState, history.future);
    }

    history = insert(history, reducedState, config.limit);
    return history;
  };
}
