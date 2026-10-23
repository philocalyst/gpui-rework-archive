# Constructor and retained representation costs

The matched startup constructor has a reproducible resource regression with the
expanded UI (+20.6–20.9KB retained and +530–531 requested allocations). This
resource comparison does not pass; whole-player performance remains unmeasured. The same unchanged four-cohort
constructor source used by9f produces the following candidate-minus-control
results; raw rows and mechanical deltas are retained. There is no timing test.

| Calling-thread Rust request scope | Cold0 | Warm1–3, each |
| --- | ---: | ---: |
| Retained heap plus final Win inline header | +20,605B | +20,925B |
| Total requested allocations across phases | +530 | +531 |
| Total requested bytes across phases | +81,463B | +82,451B |
| Retained allocation requests across phases | +98 | +98 |
| Mounted phase peak requested bytes | +24,460B | +24,780B |
| Mounted phase peak allocation requests | +99 | +99 |

Spawn is byte-for-byte identical to9f. Connected adds one allocation and56B
(total/current/peak). Mounted adds529/530 total requests,97 retained requests,
20,501/20,821 retainedB and81,407/82,395 total requestedB. Phase peaks are separate
observations, not a summed simultaneous whole-owner peak. Cold retained plus
inline100648→121253; warm96328→117253.

Library552→632 (+80), Questions592→640 (+48), Win656→704 (+48), LibraryEvent96→104
(+8). These are overlapping inline views and cannot be summed three times.
Selection32, SourceError64 and AudioError32 remain unchanged. WorkerHandle8 and
Producer40/56-byte Arc allocation remain the exact9f formulation. No new static
storage, worker or channel. The result lane still admits8 messages; a successful
listing message owns an O(N) metadata vector, not a constant-size heap envelope.

Separate public-type probes measure Browser96, Navigation48, Input72,
PlayRequest40, PreparedListing32, Page112, TrackRows56, Collections32,
CollectionRow72, TrackSearchRow72, queue Entry16, EntryKey8, Track88, TrackRef8.
An empty-query frozen Input requests one80B Arc allocation; a1024-byte query
requests1104B across two allocations. Cloning an existing Input Arc does not
copy the query. Page borrows its input from TrackRows rather than owning a third
Arc. Track and card adapters each own their shared input; per-realized-row
context closures add Arc references, not query-string allocations.

Navigation length is bounded100; Vec capacity/allocator rounding are separate
from that length. Current page rows, titles/artists, card strings and prepared
metadata scale with collection size and String/Vec capacities. Ordinary tracks
have no playlist-ID vector allocation; playlist pages store one i64 per item
capacity in their separate vector. Cards currently duplicate an id already
carried by Route, an explicit8B/card representation opportunity left in the
frozen review candidate. Existing queue undo (30 entries plus its large-change
pruning policy), queue metadata, active/retired audio and provider storage remain
additional retention. There is no new absolute application memory ceiling.

The constructor opens no AudioService/device. It measures allocations only on
the calling thread; worker-produced Page/SQL/metadata allocations, SQLite C,
OS/device allocations and RSS are excluded. It is a startup constructor bill,
not a measurement of every ready page or a maximum full-player resident set.
The capability callback's earlier zero-allocation test does not cover queue
edits or this UI. The performance/resource non-regression requirement remains
unqualified for the expanded UI; these increases cannot be offset by historical
kernel wins. Native playback is functional qualification only.

The standalone manifests differ in filesystem paths and add a header-only
binary using the already-enabled triomphe dependency; constructor main source is
byte-identical to control. Logs include actual incremental compilation work,
not cold-build benchmarks. The production package manifests/lockfile and thus
crate feature graph do not change; native qualification still pays the existing
CPAL/ALSA, accessibility and graphics dependency build costs.
