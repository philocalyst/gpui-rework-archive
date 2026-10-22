# Native and public pointer protocol

[checks.json](checks.json) pins isolated source `c6db932473`, integrated as
`3bbacbe3b1`, and preserves eight successful gates. Nine new public pointer cases
plus existing focus and presentation suites pass 27 cases. Accessible native
units pass 115, strict accessible X11/Wayland all-target Clippy passes, and the
actual five-policy Todo and ordinary-scroll X11 scripts pass. Apple aarch64 and
Windows MSVC desktop all-target Clippy pass as cross-compilation checks.

The native host now calls the public `Win::pointer_event` reducer. The caller
owns one 32-byte `PointerSession`; no runtime/node/presented field or allocation
is added. NativeHost remains 688 bytes with the same X11+Wayland test features.
The input-focus oracle runs 1,000 move/press/release cycles with zero allocations
or source/layout/paint work. Activating arbitrary callbacks can perform those
operations; this is not a universal click-cost claim.

Release requires a fresh hit on current acknowledged geometry and the exact
same window-qualified target. A rejected stale release consumes its press before
returning; acknowledgement cannot resurrect it. A newer acknowledged sheet can
activate the same surviving target after a fresh re-hit. Leave/wheel/cancel
consume a gesture. Native move/resize/focus-loss/suspend reset the session and
wait for another physical cursor sample. This floor does not implement capture,
multiple devices, touch, drag or hover callbacks.

The real Todo script additionally checks window movement, resize and focus loss:
after native re-presentation, an old release and a new press/release without a
fresh cursor sample cannot edit sources. A new sample restores normal clicking.
Its first added fixture incorrectly assumed equal-size native resize retained
coordinate authority; the actual host correctly called `presentation_lost`.
The failed log is retained. The corrected fixture executes real native redraw
before testing input, rather than manually acknowledging a token.

Execution uses Xvfb and llvmpipe. These results establish protocol and server
pixel behavior, not Wayland/Windows/macOS execution, hardware latency or RSS.
