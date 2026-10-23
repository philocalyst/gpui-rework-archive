# Qualified partial caret construction, source62e4047420

This candidate is **not adopted** and has no timing result. It preserves the
no-reserve8d81 control, the RTL-countd54 control and every earlier losing capture.
The root worktree is unchanged. Current shipping source is
62e4047420; full hashes and exact shipping patches are in shipping-patches.json.

Canvas constructs carets only in shape_inner's local unpublished TextLayout.
The new hidden partial visitor shares the borrowed source walk, checks admission
while emitting, and returns an explicit restart after any prior callbacks.
Canvas truncates its local Vec to the paragraph checkpoint, rebuilds through the
old indexed authority, and regenerates ICU requests. Nonfinite geometry is
remembered until structural admission finishes, so a later indexed font rejection
keeps precedence. The existing public atomic visitor retains its full preflight
and zero callbacks on checked rejection. The old impossible-state panic uses a
static message without formatting the restart ZST.

No unsafe, duplicate output/range/visited Vec, retained layout field, source
permutation, replacement segmentation or f32 reassociation was introduced.
RTL prefixes still add every advance in original visual order. A scalar-only
RTL flag scan reserves capacity from the existing exact run count; ordinary
Vec reserve reuses capacity across later runs. This removes Canvas's complete
range/Grapheme preflight and eager maximum RTL census, while keeping the required
RTL visual-prefix and source-order walks.

## Exact final-source gates

| Gate | Result |
| --- | --- |
| Canvas parallel |193 passed,4 ignored;28 harnesses |
| Canvas scalar |183 passed,3 ignored;28 harnesses |
| Canvas all-target parallel Clippy | passed with -D warnings |
| Private source/admission/bitwise/scoped allocation overlay |19 passed;17 stock tests explicitly filtered |
| Native-feature public83 transcript |2678729 bytes, SHA1d529192f8bce827403feb865c800d20054ef98b96fa8043e29edce018f69a4f, identical to indexed/borrowed history |

The actual Canvas pair oracle retains94,176 accepted /41,760 snapped /11,096
distinct full-bit pairs. Private tests cover396 producer layouts, late overlapping
and OOB admission after earlier nonfinite geometry, late duplicate/fragmented
identity, decreasing-but-disjoint ranges, repeated/decreasing requests, gaps and
empty metrics. The malformed rollback sink is a private Parley test; actual
Canvas packed Stops are tested separately. No fabricated private Engine reversed
character arrays or impossibly allocated >u32 character/line counts are claimed.
The original unfiltered stock-font failures are preserved in the parent archive.

qualification.json records fresh:false semantic-test artifacts, frozen test
binary hashes, and421 passing source guards. Public release artifacts for Parley,
Canvas, GPUI and both clients also require fresh:false. Binary/input/source checks
surround the public captures. The same root config SHA46b48c... injects v0 mangling
and tokio_unstable. Historical flags-empty binaries remain historical controls;
they cannot be relabelled matched for this capture.

## Complete owner and publication costs

| Stage | calls | requested bytes | peak bytes | live delta bytes |
| --- | ---: | ---: | ---: | ---: |
| First C |381 |20590912 |12170700 |1091736 |
| Old P/new C |339 |20577436 |11607828 |482088 |
| Old P/old C after failed L |336 |20577296 |11605560 |483084 |
| Exact old-C ACK after failed L |0 |0 |0 |-484476 |

The frozen native owner client asserts old P remains authoritative after a newer
C and failed L, then exact old-C ACK publishes b's correct geometry. These rows
numerically equal the earlier borrowed capture, but the compiler flags differ;
this is an absolute owner result, not a matched latency/cost attribution. Live
deltas include releases of old maps. Retained layout structure and authority
remain unchanged. A complete TextLayout must return Ok before any map can enter
local preparation, then candidate C, then acknowledged P.

## Source, scratch and generated code

True Syn/Tokei counts: six first-party libraries30448 non-test code lines,
including18 build-script lines; planner534, vendor geometry547, run362, editing
mod8. The authored shipping delta is **87 code lines over borrowed81bd**, and
453 over indexed1d5 (28 first-party,425 vendor). Current experiment support is
separately charged in source-ledger.json; comments, blanks and disassembly are
not shipping code.

Measured types remain RunSlot8B, Entry16B, Option<Entry>20B, Vec24B,
Run48B, owned Cluster144B, cluster cursor272B and Restart0B. No-reserve8d81's
4500-character RTL scratch8192 slots/32768B becomes4500 slots/18000B with the exact
count strategy. Empty/tiny/LTR32KiB scratch remains0; mixed sparse capacity is
26 RunSlots plus4 f32 slots,224B payload. Dynamic reserve is not a universal win:
same-binary scoped wrapped RTL is atomic2calls/172B versus partial3calls/204B;
mixed132B versus136B. Indexed32KiB ASCII requests655360B versus partial0B. Scoped
lookup rows retain0B; these are allocator measures, not RSS or native frame time.

Actual final native-owner linked code/local stack subtraction: partial3165B/728B,
logical visitor1749B/648B, RTL visitor399B/360B, append935B/136B,
cold pair1113B/472B, constructor747B/56B, shared cursor advance1538B/136B,
Planner14741B with4096+424B subtraction. These separate frames must not be summed
into a peak. The count helper is306B: scalar byte loads/adds unrolled by four with
a scalar remainder, no SIMD/popcount. The272B cursor remains; hot visitors avoid
owned144B Cluster staging. The partial method retains one152B memcpy for offset construction. Cold
fallback still uses owned-cluster APIs; no new per-edge byte-move count is
claimed for those paths. See the captured disassembly.

The same-client/same-flags d54-to62e cleanup removes the21B Debug formatter,
shrinks the atomic method4459->4447B and minimal client.text271811->271763B (-48).
Counter306B and the const-false logical/RTL visitor sizes stay unchanged; the
const-false path does not call the added counter. These cleanup comparisons are
matched; historical flags-empty whole-binary comparisons are not.

Fourteen whole-TextLayout allocator rows in the RTL-count archive belong only
tod54, before the impossible-state panic cleanup. They are not retagged62e.
The final native owner and complete bitwise captures above belong to62e. A62e
caret_pair_measure timing executable and flags-matched indexed control are still
to be built if a campaign is approved. No text timing has run.
