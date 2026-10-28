# Parley 0.12 migration and correctness gates

The production planner now uses released Parley, Parley Engine, Fontique,
Parley Data and Parley Emoji 0.12.0. Direct outline admission and the patched
engine use Skrifa 0.49.0; ICU analysis/data stays at 2.3.0. All source-byte,
fallback-lease, glyph/run/line/stop and TextLayout APIs remain the same.

Primary release evidence:
[Parley v0.12.0](https://github.com/linebender/parley/releases/tag/v0.12.0),
[Parley registry metadata](https://crates.io/api/v1/crates/parley),
[Fontique registry metadata](https://crates.io/api/v1/crates/fontique),
[Skrifa registry metadata](https://crates.io/api/v1/crates/skrifa).
Parley 0.12 requires Rust 1.88; the test environment uses Rust 1.97.1.
The complete vendored package manifests, VCS metadata and Apache/MIT licenses
remain with both local patches. Their patch ledgers record exact crate archive
SHA-256 and upstream commit `6e1143dda817360dd3a2a64f9133c6e5dfabd881`.

The new engine fixes upstream's former fixed 32-element mapping scratch, but
still saturates coverage counts and truncates shaped-cluster glyph counts. Our
existing long-grapheme repairs move to that engine rather than being dropped.
The source-affinity Cursor rule and transient indexed geometry move to 0.12's
character-based paths. A borrowed shaped-source iterator avoids replacing finer
glyph ownership with the new public whole-grapheme clusters. No retained
Canvas mapping field or second layout is introduced.

Two adapter details matter for correctness:

- New line/content bounds can differ by a float ulp even for ordinary text.
  Canvas uses the same union as Cursor geometry; otherwise a caret just above
  its recorded line top can acquire the preceding line through binary search.
- Fontique now compares requested CSS weight to a variable axis's actual
  default, independently of the overridden face weight. Explicit FontFace
  defaults override the registry's axis metadata so a default700 face is not
  silently shaped at400 while the rasterizer renders its default instance.

The existing 8 selection and 14 Unicode tests are preserved, including the
independent byte11 bidi soft-wrap line oracle, physical arrow/hit transitions,
CRLF atomicity, zero-allocation queries, 512-accent glyph/source/position oracle,
and modified variable-default face. The indexed helper still has a direct
Cursor oracle at every byte and both affinities, including inline boxes.
`Glyph` stays 16 bytes, `TextLayout` stays 56 bytes, and authored Color stays 16
bytes; the full Canvas suite contains those layout checks.

Validation on this migration: 170 Canvas tests passed across all targets and
features (four existing expensive/timing tests remain ignored); all22 selection
and Unicode tests also passed in release. The private engine coverage regression
passed every listed count and missing-tail case. The source gates compare
semantic output and retained layouts; no new timing comparison was collected.

Upstream 0.12 removed the former local word-boundaries feature. Current word
analysis remains enabled. Old payload/native/timing feature comparisons in
TEXT.md and evidence files remain historical 0.11 measurements and cannot be
reused to describe the new binary. This migration records correctness gates,
not performance comparisons.

HarfRust 0.12 remains a constrained production dependency of the released engine.
The latest 0.14 removes UnicodeBuffer, GlyphBuffer, ShaperData, ShaperInstance
and Variation APIs; a real trial produces 15 compile errors and requires a
separate shaper rewrite. Swash 0.2.10 likewise still requires Skrifa 0.44, and
Fontique 0.12/HarfRust 0.12 require read-fonts 0.41. Direct latest dependencies do
not imply every transitive major is latest. The resolved registry audit reports
the actual versions, target conditions and requiring parents separately.

Reproduction from `reactivity/`:

```sh
cargo test -p gpui_canvas --all-targets --all-features --jobs 2
cargo test --release -p gpui_canvas --test selection --test unicode --jobs 2
python3 vendor/parley_engine/check-clusters.py
```

The subsequent [matched allocation investigation](../../../evidence/dependency-modernization/README.md)
preserves the initial upgrade's transient-allocation regression and a separate
scoped paragraph-buffer reuse change. It records source/lock/driver/binary hashes,
three-repeat requested-heap captures, actual DHAT stacks and identical rendered
pixels. Reuse reduces repeated-label allocation totals, with disclosed
single-label/peak costs; stable output header sizes alone do not establish
memory neutrality. That follow-up passes 171 Canvas tests and the same release
22-test selection/Unicode corpus. Its historical graph predates the separate
GPU30/SIMD/editor/zbus6 integrations.
