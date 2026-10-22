# Four-byte shared-stream baseline

Base: `619788822bf4f55818007ac596af0d607b4ebb3b`.
Correct candidate: `b048b83ba5` (resolve the full hash in candidate-source.txt).
This checkpoint precedes the optional eight-byte finite-diagonal control.

The base was tested with the exact tracked.patch and probe.patch archived here.
The candidate command was:

```sh
source /tmp/gpui-native-env.sh
CARGO_BUILD_JOBS=2 CARGO_TARGET_DIR=/tmp/gpui-presented-basis-target cargo test --manifest-path reactivity/Cargo.toml -p gpui --no-default-features --lib basis_ --offline --locked -- --nocapture --test-threads=1
```

Five candidate tests pass: three exact codec/ownership tests, the layout/owner
proposal probe and the ordinary-window allocation cohorts. This is a bounded
checkpoint, not full qualification. Production row size is actually 64 bytes
(previously 80), with Prepared40, Runtime<()>1824, Metadata264 and Geometry96.
Separate-pool types in the fixture are explicit modeled controls, not production
carriers. The code has no new retained owner header.

Allocation-counter values are requested Rust allocations, not allocator usable
size, native bytes, RSS, startup time or hardware performance. Each ordinary
recording window is acknowledged before retained bytes are read, with dependency
TLS scratch warmed consistently. No timings are interpreted. Compare matching
case/count rows between allocations.log (base) and
candidate-tests-and-allocations.log (candidate).

At 1025 rows plain retains 16,400 fewer bytes, inherited custom-root 15,976 fewer.
One custom-only row adds 408 bytes: a new Metadata264 + Geometry96 + initial
64-byte basis vector capacity, less the 16-byte row saving. 1024 custom siblings
or unique custom bases add 344 retained bytes and 11 allocation requests because
each non-inherited basis appends a 16-byte record without a sibling interner.
Their basis payload consumes almost all row savings. Rounded-only storage keeps
its existing header and exact 16-byte record stride. Dense growth and extra
query decoding have costs; no speed benefit is claimed.

The candidate executable hash and byte count identify the actual debug test
binary used. It is not a shipping binary or a native allocator measurement.
The test target path may be rebuilt for the next experiment; the source commit,
patches, toolchain and output remain immutable in this checkpoint.
