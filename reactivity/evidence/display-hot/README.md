# A: hot parameters with unchanged traversal

Baseline: local/display-radix **bb21d11455b6a03d134f99377c5a16b983fac27f**.
Preregistration **32878eff7a835238e60a8af44ffb51af90f4fc5f** includes independent
mechanisms A/B, later combination gates, and a concrete prototype timing gate.
This correctness checkpoint's frozen source is
**5d4a977f0e51a8350d7e333da2ee98f5464b022c**. All changes local, zero shipping
library edits. No timing, speedup, production integration or ZGX claim yet.

**5749 CPU checks,208 exact actual GPU hot-parameter frames and33 cold-control
frames pass.** Strict all-target Clippy passes. Independent staged-memory replay
covers254 scripted frames and matches every produced GPU readback. The actual
round-robin eviction mutant fails4 decoded color bytes at deferred fence1 while
pixels remain correct. Stale-render suppression is insufficient to prove old
parameter/resource lifetime.

A retains the exact full painter traversal. Only initially registered dynamic
paint bindings replace inline color with a stable hot-key index; static colors
remain inline. Six `(epoch,value)` slots cost48 GPU bytes per hot key. The root
selects the greatest epoch not newer than its own. One old visible + three
submitted + one eligible frame can require five different old versions; the
sixth slot admits a new candidate without overwriting any of them. This explicit
admission bound, staged writes and fence ownership are essential. It is neither
coherent shared memory nor an arbitrary O(1) UI update algorithm.

The same sealed ordinary public Win::set fixtures and independent full GPUI/
fresh-Window pixel oracles are reused byte-for-byte. The registered source-to-
identity adapter is still offline and restricted. Paint edits use cached support
from initial binding admission, avoiding both cold record decode and directory
path copy. Generic live layout/clip support maintenance, source fanout and
production journal/backend integration remain missing. The next traversal
mechanism must not inherit this encoding for its standalone comparison.

| Records | Radix candidate bytes/edit | A candidate bytes/edit | A GPU version storage, one key | Full traversal visits/edit |
| ---: | ---: | ---: | ---: | ---: |
|1|1072 (148 raw)|104|48B|512|
|9|1148 (532 raw)|104|48B|4608|
|32|1108 (1636 raw)|104|48B|16384|
|256|952 (2020 uncompressed)|104|48B|131072|
|1024|952 (2020 uncompressed)|104|48B|524288|

104B is8B hot slot +64B immutable frame root +24B fixed arguments +8B shared
current authority. Actual audit commands add4B, for108B and four queue writes.
No cold page bytes or directory words change. It is a byte-count improvement,
not a timing result. The hot field scans six version epochs on GPU; static color
reads also test the hot flag. That decode overhead can outweigh fewer uploads.

First update CPU work:1 key lookup,1 distinct authority entry,6 latest-entry
examinations,6 version comparisons,6 victim-entry examinations,2 damage records.
At maximal five-authority pressure, selection can examine30 version entries,
plus latest/victim scans. No whole-hot-table scan occurs on a point edit. Key
retirement currently has an explicit maintenance scan; it is not an incremental
structural optimization. Capacity, namespace, generation and u32 epoch admission
are checked. Dense1024-key storage costs49152 GPU bytes, before CPU key/support
metadata: that is a real compression/storage counterexample.

At1024 records the overlapping COW heap high-water is18064B versus radix20240B,
plus the separate48B hot buffer. At the last pending checkpoint, COW meaningful
live payload/directory/root bytes are11532B; CPU reachable model objects total
177834B. Retained pixels, authority, parameters, audit output/readback, Python
object overhead, current maps, support and generation bookkeeping remain
separate ledger categories. These are prototype measurements, not a Rust ABI,
whole application RSS or complete driver allocation accounting. Dense hot cells
are charged even when their versions do not all contain meaningful values.

The stress case retains an initial visible frame and three submitted roots,
then prepares seven newer unsubmitted eligible candidates before the oldest
actual command is submitted. Submission backpressure remains in force; every
extra8-byte hot write,64-byte root and8-byte authority write is itemized. The
old command must decode its own old color while preserving the latest submitted
pixels. Correctness holds with safe eviction. Round-robin overwrites the needed
old version and fails4 decoded bytes while the pixel oracle alone stays green.
The CPU model also holds old authorities through1000 successive candidates,
tests exact arbitrary u32 values, no-op updates, foreign namespaces, invalid
epochs, retirement and key generation reuse. The CPU mutant fails at epoch7.

The shared shader still passes the sealed full-traversal1024-node control,
real image/glyph resource replacement control, old/new geometry damage control,
and97-node structural move/remove/insert control:33 exact frames. These controls
exercise relevant unchanged branches; unrelated broad suites were not repeated.
The main mutant's wire `args[5]` remains0 so stale-authority logic is intact;
its eviction decision alone changes. The inherited ledger's generic `mutant`
field is0 for that reason; summary.json/filename identify the hot eviction mutant.

Run `python3 verify.py`. It verifies captures/source guards, executable and
embedded shader identities, frozen CPU replay, reused baseline source/oracle
files and independent GPU-memory/pixel replay. Timing endpoint implementation is
next: a resident GPU worker must include model preparation, serialization/IPC,
actual staging and GPU completion in the round-trip interval. Until it passes
the preregistered cost gate, A is a correctness-qualified storage alternative.
