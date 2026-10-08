#!/usr/bin/env python3
"""Package an exact SDK as a measured bootstrap plus independently fetched ranges.

Every byte remains available. Profiles select only which immutable pages arrive
with the page; unknown components fault the remaining content-addressed chunks.
The source bundle is left intact for full-bundle parity comparisons.
"""
import argparse
import ast
import gzip
import hashlib
import json
from pathlib import Path
import shutil

PAGE_SIZE = 16 * 1024
CHUNK_SIZE = 256 * 1024
ROOT = Path(__file__).resolve().parents[2]


def profiles(paths):
    observed = {}
    def include(name, length, pages, granularity, path):
        if type(length) is not int or length < 0 or not isinstance(pages, list) or any(
                type(page) is not int or page < 0 or page * granularity >= length for page in pages):
            raise ValueError(f"Invalid metadata page profile in {path}")
        observed.setdefault((name, length), set()).update(page * granularity // PAGE_SIZE for page in pages)
    for path in paths:
        if path.suffix == ".json":
            plan = json.loads(path.read_text())
            if plan["page_size"] != PAGE_SIZE:
                raise ValueError(f"Metadata prefetch page size differs in {path}")
            for entry in plan["files"]:
                include(entry["path"], entry["length"], entry["pages"], PAGE_SIZE, path)
            continue
        for line in path.read_text().splitlines():
            if not line.startswith("GPUI_METADATA_PAGES\t"):
                continue
            _, name, length, pages, *_ = line.split("\t")
            length, pages = int(length), ast.literal_eval(pages)
            include(name, length, pages, 4096, path)
    return observed


def package(source, destination, profile_paths):
    if source.resolve() == destination.resolve():
        raise ValueError("Keep the verified source bundle separate from the paged experiment")
    manifest = json.loads((source / "assets.json").read_text())
    if manifest.get("metadata_paging"):
        raise ValueError("The source must be a full SDK bundle")
    destination.mkdir(parents=True, exist_ok=True)
    shutil.copytree(ROOT / "crates/gpui_codepen/web/miri", destination, dirs_exist_ok=True)
    shutil.copytree(source / "wasi", destination / "wasi", dirs_exist_ok=True)
    shutil.copy2(source / manifest["module"], destination / manifest["module"])
    payload = b"".join(gzip.decompress((source / part).read_bytes())
                       for part in manifest.get("metadata_parts", [manifest["metadata"]]))
    observed = profiles(profile_paths)
    bootstrap_groups = {"sdk": bytearray()}
    starter_groups = {path: program["crate"] for program in manifest.get("starters", [])
                      for path in (program["path"], program["packet"])}
    files = []
    compressed_bytes = 0
    written = set()

    def asset(prefix, content):
        nonlocal compressed_bytes
        compressed = gzip.compress(content, compresslevel=6, mtime=0)
        name = prefix + hashlib.sha256(compressed).hexdigest()[:20] + ".bin.gz"
        if name not in written:
            (destination / name).write_bytes(compressed)
            compressed_bytes += len(compressed)
            written.add(name)
        return name

    matched = 0
    for entry in manifest["files"]:
        group = starter_groups.get(entry["path"], "sdk")
        bootstrap = bootstrap_groups.setdefault(group, bytearray())
        offset, length = entry["offset"], entry["length"]
        if offset < 0 or length < 0 or offset + length > len(payload):
            raise ValueError(f"Invalid source metadata range: {entry['path']}")
        content = memoryview(payload)[offset:offset + length]
        chunks = [asset("metadata-page-", content[start:start + CHUNK_SIZE])
                  for start in range(0, length, CHUNK_SIZE)]
        pages = set(observed.get((entry["path"], length), ()))
        matched += bool(pages)
        if length:
            # Header and end sentinel are enough to discover any dependency.
            # Initial lesson MIR is small and already compiled: deliver it whole.
            pages.update((0, (length - 1) // PAGE_SIZE))
            if entry["path"].endswith(".mir"):
                pages.update(range((length + PAGE_SIZE - 1) // PAGE_SIZE))
        seed = []
        for page in sorted(pages):
            start = page * PAGE_SIZE
            size = min(PAGE_SIZE, length - start)
            if size <= 0:
                raise ValueError(f"Profile exceeds metadata: {entry['path']}:{page}")
            seed.append([page, len(bootstrap), size])
            bootstrap.extend(content[start:start + size])
        files.append({"path": entry["path"], "length": length, "chunks": chunks, "bootstrap": seed,
                      "_bootstrap_group": group})
    offsets, total, metadata_parts = {}, 0, []
    for group, content in bootstrap_groups.items():
        offsets[group] = total
        total += len(content)
        metadata_parts.append(asset("metadata-bootstrap-" if group == "sdk" else "metadata-starter-", content))
    for entry in files:
        offset = offsets[entry.pop("_bootstrap_group")]
        for seed in entry["bootstrap"]: seed[1] += offset
    manifest.update(metadata=metadata_parts[0], metadata_parts=metadata_parts, files=files,
                    metadata_paging={"page_size": PAGE_SIZE, "chunk_size": CHUNK_SIZE,
                                     "full_bytes": len(payload), "bootstrap_bytes": total})
    temporary = destination / "assets.json.tmp"
    temporary.write_text(json.dumps(manifest, separators=(",", ":")))
    temporary.replace(destination / "assets.json")
    keep = written | {manifest["module"]}
    for pattern in ("metadata-*.bin.gz", "miri-*.wasm.gz"):
        for stale in destination.glob(pattern):
            if stale.name not in keep:
                stale.unlink()
    print(json.dumps({"files": len(files), "chunks": len(written) - len(metadata_parts), "profiled_files": matched,
                      "full_bytes": len(payload), "bootstrap_bytes": total,
                      "bootstrap_compressed_bytes": sum((destination / part).stat().st_size for part in metadata_parts),
                      "all_compressed_bytes": compressed_bytes, "destination": str(destination)}, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("destination", type=Path)
    parser.add_argument("--profile", type=Path, action="append", default=[])
    args = parser.parse_args()
    package(args.source, args.destination, args.profile)
