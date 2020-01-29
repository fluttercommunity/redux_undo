## 0.1.1+2
#### Updates
- updated dependency version

## 0.1.1+1
#### Critical Fix
- added new boolean getters to the `UndoableState` class: `canUndo` and `canRedo`
#### Updates
- reformatted some files with dartfrmt
- added the support for multiple screens to the example to showcase different use-cases in the future

## 0.1.0+3
#### Critical Fix
- added a new helper function `UndoableState createUndoableState(dynamic state)` to initiate the UndoableState on init
- renamed `undoableReducer` to `Reducer<UndoableState> createUndoableReducer(dynamic reducer, { UndoConfig config })` to keep naming consistent
#### Updates
- reformatted some files with dartfrmt

## 0.1.0+2
- reformatted some files with dartfrmt
- added a bit of documentation

## 0.1.0+1
- Initial version