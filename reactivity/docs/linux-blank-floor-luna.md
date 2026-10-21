# Linux blank-window startup and memory floor

This is a bounded, read-only profile of the current release `empty` example on Xvfb. It identifies one plausible Winit startup experiment; it does not show a broad Linux optimization that is already proven, and Linux/Xvfb results do not predict macOS or Windows behavior.

## Result

On the current `:94` Xvfb instance (`-noreset`), a live release `empty --auto --startup` process reported its first CPU-present frame at 13.109 ms from the app's main timer. The sampled process had 10,900 KiB RSS, 8,584 KiB PSS (1,584 KiB anonymous, 6,062 KiB file-backed, 938 KiB shared-memory PSS), and one thread. Root's independent startup sample is about 15 ms spawn-to-present, with ~10.8 MB RSS and ~1.6 MB anonymous. These are different clock boundaries/samples, not a conflict. The root also measured that Xvfb `:93` with its default reset behavior added about 17 ms; that is an environment artifact, not an application improvement.

The 800x600 softbuffer/X11 surface uses a 2 MiB shared mapping (`/dev/shm/softbuffer-x11-…`, deleted after mapping). The process's PSS for it was 938 KiB because the server also maps it. This matches softbuffer's documented Linux XShm path: the buffer may map display-server-accessible shared memory and avoid a client-side present copy ([softbuffer 0.4.8 `Buffer`](https://docs.rs/softbuffer/0.4.8/softbuffer/struct.Buffer.html)). Do not report its whole 2 MiB as private application memory or count an additional full-frame copy without evidence.

The process had no mapped Vulkan loader or Mesa driver before first present, despite those libraries being in the launch environment. A traced run reached `GPUI_PRESENT` at 33.131 ms and only afterwards checked `/dev/dri`; it did not load Vulkan before the software first frame. This is a trace-perturbed diagnostic run, not a latency measurement. It supports keeping the existing CPU-first policy: GPU driver startup is already kept off the blank CPU-first path. It does not establish hardware-GPU startup cost, since this run is Xvfb and its eventual GPU candidate is llvmpipe.

Memory figures should be read as `smaps_rollup`, not a single RSS number. Linux documents that PSS divides shared resident pages among mapping processes, while RSS includes all resident pages; `smaps_rollup` aggregates the per-mapping details ([Linux kernel procfs documentation](https://www.kernel.org/doc/html/latest/filesystems/proc.html)). In this sample the app executable contributed ~3.2 MiB PSS; major other PSS contributors included libc (~844 KiB), libX11 (~770 KiB), libm (~588 KiB), libxkbcommon (~324 KiB), and the heap (~544 KiB anonymous). These are mapped/resident pages, not all reclaimable unique private bytes.

## Startup work and a narrow test

The pinned Winit 0.30.13 X11 implementation does substantial process-global initialization before the app can draw:

* `XConnection::new` opens Xlib, Xcursor, Xlib-XCB, and XInput2, calls `XOpenDisplay`, reads X resource-manager data, and queries RandR. See the pinned [Winit X11 connection source](https://docs.rs/crate/winit/0.30.13/source/src/platform_impl/linux/x11/xdisplay.rs) (also present locally at `reactivity/vendor/winit/src/platform_impl/linux/x11/xdisplay.rs`).
* `EventLoop::new` initializes DnD, saves/changes/checks `LC_CTYPE`, creates the X input method, selects RandR input, queries XInput2 and XKB, loads an XKB context, and reloads the modifier map. See the pinned [Winit X11 event loop source](https://docs.rs/crate/winit/0.30.13/source/src/platform_impl/linux/x11/mod.rs); the actual `Ime::new` calls `PotentialInputMethods::new` and `open_im` in [Winit's X11 IME source](https://docs.rs/crate/winit/0.30.13/source/src/platform_impl/linux/x11/ime/mod.rs).

The most defensible experiment is an **opt-in** X11 policy to defer XIM opening until a window first enables text input (`set_ime_allowed(true)`). An empty canvas has no text input on its first frame, and XIM opening and locale/Xlib checks are performed eagerly. This might avoid startup round trips and a locale-related cold mapping for apps whose first screen has no text field. It will not eliminate xkbcommon: Winit still needs keyboard layout/key translation and compose behavior. It must not become the default without tests for compose/dead keys, non-Latin IMEs and preedit/commit, multiple focused windows, IME destruction/recreation, and a window that enables IME immediately. Compare instrumented X-server round trips and fresh-process first-present distributions, not just number of system calls. This is a measured-work hypothesis; no latency saving is claimed yet.

Avoid disabling XInput/RandR/XKB wholesale: those are part of normal input and monitor-change behavior. Avoid trying to optimize by removing xkbcommon from the binary; it is resident but small in this profile, while key correctness would be at stake. The default-reset Xvfb comparison also shows why startup claims need fixed server state and matched process conditions.

## Repro commands and caveats

The profile used `/tmp/gpui-native-env.sh` with `DISPLAY=:94`, the existing release binary at `reactivity/target/release/examples/empty`, and a live process so `/proc/$pid/smaps_rollup` and `/proc/$pid/smaps` could be read after first present. The one diagnostic trace was equivalent to:

```sh
timeout 1s strace -ttt -T -o /tmp/empty-strace.log \
  -e trace=openat,mmap,munmap,connect,sendmsg,recvmsg,poll,ppoll,read,write,ioctl,statx,fstat,close \
  /root/gpui-ce3/reactivity/target/release/examples/empty --auto --startup
```

`strace` increased observed first-present time to 33.131 ms from an untraced ~13 ms sample, so trace timing is excluded from all performance conclusions. A single Xvfb machine/profile is also not a portable baseline. For the XIM experiment, benchmark fresh processes on at least Xvfb/Xorg with and without an active IME, compare the same event-loop policy at p50/p95 and verify keyboard/IME input; collect RSS, PSS, private dirty, and file mappings separately.

## Ranked next steps

1. Keep CPU-first present before GPU initialization; this currently avoids Vulkan/Mesa startup on the blank first frame. Measure on actual devices/platforms before extrapolating beyond Linux/Xvfb.
2. Prototype opt-in lazy XIM initialization behind an app/window text-input policy. Accept only if startup improves materially in fresh processes without changing text input behavior.
3. Do not spend time on broad library pruning from this profile. The largest stable resident items are executable and standard/X11 libraries; removing them means changing platform/input functionality or build/runtime assumptions, with no demonstrated first-frame win.

## Primary evidence links

* [Linux kernel `/proc` documentation: `smaps`, RSS, PSS, and `smaps_rollup`](https://www.kernel.org/doc/html/latest/filesystems/proc.html)
* [Winit 0.30.13 pinned X11 connection source](https://docs.rs/crate/winit/0.30.13/source/src/platform_impl/linux/x11/xdisplay.rs)
* [Winit 0.30.13 pinned X11 event loop source](https://docs.rs/crate/winit/0.30.13/source/src/platform_impl/linux/x11/mod.rs)
* [Winit 0.30.13 pinned X11 IME source](https://docs.rs/crate/winit/0.30.13/source/src/platform_impl/linux/x11/ime/mod.rs)
* [softbuffer 0.4.8 CPU buffer and platform behavior](https://docs.rs/softbuffer/0.4.8/softbuffer/struct.Buffer.html)
