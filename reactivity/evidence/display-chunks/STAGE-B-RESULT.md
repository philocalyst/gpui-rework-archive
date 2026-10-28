# B1/C1 checkpoint: direct paint binding and actual resource lifetime

Frozen source0ec97702ed147fb8ffb3e91dbfc583fe090825ec passes build,2834 Stage A
checks,16 ordinary public Source edits, real resource extraction,51 exact GPU
root-byte readbacks, an actual resource-lease mutant, and strict Clippy. Initial
88e3e997 passed execution but failed a Clippy readback iteration rule; its logs
and outputs remain. No production code or application APIs change.

The restricted paint fixture registers a named Target and its chunk at initial
admission. Each unchanged `Win::set` reads one source, with zero owner reruns,
descriptions, layout or paint passes; the adapter reads one winning property.
No further candidate snapshot/bounds/draw enumeration occurs. It emits a direct
identity/color operation, then the offline chunk model performs one identity
lookup and derives damage from the old/new record. Full CPU pixels and fresh
Views are separate oracles. This proves the restricted binding is executable;
it **does not install a generic binding journal in the production runtime**.
Two prepared candidates fail the existing public stale-token acknowledgement.

For the first point update, compressed mode reads five field words, copies162
encoded words to scratch, decodes nine rows, and rewrites648 bytes. Raw fallback
reads two field words, copies109 encoded words, and rewrites436 bytes. Both
perform two damage-record operations. These are local model counts, not
elapsed time or hardware cache measurements. The source fixture itself has nine
nodes; Stage A separately exercises1024 nodes without a global point-update walk.

The lifetime workload deliberately adds resource churn to those paint edits.
It copies real DejaVuSans A/g/Ω coverage masks (132/117/144 bytes) and8x8 RGBA
images (256 bytes) through the existing borrowed scene API. Source windows/fonts
are dropped before the GPU audit starts. Owned payload copies are retained by
publication roots. This tests actual text/image **bytes and backing ownership**,
not the production atlas/texture/font lease implementation or text rendering.

| Path | Submitted frames before wait | GPU heap high-water | First update heap writes | Submission parameters |
| --- | ---: | ---: | ---: | ---: |
| Serial compressed | 1 | 3264 B | 1044 B | 24 B |
| Overlap compressed | 3 | 6144 B | 1044 B | 24 B |
| Overlap raw fallback | 3 | 4096 B | 832 B | 24 B |

The1044-byte compressed update is648 record bytes +20 root-table bytes +256
image bytes +117 glyph bytes +3 padding bytes, in four heap writes; the24-byte
parameters are a fifth write. Root/resource tables, data and parameters are
separate work. The initial direct-source reader/state is not included in those
wire bytes. The raw fallback leaves the same identity108/page16 wire metadata
and per-version ownership bookkeeping. It reduces actual heap retention in this
trace; it does not eliminate fixed metadata or prove total application memory.
Allocator size classes create substantial internal fragmentation, recorded per
frame. Every old/current/visible root and submitted lease is counted. All
allocations are released on close; upload journals drain each publication.

For each overlapping triple, the oldest command buffer executes after newer
uploads and submissions. The CPU processes completion notifications in reverse
order. Later triples reuse freed ranges only after their semantic and submitted
owners release. The shader reads every byte through each immutable root's child
addresses, and all51 positive readbacks match independently reconstructed bytes.
Removing only the root's resource child leases corrupts267 bytes at deferred
fence0, while its page/root ownership and pointer bytes remain. The actual mutant
process exits101; three produced readbacks are preserved. It did not execute
the remaining input jobs after failure.

This is software Vulkan with staged writes. Submitted roots overlap in lifetime;
parallel GPU execution or display scanout is not asserted. The byte audit does
not combine the new chunk store with a display renderer. First-pair36f700a734
remains the compressed display-pixel baseline. The current publication table
still rebuilds linearly with page/resource count, and diagnostic audit lengths
also enumerate all children. Stable pointer lookup, payload work and rendering
cost are distinct. A bounded COW directory, integrated total-memory ledger,
generic runtime binding and combined chunk/pixel GPU consumption remain open.
Portable wgpu mapping excludes simultaneous CPU/GPU access to a mapped buffer;
this experiment is not coherent shared host memory or constant total publication.

`verify_stage_b.py` independently simulates queued/deferred memory reads and
compares every actual GPU byte, upload/padding count, public pixel trace,
artifact/shader/font identity, source guard and mutant output. The next model
will compare the flat publication baseline with a persistent bounded directory,
then carry the same chunk records into actual rendering. No latency, adoption,
hardware or ZGX performance claim follows from these results.
