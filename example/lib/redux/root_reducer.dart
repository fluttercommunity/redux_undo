import 'root_state.dart';
import 'simple_counter/simple_counter_reducer.dart';

// We create the State reducer by combining many smaller reducers into one!
RootState rootReducer(RootState state, dynamic action) {
  return RootState(
    counter: counterReducer(state.counter, action),
  );
}
