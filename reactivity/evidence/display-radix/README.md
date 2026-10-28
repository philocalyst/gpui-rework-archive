# Bounded COW publication, decoded display chunks and actual pixels

Local experiment, not production adoption. Frozen executable/model source:
`e254d42901`; first pair remains `36f700a734`, preceding chunk/resource subgates
remain `57ccf254851e12839da4b5deedd5c7047b686c80`. Preregistration `f1e9d54bf8`.

**241 exact actual Vulkan pixel/record/resource frame comparisons pass**, plus
3906 CPU checks. Independent replay simulates all296 scripted positive/negative
frames from staged memory, separately reconstructs pixels, and checks every
actual readback produced. Five actual GPU mutants fail their exact oracles;
a premature submitted-root release also fails the CPU ownership oracle. Strict
all-target Clippy passes. Software Vulkan/llvmpipe only; no timing, scanout,
hardware, performance-adoption or ZGX claim.

The point path is an ordinary `Win::set` background source assignment, one
statically registered Target/property read, one stable identity lookup, one
compressed chunk mutation, two old/new damage records, one COW directory path,
a64-byte immutable frame root, staged GPU writes, GPU decode and retained pixels.
The **registered binding is an offline restricted fixture adapter**: Rust emits
source events and independent full-render oracles; Python applies the identity
patch and emits jobs; Rust executes those jobs on Vulkan. This is now a composed
representation-to-pixels model, but it is not a production GPUI journal/backend.
Initial source admission enumerates the snapshot and draws once. Subsequent
candidate point edits do not materialize a scene or expanded mirror. Full GPUI
and fresh-Window rendering, ledger walks and GPU decode audits are separate
explicit diagnostics and are not counted as candidate update work.

| Requirement | Status in this checkpoint | Boundary |
| --- | --- | --- |
| Authoritative lossless ordered chunks, stable identity index | Implemented in model |32-record chunks, u32 fields; GPU directory admits32768 physical slots |
| Direct point identity → chunk → old/new damage → pixels | Restricted adapter only | Ordinary public paint setter, static registered binding, integer opaque rectangles |
| COW publication without whole page/resource-table copy | Implemented in model | Two32-way levels;128-byte root +256-byte leaf per touched group; explicit delta keys |
| Tiny raw fallback, arbitrary exact field bits | Implemented in model | Tiny raw bypass omits node directory; fallback choice not yet adaptive; entropy tests randomize six payload fields |
| Dependency closure and structural updates | Restricted adapter only | Paint closure is one node;97-node model move/remove/insert, full painter oracle; generic layout/clip dependency journal missing |
| Submitted/eligible/visible leases and stale authority | Implemented in model | Up to3 submitted roots plus prior visible root, one ordered Vulkan queue, deferred oldest and reverse completion notifications |
| Failed newer source preparation preserves eligible pixels | Restricted adapter only | Public NaN-transform SetError::Committed, invalid source stays committed, prior eligible scene rendered/presented; no rollback claim |
| Image resource replacement → exact final pixels | Restricted adapter only | Opaque endpoint RGB,8×8 at1:1 integer geometry, default Linear sampling, overlap and clipping |
| Text/image resource-byte lifetime | Implemented in model | Actual captured glyph/image bytes read through leased resource directory; production atlas integration and glyph pixels missing |
| Coherent CPU/GPU shared memory | Still missing | queue.write_buffer is staging, not coherent shared memory |
| Generic public-API production integration | Still missing | No shipping library edits, zero source compatibility claim beyond exercised APIs |
| Competitor/hardware performance win | Still missing | No timings or ZGX inference from this experiment |

## Fixed edit sweep

All sizes have a visible32×16 target with the same edit, clipped/overlapping static
content,12 source assignments and fresh full-Window pixel oracles. Counters per
assignment:1 source read;0 owner reruns, layout runs, descriptions and paint
passes. These **fixture counters do not prove zero generic production walks**.
Mutation reads one index entry and5 field words, then decodes at most32 records.
No resource entries are examined. A1024-unrelated-resource CPU comparison also
retains zero resource-entry examinations and identical directory word copies.

| Live records | Compressed bytes rewritten | Candidate staged bytes/edit* | Raw control staged bytes/edit* | Record rows decoded | GPU record visits per rendered edit |
| ---: | ---: | ---: | ---: | ---: | ---: |
|1|592|1072|148|1|512|
|9|668|1148|532|9|4608|
|32|628|1108|1636|32|16384|
|256|472|952|2020|32|131072|
|1024|472|952|2020|32|524288|

*Candidate staged bytes include payload, copied directory paths,64-byte frame
root,24-byte fixed argument portion and8-byte shared current-authority value.
Actual audit runs additionally upload4 audit-count bytes plus8 bytes per audited
resource key; audit output/readback buffers and full pixels are diagnostics. One
queue call is not the unit of cost. Point compressed edits make6 actual writes
(payload, leaf, directory root, frame root, arguments, authority); tiny raw4.
At256 and1024 records the full candidate upload is respectively the same952B;
actual no-resource audit runs upload956B. Decode/encode scratch and Python
allocations remain charged in per-frame ledgers.

The directory copies32 root words and64 leaf words for each point edit. Graph
ownership is not free: first-edit ref increments are5,5,5,12,36 across the sweep;
retirement decrements and later fanout work are recorded separately. This grows
with occupied fanout, bounded by the admitted directory, not by an unqualified
constant-time claim. The renderer still walks every live record for each damaged
pixel. No bounded total GPU work or rendering breakthrough is established.

## Storage, versions and resource costs

At1024 repeated records the authoritative CPU chunk payload is10848B, with
12288B identity wire entries and512B page headers. The compressed overlapping
heap high-water is20240B, of which16B is the reserved null prefix. At the last
three-pending checkpoint its live allocations total20224B:14056B meaningful
payload/directory/root bytes plus6168B allocation fragmentation. It includes
leased old versions; it is not merely the newest scene. The CPU reachable Python
object graph at that checkpoint is191089B, separately measured, not a Rust ABI
forecast or total application RSS. Diagnostic GPU buffers and retained16384B
pixel surface are additional, as are8 authority bytes and per-pending parameters.

Tiny fallback actually removes node directories: at1 node the current raw page
plus frame root is116B versus1040B compressed; at9 nodes500B versus1116B. Raw
still costs metadata:12B identity/node +16B page header plus CPU current maps,
reference graph, allocator and object headers captured in the reachable-object
ledger. At32 nodes raw loses:1604B current page/root versus1076B compressed.
Therefore "always raw through32" is a comparison, not the selected policy.
At1 node with six high-entropy exact fields, compressed page/directory/root is
1620B versus116B raw. No deep compression benefit is assumed for unique data.
A1000-update fixed-size resource/chunk churn holds heap high-water5264B and
slot-generation entry count steady; this is not a bound on arbitrary payloads.

The image+glyph replacement changes two explicit resource entries and one
resource directory path, with no node chunk rewrite. First replacement stages
864 candidate bytes, plus20 diagnostic argument bytes (884 actual). A single
registered support lookup supplies old/new damage. Image pixels preserve the
existing16-sample bilinear semantics:64 texel loads per image-covered pixel,
and4100 static shader-table bytes for exact sRGB quantization in this restricted
domain. The glyph is audited as real bytes, not drawn by this renderer.

The contrasting97-node move in the serial uncompressed control visits194 extent
records across8 page visits,105 identity lookups,2231 index entries, and82 record
relocations. It rewrites4776 payload bytes and stages5256 candidate bytes (5260
with audit count). Nine page update/delete entries are examined. The starting
identity lookup and affected-extent enumeration are distinct costs. The prior
compressed structural baseline's2860 rewritten bytes remains in57ccf254; this
checkpoint does not pretend that earlier structural number includes this new
GPU publication path.

## Authority, oracles and failures

Initial pixels complete first. Each overlap group then encodes/defer-submits its
oldest candidate, submits two newer candidates, and finally submits the oldest.
Every old command still reads its old leased chunks/resources; shared current
sequence+namespace prevents it from changing newer pixels. Completion callbacks
are consumed in reverse order. The old pixel readback must equal the latest full
renderer output, while its decoded/resource readback must equal its own version.
Old staged payloads are still uploaded: stale-upload waste is not eliminated.
Stale authority is distinct from buffer lifetime; both certificates are tested.

| Actual mutant | Independent observed mismatch |
| --- | --- |
| Ignore shared current authority |1024 pixel bytes on deferred fence1 |
| Wrong directory key |866 decoded/resource bytes +960 pixel bytes |
| Wrong per-page row count |89 decoded/resource bytes +960 pixel bytes |
| Omit old damage support |192 pixel bytes |
| Omit resource leaf child leases |80 resource audit bytes;0 pixel bytes, because stale rendering is correctly suppressed |

The last result is intentional: visible-state correctness alone would miss
premature resource reuse. Full readbacks and the independent replay are kept.
Premature submitted-root release separately fails CPU graph ownership before a
complete GPU workload can be formed; it is not counted as a sixth GPU mutant.

All failed attempts remain under raw/:
-2a4018ecf2:195 point frames pass, image frame fails96 pixel bytes because direct
 texel copying did not match default Linear sampling. Fixed the renderer without
 changing images, expected pixels, thresholds or sampling options.
-c2f7eab184: rejected transform remains a committed invalid source; a later paint
 setter consequently fails again. Corrected fixture ends with the failed newer
 preparation, retaining old eligibility rather than assuming state rollback.
-00acedf751: assertion named the wrong public error type; compiler rejected it.
-e254d42901: complete corrected cohort, strict Clippy and independent replay pass.
A reviewed raw-address-hole bug was corrected before the structural GPU case:
a direct raw root must reject slots outside its own physical page.

Run `python3 verify.py` here. It verifies the manifest, source/shader/executed ELF
identities, guards, captured failed attempts, CPU replay and independent staged
memory/GPU pixel simulation. Canonical executed binaries are preserved outside
the repository with paths/hashes in artifacts.json. No files were published.

The next architectural choice is whether hot parameters belong inside compressed
records at all. A four-byte color change currently rewrites472B+448B of payload
and directory/root data at1024 nodes. Existing GPUI already produces a precise
shared paint-slot transition. A separate versioned hot-parameter representation
should compete with this measured baseline, preserving old submitted reads and
fixed damage addressing. Independently, damage-directed traversal must reduce
record visits without hiding index maintenance or overlooking old/new support.
