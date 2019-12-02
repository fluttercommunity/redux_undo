import 'package:redux/redux.dart';

import './actions.dart';
import './classes.dart';
import './utils.dart';

/// create a new history with this helper function which does makes importing the utils needless by desfault
UndoableState createUndoableState(dynamic initialState) => createHistory(initialState);

/// this is the core reducer that calls the given root reducer or skips it
/// depending on what action is provided and returns the new UndoableState
Reducer<UndoableState> createUndoableReducer(dynamic reducer, {UndoConfig config}) {
  config ??= UndoConfig();

  return (UndoableState state, dynamic action) {
    UndoableState history = state;

    if (history is! UndoableState) {
      final dynamic reducedState = reducer(state, UndoableInitAction());
      history = newHistory(<dynamic>[], reducedState, <dynamic>[]);
    }

    /// handle all Undo-, Redo-, Jump- and ClearActions here
    if (action is UndoableUndoAction) {
      final UndoableState reducedHistory = jump(history, -1);
      return reducedHistory;
    } else if (action is UndoableRedoAction) {
      final UndoableState reducedHistory = jump(history, 1);
      return reducedHistory;
    } else if (action is UndoableJumpAction) {
      final UndoableState reducedHistory = jump(history, action.index);
      return reducedHistory;
    } else if (action is UndoableClearHistoryAction) {
      return newHistory(<dynamic>[], history.present, <dynamic>[]);
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
