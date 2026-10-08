import tempfile
import unittest
from pathlib import Path

from book import ApiLinks, accessible_chrome, canonical_source, prepare_search_assets, preprocess, render_markdown
from check_site import Document


class BookTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.docs = Path(self.directory.name)
        (self.docs / "struct.Entity.html").write_text('<section id="method.update"></section>')
        (self.docs / "struct.Canvas.html").write_text("")
        (self.docs / "fn.canvas.html").write_text("")
        self.links = ApiLinks(self.docs, "https://example.test/docs/api/gpui/")

    def test_case_sensitive_item_names_on_case_insensitive_filesystems(self):
        self.assertTrue(self.links.resolve("crate::canvas").endswith("/fn.canvas.html"))
        self.assertTrue(self.links.resolve("crate::Canvas").endswith("/struct.Canvas.html"))

    def test_members_must_exist_in_actual_rustdoc(self):
        self.assertTrue(self.links.resolve("crate::Entity::update").endswith("#method.update"))
        with self.assertRaisesRegex(ValueError, "API member"):
            self.links.resolve("crate::Entity::missing")

    def test_links_change_but_prose_and_rust_do_not(self):
        source = "Use [`Entity`](crate::Entity).\n\n```rust\n// [`missing`]\n```\n"
        rendered = render_markdown(source, self.links, "https://example.test/docs")
        self.assertEqual(rendered, source.replace("crate::Entity", self.links.resolve("Entity")))

    def test_mirror_reads_the_current_canonical_source(self):
        chapter = {"Chapter": {"content": "{{#gpui ownership}}\n", "sub_items": []}}
        class IdentityLinks:
            base = "https://example.test/api/"
            def resolve(self, symbol):
                return symbol
        links = IdentityLinks()
        result = preprocess({"items": [chapter]}, links, "https://gpui-ce.github.io")
        expected = render_markdown(canonical_source("ownership"), links, "https://gpui-ce.github.io")
        self.assertEqual(result["items"][0]["Chapter"]["content"], expected)

    def test_concept_links_stay_inside_book(self):
        self.assertEqual(self.links.resolve("crate::_documentation::testing"), "testing.md")

    def test_concept_deep_links_keep_their_fragment(self):
        symbol = "crate::_ownership_and_data_flow#notify-after-a-change"
        self.assertEqual(self.links.resolve(symbol), "ownership.md#notify-after-a-change")
        site_links = ApiLinks(self.docs, "https://example.test/api/", "https://example.test/book")
        self.assertEqual(site_links.resolve(symbol), "https://example.test/book/ownership.html#notify-after-a-change")

    def test_explicit_fragment_cannot_override_a_resolved_member(self):
        with self.assertRaisesRegex(ValueError, "fragment conflict"):
            self.links.resolve("crate::Entity::update#another-member")

    def test_book_navigation_does_not_compete_with_chapter_heading(self):
        html = '<h1 class="menu-title">The GPUI Book</h1><iframe class="sidebar-iframe-outer" src="toc.html"></iframe><main><h1 id="chapter">Chapter</h1></main>'
        document = Document()
        document.feed(accessible_chrome(html))
        self.assertEqual(document.tags["h1"], 1)
        self.assertEqual(document.errors, [])
        self.assertEqual(document.ids, ["chapter"])

    def test_contents_toggle_is_a_keyboard_operable_button(self):
        html = '<label id="mdbook-sidebar-toggle" class="icon-button" for="mdbook-sidebar-toggle-anchor" aria-controls="mdbook-sidebar" aria-expanded="false"><span>Contents</span></label>'
        rendered = accessible_chrome(html)
        self.assertIn('<button type="button" id="mdbook-sidebar-toggle"', rendered)
        self.assertIn('aria-expanded="false"', rendered)
        self.assertIn('<span>Contents</span></button>', rendered)
        self.assertNotIn('for=', rendered)

    def test_search_results_follow_input_and_asset_identity_changes(self):
        script = self.docs / "searcher-old.js"
        script.write_text("searchbar.addEventListener('keyup', () => { searchbarKeyUpHandler(); });")
        page = self.docs / "testing.html"
        page.write_text('<script src="searcher-old.js"></script>')
        prepare_search_assets(self.docs)
        revised, = self.docs.glob("searcher-gpui-*.js")
        self.assertIn("addEventListener('input'", revised.read_text())
        self.assertIn(revised.name, page.read_text())
        self.assertFalse(script.exists())


if __name__ == "__main__":
    unittest.main()
