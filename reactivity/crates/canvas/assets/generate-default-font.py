#!/usr/bin/env python3
"""Reproduce the full, unsliced default instance using a verified local wheel.

Download fonttools-4.67.0-py3-none-any.whl from the URL in README.md first.
Usage: python3 generate-default-font.py /path/to/fonttools-4.67.0-py3-none-any.whl
No installed Python package, runtime dependency, or network access is needed.
"""
from pathlib import Path
import hashlib
import sys
import tempfile
import zipfile

SOURCE_SHA256 = "bfb7bb691513f12e734dc346c03a03f784912432d7e3fa8e56efcf906fe86b3d"
WHEEL_SHA256 = "4304f03ed7f4ba000a8dcc941ad854bfa52e2f3b6112b8f099b6f431cf98e701"
OUTPUT_SHA256 = "16a1ee5229882c1ba577d265014a85d8a4ddbcf5e45bd30bcfbabfdaf89cabf3"


def verify(path, expected):
    actual = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual != expected:
        raise SystemExit(f"SHA-256 mismatch for {path}: {actual}")


def main():
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    wheel = Path(sys.argv[1]).resolve()
    source = Path(__file__).resolve().with_name("NotoSans.ttf")
    output = source.with_name("NotoSans-default.ttf")
    verify(wheel, WHEEL_SHA256)
    verify(source, SOURCE_SHA256)
    with tempfile.TemporaryDirectory(prefix="canvas-default-font-") as temporary:
        with zipfile.ZipFile(wheel) as archive:
            for member in archive.infolist():
                path = Path(member.filename)
                if path.is_absolute() or ".." in path.parts:
                    raise SystemExit("unsafe wheel member")
            archive.extractall(temporary)
        sys.path.insert(0, temporary)
        from fontTools.ttLib import TTFont
        from fontTools.varLib.instancer import instantiateVariableFont

        font = TTFont(source, recalcTimestamp=False)
        axes = {axis.axisTag: axis.defaultValue for axis in font["fvar"].axes}
        if axes != {"wght": 400.0, "wdth": 100.0}:
            raise SystemExit(f"unexpected source axes: {axes}")
        instance = instantiateVariableFont(
            font, dict.fromkeys(axes), inplace=False, optimize=False
        )
        if "fvar" in instance or instance.getGlyphOrder() != font.getGlyphOrder():
            raise SystemExit("not a complete static instance with original glyph IDs")
        candidate = Path(temporary) / output.name
        instance.save(candidate, reorderTables=False)
        verify(candidate, OUTPUT_SHA256)
        output.write_bytes(candidate.read_bytes())
    print(f"{output.name}: {output.stat().st_size} bytes, SHA-256 {OUTPUT_SHA256}")


if __name__ == "__main__":
    main()
