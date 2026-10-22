# Pinned source accounting

These snapshots use inventory source commit
`4b1b4c66237e02d2456752a9b5092c80b6247c5d`. The experiment snapshot inventories
that exact commit; the original snapshot inventories
`41a42eb96d6c04e5e71f3577d12934d4de569b20` with the same tool and classification
rules. The later commit adding this data does not change either source pin.

This is a physical-line ledger, including comments and blanks, with conservative
Rust test subtraction. It does not establish equivalent features or an exact
reduction ratio. No timings were collected for this work.

| Experiment purpose (hand-written first-party source) | Non-test lines |
| --- | ---: |
| Libraries | 26,844 |
| Labs | 2,939 |
| Examples | 5,999 |
| Benchmarks and fixtures | 4,861 |
| Tools, including the inventory implementation | 947 |
| Evidence helpers and fixtures | 2,545 |
| **All hand-written first-party non-test source** | **44,135** |

| Experiment accounting | Lines |
| --- | ---: |
| First-party generated/disassembly, separately charged | 36,007 |
| All first-party non-test, including generated/disassembly | 80,142 |
| Vendor non-test, excluding generated | 142,844 |
| Vendor generated, separately charged | 1 |
| **All active non-test source, all charges** | **222,987** |
| Known active test lines | 40,588 |
| All active physical source, including tests | 263,575 |
| Excluded original checkout physical source | 264,164 |
| Excluded docs/inputs physical source | 814 |
| All repository physical source, including exclusions | 528,553 |

The original snapshot has 202,755 conservative non-test lines across libraries,
examples, benchmarks, tools and other support, out of 264,164 physical lines.
Its six flagged files contain quoted test-related attributes in unexpanded macro
tokens; those remain charged. The experiment's sole flagged file is an 11-line evidence
fixture referring to `/tmp/gpui-flex-f019-style.rs`; those lines remain charged. Review each JSON entry's `unclassified` diagnostics.

The JSON ledgers contain every source path, language, ownership/purpose,
physical/test/non-test counts, and SHA-256; excluded historical files only get
physical counts. They also include source commits, tool and Cargo manifest
hashes, active/all-source ledger hashes, and reproduction commands. Full rules,
limitations and validation commands are in
[the inventory documentation](../../tools/inventory.md).

To regenerate from the integrated repository:

```sh
python3 reactivity/tools/inventory.py --ref 4b1b4c6623 > /tmp/experiment-4b1b4c6623.json
python3 reactivity/tools/inventory.py --ref 41a42eb96d --scope original > /tmp/original-41a42eb96d.json
```

After later source changes, use `--working` or pin the new source commit and
write a new snapshot. Reusing these totals for another HEAD would be incorrect.

These historical JSON files preserve the original tool and source hashes. They
predate the follow-up fixes for Unicode character span columns and authored
assembly classification, and the change to read attributes directly from Syn.
Their recorded source pin and totals have not been retagged as results from the
corrected tool. Generate a new snapshot after adopting those corrections.
