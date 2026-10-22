# Acknowledged geometry, Future questions and native rendering together

Frozen main source: `007f10ccbdf278dc16242b157d19e12075d5ba2f`.
It includes the geometry-only C/P text maps, typed Future questions, Vulkan stage
cleanup, cold Auto blank admission and Hummingbird's public renderer CLI.

| Gate | Result |
| --- | --- |
| Full desktop/X11/Wayland/parallel/verified-layout GPUI suite | 529 passed in 48 groups; 27 ignored |
| GPUI all-target strict Clippy and three-library formatting | Passed |
| Native-feature Hummingbird tests and shared headless transcript | Nine tests and transcript passed |
| External component/catalog fixture | Five passed |
| Actual AT-SPI Registry | Unicode extents/hit/ordinary-P oracle, selection/edit and reactivation passed |
| Actual late AT-SPI service/provider lifecycle | Replacement and destruction passed |
| Native Future cancellation and result wake | Passed without unrelated input |
| Native cold blank lifecycle | Resize/resume stay cold; complex CPU frame then GPU handoff passed |
| Shared Hummingbird through CPU, GPU, Auto | All three real X11/AT-SPI transcripts passed |

One actual Cargo-produced GPUI unit artifact and one Hummingbird executable were
copied and hashed before native execution. Source/library/vendor files and both
copies remained unchanged. Each Hummingbird run presented eight acknowledged
frames: CPU/Auto used ReferenceCpu and explicit GPU used llvmpipe. Private Xvfb
and D-Bus sessions were owned and stopped. No renderer-specific application View
or private test dispatcher was used.

The exact [shipping source ledger](core-lines.json) is 29,365 non-test code lines:
29,352 under the six library source trees plus 13 build-script lines. Comments,
blanks and tests are excluded by the pinned Syn/Tokei counter. Dependencies,
vendor changes, tools, ports and fixtures are charged separately; this does not
establish original-framework parity or predict final size.

The [geometry producer evidence](../../benchmarks/acknowledged-text-geometry/README.md)
retains its own source pins, construction/memory regressions, code-size controls
and Apple/MSVC compile checks. This combined campaign adds no foreign runtime,
hardware timing, RSS or native HDR claim. Optional offline/static shader work,
compact maps, query-index improvements and intrinsic-measurement experiments
remain outside this source freeze.

See [metadata.json](metadata.json), [qualification.json](qualification.json),
[results.json](results.json) and [source-guard.json](source-guard.json).
`guard-driver.py` and `archive.py` preserve orchestration; raw logs are compressed
without editing their contents. `SHA256.json` covers this directory except itself.
