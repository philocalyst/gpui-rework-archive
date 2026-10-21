# Static question inputs: pinned implementation and controls

Implementation: `d94d3da171a144eb3b9c264f89c31301131e67c3`, based on
`724ece73cb665a1f6d83e97ae7d431eee11a887a`. No dependency or manifest changed.
The ordinary source-only spelling is preserved; paired/nested inputs and earlier
Readers use the same production owner and native delivery barrier.

`pins.json` freezes both source sets, the identical benchmark source, exact
executables, machine and release profile. The baseline worktree contains only
the added identical control fixture. Each variant has a separate Cargo target
directory. `capture.py` checks every source/executable hash before and after
seven alternating fresh-process pairs, pins to one allowed CPU, checks all three
case outputs, and refuses to overwrite an existing capture. These three controls
use a one-pixel empty View and owned `u64` values; they are API operation controls,
not a frame-time, realistic app, native startup, or tail-latency measurement.

The exact-source control changes only an unrelated direct field. The coalesced
control changes the declared source while its one physical cap remains held. The
completion control accepts one result, then edits its source and receives the
next cap. Each case times 20,000 operations per process. It includes ordinary
runtime/layout/presentation barriers appropriate to that case, while construction
and destructor cleanup are outside the timer. All timing rows, including losses,
are retained; no benchmark assertion chooses an adoption outcome.

## Storage and ownership

See `candidate-ledger.txt` and `baseline-ledger.txt` (Rust 1.97.1, x86-64, default
features). An empty plan still allocates nothing. The measured one-source plan
shrinks 384 → 328 B, bound set 376 → 320 B, Completion 72 → 40 B, Controller
96 → 64 B. Its two cold allocations request 152 → 120 B. Reader remains 16 B;
projection description still allocates twice / 88 B. These are allocator request
sizes, excluding allocator rounding, RSS and the existing native wake slot.

The two-source plan is 368 B; three nested sources 416 B. Source handles cost
40 B each, in addition to their 4 B revisions; there is no claim that complete
source dependencies cost only one revision. Optional packs are 8 B for one
source, 12 B for two, and 16 B for three. A Reader version is 16 B. The complete
Source question followed by a Reader-plus-Source dependent is 656 B in this
fixture; adding that dependent allocates one 80 B controller request and shares
the scope. No per-dependency allocation/refcount or worker-side version vector
is added. Larger frozen inputs/outcomes and application executor allocations
remain the application's real retained costs.

The app Library freezes query bytes and order together, scans 250K tracks using
stack title formatting, checks cancellation every 128 tracks, and owns at most a
128-ID page. One explicit worker retains its existing 256 KiB stack. Domain save
and restore persist inputs, reconstruct a fresh plan, and remint Reader keys.
No executor, task, completion, mailbox, or request authority is placed in the model.

## Actual linked consumer code

`codegen.py`, `codegen.json`, and both assembly files inspect the linked release
control executable. On this build, `.text` is 3,288,231 → 3,285,159 B (−3,072 B).
The actual `Win::set` monomorph is 2,550 B in both variants; `deliver_ready` is
1,924 B in both. `start_pending` is 1,418 → 996 B; `apply_questions` 1,868 →
1,013 B; `refresh` 1,615 → 1,231 B, plus the candidate's 323 B outlined typed
Source resolver. The control loop itself grows 5,279 → 5,301 B. These sizes are
specific linked-artifact observations, not universal application code-size claims.

The Source-only specialization removes Reader-tail traversal. It retains an
outlined direct Source-resolver call and its widened result ABI, a concrete cost
that the timing controls must include. No annotation or alternate formulation is
mixed into the frozen source before measurement. The transport now moves only
its independently stamped typed result, instead of copying a 32 B diagnostic
InputVersion through Work, Completion and Message.

## Validation and limits

`checks.json` and logs retain 281 default GPUI cases/doctests (7 manual
ignores), strict accessible X11+Wayland all-target Clippy, 3 credit / 9 exact-source
mailbox Loom tests, and actual X11 Question and 250K Library scripts on DISPLAY94.
The native Question script tests paired sources, coalescing with held physical
credit, an earlier Reader dependent, synchronous downstream completion, and real
WorkReady progression without an unrelated input wake. A stale environment's
DISPLAY93 initially failed XOpenDisplay; both final execution gates used the
live DISPLAY94, not a replaced or mocked host.

Public tests cover both Source dependencies, unrelated exact skips, nested and
duplicate sources, equal-revision coarse replacement, earlier/foreign keys,
blocked repeated observations, Pending/Fault previous values, two Reader
convergence, combined old dependent/upstream terminals, fault recovery, deferred
synchronous completion, accepted answers after failed presentation, close, panic
quarantine and complete diagnostics. The mailbox source/protocol is unchanged;
Loom verifies that exact transport source, not the sequential input-family logic.

This settles each frozen batch without intermediate publication. Across turns,
independently projected Readers still expose progressive current/previous state;
this is not atomic multi-output cohort reveal. Library's query/order caption is
inside its retained SearchPage, so those rows and labels belong to one answer.
Reader input lookup traverses the concrete earlier tail; many consumers of an
early producer can cost quadratic work. There is no dynamic tracking, memoized
output equality cutoff, arbitrary cross-owner edge, or complete Reader graph.

## Frozen paired results

Seven alternating fresh-process pairs, 42 rows, CPU 0, all source/executable and
case checksum guards passed. Times are medians of each variant; percentages are
the median of the seven paired percentages, not a ratio of those two medians.

| One-source control | Baseline | Family | Median paired change | Full pair range |
| --- | ---: | ---: | ---: | ---: |
| Exact unrelated edit | 43.72 ns | 42.57 ns | −2.62% | −6.94% … +9.63% |
| Coalesced declared-source refresh | 681.27 ns | 690.31 ns | **+0.59%** | +0.13% … +3.27% |
| Completion plus next refresh | 1,415.09 ns | 1,389.05 ns | −1.66% | −3.36% … +0.58% |

The coalescing loss is retained; unrelated-edit results are noisy. There is no
frame-time or statistical significance claim. The source-only controls support
adopting the functional slice and lower retained storage, not a general speedup.
No inline or further codegen variant was mixed into the measured cut.

One initial runner attempt stopped before recording any paired rows because
libtest prefixes the first emitted CSV line with its test-name text. The runner's
parser alone was corrected and the complete unchanged seven-pair campaign rerun.
The initial unpaired output is preserved in `parser-preflight-failure.txt`.
