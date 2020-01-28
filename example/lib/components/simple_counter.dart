import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';
import 'package:redux_undo_example/components/wrapper.dart';
import 'package:redux_undo_example/redux/simple_counter/simple_counter_actions.dart';

class SimpleCounter extends StatelessWidget {
  const SimpleCounter();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<UndoableState, Store<UndoableState>>(
      converter: (Store<UndoableState> store) => store,
      builder: (BuildContext context, Store<UndoableState> store) {
        final int counter_1 = store.state.present.counter[0];
        final int counter_2 = store.state.present.counter[1];
        return Center(
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
                    onPressed: store.state.canUndo
                        ? () {
                            store.dispatch(CustomUndo());
                          }
                        : null,
                    child: const Text('undo'),
                  ),
                  RaisedButton(
                    onPressed: store.state.canRedo
                        ? () {
                            store.dispatch(UndoableRedoAction());
                          }
                        : null,
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
        );
      },
    );
  }
}

class SimpleCounterView extends StatelessWidget {
  const SimpleCounterView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Wrapper(title: title, child: const SimpleCounter());
  }
}
