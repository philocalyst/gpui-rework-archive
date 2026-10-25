# GPUI native solid presentation

Baseline: crates.io `softbuffer` 0.4.8, upstream commit
`d871852faa1137d4615b99b9ad31c3ba80f345b5`. The original cached crate archive has
SHA-256 `aac18da81ebbf05109ab275b157c22a653bb3c12cf884450179942f81bcbf6c3`.
The upstream source and both licenses are retained.

This patch adds `Surface::present_solid(0x00RRGGBB)`. Unsupported backends return
`Ok(false)` with unchanged presentation and buffer history. X11 uses its private
GC and a checked server-side rectangle fill; no client pixel array is needed.
The protocol integer follows the same visual/image-endian policy as upstream
image presentation. Invalid high-byte input is rejected before dispatch.

X11 resize records logical size; `buffer_mut` performs allocation after waiting
for any preceding SHM reader. Solid presentation invalidates buffer age and
releases preceding client storage. SHM is detached only after the server's read
barrier and checked detach; wire storage is dropped. The next ordinary buffer
therefore reports age zero and requires a complete repaint. An already-solid
surface does not allocate pixel storage during resize or solid presentation.
The upstream 4KiB transient SHM capability probe remains in context creation.

Success means the X server accepted the fill request, not monitor scanout.
Winit's pre-present notification and the exact GPUI owner-token acknowledgement
remain in the native consumer. Unsupported content/backends use the ordinary
buffer path. Other backends and their resource cleanup are separate patches.
