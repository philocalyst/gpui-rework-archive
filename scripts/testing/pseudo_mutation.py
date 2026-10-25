#!/usr/bin/env python3
"""Run focused pseudo-source mutants in an isolated archive of HEAD.

The runner never edits the caller's checkout. Each trial restores its exact source file bytes
before running the next trial; a fresh temporary archive is discarded at exit. Each campaign gets
a unique Cargo cache under target/pseudo-mutation, keeping mutant executables out of normal builds
and ensuring prior campaigns cannot contaminate baseline checks.
"""
from __future__ import annotations

import argparse
import datetime as dt
import os
import pathlib
import signal
import subprocess
import sys
import tarfile
import tempfile
import time
from typing import Sequence


from mutation_catalog import Mutant, MUTANTS
from mutation_report import markdown_report

def git_root(path: pathlib.Path) -> pathlib.Path:
    result = subprocess.run(
        ["git", "-C", str(path), "rev-parse", "--show-toplevel"],
        check=True,
        capture_output=True,
        text=True,
    )
    return pathlib.Path(result.stdout.strip()).resolve()


def campaign_target_dir(cache_root: pathlib.Path, commit: str, run_id: str) -> pathlib.Path:
    return cache_root / f"{commit}-{run_id}"


def baseline_key(mutant: Mutant) -> tuple[tuple[str, ...], tuple[tuple[str, str], ...]]:
    return mutant.command, mutant.environment


def preflight_anchors(root: pathlib.Path, mutants: Sequence[Mutant]) -> list[str]:
    problems = []
    for mutant in mutants:
        path = root / mutant.source
        if not path.is_file():
            problems.append(f"{mutant.name}: missing mutation source {mutant.source}")
            continue
        occurrences = path.read_bytes().count(mutant.before.encode())
        if occurrences != 1:
            problems.append(
                f"{mutant.name}: expected one exact anchor in {mutant.source}, found {occurrences}"
            )
    return problems


def archive_revision(repo: pathlib.Path, destination: pathlib.Path, revision: str) -> None:
    archive_path = destination.parent / "head.tar"
    with archive_path.open("wb") as archive:
        subprocess.run(
            ["git", "-C", str(repo), "archive", "--format=tar", revision],
            check=True,
            stdout=archive,
        )
    with tarfile.open(archive_path, "r:") as archive:
        archive.extractall(destination, filter="data")
    archive_path.unlink()


def apply_mutation(root: pathlib.Path, mutant: Mutant) -> bytes:
    path = root / mutant.source
    original = path.read_bytes()
    needle = mutant.before.encode()
    occurrences = original.count(needle)
    if occurrences != 1:
        raise RuntimeError(
            f"{mutant.name}: expected one exact mutation anchor in {mutant.source}, found {occurrences}"
        )
    path.write_bytes(original.replace(needle, mutant.after.encode(), 1))
    return original


def classify(returncode: int, output: str, failure_marker: str | None = None) -> str:
    lowered = output.lower()
    if "running 0 tests" in lowered or "0 passed; 0 failed" in lowered:
        return "invalid"
    if any(token in lowered for token in ("could not compile", "error[e", "rustc-llvm error", "failed to run custom build command")):
        return "invalid"
    if returncode == 0:
        return "survived"
    assertion_output = any(
        token in lowered
        for token in (
            "assertion `left == right` failed",
            "assertion failed:",
            "assertion failed",
            "test failed: assertion",
        )
    )
    marked_failure = failure_marker is not None and failure_marker.lower() in lowered
    if "test result: failed" in lowered and (assertion_output or marked_failure):
        return "killed"
    return "invalid"


def concise_test_output(output: str) -> str:
    lines = output.splitlines()
    run_markers = [
        index
        for index, line in enumerate(lines)
        if line.startswith("Running ") or line.startswith("running ")
    ]
    if run_markers:
        lines = lines[run_markers[-1] :]
        concise: list[str] = []
        skip_warning = False
        for line in lines:
            if line.startswith("warning:"):
                skip_warning = True
                continue
            if skip_warning:
                if not line.strip():
                    skip_warning = False
                continue
            concise.append(line)
        return "\n".join(concise)[-5000:]

    error_markers = [
        index
        for index, line in enumerate(lines)
        if "error:" in line.lower() or "error[" in line.lower()
    ]
    if error_markers:
        start = max(0, error_markers[0] - 4)
        return "\n".join(lines[start:])[-5000:]
    return "\n".join(lines[-80:])[-5000:]


def terminate_process_tree(pid: int, *, force: bool = False) -> None:
    if os.name == "posix":
        # `Popen(start_new_session=True)` makes the child PID the new process-group ID.
        # Negative PIDs are portable through os.kill even on Python builds without os.killpg.
        os.kill(-pid, signal.SIGKILL if force else signal.SIGTERM)
    else:
        command = ["taskkill", "/PID", str(pid), "/T"]
        if force:
            command.append("/F")
        try:
            subprocess.run(
                command,
                check=False,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                timeout=5,
            )
        except subprocess.TimeoutExpired:
            # Do not let a broken taskkill invocation hang the runner indefinitely.
            pass


def display_command(
    command: tuple[str, ...], environment: tuple[tuple[str, str], ...] = ()
) -> str:
    command = prepared_command(command)
    prefix = " ".join(f"{key}={value}" for key, value in environment)
    return f"{prefix} {' '.join(command)}" if prefix else " ".join(command)


def prepared_command(command: tuple[str, ...]) -> tuple[str, ...]:
    if command[:2] == ("cargo", "test"):
        command = (
            "cargo",
            "+nightly-2026-09-30",
            "-Zchecksum-freshness",
            "test",
            "--quiet",
            *command[2:],
        )
    return command


def run_command(
    root: pathlib.Path,
    target_dir: pathlib.Path,
    command: tuple[str, ...],
    timeout: int,
    environment: tuple[tuple[str, str], ...] = (),
    failure_marker: str | None = None,
) -> dict[str, object]:
    env = os.environ.copy()
    env["CARGO_TARGET_DIR"] = str(target_dir)
    env["CARGO_INCREMENTAL"] = "0"
    env.update(environment)
    started = time.monotonic()
    quiet_command = prepared_command(command)
    process = subprocess.Popen(
        quiet_command,
        cwd=root,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        start_new_session=(os.name == "posix"),
    )
    try:
        stdout, stderr = process.communicate(timeout=timeout)
    except subprocess.TimeoutExpired:
        cleanup_notes = []
        try:
            terminate_process_tree(process.pid)
        except (ProcessLookupError, OSError) as error:
            cleanup_notes.append(f"process-tree termination warning: {error}")
        try:
            stdout, stderr = process.communicate(timeout=2)
        except subprocess.TimeoutExpired as graceful_timeout:
            stdout, stderr = timeout_output(graceful_timeout)
            try:
                terminate_process_tree(process.pid, force=True)
            except (ProcessLookupError, OSError) as error:
                cleanup_notes.append(f"forced process-tree termination warning: {error}")
            try:
                forced_stdout, forced_stderr = process.communicate(timeout=2)
                stdout = forced_stdout or stdout
                stderr = forced_stderr or stderr
            except subprocess.TimeoutExpired as forced_timeout:
                forced_stdout, forced_stderr = timeout_output(forced_timeout)
                stdout = forced_stdout or stdout
                stderr = forced_stderr or stderr
                try:
                    process.kill()
                    process.wait(timeout=2)
                except (OSError, subprocess.TimeoutExpired) as error:
                    cleanup_notes.append(f"direct child cleanup warning: {error}")
                for stream in (process.stdout, process.stderr):
                    if stream is not None:
                        stream.close()
                cleanup_notes.append("output pipes remained open after forced process-tree termination")
        output = stdout + stderr
        if cleanup_notes:
            output += "\n" + "\n".join(cleanup_notes)
        output = concise_test_output(output)
        return {
            "status": "timeout",
            "elapsed_seconds": round(time.monotonic() - started, 2),
            "exit_code": None,
            "output": output,
        }
    output = stdout + stderr
    return {
        "status": classify(process.returncode, output, failure_marker),
        "elapsed_seconds": round(time.monotonic() - started, 2),
        "exit_code": process.returncode,
        "output": concise_test_output(output),
    }


def timeout_output(error: subprocess.TimeoutExpired) -> tuple[str, str]:
    def as_text(value: str | bytes | None) -> str:
        if value is None:
            return ""
        return value.decode(errors="replace") if isinstance(value, bytes) else value

    return as_text(error.output), as_text(error.stderr)


def run_mutant(root: pathlib.Path, target_dir: pathlib.Path, mutant: Mutant, timeout: int) -> dict[str, object]:
    original = apply_mutation(root, mutant)
    try:
        result = run_command(
            root,
            target_dir,
            mutant.command,
            timeout,
            mutant.environment,
            mutant.failure_marker,
        )
        return {
            "name": mutant.name,
            "description": mutant.description,
            "command_name": mutant.command_name,
            "command": display_command(mutant.command, mutant.environment),
            **result,
        }
    finally:
        (root / mutant.source).write_bytes(original)




def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=pathlib.Path, default=pathlib.Path(__file__).resolve().parents[2], help="main checkout containing the committed HEAD")
    parser.add_argument("--revision", default="HEAD", help="committed revision to archive and test (defaults to HEAD)")
    parser.add_argument(
        "--target-dir",
        type=pathlib.Path,
        help="exact isolated Cargo cache to reuse; by default, a unique cache is created under <repo>/target/pseudo-mutation",
    )
    parser.add_argument("--timeout-seconds", type=int, default=300)
    parser.add_argument("--only", action="append", help="run only this mutant (repeat the option to select several)")
    parser.add_argument("--report", type=pathlib.Path, default=pathlib.Path("docs/testing/evidence/testing-mutations-run.md"), help="standalone Markdown result report written in the main checkout")
    parser.add_argument("--list", action="store_true", help="list mutants and focused tests without running them")
    args = parser.parse_args()

    repo = git_root(args.repo.resolve())
    cache_root = (repo / "target" / "pseudo-mutation").resolve()
    revision_sha = subprocess.run(
        ["git", "-C", str(repo), "rev-parse", args.revision],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    commit = revision_sha
    run_id = f"{time.time_ns()}-{os.getpid()}"
    target_dir = (
        args.target_dir.resolve()
        if args.target_dir
        else campaign_target_dir(cache_root, commit, run_id)
    )
    if args.list:
        for mutant in MUTANTS:
            print(
                f"{mutant.name}: {mutant.command_name}\n  "
                f"{display_command(mutant.command, mutant.environment)}"
            )
        return 0
    if args.timeout_seconds <= 0:
        parser.error("--timeout-seconds must be positive")
    selected = {mutant.name for mutant in MUTANTS} if not args.only else set(args.only)
    unknown = selected - {mutant.name for mutant in MUTANTS}
    if unknown:
        parser.error("unknown mutant name(s): " + ", ".join(sorted(unknown)))
    mutants = tuple(mutant for mutant in MUTANTS if mutant.name in selected)
    date = dt.datetime.now(dt.timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    report_path = args.report if args.report.is_absolute() else repo / args.report

    def save_report(
        results: Sequence[dict[str, object]],
        baselines: dict[
            tuple[tuple[str, ...], tuple[tuple[str, str], ...]], dict[str, object]
        ],
        *,
        complete: bool = False,
    ) -> None:
        report_path.parent.mkdir(parents=True, exist_ok=True)
        report_path.write_text(
            markdown_report(results, baselines, commit, date, target_dir, complete),
            encoding="utf-8",
        )

    results: list[dict[str, object]] = []
    with tempfile.TemporaryDirectory(prefix="gpui-pseudo-mutants-") as temporary:
        archive_root = pathlib.Path(temporary) / "checkout"
        archive_root.mkdir()
        archive_revision(repo, archive_root, revision_sha)
        anchor_problems = preflight_anchors(archive_root, mutants)
        if anchor_problems:
            results = [
                {
                    "name": mutant.name,
                    "description": mutant.description,
                    "command_name": mutant.command_name,
                    "command": display_command(mutant.command, mutant.environment),
                    "status": "invalid",
                    "elapsed_seconds": 0,
                    "exit_code": None,
                    "output": next(
                        (
                            problem
                            for problem in anchor_problems
                            if problem.startswith(f"{mutant.name}:")
                        ),
                        "preflight failed because another selected mutation anchor is invalid",
                    ),
                }
                for mutant in mutants
            ]
            save_report(results, {}, complete=True)
            print("Mutation preflight failed before Cargo baselines:", file=sys.stderr)
            for problem in anchor_problems:
                print(f"  {problem}", file=sys.stderr)
            print(f"Report: {report_path}")
            return 2
        baselines: dict[tuple[tuple[str, ...], tuple[tuple[str, str], ...]], dict[str, object]] = {}
        for mutant in mutants:
            key = baseline_key(mutant)
            if key not in baselines:
                print(f"[baseline] {mutant.command_name}", flush=True)
                baseline = run_command(
                    archive_root,
                    target_dir,
                    mutant.command,
                    args.timeout_seconds,
                    mutant.environment,
                )
                baseline["status"] = "passed" if baseline["status"] == "survived" else baseline["status"]
                baselines[key] = {
                    "command_name": mutant.command_name,
                    "command": display_command(mutant.command, mutant.environment),
                    **baseline,
                }
                save_report(results, baselines)
        for mutant in mutants:
            print(f"[{mutant.name}] {mutant.command_name}", flush=True)
            baseline = baselines[baseline_key(mutant)]
            if baseline["status"] != "passed":
                result = {
                    "name": mutant.name,
                    "description": mutant.description,
                    "command_name": mutant.command_name,
                    "command": display_command(mutant.command, mutant.environment),
                    "status": "invalid",
                    "elapsed_seconds": 0,
                    "exit_code": None,
                    "output": f"focused check did not pass before mutation ({baseline['status']})",
                }
            else:
                try:
                    result = run_mutant(archive_root, target_dir, mutant, args.timeout_seconds)
                except Exception as error:
                    result = {
                        "name": mutant.name,
                        "description": mutant.description,
                        "command_name": mutant.command_name,
                        "command": display_command(mutant.command, mutant.environment),
                        "status": "invalid",
                        "elapsed_seconds": 0,
                        "exit_code": None,
                        "output": f"mutation setup failed: {error}",
                    }
            results.append(result)
            save_report(results, baselines)
            print(f"  {result['status']} ({result['elapsed_seconds']} s)", flush=True)

    save_report(results, baselines, complete=True)
    counts = {status: sum(result["status"] == status for result in results) for status in ("killed", "survived", "invalid", "timeout")}
    print(f"Report: {report_path}")
    print("Results: " + ", ".join(f"{key}={value}" for key, value in counts.items()))
    if counts["invalid"] or counts["timeout"]:
        return 2
    return 1 if counts["survived"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
