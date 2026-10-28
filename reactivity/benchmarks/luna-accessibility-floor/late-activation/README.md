# AccessKit Unix late-activation probe

This standalone diagnostic pins the production integration dependencies in its own `Cargo.lock`: `accesskit 0.25.1`, `accesskit_unix 0.24.0` (`async-io`), and `zbus 5.19.0`. It uses an isolated `dbus-run-session` and a mock status service/AT-SPI socket. The original control/late modes test actual adapter callback activation/deactivation. The separate `prototype-*` modes construct only the owner/status monitor and check emitted status values. Neither creates a GPUI native Consumer tree, speaks to the system AT-SPI registry, or tests a screen reader.

Build and run from the cleanroom workspace root:

```sh
source /tmp/gpui-native-env.sh
CARGO_TARGET_DIR=/tmp/gpui-late-a11y-target cargo build \
  --manifest-path benchmarks/luna-accessibility-floor/late-activation/Cargo.toml \
  --locked --offline
for mode in prototype-control prototype-late prototype-late-true prototype-initial-true prototype-replacement; do
  dbus-run-session -- /tmp/gpui-late-a11y-target/debug/late-activation-probe "$mode"
done
```

The first prototype mode checks enabled-state transitions when the service exists at launch. `prototype-late` starts with a healthy session bus and no `org.a11y.Bus` owner for two seconds, then starts the service disabled. `prototype-late-true` does the same with the new service initially enabled. `prototype-initial-true` verifies a service already enabled before the monitor starts. `prototype-replacement` changes the well-known name directly to a second live unique owner; it also changes the former owner's property after replacement to check that stale old-owner state cannot cross into the new state.

The prototype state machine subscribes to `NameOwnerChanged` before querying `GetNameOwner`, binds each property watch to a unique owner, emits an absent-owner status at owner loss/replacement, and checks owner identity before forwarding queued property values. The recorded runs are in `../runs/session-bus-reconnect-prototype-20261021/`. It establishes candidate owner-monitor behavior for a future AccessKit Unix fix. It does not exercise adapter activation, session-bus reconnect, or native-tree delivery.

The earlier production-adapter reproduction is separate: `../runs/session-bus-late-activation-20261021/` records the existing behavior. The ordinary control succeeds; the healthy-session-bus/late-service case and the separately injected initial connection failure both miss activation. Do not treat the fake service as a real registry or infer that the production bridge has been fixed.

The pre-prototype regression probe's executable was preserved from Cargo's prior build output as `../runs/session-bus-late-activation-20261021/late-activation-probe-original` (SHA-256 `c7f74470a0f53c2823c9f54d47e31c9d3ae38d595f65919e0ba3919599283343`). It is a 100 MiB debug binary kept as a local untracked evidence artifact rather than added to the source commit. Its earlier source hashes are retained here: manifest `419d7b74ffda0b6db6751f202846bf0c9eaed00a88caee37ac7033ca1d8de281`, lockfile `6647da6ffee28598ab526f4bddae121f55e78f92b465b0796589570ca29b759d`, and `src/main.rs` `ee4670605ce6ef88d88a3f4bd47c4769f7c4dcd131aba1e39a9adde37c8c0740`. The source file was then extended in place for the reconnect prototype; the saved executable and original three output logs remain separate.

## Frozen probe artifacts

Prototype source/build artifacts used for the recorded runs:

| Artifact | SHA-256 |
| --- | --- |
| `Cargo.toml` | `36215e937a7f1e5689549ae53842c7c3049e5e4f2c68c3d92c4235a3f3e8dde1` |
| `Cargo.lock` | `6df1b26a6e24501e65b5e64b5d92ab7b5efec7b8a619999800eaa9d359b8369c` |
| `src/main.rs` | `7449be679091a5cb93bf912b2ab9fb5af781b069fa96b2b5ccad6dbf3f254490` |
| debug executable | `762c56ea0f02522420a1087ece07ffb374b9035a0fc24cf7a26936116db6df7b` |

The source and executable hashes above are the final versions used to generate all five prototype logs. Their SHA-256 values are `d65ede510717ca4a5cdab2b79b91a869dd9f87a3c1a92b504740f08f2246179d` (control), `4ebdbf60f48d7e3851ee35a0f30090686e6bc444552c03bd4aceaf5eb5b0f7f9` (late), `e56e027a3f6beb86747d1bbaf7a47221a36d4747df6cae6253b8bcb3c55d51ec` (late-true), `a6d8fa668bce9b08b392ebf927e530232fd2a8a8b0e1529174939b620e3c4cfc` (initial-true), and `4744671beaf52fff2bed301530696e30f87ef3bb3e397be90fb941156eef2a67` (replacement).

The earlier regression probe before the reconnect prototype is independently frozen by its run metadata/log hashes in `../runs/session-bus-late-activation-20261021/`.
