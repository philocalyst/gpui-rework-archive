"""Exercise classification boundaries; run with the inventory-rust helper built."""
import importlib.util
import os
import pathlib
import unittest
from unittest import mock

SPEC = importlib.util.spec_from_file_location("inventory", pathlib.Path(__file__).with_name("inventory.py"))
inventory = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(inventory)


class InventoryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.helper = pathlib.Path(os.environ["INVENTORY_RUST_HELPER"])

    def analyze(self, files):
        sources = [(path, text.encode(), "Rust") for path, text in files.items()]
        return sources, inventory.rust_analysis(sources, self.helper)

    def test_real_syntax_and_shared_physical_lines(self):
        text = ('const RAW: &str = r###" } #[test] fn fake() { "###;\n'
                '/* outer /* } */ #[test] */\n'
                '#[cfg(\n all(test, feature = "x")\n)]\n'
                'mod tests { #[test] fn check() {} }\n'
                '#[cfg(any(test, feature = "x"))]\nfn shared() {}\n'
                '#[test] fn unit() {} fn production() {}\n')
        _, result = self.analyze({"src/lib.rs": text})
        self.assertEqual(inventory.excluded_test_lines(text.encode(), result["src/lib.rs"]), 4)
        self.assertFalse(result["src/lib.rs"]["unclassified"])

    def test_unicode_endpoints_and_shared_lines_use_actual_rust_spans(self):
        text = ('#[test] fn café() { let _ = "雪🦀"; }\n'
                '#[cfg(test)]\nfn épreuve() {\n    let _ = "雪🦀"; }\n'
                '#[test] fn café_partagée() { let _ = "雪"; } fn production() {}\n'
                'const É: &str = "雪"; #[test] fn unité() {}\n')
        _, result = self.analyze({"src/lib.rs": text})
        analysis = result["src/lib.rs"]
        lines = text.splitlines()
        # Assert helper locations against source character lengths, rather than
        # manufacturing columns that would repeat the Python implementation.
        self.assertEqual(analysis["test_ranges"][0][3], len(lines[0]))
        self.assertEqual(analysis["test_ranges"][1][3], len(lines[3]))
        self.assertNotEqual(len(lines[0]), len(lines[0].encode()))
        self.assertEqual(inventory.excluded_test_lines(text.encode(), analysis), 4)
        self.assertFalse(analysis["unclassified"])

    def test_out_of_line_path_nested_and_production_sharing(self):
        sources, result = self.analyze({
            "src/lib.rs": '#[cfg(test)]\n#[path = "checks.rs"] mod checks;\nmod production;\nmod nested { #[cfg(test)] mod more; }\n',
            "src/checks.rs": 'mod child;\n#[path = "shared.rs"] mod shared;\n',
            "src/checks/child.rs": 'fn helper() {}\n',
            "src/production.rs": '#[path = "shared.rs"] mod shared;\n',
            "src/shared.rs": 'fn shared() {}\n',
            "src/nested/more.rs": 'fn more() {}\n',
        })
        tests = inventory.resolve_modules(result, sources)
        self.assertEqual(tests, {"src/checks.rs", "src/checks/child.rs", "src/nested/more.rs"})
        self.assertTrue(all(not entry["unclassified"] for entry in result.values()))

    def test_cfg_attr_path_cannot_quietly_hide_production_file(self):
        sources, result = self.analyze({
            "src/lib.rs": '#[cfg(test)] #[path = "shared.rs"] mod checks;\n#[cfg_attr(feature = "x", path = "shared.rs")] mod production;\n',
            "src/production.rs": 'fn normal() {}\n',
            "src/shared.rs": 'fn shared() {}\n',
        })
        self.assertNotIn("src/shared.rs", inventory.resolve_modules(result, sources))
        self.assertTrue(result["src/lib.rs"]["unclassified"])

    def test_custom_cargo_roots_and_tests(self):
        sources, result = self.analyze({
            "test_driver.rs": '#[path = "custom_lib.rs"] mod library;\n',
            "custom_lib.rs": 'mod implementation;\n',
            "implementation.rs": 'fn production() {}\n',
            "src/lib.rs": 'fn regular() {}\n',
        })
        tests = inventory.resolve_modules(result, sources, {"test_driver.rs"}, {"custom_lib.rs"})
        self.assertEqual(tests, {"test_driver.rs"})
        self.assertFalse(result["custom_lib.rs"]["unclassified"])

    def test_raw_identifiers_are_file_names_without_raw_prefix(self):
        sources, result = self.analyze({
            "src/lib.rs": 'mod r#async;\nmod r#type { #[cfg(test)] mod r#async; }\n',
            "src/async.rs": 'fn production() {}\n',
            "src/type/async.rs": 'fn check() {}\n',
        })
        self.assertEqual(inventory.resolve_modules(result, sources), {"src/type/async.rs"})
        self.assertFalse(result["src/lib.rs"]["unclassified"])

    def test_parse_failure_is_charged(self):
        text = 'this is an archived snippet, not valid Rust\n'
        _, result = self.analyze({"snippet.rs": text})
        self.assertTrue(result["snippet.rs"]["unclassified"])
        self.assertEqual(inventory.excluded_test_lines(text.encode(), result["snippet.rs"]), 0)

    def test_macro_production_import_blocks_test_exclusion(self):
        sources, result = self.analyze({
            "src/lib.rs": '#[cfg(test)] mod shared;\nconditional! { mod shared; }\n',
            "src/shared.rs": 'fn shared() {}\n',
        })
        self.assertNotIn("src/shared.rs", inventory.resolve_modules(result, sources))
        self.assertTrue(result["src/lib.rs"]["unclassified"])

    def test_purpose_and_ownership(self):
        expected = {
            "reactivity/crates/foo/src/lib.rs": ("first_party", "libraries"),
            "reactivity/crates/api-lab/src/lib.rs": ("first_party", "labs"),
            "reactivity/crates/foo/examples/a.rs": ("first_party", "examples"),
            "reactivity/benchmarks/fixtures/main.go": ("first_party", "benchmarks"),
            "reactivity/tools/inventory.py": ("first_party", "tools"),
            "reactivity/vendor/winit/src/a.rs": ("vendor", "vendor"),
            "reactivity/docs/inputs/final/a.rs": ("archived_legacy", "archived_inputs"),
            "crates/gpui/src/lib.rs": ("archived_legacy", "legacy_checkout"),
        }
        for path, category in expected.items():
            self.assertEqual(inventory.category(path, "experiment"), category)
        self.assertEqual(inventory.category("crates/gpui/src/lib.rs", "original"), ("first_party", "libraries"))
        self.assertEqual(inventory.source_language("probe.c", b""), "C")
        self.assertEqual(inventory.source_language("fixture.zig", b""), "Zig")
        self.assertTrue(inventory.generated_source("reactivity/evidence/paint-patch/output.s", b""))
        self.assertTrue(inventory.is_external_test("reactivity/tools/test_inventory.py"))

    def test_authored_and_captured_assembly_have_separate_charges(self):
        cases = {
            "reactivity/crates/core/src/arm64.s": False,
            "reactivity/crates/core/src/arm64.asm": False,
            "reactivity/crates/core/src/asm/kernel.s": False,
            "reactivity/benchmarks/bin-miss/asm/kernel.s": True,
            "reactivity/evidence/paint-coupling/consumer.s": True,
            "reactivity/crates/gpui/evidence/dimensions/layout.asm": True,
            "reactivity/crates/canvas/evidence/text-selection-cut-candidate.asm": True,
            "reactivity/crates/canvas/evidence/authored.asm": False,
        }
        handwritten = b".text\n.global kernel\nkernel:\n  ret\n"
        for path, generated in cases.items():
            self.assertEqual(inventory.generated_source(path, handwritten), generated)
            self.assertEqual(inventory.source_language(path, handwritten), "Assembly")
        self.assertTrue(inventory.generated_source("reactivity/crates/core/src/generated.s",
                                                  b"; @generated by codegen\n  ret\n"))
        # Exercise the actual ledger totals with identical authored/captured
        # source: the ownership charge changes, the all-code total does not.
        def totals_at(path):
            with (mock.patch.object(inventory, "read_sources", return_value=[(path, handwritten, "Assembly")]),
                  mock.patch.object(inventory, "cargo_targets", return_value=(set(), set(), {}))):
                return inventory.inventory(helper=self.helper)["totals"]
        authored = totals_at("reactivity/crates/core/src/arm64.s")
        captured = totals_at("reactivity/evidence/paint-coupling/consumer.s")
        lines = len(handwritten.splitlines())
        self.assertEqual(authored["first_party_non_test_lines"], lines)
        self.assertEqual(captured["generated_non_test_lines"], lines)
        self.assertEqual(authored["all_active_non_test_lines"], captured["all_active_non_test_lines"])
        self.assertEqual(authored["all_active_non_test_lines"], lines)


if __name__ == "__main__":
    unittest.main()
