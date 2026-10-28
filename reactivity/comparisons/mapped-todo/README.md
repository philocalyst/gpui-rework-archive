This is the frozen mapped-state Todo experiment on core
`0062bf589829c4f28807ad0fde3e13285379294c`, followed by a separate Main import.
Read the [capture report](capture-2026-10-24/report.md) for results and exclusions.
The report's “unadopted API experiment” describes its capture-time status. Main
subsequently adopted the reviewed successor at `c0b7dfb0dd11404e31bcc3dcda6df400a882ac66`;
these measurements are not attributed to that newer implementation.

The mapped fixture eliminates repeated owner/row descriptions in its animation
route and passes all three Auto animation work gates. It demonstrates no CPU
saving. Only one Auto animation control pair qualifies, forced-GPU animation
fails preflight, and strict Heavy deadlines fail. Rejected samples remain in the
raw evidence. Hardware GPU time and physical scanout are unmeasured on llvmpipe.

Main includes `todo_comparison_mapped` alongside the ordinary comparison example
for continued API exercise. Its runtime metadata identifies the historical
fixture origin separately; its build pin is null unless supplied through
`GPUI_BENCH_SOURCE` at compilation. It never reports the old pin as current.
Example registration and Python formatting do not alter the sealed source/ELF
capsule. Both archives were independently reread:
all payload bytes, member sets, link types and executable modes match their
receipts. The source/ELF archive contains three executable ELF targets and an
incidental historical Wayland IME shared object; its full manifest is authoritative.

Main's formatted analyzer reproduces `summary.json` and `resources.md` byte for
byte. The 20-test offline benchmark suite runs with the mandatory historical
33-row archive enabled, preserving its six known failing cells. See
[integration-review/result.json](integration-review/result.json) for the independent
audit and Main reproduction identity. This is source/evidence qualification,
not a rerun or a performance claim for Main.
