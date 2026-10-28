# One-candidate editing refinement

Source: `9846d3057476a454685a36f3a0c116de221b9f77`, after the immutable
first source `87ef97396311cc7c74ccfe3c5c67b5d3d1afec0c`. The first source and
its evidence remain unchanged. This refinement supersedes its compound-click
behavior, and removes diagnostic counters from production decision-making.

The private stack-only `EditingIntent::{None, Replace, Focus}` carries the
closed effect through ordinary source admission. For a compound click, Focus
sets dirty **before** patching: a bank-only color candidate cannot include caret
blur, so its `!dirty` fast admission must be disabled before it can publish.
Visual, Complete, Metadata and color-bank actions then prepare one full scene
containing their accepted output and changed caret visibility. Without a caret
effect, their existing zero-paint/zero-frame paths remain available.

Before source admission, a rejected action restores previous focus only while
the owner remains logically valid and live and its source epoch is unchanged.
After admission, failed preparation retains new logical focus; reconciliation
failure or panic uses existing revocation/poison cleanup. No pending field,
callback, second retained sheet, or node/header expansion was added.

`select_pointer` and Tab reveal compare actual candidate tokens rather than
`Counters.paint_passes`. This is deliberately restricted: selection changes
and scroll revelation prepare a full scene or nothing, so a new token from
those calls includes the current focus. Closed Inspector Window actions obey
the same full-scene-or-none rule. Arbitrary token changes are **not** treated
as proof: `paint.rs::publish_paint` also advances the token for a color-bank
candidate. The gate and the restricted assumptions are documented beside the
production branches.

`tests/text_selection_compound.rs` uses only the ordinary public API. The exact
same test file compiled against untouched first-source shipping code in
`/root/gpui-text-selection-editor-control` fails the one-candidate assertion:

```text
assertion `left == right` failed: visual: includes bank-only candidates
  left: 2
 right: 1
```

The refined source passes all six compound tests. They cover both click APIs,
Visual/Complete/Metadata/paint-bank outcomes, exact unchanged token when no
frame is needed, retained bank-only speed paths, projection/hit rejection,
committed failed P, logical failure, panic, idle Tab reveal and a real Tab
scroll. Automatic-presentation counts include bank-only candidates, so the
test detects two candidates even when only one performs a paint walk.

The [source ledger](text-selection-refinement-lines.json) pins both committed
source identities and the identical counterexample's SHA-256. Cumulative
shipping non-test code is **+664 lines** over the pre-editor baseline: +616
in the first source and +48 in this refinement. This includes native adapters
and all changed shipping files; no new executable/script source is omitted.
The original 40 B cold state, +8 B Metadata slot, 304 B plain-owner carrier
activation and unchanged Runtime/Node/TextSite header ledger remain applicable.

After the refinement, the real X11 Todo proof was rerun on this exact frozen
source across all five renderer-policy cases, including selected server pixels,
Shift arrows, pointer drag redraw, resize, inspector, GPU submission and
suspend/resume. It passed. Strict all-target GPUI+Canvas Clippy with
`x11-minimal` and Canvas `parallel` passed. Focus/pointer/inspector/editor
integration and the two cold-state/epoch unit gates were rerun on the frozen
source as well. The first source's full 409-test default run is historical
control evidence, not relabeled as a full run of this refinement.
