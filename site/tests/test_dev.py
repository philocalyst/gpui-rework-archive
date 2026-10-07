"""Check the served artifact and the live-reload input boundary."""

from functools import partial
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import http.client
import importlib.util
from pathlib import Path
from types import SimpleNamespace
import tempfile
import sys
import threading
import unittest
from unittest.mock import patch
from urllib.request import urlopen

sys.path.insert(0, str(Path(__file__).parents[1] / "scripts"))
spec = importlib.util.spec_from_file_location("documentation_dev", Path(__file__).parents[1] / "scripts/dev.py")
dev = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dev)


class DevTests(unittest.TestCase):
    def test_miri_binary_frames_and_cancellation_use_the_same_origin_proxy(self):
        requests = []
        frame = b'GPUIREP3\x00\xff\x80\x00'
        class Companion(BaseHTTPRequestHandler):
            def do_POST(self):
                requests.append((self.path, self.headers.get('Accept'), self.rfile.read(int(self.headers['Content-Length']))))
                self.send_response(204 if self.path == '/api/cancel' else 200)
                self.send_header('Content-Type', 'application/vnd.gpui.codepen-frame;version=3')
                self.end_headers()
                if self.path != '/api/cancel':
                    self.wfile.write(frame)
            def log_message(self, *_):
                pass
        upstream = ThreadingHTTPServer(('127.0.0.1', 0), Companion)
        server = ThreadingHTTPServer(('127.0.0.1', 0), dev.DocumentationHandler)
        threads = [threading.Thread(target=s.serve_forever, daemon=True) for s in (upstream, server)]
        for thread in threads:
            thread.start()
        try:
            with patch.object(dev.DocumentationHandler, 'workbench_address', upstream.server_address):
                connection = http.client.HTTPConnection(*server.server_address)
                headers = {'Content-Type': 'application/json', 'Accept': 'application/vnd.gpui.codepen-frame;version=3',
                           'Origin': f'http://127.0.0.1:{server.server_port}'}
                connection.request('POST', '/api/render', b'{"generation":7}', headers)
                response = connection.getresponse()
                self.assertEqual(response.status, 200)
                self.assertEqual(response.read(), frame)
                self.assertEqual(response.getheader('Content-Type'), headers['Accept'])
                connection.request('POST', '/api/cancel', b'{"generation":7}', headers)
                response = connection.getresponse()
                self.assertEqual(response.status, 204)
                response.read()
                headers['Origin'] = 'https://unrelated.example'
                connection.request('POST', '/api/render', b'{}', headers)
                response = connection.getresponse()
                self.assertEqual(response.status, 403)
                response.read()
                connection.request('POST', '/compile', b'{}', headers)
                response = connection.getresponse()
                self.assertEqual(response.status, 404)
                response.read()
                connection.close()
            self.assertEqual([row[0] for row in requests], ['/api/render', '/api/cancel'])
            self.assertEqual(requests[0][2], b'{"generation":7}')
        finally:
            for instance in (server, upstream):
                instance.shutdown(); instance.server_close()
            for thread in threads:
                thread.join()

    def test_directory_pages_receive_live_reload(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            page = root / "examples/counter/index.html"
            page.parent.mkdir(parents=True)
            page.write_text('<main>Counter</main></body>')
            server = ThreadingHTTPServer(("127.0.0.1", 0), partial(dev.DocumentationHandler, directory=root))
            thread = threading.Thread(target=server.serve_forever, daemon=True)
            thread.start()
            try:
                with urlopen(f"http://127.0.0.1:{server.server_port}/examples/counter/") as response:
                    self.assertIn('documentation-build.json', response.read().decode())
                    self.assertEqual(response.headers['Cache-Control'], 'no-store')
            finally:
                server.shutdown()
                server.server_close()
                thread.join()

    def test_generated_output_does_not_trigger_a_rebuild(self):
        with tempfile.TemporaryDirectory() as directory, patch.object(dev, "ROOT", Path(directory)):
            root = Path(directory)
            authored = root / "site/examples/examples/counter.rs"
            generated = root / "site/static/api-examples.json"
            authored.parent.mkdir(parents=True)
            generated.parent.mkdir(parents=True)
            authored.write_text('fn main() {}')
            generated.write_text('{}')
            before = dev.source_snapshot()
            generated.write_text('{"generated": true}')
            self.assertEqual(before, dev.source_snapshot())
            authored.write_text('fn main() { println!("changed"); }')
            self.assertNotEqual(before, dev.source_snapshot())

    def test_failed_build_keeps_the_served_artifact(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            public, staging = root / "site/public", root / "target/staging"
            public.mkdir(parents=True)
            (public / "index.html").write_text('last checked build')
            staging.mkdir(parents=True)
            (staging / "index.html").write_text('incomplete build')
            with patch.object(dev, "ROOT", root), patch.object(dev, "PUBLIC", public), patch.object(dev, "STAGING", staging), patch.object(dev.subprocess, "run", side_effect=[SimpleNamespace(returncode=n) for n in (0, 0, 1)]):
                self.assertFalse(dev.rebuild({}, 'http://127.0.0.1:1111'))
            self.assertEqual((public / "index.html").read_text(), 'last checked build')


if __name__ == '__main__':
    unittest.main()
