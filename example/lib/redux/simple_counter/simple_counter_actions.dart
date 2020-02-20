import 'package:flutter/widgets.dart';
import 'package:redux_undo/redux_undo.dart';

/// [CounterIncrement] action class
/// increments the counter at the given index
class CounterIncrement {
  CounterIncrement({
    @required this.index,
  });

  // index of the counter that should be incremented
  final int index;
}

/// [CounterDecrement] action class
/// decrements the counter at the given index
class CounterDecrement {
  CounterDecrement({
    @required this.index,
  });

  // index of the counter that should be decremented
  final int index;
}

class CustomUndo extends UndoableUndoAction {}
