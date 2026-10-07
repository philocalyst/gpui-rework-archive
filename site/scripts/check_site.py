#!/usr/bin/env python3
from pathlib import Path
import runpy
import sys

root = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(root / "scripts" / "docs"))
sys.argv[0] = str(root / "scripts" / "docs" / "check_site.py")
runpy.run_path(sys.argv[0], run_name="__main__")

