# Current cleanroom GPUI native preflight

This directory contains a current-main preparation build only. No timing
capture has been run. The GPUI source pin is
`dcdadf4d527cb669c13d9e99271bb1f956f95a1f`, built from the nested cleanroom
workspace `/root/gpui-current-main-bench/reactivity` and package
`crates/gpui/Cargo.toml`. Do not build the legacy top-level `gpui-ce` package.
The accepted fixture bytes match the prior native-default 724 fixture exactly
(SHA-256 `a2c7b0a4992efa06719127cba59978aff62536d8d61994ca8c4c7dceb4f67c29`).

The successful locked, offline release build used feature `x11` (which includes
the AccessKit backend), renderer policy `Auto`, Rust 1.97.1, and a fresh target
directory. Metadata validation records the workspace root and exact `gpui`
package manifest. The compiled executable is frozen outside the repository at
`/tmp/gpui-current-dcdadf4-luna-bench-9f26a0f112e1b34c67ad0ad57649037f5c135d776e05d77deaeeacc08b81785f`
with SHA-256
`9f26a0f112e1b34c67ad0ad57649037f5c135d776e05d77deaeeacc08b81785f`.
`build-manifest.txt`, `metadata-summary.txt`, `source-archive-sha256.txt`, and
`build.log` preserve the build identity and result.

`preflight-current.sh` requires an explicit binary path/SHA, checks the source
pin and tracked source cleanliness, compares the fixture bytes, and checks the
two peer source pins and binary hashes before launching. It drives all three
apps for eager 0, eager 1,000, and virtual 250,000 on a private Xvfb display.
The accepted run is `preflights/private99-dcdadf4-current-v2/`; its status is
still `awaiting-manual-review`. The observer verified the 800×600 client,
marker/button pixels, expected first-row text for populated cases, and the
one-click marker transition. It reports visible row IDs 0–22 for the populated
viewport; realized virtual rows are source-derived (GPUI 23, MyGo 25, NanoUI
28), not internal instrumentation. Each log reports exact binary identity.
The companion backend probe reports `ReferenceCpu` selected by `Auto`; the
AT-SPI status probe says the session-bus service was not activatable. This is
not an active assistive-technology test. These are correctness checks, not
latency samples.

Renderer/font/accessibility differences remain: GPUI Auto selected
ReferenceCpu here, MyGo used its native GTK software path, NanoUI used its
Linux CPU/Cairo path; GPUI uses bundled Noto Sans while peers use DejaVu Sans;
AccessKit is compiled for GPUI, GTK/ATK is available to MyGo, and this NanoUI
snapshot has no accessibility implementation. The observer endpoint is Xvfb
server drawable readback, not compositor, vblank, scanout, or photons.

The initial `private98-*` attempts are preserved but excluded. The first
script revision omitted the `APP`/`MODE`/`ROWS` inputs required by `run-one.sh`;
the attempted Xvfb on :98 was also launched as a shell background child and
did not remain alive. The corrected :99 run used an attached Xvfb session and
passed. Do not treat those failed attempts as measurements or preflight rows.

Native timing is still gated on root's full native/AT/cross-platform
verification and a separately coordinated quiet window. Preserve this source
and executable pin; do not substitute the baseline-724 binary, legacy package,
or another renderer when describing this build.
