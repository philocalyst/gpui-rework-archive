#!/usr/bin/env python3
"""Verify paged SDK packaging independently by reconstructing its byte streams."""
import contextlib
import gzip
import importlib.util
import io
import json
from pathlib import Path
import tempfile

spec = importlib.util.spec_from_file_location("pager", Path(__file__).with_name("page-metadata.py"))
pager = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pager)
with tempfile.TemporaryDirectory() as directory:
    root = Path(directory)
    source = root / "source"
    source.mkdir()
    (source / "wasi").mkdir()
    (source / "driver.wasm.gz").write_bytes(b"fixture")
    first = bytes(index % 251 for index in range(10 * pager.PAGE_SIZE + 17))
    second = b"actual MIR fixture" * 100
    third = b"starter metadata" * 100
    payload = first + second + third
    (source / "full.bin.gz").write_bytes(gzip.compress(payload))
    manifest = {"module": "driver.wasm.gz", "metadata": "full.bin.gz", "starters": [
        {"crate": "starter", "path": "/deps/starter.rmeta", "packet": "/deps/starter.mir"}], "files": [
        {"path": "/deps/first.rmeta", "offset": 0, "length": len(first)},
        {"path": "/deps/starter.mir", "offset": len(first), "length": len(second)},
        {"path": "/deps/starter.rmeta", "offset": len(first) + len(second), "length": len(third)},
    ]}
    (source / "assets.json").write_text(json.dumps(manifest))
    profile = root / "profile.txt"
    profile.write_text(f"GPUI_METADATA_PAGES\t/deps/first.rmeta\t{len(first)}\t[9, 10]\t[]\n")
    plan = root / "plan.json"
    plan.write_text(json.dumps({"page_size": pager.PAGE_SIZE, "files": [
        {"path": "/deps/first.rmeta", "length": len(first), "pages": [3]}]}))
    destination = root / "paged"
    with contextlib.redirect_stdout(io.StringIO()):
        pager.package(source, destination, [profile, plan])
    result = json.loads((destination / "assets.json").read_text())
    bootstrap = b"".join(gzip.decompress((destination / part).read_bytes()) for part in result["metadata_parts"])
    assert len(result["metadata_parts"]) == 2, "Starter assets must be independently cached from the SDK"
    for entry, original in zip(result["files"], [first, second, third]):
        reconstructed = b"".join(gzip.decompress((destination / name).read_bytes()) for name in entry["chunks"])
        assert reconstructed == original
        for page, offset, length in entry["bootstrap"]:
            assert bootstrap[offset:offset + length] == original[page * pager.PAGE_SIZE:page * pager.PAGE_SIZE + length]
    assert [page for page, _, _ in result["files"][0]["bootstrap"]] == [0, 2, 3, 10]
    assert result["metadata_paging"]["bootstrap_bytes"] < len(payload)
    (source / "full.bin.gz").write_bytes(gzip.compress(first + b"X" + second[1:] + third))
    with contextlib.redirect_stdout(io.StringIO()):
        pager.package(source, root / "changed", [profile, plan])
    changed = json.loads((root / "changed/assets.json").read_text())
    assert changed["metadata_parts"][0] == result["metadata_parts"][0], "Lesson edits must retain the immutable SDK cache key"
    assert changed["metadata_parts"][1] != result["metadata_parts"][1]
    profile.write_text("GPUI_METADATA_PAGES\t/deps/first.rmeta\t10\t[1]\t[]\n")
    try:
        pager.profiles([profile])
        raise AssertionError("Out-of-range profile must fail")
    except ValueError:
        pass
print("PASS paged packaging: byte-exact reconstruction, profile mapping, bootstrap offsets, partial pages and malformed-profile rejection")
