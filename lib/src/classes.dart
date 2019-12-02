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
  });

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
  int index;
  int size;

  @override
  String toString() =>
    'StateHistory: List<dynamic> past: ${past.toString()}, present: ${present.toString()}, List<dynamic> future: ${future.toString()}, latestUnfiltered: ${latestUnfiltered.toString()}';
}

/// A class for setting the config of the Undoable
class UndoConfig {
  /// initiating the class
  UndoConfig({
    this.limit = 10,
    this.blackList = const <Type>[],
  });

  /// limit the length of the past List
  /// defaultValue: 10
  int limit;
  /// blacklist certain Actions
  List<Type> blackList;
}