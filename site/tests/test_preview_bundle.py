"""The editor must ship a complete runtime for its published Rust sources."""

import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('preview_build', Path(__file__).parents[1] / 'scripts/build_preview.py')
preview = importlib.util.module_from_spec(spec)
spec.loader.exec_module(preview)


class PreviewBundleTests(unittest.TestCase):
    def fixture(self, root):
        source = root / 'target/codepen-browser/miri'
        source.mkdir(parents=True)
        components = root / 'site/static/components'
        components.mkdir(parents=True)
        (components / 'counter.rs').write_text('fn component() {}')
        manifest = {'protocol': 8, 'module': 'miri.wasm.gz', 'metadata': 'metadata.bin.gz',
                    'starters': [{'source': 'fn component() {}'}]}
        for name in ('miri.wasm.gz', 'metadata.bin.gz', 'runtime.js', 'worker.js',
                     'bootstrap.js', 'wasi-clock.js', 'wasi/index.js'):
            path = source / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(b'asset')
        (source / 'assets.json').write_text(json.dumps(manifest))
        return source, components, manifest

    def test_publishes_matching_runtime_and_rejects_changed_source(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source, components, _ = self.fixture(root)
            with patch.object(preview, 'ROOT', root), patch.object(preview, 'OUT', root / 'site/static/preview/pkg'):
                preview.copy_runtime()
                self.assertEqual((root / 'site/static/preview/miri/wasi/index.js').read_bytes(), b'asset')
                (components / 'counter.rs').write_text('fn changed() {}')
                with self.assertRaisesRegex(RuntimeError, 'starter is stale: counter.rs'):
                    preview.copy_runtime()
                self.assertEqual((root / 'site/static/preview/miri/assets.json').read_bytes(), (source / 'assets.json').read_bytes())

    def test_rejects_missing_assets_and_paths_outside_the_bundle(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source, _, manifest = self.fixture(root)
            with patch.object(preview, 'ROOT', root), patch.object(preview, 'OUT', root / 'site/static/preview/pkg'):
                (source / 'worker.js').unlink()
                with self.assertRaisesRegex(RuntimeError, 'missing or outside its bundle: worker.js'):
                    preview.copy_runtime()
                manifest['module'] = '../outside.wasm'
                (source / 'assets.json').write_text(json.dumps(manifest))
                (source.parent / 'outside.wasm').write_bytes(b'outside')
                with self.assertRaisesRegex(RuntimeError, 'outside its bundle: ../outside.wasm'):
                    preview.copy_runtime()

    def test_rejects_missing_cold_metadata_before_replacing_the_runtime(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source, _, manifest = self.fixture(root)
            manifest['metadata_paging'] = {'page_size': 16384, 'chunk_size': 262144}
            manifest['files'] = [{'path': '/sdk.rmeta', 'chunks': ['chunks/sdk.bin.gz']}]
            (source / 'metadata-files.js').write_bytes(b'paged loader')
            (source / 'assets.json').write_text(json.dumps(manifest))
            destination = root / 'site/static/preview/miri'
            destination.mkdir(parents=True)
            (destination / 'assets.json').write_text('last complete runtime')
            with patch.object(preview, 'ROOT', root), patch.object(preview, 'OUT', root / 'site/static/preview/pkg'):
                with self.assertRaisesRegex(RuntimeError, 'missing or outside its bundle: chunks/sdk.bin.gz'):
                    preview.copy_runtime()
                self.assertEqual((destination / 'assets.json').read_text(), 'last complete runtime')
                (source / 'chunks').mkdir()
                (source / 'chunks/sdk.bin.gz').write_bytes(b'cold page')
                preview.copy_runtime()
                self.assertEqual((destination / 'chunks/sdk.bin.gz').read_bytes(), b'cold page')


if __name__ == '__main__':
    unittest.main()
