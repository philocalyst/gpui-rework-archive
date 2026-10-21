# Native startup and memory evidence

Measured on Linux/NixOS, Xvfb 21.1.24, release builds, warm filesystem caches.
Each row is 15 fresh processes using `tools/native_startup.py --renderer auto`.
The endpoint is successful native present plus runtime acknowledgement, observed
through the child stderr marker. It is not monitor scanout. Builds are excluded.

| Implementation / display | Blank median | Todo median | Gallery median | Gallery maximum |
| --- | ---: | ---: | ---: | ---: |
| Fontdue, Xvfb default reset | 31.575 ms | 65.079 ms | 80.038 ms | 83.212 ms |
| Lazy Swash, same display | 31.568 ms | 40.792 ms | 56.845 ms | 57.935 ms |
| Scoped shaping, same display | 32.144 ms | 34.725 ms | 40.525 ms | 47.983 ms |
| Scoped shaping, Xvfb `-noreset` | 15.022 ms | 17.633 ms | 23.302 ms | 23.515 ms |

The final row changes the environment: default Xvfb resets when its last client
disconnects. Disabling that reset removes about 17 ms between fresh processes;
it is not another library optimization. All four raw datasets are adjacent
`evidence-startup-*.csv` files. The first two use the original selector reader;
the later runs use a portable reader thread, timestamped before queue delivery.
The Linux first-present tests, including actual software pixels, separately pass.
These results do not establish Windows/macOS latency or cold-disk performance.

`examples/first_frame.rs` measures ordinary public `Win::recording` preparation
and `Win::render_bgrx` separately. Before scoped shaping, warm fresh-owner Todo
preparation was about 7 ms and gallery preparation about 18 ms. Afterwards they
are about 1.25 ms and 3.2 ms. Software rendering remains about 1.75 ms and 5.65 ms
at 540×620 and 560×440. These component timings exclude native window setup.

Rustybuzz constructs GSUB/GPOS lookup vectors on every `Face::from_slice`.
`FontFace::shaper()` now borrows one lazy parser for an entire preparation pass,
including every Cephal measurement, wrapped line and final paint layout. A pass
that reuses all layouts never initializes the parser. The runtime takes one face
lease per pass so the raster cache can mutate independently. No string or glyph
increments that lease. Tables are released at pass end; no self reference,
unsafe code, platform hook or permanent 235 KB table cache is required.

Requested allocations are checked by `tests/shaping.rs`: an unused session
allocates nothing, eight batched strings use less than one quarter of the
allocation bytes and count of eight separate sessions, and session disposal
retains no table allocation. Existing wrapping, shaping, DPI and paint tests
continue to cover behavior.

After lazy Swash, default Auto on this machine finds no local render device and
never initializes Wgpu. At one/three/five seconds, blank RSS is 10,824 KiB,
PSS 8,716 KiB, anonymous 1,588 KiB; Todo RSS is 12,592 KiB, PSS 10,764 KiB,
anonymous 1,828 KiB. Both use one thread and have unchanged CPU ticks across
samples. These precede the scoped-parser change. Before lazy fonts the CPU Todo
had about 22 MiB PSS and 14 MiB anonymous memory. Forcing llvmpipe Vulkan had
about 111 MiB blank PSS and 37 threads. Driver allocation, mapped file pages,
shared pages and GPUI-owned scene storage are distinct costs; logical resource
bytes are never presented as process RSS. See the adjacent memory CSV files.

The portable parser and software-output paths apply across native platforms.
Native surface transitions have additional OS contracts. Windows Auto currently
stays software because DXGI flip-model presentation permanently prevents GDI
drawing to the same HWND, even after swapchain destruction. Explicit `Gpu`
still selects DX12. A child presentation HWND or a permanent DXGI presenter
needs Windows lifecycle tests before enabling opportunistic promotion there.
Microsoft documents this in
[DXGI_SWAP_EFFECT](https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ne-dxgi-dxgi_swap_effect).
macOS layer ownership and software/GPU coexistence are under separate review.
The cleanroom CI matrix builds native ports and checks real software/Auto first
presentation on Linux, macOS and Windows; adding a workflow is not evidence
that those remote runners have already passed.
