# API testing workflow review — 2026-10-08

This review checked `scripts/check-element-api.py` and `docs/element-api-testing.md` in this
checkout, then read the sibling visual-testing checkout at
`/Users/mileswirht/.codex/worktrees/f239/gpui-ce3`. No sibling files were changed. The sibling
was at `938f29258c` (`Record final collection profiles and verification limits`) with one unrelated
working-tree edit in `crates/gpui_linux/src/linux/x11/clipboard.rs`; its prior report/viewer change
is `fdec165b0e`.

## Findings

- The compile-contract script now runs eight positive integration targets: `value_queries`,
  `value_shapes`, `tuple_shapes`, `method_handles`, `value_query_positions`, `entity_queries`,
  `element_query_api`, and `trait_reflection`. The
  entity fixture checks headless selection over entity models and has negative cases for borrow
  escape and aliasing.
- The script now has 32 configured negatives: 10 query/capability, 9 reflection, 11 native
  value-query, and 2 entity-query cases. The value-query set now rejects field, role, and
  `Describe` schemas rooted at the wrong type, and access to a private method. These are wired as
  runner contracts; the root's full pass subsequently verified all 32 expected rejections.
- `--compile-pass-only` means all positive fixtures, not one fixture. For a tight loop, run a
  single target directly, or use `--skip-positive --case CASE_NAME` for one configured negative;
  reserve the full serial runner for a wider regression pass. Cargo's shared target directory and
  target-local `--cfg` keep dependencies reusable, though each selected integration target still
  needs compilation.
- Expected diagnostic matching is only as precise as each marker set. Cases that accept only a
  broad code such as `E0308` can pass after an unrelated type mismatch; prefer a distinctive type
  or diagnostic phrase alongside the code where stable.
- The sibling render workflow is complementary: `Harness::run_all` supports application-owned
  scenarios with deterministic simulated time, and `ReportWriter` collects captures without
  rerendering. This is useful for runtime behavior after the public API compiles. It does not
  replace compile-fail contracts. The sibling pseudo-mutation tool is a separate, slower check of
  whether runtime assertions detect deliberate regressions.
- Sibling `scripts/testing` Python tests were rerun read-only against HEAD
  `938f29258c08bc3c883cf9dcbb0ed15bdb1e3a05`:
  `python3 -m unittest discover -s scripts/testing -p 'test_*.py'` completed 58 tests with one
  platform-specific skip in 8.1 seconds. These tests cover report data and localhost forge
  publishing. Viewer source-fragment assertions do not run browser layout or image interactions,
  so they are not evidence that browser behavior works.

## Iteration guidance

Use the narrowest public integration fixture that matches the edit. A query/composition or
reflection compile change belongs first in its corresponding integration target; a runtime
selection or layout behavior change belongs in its focused test. For visual behavior, capture a
small deterministic scenario with the sibling harness only when a report adds useful evidence.
Run the entity target and one or more schema-root `--case` probes with `--skip-positive` during
focused edits, then run the full set after broad changes. Probe count matches runner
configuration; compile and verify intended failure diagnostics when the complete API check
finishes.

This review did not run Rust/Cargo tests, browser automation, or the sibling visual capture
workflow. It therefore makes no claim about API contract pass/fail or native runtime behavior
beyond source-level test coverage, and makes no claim about browser rendering or interaction
correctness.

The root's subsequent production pass ran 452 library tests, 32 public consumer tests, and 28
macro tests successfully. Fresh method regressions cover lifetime collisions, nested function
elision, temporary descriptors, pinned receivers, explicit generic return lifetimes, and source
`where` clauses. The sibling checkout was checked again after these changes and remained at the
same revision with only the unrelated clipboard edit.
