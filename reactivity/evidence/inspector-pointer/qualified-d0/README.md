# Built-in inspector rapid release: qualified d0 control

Shipping source **d0bd2f4ea541cf3483c71d5e8228aea5a8a1c7cc**, based on
**6021d0009db4069e5c7f96400890baa75630f047**, in isolated
`/tmp/gpui-inspector-pointer-sol`. This archive does not qualify later main
combinations. `source.patch` contains exactly five production files and one
public integration test file; no manifest, vendor, public type, or owner field
changes. `source-proof.json` names every changed blob. Evidence is separate.

The source removes the remaining built-in inspector restriction on a rapid
release after this press's own focus transition. The ordinary strict path stays
first. The fallback retains 6021's exact source/token/viewport admission, then
requires the pressed target at the release point in both acknowledged P and its
complete pending focus C. Each sheet owns its rows, transforms/basis pool,
rounded geometry, ancestor clips, dimensions, and metadata. KEEP and missing C
columns reject. The candidate accessor never substitutes P. Shared traversal
preserves foremost shapes, parent bubbling and app scope. No untrusted callback
runs until the gesture proof has been consumed and ordinary target admission
succeeds. No global current-presentation gate was relaxed.

Strict inspector picking deliberately retains its historical outward-bounds
policy. The extra two-window extent check applies only to this pending-C proof.
The actual published fractional-envelope counterexample and exhaustive old-loop
P/C oracle are in `../focused/`: a rounded-out f32 envelope can have f64 right
endpoint 720.000024408102, so x=720 can hit the old picking loop. Adding an extent
test to strict picking would change behavior. Nonhittable skip runs represent
only nonhittable rows; omitted ancestors retain each sheet's admitted parent
chain and clip resolution. Focused oracles cover those cases.

## Exact behavior and build gates

`qualification/targeted-metadata.json`: default 43 tests and targeted rustfmt
passed. `qualification/broad-metadata.json`: native 43 tests, default/native
all-target Clippy with `-D warnings`, and desktop library checks for
`aarch64-apple-darwin` and `x86_64-pc-windows-msvc` passed. The latter use
`-Zbuild-std=std,panic_abort`; these are compilation checks, not foreign runtime
claims. The source graph has 1,968 guarded core/config/vendor files. The first
GPUI compilation in each default/native test campaign is explicitly fresh:false
after cleaning only GPUI's dev package.

The 43 comprise 3 private release/carrier tests, 4 inspector/oracle tests, and
36 public cases (15 inspector, 9 pointer, 12 pointer_focus). The original 6021
public pointer suites contain 9+9 cases; no claim of 18 pointer_focus cases.
Adversaries cover caption epoch 9→10, same-target positive and actual foreground
negative, candidate own size/translation/bounds/radius/ancestor clips/basis
pool, missing C metadata or geometry, KEEP, omitted rows, old P preservation,
model/no-op/semantic/inspector edits, failed focus, viewport ABA, loss and ACK.
`../focused/` preserves the initial fixture failures rather than retagging them.

Every Cargo gate ran from the checked-out root configuration, jobs=2, with
RUSTFLAGS and CARGO_ENCODED_RUSTFLAGS unset. Cross fingerprints were selected by
the actual command start time and assert Apple v0+tokio_unstable and Windows
windows_slim_errors+crt-static, respectively (`cross-fingerprints.json`).
The public fixture's verbose build records actual native flags and fresh:false
GPUI and consumer. No external SPIR-V artifact profile was enabled.

`public-native-sealed.json` is an actual ReferenceCpu public
`Window::document(...).inspector()` window on owned Xvfb and AT-SPI Registry.
The client uses real X11 complete clicks/Space and Registry
Action/EditableText/Component. There is no private host/model seeding, retained
Win, added app instrumentation beyond a public on_presented observer, held
button, or wait between Down and Up. A selected rounded, general-shear shape
uses the ordinary inspector. The checkbox click crosses S9→focus10→callback11;
the acknowledged frames go directly 9→11. The panel height click similarly goes
19→21. Rounded-corner rejection and a transformed center pick pass at 25→27,
with stable native provider identity. Keyboard toggles pass. These real positive
cases complement the deliberately mismatched-C negative unit fixtures.

The first client failed before pointer qualification because its prefix tree
walk did not retry a provider retired during an ACK; v2 corrected that but had
an incorrect expected internal label (Div, instead of public Role::Generic).
Both source versions, failure logs, native logs and the initial complete source
guards remain here. V3 changes only those test issues and passes twice on the
same frozen app/core. The second run guards 1,975 files, including all client
versions, fixture source/lock and frozen binary, before and after. No production
change was made for either client failure. The broad runner's final exit1 is
that preserved first client failure; every preceding gate is exit0 and the
separate sealed replay is exit0. It was not silently relabeled as a clean run.

Frozen native executable: `/tmp/gpui-inspector-pointer-native-frozen`,
402,728,752 bytes; exact SHA-256 is in source-proof.json. The external fixture
and clients are archived under tools. Their manifests use explicit producer
paths: a main replay must substitute its own qualified source path, then guard
and rebuild that consumer independently. The codegen fixture disables GPUI's
default features; the native fixture enables ordinary defaults plus x11.

## Measured source, storage and code costs

The pinned six-library authored shipping counter is 30,554→30,636, **+82 code
lines**; changed tests add 511 code lines. The counter excludes tests/comments/
blanks/evidence/examples/vendors without hiding authored shipping code.
`final-core-lines.json` records the counter and source/tool hashes. Tools,
external fixture, clients and archive are additional test/evidence code.

There is no additional retained field, allocation owner, route slot, public API,
or dependency. The borrowed HitSheet/Option<HitSheet> is 56/56 bytes; direct and
optional PointerSession stay 32/32; Runtime for the test model remains
1,864 default / 1,880 native; Win stays 8. Traversal adds no allocation call.
These static carrier sizes are distinct from retained headers and stack peaks.

Matched fresh release codegen uses the same source path, actual compiler,
root configuration, features, lock and fixture. All changed packages were
cleaned explicitly with --release; GPUI and fixture fresh:false, actual
fingerprints and source guards are archived. All crates append only
-Zemit-stack-sizes to the root v0+tokio_unstable flags. Profile is opt3,
codegen-units1, no LTO, debug0, stripnone. These are this instrumented linked
fixture's costs, not a universal application binary or timing claim.

| Source/control | linked .text delta | dispatch frame | hit-only frame | click-only frame |
| --- | ---: | ---: | ---: | ---: |
| 6021 baseline | 0 | 232 | 24 | 136 |
| a2 shared carrier | +1,984 | 424 | 136 | 152 |
| a60 plain inline | +2,160 | 424 | 136 | 152 |
| 72 split helper | +3,328 | 248 | 168 | 152 |
| 0a local P hit | +1,568 | 248 | 24 | 152 |
| d0 final P wrappers | **+1,536** | **232** | **24** | **136** |

Final ordinary Runtime.hit frame120, main3368 and acknowledge136 equal baseline;
main/ack/hit-only/click-only code bytes also match. Dispatch grows 3,218→3,263
bytes (+45); Runtime.hit shrinks 1,049→874. Linked .rodata is unchanged;
.data.rel.ro adds24, .eh_frame adds200. Stack metadata itself adds37 bytes.
The new opt-in C helper is 1,160 code bytes/frame168. Inspector P picking changes
from one 482-byte/frame152 function to a 216-byte/frame120 wrapper calling the
529-byte/frame152 shared traversal. This adds a call boundary: it is not proof
of unchanged aggregate inspector stack or speed. Frames are not added to invent
a stack peak. `codegen-summary.json` and selected assembly include these costs.
The rejected controls are retained. Plain-inline's postcheck initially included
unrelated evidence paths, and its explicit compiled-graph correction is retained
in metadata; its compiler/oracle results were not rerun or retagged.

No performance timing, RSS, hardware GPU, allocator delta, or summed-stack-peak
claim is made. This slice qualifies point-specific authority and public native
behavior while charging the linked code increase.
