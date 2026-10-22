"""Losslessly gzip bulky captures/whitespace-bearing logs; hash the archive."""
import gzip
import hashlib
import json
from pathlib import Path

root = Path(__file__).resolve().parent
packed = {}
for path in sorted(root.rglob("*")):
    if not path.is_file() or path.suffix in {".gz", ".pyc"} or "__pycache__" in path.parts:
        continue
    data = path.read_bytes()
    bulky = path.parent.name == "dhat" and path.suffix == ".json"
    generated = path.name == "ui-artifacts.rs"
    raw_log = path.suffix in {".txt", ".stderr", ".stdout"} and (
        data.endswith(b"\n\n") or any(line.endswith((b" ", b"\t")) for line in data.splitlines())
    )
    if not (bulky or generated or raw_log):
        continue
    target = path.with_name(path.name + ".gz")
    with target.open("wb") as dest:
        with gzip.GzipFile(filename="", fileobj=dest, mode="wb", mtime=0) as stream:
            stream.write(data)
    assert gzip.decompress(target.read_bytes()) == data
    packed[str(path.relative_to(root))] = {
        "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()
    }
    path.unlink()
ledger = root / "packed-originals.json"
if ledger.exists():
    packed = {**json.loads(ledger.read_text()), **packed}
ledger.write_text(json.dumps(packed, indent=2) + "\n")
files = [p for p in sorted(root.rglob("*")) if p.is_file() and p.name != "SHA256SUMS"
         and p.suffix != ".pyc" and "__pycache__" not in p.parts]
(root / "SHA256SUMS").write_text("".join(
    f"{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.relative_to(root)}\n" for p in files
))
