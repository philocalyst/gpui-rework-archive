#!/usr/bin/env python3
"""Read-only linked ELF/renderer inspection; this does not measure shader JIT ISA."""

import hashlib
import json
import re
import shutil
import struct
import subprocess
from pathlib import Path

TASK = Path("/home/miles/gpui-ce3-compute-20261024")
EVIDENCE = TASK / "evidence/todo-shader-profiles"


def sections(binary):
    data = binary.read_bytes()
    header = struct.unpack_from("<16sHHIQQQIHHHHHH", data)
    assert header[0][:6] == b"\x7fELF\x02\x01"
    records = [
        struct.unpack_from("<IIQQQQIIQQ", data, header[6] + index * header[11])
        for index in range(header[12])
    ]
    strings = records[header[13]]
    names = data[strings[4] : strings[4] + strings[5]]
    result = {}
    for record in records:
        name = names[record[0] :].split(b"\0", 1)[0].decode()
        if name in (".text", ".rodata", ".data", ".bss", ".eh_frame"):
            content = data[record[4] : record[4] + record[5]] if record[1] != 8 else b""
            result[name] = {
                "bytes": record[5],
                "sha256": hashlib.sha256(content).hexdigest(),
            }
    return result


def renderer_symbols(binary, nm):
    result = subprocess.run(
        [nm, "-S", "--defined-only", "--demangle", str(binary)],
        capture_output=True,
        text=True,
        check=True,
    )
    symbols = []
    for line in result.stdout.splitlines():
        fields = line.split(None, 3)
        if len(fields) != 4 or fields[2] not in ("t", "T"):
            continue
        if "gpui_gpu" in fields[3] and "renderer" in fields[3]:
            symbols.append(
                {
                    "address": int(fields[0], 16),
                    "bytes": int(fields[1], 16),
                    "name": fields[3],
                }
            )
    return sorted(symbols, key=lambda symbol: symbol["bytes"], reverse=True)


def main():
    output = EVIDENCE / "static-cost-v1"
    output.mkdir(exist_ok=False)
    nm = shutil.which("nm")
    objdump = shutil.which("objdump")
    readelf = shutil.which("readelf")
    profiles = {}
    for profile in ("original", "certified", "banked4"):
        case = EVIDENCE / "attempt2/builds" / profile
        binary = case / "todo_comparison_mapped"
        record = {
            "elf_bytes": binary.stat().st_size,
            "elf_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(),
            "sections": sections(binary),
            "actual_wgsl_bytes": (case / "ui.wgsl").stat().st_size,
            "tools": {"nm": nm, "objdump": objdump, "readelf": readelf},
            "scope": "Linked CPU-side ELF and actual WGSL text; no new shader JIT instruction/stack attribution.",
        }
        if nm:
            symbols = renderer_symbols(binary, nm)
            record["renderer_symbols"] = symbols
            if objdump:
                assembly = output / profile
                assembly.mkdir()
                for index, symbol in enumerate(symbols[:3]):
                    command = [
                        objdump,
                        "-d",
                        "-C",
                        f"--start-address={symbol['address']}",
                        f"--stop-address={symbol['address'] + symbol['bytes']}",
                        str(binary),
                    ]
                    result = subprocess.run(
                        command, capture_output=True, text=True, check=True
                    )
                    path = assembly / f"{index}.asm"
                    path.write_text(result.stdout)
                    symbol["disassembly_path"] = str(path)
            if readelf:
                result = subprocess.run(
                    [readelf, "--debug-dump=frames-interp", str(binary)],
                    capture_output=True,
                    text=True,
                    check=True,
                )
                (output / f"{profile}-frames.txt").write_text(result.stdout)
                record["cfi_scope"] = (
                    "Raw interpreted CFI retained; no unsupported own-stack estimate inferred."
                )
        profiles[profile] = record
    (output / "summary.json").write_text(
        json.dumps({"profiles": profiles}, indent=2) + "\n"
    )
    print(
        json.dumps(
            {
                name: {
                    "sections": value["sections"],
                    "wgsl_bytes": value["actual_wgsl_bytes"],
                    "renderer_functions": len(value.get("renderer_symbols", [])),
                }
                for name, value in profiles.items()
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
