# Retained color publication

Registered `direct` fields whose complete fanout consists of background and
foreground properties can update the latest complete Canvas commands without
another owner description, layout, shaping or paint walk. Ordinary field
registrations retain their conservative description behavior. Mixed color/text,
geometry or layout fanouts use the existing full presentation path.

Full presentation captures checked command-group positions only for these color
fields. The cold table belongs to that complete scene. A fast update requires
its coverage to equal the immediately preceding source epoch, and no unresolved
visual work. Source changes and masked inspector bases still commit through the
ordinary barrier. Every effective edit is staged and validated before canonical
Canvas mutation. A changed alpha, unsupported group or missing coverage uses
full presentation. An unchanged effective style advances coverage directly,
without a metadata-tree walk.

A successful color transaction creates a new opaque presentation token. If a
full candidate was already pending, its rows and frozen metadata remain intact
and damage is unioned. Otherwise a private flag in the existing admitted extent
word represents reuse of acknowledged rows. Row selection is centralized for
virtual membership and semantic publication; an empty replacement remains a
real empty sheet. Acknowledgement, surface loss and live focus use the ordinary
runtime authority. Rounded shape and descendant clipping are unchanged.

Native GPU state uses the opt-in PaintRenderer owner. Its private packet token
must equal the transition's immediately preceding complete token. Indexed edits
borrow the already-converted Canvas values; there is no second native edit
array. Binary search in the existing GPU map costs O(k log bound groups) in
validation and commit. Source and Canvas work is O(k), after one field lookup.
A full packet capture sorts its existing map, so no second index array is needed.
An invalid proof class, configuration change, error, or token gap rebuilds the
latest canonical scene. Several color transactions before native delivery may
therefore cause a full rebuild: this is a latest-transition protocol, not an
accumulated GPU delta. Every acquired target still receives a full clear/draw/
submit. Submission does not acknowledge physical presentation.

Color-only semantic transitions reuse the existing sparse observer with no
changed nodes. A prior full candidate retains its changed-index set when its
stamp advances. Independently built AccessKit Consumer trees are the test
oracle. Focus remains live over acknowledged geometry.

The ordinary Fanout, Node, Presented, Runtime and Canvas headers are unchanged.
Metadata gains one optional pointer. A previously metadata-free paint owner pays
for the entire Metadata box, PaintState box, field/range and sink arrays, not
merely that pointer. Each field entry is 16 bytes and each sink is 8 bytes. Full
capture temporarily sorts one 8-byte pair per sink. Two reusable PaintEdit
arrays preserve an older coherent native transition while the next transaction
is validated; each element is 20 bytes. Scratch capacity above four times the
current field demand is discarded before reserving exact demand. Full scene
replacement rebuilds the active table and releases obsolete arrays.

CPU output is dirtied and command damage is conservative. Grouped glyph damage
uses its clip and may cover the viewport. CPU rasterization still rebuilds its
existing disposable bins. Wgpu queue staging and OS presentation may allocate;
zero warm source/Canvas allocations do not establish zero native allocation.
No timing improvement is claimed by this implementation.

Measured x86-64 storage in this cut:

| Type or allocation | Bytes |
| --- | ---: |
| Node / Presented / Prepared | 40 / 80 / 40 |
| Fanout / Destination | 32 / 4 |
| Metadata | 256 (248 before this cut) |
| PaintState / field / sink | 112 / 16 / 8 |
| One-field, one-sink cold retained storage | 392 |
| Two exact one-edit arrays after warm-up | 40 |
| Temporary capture pair per sink | 8 |
| Renderer / PaintRenderer | 872 / 896 |
| GPU map entry | 12 |
| Indexed-or-bound GPU guard | 48 (40 in substrate) |

An accessible X11 one-node fixture with the same registered source retained
6,260 bytes with a literal binding and 7,124 bytes with a dynamic background;
that 864-byte difference includes existing source fanout and declaration costs,
not only the 392-byte new cold storage. Mount requested 41 versus 51 allocations.
After both staging arrays were warmed, the measured third color edit requested
zero allocations and zero bytes. This is one precisely scoped owner-thread
fixture, not an assertion about every style diversity, native queue, or OS path.
The accessible Runtime<()> header is 2,400 bytes and remains structurally
unchanged by this cut. NativeHost remains 680 bytes; GpuSurface is 1,080 bytes
with the additional 24-byte map header, allocated only when a GPU cohort exists.

The native fixture compares both SDR and RGBA16F texture readbacks from the
actual private bridge to a separate full GPU renderer. Those bytes must match
exactly. Its CPU oracle separately permits the existing one-byte SDR conversion
difference and one positive half-code HDR conversion difference for its selected
nonnegative colors. An initially overstrong exact CPU-byte assertion failed at
rounded partial coverage and is retained in the evidence; no production numeric
behavior was changed to accommodate it. This is not a universal cross-device
CPU/GPU byte-parity claim.
