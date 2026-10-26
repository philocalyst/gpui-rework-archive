# Collected GPUI rework checkpoint

Start with the original normative reactivity designs and ladder; see [the verified corpus and implementation crosswalk](DESIGN-CROSSWALK.md). The new brief must not replace those originals.

Then read [the expansive engineering brief](BRIEF.md). This is an experimental source preservation checkpoint, not a finished release.

- [Historical scene-preparation graph](benchmarks/scene-costs.png)
- [Historical full CPU-output graph](benchmarks/cpu-output-costs.png)
- [Historical raster phase-share graph](benchmarks/raster-phase-share.png)
- [Original historical summary data](benchmarks/historical-interaction-summary.json)
- [Fresh coherent benchmark acceptance contract](benchmarks/ACCEPTANCE.md)
- [Original workload contract](benchmarks/WORKLOAD-CONTRACT.md)
- [Cloud source branch inventory](SOURCE-REFS.json)
- [Preserved detached source snapshots](DETACHED-SOURCE-REFS.json)
- [Worktree source inventory](WORKTREE-SOURCE-INVENTORY.json)
- [Target consumer contract](supporting/TARGET-RECEIPT-CONSUMER-CONTRACT.md)

The graphs are historical baseline measurements, not unified-candidate before/after gains. Their plotted total is the sum of harness phase timings, not hardware input-to-display latency.

The source inventories preserve alternatives and failures. Being listed does not mean a branch is integrated, correct, fast, or recommended. Host-only source and qualification receipts must be read from the separately collected host manifest. Transport bundles and build binaries are deliberately not committed as bulk source artifacts.

The lexical support checker is not a Rust compiler; its portable synthetic self-test verifies only its own limited delimiter behavior.
