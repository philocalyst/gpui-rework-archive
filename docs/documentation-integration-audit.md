# Documentation integration audit

Audit performed 2026-10-07 against `b5aceefaf96af3946ff26a603e5f4110d4bdf4ca`
(`codex/zola-documentation`, also the current `main`). This is a read-only
review of the active implementation branches and worktrees. No branch was
merged, rebased, pushed, or modified.

## Decision

Do not merge `codex/portable-visual-tests` wholesale before the examples settle.
The branch is 53 commits on top of the current base and changes 230 paths. It
contains the same gallery/lesson moves and renderer/test paths as the committed
`codex/testing-examples` line (275 changed paths, two commits), while the
uncommitted `codex/example-cleanup` worktree changes 77 of those paths directly.
The overlap includes `crates/gpui/Cargo.toml`, nearly all learn/gallery examples,
`crates/gpui/src/scene*`, `gpui_render`, `gpui_test`, `Cargo.lock`, `README.md`,
and the CI workflows. Merging portable now would force a choice between two
in-progress example layouts and would likely discard the newer split work.

Use `codex/testing-examples` (`9da09ed5f6`, then `b33cb30710`) as the current
integration candidate once its example-cleanup worktree is committed and
verified. Treat portable's later testing/report commits as source material to
compare or selectively port after that line is authoritative; do not replay
the equivalent early example commits. The portable branch's tip is
`938f29258c`, with the last commit only adjusting documentation of collection
profiles and verification limits.

`codex/retained-rendering` is a separate two-commit prototype from
`c6b17e616a` (`c808b9b179`, `fb40fd2524`). It touches `scene.rs`, `taffy.rs`,
`window.rs`, and adds retained-layout workload tests, so it cannot be merged
after portable/testing without reconciling the scene and window APIs. Keep it
out of the documentation base until the runtime/display-list owner explicitly
declares it the successor; the portable/testing line already supplies the
scene-capture and report interfaces the docs can describe.

The `testing` branch is an older, separate line (tip `5280a735f1`, merge base
`74b3a785c1`) and has no site implementation. It is useful as historical test
coverage only; do not merge it into the docs branch.

## Site branch

`site` is not ancestrally mergeable with the current base (merge base
`2e354dfab2`). Its two site commits are:

* `9ba01949b8` — initial Zola field guide, 39 recovered chapters, templates,
  CSS, browser checks, and generated WASM assets.
* `23028794bd` — visual refresh, playground improvements, and
  `scripts/live-compiler.mjs`.

Transplant only the `site/` tree and the associated site workflow/configuration
from those commits, then regenerate the WASM artifacts against the final API.
Do not merge the entire `site` branch: it also carries 51 unrelated renderer
and platform commits. The generated `site/static/components/gpui-demo/*`
artifacts and `site/static/wasm/gpui_examples.wasm` are stale relative to any
future example/API cleanup and should be treated as reproducible build output,
not authoritative source.

The valuable reusable pieces are the content taxonomy under
`site/content/guide` and `site/content/examples`, migration manifest,
`templates/{base,page,section,shortcodes}`, the OKLCH stylesheet/font bundle,
`scripts/check-site.py`, `scripts/build.sh`, and the live compiler protocol in
`site/scripts/live-compiler.mjs`. The latter compiles an edited Rust module in
a serialized queue, caches by source hash, returns structured diagnostics, and
serves a generated WASM iframe. It is a strong foundation for the requested
comment-DSL/example post-processor, but its paths and demo crate must be
repointed to the final workspace layout.

## Verification and limitations

Using a temporary archive of `site@23028794bd` (so the worktree stayed clean):

```text
zola --root site check --skip-external-links       PASS
zola --root site build                             PASS
python3 site/scripts/check-site.py                 PASS
Checked 89 HTML documents, 39 recovered pages, fonts, CSS, and WASM fingerprints.
```

The checked-in WASM is therefore internally consistent with that site snapshot,
but this does not prove it builds against the current `main` APIs. The browser
test suite additionally requires `npm ci`, Playwright Chromium, and a browser;
those were not run during this read-only audit.

## Live playground worktree

`/Users/mileswirht/.codex/worktrees/12a1/gpui-ce3` is detached at
`c6b17e616a` and has substantial uncommitted work. It adds the
`crates/gpui_codepen` crate and guest, `scripts/codepen`, a web/Trunk bundle,
vendored Miri, workspace/profile changes, and a `codepen.yml` workflow. It also
modifies text/editable-element APIs and `Cargo.lock`. It is not a ready commit
and is based on an older runtime than the docs branch. Preserve the worktree
and import it only after its owner produces a commit against the selected
runtime base. The crate/scripts are valuable for the final live examples, but
the generated `web/dist` files and `vendor/` must be reviewed for reproducible
size/licensing and target compatibility before inclusion.

## Recommended order

1. Finish and commit the example cleanup; use that commit as the canonical
   example paths and names.
2. Reconcile/select the testing/report work from `codex/testing-examples` (or
   a reviewed successor), then decide whether any portable commits remain
   necessary. Keep retained-rendering separate pending the display-list
   decision.
3. Transplant the two site commits' `site/` content/templates/scripts and
   workflow, regenerate demos against the resulting API, and run Zola plus
   `check-site.py` and browser tests.
4. Import the live codepen/Miri work only from a committed, rebased snapshot;
   connect its stable source protocol to the site playground after API paths
   are final.

