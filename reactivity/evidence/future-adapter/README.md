# Bounded Future adapter evidence

Shipping source: `a951113912d32d6dca91c40b5b119c35056ea4a6`.
Matched baseline: `8158386886a45e66f9baba54643042638496e59b`.
All builds use isolated targets and two Cargo jobs. Source hashes in
[`source-freeze.json`](source-freeze.json) remained unchanged across final gates.
Earlier gates at `ff1f7224` are superseded by the complete-chain close correction.

## Final gates

| Gate | Result |
| --- | --- |
| GPUI desktop/X11/Wayland, parallel canvas, verified Cephal cache | 516 passed across 47 groups: 175 library units, 313 integration cases, 28 doctests; 27 ignored |
| Four-package strict Clippy, same full features, all targets | Passed with `-D warnings` |
| Headless reader/transport/allocation units | 12 passed |
| Native Future cancellation/result wake | 1 passed on private Xvfb `:113` |
| Existing ordinary native question/credit wake | 1 passed on the same display |
| Current-source Loom mailbox harness | 9 passed |
| Apple ARM64 and Windows MSVC, desktop/parallel, all targets | Both compile checks passed |
| GPUI format check | Passed |

Exact commands, log hashes and qualifications are in
[`final/checks.json`](final/checks.json). Foreign compilation is not runtime
execution. The native tests use the real event loop and ReferenceCpu presenter;
their watchdog deadline does not poll delivery. Xvfb 21.1.24 was launched with
`-screen 0 1280x800x24 -nolisten tcp -ac`. Artifact and feature hashes are in
[`final/native-artifact.json`](final/native-artifact.json).

The 17 public Future tests use actual `View`, `Questions`, `Win` and executor
traits. They cover never-waking replacement, latest-only coalescing, A→B→A
staleness, Ready/cancel races, early worker completion, rejection and lost-handle
half-acceptance, factory/poll/panic-payload/destructor failures, retry, previous
value/error projection, cancellation before first poll and during registration,
blocked destructor credit retention, unavailable dependencies, owner close and
natural Drop. The complete-chain close adversaries catch a head freezer,
queued Inbox payload or ready response destructor panic, then prove both task
handles were already cancelled/retired and the outer Inbox is closed. Borrowed
input/capture and foreign Source doctests fail to compile as intended; foreign
Reader admission is also exercised through the public API.

Loom includes current `linear_mailbox.rs` verbatim. Its new `into_payload`
method type-checks against Loom Mutex; the harness reports it unused. Those nine
tests model the mailbox, not the entire Future executor. No new synchronization
primitive or implementation-mirroring executor model was introduced.

## Ordinary owner and allocation controls

The pre-edit baseline artifacts/source/feature hashes are preserved in
[`baseline/source-and-artifacts.json`](baseline/source-and-artifacts.json).
The same ordinary closure consumers compile unchanged after the adapter.

| Headless u64/Infallible fixture | Baseline | Candidate |
| --- | ---: | ---: |
| Controller | 64 B | 64 B |
| Completion | 40 B | 40 B |
| Question plan / bound lane | 328 / 320 B | 328 / 320 B |
| Declaration allocations / requested heap | 2 / 120 B | 2 / 120 B |
| Projection allocations / requested heap | 2 / 88 B | 2 / 88 B |

Raw baseline and final ledgers are retained. A zero-sized Future producing a
4096-byte answer uses a 64-byte wrapper with a 40-byte Completion and performs
zero allocations during its poll. The result lives on that poll's stack, not in
a retained result slot. Executor task-node, pin-box, waker, queue and cancellation
allocations remain executor costs; the deterministic and native test executors
explicitly own such storage. Production GPUI adds no task box, erased Future,
Waker or request Arc.

The close barrier has a separate transient cost. The public inferred-LaneSet
fixture reports its retirement **value size**, not optimized stack-frame peak:

| Inline answer | Plan | Transient retirement value |
| --- | ---: | ---: |
| u64 | 328 B | 40 B |
| String | 336 B | 56 B |
| 304-byte page | 608 B | 336 B |
| 4096-byte array | 4400 B | 4128 B |
| 4096-byte array aligned to 64 | 4608 B | 4160 B |

Each detached Inbox receiver adds 16 B. Retirement sizes add across the static
chain; compiler frames/spills can differ. This storage exists during close,
keeps user response destructors outside the cancellation phase, and adds no
retained owner fields or heap allocation. See
[`retirement-stack.csv`](retirement-stack.csv) and its matched artifact record.

## Ordinary linked code and dependency bill

The unchanged real `question_input_cost` owner consumer was compiled in release,
default features disabled, at both pins. It was **not** run as a timing test.
The preserved executables and hashes are recorded in
[`final/ordinary-codegen.json`](final/ordinary-codegen.json).

| Actual control artifact | Baseline | Candidate | Difference |
| --- | ---: | ---: | ---: |
| `.text` | 4,032,903 B | 4,032,871 B | −32 B |
| Executable file | 12,807,080 B | 12,806,904 B | −176 B |
| GNU aggregate `text` (includes rodata/EH) | 11,290,977 B | 11,291,045 B | +68 B |

Both feature sets are empty and both profiles use opt-level 3, no debug info,
debug assertions or overflow checks. Section, relocation, padding and symbol
changes are retained separately. Worktrees have different paths. These are
actual linked-size controls, not identical-assembly or speed claims. The
candidate has zero `gpui::reader::future` or `pin_project` runtime symbols in
this ordinary consumer.

The always-available API adds a normal `pin-project-lite = 0.2.17` dependency
edge. The version was already locked, but this edge is new: the baseline's
default-off normal dependency graph contains no pin-project-lite. Its library
source is separately charged as 1,241 Tokei code lines / 57,246 source bytes;
source hashes and the toolchain Arc primitive audit are in
[`primitive-sources.json`](primitive-sources.json). No compile-time/RSS claim is
made. Executor internals are separately charged as described above.

The exact Syn+Tokei build-inclusive six-library ledger is 28,405→28,659 code
lines, **+254 first-party shipping lines**. Tests, comments, blanks and examples
are excluded; library build helpers stay included. Both full per-file ledgers
are retained. The external macro dependency is not silently included in, or
omitted from, that first-party figure: it is reported separately above.

Design, lifecycle obligations, rejected alternatives, and explicit stream /
optimistic / Solid-parity followups are in
[`docs/future-questions.md`](../../docs/future-questions.md). No unread Solid blog
article bodies or general rollback/stream semantics are claimed.
