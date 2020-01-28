import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';
import 'package:redux_undo_example/components/home.dart';
import 'package:redux_undo_example/components/simple_counter.dart';

import 'redux/root_reducer.dart';
import 'redux/root_state.dart';
import 'redux/simple_counter/simple_counter_actions.dart';

void main() => runApp(MyApp());

final UndoableConfig config = UndoableConfig(
  whiteList: <Type>[
    CustomUndo,
  ],
);

/// redux_undo demo
class MyApp extends StatelessWidget {
  final Store<UndoableState> store = Store<UndoableState>(
    createUndoableReducer(rootReducer, config: config),
    initialState: createUndoableState(RootState.initial(), false),
  );

  final GlobalKey navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return StoreProvider<UndoableState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Redux Undo Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: navigatorKey,
        routes: <String, Widget Function(BuildContext)>{
          '/': (BuildContext context) {
            return const HomeScreenView(title: 'Welcome');
          },
          'simple_counter': (BuildContext context) {
            return const SimpleCounterView(title: 'Simple Counter');
          },
        },
      ),
    );
  }
}
