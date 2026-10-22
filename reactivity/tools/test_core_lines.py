import pathlib
import os
import unittest
from unittest import mock

import core_lines


class CoreLinesTests(unittest.TestCase):
    def test_test_removal_preserves_shared_unicode_lines_and_line_endings(self):
        text = '#[test] fn café() {} fn production() {}\r\n\n#[cfg(test)]\nfn check() {\n  let _ = "雪";\n}\n'
        removed = core_lines.without_tests(text, [[1, 0, 1, 20], [3, 0, 6, 1]])
        self.assertEqual(removed.splitlines()[0].strip(), "fn production() {}")
        self.assertTrue(removed.startswith(" " * 20 + " fn production() {}\r\n"))
        self.assertEqual(text.count("\n"), removed.count("\n"))
        self.assertNotIn("check", removed)
        self.assertNotIn("雪", removed)

    @unittest.skipUnless(os.environ.get("INVENTORY_RUST_HELPER") and os.environ.get("TOKEI"),
                         "requires the real Syn helper and Tokei")
    def test_real_parser_counter_excludes_documentation_examples_and_test_syntax(self):
        text = ('/// Docs\n/// ```rust\n/// let example = 1;\n/// ```\n'
                '#[test] fn café() {} fn production() { /* outer /* nested */ */ }\n'
                'const RAW: &str = r#"// data\n/* data */"#; // comment\n'
                '#[cfg(test)]\nmod checks {\n  fn only_test() {}\n}\n')
        sources = [("reactivity/crates/gpui/src/lib.rs", text.encode(), "Rust")]
        with (mock.patch.object(core_lines.inventory, "git", return_value="fixture\n"),
              mock.patch.object(core_lines.inventory, "read_sources", return_value=sources)):
            result = core_lines.count("fixture", False,
                                      pathlib.Path(os.environ["INVENTORY_RUST_HELPER"]),
                                      pathlib.Path(os.environ["TOKEI"]))
        self.assertEqual(result["core_non_test_code_lines"], 3)
        self.assertFalse(result["files"][sources[0][0]]["unclassified"])

    @unittest.skipUnless(os.environ.get("INVENTORY_RUST_HELPER") and os.environ.get("TOKEI"),
                         "requires the real Syn helper and Tokei")
    def test_custom_library_root_propagates_test_only_modules(self):
        sources = [("crates/gpui/src/gpui.rs", b"#[cfg(test)] mod checks;\npub fn root() {}\n", "Rust"),
                   ("crates/gpui/src/checks.rs", b"pub fn helper() {}\n", "Rust")]
        with (mock.patch.object(core_lines.inventory, "git", return_value="fixture\n"),
              mock.patch.object(core_lines.inventory, "read_sources", return_value=sources),
              mock.patch.object(core_lines.inventory, "cargo_targets",
                                return_value=(set(), {sources[0][0]}, {}))):
            result = core_lines.count("fixture", True,
                                      pathlib.Path(os.environ["INVENTORY_RUST_HELPER"]),
                                      pathlib.Path(os.environ["TOKEI"]))
        self.assertEqual(result["core_non_test_code_lines"], 1)
        self.assertTrue(result["files"][sources[1][0]]["test_only"])
        self.assertFalse(result["files"][sources[0][0]]["unclassified"])


if __name__ == "__main__":
    unittest.main()
