from __future__ import annotations

import hashlib
import json
import os
import subprocess
import tempfile
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any, cast

SESSION_VERSION = 1
PAUSE_EXIT = 75


class SessionError(RuntimeError):
    pass


def _git(repo: Path, *args: str) -> str:
    result = subprocess.run(
        ["git", *args], cwd=repo, text=True, stdout=subprocess.PIPE,
        stderr=subprocess.PIPE, check=False,
    )
    if result.returncode:
        raise SessionError(f"git {' '.join(args)} failed: {result.stderr.strip()}")
    return result.stdout.rstrip("\n")


def _sha(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _git_optional(repo: Path, *args: str) -> str | None:
    result = subprocess.run(
        ["git", *args], cwd=repo, text=True, stdout=subprocess.PIPE,
        stderr=subprocess.PIPE, check=False,
    )
    return result.stdout.rstrip("\n") if result.returncode == 0 else None


def _git_path(repo: Path, path: str) -> Path:
    value = _git(repo, "rev-parse", "--git-path", path)
    out = Path(value)
    return out if out.is_absolute() else repo / out


def _snapshot(repo: Path, vendor_ref: str) -> dict[str, Any]:
    branch = _git(repo, "branch", "--show-current")
    head = _git(repo, "rev-parse", "HEAD")
    merge_head = _git_optional(repo, "rev-parse", "-q", "--verify", "MERGE_HEAD")
    vendor = _git_optional(repo, "rev-parse", "-q", "--verify", f"{vendor_ref}^{{commit}}")
    porcelain = subprocess.run(
        ["git", "status", "--porcelain=v1", "-z"], cwd=repo,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=False,
    )
    if porcelain.returncode:
        raise SessionError("could not inspect worktree status")
    raw_entries = [item.decode("utf-8", "surrogateescape")
                   for item in porcelain.stdout.split(b"\0") if item]
    entries: list[dict[str, Any]] = []
    index = 0
    while index < len(raw_entries):
        entry = raw_entries[index]
        code, path = entry[:2], entry[3:]
        paths = [path]
        if "R" in code or "C" in code:
            index += 1
            if index < len(raw_entries):
                paths.append(raw_entries[index])
        entries.append({"code": code, "paths": paths})
        index += 1
    return {
        "branch": branch,
        "head": head,
        "merge_head": merge_head,
        "vendor_tip": vendor,
        "status_sha256": _sha(porcelain.stdout),
        "status_entries": entries,
    }


def _atomic_json(path: Path, data: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    encoded = (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()
    fd, name = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    try:
        with os.fdopen(fd, "wb") as stream:
            stream.write(encoded)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(name, path)
        directory_fd = os.open(path.parent, os.O_RDONLY)
        try:
            os.fsync(directory_fd)
        finally:
            os.close(directory_fd)
    finally:
        if os.path.exists(name):
            os.unlink(name)


@dataclass(frozen=True)
class AgentSession:
    repo: Path
    session_id: str
    directory: Path
    checkpoint: dict[str, Any]

    @classmethod
    def create(cls, repo: Path, *, session_id: str, phase: str, prompt: str,
               backend: str, model: str, context: dict[str, Any]) -> "AgentSession":
        repo = repo.resolve()
        if phase not in {"resolve", "verify"}:
            raise SessionError(f"unsupported phase: {phase}")
        if backend not in {"external", "codex", "claude"}:
            raise SessionError(f"unsupported backend: {backend}")
        directory = _git_path(repo, f"sync-upstream-sessions/{session_id}")
        if directory.exists():
            raise SessionError(f"session already exists: {session_id}")
        directory.mkdir(parents=True)
        prompt_path = directory / f"{phase}.prompt.md"
        prompt_path.write_text(prompt, encoding="utf-8")
        checkpoint = {
            "version": SESSION_VERSION,
            "session_id": session_id,
            "phase": phase,
            "backend": backend,
            "model": model,
            "context": context,
            "snapshot": _snapshot(repo, str(context.get("vendor_ref", "refs/heads/vendor/zed-gpui"))),
            "prompt_file": prompt_path.name,
            "prompt_sha256": _sha(prompt.encode()),
            "created_unix": int(time.time()),
            "attempt": int(context.get("attempt", 0)),
        }
        _atomic_json(directory / "session.json", checkpoint)
        (directory / "audit.jsonl").write_text("", encoding="utf-8")
        session = cls(repo, session_id, directory, checkpoint)
        session.audit("prompt-created", {"phase": phase, "prompt_sha256": checkpoint["prompt_sha256"]})
        return session

    @classmethod
    def load(cls, repo: Path, session_id: str) -> "AgentSession":
        repo = repo.resolve()
        directory = _git_path(repo, f"sync-upstream-sessions/{session_id}")
        try:
            checkpoint = json.loads((directory / "session.json").read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise SessionError(f"cannot load session {session_id}: {exc}") from exc
        if checkpoint.get("version") != SESSION_VERSION or checkpoint.get("session_id") != session_id:
            raise SessionError("unsupported or mismatched session checkpoint")
        return cls(repo, session_id, directory, checkpoint)

    @property
    def prompt(self) -> str:
        path = self.directory / str(self.checkpoint["prompt_file"])
        content = path.read_text(encoding="utf-8")
        if _sha(content.encode()) != self.checkpoint.get("prompt_sha256"):
            raise SessionError("saved prompt digest mismatch")
        return content

    def validate_resume(self, *, allowed_paths: set[str] | None = None,
                        require_clean: bool = False) -> list[str]:
        _ = self.prompt
        context = self.checkpoint["context"]
        target = context.get("target")
        if isinstance(target, str):
            actual_target = _git_optional(self.repo, "rev-parse", "--verify", f"{target}^{{commit}}")
            if actual_target != target:
                raise SessionError("resume rejected: pinned upstream target is unavailable or changed")
        expected = self.checkpoint["snapshot"]
        current = _snapshot(self.repo, str(context.get(
            "vendor_ref", "refs/heads/vendor/zed-gpui")))
        for key in ("branch", "head", "merge_head", "vendor_tip"):
            if current[key] != expected[key]:
                raise SessionError(f"resume rejected: {key} changed")
        entries = current["status_entries"]
        paths: set[str] = set()
        untracked: list[str] = []
        for entry in entries:
            code = str(entry["code"])
            entry_paths = cast(list[str], entry["paths"])
            paths.update(entry_paths)
            if code == "??":
                untracked.extend(entry_paths)
        if untracked:
            raise SessionError("resume rejected: untracked files present: " + ", ".join(sorted(untracked)))
        if allowed_paths is not None:
            unexpected = paths - allowed_paths
            if unexpected:
                raise SessionError("resume rejected: out-of-scope changes: " + ", ".join(sorted(unexpected)))
        if require_clean and entries:
            raise SessionError("resume rejected: worktree is not clean")
        self.audit("resume-validated", {"paths": sorted(paths), "status_sha256": current["status_sha256"]})
        return sorted(paths)

    def audit(self, event: str, data: dict[str, Any]) -> None:
        record = {"event": event, "unix": int(time.time()), **data}
        path = self.directory / "audit.jsonl"
        with path.open("a", encoding="utf-8") as stream:
            stream.write(json.dumps(record, sort_keys=True) + "\n")

    def capture(self, name: str, data: bytes) -> Path:
        path = self.directory / name
        path.write_bytes(data)
        self.audit("artifact", {"name": name, "sha256": _sha(data), "bytes": len(data)})
        return path

    def complete(self, outcome: str) -> None:
        checkpoint = dict(self.checkpoint)
        checkpoint["outcome"] = outcome
        checkpoint["completed_unix"] = int(time.time())
        _atomic_json(self.directory / "session.json", checkpoint)
        self.audit("completed", {"outcome": outcome})


def codex_exec_argv(binary: str, output_path: Path, model: str | None = None) -> list[str]:
    """Current documented invocation; omit --model to keep Codex's configured default."""
    argv = [binary, "exec"]
    if model:
        argv.extend(["--model", model])
    argv.extend([
        "--json", "--sandbox", "workspace-write",
        "--output-last-message", str(output_path), "-",
    ])
    return argv


def codex_exec_env(source: dict[str, str] | None = None) -> dict[str, str]:
    """Keep saved Codex login available but remove inherited API/GitHub/git credentials."""
    env = dict(os.environ if source is None else source)
    for key in (
        "CODEX_API_KEY", "OPENAI_API_KEY", "GITHUB_TOKEN", "GH_TOKEN",
        "GH_ENTERPRISE_TOKEN", "GIT_ASKPASS", "SSH_ASKPASS", "SSH_AUTH_SOCK",
    ):
        env.pop(key, None)
    env["GIT_TERMINAL_PROMPT"] = "0"
    env["GIT_CONFIG_NOSYSTEM"] = "1"
    env["GIT_CONFIG_GLOBAL"] = os.devnull
    env["GIT_CONFIG_COUNT"] = "1"
    env["GIT_CONFIG_KEY_0"] = "credential.helper"
    env["GIT_CONFIG_VALUE_0"] = ""
    return env
