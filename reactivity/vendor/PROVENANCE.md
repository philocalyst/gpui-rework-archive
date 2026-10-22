# Vendored windowing and layout sources

Winit retains its complete published archive. Cephal now contains the complete
git archive of the requested performance branch, including licenses, fixtures,
examples and manifests. Both are excluded from workspace membership. Local
adapter changes remain in the first-party layout boundary.

| Directory | Package | Upstream commit | Source archive SHA256 |
| --- | --- | --- | --- |
| `winit` | Winit 0.30.13 | `e9809ef54b18499bb4f2cac945719ecc2a61061b` | `a6755fa58a9f8350bd1e472d4c3fcc25f824ec358933bba33306d0b63df5978d` |
| `cephal` | Cephal 0.1.1 | `20c4c494179078ddfde7e8532ffc93f28cf5b531` (`perf/cold-layout`) | `1ff2c62c3deee1e9aaec7db3b65eada7d8a8474ea3874da88ef6097c79e9574c` |

Sources: [Winit archive](https://static.crates.io/crates/winit/winit-0.30.13.crate),
[Cephal git archive](https://codeload.github.com/zortax/cephal/tar.gz/20c4c494179078ddfde7e8532ffc93f28cf5b531).
Winit `.cargo_vcs_info.json` and Cephal `GPUI-PROVENANCE.json` record their commits.
The prior Cephal package archive remains recoverable at `d05b826b62`. Winit is Apache 2.0;
Cephal is MIT or Apache 2.0. Their license files remain in each directory.

`crates/host` changes the integration boundary instead of forking native lifecycle
semantics: native callbacks borrow their event synchronously, wake requests
coalesce, idle uses `Wait`, and Linux backends are selected explicitly. Winit's
optional Adwaita CSD/font stack is not enabled by the host features. Applications
that need those decorations must enable an appropriate platform policy.

Cephal is pinned without its optional `taffy-compat` feature. Its low-level
`LayoutTree`, `CacheAccess`, and `Incremental` traits are the intended shared-tree
seam. The presence of vendored source alone does not prove a working adapter or
layout parity; the implementation status document records that separately.

Before changing a vendor file, record the patch purpose and add a test at the
host or layout boundary. Update by replacing the complete archive, reviewing the
upstream diff, verifying checksums, and rerunning that boundary's conformance
fixtures. Report first-party, vendor and test line counts separately and report
the total too; moving code into this folder is not a reduction.

The additional `softbuffer` and `wgpu-hal` directories are complete published
archives with narrowly recorded Apple presenter ownership patches. Their pinned
upstream revisions, archive hashes, changes, and platform validation limits are
in [PRESENTER_PATCHES.md](PRESENTER_PATCHES.md). They are excluded from workspace
membership and selected by root Cargo `[patch.crates-io]` entries.
