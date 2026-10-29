# Actual packet reference relocation

**No adoption, timing or GPU representation change.** The actual Source→full preparation→GPU completion→ack trace now separates semantic node identity, command ordinal, packet word address and immutable resource identity. A reversible diagnostic encoding removes some address churn, but dependency changes and tile maintenance remain. The inherited mixed exact CPU/GPU gate remains **FAILED** (48 bytes in matched candidate/control); it was not rerun here.

Parent `0cc1fb926b2fde1ddb02436ab388910de63d556d`; protocol `e727076f71f1579aaff817d68f54450c51585785`. Final executed source is in `source.txt`. Unique local branch `local/packet-relocation`, worktree `/home/user/gpui-packet-relocation-lab`. No pushes or shipping adoption.

## What is captured

A dev-only `gpui_gpu/packet-trace` feature records `[first ordinal, count, physical start, compact]` at the renderer's actual group emission event. Read-only snapshots copy its final CPU record prefix, tile ranges/references, corrections and image-address index after successful full submission. No alternate packet generator or shader change. GPUI's ordinary optional GPU dependency does not enable this feature; its dev-dependency does. The test reuses the prior structural/mixed models through ordinary `Win::set`, the private production render decision, completion and acknowledgement. It adds no semantic registry.

Fifteen frames: keyed4 and keyed256 initial/insert/remove/reorder; unkeyed4 likewise; mixed initial/insert/remove. Full preparation is unchanged. This is an address diagnostic, not another pixel qualification campaign. Captured words are **CPU staging**, not GPU buffer readbacks; immutable image/gradient suffix uploads and mask textures are separate domains. Array snapshots are not an optimized producer journal.

The analysis validates group partitioning, all observed clip/common/correction/image references, CSR/uniform-tile draw addresses, exact interpretation-lane patch reconstruction, and the relative-domain model's full-prefix round trip. Paint banks, gradients, nonzero parent-clip references, nonzero correction-index relocation and image suffix overflow/replacement are not exercised. Their code dependencies are audited in `LIFETIME.md`; their absence is not a passed gate.

## Concrete old/new words

The mixed root survives with identity1, own command ordinal0 and inline physical address `0x80000000`. Inserting the black child adds six words before the clip suffix. The root's 96-byte packet has exactly **one changed 32-bit lane**; the other23 are identical:

| Physical 16-byte word | Old | New | Classification |
| --- | --- | --- | --- |
| 3 (clip reference) | `[0x7fc00003, 48, 0, 0]` | `[0x7fc00003, 54, 0, 0]` | Relocated reference: identical complete clip dependency moved from word48 to54 |

The five-word clip payload itself is identical. The root did not change geometry, color or resource meaning. Exact old/new six-word root records and every changed lane are in `raw/analysis.json`.

Other words are not mere relocation. In keyed256 insertion, surviving follower identity10 moves command4→5 and inline word24→30. Four lanes change: sampled local Y20→28, inverse translation Y−20→−28, and two numeric error terms. These are **changed layout/interpretation dependencies**, outside the edited group's structural extent. Surviving item identities7 and9 each change five lanes. Across all70 matched old draws,14 lanes change dependency meaning; one new draw contributes96 bytes. All267 old semantic nodes survive,262 relocate, and all269 new nodes still traverse reconciliation, identity indexing, layout insertion and paint. The prior326-byte subtree-only damage corruption remains binding evidence; this trace does not replace it.

Unkeyed reorder keeps command addresses/ranges and cold topology while changing four color lanes across three surviving draws. That is **changed content**, consistent with the earlier704-byte pixel witness. Storage or range equality cannot authorize output reuse.

Mixed children remint. The semantic comparison therefore matches only the root. A separate, explicitly diagnostic fixture-role pairing (not semantic reuse authority) matches nine pre-existing draw roles. In insertion/removal,29 unique interpreted lanes differ: seven pure clip-reference relocations and22 dependency changes. Four of the latter are common-record pointers whose referenced transforms also change; their address and interpretation both change. Other shared common state is counted once, not per glyph placement. Raw positional prefix differences are146 lanes, a different quantity dominated by record relocation and new words.

## Shared resources and tile references

Four glyph draws use two compact groups; each compact group stores5 common words plus2 words per glyph. In the mixed insertion the first common starts12→18 and the second21→27. The same glyph key keeps atlas coordinates, and both image draws keep the same ImageKey and word64 suffix address (`0x80000040`). The image reservation is1,024B, its immutable pixels16B, and allocated draw/image buffer1,280B. It uploads16 pixel bytes initially and zero on insertion/removal. That existing capacity policy already prevents image-reference relocation in this fixture; it is not a newly invented stable address design. The mask uploads70B initially and zero on insertion/removal, while its atlas retains65,536B. Initial instance1,208B + image16B + mask70B =1,294B staged payload; insertion1,320B and removal1,208B. These exclude driver allocation/transfer overhead. The atlas illustrates why small packet sizes alone do not establish low complete retained storage.

The keyed256 insertion has420→426 record words and a7,992B **instance upload** (records6,816B + tile ranges128B + indices968B + corrections32B + globals48B). No image or mask payload participates there. This remains complete preparation, not a14-lane GPU patch.

Nine of16 tile lists keep the same ordered semantic contributors. Eight of those nine still contain shifted physical addresses: **143 changed references** (572 payload bytes). Other tiles change contributors/order and need dependency-aware updates. Raw positional CSR comparisons also contain shifted list offsets; those counts must not be called143 additional draws or universal dependency work. `tile_referents` records the exact distinction. Stable draw references could avoid some address churn, but would need a directory/allocator/version scheme and would not remove changed lists or legitimate overlap.

## Executable alternatives and their limits

`raw/domain_model.py` implements a reversible encoding over the actual captures, compared with raw words. It stores clip-node indices relative to a per-version clip-section base, parent references as relative index+1 (zero still means none), and compact common pointers as backward distances from the placement. The diagnostic encoder/decoder traverses all captured groups and reconstructs all15 full prefixes byte-exactly. It does not run a changed shader or publish less data.

| Alternative | Evidence / remaining cost |
| --- | --- |
| Raw physical references, patch relocations | Existing renderer and complete upload control. Root example requires one4B reference change; seven matched mixed clip sites change. Finding/patching sites still needs events or a maintained relocation index; stale versions must retain their interpretation. |
| Relative address domains | Implemented Python model: mixed29→18 changed matched lanes; seven clip and four common address differences disappear. Raw prefix size is unchanged and the model adds a4B logical clip-base descriptor. Keyed insertion14→14 and unkeyed reorder4→4: no benefit for genuine content/layout changes. CSR remains raw. |
| Stable virtual handles/extents | Not implemented or selected. Could stabilize the143 references in unchanged tile contributor lists, but adds handle/directory and lifetime costs; common/clip/material closure, reminting and changed painter-order lists remain. Needs a complete comparison against raw and simpler relative domains. |

The relative model copies/decodes the whole prefix and uses the captured32B/group directory as diagnostic scratch. Its4B descriptor is a logical field count, **not measured publication bytes**, a coherent-memory protocol, or a bound on driver alignment/staging. It saves no measured live CPU work, GPU upload or memory; record bytes plus descriptor are larger than raw. No compression claim follows.

A deliberate old-descriptor/new-prefix mix reconstructs **eight wrong lanes** after mixed insertion (seven after removal). The correct descriptor restores exact bytes. Thus even this simpler encoding needs an exact version root; a latest clip-base value is not a safe shared interpretation for retained predecessors. This is a byte countermodel, not a pixel/lifetime gate. Full queue/buffer/resource ownership analysis and required operations for an in-flight predecessor are in `LIFETIME.md`.

## Costs and gates

The group observer adds a24B Vec header; keyed256 insertion retains4,096B group capacity and appends71×32=2,272B of descriptors during full preparation. The copied packet snapshot requests10,216B in five allocations plus its160B value header. These are extra diagnostic costs, not replacements for existing arrays. Mixed insertion retains256B observer capacity; snapshot arrays1,528B, total snapshot allocation1,584B in eight allocations, net retained1,576B including resource-address strings. The8B allocation/retention difference is temporary allocation. JSON/analysis structures and the older semantic/cold diagnostic mirrors are additional and are not included in these snapshot-only counts. No whole-application memory or latency claim.

The source inventory conservatively counts feature-gated observers as library code:38,145 lines versus38,079 parent, +66. The normal dependency does not enable the feature. Original preparation, expanded staging arrays, existing raw/absolute/relative cold controls and semantic diagnostic mapping remain. No claim of lower total storage.

The first executed source `f363841c1deeed63cf6f12ac70ac3f172b8debbe` passed build/15-frame trace, then failed strict Clippy on an unused test import. Corrected `963751a5faf0e98b3dd5f8acf2168a99358190a6` passed build/trace/Clippy and produced identical traces. Final source adds only existing mask/atlas counters to the capture so instance bytes are not mistaken for all resource uploads. The final clean build/trace/Clippy, source guards, canonical ELF and embedded shader checks are independently recorded. No pixel oracle was relaxed or rerun. All failed attempts remain in `raw/`.

Completed own build targets were reclaimed only after canonical ELF and source-guard verification; receipts are preserved. The final counter-only capture reuses its own target after explicit `cargo clean --release -p gpui`. Its local incremental free-space preflight is2GiB (actual free space recorded), not the8GiB fresh-build preference. Mothership was not used and its8GiB rule was not altered. There are no timing samples.

## Requirement matrix

| Requirement | State |
| --- | --- |
| Contiguous CPU nodes / existing semantic identity | Existing; reconstruction/remint/rank relocation limits unchanged |
| Semantic identity→command intervals | Implemented live diagnostic under exact scene/source stamps; generic retained production journal missing |
| Command→actual packet group/word addresses | Implemented dev observer and15-frame staging diagnostic |
| Packet/reference/resource closure | Partial fixture interpretation; unsupported formats and generic dependency authority still missing |
| Relative address encoding | Executable offline byte model only; no GPU consumer or lower-cost producer |
| Old/new damage including escaping siblings | Existing full path/oracle retained; subtree-only326-byte counterexample remains |
| Mixed text/image exact CPU/GPU parity | FAILED inherited48-byte discrepancy in matched mapping/control; not rerun |
| Submitted version/fenced resource lifetime | Existing serial path source-audited; no new multi-version representation implemented |
| Lossless compressed integrated display tree | Missing; prior cold extent sharing is separate and unadopted |
| Shared-memory publication / end-to-end ZGX win | Missing; staged queue writes and no new timing evidence |

The next representation decision should compare relocation events, relative domains and stable draw addressing using these same actual producer events. It must carry exact version/namespace/interpretation authority and count changed tile lists, common/clip/material references, directories, mirrors, current/in-flight versions and reconstruction. It must retain full preparation as the oracle and charge its current global work until that work is actually removed. No further paint fast-path or codec tuning campaign is implied.
