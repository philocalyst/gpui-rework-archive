#!/usr/bin/env python3
"""Losslessly encode a captured P6 RGB drawable as PNG for visual inspection."""

import argparse, struct, zlib
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument("input", type=Path)
p.add_argument("output", type=Path)
a = p.parse_args()
magic, size, maximum, rgb = a.input.read_bytes().split(b"\n", 3)
w, h = map(int, size.split())
assert magic == b"P6" and maximum == b"255" and len(rgb) == w * h * 3


def chunk(name, data):
    return (
        struct.pack(">I", len(data))
        + name
        + data
        + struct.pack(">I", zlib.crc32(name + data) & 0xFFFFFFFF)
    )


a.output.parent.mkdir(parents=True, exist_ok=True)
a.output.write_bytes(
    b"\x89PNG\r\n\x1a\n"
    + chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 2, 0, 0, 0))
    + chunk(
        b"IDAT",
        zlib.compress(
            b"".join(b"\0" + rgb[y * w * 3 : (y + 1) * w * 3] for y in range(h)), 9
        ),
    )
    + chunk(b"IEND", b"")
)
