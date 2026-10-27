# Compact parent columns: strong deep gains, rejected scalar fallback

Hypothesis and fixed thresholds precede timing in PROTOCOL.md. Parent links are
moved, not copied, into a dense authoritative u32 column. Entry shrinks 28→24
bytes; aggregate per-slot payload remains 28 bytes. Tree header grows 56→80
bytes and there is an additional allocation. All lifecycle/iterator methods
use the sole parent authority; no derived parent cache or duplicate topology.

Hinted-column source 17127ee39d20a273513878d29a2a55a410ab0d48; selective safe
candidate 24a3372666. Selective uses a sole-root proof or level-wise batching
at >=32 pending/>=32768 live nodes when the first four pending depths are >=16;
otherwise uses the original scalar helper. It restores forbid(unsafe_code).

Five interleaved processes per six alternatives and seven cells: 210 processes,
8,400 batches, 42,000 timed public compute calls. All final layout bits and stats
match. CPU ratios are medians of paired process p50s versus original AoS scalar:

| Cell | AoS levels | AoS hint | SoA scalar | SoA hint | SoA selective |
| --- | ---: | ---: | ---: | ---: | ---: |
| Tiny full | .965 | 1.019 | .965 | 1.087 | 1.025 |
| Contiguous filter | 1.085 | 1.590 | .849 | 1.832 | **6.880** |
| Shuffled depth128 | .366 | .583 | .760 | .369 | .243 |
| Shuffled depth32 | .596 | .574 | 1.078 | .412 | .309 |
| Shallow filter | .917 | .756 | .921 | .828 | .963 |
| Single-root full | .998 | .963 | .983 | .997 | .961 |
| Mixed depth1..128 | .133 | .203 | .540 | .133 | **2.320** |

Selective deep speedup is 4.11x, but its scalar fallback fails the <=5% gate
badly. Reject this candidate; do not hide the losses behind average throughput.
Hint variants also fail contiguous gates. These are core scheduler/layout
workloads, not complete rendered frames or evidence of ZGX superiority.

The selective fallback's linked filter loop calls public Tree::parent through
GOT 0x118730 (readelf relocation target 0x4aa50). The parent function constructs
and validates capabilities each step. The compact scalar control lets LLVM
inline differently. raw/selected/fallback-assembly.txt and relocations.txt keep
the evidence. A first text-only search found zero named calls because these
calls are indirect; that is not evidence of no calls. Root admission once under
a shared borrow and explicit parent inlining are separate next experiments,
not fixes silently applied to these timings. No hardware miss-counter claim.

All six alternatives pass 46 core tests. Selected strict Clippy passes and all
seven core unit tests pass Miri (96.91s); hinted-column lane lifecycle test also
passes Miri (131s). The attachment mutant omits the only parent-column write and
fails exact lifecycle/root assertions. Source/ELF hashes, before/after guards,
compiler/profile, emitted-prefetch counts, full cold/storage/RSS logs, all timing
batches and independent verifier are retained. One extra header/allocation is
charged; no payload memory saving is claimed.
