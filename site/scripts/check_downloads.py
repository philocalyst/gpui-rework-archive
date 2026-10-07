#!/usr/bin/env python3
"""Compile the Cargo projects readers download, including their setup code."""

import os
from pathlib import Path
import subprocess
import tempfile
import tomllib
import zipfile

ROOT = Path(__file__).resolve().parents[2]


def main() -> None:
    metadata = tomllib.loads((ROOT / "site/examples.toml").read_text())
    target = ROOT / "target"
    target.mkdir(exist_ok=True)
    env = os.environ.copy()
    env["CARGO_TARGET_DIR"] = str(target)
    for example in metadata["examples"]:
        slug = example["slug"]
        archive = ROOT / f"site/static/examples/{slug}.zip"
        with tempfile.TemporaryDirectory(dir=target, prefix=f"docs-{slug}-") as directory:
            project = Path(directory)
            with zipfile.ZipFile(archive) as download:
                if download.namelist() != ["Cargo.toml", "src/main.rs"]:
                    raise ValueError(f"{archive}: unexpected download structure")
                download.extractall(project)
            subprocess.run(["cargo", "check", "--manifest-path", str(project / "Cargo.toml")], cwd=ROOT, env=env, check=True)
        print(f"Download compiled: {slug}", flush=True)


if __name__ == "__main__":
    main()
