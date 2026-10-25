#!/usr/bin/env python3
"""Run the public reflection and selector consumer compile contracts."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


FEATURES = ["--no-default-features", "--features", "test-support"]
DiagnosticMarker = str | tuple[str, ...]
FAIL_CASES = {
    "query_missing_builtin": ("E0599",),
    "query_unknown_with": ("ContainsCallable",),
    "query_membership_no_methods": ("E0599",),
    "query_borrow_escape": ("E0597",),
    "query_borrow_alias": ("E0499",),
    "query_borrow_clone": ("Clone",),
    "query_wrong_capability_receiver": ("E0308", "WrongCapabilityReceiver", "TextLens"),
    "query_fake_builtin_styled": ("E0308", "__GpuiReflectStyled"),
    "query_capability_key_coercion": ("E0308", "one type is more general than the other"),
    "query_concrete_target_coercion": ("E0308", "one type is more general than the other"),
}
REFLECTION_FAIL_CASES = {
    "reflection_bounds": ("Send", "E0277"),
    "reflection_token": ("CallableReflectionToken",),
    "reflection_method": ("PaintSource", "E0277"),
    "reflection_type": ("PaintSource", "E0277"),
    "reflection_schema": ("E0308",),
    "reflection_identity": ("E0308",),
    "reflection_parent_schema": ("E0308",),
    "reflection_private": ("E0603", "PrivateParent"),
    "reflection_parent": ("callable reflected parents require callable reflection",),
}
VALUE_FAIL_CASES = {
    "value_query_escape": ("E0521",),
    "value_query_wrong_field": (("E0277", "E0631"), "closure", "String", "u32"),
    "value_query_wrong_root": ("E0271",),
    "value_query_alias": ("E0499",),
    "value_query_unsafe_method": ("E0133",),
    "value_query_borrowed_escape": ("lifetime may not live long enough",),
    "value_query_borrowed_alias": ("E0499",),
    "value_schema_wrong_field_root": ("E0308", "FieldRegistration", "Details", "Card"),
    "value_schema_wrong_role_root": ("E0308", "RoleRegistration", "Details", "Card"),
    "value_schema_wrong_describe_root": ("E0308", "Schema<Wrong>", "Schema<Details>"),
    "value_query_private_method": ("E0624", "private_method"),
}
ENTITY_FAIL_CASES = {
    "entity_query_escape": ("E0521",),
    "entity_query_alias": ("E0499",),
}


def cargo(root: Path, args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["cargo", *args],
        cwd=root,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )


def check_fail_cases(
    root: Path,
    target: list[str],
    cases: dict[str, tuple[DiagnosticMarker, ...]],
    label: str,
) -> int:
    for cfg, expected_markers in cases.items():
        print(f"Checking {label}: {cfg}", flush=True)
        result = cargo(
            root,
            ["rustc", "--locked", *target, "--", "--cfg", cfg],
        )
        if result.returncode == 0:
            print(f"FAIL: `{cfg}` unexpectedly compiled", file=sys.stderr)
            return 1
        missing = [
            marker for marker in expected_markers
            if not any(
                option in result.stdout
                for option in ((marker,) if isinstance(marker, str) else marker)
            )
        ]
        if missing:
            print(result.stdout, file=sys.stderr)
            print(
                f"FAIL: `{cfg}` failed without diagnostic markers {missing!r}",
                file=sys.stderr,
            )
            return 1
        markers = ", ".join(
            marker if isinstance(marker, str) else " / ".join(marker)
            for marker in expected_markers
        )
        print(f"PASS: {cfg} rejected ({markers})", flush=True)
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--case", action="append", choices=sorted(FAIL_CASES | REFLECTION_FAIL_CASES | VALUE_FAIL_CASES | ENTITY_FAIL_CASES),
        help="run only these negative cases (repeatable)",
    )
    parser.add_argument(
        "--skip-positive", action="store_true", help="skip positive fixtures when iterating on a negative case",
    )
    parser.add_argument(
        "--compile-pass-only",
        action="store_true",
        help="run all positive consumer fixtures without the compile-fail probes",
    )
    args = parser.parse_args()
    if args.compile_pass_only and args.skip_positive:
        parser.error("--compile-pass-only and --skip-positive would run no checks")
    if args.compile_pass_only and args.case:
        parser.error("--compile-pass-only and --case select incompatible checks")

    root = Path(__file__).resolve().parents[1]
    query_target = ["-p", "gpui-ce", "--test", "element_query_api", *FEATURES]
    reflection_target = ["-p", "gpui-ce", "--test", "trait_reflection", *FEATURES]
    value_target = ["-p", "gpui-ce", "--test", "value_queries", *FEATURES]
    position_target = ["-p", "gpui-ce", "--test", "value_query_positions", *FEATURES]
    shapes_target = ["-p", "gpui-ce", "--test", "value_shapes", *FEATURES]
    tuple_target = ["-p", "gpui-ce", "--test", "tuple_shapes", *FEATURES]
    methods_target = ["-p", "gpui-ce", "--test", "method_handles", *FEATURES]
    entity_target = ["-p", "gpui-ce", "--test", "entity_queries", *FEATURES]

    print("Checking consumer-facing element query API...", flush=True)
    positive_targets = (
        (value_target, "ordinary value and native query contracts"),
        (shapes_target, "cross-module, recursive, and container shapes"),
        (tuple_target, "conditional and borrowed tuple shapes"),
        (methods_target, "native method lifetimes and temporary descriptors"),
        (position_target, "native and role positional admission"),
        (entity_target, "entity model and context queries"),
        (query_target, "consumer render contract"),
        (reflection_target, "existing trait reflection integration tests"),
    )
    for target, label in (() if args.skip_positive else positive_targets):
        result = cargo(root, ["test", "--locked", *target])
        if result.returncode:
            print(result.stdout, file=sys.stderr)
            print(f"FAIL: compile-pass {label}", file=sys.stderr)
            return result.returncode
        print(f"PASS: compile-pass {label}", flush=True)

    if args.compile_pass_only:
        return 0

    for target, cases, label in (
        (value_target, VALUE_FAIL_CASES, "value rejection"),
        (entity_target, ENTITY_FAIL_CASES, "entity rejection"),
        (query_target, FAIL_CASES, "query rejection"),
        (reflection_target, REFLECTION_FAIL_CASES, "reflection rejection"),
    ):
        if args.case:
            cases = {cfg: markers for cfg, markers in cases.items() if cfg in args.case}
        if check_fail_cases(root, target, cases, label):
            return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
