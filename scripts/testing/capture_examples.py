#!/usr/bin/env python3
"""Build and capture Cargo examples that opt into the shared example prelude."""

import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from typing import Callable


CAPTURE_ENTRYPOINT = re.compile(r"example_prelude\s*::\s*run_example(?:_with_assets)?\s*\(")


def cargo_command(subcommand: str, manifest: Path, cargo_config: Path, *args: str) -> list[str]:
    return ["cargo", "--config", str(cargo_config), subcommand, "--manifest-path", str(manifest), *args]


def discover_examples(
    manifest: Path,
    cargo_config: Path,
    run: Callable[..., subprocess.CompletedProcess] = subprocess.run,
) -> tuple[Path, list[str]]:
    result = run(
        cargo_command("metadata", manifest, cargo_config, "--no-deps", "--format-version", "1"),
        check=True,
        text=True,
        capture_output=True,
    )
    metadata = json.loads(result.stdout)
    package = next(item for item in metadata["packages"] if item["name"] == "gpui-ce")
    names = []
    for target in package["targets"]:
        if "example" not in target["kind"]:
            continue
        source = Path(target["src_path"])
        if CAPTURE_ENTRYPOINT.search(source.read_text(encoding="utf-8")):
            names.append(target["name"])
    return Path(metadata["target_directory"]), sorted(names)


def executable_path(target_directory: Path, profile: str, name: str, windows: bool | None = None) -> Path:
    if windows is None:
        windows = os.name == "nt"
    filename = name + (".exe" if windows else "")
    return target_directory / profile / "examples" / filename


def capture(
    manifest: Path,
    cargo_config: Path,
    output: Path,
    baseline: Path | None = None,
    samples: int = 20,
    debug: bool = False,
    run: Callable[..., subprocess.CompletedProcess] = subprocess.run,
    emit: Callable[[str], None] = print,
    timeout: float = 60.0,
) -> int:
    if timeout <= 0:
        raise ValueError("timeout must be positive")
    manifest = manifest.resolve()
    cargo_config = cargo_config.resolve()
    output = output.resolve()
    baseline = baseline.resolve() if baseline else None
    target_directory, examples = discover_examples(manifest, cargo_config, run)
    if not examples:
        raise ValueError("no gpui-ce examples call example_prelude::run_example")
    profile = "debug" if debug else "release"
    build = cargo_command("build", manifest, cargo_config, "--locked", "-p", "gpui-ce", "--examples")
    if not debug:
        build.append("--release")
    emit(f"Building all gpui-ce examples ({profile})")
    run(build, check=True)

    failed = False
    for name in examples:
        executable = executable_path(target_directory, profile, name)
        output_directory = output / name
        command = [
            str(executable),
            "--capture",
            "--output",
            str(output_directory),
            "--samples",
            str(samples),
        ]
        baseline_directory = baseline / name if baseline else None
        if baseline_directory and baseline_directory.is_dir():
            command.extend(("--baseline", str(baseline_directory)))
        try:
            result = run(command, check=False, timeout=timeout)
        except subprocess.TimeoutExpired:
            emit(f"FAIL {name}: capture timed out after {timeout:g}s")
            failed = True
            continue
        except OSError as error:
            emit(f"FAIL {name}: {error}")
            failed = True
            continue
        if result.returncode:
            emit(f"FAIL {name}: capture exited with status {result.returncode}")
            failed = True
        else:
            emit(f"PASS {name}: {output_directory}")
    emit("Example capture batch failed" if failed else f"Captured {len(examples)} examples")
    return 1 if failed else 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=Path("example-captures"))
    parser.add_argument("--baseline", type=Path)
    parser.add_argument("--samples", type=int, default=20)
    parser.add_argument("--timeout", type=float, default=60.0, help="per-example capture timeout in seconds")
    parser.add_argument("--debug", action="store_true", help="build and capture debug executables")
    args = parser.parse_args()
    if args.samples < 1 or args.timeout <= 0:
        parser.error("--samples and --timeout must be positive")
    root = Path(__file__).resolve().parents[2]
    try:
        return capture(
            root / "Cargo.toml",
            root / ".cargo" / "config.toml",
            args.output,
            args.baseline,
            args.samples,
            args.debug,
            timeout=args.timeout,
        )
    except subprocess.CalledProcessError as error:
        print(f"Example capture setup failed: {error}", file=sys.stderr)
        return error.returncode or 1
    except (KeyError, StopIteration, json.JSONDecodeError, ValueError) as error:
        print(f"Could not discover gpui-ce examples: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
