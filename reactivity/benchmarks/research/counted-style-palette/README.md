# Counted style palette phase probe

This is an isolated diagnostic comparing the counted style palette with its
exact parent, `f01947e679d9dd2ca7ef149b70dccff92dad67dc`. The candidate is
**not recommended for adoption in its current form**: it removes most sparse
mutation allocation but measured full-cohort mutation regresses by 62% at
65,536 styles and about 3.8× the parent time for the 60/139-style cases. See
[`phase-results.md`](phase-results.md) for the full measurements and limits.

The same ignored probe and Todo/virtual Library-derived style seeds ran in
both variants. It measures lane construction, warm reads, a first sparse set,
four whole-cohort mutations, `Win::recording` owner setup, and the public
inspector path. This diagnoses retained-style work. It is not a native-window,
active-accessibility, or end-to-end application benchmark.

## Reproduction

Use two detached worktrees in a directory of your choice. `PALETTE_BASE` must
point to their common parent directory. Commands below assume the package
root is `$PACKAGE` and the cleanroom repository root is `$REPO`:

```sh
export PALETTE_BASE=/tmp/style-palette-worktrees
export PACKAGE=/path/to/counted-style-palette
export REPO=/path/to/gpui-ce3
mkdir -p "$PALETTE_BASE"
git -C "$REPO" worktree add --detach "$PALETTE_BASE/parent" f01947e679d9dd2ca7ef149b70dccff92dad67dc
git -C "$REPO" worktree add --detach "$PALETTE_BASE/candidate" f01947e679d9dd2ca7ef149b70dccff92dad67dc
git -C "$PALETTE_BASE/parent" apply "$PACKAGE/patches/phase-probe.patch"
git -C "$PALETTE_BASE/candidate" apply "$PACKAGE/patches/phase-probe.patch"
git -C "$PALETTE_BASE/candidate" apply "$PACKAGE/patches/counted-style-palette.patch"
PALETTE_BASE="$PALETTE_BASE" PALETTE_MODE=guard "$PACKAGE/run-paired.sh"
PALETTE_BASE="$PALETTE_BASE" PALETTE_MODE=build PALETTE_BUILD_JOBS=2 "$PACKAGE/run-paired.sh"
```

The runner checks exact HEADs, allowed modified paths, source SHA-256 values,
and Cargo metadata for the nested `reactivity` workspace and `gpui` package.
Builds use separate target directories and `--locked --offline --release`
with `x11-minimal`. For a new measurement, obtain a coordinated quiet window,
then run:

```sh
PALETTE_BASE="$PALETTE_BASE" PALETTE_MODE=capture PALETTE_QUIET_WINDOW=approved "$PACKAGE/run-paired.sh"
```

The capture mode hashes each frozen executable before launching it and
alternates parent/candidate order across three repetitions. Keep
`--test-threads=1`: allocation instrumentation is process-global. The local
quiet-window environment variable is a guard, not coordination by itself.

## Recorded inputs and provenance

- Parent source: `f01947e679d9dd2ca7ef149b70dccff92dad67dc`.
- Counted-palette `styles.rs` SHA-256:
  `2e535b39a2a0ec699fcdee3465b84c1e61d378585606f83296592e5362e3b479`.
- Shared probe source SHA-256:
  `6a09247eb8944d088912b9f1d13a5e22da70ee5f9c08dd0938bc4d828c12e935`.
- Patch hashes: see `patches/` and `raw-sha256.txt`.
- Binaries, compiler build logs, process/load envelope, and six raw stdout
  logs: `raw/`.
- Captured runner SHA-256:
  `5f41a9e2d0b14d3a8996d7bc1ad87c9bf698acd8c867b116df4c9dd567f0f96b`.
  `raw/run-paired-captured.sh` preserves the exact runner used. The packaged
  `run-paired.sh` differs only by accepting `PALETTE_BASE` instead of an
  absolute `/root/gpui-palette-phase` path.
- Toolchain: Cargo 1.97.1, rustc 1.97.1, LLVM 22.1.6; x86_64 Linux; release
  profile; `x11-minimal`; two build jobs. Assembly and exact binary digests
  are in `assembly/assembly-review.md`.

The implementation adds a `u32` count to each palette pattern: 4 bytes per
retained pattern, capped at 32 patterns. It retains no per-node counter. At
most 128 additional bytes are retained in the palette, plus up to 128 bytes
in the temporary builder palette vector. Default styles stay allocation-free.
The candidate shared getter uses a 92-byte palette-entry stride versus 88
bytes in the parent; inspected assembly does not load the counter on reads.

## Result status

The captured phase results are in `phase-results.md`. Setup timings are
controls with three observations, and lane timings have six observations per
cell. The capture window was quiet by coordination, with no runnable build or
test process observed, but two API Cargo processes and one rustc process were
stopped (`T`) in both process snapshots. This qualification and the complete
pressure snapshots are preserved in `raw/capture-envelope.txt`. The small
sample counts and `Win::recording` setup path limit generalization.
