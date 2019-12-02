/// The state containing past, present and future
class UndoableState {
  UndoableState({
    this.past,
    this.present,
    this.future,
    this.latestUnfiltered,
    this.index,
    this.size,
  });

  final List<dynamic> past;
  final dynamic present;
  final List<dynamic> future;
  dynamic latestUnfiltered;
  int index;
  int size;

  @override
  String toString() =>
    'StateHistory: List<dynamic> past: ${past.toString()}, present: ${present.toString()}, List<dynamic> future: ${future.toString()}, latestUnfiltered: ${latestUnfiltered.toString()}';
}

class UndoConfig {
  UndoConfig({
    this.limit = 10,
    this.blackList = const <Type>[],
  });

  int limit;
  List<Type> blackList;
}