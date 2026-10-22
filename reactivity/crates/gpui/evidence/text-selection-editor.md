# Input selection source freeze

Source: `87ef97396311cc7c74ccfe3c5c67b5d3d1afec0c`. The parent is root's
inspector `6c01a0ae66` with the three already-qualified selection-query commits
replayed. Cherry-pick the editor source commit alone when those queries are
already integrated. This evidence does not qualify later dependency migrations.

The ordinary exclusive APIs are `Win::selection`, `select`, `replace`,
`type_text`, `backspace`, `key`, and `pointer_event`. Native arrows/modifiers,
native drag updates, and accessibility `SetValue` call these production paths.
No test-only public mutation or geometry API was added. See
[the behavior contract](../TEXT_SELECTION.md) for authority, affinity policy,
grapheme joining, acknowledgement barriers, and unsupported browser features.

The stack-only closed `SelectionIntent` is consumed after the source's logical
patch/description and before Complete/Metadata early returns. It is not stored
in an owner, node, callback, or closure. Failed publication retains logical
source/selection; source reconciliation failure revokes the retained selection.
An immutable text lease plus identity and field qualifies stored offsets.
Explicit caller ranges deliberately address current source rather than a
previous revision. The same-source, equal-output replacement case is tested.

The cold state is 40 B on the tested 64-bit target. `Option<Box<Editing>>`
adds 8 B to existing `Metadata` (256 -> 264 B). A plain owner with no prior
metadata requests a 264 B carrier plus a 40 B editing box on first activation,
304 B before Canvas interaction data and allocator overhead. An owner already
using the carrier needs the one 40 B box; switching active inputs reuses it.
`Node` remains 40 B, `TextSite` remains 80 B, and Runtime's fields are unchanged.
The original one-word text lease is shared rather than copying retained text.

Canvas's existing byte-sorted caret stops remain the only interaction map.
Only the active input opts in; switching inputs releases the old map while
preserving glyph storage and placement. Activation can reshape and temporarily
hold the old cache during successful replacement. Logical boundary validation
and repair scan ICU; source replacement copies a String. No new timing or SIMD
speed claim is made. After the cold activation, the existing allocation-counter
gate proves 1,000 repeated identical clicks allocate nothing and perform zero
description/layout/paint work.

The [source ledger](text-selection-editor-lines.json) charges all changed
non-test executable source, including native adapters: **+616 code lines**.
Syn removes test-only AST spans; Tokei 15.0.0 excludes comments, blanks and
documentation snippets. This slice adds no executable example, script or
generated production source. Cargo manifest and lock each add one dependency
line; ICU 2.3's compiled grapheme data was already required by Canvas. Native
script extensions and all inline unit tests are excluded as tests rather than
silently counted as production savings.

Validation on the frozen source uses an isolated target and two build jobs:

```sh
source /tmp/gpui-native-env.sh
export CARGO_TARGET_DIR=/root/gpui-text-selection-editor-target
cargo test -p gpui --tests -j 2
cargo test -p gpui_canvas --test selection --test unicode -j 2
cargo clippy -p gpui -p gpui_canvas --all-targets \
  --features gpui/x11-minimal,gpui_canvas/parallel -j 2 -- -D warnings
DISPLAY=:112 cargo test -p gpui --features x11-minimal,gpui_canvas/parallel \
  --lib native_todo_port -- --ignored --nocapture --test-threads=1
```

The real X11 test passed all five existing native renderer-policy cases with
the production keyboard modifier adapter, Shift+Left, selected replacement,
pointer press/drag, and an actual post-move presentation. Software surface
server pixels equal the CPU command oracle while the range is selected.
Existing GPU submission, resize, inspector, suspend/resume and source-repair
checks remain active. The final native run completed in 3.44 s; this is a
correctness-run duration, not a matched performance result. Xvfb 21.1.24 and
Mesa llvmpipe supplied the real X11/Vulkan endpoints.

Frozen full default GPUI: **409 passed across 43 executables, 8 pre-existing
ignored**, zero failures. Canvas selection/Unicode: 23 passed. Dedicated logical/geometry/paint editor
integration: 11 passed; cold-state/cache/epoch unit gates: 2 passed. Strict
all-target Clippy passed. The dependency's existing ICU bidi deprecation warning
is emitted under its lint cap; no local warning suppression was added.
