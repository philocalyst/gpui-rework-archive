"""Failures in the published artifact must fail the documentation build."""
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

spec = importlib.util.spec_from_file_location('site_audit', Path(__file__).parents[2] / 'scripts/docs/check_site.py')
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


class SiteAuditTests(unittest.TestCase):
    def make_site(self, root):
        (root / 'index.html').write_text('<main><h1>Guide</h1><a href="/docs/topic/#step">Next</a></main>')
        (root / 'topic').mkdir()
        (root / 'topic/index.html').write_text('<main><h1>Topic</h1><h2 id="step">Step</h2></main>')
        (root / 'api-examples.json').write_text('{}')
        (root / 'documentation-build.json').write_text(json.dumps({'browser_programs': False}))

    def test_prefix_and_exact_anchors(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.make_site(root)
            self.assertEqual(audit.audit(root, base_url='https://example.com/docs'), [])
            (root / 'index.html').write_text('<main><h1>Guide</h1><a href="/topic/">Escaped</a><a href="/docs/topic/#absent">Missing</a></main>')
            errors = audit.audit(root, base_url='https://example.com/docs')
            self.assertTrue(any('escapes base URL prefix' in error for error in errors))
            self.assertTrue(any('missing anchor' in error for error in errors))

    def test_missing_identity_and_invalid_preview_are_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.make_site(root)
            (root / 'documentation-build.json').unlink()
            self.assertTrue(any('missing build identity' in error for error in audit.audit(root, base_url='https://example.com/docs')))
            (root / 'documentation-build.json').write_text(json.dumps({'browser_programs': True}))
            preview = root / 'preview'
            (preview / 'pkg').mkdir(parents=True)
            (preview / 'build.json').write_text(json.dumps({'entry': 'program.js', 'wasm': 'program.wasm'}))
            (preview / 'pkg/program.js').write_text('')
            (preview / 'pkg/program.wasm').write_bytes(b'<html>error</html>')
            self.assertTrue(any('invalid WebAssembly artifact' in error for error in audit.audit(root, base_url='https://example.com/docs')))

    def test_cross_crate_api_links_follow_reexport_redirects(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.make_site(root)
            core = root / 'api/gpui'
            companion = root / 'api/gpui_ce_elements'
            (core / 'window').mkdir(parents=True)
            companion.mkdir(parents=True)
            (core / 'trait.Focusable.html').write_text('<h1>Focusable</h1><h2 id="tymethod.focus_handle">Handle</h2>')
            (core / 'window/trait.Focusable.html').write_text('<meta http-equiv="refresh" content="0;URL=../trait.Focusable.html">')
            page = companion / 'struct.Field.html'
            page.write_text('<a href="https://example.com/docs/api/gpui/window/trait.Focusable.html#tymethod.focus_handle">Focus</a>')
            self.assertEqual(audit.audit(root, base_url='https://example.com/docs'), [])
            page.write_text('<a href="gpui::Focusable">Focus</a><a href="https://example.com/docs/api/gpui/trait.Focusable.html#absent">Missing</a>')
            errors = audit.audit(root, base_url='https://example.com/docs')
            self.assertTrue(any('unresolved Rust documentation link' in error for error in errors))
            self.assertTrue(any('missing anchor' in error for error in errors))

    def test_rustdoc_source_ranges_require_both_endpoint_lines(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.make_site(root)
            source = root / 'api/src/gpui/source.rs.html'
            source.parent.mkdir(parents=True)
            source.write_text('<a id="20"></a><a id="21"></a><a id="22"></a>')
            page = root / 'api/gpui/struct.Example.html'
            page.parent.mkdir(parents=True, exist_ok=True)
            url = 'https://example.com/docs/api/src/gpui/source.rs.html'
            page.write_text(f'<a href="{url}#20-22">Source</a>')
            self.assertEqual(audit.audit(root, base_url='https://example.com/docs'), [])
            for fragment in ('20-23', '19-22', '22-20'):
                page.write_text(f'<a href="{url}#{fragment}">Source</a>')
                self.assertTrue(any('missing anchor' in error for error in
                                    audit.audit(root, base_url='https://example.com/docs')))


if __name__ == '__main__':
    unittest.main()
