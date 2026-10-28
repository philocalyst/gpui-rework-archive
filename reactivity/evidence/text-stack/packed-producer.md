# Canonical packed text on Main: finite qualification

Production source628f96b746b3bfd3f2f66e3387c4babba854c2ce over Mainf0859ea215e637befd76a56471d99658ac495b45. Qualification162d4e98217cfb8e7e095fa5d78911af80c8def0 adds only public fixture139904e88fa69129655672a4d48961da8a21279af4a0b625c17def5bf49ef8f4. Shipping baseline fixturea690045372d4f6c26813fe909ee719a7fde4bbea adds the identical source over f085. Review tree `/tmp/gpui-packed-text-compose-sol` remains clean628f; qualification tree `/tmp/gpui-packed-text-compose-qual-sol` was restored clean162d after the matched baseline. Root alone decides adoption. No timing/speed claim.

## Representation and API

One canonical12-byte glyph stores checked17-bit glyph code plus15-bit original cluster, and unchanged x/baseline f32 bits. Public decoded Glyph remains16bytes. Source cap32768 and nonempty admitted glyph source ranges bound starts below32768. Primary all65536 IDs retained; fallback slots each reserve32768, immutable Arabic/Hebrew assets checked1661/149 glyphs. Custom primary fonts gain no fallback. Public glyphs() intentionally changes slice to borrowed cloneable/exact-size/double-ended value iterator; callers may explicitly collect. No expanded cached stream or native-only paragraph type. Hoisted document length deletes simple-tail encoding, tail-only long-grapheme Details and discarded-simple-map COW. Ordinary simple long-grapheme geometry materialization may becomeNone; run/line/caret/selection/render outputs stay checked.

The private owner stores NonNull<PackedGlyph>, actual capacityu32, lengthu16 and document lengthu16. Checked admission precedes Vec transfer and returns unchanged Vec on failure; exact pointer/len/cap restored once at Drop, no shrink/reallocation, independent checked clone, immutable slice only. Concrete PackedGlyph:Send/Sync bounds protect manual traits. Canvas changes forbid to deny with allowance only on private glyph_buffer module. No new font/geometry leases, shader/packet/layout/dependency/font-asset change. `production.patch` is the complete17-file adoption patch, including ordinary tests/API migration, without measurement fixture. `adoption-docs.patch` is separate/unapplied against628f, updating current unsafe policy/header/API docs; historical evidence remains unchanged.

## Actual finite results

| Cell | Result / scope |
| --- | --- |
| Canvas default all-targets |196passed,3ignored,41harnesses; original ELFs preserved |
| Canvas scalar all-targets |196passed,3ignored,41harnesses; same raster policy |
| Canvas actual repository-policy strict |default and scalar PASS on genuine1.101 nightly |
| Public default opt3 fixture |112named semantic cases and224 SDR/HDR CPU images byte-exact to both fresh f085 and original shipping reference |
| Analyzer fault controls |single changed glyph cluster and single changed image byte each reject independently |
| Actual Hummingbird native-feature all-targets |116passed,1ignored,16harnesses, explicit continuation gate |
| Ordinary native application/service |actual application::window, Registry/import/Greek search/Prepare/Play/bounded64PCM/Stop/disconnect/normal WM close PASS; all driver children reaped |
| Actual linked native DWARF |gpui TextSite72/Shaped56; Canvas TextLayout48/PackedGlyph12/GlyphBuffer16; public Glyph16 |
| Private capacity/allocation ledger |same physical sourcepath/compiler/debug flags;10named fresh-shaper rows, all raw fields retained |

No composed full GPUI workspace suite, cross-OS execution, GPU52 recapture, or opt3 public scalar fixture is claimed here. Root owns combined-stack qualification. Earlier safe/owner dossiers retain their own compiler/target/source scopes. Isolated owner final six strict-provenance Miri cells across x86_64/i686/s390x and stacked/tree borrows, actual wrong-capacity/shallow-clone UB controls and future Send/Sync negatives remain separately scoped. `isolated-owner-source-equivalence.json` proves exact owner module, codec test source, PackedGlyph record/codec and domain constants match the isolated e8c qualification. It does not relabel those runs as composed full-Canvas Miri.

## Matched cost bill — all unfavorable costs retained

Both release artifacts used the SAME physical qualification source path, target, locked dependencies, opt3/defaultSIMD, genuine1.101.0-nightly7189d39d9/LLVM23.1.4, rootv0/tokio flags, no bootstrap/generic flags or emit-stack-sizes. Canvas and public fixture fresh:false. Actual nested Cargo fingerprints preserved for BOTH; `matching-proof.json` records exact compiler/Cargo/command/path/profile/features/config/Rustflags and Canvas dependency fingerprint equality.

A recorded environment deviation remains: baseline inherited ALSA PKG_CONFIG/PATH after native qualification; candidate variables were unset. Full environment equality is FALSE. Complete package/target/profile/features closures match and contain neither pkg-config nor ALSA. Original full-environment assertion failure is retained in consolidate.py/log; v2 explicitly scopes equality to actual codegen controls. Root reviewed this deviation and requested no cosmetic equality retry. No source, raw capture or numerical gate was changed.

| Bill | f085 baseline |628f candidate | Delta |
| --- | ---: | ---: | ---: |
| Whole linked .text |2619063 |2618711 |−352 |
| .rodata |6485600 |6485592 |−8 |
| .data.rel.ro |137032 |137032 |0 |
| .eh_frame |192404 |192412 |+8 |
| Planner::shape code |13544 |13188 |−356 |
| Planner::shape explicit RSP depth |3048 |3048 |0 |
| Canvas::draw_text_working code |3615 |3670 |+55 |
| draw_text_working RSP depth |536 |520 |−16 |
| Public fixture main code |12009 |12041 |+32 |
| Public fixture main RSP depth |2504 |2488 |−16 |
| TextShaper::shape_mode code/depth |534/5368 |534/5368 |unchanged |
| New concrete owner Drop code |0 |31 |+31 |
| Exact non-test/comment core |31321 |31388 |+67 |

Core per-file deltas: text.rs+53, glyph_buffer.rs+68, layout.rs−13, planner.rs−41. Whole ELF sections, all selected symbols/calls/raw assembly and every exact-name function delta retained in matched-cost-bill.json. Frame model follows reachable explicit RSP depth only, excluding return address, callees and red-zone storage; unknown operations retained, never summed. Primary reported callers have no unresolved stack instructions. Static counts do not establish speed.

Actual public TextLayout header56→48; native TextSite72 measured (previous shipping80, intermediate safe Vec88). Native owner16/PackedGlyph12. Private fresh-shaper actual capacities13/624/32768/1024glyphs:208/9984/524288/16384→156/7488/393216/12288bytes. Ascii32k interactive requested6883980→6752908, retained975732→844660 (−131072). Ordinary long grapheme219→216allocations, requested357794→353554, retained16568→12328 (−4240); interactive long-grapheme allocations unchanged, payload−4096. Public all112allocation rows contain no positive measured delta; every field remains in bill. These are operation scopes, not whole-window/RSS totals: public first cold scope includes reusable shaper/parser context; private ledger drops a fresh shaper. Headers and geometry/font/raster/transient shaping remain separate. Never sum cases or branch deltas into app memory.

## Failures, interruptions and preservation

- Original first Hummingbird wrapper INCOMPLETE: Cargo logged build-finished success:true and all16test binaries existed, but wrapper exit/after guard and finite-results absent after session loss. Both Root and agent could not resume IDs9915/84397 and original processes absent. `interruption-audit.json` proves original before guard equals clean current162d; NO original exit/after file invented. Explicit `hummingbird-continuation-build` separately validated artifacts/source/compiler/config; actual harness/native passes belong to continuation, never retag the incomplete original.
- Original DWARF observer exited1 because it omitted GNU --wide `(data1)` size annotations; readelf exited0, binary unchanged, empty records are NOT sizing authority. Original helper/result/log and failure JSON retained. Separate v2 correctly parses form annotations/namespaces; unrelated HarfRust GlyphBuffer304 explicitly distinguished from Canvas16.
- Initial fingerprint copy assumed old `.fingerprint` directory; support failure retained in preservation JSON. Actual nightly nested build/*/*/fingerprint copied before release clean for both controls.
- Original consolidation full-environment equality assertion failed for unused ALSA variables; retained and disposition above.
- Earlier isolated broad/header/nightly-deprecation/wrong-GPU-reference/support/fault failures remain in their immutable prior archives, not relabelled.

Candidate original release ELF5611e41de1674b1674203ef534d4e5ce4d050e655ea1dc297837a49cbf6edeeb and native ELF d318d243f3650433a2dce4c76565a072bcf7af435bb146450a7699ba66294d4e preserved before source/target reuse. All default/scalar/Hummingbird original harness copies retained. Target release paths now hold baseline artifacts despite restored candidate source; those paths are NOT asserted to remain candidate. Preserved copies are actual original instances, not reproductions. External ELF manifest records current copied paths/bytes/SHA; archive excludes ELF bytes.

Earlier safe archive82036211bytes SHA9161dc48b9f0fb111a19d1f48f5cb731130ab5723aac0cfc52f87f6681b99b8c,2258payloads/359externalELFs. Earlier owner archive5822745bytes SHA4ea4204dc68800d7c046bddca883612b197fb482c743d8067977fcfc6c12d6aa,452payloads/114externalELFs. Both separately reopened/verified; owner raw source boundaries/finite omissions retained. New archive adds only this composed lane, references rather than duplicates those original dossiers.

`ROOT-HANDOFF.md` is the original pre-interruption live handoff, retained as historical evidence; its active PIDs/unstarted-cell list is superseded by this final README and actual continuation/matched results. Original generic runtime environment was not exhaustively captured; full environment identity is not claimed. Native ALSA library-path setup is retained in environment.sh; relevant actual Cargo/compiler controls are the matching-proof scope.
