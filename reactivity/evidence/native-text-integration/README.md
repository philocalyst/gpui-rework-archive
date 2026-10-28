# Combined native text, layout and portable presentation

Library source `8ea8b9d76abb76717bd84fc28a5d471ce69f5ed3` combines the
Cephal nonparent containing-block records and hidden-marker refinement, portable
WGPU/HAL target admission, and source-qualified native text selection/editing.
`checks.json` records exact commands, actual test counts and log hashes.

- 43 core cases pass with `layout,cephal/verify-cache`.
- 489 GPUI cases/docs pass with accessible desktop, X11, Wayland, parallel
  Canvas and verified layout; 25 environment-gated cases remain ignored.
- Strict GPUI/core/GPU all-target Clippy and six-library formatting pass.
- Actual Apple AArch64 and Windows MSVC desktop/parallel all-target compilation
  passes through the real platform adapters using Rust build-std.
- Five native scripts pass: early GPU target rejection and close/drop while a
  worker retains a surface lease; the five-policy Todo pixel/input/resize script;
  late AT-SPI service/provider replacement and destruction; real registry text
  range editing, activation and actions; and presentation without a session bus.
- The standalone Hummingbird workspace passes nine native-feature tests and
  both executable paths: its SQL/public-owner headless transcript and actual
  X11/AT-SPI Library interaction transcript.

The native drivers guard library, vendor and executable hashes around each case,
run copies of the actual Cargo artifacts, own their Xvfb/private D-Bus settings,
and stop their displays. Complete source guards and raw logs are archived. The
Hummingbird executable was built at the same library source. Only its external
driver changed at `0b5f23f5c5`: after keyboard editing replaces the immutable text
lease, the driver must reacquire the provider object from the acknowledged tree.
The old source-qualified object is deliberately retired. The first driver's
failed request and its exact script remain under `controls/stale-text-driver`.
The corrected transcript asserts replacement, then performs Unicode editing and
Play ID44 through the current provider. Stable row action identity across SQL
resort is checked separately.

These counts overlap previous producer campaigns. Linux uses Xvfb and Mesa
26.1.4 llvmpipe; foreign checks compile without running AppKit, VoiceOver, UIA,
Windows or Wayland. This campaign does not establish hardware performance,
startup/RSS improvements, screen-reader coverage or complete GPUI/Hummingbird
parity. Accessible wrapped-run/character/caret geometry and magnifier support,
IME/clipboard and the remaining editor contracts are still required.

The actual shipping first-party library ledger at this freeze is **27,696**
non-test code lines: 27,683 under `src` plus 13 build-script lines. It excludes
comments, blanks, tests, vendors, tools and application ports. Original GPUI is
56,922 under the same build-inclusive rule. The feature sets are not yet equal;
this comparison is neither a final size prediction nor a parity claim.

Allocation, assembly and source-size controls for individual mechanisms retain
their own source pins in `../native-text-selection`, `../portable-presentation`,
`../cephal-oof-records`, `../cephal-oof-single` and `../cephal-hidden-marker`.
No measurements are retagged as timings for this combined source.
