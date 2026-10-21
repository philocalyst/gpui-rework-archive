# Canonical identity lookup: first formulation held

Production candidate `4a80f08dd0`, measured fixture correction `32e47e5b1d`;
baseline `b15133e90d` is source `724ece73cb` plus the identical public fixture.
The candidate also includes `564e034027`, which reuses one validated logical
position inside the existing exclusive owner borrow. This campaign measures
the combined slice, not either change separately.

The retained BTreeMap is removed. Strictly increasing identities use a checked
offset and canonical-node binary search fallback. Other orders retain one
sorted u32 permutation; no identity key is duplicated. The node lane exposes
shared slice access only, and replaces its order as a whole. Lookup on a taken
tree stays empty even while its permutation allocation is reserved for reuse.
No unsafe or interior mutability is introduced. The Runtime header is exactly
2,384→2,376 B on this target; Node40/P80 are unchanged.

Default GPUI cases/doctests and strict accessible native all-target Clippy pass
(`checks.json`). An independent map oracle covers every permutation of seven
distinct IDs, holes, empty/taken/replaced trees and extreme u64 values. Public
fixtures verify retained target reversal rather than remounting keyed rows,
complete white pixels, exact action counts, and balanced owner destruction.

`frozen.json` pins independent Cargo targets, exact source revisions, identical
fixture bytes, lock/toolchain and four immutable SHA-named linked executables.
`capture.py` checks source/fixture/binary hashes before every process and refuses
an existing output directory. The accepted capture is `serial-20261021`: seven
alternating fresh-process pairs × 90 rows = 1,260 rows; existing unchanged app
controls add five pairs × 3 batches × 25 cases = 750 rows. All run serially on
CPU2 during a coordinated quiet window (20.73 seconds). Zero-allocation address
operations and balanced drops are guarded. Timings include headless public owner
operations, excluding native input, pixel transfer, startup and scanout. Percent
changes below are medians of per-pair changes; complete ranges and losses remain
in both summary CSVs. No statistical significance claim is made.

At 4,096 rows the ordered fixture retains 2,029,972→1,954,796 requested bytes
(−75,176 B). Mount allocations are 5,318→4,941. The permuted fixture retains
9,627,148→9,510,452 B after reversal, including its compact cold permutation.
Contiguous first/last focus and property calls improve by roughly 58–77%.
The four existing large style-control mounts improve by 13.6–16.3%.

**Hold:** the gapped first focus/property controls lose 42.8%/54.7%; permuted
first focus/property lose 13.8%/29.5%. Existing warm inspector override cases
lose 1.3–10.7%, and Todo-equal/Workspace-rotate lose 3.5%/2.6%. The permuted
last target still encounters the pre-existing linear realized-presentation
membership check, so these are complete public calls rather than pure index
latency. The memory savings do not establish acceptance of these losses.

An initial author fixture asserted exact equality with Oklch TRANSPARENT even
though the default property preserves an sRGB-transparent author value. That
untimed attempt is retained in `rejected-author-color-preflight.csv`; the final
fixture checks alpha and black-boxes target inputs. Both rebuilt release
preflights pass before the accepted capture. No partially recorded or
contention-time preflight is included in the paired result.

Next formulation should retain the canonical identity authority while improving
bounded dense permutations and the common ordered-gap case; it must be a new
source-pinned campaign. Neither this index nor Node24/P56 is integrated on main.
