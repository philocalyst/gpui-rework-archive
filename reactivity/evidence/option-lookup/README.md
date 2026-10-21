# Optional-index lookup experiment: rejected

Do not integrate this source. The private calling convention improves, but the
guarded application controls regress with no memory saving. This evidence
preserves the implementation, the gains, and the losses together.

Source pins:

- Original public-operation baseline: `b15133e90de3925fcb4aeaa4ffb18d413a3bf0f7`.
- Narrow validated-index reuse, still using BTree:
  `b25b45f2c11db024083749d0dcdd8080333a7b10`.
- Optional-index implementation: `7724d9199ec6364c42519326fdc095bbeecdf2ad`.
- Final measured source after moving the measurement-only test into evidence:
  `788dbce027167c686003542b0ae0b7f342efadde`.

## Scope and correctness

The experiment changes private `Runtime::locate` from
`Result<(u64, usize), Error>` to `Option<usize>`. All its old rejection paths
returned `StaleTarget`. Public callers now construct that same error at their
existing boundary. The identity-only convenience returns `Option<u64>` and
reads the canonical node identity after locating it. Consumers needing both
index and identity do the same checked node read.

The existing BTree, namespace check, logical-validity check, virtual-list
prepared/presented membership policy and admission order remain intact. Index
reuse lasts only for the existing owner borrow, before a description can
rebuild the tree. No persistent index capability, new field, lookup table,
allocation, manual integer tag, unsafe code or public API was added.

The complete GPUI default suite passes: 245 runtime/integration cases and 19
doctests, including stale/foreign targets, owner faults, presentation failure,
virtual-list membership, input and typed inspector behavior. Strict accessible
X11+Wayland all-target Clippy passes. Native input scripts were not rerun for
this rejected source; this experiment does not claim platform runtime evidence.

## ABI and actual linked code

The separately captured ABI probe measures the pinned x86_64 Rust 1.97.1 types:

| Return type | Bytes |
| --- | ---: |
| Error | 56 |
| Result<usize, Error> | 56 |
| Result<(u64, usize), Error> | 56 |
| Option<usize> | 16 |
| Option<u64> | 16 |

`abi-ledger-probe.patch` and `abi.log` preserve that measurement without adding
a print-only test to the final release application harness. All three measured
app binaries have identical test inventories (`app-test-inventory.txt`). The
ordinary identity fixture is byte-identical before and after removing the probe
(`ledger-removal-fixture-hashes.txt`).

The ordinary linked `identity_index` executable confirms the expected local
calling-convention change. The narrow callee receives a hidden result pointer
in RDI and Runtime in RSI; its callers pass a stack slot, then read the result
discriminant and index back from it. The candidate receives Runtime in RDI and
returns presence/index in RAX/RDX. The four real direct caller windows and both
complete callees are included, rather than inferring this from type size.

| Linked identity fixture | Narrow | Candidate |
| --- | ---: | ---: |
| locate callee bytes | 413 | 391 |
| .text bytes | 3,006,359 | 3,006,103 |
| Total section bytes | 8,130,904 | 8,130,912 |

The actual application monomorphs do not become uniformly simpler:

| Adversary callee bytes | Narrow | Candidate |
| --- | ---: | ---: |
| describe_inner | 27,194 | 27,114 |
| locate | 413 | 391 |
| present | 18,606 | 18,606 |
| set_property | 1,352 | 1,376 |

`set_property`'s local stack reservation grows from 456 to 472 bytes despite
the smaller helper return. Its canonical identity read requires a checked node
access. The full app .text shrinks by 576 bytes, while its start moves 96 bytes
later; the total section size shrinks four bytes. The large description and
presentation callees and inspector code are preserved in the assembly files.
These observations do not isolate the cause of the application regressions;
neither the ABI reduction nor the callee sizes establish a whole-program win.

## Guarded three-way controls

The one accepted capture is `serial-quiet-20261021`, taking 35.63 seconds.
The root and both peers explicitly held builds/tests/timings before START;
FINISHED was sent immediately after the process exited. No source or executable
was changed during the capture. No alternate run was selected or discarded.

Seven interleaved three-way rounds produce 1,890 fixture rows; five rounds of
three fresh app processes, each with three internal batches, produce 1,125 app
rows. Processes are pinned to CPU 2. Order rotates and reverses between rounds;
the exact orders are recorded. `capture.py` checks each launch's exact source
HEAD, clean tracked tree, absence of untracked production inputs, Cargo.lock,
fixture hash and the SHA-named executable copy. Raw files, executable/source
pins and capture hashes are retained. Both comparisons use the same measured
candidate runs, avoiding percentage chaining across different captures.

For a rerun, create detached worktrees at the source pins and update a copy of
the manifest's worktree paths, retaining executable hashes. The evidence commit
advances this branch beyond its measured source HEAD; do not weaken the exact
HEAD guard or overwrite the accepted capture to accommodate that change.

The summaries report the median of per-round candidate/baseline percentage
changes; their min/max columns retain all round ratios. Each app round first
takes the median of its three internal batches. Results are CPU owner-operation
controls, not native startup, transfer, GPU, scanout or photon measurements.

Private lookup gains survive against the original baseline. The ranges below
are the nine per-cell medians across counts and identity patterns, rather than
a time-weighted aggregate:

| Stage | Versus original | Versus narrow |
| --- | ---: | ---: |
| focus_first | -40.82% to -30.02% | -6.00% to +8.02% |
| focus_last | -49.51% to -1.39% | -3.68% to +8.50% |
| property_first | -38.21% to -24.73% | -37.20% to -1.30% |
| property_last | -41.42% to -3.44% | -37.95% to +1.02% |

The app controls reject adoption:

| Operation | Versus original | Versus narrow |
| --- | ---: | ---: |
| mount_0 | +7.82% | +9.18% |
| equal_0 | +1.68% | +4.34% |
| warm_override_0 | +13.61% | +12.99% |
| equal_1 | +4.40% | +3.93% |
| update_1 | +3.71% | +4.07% |
| equal_2 | +3.62% | +3.80% |
| update_2 | +3.87% | +4.35% |
| warm_override_2 | +2.74% | -1.28% |
| equal_3 | +2.88% | +3.97% |
| update_3 | +2.40% | +2.60% |
| counter_exact | +2.58% | -0.40% |
| todos_equal | +1.99% | +0.54% |
| workspace_rotate | +0.16% | +2.63% |
| library_equal | -0.25% | -0.52% |
| library_scroll | +0.09% | +0.22% |

`warm_override_0` is slower than the original in every round (+13.48% to
+15.03%). The hoped-for `warm_override_2` repair improves on narrow but remains slower
than the simultaneously measured original in every round (+2.35% to +3.85%). Small Library movements straddle
zero. All 25 app cells and every fixture cell, including small-owner and rare
losses, remain in the CSV files; this table is not a replacement for them.

## Storage and decision

No retained field or data structure changes. The probe measures Node at 40
bytes and Presented at 80 bytes, unchanged from this narrow base. The fixture
asserts that allocation count, requested bytes, live delta, retained bytes and
peak are exactly equal across all three variants for every cell and round.
Focus and property operations allocate zero bytes; drop releases all retained
fixture bytes. Those checks all pass.

Keep the source isolated. The simpler private failure domain and actual
register return are useful findings, but they do not pay for the repeated
application losses. No follow-up representation, alignment tweak or retiming
is included in this cut.
