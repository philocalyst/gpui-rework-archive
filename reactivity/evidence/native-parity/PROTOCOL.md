# Native workload parity qualification

Base: native diagnostic port 6d5e409d6b3e8994b69c8dbf7a153e8358be5e99.
Reference: unchanged ZGX a3678578980ef239058c557338ef9c544d356b0c.
Local branch local/native-workload-parity, isolated target
/home/user/gpui-native-parity-target. No performance ranking in this stage.

First slice: move the unchanged shared Workload into an exclusively owned UI
inbox callback. Stream mode uses existing with_inbox_for on Lab::STREAM;
scroll/both retain a root callback until an equivalent controlled list exists.
The producer sends tick notifications only. Workload::tick and visible_text
execute on the UI thread and stay inside the charged operation. One pending
tick, native presentation acknowledgement start, stop/join and diagnostics
remain. The model holds only rendered text, row range/offset and controls.

Qualification uses ordinary Win inbox delivery, independent unchanged Workload
state, fresh-window exact image oracles, source/owner counters, finish/empty
inbox and producer close. Exercise stream/scroll/both including prefilled text,
row-boundary and buffer trimming. Actual private X11 verifies tick delivery,
presentation and teardown. Preserve any failures and source corrections. Freeze
clean source before builds; hash all present tracked first-party/vendor/config
inputs before and after, capture executable identity before later test builds.
Use pinned nightly-2026-10-23 checksum freshness and strict Clippy.

Later slices must qualify typography, wheel routing, keyed two-row overscan,
deferred controls and matched build profiles. No microbenchmark threshold is
being changed. GPU tile variants remain unadopted. Physical GPU and two-hardware
requirements are unchanged and cannot be satisfied by this VM's llvmpipe.
