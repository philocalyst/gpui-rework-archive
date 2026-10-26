# GPUI rework: collected experimental checkpoint

## Normative design first

The original reactivity designs, progressive ladder and structural consolidation review are the starting point: **one semantic model, proofs at boundaries, no third language, nothing ambient**. The new brief is subordinate to those originals and explicitly documented amendments. See the [design preservation inventory](reactivity/docs/rework-2026-10-26/DESIGN-PRESERVATION.md); the authoritative Mac corpus is being collected unchanged for this checkpoint.

## Engineering handoff

Read the [expansive engineering brief](reactivity/docs/rework-2026-10-26/BRIEF.md) and [evidence/source index](reactivity/docs/rework-2026-10-26/README.md). The brief covers architecture, code status, correctness, rendering and parallel execution, text/resource ownership, measured results, failures, weak points, and the next-experiment atlas.

This is **not a finished or performance-qualified release**. Selected cloud code is `3c5cc3330cf6e6878489a55f1ab7218731a379af`; host adaptations, qualified predecessors and incompatible alternatives are separately inventoried. The final backend damage consumer and realistic matched unified benchmarks remain open. Historical graphs are clearly labelled baseline-only.

All archival refs must be interpreted with their status index, not as interchangeable shipping branches. No force-merging of rejected experiments or silent inheritance of earlier test results is intended.
