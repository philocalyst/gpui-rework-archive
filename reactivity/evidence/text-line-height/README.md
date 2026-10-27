# Explicit text line height: local behavior qualification

The native ZGX port previously used GPUI font metrics while ZGX uses
ceil(font_size*1.4), producing different line spacing. This isolated slice adds
optional absolute line height and uses20px at14px font size,28px for the title.
Existing GPUI/Canvas calls retain their defaults. No performance verdict or
competitor victory; no merge into the original archive and nothing pushed.

Base native-port dossier3d60e5b4a8. Production first frozen atbbe1d90ede;
full native build/tests/scripts at9ffba981b8f6c5cbacbc669d36b423b7090cebd3.
Final source9d172e052ad8aac6d93a4d004b7788cc48355efc adds only one public
failed-newer/old-ACK test. Final focused tests pass in both default and X11
profiles. Source-equivalence receipts record the diagnostic example alias and
later test-only differences; every build gate has before/after input guards.

The additive El.line_height literal/Signal method uses the existing closed
property schema (id15, optional Dimension, Layout impact). None is the existing
normal metric behavior; an explicit None override remains distinct from Inherit.
Canvas adds measure/shape/interactive-shape methods with optional line height;
old signatures forward None. Existing Parley Absolute line height drives all
measurement, painting, cached shapes, sparse updates, selection and IME geometry.
The cache key and all style representations/equality/invalidation paths include
pitch. Invalid values and overflowing output reject through existing errors.
No new dependency, vendor edit, shader-source edit, production unsafe or root
shared-mutation mechanism.

Qualification:967 default and1040 X11 GPUI+Canvas tests, strict all-target
Clippy,8 native-port tests; final7 focused tests in each feature profile include
the additional failed-newer pitch case. They preserve exact fresh-window pixels,
old acknowledged geometry and older eligible candidates; cover normal reset,
source/override changes, wrapping/paragraph separators, small/fractional pitch,
invalid/overflow inputs, scratch reuse, sparse publication and IME epoch rules.
A fresh mutant4662b53252 omitting pitch from exact style equality fails the
ordinary public pixel oracle. Six actual native application scripts pass, plus
actual D-Bus/AT-SPI CJK IME preview/old-candidate/commit scripts at both default
and explicit40px pitch. Wire integer rectangles retain the existing conversion
contract; no new tolerance was introduced. This is behavior qualification for a
comparator feature, not complete allocation/performance adoption evidence.

Failed attempts remain: a test import, a repeated unchanged attempt after an
edit-script assertion, an IME test that incorrectly assumed old sessions survive
source-epoch changes, exact header/schema assertions requiring deliberate new
values, and an existing capacity-example Clippy type alias issue. The production
implementation did not change after its initial freeze; subsequent changes are
tests/example diagnostics. A rejected inventory used the tool repository's HEAD;
corrected inventories use explicit commits. Native snapshot startup initially
raced X mapping; the bounded retry and source guards are retained. Owned snapshot
D-Bus autolaunch services were identified by private display/runtime and stopped.

Storage:Style88→96B,El176→184B,Draft152→160B,TextSite80→88B,Shaped64→72B,
compact LayoutStyle56→64B and Record72→80B. Node24B,Presented64B,Styles40B,
Fanout32B and Destination4B remain. Shipping inventory36578→36657(+79 lines).
The native example ELF26284496→26281592B is not a general code-size win:
shape cache body573→643B; sparse text2110→2141B with local prologue reservation
344→360B; planner measure6356→6443B and shape8041→8104B, local reservations
2472/2520B unchanged. Whole ELF and section/function receipts are retained.
These prologues do not measure total call-stack usage or runtime performance.

Unchanged ZGX a3678578980ef239058c557338ef9c544d356b0c and GPUI settled native
960x720 screenshots use the same DejaVu file, initial190 ticks, and idle mode.
Both show seven lines with20px pitch. Diagnostic ink row spans still differ by
about a pixel and weight: this is not exact cross-framework output equivalence.
Pinned source audit shows encoded-color retained blending in ZGX versus GPUI's
linear-light composition; rasterizer/hinting differences are not ruled out.
Do not change GPUI's established exact color contract to force a screenshot match.
The reference capture's build profile is unmatched: no timing ranking follows.

Next native parity requirements: controlled wheel/scroll, keyed two-row overscan,
deferred controls, cross-framework text-quality qualification and equal build
profiles. Physical GPU/two-hardware gates remain. Software Vulkan/private X11
cannot establish hardware GPU or scanout performance. Retained GPU experimental
ancestors remain independently unadopted. `raw/next-native-list-notes.txt` records
keyed-list and later certified integer-scroll reuse hypotheses, not implementation.

Run `python3 verify.py` to verify files, all gate outcomes/failures, source guards,
actual native scripts, executable/symbol identities and diagnostic image spans.
