from __future__ import annotations

import importlib.util
import json
import os
import subprocess
import sys
import tempfile
import shutil
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
SCRIPT = Path(os.environ.get("SYNC_TEST_SCRIPT", ROOT / "scripts" / "sync-upstream" / "sync_upstream.py"))
sys.path.insert(0, str(SCRIPT.parent))


def git(cwd: Path, *args: str, check: bool = True) -> str:
    result = subprocess.run(
        ["git", *args],
        cwd=cwd,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if check and result.returncode:
        raise AssertionError(f"git {args} failed: {result.stderr}")
    return result.stdout.strip()


def init_repo(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)
    git(path, "init", "-b", "main")
    git(path, "config", "user.name", "Sync Fixture")
    git(path, "config", "user.email", "sync-fixture@example.invalid")


def commit(cwd: Path, message: str) -> str:
    git(cwd, "add", "-A")
    git(cwd, "commit", "-m", message)
    return git(cwd, "rev-parse", "HEAD")


def load_sync_module():
    source = SCRIPT
    holder = None
    if not (source.parent / ".git").exists():
        holder = tempfile.TemporaryDirectory(prefix="sync-script-repo-")
        script_dir = Path(holder.name) / "scripts" / "sync-upstream"
        script_dir.mkdir(parents=True)
        shutil.copy2(source, script_dir / "sync_upstream.py")
        sibling = source.parent / "agent_session.py"
        if sibling.exists():
            shutil.copy2(sibling, script_dir / "agent_session.py")
        subprocess.run(["git", "init", "-q", str(Path(holder.name))], check=True)
        source = script_dir / "sync_upstream.py"
        sys.path.insert(0, str(script_dir))
    spec = importlib.util.spec_from_file_location("sync_upstream_fixture", source)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    module._fixture_repo = holder
    return module


class SyncHistoryAudit(unittest.TestCase):
    def test_vendor_tree_includes_merge_only_resolution_delta(self) -> None:
        with tempfile.TemporaryDirectory(prefix="sync-history-merge-") as temp:
            base_dir = Path(temp)
            upstream = base_dir / "upstream"
            fork = base_dir / "fork"
            init_repo(upstream)

            tracked = upstream / "crates" / "gpui"
            tracked.mkdir(parents=True)
            (tracked / "value.txt").write_text("base\n")
            base = commit(upstream, "base")

            git(upstream, "switch", "-c", "topic")
            (tracked / "value.txt").write_text("topic-side\n")
            commit(upstream, "topic change")

            git(upstream, "switch", "main")
            (tracked / "value.txt").write_text("main-side\n")
            commit(upstream, "main change")
            merge = subprocess.run(
                ["git", "merge", "--no-ff", "topic", "-m", "merge topic"],
                cwd=upstream,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
            )
            self.assertNotEqual(merge.returncode, 0, "fixture should create a content conflict")
            (tracked / "value.txt").write_text("main-side\ntopic-side\nresolved-only\n")
            git(upstream, "add", "crates/gpui/value.txt")
            merge_sha = commit(upstream, "merge resolution")

            init_repo(fork)
            (fork / "README.md").write_text("fork\n")
            commit(fork, "fork root")
            git(fork, "remote", "add", "zed", str(upstream))
            git(fork, "fetch", "zed", "main", "topic")

            module = load_sync_module()
            if module._fixture_repo is not None:
                self.addCleanup(module._fixture_repo.cleanup)
            module.REPO_ROOT = fork
            module.ZED_REMOTE_NAME = "zed"
            vendor_base = module.build_vendor_snapshot(base)
            vendor_tip = module.build_vendor_history(vendor_base, base, merge_sha)

            actual_tree = git(fork, "rev-parse", f"{vendor_tip}^{{tree}}")
            expected_tree = module.filtered_tree(merge_sha)
            self.assertEqual(
                actual_tree,
                expected_tree,
                "filtered vendor replay must include the merge commit's resolution-only tree delta",
            )

    def test_failed_verification_does_not_advance_sync_state(self) -> None:
        with tempfile.TemporaryDirectory(prefix="sync-history-gate-") as temp:
            base_dir = Path(temp)
            upstream = base_dir / "upstream"
            fork = base_dir / "fork"
            init_repo(upstream)

            tracked = upstream / "crates" / "gpui"
            tracked.mkdir(parents=True)
            (tracked / "value.txt").write_text("base\n")
            base = commit(upstream, "base")
            (tracked / "value.txt").write_text("target\n")
            target = commit(upstream, "target change")

            init_repo(fork)
            fork_tracked = fork / "crates" / "gpui"
            fork_tracked.mkdir(parents=True)
            (fork_tracked / "value.txt").write_text("base\n")
            (fork / "README.md").write_text("fork\n")
            sync_dir = fork / "scripts" / "sync-upstream"
            sync_dir.mkdir(parents=True)
            state_path = sync_dir / "state.json"
            state_path.write_text("{}\n")
            commit(fork, "fork root")
            git(fork, "remote", "add", "zed", str(upstream))
            git(fork, "fetch", "zed", "main")

            module = load_sync_module()
            if module._fixture_repo is not None:
                self.addCleanup(module._fixture_repo.cleanup)
            module.REPO_ROOT = fork
            module.STATE_FILE = state_path
            module.ZED_REMOTE_NAME = "zed"
            module.VENDOR_BRANCH = "vendor/zed-gpui"
            vendor_tip = module.build_vendor_snapshot(base)
            git(fork, "update-ref", f"refs/heads/{module.VENDOR_BRANCH}", vendor_tip)
            git(
                fork,
                "merge",
                "-s",
                "ours",
                "--allow-unrelated-histories",
                "--no-edit",
                "-m",
                "record baseline",
                vendor_tip,
            )
            state_path.write_text(
                json.dumps(
                    {
                        "last_synced_sha": base,
                        "vendor_tip": vendor_tip,
                        "last_synced_date": "fixture",
                        "upstream_url": str(upstream),
                        "upstream_ref": "main",
                    }
                )
                + "\n"
            )
            commit(fork, "initialize sync state")
            module.RT.zed_ref = "main"
            module.RT.dry_run = False
            module.RT.bump_zed_deps = False
            module.verify_fix_loop = lambda: False

            with self.assertRaisesRegex(module.SyncError, "verification failed"):
                module.cmd_sync(None)
            state = json.loads(state_path.read_text())
            self.assertEqual(
                state["last_synced_sha"],
                base,
                "a failed build/test gate must leave last_synced_sha retryable",
            )
            self.assertNotEqual(state["last_synced_sha"], target)


    def test_filtered_tree_remaps_nested_crates_and_tracks_moves_and_deletions(self) -> None:
        with tempfile.TemporaryDirectory(prefix="sync-history-mapping-") as temp:
            base_dir = Path(temp)
            upstream = base_dir / "upstream"
            fork = base_dir / "fork"
            init_repo(upstream)

            (upstream / "crates/gpui/src").mkdir(parents=True)
            (upstream / "crates/gpui/src/core.rs").write_text("core\n")
            (upstream / "crates/collections/src").mkdir(parents=True)
            (upstream / "crates/collections/src/collection.rs").write_text("collection\n")
            (upstream / "crates/refineable/src").mkdir(parents=True)
            (upstream / "crates/refineable/src/lib.rs").write_text("refineable\n")
            (upstream / "crates/refineable/derive_refineable/src").mkdir(parents=True)
            (upstream / "crates/refineable/derive_refineable/src/lib.rs").write_text("derive\n")
            old_path = upstream / "crates/util/src/rel_path.rs"
            old_path.parent.mkdir(parents=True)
            old_path.write_text("pub struct RelPath;\n")
            base = commit(upstream, "baseline tracked crates")

            shutil.rmtree(upstream / "crates/collections")
            new_path = upstream / "crates/path/src/rel_path.rs"
            new_path.parent.mkdir(parents=True)
            old_path.unlink()
            new_path.write_text("pub struct RelPath;\n")
            target = commit(upstream, "delete crate and move file")

            init_repo(fork)
            (fork / "README.md").write_text("fork\n")
            commit(fork, "fork root")
            git(fork, "remote", "add", "zed", str(upstream))
            git(fork, "fetch", "zed", "main")

            module = load_sync_module()
            if module._fixture_repo is not None:
                self.addCleanup(module._fixture_repo.cleanup)
            module.REPO_ROOT = fork
            vendor_base = module.build_vendor_snapshot(base)
            base_paths = git(fork, "ls-tree", "-r", "--name-only", vendor_base).splitlines()
            self.assertIn("crates/gpui_collections/src/collection.rs", base_paths)
            self.assertIn("crates/gpui_refineable/src/lib.rs", base_paths)
            self.assertIn("crates/gpui_derive_refineable/src/lib.rs", base_paths)
            self.assertNotIn("crates/gpui_refineable/derive_refineable/src/lib.rs", base_paths)
            self.assertIn("crates/gpui_zed_util/src/rel_path.rs", base_paths)

            vendor_tip = module.build_vendor_history(vendor_base, base, target)
            target_paths = git(fork, "ls-tree", "-r", "--name-only", vendor_tip).splitlines()
            self.assertNotIn("crates/gpui_collections/src/collection.rs", target_paths)
            self.assertNotIn("crates/gpui_zed_util/src/rel_path.rs", target_paths)
            self.assertIn("crates/gpui_path/src/rel_path.rs", target_paths)
            self.assertEqual(
                module.detect_moves(vendor_base, vendor_tip),
                {"crates/gpui_zed_util/src/rel_path.rs": "crates/gpui_path/src/rel_path.rs"},
            )
            self.assertEqual(
                git(fork, "rev-parse", f"{vendor_tip}^{{tree}}"),
                module.filtered_tree(target),
            )

    def test_binary_conflict_stops_before_raw_merge_commit(self) -> None:
        with tempfile.TemporaryDirectory(prefix="sync-history-binary-") as temp:
            base_dir = Path(temp)
            upstream = base_dir / "upstream"
            fork = base_dir / "fork"
            init_repo(upstream)
            upstream_file = upstream / "crates" / "gpui" / "asset.bin"
            upstream_file.parent.mkdir(parents=True)
            upstream_file.write_bytes(b"\x00base")
            base = commit(upstream, "base")
            upstream_file.write_bytes(b"\x00upstream")
            commit(upstream, "upstream binary change")

            init_repo(fork)
            fork_file = fork / "crates" / "gpui" / "asset.bin"
            fork_file.parent.mkdir(parents=True)
            fork_file.write_bytes(b"\x00fork")
            sync_dir = fork / "scripts" / "sync-upstream"
            sync_dir.mkdir(parents=True)
            state_path = sync_dir / "state.json"
            state_path.write_text("{}\n")
            commit(fork, "fork root")
            git(fork, "remote", "add", "zed", str(upstream))
            git(fork, "fetch", "zed", "main")

            module = load_sync_module()
            if module._fixture_repo is not None:
                self.addCleanup(module._fixture_repo.cleanup)
            module.REPO_ROOT = fork
            module.STATE_FILE = state_path
            module.ZED_REMOTE_NAME = "zed"
            module.VENDOR_BRANCH = "vendor/zed-gpui"
            vendor_tip = module.build_vendor_snapshot(base)
            git(fork, "update-ref", f"refs/heads/{module.VENDOR_BRANCH}", vendor_tip)
            git(
                fork,
                "merge",
                "-s",
                "ours",
                "--allow-unrelated-histories",
                "--no-edit",
                "-m",
                "record baseline",
                vendor_tip,
            )
            state_path.write_text(
                json.dumps({
                    "last_synced_sha": base,
                    "vendor_tip": vendor_tip,
                    "last_synced_date": "fixture",
                    "upstream_url": str(upstream),
                    "upstream_ref": "main",
                }) + "\n"
            )
            commit(fork, "initialize sync state")
            module.RT.zed_ref = "main"
            module.RT.dry_run = False
            module.RT.bump_zed_deps = False

            with self.assertRaisesRegex(module.SyncError, "binary/markerless conflicts"):
                module.cmd_sync(None)
            self.assertTrue(git(fork, "rev-parse", "-q", "--verify", "MERGE_HEAD"))
            self.assertEqual(
                git(fork, "diff", "--name-only", "--diff-filter=U"),
                "crates/gpui/asset.bin",
                "the merge must remain explicitly unresolved for manual handling",
            )
            state = json.loads(state_path.read_text())
            self.assertEqual(state["last_synced_sha"], base)

if __name__ == "__main__":
    unittest.main()
