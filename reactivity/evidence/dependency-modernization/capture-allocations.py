#!/usr/bin/env python3
"""Run identical existing fixtures; persist allocation fields only, never timings."""
import argparse
import csv
import hashlib
import io
import json
import pathlib
import subprocess


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def capture(binary, arguments):
    completed = subprocess.run([str(binary), *arguments], text=True, capture_output=True, check=True)
    lines = completed.stdout.splitlines()
    if binary.name == "font_memory":
        # The optional legacy fontdue timing/control is unrelated to this text
        # substrate comparison; the first two lines are the actual service row.
        lines = lines[:2]
    rows = []
    for row in csv.DictReader(io.StringIO("\n".join(lines))):
        row = {key: value for key, value in row.items() if key and "nanosecond" not in key and not key.endswith("_ns")}
        rows.append({key: int(value) if value.lstrip("-").isdigit() else value for key, value in row.items()})
    return rows


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--before", type=pathlib.Path, required=True)
    parser.add_argument("--after", type=pathlib.Path, required=True)
    parser.add_argument("--before-source", required=True)
    parser.add_argument("--after-source", required=True)
    parser.add_argument("--output", type=pathlib.Path, required=True)
    args = parser.parse_args()
    fixtures = [("text_shaping", arguments) for arguments in [
        ["labels", "0"], ["labels", "1"], ["labels", "1000"], ["unicode", "1"], ["unicode", "1000"]]]
    fixtures += [("font_memory", [count]) for count in ["1", "8"]]
    fixtures += [("unicode_text_measure", [count]) for count in ["0", "1", "1000"]]
    results = []
    for repeat in range(3):
        for variant, directory in [("before", args.before), ("after", args.after)]:
            for name, arguments in fixtures:
                binary = directory / name
                results.append({"repeat": repeat, "variant": variant, "fixture": name,
                                "arguments": arguments, "binary_sha256": digest(binary),
                                "rows": capture(binary, arguments)})
    args.output.write_text(json.dumps({"method": "matched existing fixture bytes, fresh process per case, three repeats; requested thread-local heap; timing columns discarded before persistence",
                                      "before_source": args.before_source, "after_source": args.after_source,
                                      "results": results}, indent=2) + "\n")


if __name__ == "__main__":
    main()
