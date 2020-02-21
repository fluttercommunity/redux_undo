import 'package:meta/meta.dart';

/// The state containing past, present and future
class UndoableState<S> {
  /// initiating the class
  UndoableState({
    @required this.past,
    @required this.present,
    @required this.future,
    this.latestUnfiltered,
    this.index,
  })  : assert(past != null),
        assert(present != null),
        assert(future != null);

  /// either an empty List or filled with the past states
  /// filled when using normal actions or redoActions
  final List<S> past;

  /// the current state of the redux store
  final S present;

  /// either an empty List or filled with future states
  /// it gets filled when using undoActions
  final List<S> future;

  /// the latest unfiltered state of the redux store
  S latestUnfiltered;

  /// the current length of the past List
  int index;

  /// the size of the UndoableState (past.length + 1 (present) + future.length)
  int get getSize => past.length + 1 + future.length;

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
      'UndoableState: '
        'List<$S> past: $past, '
        '$S present: $present, '
        'List<$S> future: $future, '
        '$S latestUnfiltered: $latestUnfiltered, '
        'int index: $index';
}

/// A class for setting the config of the [UndoableReducer]
/// options that can be set with this include:
/// 1. limit:
///     limits the times you can undo a certain action ([UndoableState].past.length <= limit).
///     By limiting the length of [UndoableState].past the length of
///     [UndoableState].future is ultimately limited as well
///
///     Example:
///     ```dart
///       final config = UndoableConfig({limit: 100});
///     ```
///
/// 2. blackList:
///     A List of Types that, when dispatched, do not update the [UndoableState].past
///
///     Example:
///     ```dart
///       final config = UndoableConfig({
///         blackList: <Type>[
///           BlackListedType,
///         ]
///       });
///     ```
///
/// 3. whiteList:
///     A List of Types that need to be extended from [UndoableAction]:
///       - UndoableInitAction
///       - UndoableUndoAction
///       - UndoableRedoAction
///       - UndoableJumpAction
///       - UndoableClearHistoryAction
///
///     Example:
///     ```dart
///       class WhiteListedType extends UndoableRedoAction { ... }
///
///       final config = UndoableConfig({
///         whiteList: <Type>[
///           WhiteListedType,
///         ]
///       });
///     ```
class UndoableConfig {
  /// initiating the class
  /// default-values for the options are:
  /// - limit = 10
  /// - blackList = <Type>[]
  /// - whiteList = <UndoableAction>[]
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
