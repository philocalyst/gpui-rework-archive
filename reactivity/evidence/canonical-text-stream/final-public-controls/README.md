# Final public text controls: correctness and codegen, no timing

Production remains `9f934e85b5b6211a3985b830ce4dcc672a1ffe16`, unadopted. This checkpoint changes evidence only. No performance capture or timing entry has run. The clock-free full-work qualification passed all 140 executions: exactly the preregistered 70 cells on both frozen normal binaries, with matching complete observable outputs and source/fixture/binary before/after guards. No work count, cap, threshold or production policy changed in response to verification. Native cohorts passed 128 changing selection cycles each, actual provider failure retaining old presentation, repair and queued work at close.

Both controls contain root's exact `cc74e92d7fb2ffd9eedb9b66813a79c2fcfc41b5` production close prerequisite: baseline `9874a6e15bf4f69e63ae493924c093583375e12b` is main51f plus that line; candidate `501368955ee9021c56933614522dfb087620dc81` is text fixture/source c6d plus the identical line. The physical source, manifest and fixture paths are identical between variants. Each build forced fresh gpui, canvas and public caller compilation. Normal binaries have no counting allocator or dev dependency edges. All four lanes use shipped SIMD, X11/accessibility, opt3/noLTO/CGU1/debug0/stripnone, jobs1 and root flags `-C symbol-mangling-version=v0 --cfg tokio_unstable`. Separate codegen targets append only `-Zemit-stack-sizes` through Cargo configuration, with bootstrap enabled only there. Fingerprints, full 1,983-file source maps, compiler versions and actual commands are in each matrix's metadata.

Three complete matched matrices are preserved. V1 (`matched-release-codegen`) retains the original four-cycle public oracle and six native cohorts. Source review then found that the ordinary queries excluded the terminal caret and tiny selection was collapsed. V2 (`matched-release-codegen-terminal`) includes terminal offsets/upstream terminal affinity and a nonempty tiny selection; its native cohorts add minimal two-unit selections and a combining grapheme exceeding u8 character length. V3 (`matched-release-codegen-final`) adds only `verify CASE OP COUNT`, running the identical ordinary work with clocks disabled. All four normal/codegen baseline/candidate lanes pass their four-cycle public/native oracle comparisons in every matrix. The final 70 full-count cells use V3 normal binaries. Earlier matrices are historical controls, not substituted timing results.

`fixture-final` is byte-identical to the physically built final external package. `fixture-terminal` reconstructs the exact V2 source and asserts all freeze hashes. V1 source and every original setup failure are in the sibling [public preflight checkpoint](../public-native-preflight/README.md). The final fixture remains outside production and uses real public Win/Window/Map/AccessKit APIs. Every arrow and drag cycle checks actual movement; text and transform sources alternate actual values and ACK each cycle. The ordinary oracle also checks C1, failed C2, older eligible ACK and repair against the old full-map transcript and pointer. Final native output checks unique ACK work; raw repeated same-token startup exposure callbacks are retained separately. Its busy lane measures a structural 256-row update plus ACK, then real selection plus ACK and provider GetSelection. It does not model simultaneous input contention or monitor scanout.

The source simplification shares retained source-byte stops across geometry and native character indexing. Distinct bidi/soft-wrap affinity positions remain distinct. Completed interactive empty text retains the existing producer's byte-zero stop; an empty stop Vec represents passive/discarded geometry. No point is invented for an unacknowledged layout, and no C/P ownership changes. Native source boundaries group equal-byte aliases only for character indexing. Logical editing of a failed newer source still segments the current source, rather than using old displayed geometry as its authority. Password masking, preferred-column navigation, IME composition and autoscroll are absent in this source and are not claimed as implemented or tested features.

The actual committed six-library Syn/Tokei core is 30,692 → 30,688 (−4), including four removed `let map = self` aliases. The algorithm/API source bill is essentially flat; this is not a broad source-deletion claim. The public Unicode editor/preview/inspector example costs 58 versus 45 code lines (+13 outside library core). The sibling [functional/resource checkpoint](../functional-resource-checkpoint/README.md) preserves scoped Clippy, public text/drag/keyboard/scroll/native/a11y suites, frozen old-walk differential tests and six matched fresh-process whole-owner allocation ledgers. Calls, requested bytes, retained bytes, peaks, headers and map leases are exactly equal. Iterator values shrink 72 → 48 and 168 → 144 bytes; there is no retained-heap reduction or memory-win claim.

## Optimized code and frame costs

Final real linked callers, all dependency crates carrying stack metadata:

| Caller | Baseline `.text` | Candidate `.text` | Delta |
|---|---:|---:|---:|
| Ordinary public application | 3,519,479 B | 3,515,015 B | −4,464 B |
| Native public application | 11,664,279 B | 11,661,175 B | −3,104 B |

Representative individual functions, code bytes / metadata frame bytes:

| Function | Baseline | Candidate |
|---|---:|---:|
| TextSite::shape_for | 463 / 168 | 402 / 168 |
| grapheme_at | 850 / 376 | 850 / 264 |
| move_visual | 1,691 / 328 | 1,175 / 216 |
| position_on_line | 2,185 / 360 | 1,664 / 232 |
| Ordinary query_selection | 1,484 / 312 | 1,157 / 200 |
| Native Input::native_position | 1,290 / 488 | 1,039 / 360 |
| intervals constructor | 43 / 0 | 154 / 16 |
| Ordinary graphemes constructor | 78 / 0 | 178 / 16 |
| Native graphemes_in constructor | 351 / 24 | 356 / 16 |
| Native runs constructor | 333 / 88 | 401 / 88 |
| Native run count fold | 722 / 200 | 737 / 120 |
| Native selection_rects caller | 1,105 / 344 | 1,513 / 328 |

The constructor, native selection caller and run-count code growth are real costs. Added/removed helpers and every selected physical code body, frame and mangled alias are preserved in `all-bodies-ledger.json`, full `*-elf.json` records and assembly. Normalized demangled names can collide across instantiations: `*-frame-delta.json` is only a convenience view and must not pair colliding bodies by its overwritten name key. The complete ledger preserves multiplicity instead. Physical unique-body totals deduplicate aliases by address. Frames are individual compiler metadata, not transitive dynamic stack, and are never summed to cancel a larger helper.

Actual interval assembly uses scalar source-byte/affinity comparisons and a monotone line cursor; range admission uses scalar partition searches. Existing floating-point geometry uses ordinary compiler vector/scalar instructions. There is no manual SIMD stop scan or vectorized boundary-walk claim. A source-level SIMD rewrite of ordered, interleaved stops would add a separate algorithm and boundary handling; it is not part of this frozen candidate. Smaller linked code and frames do not establish lower latency.

## Preregistered capture awaiting root review and quiet GO

`timing-fixed-work-registration.json` is the original count/gate freeze, written before full-work verification. `timing-final-registration.json` adds final binaries, all 70 full-count expected outputs, source/fixture hashes, exact runner hashes, raw log hashes and completed qualification references. Work remains 70 cells × 11 paired repetitions = 1,540 observations, CPU0, hard 900-second cap, zero warmups, fixed alternating cell/variant order, no calibration, retry, resampling or adaptive counts. Ordinary metrics cover isolated geometry queries and actual public owner hit/arrow/drag/transform/reshape work. Native per-cell metrics independently cover median/p95/p99/max complete provider-cycle and host-ACK durations, plus 60 Hz budget exceed counts.

Each cell and metric must pass independently. At least 9/11 positive paired duration ratios is a reproducible regression (exact sign tail 0.03271484375), even inside the 1% band. Otherwise the ninth sorted ratio must be ≤1.01; failure is equivalence unproven, not permission to adopt. Native budget counts use the separately frozen nonpositive difference bound. No aggregate gain offsets a loss. A speed claim additionally needs all gates passing and a representative non-tiny actual owner/native cohort meeting the frozen ≥5% improvement gate. The busy scope and lack of physical scanout measurement remain explicit.

`capture_final_timing.py` requires `--quiet-go` and the exact final-registration SHA; it has not been invoked. It checks source, fixture, binary, runner, profile/environment, CPU affinity and quiet process guards, runs each fixed observation once, verifies its exact frozen output, preserves raw per-cycle arrays and stops on failure/timeout. `analyze_final_timing.py` implements the frozen independent gates. `timing-analyzer-selfcheck.json` contains synthetic analysis-only checks for equality, regression inside the equivalence band, eight-positive equivalence, equivalence unproven and native budget regression. Those checks are not measurement observations. No timing capture directory exists at this checkpoint.

Verbose build logs and selected assembly are gzip-compressed with mtime0; `archive-ledger.json` records original paths, uncompressed SHA256 and stored SHA256, verified by decompression. Frozen executable binaries remain outside Git at the metadata paths and hashes. All original failures remain preserved in the earlier checkpoints; no functional failure is relabeled a measurement. At sealing, this agent owns no compiler/native/client/counter/Xvfb process and awaits review, with no timing authorization.
