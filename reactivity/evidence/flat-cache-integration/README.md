# Integrated cache, text and graphics checks

The direct Cephal cache handles are integrated over Parley 0.12/scoped paragraph
reuse, WGPU 30/build-time typed WGSL, SIMD, source-qualified editing and zbus 6
test tooling. Source `ff49d8482e` passes all 31 core cases with layout verification,
all 472 GPUI cases/docs (24 environment-gated cases ignored), and strict core
all-target Clippy. Raw logs and actual counts are in `checks.json`.

Source `56e1f5ddf1` adds only the independent Hummingbird workspace/evidence;
the tested UI libraries and vendors are unchanged. Actual combined native gates
pass the five-policy Todo/pointer/editor/resize/pixel script, late AT-SPI service
and provider replacement/destruction, registry activation/edit/invoke/reactivation,
and presentation without a session bus. The external driver guards source and
executable hashes around each case and stops its owned Xvfb. The AT-SPI helper's
new optional executable argument exercises the already built, hashed artifact
without silently rebuilding a different feature profile.

Actual Apple AArch64 and Windows MSVC desktop all-target compilation passes using
Rust's build-std. These compile checks do not execute AppKit, VoiceOver, UIA or
foreign platform rendering. Linux uses Xvfb and Mesa llvmpipe, not a hardware
display or a screen-reader/performance audit. The next native accessible text
selection codec and portable WGPU admission slice are not included.

Producer allocation evidence remains pinned to the earlier matched controls in
`../cephal-flat-cache`. This combined correctness run does not retag those
measurements or claim whole-window RSS/startup gains.
