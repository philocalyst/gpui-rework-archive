The [report](report.md) summarizes this separate exact-0062 mapped Todo experiment.
It does not replace or modify the original five-app evidence.

`raw-evidence.tar.gz` contains every raw setup/build/preflight/control/capture and
instrumented diagnostic file, plus explicitly named postcapture analysis. It has
408 payload files and a `MANIFEST.json` of their hashes, sizes, link types and
executable modes. The archive was reread and its exact member set and all bytes
verified; see `raw-archive-receipt.json`.

The separately retained source/ELF capsule is recorded by
`source-elf-archive-receipt.json` at its absolute workspace location. It contains
all 2,036 anchored GPUI build-source files and metadata, scoped upstream base and
fixture overlay, both guarded application ELFs, the complete native present-control
source and ELF, and the sealed runner/protocol sources. The control export covers
all Git-tracked paths plus untracked-not-ignored source; all upstream blobs except
its four declared adapter files were verified. Git internals and build caches are
absent. Its exact 11,282 payload member set, contents and modes were reread too.
The current commit separately versions the postcapture analysis and report.

To reproduce the main resource summary after extracting the raw archive into a
fresh directory:

```sh
python3 ../analyze.py "$EXTRACT/evidence/capture-v1" "$OUTPUT"
cmp summary.json "$OUTPUT/summary.json"
cmp resources.md "$OUTPUT/resources.md"
```

`all-raw-auto-pairs.json` retains CPU/PSS from all three paired repetitions,
including both rejected control animation trials. A false eligibility flag means
those resource numbers are diagnostic only. Original per-row acceptance flags,
full ordered models/actions, screenshots and host timestamps remain in the archive.

For the owned-RX diagnostic's independent disassembly:

```sh
python3 ../analyze_code.py "$EXTRACT/evidence/cpu-diagnostic-code-v3" \
  --objdump /nix/store/ddk8rvjihg4vhh1k6x9rc65y1zb1kx34-binutils-2.46/bin/objdump
```

This uses only the frozen RX byte snapshots, not a live process. It recomputes
module resolution using the latest preceding executable mapping, verifies each
snapshot hash, and starts each assembly window at a sampled instruction address.
There is no named function/stage or cycle-exact latency claim.

The mandatory historical archive SHA is
`bc7f5d08992cbe4a58e08ed970d8bc1785724453c93151c37aa0a6a6edb7dfa2`.
The recorded 20-test run enabled that archive; none of its six known failing cells
was retagged as passing. Native qualification and every profile exclusion are in
`qualification.json`, `summary.json` and the raw archive.
