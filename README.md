[![Flutter Community: redux_undo](https://fluttercommunity.dev/_github/header/redux_undo)](https://github.com/fluttercommunity/community)

[![Build Status](https://travis-ci.com/michelengelen/redux_undo.svg?branch=master)](https://travis-ci.com/michelengelen/redux_undo)
[![codecov](https://codecov.io/gh/michelengelen/redux_undo/branch/master/graph/badge.svg)](https://codecov.io/gh/michelengelen/redux_undo)
[![pub package](https://img.shields.io/pub/v/redux_undo.svg)](https://pub.dartlang.org/packages/redux_undo)

# redux_undo.dart

This package will make your redux store undoable.

## READ THIS FIRST
> :warning:
> 
> **The package as it is now is still in Beta phase. So you are free to use it as is, but please keep in mind that, until version 1.0.0 is released all class, function and helper-names are prone to change.** 

## Things to come in the future
- [ ] Support for string based actions (currently supported are only class-based actions)
- [ ] Support for making only a slice of the state undoable
- [ ] more examples and documentation

## Installation

define the dependency in your `pubspec.yaml` file:
```yaml
dependencies:
  redux_undo: ^0.1.1+5
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
UndoableHistory<S> state = {
  past: <S>[],
  present: null, // <-- the current state of the app
  future: <S>[],
  latestUnfiltered: null // <-- basically equals present, to store a mutual state before storing it into past or future 
};
```

## Usage

Because it modifies the initial state you need to initiate `redux_undo` when initiating the redux store.
This is done by calling 2 separate functions:

```dart
/// to wrap the root reducer
Reducer<UndoableState<S>> createUndoableReducer<S>(Reducer<S> reducer, { UndoableConfig config });

/// to wrap the Root state of your app.
UndoableState<S> createUndoableState<S>(S initialState, bool ignoreInitialState);
```

Here is an example of how this can be done in a flutter app:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_undo/redux_undo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final Store<UndoableState<RootState>> store = Store<UndoableState<RootState>>(
    createUndoableReducer<RootState>(rootReducer),
    initialState: createUndoableState(RootState.initial(), false),
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider<UndoableState<RootState>>(
      store: store,
      child: MaterialApp(
        title: 'Redux Undo Demo',
        home: const MyHomePage(),
      ),
    );
  }
}
```

## Actions

`redux_undo` provides 4 basic actions

- `UndoableUndoAction` - Standard-Action for undo
    
    **Usage:** `store.dispatch(UndoableUndoAction())`
- `UndoableRedoAction` - Standard-Action for redo
    
    **Usage:** `store.dispatch(UndoableRedoAction())`
- `UndoableJumpAction` - Standard-Action for jump (to past or to future)
    
    **Usage:** `store.dispatch(UndoableJumpAction(index: -2))` // <- jumps 2 steps to the past (same as dispatching `UndoableUndoAction` twice)
    
    **Usage:** `store.dispatch(UndoableJumpAction(index: 0))` // <- does nothing, since it just returns the current `UndoableState`
    
    **Usage:** `store.dispatch(UndoableJumpAction(index: 2))` // <- jumps 2 steps to the future (same as dispatching `UndoableRedoAction` twice)

- `UndoableClearHistoryAction` - Standard-Action for clearing the history

## Options

It is possible to provide a configuration object to the UndoableState instantiation like this:
```dart
final UndoableConfig config = UndoableConfig(
  limit: 100,
  blackList: <Type>[
    BlacklistedAction,
  ],
  whiteList: <Type>[
    WhitelistedAction,
  ],
);
```

Then pass it to the `createUndoableReducer` function like this:
```dart
final Store<UndoableState<RootState>> store = Store<UndoableState<RootState>>(
    createUndoableReducer<RootState>(rootReducer, config: config),
    initialState: createUndoableState(RootState.initial(), false),
);
```
These are the options the `UndoableConfig` class provides:
- int limit: limits the length of the `UndoableState.past` List and with this ultimately the length of `UndoableState.future` as well
    - default value => **10**
- List<Type> whiteList: actions in this list need to be extended from one of the provided `redux_undo` actions and will fire the original `rootReducer` after performing the action they extended from without updating `UndoableState.past` or `UndoableState.future`  

## Contributors

  * [Michel Engelen](https://github.com/michelengelen)