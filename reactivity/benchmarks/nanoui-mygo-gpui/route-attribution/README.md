# Route-storage attribution campaign (prepared; no timings captured)

This campaign separates the clean parent-to-candidate attribution from the
cross-framework task comparison. The parent is the exact clean-room source
commit `b60af3a4f97d67a35b4eab5a4ef672a17d9de6f6`; the candidate is the
eventual root-frozen integration commit, recorded only after it exists. Do not
substitute the earlier `78824355bc4ceb1523bdbd21404b8380a50d9e7d` binary or the
intermediate `/root/gpui-pan-viewports` worktree for either side.

Both GPUI builds use the same checked-in benchmark fixture copied from
`../fixtures/gpui-luna_bench.rs`, Rust release profile, offline lockfile,
`x11-minimal` feature, `ReferenceCpu` presentation, Xvfb display `:94`, and
one dedicated Cargo target directory per source pin. Preserve source commit,
fixture SHA-256, `reactivity/Cargo.lock` SHA-256, executable SHA-256, target
triple, and `rustc -Vv` in each build record. The executable output is copied
to an immutable SHA-named file; do not overwrite it when building the
candidate.

Each build script requires its source to be a detached Git worktree and
refuses to build from a branch checkout or the authoritative working tree.
`CARGO_BUILD_JOBS` is configurable by the caller and defaults to 4; each
source still gets a unique target directory and immutable executable artifact.

## Campaigns that must remain separate

1. **Attribution:** parent `b60af3a4f9` versus the frozen integrated route
   candidate. Same GPUI fixture and build profile. Compare eager 0/1k/10k and
   virtual 250k only after each identical source fixture passes admission and
   visual preflight. This estimates the combined parent-to-candidate change;
   it does not isolate routes from other integrated changes. Root's additional
   route-only storage/churn experiment is the narrow attribution.
2. **Current-to-peers:** the frozen integrated candidate versus the already
   pinned JustRach NanoUI `dfa7f7ab4e890f643703f4ffe4d834ff10defd4f` and MyGo
   `ea23ad2975a87db9b20efe6690ffedf88f4fe4f3`, using the corrected fixtures
   and the `cpu-matched` profile. Reuse their existing source-pinned binaries;
   verify hashes against `../results/binary-and-fixture-sha256.txt` before the
   campaign. Never compare the older `baseline788` GPUI rows as if they used
   the current source.

The existing valid `baseline788` rows remain intact and labeled as the older
GPUI revision. The incomplete GPUI eager-10k smoke remains excluded. A fresh
10k cell is admitted only if all three apps pass one-start non-matrix
preflight: exact 800x600 client, expected title text pixels, first-row glyph
pixels, row identities/viewport expectations, no crash or validation error.
The fixture's eager mode intentionally has no scrolling. Do not add a
framework-specific scroll shim.

The runner's endpoint is Xvfb server drawable readback after XDamage, not
compositor, vblank, scanout, or photons. Keep the single X observer connection
and Xvfb server alive across app starts. For timing, use 100 starts per cell,
10 pixel-verified clicks per start, and only five idle-memory samples per cell.
Capture p50/p95/p99 in raw nanoseconds. Rotate app order and alternate parent /
candidate within workload blocks. Do not begin captures until root assigns a
quiet window and reviews the frozen executable/source manifest.

## Parent build

`build-parent.sh` builds from a detached worktree at the exact parent pin into
`/tmp/gpui-route-parent-b60-target`, saves the immutable executable under
`/tmp/gpui-route-builds/`, and writes its source/fixture/toolchain/binary
manifest under `../results/`. It does not run the window or observer, so it
produces no timing samples.

The fresh parent executable is
`/tmp/gpui-route-builds/gpui-parent-b60-da0423c6ac40462b2a8c676491b6c3a40b5d6129c5755843d8d51709d03826e7`
(SHA-256 `da0423c6ac40462b2a8c676491b6c3a40b5d6129c5755843d8d51709d03826e7`).
Its manifest is
`../results/route-parent-b60-da0423c6ac40462b2a8c676491b6c3a40b5d6129c5755843d8d51709d03826e7.manifest`;
the locked build command log is `../results/route-parent-build.log`. It was
built from the clean b60af3a4f9 worktree with the approved fixture, Rust 1.97.1,
x86_64-unknown-linux-gnu, release profile, and `x11-minimal` / ReferenceCpu.
It has not been run or timed.

The capture scripts require a reviewed `preflight-native.sh` record with
`status=pass`; that preflight checks the exact frozen parent and candidate
GPUI binaries plus both peer binaries in eager 0/1k and virtual 250k modes.
They refuse to overwrite prior runs and record the explicit order. They omit
eager 10,000 by default; supplying
`LUNA_10K_PREFLIGHT_RECORD` includes it only if that file is a reviewed
preflight record containing `status=pass`. The record should name the exact
fixture and source/binary SHAs for every app and retain all three app logs and
images. After review, update the record status and regenerate that preflight's
`sha256.txt`. This keeps the high-node workload out until it is visibly and
semantically admitted on the frozen builds.

The corrected fixture is intentionally not claimed to be renderer-equivalent
with the peers: GPUI uses bundled Noto Sans; NanoUI/MyGo use staged DejaVu Sans,
and software rasterizers/native widget styling differ. For virtual mode,
source-derived materialization expectations are GPUI 23, MyGo 25, NanoUI 28,
with visible IDs 0–21 fully drawn and ID22 clipped. Report these differences
beside every comparison.
