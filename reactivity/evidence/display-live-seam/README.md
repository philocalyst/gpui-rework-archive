# Live native packet seam: qualified observability, no optimization adoption

**Production already performs a16-byte eligible paint-slot GPU update with
retained ordered tile traversal.** B's prototype full-scan control cannot prove
an improvement over that path, and A's104-byte staged update is not an upload
win against it. B cost remains NOT ADMITTED at2f357586bf213e2daf1043c80f5e02ad7177890d;
its qualified sparse gains, tiny/raw losses and cold/RSS costs are unchanged.

This branch extracts the existing private native packet decision into
`render_packet`, shared by GpuSurface and an offscreen integration test. Its body
is identical after replacing receiver accesses with borrowed renderer/token
arguments. Public API changes0; metadata fields0. Repo core_lines inventory
38,028→38,044 shipping lines (+16 for extraction; tests excluded). There is no
claim of faster behavior or changed storage from this refactor. Measured/qualified
source **64862c8fc8fa665fb85d398f3ea15b7d363ca621**; local/display-live-seam.

## What this enables

The executable calls ordinary Win::set and consumes the actual existing private
native decision through with_paint_scene, then the actual retained GPU renderer.
No Python owner, cached offline identity/property adapter or serialized IPC is
in this path. The eligible patch does not enumerate PreparedScene groups/draws,
revalidate the whole GPU packet or rebuild bins. Independent fresh-Window CPU
and full GPU routes remain the pixel oracles, outside the candidate operation.

All38 captured actual frames match current full CPU, fresh Win and full GPU
bytes (152 preserved RGBA files). Sizes1/9/32/256/1,024 plus64 shared-source
contributors cover ordinary single-slot edits, coalesced edits, translation and
alpha full fallbacks, failed newer NaN preparation/replay, foreign windows and
two queue submissions before the first fence/read. The latter verifies each
separate target retains its own color. Stale acknowledgements are rejected.
The deliberately unauthorized foreign positional-slot patch changes2,048 pixel
bytes; this is an actual GPU negative witness reported by the executed test,
not a claim that positional slot indices are semantic identities.

Strict Clippy all-targets, clean source guards, actual fresh executable and
embedded generated typed WGSL checks pass. Canonical test ELF42,077,808 bytes,
SHA ca95ad752f5c7a9632d90921d3528dd067f2657026727e23ca7562a2c70cd4c7.
This is software Vulkan offscreen qualification; no WSI, hardware timing or ZGX
comparison. Initial compiler failures from trying to serialize opaque tokens
are preserved, including one unchanged repeat after a failed edit script. The
correction uses diagnostic Debug strings and changes no token type or gate.

## Live baseline costs and the remaining publication problem

| Nodes | Eligible slot staged bytes | Coalesced staged bytes | Coalesced validated draws | Coalesced bin visits |
| --- | ---: | ---: | ---: | ---: |
| 1 | 16 | 368 | 1 | 12 |
| 9 | 16 | 1,280 | 9 | 100 |
| 32 | 16 | 3,856 | 32 | 284 |
| 256 | 16 | 28,944 | 256 | 2,076 |
| 1,024 | 16 | 114,960 | 1,024 | 8,220 |

Each eligible slot edit reports one source operation/read, zero owner reruns,
layout/description/paint passes, GPU validated draws and bin visits. The one-slot
case repairs561 pixels (conservative33×17 support), then copies all4,096 pixels
to the fresh target. Shared64 contributors still update one16-byte slot while
repairing1,025 pixels. These are work counts, not latency or total bandwidth.

Two Source edits before consumption leave transition.from at the intermediate
complete token while the GPU packet and damage.base still reference the preceding
image. Full preparation is therefore correct under the current single-transition
contract. At1,024 nodes this triggers114,960 staged bytes and the full validation/
binning work despite unchanged geometry and already-complete canonical paint.
This is a measured live cost to investigate before choosing packet compression.
It suggests testing bounded coalescence of exact same-slot chains while preserving
all authority/fallback rules, not assuming a generic semantic subtree journal.
No such behavior change is included here.

At1,024 nodes the live baseline retains98,352 logical packet-record bytes,
164,048 GPU buffer capacity,115,120 CPU packet/index capacity,16,384 retained-image
bytes and a1-byte empty atlas. Target textures, independent oracle contexts,
model/window/canvas state, allocator/driver memory and GPU staging internals are
separate and not included in these categories. This is not a complete application
memory total. The same renderer grows across the increasing-size sweep; the
later shared64 case retains the earlier1,024-node capacity, explicitly charged.
Source counters in each row are cumulative since the single-slot reset; later
rows must use differences, not be mislabeled per-edit counts. Full initialization
is recorded separately; no startup latency or RSS measurement is made here.

## Authority map and requirements still missing

- Source authority advances only through a successfully completed canonical
  scene; a failed newer logical edit cannot certify its pixels.
- PaintSlot is a position in that complete scene's bank. SlotTransition.from
  and latest token qualify it; SceneDamage.base qualifies damage against the
  acknowledged image. Equal-alpha paint keeps old/new geometry support equal.
  Existing PaintSupport already includes every surviving contributor.
- Native packet authority is revoked before mutation. Exact predecessor mismatch,
  foreign namespace, alpha/geometry/description/layout/structural invalidation
  retains full preparation. Acknowledgement accepts only the latest eligible
  complete token. No parallel metadata registry is added.
- Existing queue order protects previously submitted buffer/atlas/image reads.
  This does not authorize holding encoded commands across destructive later
  writes or provide coherent shared CPU/GPU memory.

| Requirement | Status after this gate |
| --- | --- |
| Live ordinary Source→token/slot/damage→actual retained GPU pixels | Qualified existing production path |
| Full-render route and raw production comparison | Preserved; no representation change |
| Subtree semantic identity→contiguous structural extent | Still missing from this seam |
| Generic structural/dependency journal and relocation closure | Still missing; existing full path retained |
| Unified compressed CPU/GPU display representation | Still missing; conditional hypothesis only |
| New compressed/indexed text/image compatibility | Still open; existing general raw renderer retained |
| Native complete-endpoint performance improvement | Not measured or claimed |

Cold compression behind virtual addresses remains a candidate, not a chosen win.
It must improve total retained storage or complete live cost after expanded CPU
mirrors, address directories, scratch and raw compatibility are charged. Existing
paint-bank indirection is the baseline, not A six-version encoding. Read
PROTOCOL.md for the detailed seam and compatibility requirements. All work local.

Verify: `PYTHONDONTWRITEBYTECODE=1 python3 reactivity/evidence/display-live-seam/verify.py`.
