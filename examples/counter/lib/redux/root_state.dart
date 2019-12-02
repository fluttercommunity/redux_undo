import 'package:meta/meta.dart';

@immutable
class RootState {
  const RootState({
    this.counter,
  });

  factory RootState.initial() {
    return const RootState(
      counter: <int>[0, 0],
    );
  }

  final List<int> counter;

  RootState copyWith({
    List<int> counter,
  }) {
    return RootState(
      counter: <int>[
        counter[0] ?? this.counter[0],
        counter[1] ?? this.counter[1],
      ],
    );
  }

  @override
  int get hashCode => counter.hashCode;

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
      other is RootState &&
        runtimeType == other.runtimeType &&
        counter == other.counter;

  @override
  String toString() {
    return 'RootState: {counter: $counter}';
  }
}
