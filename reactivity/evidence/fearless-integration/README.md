# Shared SIMD geometry integration

Source `1023e8e0f3` is integrated against `c97ecc8909`, retaining the source-owned
paint banks, HDR cut invalidation, coordinate spaces, compact CSR and text-query
cuts. Binary rectangle/rounded membership stays a u16 mask through sample
promotion. One generic ordered f64 geometry kernel instantiates the guaranteed
hardware baseline or Fallback; the original already-vectorized RGBA/image
equations stay shared. There is no retained backend selector, startup CPU probe,
public window switch, new header or production unsafe block.

The encoded uniform-row copier shares one implementation per output writer.
Encoding was already once per tile, and stores were already vectorized. The
change isolates checked row bounds and register lifetimes; instruction-counter
and assembly evidence motivated it. The relative contribution of those changes
and code layout to measured time has not been established.

The lossless producer archive contains all seven evidence campaigns from the
producer checkout at `846dd17ad0`: shared pipeline, ABI controls, layout and wide
sample experiments, coordinate masks, geometry-only controls, hardware-counter
diagnostics, and final uniform-output controls. It preserves raw rows, source,
library and executable guards, complete assembly and rejected/invalid variants.
In the final source-pinned host capture, default flat/opaque/transformed/boundary
medians were 0.419/0.732/0.728/0.792 times the original; nearest images retained a
1.035 ratio and Fallback labels 1.023. Observed ranges and IQR are descriptive.
Those historical timings and size/allocation observations are not retagged as
measurements of this newer paint-bank integration.

Both complete integrated parallel release policies pass 175 tests with four
existing ignored. Eighteen ordinary application/inspector/paint-binding tests
and strict accessible X11 all-target Clippy pass. The backend pixel oracle now
passes the current viewport to the command iterator. Its new bundled-font use
exposed an old lifecycle test's exclusive-registry assumption; a test-only guard
isolates those two fixtures while retaining the actual eight-thread cold parse
and release/remint/poison checks. Both failed integration controls are retained.
No global guard or test dispatch exists in the production library.
