#!/usr/bin/env python3
import json
from pathlib import Path
import sys
import tempfile
import unittest
import shutil
import subprocess

sys.path.insert(0, str(Path(__file__).parent))
from parser import DocumentationError, parse_source
from postprocess import callouts, rustdoc_backlinks
from sync_links import sync
from generate import cargo_zip, component_source, render


class ParserTests(unittest.TestCase):
    def test_markdown_heading_and_rustdoc_links(self):
        source = '// ## Own state {#state}\r\n// Keep an [`Entity`] alive.\r\n\r\nlet x = 1;\r\n'
        steps = parse_source(Path("example.rs"), source)
        self.assertEqual(steps[0].slug, "state")
        self.assertEqual(steps[0].code, ["let x = 1;"])
        self.assertEqual(steps[0].api, ["gpui::Entity"])

    def test_rejects_duplicate_anchors_and_empty_chapters(self):
        for source in (
            "// ## X {#x}\n// Explain x.\nlet x = 1;\n// ## Again {#x}\n// Explain again.\nlet y = 2;\n",
            "// ## Empty\n// Explanation only.\n",
            "// ## No prose\nlet x = 1;\n",
        ):
            with self.assertRaises(DocumentationError):
                parse_source(Path("bad.rs"), source)

    def test_strings_and_block_comments_cannot_create_chapters(self):
        for source in (
            'let s = "open\n// ## Hidden\nclose";\n',
            'let s = r#"\n// ## Hidden\n"#;\n',
            '/* nested /* comment */\n// ## Hidden\n*/\n',
        ):
            self.assertEqual(parse_source(Path("example.rs"), source), [])

    def test_char_literal_and_markdown_indentation(self):
        source = "let quote = '\"';\n// ## X {#x}\n// - item\n//   - nested\n\nlet value = 1;\n"
        steps = parse_source(Path("example.rs"), source)
        self.assertEqual(steps[0].prose, ["- item", "  - nested"])

    def test_code_comments_and_adjacent_chapters(self):
        source = "// ## First\n// Explain.\nlet x = 1;\n// An ordinary code comment.\n\n// ## Next {#stable}\n// Explain again.\nlet y = x + 1;\n"
        steps = parse_source(Path("example.rs"), source)
        self.assertEqual([step.slug for step in steps], ["first", "stable"])
        self.assertIn("// An ordinary code comment.", steps[0].code)
        self.assertEqual(steps[1].code_start, 8)

    def test_chapters_can_explain_code_inside_a_function(self):
        source = "fn main() {\n    // ## Start {#start}\n    // Explain the setup.\n    let x = 1;\n    // ## Use it {#use}\n    // Explain the result.\n    println!(\"{x}\");\n}\n"
        steps = parse_source(Path("example.rs"), source)
        self.assertEqual([step.slug for step in steps], ["start", "use"])
        self.assertEqual(steps[0].code, ["    let x = 1;"])

    def test_unknown_api_reference_is_an_authoring_error(self):
        with self.assertRaisesRegex(DocumentationError, "unknown API link"):
            parse_source(Path("example.rs"), "// ## X\n// Use [`Typo`].\nlet x = 1;\n", catalog={})


class LinkTests(unittest.TestCase):
    @unittest.skipUnless(shutil.which("rustfmt"), "rustfmt is required for this integration check")
    def test_generated_method_links_remain_current_after_rustfmt(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "crates/gpui/src/lib.rs"
            source.parent.mkdir(parents=True)
            (root / "crates/gpui/Cargo.toml").write_text("[package]\nname='gpui'\n")
            source.write_text("pub trait Example {\n    fn update(&mut self);\n}\n")
            site = root / "site"
            site.mkdir()
            (site / "examples.toml").write_text('''[[examples]]
slug = "counter"
title = "Counter"
summary = "A counter"
source = "counter.rs"
run = "cargo run"
weight = 1

[api."gpui::Example::update"]
source = "crates/gpui/src/lib.rs"
declaration = "fn update("
''')
            (root / "counter.rs").write_text('// ## Update\n// Call [`Example::update`].\nlet x = 1;\n')
            self.assertEqual(sync(root), [])
            subprocess.run(["rustfmt", "--edition", "2024", str(source)], check=True)
            self.assertEqual(sync(root, check=True), [])

    def test_miri_component_keeps_the_same_constructor_and_api(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / 'counter.rs'
            source.write_text('#[path = "../src/support.rs"]\nmod support;\n// ## Counter\n// Own the value.\nuse gpui::*;\nfn component(_: &mut Window, cx: &mut App) -> Entity<u32> { cx.new(|_| 0) }\npub fn main() {\n    support::run(component);\n}\n')
            component = component_source(source, parse_source(source))
            self.assertIn('use gpui::*;', component)
            self.assertIn('cx.new(|_| 0)', component)
            self.assertNotIn('support', component)
            self.assertNotIn('fn main', component)
            source.write_text('fn main() {}')
            with self.assertRaises(DocumentationError):
                component_source(source, [])

    def test_download_project_is_deterministic_and_inlines_support(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory); source = root / "example.rs"; manifest = root / "Cargo.toml"; support = root / "support.rs"
            source.write_text('#[path = "../support.rs"]\nmod support;\nfn main() {}\n')
            support.write_text('pub fn run() {}\n')
            manifest.write_text('[package]\nname = "demo-{slug}"\nversion = "0.1.0"\n')
            steps = parse_source(source, '// ## X {#x}\n// Explain.\nfn main() {}\n')
            item = {"slug": "demo", "downloadable_manifest": "Cargo.toml", "support": "support.rs"}
            first = cargo_zip(root, item, source, steps)
            second = cargo_zip(root, item, source, steps)
            self.assertEqual(first, second)
            import zipfile, io
            with zipfile.ZipFile(io.BytesIO(first)) as archive:
                main = archive.read("src/main.rs").decode()
                self.assertIn("mod support {", main)
                self.assertNotIn('#[path = "../support.rs"]', main)
                self.assertEqual(archive.namelist(), ["Cargo.toml", "src/main.rs"])

    def test_callout_and_idempotent_backlink(self):
        rendered = callouts('<blockquote><p>[!NOTE]<br>Read this.</p></blockquote>')
        self.assertIn('role="note"', rendered)
        html = '<main><h1 id="x">Entity</h1></main>'
        links = [{"url": "/examples/counter/#state", "title": "Counter", "step": "state"}]
        once = rustdoc_backlinks(html, "gpui::Entity", links)
        self.assertEqual(rustdoc_backlinks(once, "gpui::Entity", links), once)
        self.assertIn("/examples/counter/#state", once)
        authored = '<p>Keep this explanation.</p>'
        generated = '<!-- gpui-walkthroughs:begin gpui::Entity --><p>Walkthroughs:</p><ul><li>Old link</li></ul><!-- gpui-walkthroughs:end gpui::Entity -->'
        replaced = rustdoc_backlinks(html.replace('</main>', authored + generated + '</main>'), "gpui::Entity", links)
        self.assertIn(authored, replaced)
        self.assertNotIn('Old link', replaced)
        self.assertEqual(replaced.count('Walkthroughs'), 1)
        multi = callouts('<blockquote><p>[!NOTE]</p><p>First.</p><p>Second.</p></blockquote>')
        self.assertIn('<p>First.</p><p>Second.</p>', multi)
        self.assertNotIn('<p><p>', multi)
        mixed = callouts('<blockquote><p>[!WARNING]<br>First.</p><p>Second.</p></blockquote>')
        self.assertIn('<p>First.</p><p>Second.</p>', mixed)
        self.assertIn('role="note"', mixed)
        self.assertNotIn('role="alert"', mixed)
        method = '<section id="method.spawn"><details><summary>spawn</summary><h4 class="code-header">fn spawn</h4><div class="docblock">Body</div></details></section>'
        linked = rustdoc_backlinks(method, "gpui::Context::spawn", links, "method.spawn")
        self.assertLess(linked.index("</summary>"), linked.index("gpui-examples-backlinks"))
        with self.assertRaises(ValueError): rustdoc_backlinks(method, "gpui::Context::spawn", links, "method.missing")

    def test_sync_links_is_idempotent(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory); source = root / "crates/gpui/src/app/entity_map.rs"
            source.parent.mkdir(parents=True); (root / "crates/gpui/Cargo.toml").write_text("[package]\nname='gpui'\n")
            source.write_text("pub struct Entity<T> { value: T }\n")
            site = root / "site"; site.mkdir()
            (site / "examples.toml").write_text('''[[examples]]
slug = "counter"
title = "Counter"
summary = "A counter"
source = "crates/gpui/examples/counter.rs"
run = "cargo run"
weight = 1

[api."gpui::Entity"]
source = "crates/gpui/src/app/entity_map.rs"
declaration = "pub struct Entity<"
''')
            ex = root / "crates/gpui/examples/counter.rs"; ex.parent.mkdir(parents=True)
            ex.write_text('// ## State {#state}\n// Keep an [`Entity`].\nlet x = 1;\n')
            self.assertEqual(sync(root), [])
            first = source.read_text()
            self.assertEqual(sync(root), [])
            self.assertEqual(source.read_text(), first)
            self.assertIn("docs:examples:begin", first)

    def test_sync_links_keeps_multiple_symbols_in_one_source(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory); source = root / "crates/gpui/src/app.rs"
            source.parent.mkdir(parents=True); (root / "crates/gpui/Cargo.toml").write_text("[package]\nname='gpui'\n")
            source.write_text("pub struct A;\npub struct B;\n")
            site = root / "site"; site.mkdir()
            (site / "examples.toml").write_text('''[[examples]]
slug = "x"
title = "X"
summary = "X"
source = "crates/gpui/examples/x.rs"
run = "cargo run"
weight = 1

[api."A"]
source = "crates/gpui/src/app.rs"
declaration = "pub struct A"

[api."B"]
source = "crates/gpui/src/app.rs"
declaration = "pub struct B"
''')
            ex = root / "crates/gpui/examples/x.rs"; ex.parent.mkdir(parents=True)
            ex.write_text('// ## X {#x}\n// Use [`A`] and [`B`].\nlet x = 1;\n')
            self.assertEqual(sync(root), [])
            text = source.read_text()
            self.assertEqual(text.count("docs:examples:begin"), 2)
            self.assertEqual(sync(root), [])
            self.assertEqual(source.read_text(), text)

    def test_sync_links_removes_deleted_api_marker(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory); source = root / "crates/gpui/src/lib.rs"
            source.parent.mkdir(parents=True); (root / "crates/gpui/Cargo.toml").write_text("[package]\nname='gpui'\n")
            source.write_text('// docs:examples:begin\n#[doc = include_str!("docs/examples/old.md")]\n// docs:examples:end\npub struct Keep;\n')
            site = root / "site"; site.mkdir(); (site / "examples.toml").write_text('')
            self.assertEqual(sync(root), [])
            self.assertNotIn("docs:examples", source.read_text())


if __name__ == "__main__": unittest.main()
