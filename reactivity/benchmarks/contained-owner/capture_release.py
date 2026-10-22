"""Capture complete ordinary-client bodies, ELF sections and actual route tables.

No timings. Each immutable source has its own Cargo target directory. Fail if a
client glob is ambiguous; never choose the newest artifact from a shared target.
"""
from pathlib import Path
import hashlib
import json
import re
import struct
import subprocess
import sys

OUT = Path(__file__).parent / "release-controls"
NM = "/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin/nm"
OBJDUMP = NM.removesuffix("nm") + "objdump"
SPECS = {
    "baseline": ("/root/gpui-contained-owner-unit-baseline", "/tmp/gpui-contained-owner-unit-baseline-target"),
    "candidate": ("/root/gpui-inspector-contained-owner", "/tmp/gpui-contained-owner-spike-target"),
    "exchange": ("/root/gpui-contained-property-exchange", "/tmp/gpui-contained-property-exchange-target"),
}
SOURCE_PINS = {
    "baseline": "e6c231d90f38dd196c937e82cb6ba2c5d00005fc",
    "candidate": "5ffbe09e18bddaaa36c9cd3eeda4ffa0170d74d6",
    "exchange": "f8467390d50e5feb32407753170b6f763b4c872c",
}
if sys.argv[1:] == ["--final"]:
    OUT = Path(__file__).parent / "final-release-controls"
    SPECS = {"baseline": SPECS["baseline"], "final": SPECS["exchange"]}
    SOURCE_PINS = {
        "baseline": SOURCE_PINS["baseline"],
        "final": "c3248fd11c138124e221af9487030b849445eca1",
    }
else:
    assert not sys.argv[1:], "expected no arguments or --final"
METHODS = ("click", "activate_focused", "activate_with_editing", "activate_property")


def sections(data):
    assert data[:6] == b"\x7fELF\x02\x01"
    offset = struct.unpack_from("<Q", data, 40)[0]
    width, count, names = struct.unpack_from("<HHH", data, 58)
    table = [struct.unpack_from("<IIQQQQIIQQ", data, offset + i * width) for i in range(count)]
    strings = data[table[names][4]:table[names][4] + table[names][5]]
    return {strings[row[0]:].split(b"\0", 1)[0].decode(): row for row in table}


def capture(variant, root, target, client):
    matches = [p for p in (target / "release/deps").glob(client + "-*") if p.is_file() and not p.suffix]
    assert len(matches) == 1, matches
    binary = matches[0]
    data = binary.read_bytes()
    folder = OUT / variant / client
    folder.mkdir(parents=True, exist_ok=True)
    raw = subprocess.check_output([NM, "-S", "--size-sort", "--demangle", str(binary)], text=True)
    (folder / "symbols.txt").write_text(raw)
    symbols = []
    for line in raw.splitlines():
        fields = line.split(None, 3)
        if len(fields) == 4:
            address, size, kind, name = fields
            symbols.append((int(address, 16), int(size, 16), kind, name))
    rows = []
    for address, size, kind, name in symbols:
        if kind.lower() != "t":
            continue
        if not (name.endswith(tuple("::" + m for m in METHODS))
                or "MethodRoute<" in name
                or ("gpui::runtime::RuntimeMut<" in name and client + "::" in name)
                or ("allocation_counter::measure::<" + client + "::" in name)):
            continue
        text = subprocess.check_output([OBJDUMP, "-Cd", f"--start-address={address}", f"--stop-address={address + size}", str(binary)], text=True)
        filename = f"{len(rows):02}.asm"
        (folder / filename).write_text(text)
        adjustments = [line.strip() for line in text.splitlines() if re.search(r"\b(?:sub|add|push|pop)q?\b", line) and ("%rsp" in line or re.search(r"\b(?:push|pop)q?\b", line))]
        rows.append({"address": address, "bytes": size, "name": name, "asm": filename, "stack_adjustments": adjustments})
    sec = sections(data)
    # PIE uses RELA addends for local function pointers; their on-disk slots
    # need not contain the initialized values. Decode only x86_64 RELATIVE
    # relocations into a private copy, with zero load bias, before table lookup.
    assert struct.unpack_from("<H", data, 18)[0] == 62
    initialized = bytearray(data)
    for row in sec.values():
        if row[1] != 4:  # SHT_RELA
            continue
        assert row[5] % 24 == 0
        for offset in range(row[4], row[4] + row[5], 24):
            destination, info, addend = struct.unpack_from("<QQq", data, offset)
            if info & 0xffffffff != 8:  # R_X86_64_RELATIVE
                continue
            for target_section in sec.values():
                if target_section[3] <= destination < target_section[3] + target_section[5]:
                    slot = target_section[4] + destination - target_section[3]
                    struct.pack_into("<Q", initialized, slot, addend)
                    break
    tables = []
    for address, size, kind, name in symbols:
        if "MethodRoute<" not in name or not name.endswith("::admit"):
            continue
        prefix = name.removesuffix("::admit")
        methods = {n.rsplit("::", 1)[1]: a for a, _, _, n in symbols if n.startswith(prefix + "::")}
        order = ["admit", "invoke", "owner_scope"]
        if "proposal" in methods:
            order += ["proposal", "applied_logically"]
        elif "property" in methods:
            order += ["property"]
        needle = struct.pack("<" + "Q" * len(order), *(methods[m] for m in order))
        start = 0
        while (position := initialized.find(needle, start)) != -1:
            start = position + 1
            header = struct.unpack_from("<QQQ", initialized, position - 24)
            if header != (0, 0, 1):
                continue
            tables.append({"route": prefix, "file_offset": position - 24, "bytes": 24 + len(needle), "header": header, "methods": order, "pointers": [methods[m] for m in order]})
    assert tables, "normal method route table not found"
    fingerprint = target / "release/.fingerprint" / ("gpui-" + binary.name.split("-")[-1]) / ("test-integration-test-" + client + ".json")
    flags = json.loads(fingerprint.read_text())
    assert flags["features"] == '["default", "simd"]' and flags["rustflags"] == []
    (folder / "fingerprint.json").write_text(json.dumps(flags, indent=2) + "\n")
    return {
        "head": subprocess.check_output(["git", "-c", f"safe.directory={root}", "-C", str(root), "rev-parse", "HEAD"], text=True).strip(),
        "binary": str(binary), "sha256": hashlib.sha256(data).hexdigest(),
        "client_sha256": hashlib.sha256((root / "reactivity/crates/gpui/tests" / (client + ".rs")).read_bytes()).hexdigest(),
        "sections": {name: sec[name][5] for name in (".text", ".rodata", ".data.rel.ro")},
        "bodies": rows, "method_route_tables": tables,
    }


result = {}
for variant, (root, _) in SPECS.items():
    actual = subprocess.check_output(
        ["git", "-c", f"safe.directory={root}", "-C", root, "rev-parse", "HEAD"], text=True
    ).strip()
    assert actual == SOURCE_PINS[variant], (variant, actual, SOURCE_PINS[variant])
for variant, (root, target) in SPECS.items():
    result[variant] = {client: capture(variant, Path(root), Path(target), client) for client in ("unit_action_cost", "unit_action_cost_two")}
for client in ("unit_action_cost", "unit_action_cost_two"):
    assert len({clients[client]["client_sha256"] for clients in result.values()}) == 1
(OUT / "artifacts.json").write_text(json.dumps(result, indent=2) + "\n")
print(json.dumps({variant: {client: row["sections"] for client, row in clients.items()} for variant, clients in result.items()}, indent=2))
