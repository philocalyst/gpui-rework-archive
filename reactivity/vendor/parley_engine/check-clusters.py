#!/usr/bin/env python3
"""Run the private long-coverage regression from published engine source.

The archive omits parley_dev and its test font fixtures. Disable only upstream
modules named `tests` in a temporary copy; keep production and GPUI test code
unchanged. Full glyph/source/position tests run through Canvas normally.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

source = Path(__file__).resolve().parent
with tempfile.TemporaryDirectory(prefix="gpui-parley012-clusters-") as directory:
    target = Path(directory)
    shutil.copytree(source / "src", target / "src")
    shutil.copy(source / "Cargo.toml", target / "Cargo.toml")
    for path in (target / "src").rglob("*.rs"):
        text = path.read_text()
        path.write_text(text.replace("#[cfg(test)]\nmod tests {", "#[cfg(any())]\nmod tests {"))
    subprocess.run(
        ["cargo", "test", "--offline", "--manifest-path", str(target / "Cargo.toml"),
         "--no-default-features", "--features", "std,complex-scripts", "--lib",
         "gpui_long_cluster_tests", "--jobs", "2"],
        check=True, env=os.environ,
    )
