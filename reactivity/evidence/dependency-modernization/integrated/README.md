# Integrated production dependency closure

The frozen report uses source `56e1f5ddf1` and Cargo metadata for all features and
all target cfgs. It traverses only normal/build edges from workspace members;
dev-only test dependencies do not masquerade as production dependencies.
The existing primary crates.io cache is reused; missing names are fetched by
the audit helper and disclosed in the report. Unfiltered offline metadata first
failed on an uncached Emscripten package; the subsequent locked online metadata
command succeeded, with its fetch log preserved.

There are 398 active packages. Registry resolutions include 282 at the latest
stable version, 91 behind a newer stable major/minor, three at the latest
prerelease-only release and one behind its prerelease-only release. Vendored
packages are reported separately. Parley/Engine/Fontique 0.12, WGPU/HAL 30.0.1,
WGSL-RS beta.6 and the new utility direct pins match their frozen latest evidence.
Older constrained HarfRust, Swash font readers, Winit's X11rb and AccessKit's
zbus graph remain explicit compatibility work; this is not an all-transitives-
latest claim. See the parent report for the preserved losing HarfRust trial.

`ports/hummingbird/Cargo.lock` is an active independent application workspace,
outside the UI-core graph. Its six added dependency families have separate
primary registry checks in the port. Tool and frozen benchmark lock scopes also
remain distinct; historical controls are not rewritten to new versions.
