# zbus 6 native AT-SPI harness migration

The Linux test harness now uses zbus 6.0.0 and zruntime 0.2.0. All connection,
fixture, discovery, timer, and UI-gate work runs inside one `zbus::block_on`
on the existing client thread. The bounded gates yield on that same runtime.
The real scenario deadline still bounds the client. Terminal success follows
explicit asynchronous close of the bus, both status providers, registry, and
session; client join also checks that both channel ends closed.

Only the GPUI Linux dev dependencies, lockfile, and two test modules changed.
Production AccessKit retains its required zbus 5.19.0. The normal dependency
tree excludes both zbus 6 and zruntime; the test tree includes them. No public
harness API or production accessibility/GPU source changed.

## Final validation

The final source-only commit and exact tested commit share one Git tree;
`source-pins.json` records both, all relevant source hashes, the exact built
lib-test artifact and executable hash, commands, toolchain, and crate hashes.

- Full GPUI x11 suite: **453 passed, 0 failed, 24 ignored**, across 44 test
  groups including doctests (`gpui-zbus6-final-suite.log.gz`).
- Strict GPUI x11 all-target Clippy: exit 0 with `-D warnings`. The existing
  vendored Parley deprecation warning is reported by Cargo as a dependency
  warning; GPUI passes the strict gate.
- Three separately launched actual native gates: all exit 0. They exercise
  real AT-SPI Unicode EditableText, focus and Add actions with the real
  registry; late initial-true service activation, replacement while the old
  unique owner remains connected, stale old-owner properties, full restored
  tree, and destruction; and presentation without a session bus.
- Targeted rustfmt checks and `git diff --check`: passed.

The runner owns a fresh Xvfb and private session/runtime directories, uses
fresh processes to isolate bus-global state, guards source and executable
hashes around every native gate, and stops its owned Xvfb. `native/` retains
commands, raw output, metadata, and identical before/after source guards.
`native-gates.py` is the exact external driver used. It has fixed workspace
and artifact paths; adjust them deliberately before reproducing elsewhere.
Source `native-env.sh`, set the isolated target and two Cargo jobs, run the
recorded build command, then run the driver with Python 3. The environment
snapshot's stale DISPLAY=:93 is overridden by the driver's owned display.

These are Linux x86_64 X11/Xvfb/private-D-Bus protocol gates. They make no
spoken-screen-reader, physical-display, hardware-GPU, performance, WGPU30,
Apple, or Windows claim.

## Preserved earlier checkpoints

`native/c97-initial/` is historical evidence for initial source b8a5c90fc5 on
c97ecc8909. Its strict Clippy failure is the inherited Canvas recursion lint;
that output is retained, not relabeled as a final pass. Rebase onto parent
8350157374 included its independent Canvas fix.

`native/835-pre-shutdown/` is historical evidence for a0415ae352 before the
terminal-shutdown acknowledgement correction. Those native and full-suite
passes do not substitute for the final bd37da00c2 captures above. The
source-only consolidation is tree-identical to final bd37da00c2.

An initial old-manifest `blocking-api` resolver incompatibility was reported
but its raw diagnostic was not preserved. No reconstructed historical failure
is claimed. Published zbus 6 source and the primary release document the
removed blocking API; the actual final migration gates supersede that blocker.

## Primary references

- [zbus 6.0.0 release](https://github.com/z-galaxy/zbus/releases/tag/zbus-6.0.0)
  documents removal of blocking support and the new runtime.
- [Published zbus 6.0.0](https://crates.io/crates/zbus/6.0.0) and
  [zruntime 0.2.0](https://crates.io/crates/zruntime/0.2.0) are pinned exactly;
  their downloaded package hashes are recorded in `source-pins.json`.
