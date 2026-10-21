# Linux AccessKit worker-floor probe

This is an isolated process-level probe, not a GPUI benchmark. It constructs
six `accesskit_unix::Adapter`s and observes task count plus `/proc` RSS/PSS
while a synthetic session-bus owner advertises
`org.a11y.Status.IsEnabled=false`. Six adapters are intentional: the result
tests whether the worker count scales with windows. The synthetic service has
no AT-SPI bus and no assistive technology, so the probe measures the inactive
monitoring floor only.

The manifests and `Cargo.lock` pin `accesskit 0.25.1`,
`accesskit_unix 0.24.0`, `zbus 5.19.0`, and `tokio 1.54.0`. The async-io
baseline enables AccessKit Unix's `async-io` feature. The candidate enables
its `tokio` feature and explicitly feature-unifies zbus with both `async-io`
and `tokio`; AccessKit Unix 0.24.0 does not forward `zbus/tokio`. Both
executables use the same six adapters, property service, sampling cadence,
and debug profile. This deliberately isolates backend worker behavior, not
release-build application startup or runtime memory.

Reproduce after building either manifest with the same `CARGO_TARGET_DIR`:

```sh
dbus-run-session -- ./run.sh ./async-io /tmp/a11y-floor-target
dbus-run-session -- ./run.sh ./tokio /tmp/a11y-floor-target
```

The script expects `debug/status-server` and `debug/<package-name>` in the
provided target directory. Capture outputs are in `runs/`. Toolchain used was
Rust/Cargo 1.97.1, x86_64 Linux. The captures were separate processes and
separate builds, so the RSS/PSS differences are not attributable to backend
choice. No claim is made about a production memory win.

## Six-adapter observations

| Backend | Baseline tasks | Stable tasks | Stable names | Baseline RSS/PSS KiB | Stable RSS/PSS KiB |
| --- | ---: | ---: | --- | ---: | ---: |
| AccessKit Unix async-io | 1 | 4 | main, AccessKit worker, `blocking-1`, `async-io` | 5096 / 3710 | 11164 / 9778 |
| AccessKit Unix Tokio | 1 | 3 | main, AccessKit worker, `tokio-rt-worker` | 4768 / 3400 | 10608 / 9240 |

The count did not increase from the earlier single-adapter probe. Source
inspection confirms the AccessKit Unix channel, executor, session-bus monitor
and adapter registry are process-global; each window registers an adapter in
that process context. The Tokio candidate removes one helper thread here, but
still uses the AccessKit worker and a Tokio blocking worker. Its feature
unification and runtime footprint need a paired production release capture
before any adoption decision.

## Source pins

- [AccessKit Unix 0.24.0 context](https://docs.rs/crate/accesskit_unix/0.24.0/source/src/context.rs) owns the process-global message sender and worker startup.
- [AccessKit Unix 0.24.0 executor](https://docs.rs/crate/accesskit_unix/0.24.0/source/src/executor.rs) drives futures on the worker.
- [AccessKit Unix 0.24.0 adapter](https://docs.rs/crate/accesskit_unix/0.24.0/source/src/adapter.rs) registers windows and documents callbacks arriving from another thread.
- [AccessKit Winit 0.34.1 Unix adapter](https://docs.rs/crate/accesskit_winit/0.34.1/source/src/platform_impl/unix.rs) ties Winit windows into the process backend.
- [zbus 5.19.0 property stream](https://docs.rs/crate/zbus/5.19.0/source/src/proxy/property_stream.rs) emits the cached initial property value before subsequent changes; start-enabled is not lost as an initial-change race.
- [Winit 0.30.13 event-loop fd](https://docs.rs/winit/0.30.13/winit/event_loop/struct.EventLoop.html) and [pump-events API](https://docs.rs/winit/0.30.13/winit/platform/pump_events/trait.EventLoopExtPumpEvents.html) expose an outer-poller route, but GPUI currently calls `run_app`; the pump path is a larger, caveated event-loop change. AccessKit's bus connection/executor internals are private, so registering only Winit's fd cannot fold the AccessKit worker into the owner loop.

Dynamic monitoring remains required for assistive technology enabled after
window creation. The AT-SPI bus launcher is activated through the session bus;
when enabled, AccessKit creates the separate accessibility-bus connection.
The inactive process still pays for the monitor and the fixed worker path.
The probe does not establish production attribution for a host-level thread
count change, nor compare per-app startup/idle memory.
