# Vendored windowing and layout sources

Both directories contain the complete published source archives, including
licenses, upstream examples and manifests. They are excluded from the experiment
workspace membership. No upstream source changes have been made.

| Directory | Package | Upstream commit | Source archive SHA256 |
| --- | --- | --- | --- |
| `winit` | Winit 0.30.13 | `e9809ef54b18499bb4f2cac945719ecc2a61061b` | `a6755fa58a9f8350bd1e472d4c3fcc25f824ec358933bba33306d0b63df5978d` |
| `cephal` | Cephal 0.1.1 | `3c1747d2722f18f1f72811882e4cdede17b52362` | `9b74eac90bccfd105751a15dcf6e16206b3ba0c837575dd7c4f9993c35e4b014` |

Sources: [Winit archive](https://static.crates.io/crates/winit/winit-0.30.13.crate),
[Cephal archive](https://static.crates.io/crates/cephal/cephal-0.1.1.crate).
The `.cargo_vcs_info.json` files record the upstream commits. Winit is Apache 2.0;
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
