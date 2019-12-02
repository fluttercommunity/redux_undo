import 'package:meta/meta.dart';

/// Standard-Action for initiating the history
class UndoableInitAction {}

/// Standard-Action for undo
class UndoableUndoAction {}

/// Standard-Action for redo
class UndoableRedoAction {}

/// Standard-Action for jump (to past or to future)
class UndoableJumpAction {
  /// intiating the UndoableJumpAction
  UndoableJumpAction({
    @required this.index,
  });

  /// the index to jump to (can be positive or negative - future or past)
  final int index;
}

/// Standard-Action for clearing the history
class UndoableClearHistoryAction {}
