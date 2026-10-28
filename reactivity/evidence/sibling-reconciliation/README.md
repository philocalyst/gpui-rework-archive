# Flat sibling reconciliation

Candidate `eb2a286f950212014b0da01ea071763a4efe5593` replaces the temporary
ordered site and child-count maps with one flat buffer. Its two exclusive slices
hold N+2 prefix offsets and N child addresses. Existing admitted sibling ordinals
fill their ranges; the still-old identity index resolves a parent to its old row.
Keyed rows/lists, kind normalization, component-scope checks and retirement stay
on their original paths. There is no new retained field, refcount, unsafe code or
dependency. Nonempty scratch requests exactly 8N+8 bytes in one allocation;
empty scratch allocates nothing. Its scoped header is 24 bytes.

The exact old-map oracle covers wide, deep and mixed topological inputs through
100,000 rows. These manufactured helper inputs are not full layout fixtures.
The complete owner controls separately use ordinary public View/Win/update,
flat and grouped trees, with initial font/setup work outside measurement.
All 538 default cases/docs pass (nine ignored), as do strict all-target Clippy
and formatting. All 1,968 candidate input guards match after the release build.
Baseline `963b4409a2` changes only the same public consumer; shipping source is
identical to c00c030a98. The two final consumers have identical fixture bytes.

## Actual costs

Across three unchanged descriptions of 16,384 children, allocation calls fall
8,310→123 and requested bytes 65,311,026→62,578,914. Incremental retention is
zero in both; whole-operation peak remains 11,141,120 bytes. Description buffers
still dominate that peak. Small owner controls and every raw row are retained.
Optimized allocator rows reproduce the earlier debug rows exactly.

Seven alternating pairs per cohort, CPU 0, in the acknowledged quiet interval
23:11:54–23:11:59 UTC on 2026-10-22, take 5.269 seconds. All three agents held
heavy work; no Cargo/rustc/Clippy/Valgrind process appears in pair audits.
Executable hashes match before/after every pair. Unrelated host activity remains
uncontrolled. No samples were discarded or replaced; these are medians without
confidence intervals, not native frame/click, startup or RSS measurements.

| Public owner | Median change |
| --- | ---: |
| Tiny, one root | +1.73% |
| Flat, 1,024 children | −17.43% |
| 32 groups × 32 children | −21.64% |
| Flat, 16,384 children | −19.47% |

Positive means slower. Each process mounts and primes its owner before timing;
the timed interval includes entire repeated no-op model updates, description,
reconciliation and replaced-buffer disposal. It excludes process/font setup.
These fixtures exercise complete redescription, not changed-pixel painting.
The tiny loss remains charged. A future explicit empty/root representation could
avoid its remaining scratch allocation; that is not part of this source.

The linked test executable shrinks 15,328 bytes: .text −10,048, .rodata +16,
.data.rel.ro +88 and .eh_frame −1,012. The main describe_inner body itself grows
31,860→32,069 bytes; Siblings::new/children add 494/118 bytes. Removed specialized
map machinery accounts for the net linked reduction. Exact ELF metadata and
disassembly are archived, with no dynamic or summed-stack claim.

Actual core source grows 45 code lines, 30,468→30,513 including 18 build-script
lines. Tests/comments/blanks are excluded. The public control, private oracle,
Python runners, raw artifacts and vendor source are separate charges, not erased
by that count. No feature-parity or final-size projection follows.

## Reproduction and prior controls

Apply candidate.patch.gz to c00c030a98 for the exact shipping/test files, or
baseline-fixture.patch.gz for the unchanged-map consumer. Both are standalone
source patches; unpublished spike Git objects are unnecessary. Use repository
.cargo/config.toml with RUSTFLAGS/CARGO_ENCODED_RUSTFLAGS unset, locked offline
release builds of the sibling_reconciliation_cost test. Cargo JSON identifies
the exact executable. The ignored timing function requires SIBLING_COHORT.
Freeze executables separately, update the recorded absolute paths in pair.py,
and obtain a new quiet interval before running it. Never relabel another binary.

The first baseline/debug probe predates fixture formatting and the ignored timing
function; its fixture hash is preserved in controls/baseline.json.gz. The final
matched release consumers replace that probe as the allocation/timing evidence.
two-buffer.patch.gz preserves the earlier e95dfe8e64 control and its full suite.
Raw logs/disassembly preserve original bytes through deterministic gzip.
SHA256.json seals every archived file except itself.
