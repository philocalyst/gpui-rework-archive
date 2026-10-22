# Modern text and graphics integration

Combines reviewed Parley/Engine/Fontique0.12, scoped paragraph reuse, current
utility dependencies and the zbus6 test harness with WGPU30/SIMD, source-qualified
editing, Cephal cold-layout and build-time typed WGSL. GPU dev Pollster also uses
1.0.1, eliminating its old0.4 direct pin. SIMD propagation, source glyph clusters,
long graphemes and original frozen field identity stay intact.

`checks.json` records exact source hashes (null means deleted), raw log hashes
and actual group/test counts: GPUI472passed/24ignored; Canvas177passed/4ignored;
GPU49passed. GPUI enables Cephal recomputation/poison verification; Canvas runs
all features; GPU tests exercise real Mesa llvmpipe Vulkan pixels. Strict GPUI
all-target Clippy passes. Native/cross-platform execution and the next cache
representation are separate gates. Producer allocation, timing and linked-size
evidence remains pinned to its original controls.
