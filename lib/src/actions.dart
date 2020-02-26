import 'package:meta/meta.dart';

/// abstract class [UndoableAction] from which all other action classes inherit.
/// This makes it easier to check for a specific type in Lists, etc.
abstract class UndoableAction {}

/// Standard-Action for undo
class UndoableUndoAction extends UndoableAction {}

/// Standard-Action for redo
class UndoableRedoAction extends UndoableAction {}

/// Standard-Action for jump (to past or to future)
class UndoableJumpAction extends UndoableAction {
  /// intiating the UndoableJumpAction
  UndoableJumpAction({
    @required this.index,
  });

  /// the index to jump to (can be positive or negative - future or past)
  final int index;
}

/// Standard-Action for clearing the history
class UndoableClearHistoryAction extends UndoableAction {}
