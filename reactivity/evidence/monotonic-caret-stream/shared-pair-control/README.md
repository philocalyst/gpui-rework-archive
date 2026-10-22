# Shared pair-from-entries control

Shipping source is **cc545b4988129ba02ef268801467b5f7d425e8ed**, based on
the frozen cached-boundary control 8d8afa5dc2. The only additional production
edit is geometry.rs: +19/-41 physical lines, 474 -> 455 code lines. Indexed
byte lookup and the monotonic walk now supply the same two Entry references
to one cold endpoint/affinity lowering function. Source-neighbour reconstruction
and `Cursor::geometry_with` remain canonical; the shared-edge branch is unchanged.
The unrelated borrowed-projection experiment is absent from this source.

No retained layout/owner/node field or allocation is added. The first-party
counter remains 30,432 code lines, including 18 build-script lines; authored
vendor geometry is an additional 455. Against 1d5 (30,420 and 142), the shipping
delta is **325 code lines**, not merely the first-party +12. Common span helpers
remain 299 distinct non-test code lines, and this archive contains copied public
clients of 71+94 = **165 additional physical code lines**. Prior slot archives
also contain their separately charged 198 copied census-client lines and the
initial paired driver has 72 lines. These support costs are outside shipping
library counts. Compressed patches reproduce already charged code.

Exact qualification:

* Canvas parallel: 193 passed / 4 ignored in 28 harnesses.
* Canvas no-default-features scalar: 183 passed / 3 ignored in 28 harnesses.
* Independent ordinary-cursor and packed-stop bit oracle: 94,176 accepted,
  41,760 snapped and 11,096 distinct pairs, including repeated/decreasing
  requests, bidi, hard breaks, zero line heights, negative advances and widths.
* Private std+complex-scripts admission: 8 passed. This includes all 396 real
  producer layouts plus deliberately malformed/disjoint/gapped/empty controls.
* Already-shaped allocation probe: passed, full indexed/streamed bbox checksums
  equal; common inline scratch is zero, RTL172B and mixed132B, retained zero.
* Canvas all-target parallel Clippy with `-D warnings`: passed.
* Public 83-case recording-owner transcript: 2,678,729 bytes, SHA-256
  `1d529192f8bce827403feb865c800d20054ef98b96fa8043e29edce018f69a4f`,
  identical to frozen 1d5 and 16-byte controls.

The ordinary owner still exposes old P through new C and failed new L, then
acknowledges the old C correctly. Its first C uses 381 allocations, 20,590,912
requested bytes, 12,170,700 peak and 1,091,736 retained, versus baseline383 /
21,246,272 / 12,817,120 / 1,091,736. New-C and failed-L requested bytes each
fall by655,360. Old-C ACK allocates zero; all stage checksums and retention match.
These are scoped allocator measurements, not RSS or foreign native runtime.
The 14 fresh/warm shaper allocation rows match frozen inline byte-for-byte.

The default release example's .text is0x1212a8, **2144B smaller** than 8d8's
0x121b08, but still12,112B above baseline. Bulk body8259B/local reservation2056B
and shared pair1113B/local472B remain unchanged. Removing the duplicate indexed
pair and geometry instantiation accounts for the linked reduction. The retained
shared `geometry_with` is936B. Planner14745B/local4584B remains charged. Local
reservations are individual function frames, not aggregate peak stack. Exact
disassembly/section/symbol captures and executable hashes accompany this archive.

No performance timing was run for this source. The 8d8 marker census remains
qualified only to that prior pin; this cleanup does not retag it as a fresh
cc545 census. The initial16B measured latency loss remains separately preserved.
Public fixtures use ordinary Win APIs with x11 enabled but no native server;
they are behavior/geometry gates, not an AT-SPI protocol or foreign-platform run.

Reproduce by applying source.patch.gz and support.patch.gz at immutable baseline
1d5bc3061cce3beb3c4857102ed651da501b5cfd. Both are complete binary Git diffs
restricted to crates/vendor and span support respectively. The local reconstructed
commit can replace the unpublished source hash when calling prepare.py. Public
sources, manifests and locks are included under public/; relocate their explicit
dependency paths to the reconstructed tree. The public lock is byte-identical to
the previous qualified fixture lock and all root path patches are present.

Recorded builds use Rust1.97.1/LLVM22.1.6, two Cargo jobs, offline locked
dependencies and empty encoded Rust flags. Scoped release example is opt3/debug0;
public release clients are opt3/debug1. Distinct target directories and copied
binary names prevent aliasing. All421 frozen source guards and public inputs /
binaries pass after the campaign. The initial standalone locked command stopped
before compilation; offline resolution produced exactly the existing cost.lock,
then locked replay passed. Its raw rejection and empty cost-lock diff are kept.

Worktree: /root/gpui-monotonic-caret-shared-pair. Scoped example:
/tmp/gpui-monotonic-control-bin/stream-shared, SHA-256
`e92b2f25af4ae3780da2bcb6ed287cab48f4c6072614d03d8c3b79e1c48885d2`.
Public binaries and full source/artifact guards are recorded in the run JSON.
