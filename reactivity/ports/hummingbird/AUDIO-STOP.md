# Serialize Stop permission with desired state

This is a separate correction after frozen application source197fb3917d.
Its early Stop revocation could be overwritten by an older control already
holding the desired-state mutex. Stop then acquired the mutex and committed
stopped desired state without republishing the gate. After Stop returned,
PlaybackGate could still permit the previous stream until the owner reacted.
This is a persistent publication mismatch, not a callback already in flight.

The deterministic regression uses the existing change closure under its real
mutex; no production test hook or alternate scheduler is added. A barrier
holds that older control. Public Stop on a cloned handle revokes and blocks;
the test observes the revoked gate, releases the older control to publish,
then joins both threads. Frozen197 production fails because desired is
None/false/zero while the old stream is permitted. The same regression passes
with the corrected publication, including contention at the final revision.

Successful change and Stop now use the same small publish_gate operation under
the desired lock. Early conservative Stop revocation stays available before
lock acquisition; final locked publication guarantees the operation winning
that mutex also publishes last. Stop therefore adds two atomic stores on its
successful control path. No callback, decoding, pipeline, worker, queue,
retained field, allocation, dependency or identity policy changes. There is no
new performance or whole-process resource claim.

Additional controls cover stale Advance rejection, exhausted revisions,
cloned Resume without a source, explicit later Play, terminal close racing a
publication, and public Stop/finish through clones against a real WAV decoder
and opened bounded stream. Closed remains monotonic and dominates later
in-flight epoch/playing publication. A scheduled timing test stays ignored.
The negative source, exact fixture, failed binary/hash and all qualification
logs are preserved in qualification/audio-stop-publication and its recorded
external artifact directory. This does not change or relabel earlier frozen
app/transport/audio evidence. The startup rendezvous/OnceLock proposal remains
separate and unimplemented.
