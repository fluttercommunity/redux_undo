import 'state_test.dart' as state_test;
import 'undo-redo_test.dart' as undo_redo_test;
import 'whitelist_test.dart' as whitelist_test;
import 'blacklist_test.dart' as blacklist_test;

void main() {
  state_test.main();
  undo_redo_test.main();
  whitelist_test.main();
  blacklist_test.main();
}