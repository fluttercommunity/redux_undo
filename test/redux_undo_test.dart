import 'test_blacklist.dart' as test_blacklist;
import 'test_clear-history.dart' as test_clear_history;
import 'test_jump.dart' as test_jump;
import 'test_limit.dart' as test_limit;
import 'test_state.dart' as test_state;
import 'test_undo-redo.dart' as test_undo_redo;
import 'test_whitelist.dart' as test_whitelist;

void main() {
  test_blacklist.main();
  test_jump.main();
  test_limit.main();
  test_state.main();
  test_undo_redo.main();
  test_clear_history.main();
  test_whitelist.main();
}
