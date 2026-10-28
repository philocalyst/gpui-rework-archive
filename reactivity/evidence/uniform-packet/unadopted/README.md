# Uniform words and resident planes: unadopted

Source `0be1f95618b555678aee57cd433c988ff75877cd`; immediate experimental
baseline `277473219bcf4add23d36126e70be1d72ceec1f6`. The baseline already
contains the unadopted four-sample shader consolidation. `shipping.patch` and
`consumer-tests.patch` are complete GPU-only changes against shipping
`7a5e1619a27010ec63f6c27506a6d1fcd113f67c`, including that prerequisite.
No shipping renderer changes are made by this evidence archive.

Every placement occupies two 16-byte words. Four common words are split into
two affine words and two material words. A singleton still uses 96 bytes;
a previously shared common record uses 64 rather than 80 bytes. The correction
handle uses 17 otherwise unused resource bits, with variant-specific decoding.
All authored float bits, including residuals, remain exact. Globals remains
48 bytes, but its internal shader ABI now names exposure and material offset
separately; this is a deliberate internal API change, not compatibility magic.

The existing CPU word vector is its own mirror. Two stack-owned first/last
change envelopes cover the common/bank and placement bands. Equal final words
produce no draw-buffer upload. Changed words produce at most two queue writes,
merging touching envelopes; unchanged gaps inside an envelope are uploaded too.
Resource coordinates and correction handles are finalized in the existing
reverse CSR pass. No shadow packet, dirty vector, per-draw tags, retained
generation, new heap owner or unsafe code is added. Failed preparation revokes
residency; word-count changes, buffer growth and image relocation force a full
write. Validation, binning, the other uploads, bind groups and shading remain.

The actual shared-text/image translation fixture uploads at most 64 draw bytes
and zero mask/image pixels. Identical scenes upload zero draw bytes. Headers
remain Renderer 888, RendererState 840, Stats 200, Context 48, Canvas 488 and
PreparedScene 56 bytes; these are type layouts, not whole-process memory.
Syn/Tokei charges **30,738** noncomment, nontest core lines: +46 against
shipping 30,692, or +113 against the experimental kernel baseline's 30,625.
Tests, examples, comments, vendors and evidence are excluded. The older
resident-word prototype charged +202 against shipping; it is not layered here.

Default and fallback runs each pass 11 library, 4 presentation and 50 readback
cases. The offline-artifact run passes 12, 4 and 51 respectively, including
independent SPIR-V validation and exact typed field offsets. Strict all-target
Clippy passes in normal and offline modes. The last change only updates the
host-side ABI reflector; runtime production bytes are unchanged from `9a5979`.
The example harnesses selecting zero tests are excluded from these counts.

The prior 578 SDR/HDR captures total 13,912,048 bytes and match the baseline
bit for bit. Additional controls cover same-size packets with different bank
and plane offsets; growth, shrink, image removal/re-addition and failed prepare;
all legal correction handles; and 4,096 dirty masks. An actual 65,536-draw
scene requires correction index 65,536 and matches an independent CPU oracle.
Deliberately retaining residency after failure and truncating correction
handles to 16 bits each cause the intended real pixel assertion to fail.
Restoring exact source makes each control pass. These controls establish
specific fault detection, not exhaustive bug coverage.

Same-physical-path release builds use identical features, lockfile, profile,
dependencies and root flags, with only `-Zemit-stack-sizes` appended once.
Both GPU libraries and all three linked examples are rebuilt (`fresh:false`).
Against `2774732`, each linked example gains **1,232 .text bytes** and 72
data-relocation bytes. Read-only data changes by -128, -128 and 0 bytes for
groups, images and tiles. Renderer::render grows 9,296 to 9,374 code bytes and
its metadata frame grows 1,432 to 1,448 bytes. Image preparation grows
2,648 to 2,722 / frame 536 to 552; prefix writing grows 517 to 632 / frame
72 to 104. Buffer::write shrinks 303 to 76 / frame 120 to 40, with reserve
now a separate 271-byte / 104-byte-frame body. These are static frames,
not dynamic high-water measurements or additive call-chain totals.

The two-word comparison compiles to scalar 64-bit XOR/OR operations and
conditional moves, with two bounds checks. No SIMD speedup is claimed.
The complete symbol lists retain aliases and normalized-name collisions;
unpaired or duplicate bodies are not silently paired by name. Assembly and
whole linked section deltas are retained, including unfavorable results.

`captures.tar.gz` contains raw readbacks, test and failed-attempt logs,
negative controls, source/fixture hashes, codegen metadata, ELF symbol/frame
ledgers, assembly and exact runners. Linked executables are not duplicated in
this archive; their hashes and local capture paths are recorded. The first
storage-ledger invocation selected zero tests and is retained but excluded.
Earlier WGSL reserved-name, Clippy, missing-validator and stale-ABI failures
are preserved alongside their corrections. No attempt was counted as success.

GPU execution here uses Mesa llvmpipe software Vulkan. No hardware GPU,
scanout, startup/RSS, foreign-runtime or speed claim is made. This candidate
still needs matched performance and cross-platform qualification before
adoption; smaller records alone do not satisfy those gates.
