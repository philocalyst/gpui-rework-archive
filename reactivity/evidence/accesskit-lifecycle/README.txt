Production source base:859274504e. Vendor sourceVCS:ce8164ba92995cfa86005b6259115e08c8244253/adapters/unix.
Stage1 passes actual Unix Adapter/Consumer/private-D-Bus protocol; same fixture against registry upstream fails waiting for Embed after late initial-true service. Expected upstream cargo-test exit101.
Stage1 does not close the callback backlog replacement boundary and is not independently adoptable. SessionBus reconnect remains open.
Target=/root/gpui-a11y-target; CARGO_BUILD_JOBS=2; rustc1.97.1. No performance measurements.
To reproduce upstream control: create an empty temporary directory; copy upstream-control.Cargo.toml as Cargo.toml, copy vendor/accesskit_unix/tests/service_lifecycle.rs as tests/service_lifecycle.rs, copy vendor/accesskit_unix/Cargo.lock as Cargo.lock, and run cargo test --offline --test service_lifecycle -- --nocapture. Do not use a workspace patch in this control.
