#!/usr/bin/env python3
"""Find exact pinned dictionary/font payloads in a linked ELF, not symbol guesses.

Uses Cargo's unpacked pinned ICU data source and reports absent payloads too.
Small lookup headers, other Unicode tables, alignment and compiler metadata
remain separate; these rows must not be described as the entire rodata section.
"""
import argparse
import csv
import hashlib
import os
from pathlib import Path
import re
import sys


def rust_bytes(body):
    result = bytearray()
    index = 0
    escapes = {"0": 0, "n": 10, "r": 13, "t": 9, "\\": 92, '"': 34}
    while index < len(body):
        character = body[index]
        index += 1
        if character != "\\":
            result.append(ord(character))
        else:
            escape = body[index]
            index += 1
            if escape == "x":
                result.append(int(body[index:index + 2], 16))
                index += 2
            else:
                result.append(escapes[escape])
    return bytes(result)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("binary", type=Path)
    args = parser.parse_args()
    binary = args.binary.read_bytes()
    cargo = Path(os.environ.get("CARGO_HOME", Path.home() / ".cargo"))
    directories = list((cargo / "registry/src").glob("*/icu_segmenter_data-2.3.0/data"))
    if len(directories) != 1:
        raise RuntimeError("expected one pinned ICU segmenter data source")
    payloads = []
    for name in ("auto", "extended"):
        source = directories[0] / f"segmenter_dictionary_{name}_v1.rs.data"
        for index, match in enumerate(re.finditer(r'b"((?:[^"\\]|\\.)*)"', source.read_text())):
            payload = rust_bytes(match[1])
            if len(payload) >= 20000:
                payloads.append((f"dictionary-{name}", f"{source.name}/literal{index}", payload))
    assets = Path(__file__).resolve().parent / "assets"
    for source in [assets / "NotoSans.ttf", *sorted(assets.glob("*/*.ttf"))]:
        payloads.append(("font", str(source.relative_to(assets)), source.read_bytes()))
    writer = csv.writer(sys.stdout, lineterminator="\n")
    writer.writerow(["kind", "source", "payload_bytes", "elf_file_offset", "instances", "sha256"])
    for kind, source, payload in payloads:
        offset = binary.find(payload)
        writer.writerow([kind, source, len(payload), "" if offset < 0 else offset,
                         binary.count(payload), hashlib.sha256(payload).hexdigest()])


if __name__ == "__main__":
    main()
