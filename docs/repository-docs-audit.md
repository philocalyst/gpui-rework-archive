# Repository documentation review

This review covered the repository Markdown and the former Typst documentation
shell outside the generated site, core rustdoc, and the existing API/research
audit notes. The current testing-examples checkout is the reference for example
paths and commands.

## Reworked

- `docs/documentation-authoring.md` now points at `site/examples/src/bin`, the
  shared support launcher, and the site examples Cargo manifest. Its annotation
  and generation workflow remains the source of truth for the comment DSL.
- `docs/README.md` is the repository documentation index. It routes readers to
  the Zola site for product guidance and keeps testing, releasing, mutation,
  performance, and hot-patching workflow documents discoverable.
- `docs/hot-patching.md` preserves the useful setup, version, command, and
  limitation details from the old Typst page in Markdown.
- The obsolete Typst presentation shell (`docs/components.typ`,
  `docs/sidebar.typ`, `docs/template.typ`, and `docs/pages/index.typ`) and the
  migrated `docs/pages/hot-patching.typ` were removed after their only useful
  content was moved to Markdown. They contained layout/navigation code rather
  than independent technical guidance.

## Reviewed and retained

The following existing technical documents were read against the current source
and retained because their commands, contracts, or historical evidence remain
specific and useful:

- `docs/examples.md`
- `docs/releasing.md`
- `docs/testing.md`
- `docs/testing-design.md`
- `docs/testing-mutations.md`
- `docs/testing-performance.md`
- all `docs/testing/evidence/*.md` records
- `crates/gpui_ce_parley/future_work.md`
- `crates/gpui_render/THIRD_PARTY_NOTICES.md`
- `crates/gpui_test/assets/fonts/*/README.md`
- `scripts/sync-upstream/README.md`

The API audit files, documentation research/reference inventory, and generated
site prose were intentionally not rewritten in this pass. The crate-level
`crates/gpui/README.md` was also left to the core API/site owner as requested.

## Known gaps

`docs/examples.md` describes the larger native visual-gallery suite while the
Zola site describes the smaller walkthrough binaries; both are valid entry
points, but they should eventually be joined by a generated cross-reference.
Testing evidence intentionally records historical revisions and cannot be
collapsed into current instructions. Platform-specific behavior still needs
the relevant native runner, and the hot-patching guide remains experimental.
