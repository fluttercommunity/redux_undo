import 'package:meta/meta.dart';

/// The state containing past, present and future
class UndoableState {
  /// initiating the class
  UndoableState({
    @required this.past,
    @required this.present,
    @required this.future,
    this.latestUnfiltered,
    this.index,
    this.size,
  })  : assert(past != null),
        assert(present != null),
        assert(future != null);

  /// either an empty List or filled with the past states
  /// filled when using normal actions or redoActions
  final List<dynamic> past;

  /// the current state of the redux store
  final dynamic present;

  /// either an empty List or filled with future states
  /// it gets filled when using undoActions
  final List<dynamic> future;

  /// the latest unfiltered state of the redux store
  dynamic latestUnfiltered;

  /// the current length of the past List
  int index;

  /// the size of the UndoableState (past.length + 1 (present) + future.length)
  int size;

  /// Lets you check if the [UndoableState] is able to undo (past has items in it)
  /// This is especially handy when you want to disable the undo button or want to show some other kind of indication
  ///
  /// Example:
  /// ```dart
  /// RaisedButton(
  ///   onPressed: store.state.canUndo ? () {
  ///     store.dispatch(UndoableUndoAction());
  ///   } : null,
  ///   child: const Text('undo'),
  /// ),
  /// ```
  bool get canUndo => past.isNotEmpty;

  /// Lets you check if the [UndoableState] is able to redo (future has items in it)
  /// This is especially handy when you want to disable the redo button or want to show some other kind of indication
  ///
  /// Example:
  /// ```dart
  /// RaisedButton(
  ///   onPressed: store.state.canRedo ? () {
  ///     store.dispatch(UndoableRedoAction());
  ///   } : null,
  ///   child: const Text('redo'),
  /// ),
  /// ```
  bool get canRedo => future.isNotEmpty;

  @override
  String toString() =>
      'StateHistory: List<dynamic> past: ${past.toString()}, present: ${present.toString()}, List<dynamic> future: ${future.toString()}, latestUnfiltered: ${latestUnfiltered.toString()}';
}

/// A class for setting the config of the UndoableReducer
class UndoableConfig {
  /// initiating the class
  UndoableConfig({
    this.limit = 10,
    this.blackList = const <Type>[],
    this.whiteList = const <Type>[],
  });

  /// limit the length of the past List
  /// defaultValue: 10
  int limit;

  /// blacklist certain Actions
  List<Type> blackList;

  /// whiteList certain Actions
  List<Type> whiteList;
}
