# Three application correctness fixes

The sealed rehearsal736afe8/runtimeb73 remains untouched. This successor starts
there and preserves test-only negative pin131260dee0, where all three new public
tests fail with exit101. `frozen-negative-source/`, negative-tests.patch and
baseline-manifest.json retain the actual tests/source identities; immutable
test binaries remain at the external paths with hashes in that manifest.
The original adversarial review is retained verbatim.

Runtime source d1dbb3de6f fixes:

1. A natural 8000→48000 predecessor followed by a valid44101Hz WAV can fail
   successor FFT admission after predecessor samples were accepted into output.
   Preflight admission once when the successor opens, while the preceding
   pipeline is still owned. Failure uses existing FailedDraining, preserving
   every prior sample without overlapping pipelines or adding state/queues.
   The public bounded sink holds all1494 predecessor frames without consuming
   them, verifies no stream drop, then consumes them. Every sample equals an
   independent pinned Rubato oracle with explicit160/960 geometry and integer
   final-frame/delay accounting. The negative drops the stream and loses them.
2. Failed preparation now stores its full Selection. Same-source changes to
   id/sequence, generation changes and library source replacement invalidate
   that failure. Controls cover immediate Closed, typed worker MissingTrack and
   result-lane terminal close. Request exhaustion binds the current selection
   while revoking earlier Pending work; private issuance remains monotonic.
3. Deferred Play uses the authoritative service revision. A receipt snapshot at
   intent capture/status is only a hint. The private replace_if operation locks
   desired, checks Closed/matching revision/checked next revision, then invokes
   the application queue edit and publishes the owned plan/gate under that lock.
   Rejection invokes no queue edit. Queue play_now checks availability, occurrence
   exhaustion and key exhaustion before append, then installs its known fresh
   retained key. No returned QueueError follows append; failure is not treated
   as rollback. A panic still follows the owner fault policy, without rollback.

This is an application queue edit, not a hard latency-bounded callback. Vec
growth, allocation and entry/lookahead lookup can scale with queue size while
desired is held. It must not re-enter AudioHandle. The method stays private to
the crate with one shipping UI call site. Public handle clones remain supported.
The successful path transfers one owned Plan instead of cloning another copy;
rejected work does not clone the prepared track into the queue. Pending authority
is retired before the queue edit. The public typed AudioError::Queue variant
preserves the queue failure rather than erasing it into an arbitrary string.

The exact public clone-Stop negative leaves the prepared result buffered, lets
Stop win, then consumes events: old code appends1 entry; fixed code appends0.
Further public controls cover active clone Pause/Seek/Stop, fresh explicit Play
after cancellation, and Unavailable preserving existing queue/stamp/audio
revision. A core barrier holds the actual transaction across queue edit and
publication while Stop waits; the two controls linearize at revisions2 then3.
Other controls prove mismatch/Closed/MAX reject before callback and QueueError
publishes neither a new revision nor permission. These are deterministic state
and credit proofs, not scheduling/performance intervals.

## Qualification and costs

All44 default,100 CPAL and100 native-feature tests pass; the one scheduled-clock
test remains ignored. Strict all-target CPAL/native Clippy passes. The unchanged
actual Registry/public Window fixture passes with its original150/180second
watchdogs and5second kill grace: real SQLite import/Unicode search, original
Prepare/Play-now/Stop actions, real AudioService decoding, zero credits followed
by64-frame bounded output, quiescent final disconnect visibility and WM close.
Before/after source and binary guards match; owned children exit. This run uses
the same public application constructor and counting output, without hardware
or private owner patches. No timing campaign or performance claim is made.

The final documentation correction after these gates changes only the transaction
comment: it removes a latency-bound claim and clarifies scaling/panic semantics.
No runtime token changed. candidate-binary-manifest.json preserves candidate
test/native binary identities and external immutable copies.

The identical public constructor probe compares sealed736 with the successor,
CPAL feature enabled but no AudioService/output opened. Four cold/warm cohorts
measure UI-thread Rust requests; worker allocations, SQLite C, device/OS and RSS
are excluded. The failed-selection identity costs8 bytes in Library's maximum
variant layout:552→560. Questions600, Win664, LibraryEvent96, Selection32,
SourceError64 and AudioError32 are unchanged. No new global/static storage,
retained queue, worker, result slot or retry state is added.

Each cohort adds8 requested retained bytes,8 total requested bytes and8 peak
mounted bytes, with identical allocation request counts. Cold retained UI plus
Win becomes100600 versus100592; warm96280 versus96272. Cold mount peak154206
versus154198, warm149886 versus149878. This is an explicit correctness cost,
not a monotonic-memory win or a universal heap ceiling: existing variable-length
errors, library data and queue contents remain variable. Full rows/probe/locks
are preserved under constructor-probe/. Actual CPAL owner headers are service32,
handle8, Shared160, Intent136, Token24, Receipt32, Event56, block48, pipeline432,
Media192, CpalStream160 and Owner1128; native-feature Owner is1120. Feature
differences are retained without claiming a cross-feature saving.

Syn/Tokei counts port src5358→5472 (+114), excluding tests/comments/docs/examples
and archived evidence. Shipping core remains30987 and untouched. No whole-app
optimized machine-code or latency comparison was made. No static data allocation
was introduced; source growth is charged rather than presented as code deletion.

## Scope retained

All earlier qualification and unfavorable DSP history remains adjacent: four
unresolved pathological processing comparisons, changed-filter constructor
cohort24ratio1.429 [1.427,1.432], untimed v2 geometry and bounded rate admission.
The previous Stop publication correction and rejected request-only authority
candidate remain intact. Main adoption is Root's decision.

Pause documentation now states that CPAL pause may stop callbacks before the
15ms fade-out; fade-in callback tests do not establish hardware pause behavior.
No fade/backend redesign is included. Natural EOF still retains live output
and a2ms owner loop; Library Drained only changes UI status. Output backend
drain and control-thread notification analysis remains a separate follow-up,
with no EOF lifecycle mutation hidden in these fixes. The pre-existing async
decoder-start failure/rendezvous limitation also remains.
