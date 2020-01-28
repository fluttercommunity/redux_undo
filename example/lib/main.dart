import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';

import 'redux/counter/counter_actions.dart';
import 'redux/root_reducer.dart';
import 'redux/root_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return StoreProvider<UndoableState>(
      store: store,
      child: MaterialApp(
        title: 'Redux Undo Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Redux Undo Demo'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<UndoableState, Store<UndoableState>>(
      converter: (Store<UndoableState> store) => store,
      builder: (BuildContext context, Store<UndoableState> store) {
        final int counter_1 = store.state.present.counter[0];
        final int counter_2 = store.state.present.counter[1];
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the first button this many times:',
                ),
                Text(
                  '$counter_1',
                  style: Theme.of(context).textTheme.display1,
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        print('### pressed +1');
                        store.dispatch(CounterIncrement(index: 0));
                      },
                      child: const Text('+1'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        store.dispatch(CounterDecrement(index: 0));
                      },
                      child: const Text('-1'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        print('### pressed undo');
                        store.dispatch(CustomUndo());
                      },
                      child: const Text('undo'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        store.dispatch(UndoableRedoAction());
                      },
                      child: const Text('redo'),
                    )
                  ],
                ),
                const Divider(
                  height: 120,
                ),
                const Text(
                  'You have pushed the second button this many times:',
                ),
                Text(
                  '$counter_2',
                  style: Theme.of(context).textTheme.display1,
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        store.dispatch(CounterIncrement(index: 1));
                      },
                      child: const Text('+1'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        store.dispatch(CounterDecrement(index: 1));
                      },
                      child: const Text('-1'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        store.dispatch(UndoableUndoAction());
                      },
                      child: const Text('undo'),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
