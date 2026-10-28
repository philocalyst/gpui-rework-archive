# Hot parameters, traversal, and measured prototype cost

A baseline is sealed local/display-radix bb21d11455b6a03d134f99377c5a16b983fac27f.
No future publication authorized. This branch isolates mechanism A; mechanism B
will descend separately from the same radix baseline. No production adoption or
ZGX inference. No agents/delegation. Preserve failures and raw/serial controls.

## A: versioned hot paint, unchanged traversal

Retain authoritative compressed cold chunks and the same full painter scan.
Initially registered dynamic paint bindings may place a stable hot-key index
in the cold record instead of a color. Static paints remain inline. Each hot key
has six (u32 sequence,u32 value) entries in GPU-visible staging storage,48 bytes
per key. Semantic roots select the greatest sequence not newer than their own.
The explicit live authority domain is at most3 submitted roots,1 visible root,
1 eligible root; a sixth temporary slot admits a new candidate without changing
any value needed by those five old authorities. Namespace lives in the immutable
frame root; hot keys cannot cross windows. Slot reuse needs fence/semantic proof,
not merely a newer eligible sequence. No coherent memory or lock-free claim.

For one registered paint edit, protect the versions selected by live epochs,
write one8-byte slot and one64-byte frame root. No cold block rewrite or directory
path copy. Charge the per-key48B, CPU hot identity/support maps, protected-epoch
scan, touched damage, every write and all retained versions. Decode scans up to6
version entries per hot field read: reducing upload may increase GPU work.
Source fanout, dense hot scenes and tiny raw controls may lose. Do not silently
make all properties hot. Exact bit preservation includes arbitrary u32 colors;
rendering admission remains the sealed restricted opaque domain.

Required executable checks: unchanged public source fixture and exact full
renderer pixels; old decoded hot values after deferred oldest submission;
reverse completion notifications, repeated newer eligible but unsubmitted
candidates while three submissions are held, all slots cycling, no-op updates,
foreign namespaces, malformed/out-of-order epochs, retirement/reuse and bounded
storage. Deliberately round-robin overwrite a still-needed value; that mutant
must fail a version/byte oracle even if stale pixels are suppressed. Preserve
sealed image-resource and cold-geometry behavior when the shared shader changes.
Reuse immutable source fixtures/binaries where unchanged; do not rerun unrelated
broad checks. Keep97-node movement as the cold-record structural counterexample.

## B: damage-directed traversal, unchanged record encoding

Separate branch from radix; do not inherit A's hot encoding for its first gate.
Compare a coarse spatial chunk directory with the full traversal. Initial index
construction, each changed bounds/membership entry, tile-list/COW copy and all
structural ordering work count. No global rank repair hidden outside the ledger.
A tile list must preserve painter order and conservatively include every record
that can contribute under inherited transforms/clips. A directly addressed dirty
subtree does not justify ignoring overlapping siblings. Geometry support remains
explicitly restricted; unsupported filters/clip transforms are rejected/fallback.

Decisive scene pair: fixed target edit plus increasing unrelated noncontributing
subtrees should not increase visited records; an overlapping scene where many
contributors legitimately matter must retain the charged full contribution set.
Include old/new geometry support, structural insertion/removal and the97-node
move. A rebuild-on-structural-edit variant is permissible only if its full O(N)
work is exposed and compared, never described as an incremental structural win.
Bounded mutants omit an overlapping sibling, old support, or painter ordering.

Only combine A+B after their separate correctness/cost gates. Any combination
must rerun relevant interaction gates rather than inheriting independent passes.

## Timing gate preregistration

After each mechanism's bounded correctness gate, make a cost decision rather
than extending correctness-only models indefinitely. Endpoint is explicitly
**prototype binding patch → completed offscreen GPU pixels**. It is not native
GPUI application update time, a display scanout measurement, or a ZGX comparison.
Use one resident Rust Vulkan worker and a synchronous JSON-lines pipe from the
Python model owner. Start before model patch/prepare, include packing/serialization,
IPC, actual staging calls, GPU dispatch/completion wait and reply; stop on reply.
Report preparation, wire/IPC, worker staging/encode/submit/completion separately
where directly measured, plus whole round-trip and all persistent/temporary
storage. Independent full oracles/audit readbacks run outside timed intervals;
completion remains inside. State software-driver and instrumentation limitations.
If this endpoint cannot be implemented without materializing a whole scene or
hiding work, reject that timing attempt instead of summing mismatched timers.

Controls: sealed compressed full traversal, serial raw/uncompressed path, A with
same traversal, later B with same encoding; optional A+B only after qualification.
Scenes:1,9,32,256,1024 records; sparse noncontributors and overlapping contributors;
one dynamic key and a dense-hot storage counterexample. Same colors, visible edit
area and completion policy across alternatives. Capture cold initialization,
first update,64 warmups then512 measured edits, six independent process rounds.
Alternate control/candidate order ABBAAB across rounds, no concurrent build/test/
analysis/cleanup. Preserve every sample and p50/p95/p99, upload bytes, record and
version visits, index/allocator/CPU/GPU/in-flight retained bytes, compiler/device
identities. No tolerance, workload shrinkage or dropped slow runs.

A local cost admission requires median per-round p95 round-trip ratio<=0.95 on
both256/1024 sparse scenes, no>1.05 p95 regression at1/9/32 after an explicitly
selected raw fallback, and no>1.05 p95 regression in1024 overlap. If a mechanism
fails, report the failure and measured tradeoff; do not retune thresholds. Memory
is a separate Pareto decision: list sparse and dense-hot losses, never amortize
through invented application frequencies. No performance claim before these
measurements. Physical hardware and production integration remain later gates.
