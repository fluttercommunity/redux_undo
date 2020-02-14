import 'package:flutter/widgets.dart';
import 'package:redux_undo/redux_undo.dart';

/// Counter actions

class CounterIncrement {
  CounterIncrement({
    @required this.index,
  });

  final int index;
}

class CounterDecrement {
  CounterDecrement({
    @required this.index,
  });

  final int index;
}

class CustomUndo extends UndoableUndoAction {}
