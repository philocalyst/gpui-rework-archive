# Keep coverage work independent of the uniform packet experiment

This is a read-only feasibility assessment. No legacy-ABI port or additional
record optimization was implemented, and no new timing campaign was run.

The exact 7a5e→277 GPU source diff already contains both requested deletions:
the shared four-sample row compositor/unified bank decoder, and fusion of the
separate resource-placement patch walk into reverse CSR fill. Commit 277 retains
the legacy Globals.mapping vec4, five-word compact common records, six-word
singleton records, ordinary correction handles, and streaming record writes.
The exact core counter reports 30,625 for 277, 30,796 for a81, 30,947 for
0359 and 30,948 for sealed 6158. Those are existing source totals, not a
prediction for a port. Sealed coverage costs +4,176 linked .text bytes and
+32 bin_draw frame bytes against a81; this cost must accompany the reusable
proof rather than disappear when evaluating a legacy port.

0359's whole-visited-rectangle certificate depends only on PreparedDraw, error,
tile_bounds and viewport extent. It has no dependency on uniform planes,
material_offset, the 17-bit correction codec, bank layout, Changes envelopes,
or residency. Its lazy per-draw setup can therefore be moved onto legacy binning
without retaining those experimental packet mechanisms. The interval proof
targets a81's geometric full_tile. A legacy port must move the opacity/sign
admission outside the geometric predicate, as a81 did, before using that same
geometry for translucent constant coverage; it must not assert that a geometric
certificate makes shipping's opacity-gated full_tile true for translucent paint.

CONSTANT_TILE / OPAQUE_PREFIX / TILE_END are CSR endpoint tags independent of
whether referenced draw addresses have INLINE_RECORD set. Keep the existing
MAX_REFERENCES bound below tag bits, and preserve the uniform direct-fill
range[0] address including its legacy inline tag. Opaque cutoffs still require
the exact alpha-one/sign-safe proof. Constant translucent coverage can never
restore a previously lost tag or retire a backdrop. Retain clear-based first
opaque source-over, original painter order and integer negative-zero output
normalization. These requirements and admission-failure revocation are not
optional simplifications when discarding the uniform representation.

The required color-only shader loader can follow the legacy schema directly:
inline color is WORDS[base+4], with bank/correction flag WORDS[base+5].w;
compact metadata WORDS[base+1].w names the common record, whose color is word
+3 and bank/correction flag is word +4.x. Reuse 277's bank-color resolution.
Do not call full load_draw merely to extract color: that source expression
would request unnecessary geometry. Compact paint-only loading needs an extra
common flag access compared with a81's plane layout; actual physical GPU
transactions and codegen must be measured rather than assumed equivalent.
Keep legacy Globals.mapping and the matching artifact/ABI reflector; the
uniform-specific exposure/material_offset ABI need not accompany coverage.

The material/resource bytes being retained are exact. Legacy common storage
costs 80 rather than 64 bytes for each shared group. The frozen 32K grouped
fixture therefore has 1,104,096 rather than 1,088,096 draw bytes (+16,000).
Singleton payload remains 3,072,096 in both schemas. In those fixed cases both
versions use the same rounded GPU draw-buffer capacity; this is not guaranteed
when a smaller packet crosses an allocation/image-prefix power-of-two boundary.
Legacy uploads full warm records, whereas uniform residency can skip unchanged
draw words. Preserve and report this lost upload benefit explicitly.

The failed fixed campaign nevertheless measured legacy grouped-32K host/total
better than a81 despite those extra uploads: a81 paired host medians were
1.119819 static / 1.072507 motion, and total 1.094277 / 1.044610. This is a
specific llvmpipe result, not proof that streaming always wins or that uploads
are free. It establishes why the coverage kernel should not be held hostage
to all uniform-packet mechanisms in the next candidate.

The uniform warm writer makes seven 16-byte word comparisons for each singleton
placement's six stored words: four common words, one local word, the forward
common-address metadata word, and the reverse finalized resource metadata word.
For the fixed workloads this is 224,007 word comparisons for 32K singletons and
100,007 for 1,000 32-glyph groups, including the opaque final rectangle. These
are source-derived word comparisons, not measured instruction/byte-traffic or
time counts. The borrowed comparisons already generate SIMD16B. A separate
uniform-only change could derive fresh common addresses in reverse and defer
the entire metadata word until resource finalization, eliminating the forward
metadata read/compare. That adds reverse group/schema bookkeeping, so it also
needs its own evidence; it was deliberately not layered into 0359.

Native already has admitted-token redraw/slot commits. A new public Canvas
revision witness would change a different reuse boundary and would not repair
the changed-scene CPU path or native's existing token shortcut. No such API,
owner allocation, revision field, or harness substitution was added here.

Recommended separation for Root review: treat legacy 277's already-existing
resource/compositor deletions as one known base; port coverage tags plus the
rounded enclosure onto that legacy schema as an independent experiment. Keep
the plane/residency experiment archived and unadopted. Count and inspect the
actual resulting code, ABI, resource bytes, uploads, caller/helpers/frames and
failures before preregistering a new matched shipping comparison. No future
line count, static cost or elapsed-speed forecast follows from this assessment.
