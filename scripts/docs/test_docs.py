#!/usr/bin/env python3
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).parent))
from parser import DocumentationError, parse_source
from postprocess import callouts, rustdoc_backlinks
from sync_links import sync
from generate import cargo_zip, render


class ParserTests(unittest.TestCase):
    def test_parse_and_normalize(self):
        steps = parse_source(Path("example.rs"), '// docs:step state | State\r\n// markdown Explain it.\r\n// docs:code\r\nlet x = 1;\r\n// docs:end\r\n')
        self.assertEqual(steps[0].slug, "state")
        self.assertEqual(steps[0].code, ["let x = 1;"])

    def test_rejects_duplicates_and_missing_sections(self):
        for source in (
            "// docs:step x | X\n// markdown prose\n// docs:code\n// docs:end\n// docs:step x | X\n// markdown p\n// docs:code\nx\n// docs:end\n",
            "// docs:step x | X\n// markdown prose\n// docs:end\n",
            'let x = r#"// docs:step hidden | H"#;\n',
        ):
            with self.assertRaises(DocumentationError): parse_source(Path("bad.rs"), source)

    def test_marker_inside_block_comment(self):
        with self.assertRaises(DocumentationError):
            parse_source(Path("bad.rs"), "/*\n// docs:step hidden | H\n*/\n")


class LinkTests(unittest.TestCase):
    def test_download_project_is_deterministic_and_inlines_support(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory); source = root / "example.rs"; manifest = root / "Cargo.toml"; support = root / "support.rs"
            source.write_text('#[path = "../support.rs"]\nmod support;\nfn main() {}\n')
            support.write_text('pub fn run() {}\n')
            manifest.write_text('[package]\nname = "demo-{slug}"\nversion = "0.1.0"\n')
            steps = parse_source(source, '// docs:step x | X\n// prose\n// docs:code\nfn main() {}\n// docs:end\n')
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
        multi = callouts('<blockquote><p>[!NOTE]</p><p>First.</p><p>Second.</p></blockquote>')
        self.assertIn('<p>First.</p><p>Second.</p>', multi)
        self.assertNotIn('<p><p>', multi)
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
            ex.write_text('// docs:step state | State\n// markdown State.\n// docs:api gpui::Entity\n// docs:code\nlet x = 1;\n// docs:end\n')
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
            ex.write_text('// docs:step x | X\n// prose\n// docs:api A B\n// docs:code\nlet x = 1;\n// docs:end\n')
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
