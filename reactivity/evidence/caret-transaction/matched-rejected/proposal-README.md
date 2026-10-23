# Flags-matched indexed control and proposed pair campaign

No timing has run. Candidate shipping bytes are 62e4047420, on archived tree b5d5fc63e93554d67a56cf010349d5569b288794. Indexed control 045b6c344fe5e27d4d0b4a49f96f73118687c616 restores ONLY four shipping modules to main 8c17a763ee7a5f1d2d932d375d2c839759d8a28b. The exact change is control.patch. Main was not modified.

Both variants were built at the same physical manifest/source/fixture paths, using the same compiler, lock files, root config and all other 421 source-closure bytes; jobs1, RUSTFLAGS and CARGO_ENCODED_RUSTFLAGS unset. The actual five library/profile fingerprint pairs have equal flags, features, profile, config, path and target. Required changed libraries and selected executables have Cargo fresh:false. Historical flags-empty artifacts remain unmatched and are not controls here. Raw build JSONL/logs and copied fingerprints are preserved in the result files.

comparison.json contains every whole TextLayout allocation row and selected assembly ledger; required-fingerprint-comparison.json contains exact actual Cargo fingerprint fields. Selected .asm files and raw section/symbol lists are retained separately. Both public transcripts are byte-identical: 2,678,729 bytes, SHA256 1d529192f8bce827403feb865c800d20054ef98b96fa8043e29edce018f69a4f. All 14 layout checksums and retained bytes agree.

| Cost | Indexed | Partial | Delta |
|---|---:|---:|---:|
| Shaper client .text | 1,172,312 | 1,179,576 | +7,264 bytes |
| Native owner client .text | 3,693,111 | 3,701,751 | +8,640 bytes |
| First C allocation calls | 383 | 381 | -2 |
| First C requested bytes | 21,246,272 | 20,590,912 | -655,360 |
| First C peak bytes | 12,817,120 | 12,170,700 | -646,420 |
| First C retained bytes | 1,091,736 | 1,091,736 | 0 |
| RTL layout calls (cold/warm) | 506/53 | 507/54 | +1 each |
| RTL layout requested bytes (cold/warm delta) | | | -366,996 each |
| RTL layout peak bytes (cold/warm delta) | | | -333,408 each |

Old P/new C and failed L keep the same semantic checksums/live ownership deltas; old C acknowledgement remains zero allocation and frees 484,476 bytes in both. First-C improvement is workload-specific and is not a universal allocator-call win.

The partial entry is 3,165 bytes and subtracts 728 stack bytes; logical borrowed visitor 1,749/648, RTL visitor 399/360, append 935/136. Stack subtractions are function-local, not additive residency. Planner is 14,895 bytes indexed versus 14,523 shaper /14,741 native-owner partial. Partial still has a 152-byte offset-construction memcpy and retains old owned fallback APIs. count_graphemes is 306 bytes with scalar unrolled flag loads/adds, no SIMD/popcount. RTL exact first reserve removes prior 32,768-byte growth slack at 4,500 scalars in favor of 18,000 bytes, at the cost of one RTL flag scan. The shipping source increase versus81bd remains +87 non-test code lines; no retained field, extra output/range/visited buffer, unsafe or f32 reassociation was added.

The frozen pair.json/run-pairs.py proposal uses seven alternating pairs, seven fixed cases, cold/warm scopes, 196 observations, CPU0, hard cap300seconds. Tiny/label use128cold/512warm rounds; other cases16cold/32warm. All samples/checksums/raw stderr and min/max paired ratios are retained; there is no retry, trimming or resampling. Guards verify frozen binaries/reports, current candidate closure, immutable indexed Git closure, fixture and root config before/after. The runner has only been AST parsed, not executed.

Proposed acceptance: all correctness and source/fingerprint guards pass, all196 observations complete, every cell's median paired partial/indexed ratio <=1.02, and the geometric mean of six latin/rtl/mixed cold/warm cell medians <=0.98. Any failure/incomplete capture means no adoption from this campaign; all results remain archived. Seven pairs do not establish universal performance; this measures scoped Planner latency, not end-to-end native frame latency. Root may accept/change this proposal before timing GO, after which the registered campaign is fixed. A pass still requires root review of the explicit code/allocator costs.
