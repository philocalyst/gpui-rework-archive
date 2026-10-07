import sys
import subprocess
from pathlib import Path
import os
import tempfile
import time
import unittest
from unittest import mock

sys.path.insert(0, str(Path(__file__).resolve().parent))
import pseudo_mutation


class PseudoMutationRunnerTests(unittest.TestCase):
    def test_campaign_target_namespace_changes_per_run(self):
        root = Path("/tmp/gpui-mutation-cache")
        first = pseudo_mutation.campaign_target_dir(root, "abc123", "run-one")
        second = pseudo_mutation.campaign_target_dir(root, "abc123", "run-two")

        self.assertNotEqual(first, second)
        self.assertEqual(first.parent, root)
        self.assertEqual(second.parent, root)

    def test_baseline_identity_includes_required_environment(self):
        common = dict(
            description="test",
            source="source.rs",
            before="before",
            after="after",
            command_name="focused test",
            command=("cargo", "test", "example"),
        )
        cpu = pseudo_mutation.Mutant("cpu", **common)
        gpu = pseudo_mutation.Mutant(
            "gpu", **common, environment=(("GPUI_REQUIRE_GPU", "1"),)
        )

        self.assertNotEqual(
            pseudo_mutation.baseline_key(cpu), pseudo_mutation.baseline_key(gpu)
        )

    def test_preflight_requires_each_anchor_exactly_once(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.rs"
            mutant = pseudo_mutation.Mutant(
                "anchor", "test", "source.rs", "before", "after", "command", ("cargo", "test")
            )
            source.write_text("before\n", encoding="utf-8")
            self.assertEqual(pseudo_mutation.preflight_anchors(root, (mutant,)), [])

            source.write_text("before\nbefore\n", encoding="utf-8")
            self.assertIn("found 2", pseudo_mutation.preflight_anchors(root, (mutant,))[0])

    @unittest.skipIf(os.name == "nt", "process-group termination is POSIX-specific")
    def test_timeout_terminates_the_command_process_group(self):
        with tempfile.TemporaryDirectory() as directory:
            started = time.monotonic()
            result = pseudo_mutation.run_command(
                Path(directory),
                Path(directory) / "target",
                (
                    sys.executable,
                    "-c",
                    "import subprocess, time; subprocess.Popen(['sleep', '30']); time.sleep(30)",
                ),
                timeout=0.1,
            )

        self.assertEqual(result["status"], "timeout")
        self.assertLess(time.monotonic() - started, 5)

    def test_windows_timeout_uses_bounded_taskkill_tree_command(self):
        with mock.patch.object(pseudo_mutation.os, "name", "nt"), mock.patch.object(
            pseudo_mutation.subprocess, "run"
        ) as run:
            pseudo_mutation.terminate_process_tree(321, force=True)

        run.assert_called_once_with(
            ["taskkill", "/PID", "321", "/T", "/F"],
            check=False,
            stdout=pseudo_mutation.subprocess.DEVNULL,
            stderr=pseudo_mutation.subprocess.DEVNULL,
            timeout=5,
        )

    def test_timeout_after_failed_tree_cleanup_has_bounded_final_drain(self):
        process = mock.Mock(pid=321)
        process.communicate.side_effect = [
            subprocess.TimeoutExpired("test", 0.1, output="partial out", stderr="partial err"),
            subprocess.TimeoutExpired("test", 2, output="partial out", stderr="partial err"),
            subprocess.TimeoutExpired("test", 2, output="partial out", stderr="partial err"),
        ]
        with mock.patch.object(pseudo_mutation.subprocess, "Popen", return_value=process), mock.patch.object(
            pseudo_mutation, "terminate_process_tree", side_effect=OSError("taskkill unavailable")
        ):
            result = pseudo_mutation.run_command(Path("."), Path("target"), ("test",), timeout=1)

        self.assertEqual(result["status"], "timeout")
        self.assertIn("partial out", result["output"])
        self.assertIn("taskkill unavailable", result["output"])
        self.assertEqual(
            [call.kwargs["timeout"] for call in process.communicate.call_args_list],
            [1, 2, 2],
        )
        process.kill.assert_called_once_with()
        process.wait.assert_called_once_with(timeout=2)
        process.stdout.close.assert_called_once_with()
        process.stderr.close.assert_called_once_with()

    def test_cargo_commands_pin_the_checksum_freshness_toolchain(self):
        self.assertEqual(
            pseudo_mutation.prepared_command(("cargo", "test", "-p", "example")),
            (
                "cargo",
                "+nightly-2026-09-30",
                "-Zchecksum-freshness",
                "test",
                "--quiet",
                "-p",
                "example",
            ),
        )

    def test_each_trial_restores_source_before_the_next_mutant(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            source = root / "source.rs"
            original = b"first\nsecond\n"
            source.write_bytes(original)
            mutants = (
                pseudo_mutation.Mutant(
                    "first", "first edit", "source.rs", "first", "changed-first",
                    "first command", ("cargo", "test", "first"),
                ),
                pseudo_mutation.Mutant(
                    "second", "second edit", "source.rs", "second", "changed-second",
                    "second command", ("cargo", "test", "second"),
                ),
            )

            observed = []

            def observe_mutant(_root, _target, _command, _timeout, *_args):
                edited = source.read_bytes()
                observed.append(edited)
                return {"status": "survived", "elapsed_seconds": 0, "output": ""}

            with mock.patch.object(
                pseudo_mutation, "run_command", side_effect=observe_mutant
            ):
                for mutant in mutants:
                    pseudo_mutation.run_mutant(root, root / "target", mutant, 1)
                    self.assertEqual(source.read_bytes(), original)

            self.assertEqual(
                observed,
                [b"changed-first\nsecond\n", b"first\nchanged-second\n"],
            )


if __name__ == "__main__":
    unittest.main()
