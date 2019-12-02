import 'counter/counter_reducer.dart';
import 'root_state.dart';

// We create the State reducer by combining many smaller reducers into one!
RootState rootReducer(RootState state, dynamic action) {
  return RootState(
    counter: counterReducer(state.counter, action),
  );
}
