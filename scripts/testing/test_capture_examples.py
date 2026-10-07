import json
from pathlib import Path
import subprocess
import sys
import tempfile
import time
import unittest

from scripts.testing.capture_examples import capture, discover_examples, executable_path


class CaptureExamplesTests(unittest.TestCase):
    def test_builds_once_and_runs_only_entrypoint_examples(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "examples"
            source.mkdir()
            (source / "capturable.rs").write_text(
                "example_prelude::run_example_with_assets(scenario, assets)", encoding="utf-8"
            )
            (source / "native_only.rs").write_text("fn main() {}", encoding="utf-8")
            target = root / "target"
            metadata = {
                "target_directory": str(target),
                "packages": [{
                    "name": "gpui-ce",
                    "targets": [
                        {"name": "capturable", "kind": ["example"], "src_path": str(source / "capturable.rs")},
                        {"name": "native_only", "kind": ["example"], "src_path": str(source / "native_only.rs")},
                        {"name": "lib", "kind": ["lib"], "src_path": str(source / "native_only.rs")},
                    ],
                }],
            }
            baseline = root / "baseline" / "capturable"
            baseline.mkdir(parents=True)
            calls = []

            def run(command, **kwargs):
                calls.append((command, kwargs))
                if "metadata" in command:
                    return subprocess.CompletedProcess(command, 0, json.dumps(metadata), "")
                return subprocess.CompletedProcess(command, 0)

            result = capture(
                root / "Cargo.toml", root / ".cargo/config.toml", Path("relative-output"),
                root / "baseline", 3, False, run, lambda _: None,
            )

            self.assertEqual(result, 0)
            self.assertEqual(sum("build" in command for command, _ in calls), 1)
            metadata_command = calls[0][0]
            self.assertEqual(metadata_command[1:4], ["--config", str((root / ".cargo/config.toml").resolve()), "metadata"])
            self.assertEqual(metadata_command[4:6], ["--manifest-path", str((root / "Cargo.toml").resolve())])
            self.assertIn("--release", calls[1][0])
            self.assertEqual(calls[2][0][0], str(target / "release/examples/capturable"))
            self.assertEqual(calls[2][0][1:], [
                "--capture", "--output", str(Path("relative-output/capturable").resolve()), "--samples", "3",
                "--baseline", str(baseline.resolve()),
            ])

    def test_discovers_real_cargo_metadata_without_building(self):
        root = Path(__file__).resolve().parents[2]
        target_directory, examples = discover_examples(root / "Cargo.toml", root / ".cargo/config.toml")
        self.assertTrue(target_directory.is_absolute())
        self.assertIn("interaction", examples)

    def test_debug_profile_and_windows_executable_name(self):
        self.assertEqual(
            executable_path(Path("target"), "debug", "example", windows=True),
            Path("target/debug/examples/example.exe"),
        )

    def test_capture_failure_is_reported_and_returns_failure(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "capture.rs"
            source.write_text("example_prelude::run_example(scenario)", encoding="utf-8")
            metadata = {
                "target_directory": str(root / "target"),
                "packages": [{"name": "gpui-ce", "targets": [{
                    "name": "bad", "kind": ["example"], "src_path": str(source),
                }]}],
            }
            calls = []

            def run(command, **kwargs):
                calls.append(command)
                if "metadata" in command:
                    return subprocess.CompletedProcess(command, 0, json.dumps(metadata), "")
                return subprocess.CompletedProcess(command, 9)

            output = []
            result = capture(root / "Cargo.toml", root / "config.toml", root / "out", debug=True,
                             run=run, emit=output.append)
            self.assertEqual(result, 1)
            self.assertNotIn("--release", calls[1])
            self.assertTrue(any(line.startswith("FAIL bad:") for line in output))

    def test_real_subprocess_timeout_is_reported_and_batch_continues(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "example.rs"
            source.write_text("example_prelude::run_example(scenario)", encoding="utf-8")
            metadata = {
                "target_directory": str(root / "target"),
                "packages": [{"name": "gpui-ce", "targets": [
                    {"name": name, "kind": ["example"], "src_path": str(source)}
                    for name in ("slow", "quick")
                ]}],
            }
            launched = []
            started = time.monotonic()

            def run(command, **kwargs):
                if command[0] == "cargo" and "metadata" in command:
                    return subprocess.CompletedProcess(command, 0, json.dumps(metadata), "")
                if command[0] == "cargo":
                    return subprocess.CompletedProcess(command, 0)
                if Path(command[0]).name == "slow":
                    return subprocess.run(
                        [sys.executable, "-c", "import time; time.sleep(5)"], **kwargs
                    )
                launched.append(Path(command[0]).name)
                return subprocess.CompletedProcess(command, 0)

            output = []
            result = capture(root / "Cargo.toml", root / "config.toml", root / "out", debug=True,
                             run=run, emit=output.append, timeout=0.1)
            elapsed = time.monotonic() - started
            self.assertEqual(result, 1)
            self.assertIn("FAIL slow: capture timed out after 0.1s", output)
            self.assertLess(elapsed, 2.0)
            self.assertEqual(launched, ["quick"])
            self.assertTrue(any(line.startswith("PASS quick:") for line in output))


if __name__ == "__main__":
    unittest.main()
