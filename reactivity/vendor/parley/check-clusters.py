#!/usr/bin/env python3
"""Run the local mapper regression from the published crate's source.

The crates.io archive omits parley_dev, which its upstream `mod tests` imports.
Suppress that separate test module in a temporary copy; production source and
all local regression code remain unchanged. Public Canvas tests independently
check the complete glyph/source/caret path in debug and release.
"""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

source = Path(__file__).resolve().parent
with tempfile.TemporaryDirectory(prefix="gpui-parley-clusters-") as directory:
    target = Path(directory)
    shutil.copytree(source / "src", target / "src")
    shutil.copy(source / "Cargo.toml", target / "Cargo.toml")
    # The omitted upstream test helper is unrelated to our in-module regression.
    library = target / "src/lib.rs"
    text = library.read_text()
    declaration = "#[cfg(test)]\nmod tests;"
    assert text.count(declaration) == 1
    library.write_text(text.replace(declaration, "// Upstream archive test helper is not published."))
    subprocess.run(
        ["cargo", "test", "--offline", "--manifest-path", str(target / "Cargo.toml"),
         "--no-default-features", "--features", "std,complex-scripts", "--lib",
         "long_cluster_tests"],
        check=True,
        env=os.environ,
    )
