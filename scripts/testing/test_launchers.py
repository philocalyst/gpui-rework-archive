import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

REPO_ROOT = Path(__file__).resolve().parents[2]


class LauncherTests(unittest.TestCase):
    @unittest.skipIf(os.name == "nt", "Bash launchers are for Unix-like hosts")
    def test_launchers_load_repository_config_and_keep_caller_directory(self):
        with tempfile.TemporaryDirectory() as temporary:
            caller = Path(temporary) / "caller"
            fake_bin = Path(temporary) / "bin"
            caller.mkdir()
            fake_bin.mkdir()
            capture = Path(temporary) / "capture.json"
            fake_cargo = fake_bin / "cargo"
            fake_cargo.write_text(
                "#!/usr/bin/env python3\n"
                "import json, os, sys\n"
                "with open(os.environ['CARGO_CAPTURE'], 'w') as file:\n"
                "    json.dump({'cwd': os.getcwd(), 'args': sys.argv[1:]}, file)\n",
                encoding="utf-8",
            )
            fake_cargo.chmod(0o755)
            env = os.environ.copy()
            env["PATH"] = str(fake_bin) + os.pathsep + env.get("PATH", "")
            env["CARGO_CAPTURE"] = str(capture)

            calls = (
                (REPO_ROOT / "scripts/gpui-test", ["list"], "gpui_ce_test", "--bin", ["--", "list"]),
                (REPO_ROOT / "scripts/gpui-test", ["run", "text-mixed-script", "--output", "relative-report", "--baseline", "relative-baseline"], "gpui_ce_test", "--bin", ["--", "run", "text-mixed-script", "--output", "relative-report", "--baseline", "relative-baseline"]),
                (REPO_ROOT / "scripts/gpui-example", ["hello_world", "--", "--scale", "2"], "gpui-ce", "--example", ["--example", "hello_world", "--", "--scale", "2"]),
            )
            for launcher, args, package, selector, expected_tail in calls:
                with self.subTest(launcher=launcher.name):
                    subprocess.run([str(launcher), *args], cwd=caller, env=env, check=True)
                    result = json.loads(capture.read_text(encoding="utf-8"))
                    argv = result["args"]
                    self.assertEqual(Path(result["cwd"]), caller.resolve())
                    self.assertEqual(argv[:2], ["--config", str(REPO_ROOT / ".cargo/config.toml")])
                    self.assertIn("run", argv)
                    self.assertEqual(argv[argv.index("--manifest-path") + 1], str(REPO_ROOT / "Cargo.toml"))
                    self.assertEqual(argv[argv.index("--package") + 1], package)
                    self.assertIn(selector, argv)
                    self.assertEqual(argv[-len(expected_tail):], expected_tail)

    @unittest.skipUnless(os.name == "nt", "native PowerShell launchers are exercised on Windows")
    def test_powershell_launchers_load_repository_config_and_keep_caller_directory(self):
        powershell = shutil.which("pwsh") or shutil.which("powershell")
        if not powershell:
            self.skipTest("PowerShell is unavailable")
        with tempfile.TemporaryDirectory() as temporary:
            caller = Path(temporary) / "caller"
            fake_bin = Path(temporary) / "bin"
            caller.mkdir()
            fake_bin.mkdir()
            capture = Path(temporary) / "capture.txt"
            fake_cargo = fake_bin / "cargo.cmd"
            fake_cargo.write_text(
                '@echo off\r\n'
                '> "%CARGO_CAPTURE%" echo %CD%\r\n'
                '>> "%CARGO_CAPTURE%" echo %*\r\n',
                encoding="utf-8",
            )
            env = os.environ.copy()
            env["PATH"] = str(fake_bin) + os.pathsep + env.get("PATH", "")
            env["CARGO_CAPTURE"] = str(capture)

            calls = (
                (REPO_ROOT / "scripts/gpui-test.ps1", ["list"], "-- list"),
                (REPO_ROOT / "scripts/gpui-test.ps1", ["run", "text-mixed-script", "--output", "relative-report", "--baseline", "relative-baseline"], "-- run text-mixed-script --output relative-report --baseline relative-baseline"),
                (REPO_ROOT / "scripts/gpui-example.ps1", ["hello_world", "--", "--scale", "2"], "--example hello_world -- --scale 2"),
            )
            for launcher, args, expected_tail in calls:
                with self.subTest(launcher=launcher.name, args=args):
                    subprocess.run([powershell, "-NoProfile", "-File", str(launcher), *args], cwd=caller, env=env, check=True)
                    lines = capture.read_text(encoding="utf-8-sig").splitlines()
                    self.assertEqual(Path(lines[0]), caller.resolve())
                    cargo_args = lines[1]
                    self.assertIn(str(REPO_ROOT / ".cargo/config.toml"), cargo_args)
                    self.assertIn(str(REPO_ROOT / "Cargo.toml"), cargo_args)
                    self.assertTrue(cargo_args.endswith(expected_tail), cargo_args)


if __name__ == "__main__":
    unittest.main()
