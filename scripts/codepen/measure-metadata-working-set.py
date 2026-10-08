#!/usr/bin/env python3
"""Summarize actual rustc metadata decoder pages from a profiled browser run.

The paged compiler reports initialized backing-store pages, including actual
range-probed definition hash lookups. Older cursor profiles remain readable.
"""
import argparse
import ast
import json
from pathlib import Path


def read_profiles(paths):
    files = {}
    for path in paths:
        for line in path.read_text().splitlines():
            if not line.startswith("GPUI_METADATA_PAGES\t"):
                continue
            _, name, length, pages, _ = line.split("\t", 4)
            length = int(length)
            pages = ast.literal_eval(pages)
            assert length >= 0 and isinstance(pages, list), "Invalid metadata profile"
            assert all(type(page) is int and 0 <= page < (length + 4095) // 4096
                       for page in pages), "Metadata page exceeds file"
            previous = files.setdefault(name, {"length": length, "pages": set()})
            assert previous["length"] == length, "Cannot combine different SDK metadata"
            previous["pages"].update(pages)

    return files


def summarize(paths):
    files = read_profiles(paths)

    def touched(file, chunk):
        chunks = {page * 4096 // chunk for page in file["pages"]}
        return sum(min(chunk, file["length"] - index * chunk) for index in chunks)

    result = {"files": len(files), "full_bytes": sum(f["length"] for f in files.values())}
    for chunk in (4096, 16384, 65536, 262144):
        result[f"bytes_at_{chunk // 1024}k"] = sum(touched(f, chunk) for f in files.values())
    result["largest_files"] = sorted(({
        "path": path, "full_bytes": file["length"],
        "bytes_at_4k": touched(file, 4096), "bytes_at_64k": touched(file, 65536),
    } for path, file in files.items()), key=lambda f: f["full_bytes"], reverse=True)[:20]
    result["coverage"] = "reported decoder pages; the paged compiler records initialized 16 KiB backing pages"
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("profiles", nargs="+", type=Path)
    parser.add_argument("--write-prefetch", type=Path,
                        help="Write the union as a reproducible 16 KiB bootstrap plan")
    args = parser.parse_args()
    if args.write_prefetch:
        files = read_profiles(args.profiles)
        if not files:
            parser.error("Cannot write an empty metadata prefetch plan")
        plan = {"page_size": 16384, "files": [
            {"path": name, "length": file["length"], "pages": sorted({page // 4 for page in file["pages"]})}
            for name, file in sorted(files.items())]}
        args.write_prefetch.write_text(json.dumps(plan, separators=(",", ":")) + "\n")
    print(json.dumps(summarize(args.profiles), indent=2))
