#!/usr/bin/env python3
"""Site-local entry point for the repository documentation generator."""
from pathlib import Path
import runpy
import sys

root = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(root / "scripts" / "docs"))
sys.argv[0] = str(root / "scripts" / "docs" / "generate.py")
runpy.run_path(sys.argv[0], run_name="__main__")

