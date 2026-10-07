import importlib.util
from pathlib import Path
import unittest

HERE = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("compiler", HERE / "scripts/compiler.py")
compiler = importlib.util.module_from_spec(spec)
assert spec.loader
spec.loader.exec_module(compiler)


class CompilerTests(unittest.TestCase):
    def test_origin_only_accepts_local_site(self):
        self.assertTrue(compiler.allowed_origin("http://localhost:1111"))
        self.assertTrue(compiler.allowed_origin("http://127.0.0.1:1111"))
        self.assertFalse(compiler.allowed_origin("https://example.com:1111"))
        self.assertFalse(compiler.allowed_origin("http://localhost:2222"))


    def test_digest_changes_with_source(self):
        self.assertNotEqual(compiler.workspace_digest("fn main() {}"), compiler.workspace_digest("fn main() { println!(); }"))


    def test_source_limit(self):
        result = compiler.compile_source("x" * (compiler.MAX_SOURCE + 1))
        self.assertFalse(result["ok"])
        self.assertIn("64 KiB", result["error"])


    def test_loopback_rejects_public_bind_address(self):
        self.assertFalse(compiler._loopback("0.0.0.0"))
        self.assertTrue(compiler._loopback("127.0.0.1"))


if __name__ == "__main__":
    unittest.main()
