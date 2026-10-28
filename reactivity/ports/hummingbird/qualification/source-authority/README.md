# Published SQLite source authority

Runtime is frozen at 9f83f23288bbb364142ff2a82d059b6d99670a7e against sealed
9145411365adfe850b58cb6dafcfb64d1cc73221. Only four application source files
and two test files change. No Browser, core, dependency, lockfile, DSP, backend,
queue or worker-count change is included. The independent source-and-tests.patch
SHA256 is af28d487fcf881b855b1edcbda23931488f6026f04cfc8a9ea126f0018c8404c.

## Actual negative schedules and recovery

Test-only 3a537b722296407946fe141287db713d0a1bdc2a first proves the old named
Play-now failure. Test-only 1d16f079a11d4a929866cf567a25960382502613 proves both
named Play-now and visible Add-prepared against unchanged 914 runtime. A real
worker buffers Prepared at generation0, then acknowledges Replace and completes
its checkpoint at generation1 before the UI consumes old Prepared ahead of the
queued Replaced notification. Both old paths incorrectly append one queue entry
(expected zero). Both logs exit101. Final runtime rejects the stale source under
the authoritative lock without editing the queue or opening output. Selection
id/generation/sequence and audio Receipt authority remain independently checked.

Test-only 0eea15c7eedb65174068e06eeaa9f5138ff5bf11 against intermediate runtime
8862b270df1830ea0a348a16bbec6a5a1a8f3971 proves initial and replacement inputs
could be acknowledged while their SQLite transaction remained uncommitted.
Both tests fail, exit101. Final runtime rejects both inputs, does not publish or
consume a version on rejection, and admits the following committed replacement.
All three exact negative source trees, test-only patches, manifests, exit codes
and actual logs are preserved here. Frozen binary paths/hashes are in manifests;
the ELF files remain outside Git in the evidence directory. The initial named
binary hash is in baseline.sha256. A mistaken stale Browser binary copy was
identified and retained separately outside this package; it is not evidence for
any named-path result. A direct header run without the ALSA loader environment
failed to load libasound; that log and the corrected same-binary run are distinct.

## Ownership and linearization

WorkerHandle owns one Arc<Producer> containing the existing SyncSender and one
Mutex<Version>. The worker holds Weak between turns and upgrades once per
command. That strong reference is scoped inside the loop body and drops before
blocking recv; it cannot keep its own waiting sender alive. SourceLife is a body
local which publishes the reserved terminal generation MAX before the captured
result Remote drops and wakes its owner. MAX is excluded from all live source
generations, so no extra retained closed flag is needed. Poison and terminal
publication reject further callbacks, even when expected generation is MAX.
Final-handle drop, explicit finish, callback panic and bounded-result delivery
failure have functional controls. No public producer finish ceremony is added.

One private with_version kernel backs with_current_version and
with_current_source. It holds the source publication mutex through the supplied
application edit. Named preparation already carries Selection.generation and
uses the source-generation capability: the existing only in-place mutation adds
a new track and preserves existing TrackRef leases. No duplicated Version is
added to Pending or the UI. Context listings can use the exact-version capability
because imports change their ordering/filter membership. This API grants no
SQLite access and must not reenter WorkerHandle. App lock order is Source then
Audio desired. Queue scans and allocation can scale under those locks; this is
an application transaction, not a hard latency-bounded callback. Returned
QueueErrors occur before mutation; panic follows owner fault policy and is not
rollback.

The single worker commits SQL/replaces the admitted committed database before
publishing Version under that same mutex. It cannot dispatch a following SQL
read until publication completes. Source publication, not UI notification, is the
linearization point. A UI edit with old authority may finish before publication
only while replacement is genuinely concurrent; it cannot pass after replacement
acknowledgement/checkpoint. Prepend writes, projection and commit share one SQL
transaction; failures roll back before publication. Uncommitted input databases
are rejected before initial allocation/spawn or replacement assignment. This is
a contract for worker-controlled SQL/publication, not external SQLite writer,
scanner, filesystem-watch or cross-process invalidation coverage.

## Qualification and costs

Final child gates pass: 50 default, 116 CPAL and 116 native tests; one scheduled
clock test remains ignored. Strict all-target CPAL/native Clippy and native
example build exit0. Exact final changed-file hashes are in runtime-manifest.json.
Parent independently runs the integrated exact9f actual Registry client; its
source/binary guards and results are recorded in root-native-integration.txt.
No duplicate child native run, hardware playback or timing claim is made.

Application shipping source is 5633 versus 5521 (+112), measured with the existing
Syn/Tokei test/doc exclusion. Actual production core remains unchanged at 30987;
port source is not added to that core number. WorkerHandle shrinks16 to8 bytes;
Producer is40 bytes plus16 Arc bookkeeping (56-byte requested allocation),
Version remains16 bytes. Each command adds a Weak upgrade/drop and source lock;
handle cloning becomes one Arc increment instead of cloning SyncSender. No new
static storage. The primitive uncontended authority callback test requests zero
allocations; queue callbacks and worker SQL are outside that claim. Optimized
whole-application code size and throughput have not been compared.

The identical four-cohort public constructor allocation probe and its explicit
control/candidate deltas are in constructor-probe. It opens no AudioService or
device and measures only calling-thread Rust requests, excluding worker-thread,
SQLite C, OS and device allocations. These are not whole-player memory ceilings.

All adverse DSP evidence remains unchanged in the preceding qualification:
four unresolved pathological processing comparisons, constructor cohort24
1.429 [1.427,1.432] regression, untimed v2 geometry, changed filters and bounded
rate admission. No universal speed/resource/rate-coverage claim follows from
this correctness fix. CPAL pause occurs before callback fade-out can run; no
hardware fade qualification is added. Natural EOF live-output/2ms polling,
backend drain/token retirement and startup rendezvous remain separate gaps.
