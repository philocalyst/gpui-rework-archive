import importlib.util
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

MODULE = Path(__file__).with_name("agent_session.py")
if not MODULE.exists():
    MODULE = Path(__file__).parents[1] / "agent_session.py"
spec = importlib.util.spec_from_file_location("agent_session", MODULE)
assert spec and spec.loader
agent = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = agent
spec.loader.exec_module(agent)

SYNC_SCRIPT = MODULE.with_name("sync_upstream.py")
sys.path.insert(0, str(SYNC_SCRIPT.parent))
sync_spec = importlib.util.spec_from_file_location("sync_upstream_for_invariants", SYNC_SCRIPT)
assert sync_spec and sync_spec.loader
sync = importlib.util.module_from_spec(sync_spec)
sys.modules[sync_spec.name] = sync
sync_spec.loader.exec_module(sync)


def git(repo: Path, *args: str) -> str:
    return subprocess.run(
        ["git", *args], cwd=repo, text=True, stdout=subprocess.PIPE,
        stderr=subprocess.PIPE, check=True,
    ).stdout.strip()


class AgentSessionTests(unittest.TestCase):
    def repo(self) -> Path:
        temp = tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        root = Path(temp.name)
        git(root, "init", "-q")
        git(root, "config", "user.name", "Test")
        git(root, "config", "user.email", "test@example.invalid")
        (root / "tracked.txt").write_text("base\n")
        git(root, "add", "tracked.txt")
        git(root, "commit", "-qm", "base")
        git(root, "update-ref", "refs/heads/vendor/zed-gpui", "HEAD")
        return root

    def test_external_checkpoint_resumes_and_scopes_paths(self) -> None:
        root = self.repo()
        session = agent.AgentSession.create(
            root, session_id="fixture-1", phase="resolve", prompt="resolve only tracked.txt",
            backend="external", model="chatgpt",
            context={"vendor_ref": "refs/heads/vendor/zed-gpui", "target": git(root, "rev-parse", "HEAD"),
                     "conflict_paths": ["tracked.txt"]},
        )
        loaded = agent.AgentSession.load(root, "fixture-1")
        self.assertEqual(loaded.prompt, "resolve only tracked.txt")
        (root / "tracked.txt").write_text("resolved\n")
        self.assertEqual(loaded.validate_resume(allowed_paths={"tracked.txt"}), ["tracked.txt"])
        artifact = loaded.capture("diff.patch", b"diff --git a/tracked.txt b/tracked.txt\n")
        self.assertTrue(artifact.is_file())
        self.assertEqual(loaded.checkpoint["phase"], "resolve")

    def test_resume_rejects_branch_head_drift(self) -> None:
        root = self.repo()
        session = agent.AgentSession.create(
            root, session_id="fixture-2", phase="verify", prompt="fix build",
            backend="external", model="chatgpt",
            context={"vendor_ref": "refs/heads/vendor/zed-gpui", "attempt": 1},
        )
        git(root, "checkout", "-qb", "unexpected")
        with self.assertRaisesRegex(agent.SessionError, "branch changed"):
            session.validate_resume()

    def test_resume_rejects_untracked_or_out_of_scope_changes(self) -> None:
        root = self.repo()
        session = agent.AgentSession.create(
            root, session_id="fixture-3", phase="resolve", prompt="resolve",
            backend="external", model="chatgpt",
            context={"vendor_ref": "refs/heads/vendor/zed-gpui"},
        )
        (root / "scratch.tmp").write_text("do not stage")
        with self.assertRaisesRegex(agent.SessionError, "untracked"):
            session.validate_resume()
        (root / "scratch.tmp").unlink()
        (root / "tracked.txt").write_text("modified")
        with self.assertRaisesRegex(agent.SessionError, "out-of-scope"):
            session.validate_resume(allowed_paths={"other.txt"})

    def test_resume_rejects_rename_outside_conflict_scope(self) -> None:
        root = self.repo()
        session = agent.AgentSession.create(
            root, session_id="fixture-rename", phase="resolve", prompt="resolve",
            backend="external", model="chatgpt",
            context={"vendor_ref": "refs/heads/vendor/zed-gpui"},
        )
        git(root, "mv", "tracked.txt", "escaped.txt")
        with self.assertRaisesRegex(agent.SessionError, "out-of-scope"):
            session.validate_resume(allowed_paths={"tracked.txt"})

    def test_resume_rejects_prompt_tampering(self) -> None:
        root = self.repo()
        session = agent.AgentSession.create(
            root, session_id="fixture-prompt", phase="resolve", prompt="original prompt",
            backend="external", model="chatgpt",
            context={"vendor_ref": "refs/heads/vendor/zed-gpui"},
        )
        (session.directory / "resolve.prompt.md").write_text("tampered")
        with self.assertRaisesRegex(agent.SessionError, "prompt digest mismatch"):
            session.validate_resume()

    def test_upstream_gpui_inventory_requires_explicit_tracking_or_exclusion(self) -> None:
        temp = tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        root = Path(temp.name)
        git(root, "init", "-q", "-b", "main")
        git(root, "config", "user.name", "Test")
        git(root, "config", "user.email", "test@example.invalid")
        for crate in ("gpui", "gpui_apple", "gpui_ios"):
            crate_dir = root / "crates" / crate
            crate_dir.mkdir(parents=True)
            (crate_dir / "Cargo.toml").write_text("[package]\n")
        git(root, "add", "crates")
        git(root, "commit", "-qm", "tracked GPUI inventory")
        target = git(root, "rev-parse", "HEAD")

        previous_root = sync.REPO_ROOT
        sync.REPO_ROOT = root
        try:
            self.assertEqual(
                sync.TRACKED_CRATES["gpui_apple"], "gpui_apple"
            )
            self.assertEqual(
                sync.TRACKED_CRATES["gpui_ios"], "gpui_ios"
            )
            sync.validate_upstream_crate_inventory(target)
            unknown = root / "crates" / "gpui_new_platform"
            unknown.mkdir()
            (unknown / "Cargo.toml").write_text("[package]\n")
            git(root, "add", "crates/gpui_new_platform")
            git(root, "commit", "-qm", "new unmapped GPUI crate")
            with self.assertRaisesRegex(sync.SyncError, "unmapped GPUI crate"):
                sync.validate_upstream_crate_inventory(git(root, "rev-parse", "HEAD"))
        finally:
            sync.REPO_ROOT = previous_root

    def test_vendor_history_fails_closed_when_listing_omits_tree_change(self) -> None:
        temp = tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        root = Path(temp.name)
        git(root, "init", "-q", "-b", "main")
        git(root, "config", "user.name", "Test")
        git(root, "config", "user.email", "test@example.invalid")
        tracked = root / "crates" / "gpui"
        tracked.mkdir(parents=True)
        value = tracked / "value.txt"
        value.write_text("base\n")
        git(root, "add", "crates/gpui/value.txt")
        git(root, "commit", "-qm", "base")
        base = git(root, "rev-parse", "HEAD")
        value.write_text("target\n")
        git(root, "commit", "-qam", "target")
        target = git(root, "rev-parse", "HEAD")

        previous_root = sync.REPO_ROOT
        previous_gout = sync.gout
        sync.REPO_ROOT = root
        sync.gout = lambda *args, **kwargs: (
            "" if args and args[0] == "rev-list" else previous_gout(*args, **kwargs)
        )
        try:
            vendor_base = sync.build_vendor_snapshot(base)
            with self.assertRaisesRegex(sync.SyncError, "filtered vendor replay is incomplete"):
                sync.build_vendor_history(vendor_base, base, target)
        finally:
            sync.REPO_ROOT = previous_root
            sync.gout = previous_gout

    def test_codex_command_uses_supported_sandbox_and_stdin_prompt(self) -> None:
        output = Path("/tmp/last-message.md")
        argv = agent.codex_exec_argv("codex", output)
        self.assertEqual(argv, [
            "codex", "exec", "--json", "--sandbox", "workspace-write",
            "--output-last-message", "/tmp/last-message.md", "-",
        ])
        self.assertEqual(
            agent.codex_exec_argv("codex", output, "gpt-6.1-codex"),
            [
                "codex", "exec", "--model", "gpt-6.1-codex",
                "--json", "--sandbox", "workspace-write",
                "--output-last-message", "/tmp/last-message.md", "-",
            ],
        )
        self.assertNotIn("--full-auto", argv)
        self.assertNotIn("CODEX_API_KEY", argv)
        child_env = agent.codex_exec_env({
            "CODEX_API_KEY": "secret", "OPENAI_API_KEY": "secret",
            "GITHUB_TOKEN": "secret", "SSH_AUTH_SOCK": "/tmp/agent",
            "PATH": "/bin",
        })
        for key in ("CODEX_API_KEY", "OPENAI_API_KEY", "GITHUB_TOKEN", "SSH_AUTH_SOCK"):
            self.assertNotIn(key, child_env)
        self.assertEqual(child_env["GIT_CONFIG_VALUE_0"], "")


if __name__ == "__main__":
    unittest.main()
