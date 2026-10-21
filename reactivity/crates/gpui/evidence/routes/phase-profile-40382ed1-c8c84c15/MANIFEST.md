# Build and capture manifest

Both sources were built independently in detached worktrees using the same Rust 1.97.1 toolchain and lockfile. The feature profile was `--features gpui/route-profile`, with distinct target directories:

- Baseline worktree `/root/gpui-route-profile-baseline`, target `/tmp/gpui-route-profile-baseline-target`.
- Candidate worktree `/root/gpui-route-profile-candidate`, target `/tmp/gpui-route-profile-candidate-target`.

Build command for each: `cargo build -p gpui --example route_storage_measure --features gpui/route-profile --release`. `cargo fmt -p gpui -- --check` passed in both worktrees. The only build warning is the pre-existing deprecated Parley ICU method.

The runner `run-pairs.sh` alternates 11 fresh-process runs per source and filters to `(count=4096,every=1,exact=true)`. No `strace` process or global allocator-policy change was used. Full raw outputs and their SHA-256s are retained in `raw/` and `raw-sha256.txt`.
