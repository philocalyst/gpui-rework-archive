#!/usr/bin/env python3
"""Make a locally runnable macOS application bundle from the native guide."""
from pathlib import Path
import json
import plistlib
import shutil
import subprocess
import sys
ROOT = Path(__file__).resolve().parents[2]
if sys.platform != "darwin":
    raise SystemExit("This script packages the macOS guide; use cargo run on Linux/Windows.")
subprocess.run(["cargo", "build", "-p", "gpui_ce_codepen", "--bin", "gpui-guide"], cwd=ROOT, check=True)
metadata = json.loads(subprocess.check_output(["cargo", "metadata", "--no-deps", "--format-version", "1"], cwd=ROOT))
bundle = ROOT / "build/GPUI Guide.app/Contents"
(bundle / "MacOS").mkdir(parents=True, exist_ok=True)
shutil.copy2(Path(metadata["target_directory"]) / "debug/gpui-guide", bundle / "MacOS/gpui-guide")
with (bundle / "Info.plist").open("wb") as file:
    plistlib.dump({"CFBundleExecutable": "gpui-guide", "CFBundleIdentifier": "dev.gpui.codepen-guide",
                  "CFBundleName": "GPUI Guide", "CFBundleDisplayName": "GPUI Guide",
                  "CFBundlePackageType": "APPL", "CFBundleVersion": "1", "NSHighResolutionCapable": True}, file)
print(bundle.parent)
