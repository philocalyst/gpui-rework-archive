# Upstream sync

Automated, local-only tooling to pull GPUI changes from the upstream Zed monorepo
(`zed-industries/zed`) into this standalone fork. Agent work can use this ChatGPT session,
Codex CLI, or the legacy Claude CLI. The orchestrator validates every response before it
stages or commits changes. **Nothing is ever pushed.**

## TL;DR

```sh
just sync-upstream-bootstrap   # ONE TIME — records the baseline to sync from
just sync-upstream             # prints an external-agent session ID and prompt by default
just sync-upstream-status      # how far behind upstream are we?
```

`just sync-upstream` starts a `sync/zed-<date>-<sha>` branch. In default external mode,
it pauses at each required conflict-resolution or build-fix checkpoint with a session ID
and prompt; resume with `sync_upstream.py resume SESSION --response-file PATH`. The run is
complete only after resolution and verification finish successfully. Then review the branch
and fast-forward `main` or open a PR by hand.

## How it works

Upstream keeps the GPUI crates **in-tree** in the monorepo under `crates/gpui*`. This
fork keeps the same crates at the **same relative paths**, so upstream changes apply at
identical paths here. The script uses a **vendor-branch 3-way merge** (a generalized
`git subtree` merge):

1. A local branch `vendor/zed-gpui` holds a *filtered replay* of upstream commits whose
   filtered GPUI tree changes. Each replay commit is newly created with the source
   author/date/message plus a `zed-upstream: <sha>` trailer and contains only tracked
   `crates/gpui*` paths, built through a throwaway git index (no working-tree churn).
   Merge commits are linearized when their filtered trees change. The original upstream
   ancestry and merge topology are not preserved.
2. Each sync extends that filtered replay and merges its tip. Git's merge base is the
   previous vendor tip, so the merge applies the upstream GPUI delta since the last sync;
   already-cherry-picked changes can merge without conflict. The sync commit's second
   parent is the vendor tip. Its ancestry is the filtered replay, not original upstream
   history; `zed-upstream` trailers provide the source commit mapping.
3. The merge is committed as **two commits** for reviewability:
   - **Commit 1 — raw merge:** git's auto-merges applied, conflict markers committed in
     as-is (deterministic add/delete conflicts settled by policy: gpui-ce's deletions
     kept). This captures exactly what git could *not* resolve.
   - **Commit 2 — resolution:** the selected agent (`resolve-conflicts.prompt.md`, looped
     up to `--retries`) edits out the markers. Because it's separate, its diff shows what
     was chosen, distinct from git's auto-merge.
   (A conflict-free sync is just one clean merge commit.)
4. The **verify-fix loop** runs: the build gate (`just check`,
   which also treats compile **warnings** as fixable so the branch stays CI-clean), then
   the test gate (`just test`). (There are no `zed-industries/zed` git deps left to bump — PR #91
   vendored everything in-tree, so the old dep-bump step is now a no-op.) Any failure — compile
   errors, warnings, or test failures —
   is handed to the selected agent (`fix-build.prompt.md`), looped up to `--retries` times, and
   committed as a **third** commit. Disable tests with `SYNC_RUN_TESTS=0`, or warning
   enforcement with `SYNC_FAIL_ON_WARNINGS=0`.

### Tracked crates (fork dir ← upstream dir; dirs, not package names)

Synced 1:1 (same dir): `gpui`, `gpui_apple`, `gpui_ios`, `gpui_linux`, `gpui_macos`,
`gpui_macros`, `gpui_platform`, `gpui_shared_string`, `gpui_tokio`, `gpui_web`,
`gpui_wgpu`, `gpui_windows`.

Synced with **path remapping** — vendored + renamed by the fork (PR #91 removed the git sources):
`gpui_bench_metrics`←`bench_metrics`, `gpui_collections`←`collections`,
`gpui_sum_tree`←`sum_tree`, `gpui_refineable`←`refineable`,
`gpui_derive_refineable`←`refineable/derive_refineable`, `gpui_scheduler`←`scheduler`,
`gpui_media`←`media`, `gpui_zed_util`←`util`, `gpui_ce_util`←`gpui_util`, `gpui_path`←`path`.
The small standalone Apache-2.0 `bench_metrics` crate is included because upstream `bench-support`
and platform benchmark targets depend on it. It maps to `gpui_bench_metrics` while retaining the
upstream library name `bench_metrics`. Packaging is orthogonal to directories: every fork package is
`gpui_ce_*` (main crate `gpui-ce`
with a hyphen), each with `[lib] name` preserving the upstream crate name and a
`[workspace.dependencies]` alias mapping the upstream name back (e.g.
`collections = { package = "gpui_ce_collections" }`, `gpui = { package = "gpui-ce" }`).
The merge preserves each
crate's gpui-ce adaptations (package rename + lib-name override, path deps, `ztracing`→`tracing`,
`zlog` removal) via
conflict resolution while taking upstream's real changes — so upstream API additions land through the
merge instead of being hand-ported during the build-fix pass.

Left untouched: `crates/gpui_elements` (fork-only, package `gpui_ce_elements`),
`tooling/perf` (fork-only);
`util_macros`
is no longer used by the fork. The mapping lives in `TRACKED_CRATES` in `sync_upstream.py`.

### Cross-crate file moves

Upstream relocates code between crates (e.g. #61029 split `util/src/rel_path.rs` out into the new
`crates/path`). Naively that reads as "upstream deleted a file the fork had modified", and the
delete/modify policy would resurrect a stale duplicate of code that now lives elsewhere.

Because **both sides of a vendor-history diff are already remapped to fork paths**, git's rename
detection reports such a move directly in gpui-ce terms — `detect_moves()` runs
`git diff -M<similarity> --diff-filter=R <prev vendor tip> <new tip>` and keeps the cross-directory
hits (`crates/gpui_zed_util/src/rel_path.rs` → `crates/gpui_path/src/rel_path.rs`, detected at 61%
similarity for #61029). Those moves then:

- settle the resulting `UD` conflict as **accept the deletion** (the content arrived at the new path
  in the same merge) instead of keeping the fork's now-orphaned copy, and
- get handed to the resolution prompt (rule 8), which re-applies the fork's adaptations at the **new**
  location and repoints `use`/`mod` references.

Tune with `SYNC_MOVE_SIMILARITY` (default `40%`). A move that falls below the threshold simply
degrades to the old behaviour — the fork's copy is kept and flagged for review, never lost.

## One-time bootstrap

The script needs to know which upstream commit this fork currently corresponds to, to use as the
merge base. Historically this was auto-read from the `zed-industries/zed` rev pinned in `Cargo.toml`,
but PR #91 removed those git sources, so there is no longer a pinned rev to default to — **pass the
baseline explicitly**:

```sh
just sync-upstream-bootstrap <upstream-sha>   # e.g. 876ec5a8a074 (the last rev pinned before #91)
```

Bootstrap adds the `zed` remote, builds the baseline vendor snapshot (all tracked crates remapped to
their fork paths at that rev), records it in the current branch's history with a **no-op** `-s ours`
merge (no files change), and writes `state.json`. Run it once. A too-old baseline just means the
first real sync has more to merge; correctness is unaffected. After the first successful sync the
recorded baseline advances automatically, so bootstrap is not needed again.

## Files

| File | Purpose |
|------|---------|
| `sync_upstream.py` | orchestrator (git plumbing + agent loops); stdlib-only, fully typed |
| `agent_session.py` | pinned, resumable external-agent sessions and audit artifacts |
| `resolve-conflicts.prompt.md` | rules for the conflict-resolution agent pass |
| `fix-build.prompt.md` | rules for the build-fix agent pass |
| `state.json` | committed: last synced upstream sha + vendor tip |

## Config / env overrides

Every default near the top of `sync_upstream.py` is overridable via a `SYNC_*` env var:

```sh
SYNC_AGENT=codex SYNC_MODEL=MODEL just sync-upstream  # optional Codex CLI backend
SYNC_RETRIES=5    just sync-upstream                  # more agent passes
SYNC_VERIFY_CMD="just ci-test" just sync-upstream
just sync-upstream --ref some-tag --no-bump --dry-run
```

## Caveats

- The compile gate is host-only (`just check` / `cargo check --workspace`). macOS- and
  Windows-specific changes can't be fully verified on a Linux host — verify those on the
  platform or in CI. The build-fix prompt asks the agent to flag such changes.
- Requires Python 3 (stdlib only — no pip installs), `just`, and the Rust toolchain. The
  default `external` agent mode pauses with a durable prompt and session ID; continue it
  with `sync_upstream.py resume SESSION --response-file PATH`. The response is retained
  in the audit record. Optional `codex` mode requires `codex` on `PATH`; legacy
  `claude` mode requires `claude` on `PATH`.
- If conflict resolution exhausts its retries, the branch is left mid-merge for you to
  finish. If verification fails, sync state is not advanced and the command exits nonzero; the branch
  remains available for review and another verification attempt.
- Codex runs with `codex exec --json --sandbox workspace-write` and captures its final
  message to an audit file. The runner removes common API/GitHub/SSH credential variables
  and disables Git credential helpers for that subprocess.
- External-agent resume requires `--response-file`; the script pins the branch, HEAD,
  merge state, upstream/vendor targets, prompt digest, and allowed path set before and
  after the response. It stages only explicitly validated files.
