# Compact logical and presented records

Capture: 2026-10-21, x86_64 Linux, Rust 1.97.1, default Cargo release profile.
Baseline source: a8bca6b504 (same Rust as be6e3e30c6). Candidate production
representation: cf74c40362. No unsafe code, fast-math, lossy coordinates,
diagnostic pixel omission or changed public identity is involved.

Internal ancestry uses a u32 index with u32::MAX as the root sentinel. Both
description admission and a compile-time domain assertion reserve the sentinel.
Public targets keep their namespace and never-reused identity. The temporary
list publication remap reuses this four-byte representation instead of a
16-byte Option<usize>.

An admitted affine matrix is finite and invertible. Its absent representation
uses a NaN coefficient; reading it reconstructs the ordinary Option<Affine>.
All valid coefficient bits, including signed zero, survive unchanged. This
does not change the Canvas transform or numerical sampling predicate. It changes
only retained P storage and its accessors. The NaN is an ordinary valid Rust
float, never a pointer or invalid enum discriminant.

| x86_64 record | Baseline | Candidate |
| --- | ---: | ---: |
| Logical Node | 232 B | 224 B |
| Presented | 104 B | 88 B |
| Parent/remap entry | 16 B | 4 B |
| Optional presented affine | 28 B | 24 B |

Luna independently inspected release assembly: logical strides change 0xe8→0xe0
and presented strides 0x68→0x58. The NaN check does use floating-point
classification rather than an integer enum tag; a smaller representation alone
does not establish faster queries.

[sheet-packing.csv](sheet-packing.csv) records six alternating paired fresh
processes per case, pinned to CPU 0. Every process first executes the existing
retained_list pixel oracle and semantic/draw-count assertions. Code and allocator
are warmed by that preflight; timed owners have fresh caches. These are requested
allocation ledgers and CPU preparation times, not RSS, startup or native frame
latency. Source IDs are separately charged by the fixture.

| Fixture | Retained requested bytes before→after | Peak before→after | Median mount µs before→after |
| --- | ---: | ---: | ---: |
| Virtual 250K IDs / 27 nodes | 59,995→59,347 | 302,413→301,441 | 391.664→399.449 |
| Eager 100 IDs / 101 nodes | 150,239→147,815 | 398,494→396,070 | 1,512.334→1,521.899 |
| Eager 10K IDs / 10,001 nodes | 13,425,399→13,185,375 | 14,681,790→14,441,766 | 133,711.276→133,778.873 |

Retained savings are exactly 24 bytes per logical+P node pair. List peak also
saves 12 bytes per remap entry. Allocation counts are unchanged. Virtual warm
scroll medians are 274.076→276.446 µs. The slight timing losses remain in the
record; this change is accepted for its bounded storage reduction, with no
speedup claim.

[sheet-access.csv](sheet-access.csv) uses eight alternating pairs on CPU 0 and
the public sheet_access_measure example. Visits read actual names, transforms
and bounds; counts use Role queries; hits traverse real acknowledged geometry.
All measured operations allocate zero and leave source/layout/paint counters
unchanged. At 10,001 nodes, median visit/count/hit ns per call are
13,402.995/7,339.915/49,993.950 before and
13,283.945/7,244.310/50,018.005 after. At 101 nodes they are
121.179/41.582/564.130 before and 121.695/41.505/571.513 after.
These overlap small timing variation and do not establish an access speedup.

The final sentinel/remap revision passes the complete gpui headless/doctest
suite (**169 cases/doctests**), strict all-target Clippy with X11+Wayland, and the actual X11 Todo
five-policy and 250K Library scripts. The latter retain the full server-pixel
oracle and input/lifecycle checks. Cross-platform integer/float representation
does not replace actual Windows/macOS/Wayland execution evidence.
