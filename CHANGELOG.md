# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- support for string-based actions
- possibility to only make a part of the state undoable
- more examples and documentation

## [0.1.1+5] - 2020-02-27
### Changed
- Moved package to Flutter Community

## [0.1.1+4] - 2020-02-26
### Added
- added abstract class `UndoableAction` which every pre-built action from `redux_undo` extends
- added the `getSize` getter to `UndoableState`
- added tests for complete code coverage
### Changed
- updated README
### Removed
- removed `UndoableInitAction` since the use-case does not exist anymore
- removed the `size` member from `UndoableState`

## [0.1.1+3] - 2020-01-29
### Added
- added generic types to the `UndoableState` class and helper functions
### Fixed
- fixed a navigation-bug in the example
### Changed
- updated dependency version

## [0.1.1+2] - 2020-01-29
### Changed
- updated dependency version

## [0.1.1+1] - 2019-12-02
### Added
- added new boolean getters to the `UndoableState` class: `canUndo` and `canRedo`
- added the support for multiple screens in the example to showcase different use-cases in the future
### Changed
- reformatted some files with dartfrmt

## [0.1.0+3] - 2019-12-02
### Added
- added a new helper function `UndoableState createUndoableState(dynamic state)` to initiate the UndoableState on init
### Changed
- renamed `undoableReducer` to `Reducer<UndoableState> createUndoableReducer(dynamic reducer, { UndoConfig config })` to keep naming consistent
- reformatted some files with dartfrmt

## [0.1.0+2] - 2019-12-02
### Added
- added a bit of documentation
### Changed
- reformatted some files with dartfrmt

## [0.1.0+1] - 2019-12-02
### Added
- Initial release version