# Frozen-724 versus current-GPUI native capture

This is the fail-closed runner and record for the completed isolated GPUI
parent/candidate comparison. The full raw campaign is in
[`results/paired-724-current-dcdadf4-20261021/README.md`](results/paired-724-current-dcdadf4-20261021/README.md).
The raw sample files, order, manifest, and derived summary are checked by that
directory's `sha256.txt`.

Before capture, set all required path and SHA variables and run the script with
`LUNA_GUARD_ONLY=1`. That mode validates both sources, manifests, binaries,
observer identity, display socket, fixture, and all six workload/source cells,
then exits without creating a results directory or launching an observer. Root
reviewed this guard mode before the accepted run. A rerun must use a new unique
campaign ID and a fresh root-reviewed preflight status; this document records
the exact guard-only invocation used to revalidate the committed selectors.

The baseline is the published cleanroom build at GPUI
`724ece73cb665a1f6d83e97ae7d431eee11a887a`; the candidate is the cleanroom
build at `dcdadf4d527cb669c13d9e99271bb1f956f95a1f`. Both use the same
`luna_bench.rs` fixture SHA-256
`a2c7b0a4992efa06719127cba59978aff62536d8d61994ca8c4c7dceb4f67c29`, `x11`
feature, release profile, `RendererPolicy::Auto`, and 800×600 task. The
baseline executable is
`/tmp/gpui-luna-current-native-target/release/examples/luna_bench` (SHA-256
`795b54cc4c8feef2d39fb4f73e4fd6b7cf2799b45fadec192888564fb85b6a91`). The
current executable is
`/tmp/gpui-current-dcdadf4-luna-bench-9f26a0f112e1b34c67ad0ad57649037f5c135d776e05d77deaeeacc08b81785f`
(SHA-256
`9f26a0f112e1b34c67ad0ad57649037f5c135d776e05d77deaeeacc08b81785f`). The
runner requires explicit binary paths, SHA values, both source worktrees, both
build manifests, both reviewed preflight records, the observer path/SHA, and a
unique campaign ID. It has no binary or display fallback.

The six cells are paired by workload, with process order alternating:

| Workload | Run order |
| --- | --- |
| eager 0 | 724, current |
| eager 1,000 | current, 724 |
| virtual 250,000 | 724, current |

Each observer process runs 100 fresh application starts, 10 verified clicks
per start, and five idle memory samples at 750 ms. This gives 100 startup
observations and 1,000 click observations per app/source/workload cell. It is
an order-balanced block comparison, not per-start paired observations; do not
report paired per-event confidence intervals. The observer endpoint is the
Xvfb server drawable after damage/readback, not compositor, vblank, scanout, or
photons. The script requires the already-running private persistent display
`:97` and does not start/restart Xvfb.

The source and binary hashes are checked before every observer process. The
observer itself is checked against its published SHA at every launch. Each
`run-one.sh` invocation also performs the application's explicit binary SHA
check before it starts the observer child. Per-cell raw logs include the exact
binary identity and nanosecond percentiles. `order.csv`, manifests, source
guards, and raw output are written to a unique campaign directory and never
overwrite prior output.

This comparison isolates baseline-to-current GPUI behavior on this host; it is
not a framework ranking. Both builds request native-default Auto, but the
preflights observed `ReferenceCpu` for both. AccessKit is compiled in both;
the latest current preflight found no activatable session-bus AT-SPI service,
so the capture must not be described as an active assistive-technology run.
Fonts and renderer differences from NanoUI/MyGo are outside this pair.

## Revalidate the committed selectors

From `/root/gpui-bench-luna/reactivity`, with the private persistent Xvfb `:97`
running, this command runs all six source/binary/preflight guards and no
application or observer. It requires the exact worktrees, manifests, reviewed
preflight records, and executable hashes used by the accepted campaign:

```sh
LUNA_PAIR_ID=guard-only-724-current-dcdadf4-20261021 \
LUNA_DISPLAY=:97 \
LUNA_BASELINE_BINARY=/tmp/gpui-luna-current-native-target/release/examples/luna_bench \
LUNA_BASELINE_SHA=795b54cc4c8feef2d39fb4f73e4fd6b7cf2799b45fadec192888564fb85b6a91 \
LUNA_BASELINE_SOURCE_TREE=/root/gpui-current-native-bench/reactivity \
LUNA_BASELINE_MANIFEST=/root/gpui-bench-luna/reactivity/benchmarks/nanoui-mygo-gpui/native-default-724ece73/build-manifest.txt \
LUNA_BASELINE_PREFLIGHT_RECORD=/root/gpui-bench-luna/reactivity/benchmarks/nanoui-mygo-gpui/native-default-724ece73/preflights/private97-20261021-click/record.txt \
LUNA_CURRENT_BINARY=/tmp/gpui-current-dcdadf4-luna-bench-9f26a0f112e1b34c67ad0ad57649037f5c135d776e05d77deaeeacc08b81785f \
LUNA_CURRENT_SHA=9f26a0f112e1b34c67ad0ad57649037f5c135d776e05d77deaeeacc08b81785f \
LUNA_CURRENT_SOURCE_TREE=/root/gpui-current-main-bench/reactivity \
LUNA_CURRENT_MANIFEST=/root/gpui-bench-luna/reactivity/benchmarks/nanoui-mygo-gpui/native-current-dcdadf4/build-manifest.txt \
LUNA_CURRENT_PREFLIGHT_RECORD=/root/gpui-bench-luna/reactivity/benchmarks/nanoui-mygo-gpui/native-current-dcdadf4/preflights/private99-dcdadf4-current-v2/record.txt \
LUNA_OBSERVER_BINARY=/tmp/gpui-bench-observer-target/release/luna-x11-observer \
LUNA_OBSERVER_SHA=b4f84c80caa854d974643a2c20823537601a04745a7bcf320be356732b42f88b \
LUNA_GUARD_ONLY=1 \
./benchmarks/nanoui-mygo-gpui/native-paired-724-current/capture-paired.sh
```
