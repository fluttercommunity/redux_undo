# redux_undo.dart

This package will make your redux store undoable.

## READ THIS FIRST
> :warning:
> 
> **The package as it is now is still in Beta phase. So you are free to use it as is, but please keep in mind that, until version 1.0.0 is released all class, function and helper-names are prone to change.** 

## Installation

define the dependency in your `pubspec.yaml` file:
```yaml
dependencies:
  redux_undo: ^0.1.0+4
```

update your applications packages by running
```shell
pub get
```

or when using flutter as a framework
```shell
flutter pub get
```

import the package to use in the file you are setting up redux:
```dart
import 'package:redux_undo/redux_undo.dart';
```

## Structure

`redux_undo` will slightly modify your state by adding a new properties-layer at the root of the store. The final structure will look like this:
```dart
/// when accessed directly from the store, store.state will have this structure
UndoableHistory state = {
  past: <dynamic>[],
  present: null, // <-- the current state of the app
  future: <dynamic>[],
  latestUnfiltered: null// <-- basically equals present, to store a mutual state before storing it into past or future 
};
```

## Usage

Because it modifies the initial state you need to initiate `redux_undo` when initiating the redux store.
This is done by calling 2 separate functions:

```dart
/// to wrap the root reducer
Reducer<UndoableState> createUndoableReducer(Function<Reducer> reducer);

/// to wrap the Root state of your app.
UndoableState createUndoableState(dynamic state);
```


Here is an example of how this can be done in a flutter app:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final Store<UndoableState> store = Store<UndoableState>(
    createUndoableReducer(rootReducer),
    initialState: createUndoableState(RootState.initial()),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider<UndoableState>(
      store: store,
      child: MaterialApp(
        title: 'Redux Undo Demo',
        home: const MyHomePage(),
      ),
    );
  }
}
```

## Contributors

  * [Michel Engelen](https://github.com/michelengelen)