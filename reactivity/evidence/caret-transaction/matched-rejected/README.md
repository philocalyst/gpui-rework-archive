# Rejected transaction experiment: matched 196-observation campaign

**Root rejected 62e for adoption.** The one preregistered campaign completed all 196 observations in 45.577634626 seconds with 868/868 guards passing before and after. The original gate is false: RTL cold regressed 3.430%, RTL warm 3.165%, and the geometric mean of the six bulk cell median paired ratios regressed 0.873593% against the required improvement of at least 2%. No resampling, changed gate, new build or further timing occurred. This evidence commit changes no shipping code and integrates no API into main.

## Frozen source and execution identity

* Shipping candidate: `62e4047420310da7c9e72836c1dbde1d7f215343`, built on sealed evidence tree `b5d5fc63e93554d67a56cf010349d5569b288794`.
* Indexed control: `045b6c344fe5e27d4d0b4a49f96f73118687c616`, restoring exactly four text modules to main `8c17a763ee7a5f1d2d932d375d2c839759d8a28b`. Other 417 paths in the 421-file directly guarded text-pipeline closure agree. Complete immutable Git build/control trees also differ at only those four paths; whole-git-tree-diff.txt and the archived tree manifests record that stronger provenance. The 421 direct hash guards cover Canvas/Core/Parley/Engine, not every GPUI/native dependency file. Source snapshots, exact standalone patches and provenance are archived here; control.patch retains the exact preregistered bytes.
* Original runner `run-pairs.py`: SHA256 `908460525c546a8df39606bc2c7d102200fe0cc612fd48240dfc4df21651452c`; original registration `pair.json`: `5be49fe94296f15a97eeeca1bb527121ab557be967539f3b1295999a918eb4b6`. Both remain byte-for-byte unchanged. Their original PROPOSAL wording is historical; root authorized and executed the single capture.
* Root reports GO 2026-10-23 04:10:18 UTC and END 04:12:20 UTC after both Sol explicit ACK holds. Original full root process audits, empty runner stdout and phase attribution are in root-*. Root reported no concurrent build/native/measurement processes. These phase stamps are explicitly attributed to root; start.json independently preserves the runner timestamp.
* Frozen binary paths/hashes are in review-hashes.json; runtime ELF files remain in `/tmp/gpui-caret-transaction-bin/`. Large ELF files are not duplicated into Git. Candidate/control public output transcripts are archived compressed and agree byte-for-byte: 2,678,729 bytes, SHA256 `1d529192f8bce827403feb865c800d20054ef98b96fa8043e29edce018f69a4f`.

Both variants used the same physical source/manifest/fixture paths, exact compiler, locks and source inputs; jobs 1, environment RUSTFLAGS/CARGO_ENCODED_RUSTFLAGS unset. Copied actual Cargo fingerprints establish the root config flags `-C symbol-mangling-version=v0 --cfg tokio_unstable`, identical features/profile/path/target/config in all five required library/profile pairs, and fresh:false for changed libraries and selected clients. Raw build JSONL/logs, exact root config and the unmodified public fixture inputs/locks are retained. Historical flags-empty binaries stay historical and unmatched: they are never relabeled controls for these measurements. Earlier stale-target, font-overlay and lock-upgrade failures remain preserved in the parent/final archives, including the rejected six-package ICU/Yoke lock upgrade.

## Every latency cell and tail

CPU 0, seven alternating pairs, fixed seven-case order, cold then warm; pair start alternates indexed/partial and partial/indexed. Tiny/label use 128 cold / 512 warm rounds; other cases use 16 cold / 32 warm. Each scope has seven samples per variant. Every raw output, checksum, pair and stderr is retained in timing-196-root/raw.jsonl. No observations were trimmed or rerun. These measure scoped Planner latency, not native frame latency.

Percentages below are partial/indexed minus one; positive means slower. The preregistered statistic is **median of seven within-pair ratios**, distinct from **ratio of the two independent sample medians**. Min/max are all seven paired ratios, including adverse tails. verification.json retains all absolute per-round samples and both statistics.

| Case | Scope | Median paired | Ratio of medians | Min / max paired |
| --- | --- | ---: | ---: | ---: |
| tiny | cold | -0.934% | -1.137% | -9.170% / -0.265% |
| tiny | warm | -0.139% | +0.532% | -2.125% / +1.153% |
| label | cold | -5.826% | -5.571% | -6.678% / -3.578% |
| label | warm | +0.175% | +0.003% | -3.152% / +1.125% |
| latin | cold | -0.223% | +0.100% | -0.492% / +33.460% |
| latin | warm | -2.742% | -2.351% | -21.999% / -1.433% |
| rtl | cold | +3.430% | +3.274% | +2.058% / +4.219% |
| rtl | warm | +3.165% | +3.531% | +2.551% / +3.851% |
| mixed | cold | +0.624% | +0.276% | -0.586% / +1.059% |
| mixed | warm | +1.118% | +1.118% | -0.915% / +9.850% |
| paragraphs | cold | -1.451% | -1.613% | -4.973% / -0.104% |
| paragraphs | warm | -0.955% | -0.475% | -2.081% / -0.377% |
| one-grapheme | cold | -0.042% | -0.201% | -2.286% / +0.220% |
| one-grapheme | warm | -0.344% | -0.203% | -1.142% / +0.725% |

The Latin cold +33.460% and mixed warm +9.850% adverse samples remain in the raw set and all calculations. The preregistered gate requires every cell median paired ratio <= 1.02 and the geometric mean of six Latin/RTL/mixed cold/warm cell medians <= 0.98. Actual bulk ratio is 1.008735932042269; both RTL cells violate the cell limit. Seven pairs are a scoped qualification result, not a universal statistical claim. Root's rejection is final for this candidate.

## Every whole-TextLayout allocation cell

The table reports partial minus indexed. Full absolute indexed/partial count, cumulative requested, live-retained and peak allocator payload bytes, byte lengths and identical checksums are in comparison.json. Retained allocation is unchanged in every row; allocation figures are not RSS.

| Case | Scope | Calls delta | Requested bytes delta | Peak bytes delta | Retained delta |
| --- | --- | ---: | ---: | ---: | ---: |
| tiny | cold | +0 | +0 | +0 | +0 |
| tiny | warm | +0 | +0 | +0 | +0 |
| label | cold | -2 | -360 | -324 | +0 |
| label | warm | -2 | -360 | -324 | +0 |
| latin | cold | -2 | -616,000 | -435,808 | +0 |
| latin | warm | -2 | -616,000 | -435,808 | +0 |
| rtl | cold | +1 | -366,996 | -333,408 | +0 |
| rtl | warm | +1 | -366,996 | -333,408 | +0 |
| mixed | cold | +0 | -417,464 | -364,128 | +0 |
| mixed | warm | +0 | -417,464 | -364,128 | +0 |
| paragraphs | cold | +0 | +0 | +0 | +0 |
| paragraphs | warm | +0 | +0 | +0 | +0 |
| one-grapheme | cold | +0 | +0 | +0 | +0 |
| one-grapheme | warm | +0 | +0 | +0 | +0 |

RTL costs **one additional allocator call** in both scopes, despite reducing requested/peak bytes. Tiny, paragraphs and the one-grapheme workload see no allocation improvement. The actual output layout structures and retained bytes are identical. No universal allocation-call win is claimed.

## Owner, source and machine-code bills

| Native owner stage | Indexed calls/requested/peak/live delta | Partial calls/requested/peak/live delta |
| --- | --- | --- |
| First C |383 /21246272 /12817120 /1091736 |381 /20590912 /12170700 /1091736 |
| Old P/new C |341 /21232796 /12253348 /482088 |339 /20577436 /11607828 /482088 |
| Old P/old C after failed L |338 /21232656 /12253348 /483084 |336 /20577296 /11605560 /483084 |
| Exact old-C ACK after failed L |0 /0 /0 /-484476 |0 /0 /0 /-484476 |

The native owner client asserts acknowledged P remains authoritative while newer C and failed L exist, then exact old-C ACK publishes the correct b geometry. Checksums agree across variants at every stage. First C saves 2 calls / 655,360 requested / 646,420 peak bytes, while retaining the same 1,091,736 bytes. Live deltas include old-map releases; they are not additional retained fields. This change did not alter GPUI preparation/publication/ACK code.

Matched linked .text increases **7,264 bytes** in the shaper client (1,172,312 to 1,179,576) and **8,640 bytes** in the native owner client (3,693,111 to 3,701,751). The source increase remains **87 non-test code lines versus borrowed 81bd**, and **453 versus indexed 1d5** (28 first-party / 425 vendor). The six first-party libraries remain 30,448 non-test code lines including 18 build-script lines. These true Syn/Tokei ledgers remain in ../final and are not recomputed or relabeled as timing measures. Extra archival Python tools and copied Rust fixture source have exact per-file byte hashes and physical/nonblank line counts in archive-support-source-ledger.json. Those extra counts are explicitly physical/nonblank, not fresh AST/Tokei code counts: the previously recorded Tokei Nix executable is absent, and no rebuild was authorized or attempted. Copied fixture bytes are archival duplication, not shipping implementation.

Generated partial entry is 3,165 bytes with 728 bytes local stack subtraction; logical borrowed walk 1,749 / 648, RTL visitor 399 / 360, append 935 / 136. Planner is 14,895 bytes indexed versus 14,523 shaper / 14,741 owner partial; frame subtractions 4,096 + 472 indexed versus 4,096 + 440 / 4,096 + 424 partial. Separate frames cannot be summed as measured peak residency. Partial retains one 152-byte offset-construction memcpy and the old owned fallback; Clusters remains 272 bytes and owned Cluster 144 bytes. Exact count_graphemes is 306 bytes, scalar flag loads/adds unrolled by four with a scalar remainder, **no SIMD/popcount**. All selected disassembly plus raw symbols/sections is archived.

RTL reserve(run.len()) scans existing Character flags once per RTL run, with no retained certificate field. It reduces the preserved no-reserve 8d control's 4,500-character initial capacity 8,192 slots / 32,768 bytes to 4,500 slots / 18,000 bytes, while geometric reserve reuse can still retain later slack. The static panic 62e cleanup removed 21 bytes of Debug formatting and 48 bytes from its matched minimal client; that narrow improvement does not erase the complete-client growth above. The old atomic API keeps full preflight/zero-callback admission, and partial callbacks remain explicitly observable outside Canvas. Canvas alone rolls back its local unpublished carets. Structural restart discards deferred nonfinite geometry and delegates to the original indexed error authority. No extra output/range/visited buffer, unsafe, retained layout field, source reordering, alternative segmentation or f32 reassociation was introduced. Correctness and lower allocation payload did not overcome the measured RTL latency regression.

## Qualification and historical limits

The final 62e source had Canvas parallel 193 passed / 4 ignored, scalar 183 passed / 3 ignored across 28 harnesses each, strict Canvas all-target parallel Clippy, private overlay 19 passed with 17 stock tests explicitly filtered, public native 83 complete transcript agreement, and the 94,176 accepted / 41,760 snapped / 11,096 distinct-pair packed source oracle. The initial unfiltered private overlay had 30 passed and **four unrelated stock font Cluster failures**, preserved verbatim; the narrower rerun is not presented as a successful full vendor suite. Private checked-admission/bitwise tests cover 396 real producer layouts, late invalid geometry before structural restart, fragmentation, repeated/decreasing requests, disjoint/decreasing ranges and empty metrics. No impossible-memory >u32 allocation or fabricated private reversed Engine offsets are claimed. Parent/final archives retain original logs, exact test overlays, source guards and every failed/unmatched experiment.

## Offline reproduction and integrity

Run `python3 verify.py` to recompute all 196 rows, exact order/rounds/checksums, all 14 medians/ratios/tails, original failed gate, snapshot hashes, actual fingerprint settings and fresh:false proof. It applies/reverses standalone patches in a temporary directory, checking candidate and indexed module bytes. It never builds or executes a benchmark. whole-tree-patch-verification.json additionally records an independent temporary-index reconstruction of the exact complete b5 and045 Git tree IDs from the full standalone patch; normal indexes and working files were untouched. Git reported whitespace warnings from preserved historical disassembly while applying that full patch; exact resulting tree IDs matched, so those evidence bytes were retained. archive-sha256.json covers all files in this directory except itself. compression.json records original uncompressed hashes for compressed logs/symbols/transcripts.

For source reconstruction, extract candidate-source-closure.tar.gz into a clean folder; this is the exact 421-file directly guarded text-pipeline closure, including the original example and source/lock files. Apply indexed-from-candidate-b5.patch there to get the indexed control modules; indexed-four-modules.tar.gz supplies those exact bytes independently. candidate-from-main8c17.patch reproduces the four candidate shipping modules from the named indexed main commit; candidate-from-borrowed 81bd.patch reproduces the candidate from the named historical borrowed base. full-build-tree-from-main8c17.patch.gz reconstructs the entire tracked b5 build tree, including unchanged native/GPUI inputs, from the named main commit; the tree manifests identify every tracked blob. The public-fixture directory preserves exact literal manifests/source/lock inputs and root-cargo-config.toml preserves the global flags. Absolute historical physical paths in the manifests are intentional and recorded; a relocated rebuild requires explicit path adjustment and must be reported as a new build. The sealed runner and registration remain historical artifacts: **do not run them again for this rejected candidate.**
