# Outcome: reject packed topology route column

The single preregistered capture completed all 180 observations in 16.9 seconds, exit zero, after the parent's timestamped GO at 2026-10-23 01:07:53 UTC. It used CPU 0, nine alternating baseline/candidate pairs, ten fixed operations and the frozen v2 runner. No sample was deleted, repeated or replaced. All executable/source/fixture/fingerprint guards, counter/digest oracles and build-process audits passed. Raw observations, per-pair audits and the exact protocol are retained in `quiet-attempt-1`.

The candidate is not suitable for adoption. Its direct O(1) route column removes the earlier column controls' large activation losses, but redescription without routes and both resize cohorts regress in every pair. The actual retained-owner savings do not justify these repeatable whole-operation costs. No broad/default/native/strict/foreign-target campaign was run for this losing candidate, and no follow-up timing sample was taken.

Positive percentages below mean the candidate is slower. The median of the nine per-pair percentage deltas and the ratio of the two sample medians are different estimators; both are retained and explicitly distinguished. These are observations from this one capture, not significance or universal workload claims.

| Operation | Nodes | Routes | Repetitions | Median paired delta | Ratio of medians | Slower pairs |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Activate | 1,000 | 1,000 | 100,000 | -0.87% | -0.63% | 4 / 9 |
| Activate | 1,000 | 500 | 100,000 | -1.31% | -0.06% | 3 / 9 |
| Activate | 16,384 | 164 | 100,000 | +0.21% | -1.23% | 5 / 9 |
| Activate | 16,384 | 8,192 | 100,000 | -0.57% | -0.09% | 4 / 9 |
| Equal redescription | 16,384 | 0 | 32 | +7.82% | +7.82% | 9 / 9 |
| Equal redescription | 16,384 | 164 | 32 | -4.58% | -3.53% | 0 / 9 |
| Equal redescription | 16,384 | 8,192 | 32 | +1.08% | +0.88% | 5 / 9 |
| Resize | 16,384 | 0 | 32 | +8.94% | +8.33% | 9 / 9 |
| Resize | 16,384 | 164 | 32 | +8.40% | +8.35% | 9 / 9 |
| Snapshot | 16,384 | 164 | 32 | +0.21% | +0.04% | 5 / 9 |

Activation uses exact source updates and verifies zero owner reruns; it does not fold mandatory redescription into lookup timing. Equal update verifies one owner rerun per repetition. Resize acknowledges every publication without owner reruns. Snapshot verifies unchanged counters and the expected routed target count. The benchmark uses the public Win/Target interfaces, actual mounted owners and an identical fixture at both revisions.

The selected candidate remains frozen at `5135d88bc69c52543d0632726d4af07407668051`: Node 24 bytes, a 16-byte boxed route header and 16 bytes per retained handler slot. Shipping source grows by 89 core lines. Runtime<()> grows by 16 bytes; an actual no-route one-node owner is neutral, while an all-routed one-node owner retains 16 more bytes and adds one allocation. The actual Workspace fixture (32 nodes, 7 routes) retains 384 fewer bytes and adds one mount allocation. Large sparse retained savings, captured payloads, description peaks, density transitions and allocation overlap are fully charged in the packed control's 44-row complete-owner ledger. These allocator requested-byte counts are not RSS or usable allocation classes.

Compiler provenance was checked before measurement. The original baseline's actual fingerprint JSON had not survived the source-switch clean, so a matched baseline was rebuilt rather than inferring its flags. The rebuilt executable is byte-identical to the original frozen baseline. Its actual library and example fingerprints match the candidate's compiler, flags, profile, features and Cargo configuration, and are guarded by the v2 runner. The fresh release baseline owner test separately confirms Runtime<()> 1,824 and Node 40 bytes. The recovery and its initially ignored test invocation are preserved without altering the raw record.

The earlier packed control `8095615af6` is also retained. Actual assembly showed its outlined constructor called for both empty initialization and final topology. The selected one-line `#[inline]` successor eliminates those calls and folds the empty initializer; linked text grows only 16 bytes from that control and remains 416 bytes below the baseline benchmark executable. Parent decode/re-encode already cancels in Siblings, so no parent_slot helper or extra constant machinery was added. The timing losses remain after removing this demonstrated avoidable construction work.

All source patches apply independently to the pinned base. The evidence archive does not require access to an unpublished producer commit. Earlier AoS/SoA losing controls and all 540 original observations remain archived separately; this outcome does not erase or replace them.
