# Stop publication correction

Frozen production control197fb3917d; negative test-only source24feab3c9e;
corrected production/test source d9137cb37e9473bfdbbf09f17a7d21cb5e708314.
Core integration rehearsals, request-only rejection evidence and the original
197fb app remain untouched in their clean worktrees. No main files changed.

The baseline fails deterministically (exit101) after both control threads have
joined: desired is stopped but PlaybackGate permits the old stream. The test
holds the real change mutex using its existing closure, starts public Stop on
a clone, observes its early revocation, then releases the older publisher.
There is no production hook, test scheduler fork, callback in flight or owner
thread whose later reaction could hide the mismatch. The same exact regression
passes after the fix, including the final revision boundary.

The correction borrows the gate in one small shared publication method. Normal
changes and the final Stop state publish under the same desired mutex. The
initial conservative Stop revocation stays; successful Stop adds two final
atomic stores. No retained field, worker/queue, dependency, decoder, pipeline,
callback or startup rendezvous changes. Shipping Syn/Tokei port source falls
5,327→5,324 and service630→627; this is not a machine-code or performance claim.

Three core cases cover the forced race, cloned stale Advance / rejected Resume
without source / explicit later Play / exhausted revision, and terminal close
dominating an already-started publisher. A public actual-service case captures
the real provider's gate after WAV open, verifies Stop through a clone, checks
that Resume cannot revive the stopped source, and finishes/closes with other
clones retained. The existing full public Library/service/codec/oracle suite
passes:92 tests, one scheduled test ignored. Strict native all-target Clippy
passes. No new timing or hardware execution is claimed. Default-only source
is unchanged; its previous42-test qualification remains separately frozen.

Fresh host header controls report service32, handle8, Shared160, Intent136,
Token24, Receipt32, Event56, AudioBlock48, Pipeline432, Media192, CPAL stream160
and owner1128 bytes. No field definitions changed. The ordinary cold CPAL
constructor caller requests11 allocations/4,891 bytes,4,874 retained in that
thread-scoped control; child allocations, OS stacks and process memory are
excluded. An initial direct header launch omitted ALSA's loader path and exited
before tests; its libasound error is preserved. The same binary under the
recorded environment passes both header/cold controls; no source fix or timed
retry was involved.

The negative binary remains external at the path/size/SHA in summary.json.
Exact source/test/command manifests, negative/fixed logs, patches and source
bills are retained. Startup OnceLock and any further ownership simplification
remain separate proposals, not part of this correction or its evidence.
