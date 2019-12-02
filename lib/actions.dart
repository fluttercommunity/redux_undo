import 'package:flutter/widgets.dart';

/// Standard-Action for initiating the history
class UndoableInitAction {}

/// Standard-Action for undo
class UndoableUndoAction {}

/// Standard-Action for redo
class UndoableRedoAction {}

/// Standard-Action for jump (to past or to future)
class UndoableJumpAction {
  UndoableJumpAction({
    @required this.index,
  });

  final int index;
}

/// Standard-Action for clearing the history
class UndoableClearHistoryAction {}
