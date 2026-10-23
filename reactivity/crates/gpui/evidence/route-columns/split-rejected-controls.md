# Outcome: reject the split-word route column

This is a separate structural hypothesis from the rejected packed-topology control. It is not adopted. The isolated source is frozen at `6403f62a918fb7c9ba50ecdd9ac5f4f52e75c266`, based on `89aeabd53942c3a4643bcb6fd978e6a24703f6d2`. No shipping source was integrated into main. No broad/default/native/strict/foreign-target qualification was run for this losing candidate.

The single preregistered capture completed all 180 observations in 16.7 seconds with exit zero. It used CPU 0, nine alternating baseline/candidate pairs, ten unchanged cases, fresh processes, fixed counts, and a 300-second process-group cap. Every raw observation and paired vector is retained. Nothing was deleted, repeated, replaced or resampled. All executable/source/fixture/fingerprint guards, operation counter/digest oracles and build-process audits passed.

Root granted GO at **2026-10-23 01:37:31 UTC** after the other workers' explicit quiescent holds and the root process audit. Root sent END at **2026-10-23 01:38:38 UTC** after successful capture completion and a second root audit. Both exact root process files and all runner per-pair process audits accompany the raw results. The runner is `fc582bcefac853ed94b3ee211721fee9044ec0449f5415ccd053973e4f422291`.

## All preregistered cases

Positive percentages mean the candidate is slower. Median paired delta is the median of the nine individual `(candidate-baseline)/baseline` percentages. Ratio of medians compares the two sets' median elapsed times. They are distinct estimators and are not substituted for each other. This one capture does not establish statistical significance, causal attribution or universal workload performance.

| Operation | Nodes | Routes | Repetitions | Median paired delta | Ratio of medians | Slower pairs |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Activate | 1,000 | 1,000 | 100,000 | +1.64% | +3.41% | 7 / 9 |
| Activate | 1,000 | 500 | 100,000 | +5.05% | +3.88% | 9 / 9 |
| Activate | 16,384 | 164 | 100,000 | +3.04% | +2.26% | 6 / 9 |
| Activate | 16,384 | 8,192 | 100,000 | -0.32% | +1.17% | 4 / 9 |
| Equal redescription | 16,384 | 0 | 32 | +9.50% | +9.34% | 9 / 9 |
| Equal redescription | 16,384 | 164 | 32 | -2.99% | -3.29% | 1 / 9 |
| Equal redescription | 16,384 | 8,192 | 32 | -1.22% | -1.03% | 3 / 9 |
| Resize | 16,384 | 0 | 32 | +0.40% | +0.65% | 8 / 9 |
| Resize | 16,384 | 164 | 32 | -0.64% | -0.60% | 3 / 9 |
| Snapshot | 16,384 | 164 | 32 | +1.07% | -0.28% | 6 / 9 |

The no-route equal-description loss in every pair and the activation losses fail the adoption gate despite retained memory savings. Resize is near baseline in this capture. The earlier packed control had different resize observations; the difference between these separate captures is not a causal attribution to one field or instruction. No follow-up measurement was requested or run.

Activation uses exact source updates and verifies zero owner reruns; it keeps lookup separate from mandatory redescription. Equal update verifies an owner rerun per repetition. Resize acknowledges each publication with zero owner reruns. Snapshot checks unchanged counters and expected target counts. The identical benchmark fixture uses the public Win/Target interfaces and actual mounted owners.

## Source, representation and actual codegen

Node is 24 bytes versus 40 at baseline. Parent retains its unchanged raw u32 representation. The other existing u32 word stores the sibling ordinal in 17 low bits and 15 low route-slot bits above it. Content's spare bits 29–30 hold the remaining two route-slot bits and its sign bit records presence. Bounds are checked before mutation, constants derive the bit widths from admission, and text/image decoding masks reserved route bits. Content replacement preserves installed route bits. Identity retains all 64 bits; component owner scope retains all 32 bits. There is no route key array, density policy, binary search, temporary ordinal overload, duplicated handler owner, reference count, unsafe code or new dependency.

The single boxed handler slice has a 16-byte header and 16 bytes per routed row, with no payload allocation when empty. Shipping source is 30,597 core lines, **+84** from baseline's 30,513. The counter excludes cfg(test), comments, examples, vendor and support sources under the established scope. Handler/Route public interfaces, Handler's 16-byte representation, El 176 bytes, Draft 152 bytes and Win 8 bytes remain unchanged on the 64-bit control.

Actual release assembly confirms raw 32-bit parent loads and u32::MAX checks in present_inner, with no parent decoding mask or decrement. Siblings reads the raw parent and masks the ordinal word. Route presence is a Content 32-bit load and sign-bit test. Activation inlines the two-word reconstruction, one handler-slice bounds check, direct slot indexing and Option null check. It has no outlined route helper or search. Linked `.text` is 3,729,591 bytes, 560 fewer than the frozen baseline benchmark executable; read-only data is 136 bytes larger. Describe is 32,517 bytes, activate 1,011, snapshot 1,903 and Siblings 495. These are actual executable section/function counts, not forecasts for another application.

## Complete-owner allocation and capacity bill

Runtime<()> grows from 1,824 to 1,840 bytes. The route fixture's actual Runtime with its model is 1,880 bytes, and that owner allocation is charged. Node vector capacities, description capacities, actual owner sizes, route density, captured payloads and old/next storage overlap are recorded in the 44-row actual-owner trace and delta CSV. The split owner's 44 rows exactly match the earlier packed control's parsed allocation fields. These are allocator requested bytes/calls, not RSS, usable allocation classes or a theoretical mirror owner.

| Actual mounted fixture | Retained byte delta | Mount peak delta | Mount request delta |
| --- | ---: | ---: | ---: |
| N=1, H=0 | 0 | 0 | 0 |
| N=1, H=1, no capture | +16 | +16 | +1 |
| N=100, H=1, no capture | -1,568 | +16 | +1 |
| N=100, H=66, no capture | -528 | +16 | +1 |
| N=100, H=100, no capture | +16 | +16 | +1 |
| N=16,384, H=0 | -262,128 | -262,128 | 0 |
| N=16,384, H=164 | -259,504 | +16 | +1 |
| N=16,384, H=8,192 | -131,056 | +16 | +1 |
| Workspace N=32, H=7 | -384 | -384 | +1 |

The public empty div is N=1, not N=0. Its no-route mount exactly matches all baseline request/live/peak metrics; after equal update its cumulative requested bytes are 16 lower while retained/peak stay equal. N=100 no-route mount peaks differ by actual model/description cohort: one saves 1,584 bytes, while an empty-capture cohort has a description-dominated +16-byte peak despite the same retained saving. All rows, including these losses and density transitions, are retained. Captured handlers retain the same 1,024-byte payload per routed site. Equal-update traces include simultaneous old routes/nodes, next routes/nodes and Draft where live; these are not summed again. Captured destructor sequence is preserved, but separate route storage changes backing deallocation order, so allocator-operation trace identity is not claimed.

## Correctness and provenance

The shipping implementation at `6694e899b2` passes 85 focused public tests: routes 8, components 10, inspector 15, lists 19, property actions 9, property selection 9, images 3, checkbox 9 and queries 3. The no-default library suite passes 153 with 6 ignored, including four split-field tests and six parent tests; those are not additional disjoint totals. The actual-owner ledger is explicitly run despite its ignore marker and passes.

Test-only successors add one ignored max-admission owner test. Final `6403f62a91` passes it: exactly 100,000 routed rows including root; public Target dispatch at split boundaries through slot 99,999; distinct captured exact-source assignments; eight exact updates and zero owner reruns; every retained route slot checked. The first harness attempt at `8d7ce59e96` read a recording snapshot before acknowledging its initial prepared scene and therefore observed zero published rows. That failure, source patch and artifact are retained. The corrected test acknowledges the scene exactly as the benchmark does. No shipping code changed in either test-only successor.

The 669, 8d and final 6403 release examples were independently rebuilt with selected artifacts reporting `fresh=false` and are byte-identical: **c3a47363379b610d97d379cbfcd0ef5afd03add6965042e3e5a1ddfa574f2d3b**. Six check-mode output oracles pass at final source. Actual final library and example compiler fingerprints are archived and match the reconstructed baseline's compiler, flags, profile, features, target IDs and Cargo configuration.

The old baseline fingerprint JSON had not originally survived the required source-switch clean. Before either packed or split timing, one matched baseline was rebuilt rather than inferring flags. Its executable is byte-identical to the original frozen baseline: **2b183734b499446cbda49ab5ee86357c89d9cbd45b1bc4e4166bfb41cffcb193**. Its actual library/example fingerprints and fresh artifact JSON, check-mode oracles and fresh release owner header oracle are included in baseline-requalification. Baseline's initial ignored allocator invocation and subsequent explicit passing execution remain in the record.

## Independent archive inputs

- Final source patch SHA-256: `55c27b634c1f5f03fba14b67dd9c89f80d59b03ef206466016c8eba12d3b98f4`.
- Runner SHA-256: `fc582bcefac853ed94b3ee211721fee9044ec0449f5415ccd053973e4f422291`.
- Final candidate and baseline executable hashes are recorded above and in the frozen binary manifest.
- Exact source patches, per-file source hashes, Cargo artifact JSON, actual fingerprints, counter ledgers, full source bill, assembly, commands, owner/capacity rows, all 180 raw timing rows, per-pair vectors, root/runner process audits and GO/END stamps are included.

Patches apply independently to the pinned base; the archive requires no unpublished producer commit. Large executables are omitted from the archive, with their exact hashes and artifact provenance retained. The earlier packed rejection remains separate in `packed-rejected-controls.tar.gz` (SHA-256 `15bd0680972cdad3f8713c0f38281fdcf1c2720e6fdebd5e5c8988e92a640e96`). Earlier AoS/SoA losing controls and all 540 original observations remain in their own archive. No result is erased or replaced by this rejection.
