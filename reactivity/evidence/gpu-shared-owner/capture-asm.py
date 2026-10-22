"""Capture actual hot entries from preserved release binaries (no timing)."""
import gzip
import hashlib
import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent
source = (ROOT / "final/source.txt").read_text().strip()
rows = {}
for label, binary, owner_type in (
    ("baseline", Path("/tmp/gpui-shared-gpu-controls/baseline/owned"), "Renderer"),
    ("final", Path("/tmp/gpui-shared-gpu-controls") / source / "owned", "RendererState"),
):
    symbols = subprocess.check_output(["nm", "-S", "-C", binary], text=True)
    (ROOT / f"final/{label}-gpu-symbols.txt").write_text("\n".join(line for line in symbols.splitlines() if "gpui_gpu::renderer" in line) + "\n")
    row = {"binary_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(), "entries": {}}
    for method in ("render", "redraw"):
        name = f"<gpui_gpu::renderer::{owner_type}>::{method}"
        matches = [line for line in symbols.splitlines() if line.endswith(name)]
        assert len(matches) == 1, (name, matches)
        address, size, _, _ = matches[0].split(maxsplit=3)
        asm = subprocess.check_output(["objdump", "-d", "-C", f"--start-address=0x{address}", f"--stop-address=0x{int(address, 16) + int(size, 16):x}", binary], text=True)
        (ROOT / f"final/{label}-{method}.asm.gz").write_bytes(gzip.compress(asm.encode(), mtime=0))
        (ROOT / f"final/{label}-{method}-entry.asm").write_text("\n".join(asm.splitlines()[:65]) + "\n")
        row["entries"][method] = {"address": address, "bytes": int(size, 16)}
    if label == "final":
        assert not any(line.endswith("<gpui_gpu::renderer::Renderer>::render") or line.endswith("<gpui_gpu::renderer::Renderer>::redraw") for line in symbols.splitlines())
        row["owned_forwarders_have_out_of_line_symbols"] = False
    rows[label] = row
(ROOT / "final/asm-summary.json").write_text(json.dumps(rows, indent=2) + "\n")
