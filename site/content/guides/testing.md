+++
aliases = ["guide/system/testing/", "system/testing.html"]
title = "Test the layer that can fail"
description = "Separate state, deterministic rendering, GPU replay, and native behavior."
weight = 90
+++

Start with a state test for the rule you changed. Add a rendering scenario when
the result depends on layout, paint, or input dispatch. Use a native or GPU check
when the behavior crosses that boundary.

## Run deterministic scenarios

The testing branch supplies a controlled app, viewport, and named checkpoints.
The CPU renderer can produce a PNG and a scene capture without opening a native
window. From the repository root:

```sh
scripts/gpui-test list
scripts/gpui-test run --output target/visual-report
scripts/gpui-test run --output target/visual-report --baseline target/visual-baseline
```

Inspect the report's selected scenarios and checkpoint labels. A test that did
not select a scenario is not evidence that the scenario passed. A changed
snapshot is a request to inspect a change, not an instruction to accept it.

## Capture an example

The larger repository examples share their view construction with capture
scenarios. Use the example launcher to select a target, then its capture mode:

```sh
scripts/gpui-example list
scripts/gpui-example run hello_world --capture --output target/hello-report
```

The ten small documentation walkthroughs are a separate compiled source suite.
Their browser tests exercise the actual WASM renderer, and their downloads are
checked as Cargo projects. Do not treat their preview as a native capture.

## Cross the renderer and platform boundaries

```sh
scripts/gpui-test bench --output target/renderer-report --gpu
scripts/gpui-test platform --output target/platform-report
```

GPU checks need a supported device. Native window checks need the platform
services and session they exercise. A CPU scene match cannot prove decoration,
clipboard, IME, GPU-driver, or browser permission behavior.

The report distinguishes scene-building time, render time, platform captures,
and checkpoints. Compare equivalent workloads before interpreting timings.
See the [test crate](https://docs.rs/gpui_ce_test/latest/gpui_test/) and the
repository's `docs/testing.md` for scenario and report contracts.
