# Hardware and software GPU oracle

Source `5aff5a1b30cd2518ecd69852fa586fbdeafcdbff` shares the existing scene and
pixel assertions across explicit Metal, DX12 and Vulkan test setup. Nine copied
adapter request sites become one helper. `gpu-tests` requires the native physical
backend; `vulkan-tests` retains explicit fallback Vulkan selection, including
when both features are requested. A CPU, virtual or unknown adapter fails the
hardware profile. This changes test/diagnostic setup; production renderer,
shader, dependencies and the **34,852** shipping-line inventory are unchanged.

The actual Apple M3 Pro Metal run passes **65 tests in two frozen Mach-O
executables**, with no ignored tests. It covers the same transformed/nested clips,
rounded shapes, gradients, HDR/P3 float output, image/text masks, retained packet
replay and queued color edits. Its compiler is the host Rust 1.99.0, recorded in
full; this run does not use or claim the later pinned-nightly native suite.
Both executables were moved before execution, hashed before/after and checked
against Cargo artifacts. All 2,061 source inputs match before/after the job.

Linux software Vulkan passes **69 tests / six executables**, then **71 / six**
with offline shaders; both strict all-target Clippy gates pass. The hardware
profile's unchanged format test fails on llvmpipe with the intended physical-GPU
assertion. That negative control cannot be reported as a hardware pass. The first
offline build failed because the harness omitted `GPUI_SPIRV_VAL`; the corrected
attempt passes without source changes. Both attempts remain in the log archive.
All eight recipes validate for Vulkan 1.0 and their exact bytes, plus the
18,995-byte generated WGSL, occur in the actual executed offline GPU unit ELF.

Windows/DX12 execution, hardware timing, native surface presentation, scanout and
the cross-framework matrix are not established here. A separate subsequent Mac
native suite reproducibly fails its first-poll and inbox allocation contracts:
each observes one allocation. The pinned standard library's Apple pthread mutex
uses `OnceBox`; investigation and a structural repair remain open. Those failures
are retained in [the targeted reruns](mac-native-negative-reruns.json), rather
than weakening the zero-allocation tests or attributing a native pass to the GPU
checks. Native release builds and the remaining tests run as a separate job.

[Qualification](qualification.json), [shader bytes audit](shader-audit.json),
[Linux logs](linux-logs.tar.gz), [Metal logs](metal-logs.tar.gz) and their
inventories retain exact commands, features, compiler identities, source hashes,
actual executable identities and rejected setup attempts. Large executable/source
archives stay at the paths and hashes in [external artifacts](external-artifacts.json).
The hardware source was transferred in offset-checked chunks and verified against
its complete archive hash and per-file manifest before building.
