# Released text dependencies and scoped allocation investigation

Parley, Parley Engine and Fontique are upgraded to released 0.12.0, with the
existing source-byte, default-font-instance, long-cluster and cursor-affinity
repairs preserved. Skrifa is 0.49.0. Utility direct dependencies become Pollster
1.0.1, Triomphe 0.1.17 and X11rb 0.14.0; compatible Memmap2 and Tokio lock entries
become 0.9.12 and 1.54.1. This evidence isolates these changes on `dc577564e5`.
It predates the separate GPU30, SIMD, editor and zbus6 integrations and does not
describe their final combined binary.

The initial upgrade increased transient paragraph allocations. A separate,
measured change reuses one Parley `Layout` through `build_into` in the existing
scoped `Planner`. It reduces repeated-label allocations below the old version,
with a modest cold single-label/peak cost. This is not a timing comparison or a
claim that all memory measures are unchanged.

## Source and measurement boundaries

The three immutable source snapshots are:

| Snapshot | Source | Purpose |
| --- | --- | --- |
| Before | `dc577564e5` | Patched Parley 0.11.1 baseline |
| Upgrade control | `b39a6b79c0` | Latest text/utility dependencies, fresh layout each paragraph |
| Scoped reuse | `697c66c773` | One reusable paragraph layout in the existing planner |

[provenance.json](provenance.json) records full commits, clean tracked-source
status, Cargo locks, identical driver-source hashes, immutable release-binary
hashes, compiler/build settings and Valgrind identity. The drivers are the
existing `text_shaping`, `font_memory` and `unicode_text_measure` examples; no
private substitute owner was introduced. Every allocation field matches across
three fresh-process repeats. The repeated baseline rows also match exactly
between the two paired captures.

[matched-allocations.json](matched-allocations.json) preserves the losing upgrade
control. [matched-allocations-reused-layout.json](matched-allocations-reused-layout.json)
records the final scoped change. `capture-allocations.py` discards nanosecond
columns before saving. The service driver's optional old Fontdue timing/control
is not included. [matched-pixel-hashes.json](matched-pixel-hashes.json) records
identical rendered BGRX bytes across all three pins for 1,000 plain/Unicode
labels and the ordinary owner's initial/edited scenes.

The allocation counter reports requested thread-local heap, not allocator usable
size or RSS. `text_shaping` cold scope includes a parser that is dropped before
the row is reported; its preallocated result-vector table and admitted primary
face are outside that scope. Warm scope begins after priming a live parser, so
its retained delta measures growth, not the parser's absolute scratch footprint.
Owner mount/edit scopes include their temporary planning passes. Output buffers
allocated outside a measured closure are not silently included in that closure.

## Allocation results

Each cell below is **total requested bytes / allocation count**.

| Existing fixture/stage | 0.11 baseline | 0.12 fresh-layout control | 0.12 scoped reuse |
| --- | ---: | ---: | ---: |
| Plain label 1, cold | 109,728 / 201 | 110,418 / 208 | 110,794 / 208 |
| Plain label 1, warm | 2,144 / 9 | 2,882 / 15 | 194 / 4 |
| Plain labels 1,000, cold | 2,800,724 / 10,945 | 3,291,408 / 15,947 | 386,460 / 4,961 |
| Plain labels 1,000, warm | 2,693,140 / 10,753 | 3,183,872 / 15,754 | 275,860 / 4,757 |
| Unicode label 1, cold | 307,160 / 430 | 308,122 / 434 | 308,498 / 434 |
| Unicode label 1, warm | 4,176 / 16 | 5,882 / 19 | 802 / 8 |
| Unicode labels 1,000, cold | 5,725,612 / 20,609 | 7,315,999 / 30,271 | 1,144,795 / 10,628 |
| Unicode labels 1,000, warm | 5,422,628 / 20,195 | 7,013,759 / 29,856 | 837,099 / 10,202 |
| Owner label 1, mount | 131,730 / 302 | 132,420 / 309 | 132,796 / 309 |
| Owner labels 1,000, mount | 5,904,284 / 14,707 | 6,394,968 / 19,709 | 3,490,020 / 8,723 |
| Owner labels 1,000, edit | 4,841,298 / 15,042 | 5,159,732 / 19,544 | 2,203,720 / 8,558 |

Cold retained output bytes are equal across all pins: 168/744 for one
plain/Unicode label, 184,040/571,008 for 1,000, and 1,697,564 for the 1,000-label
owner after mount (138,867 delta on edit). Blank recording Canvas allocates zero
within its measured fixture scope. The textless owner mount is unchanged at
5,436 retained bytes, 6,664 requested bytes and 33 allocations; it performs zero
text measurements. One/eight text-service initialization, retained shape/render
and cache-release fields are identical, including the render digest. That
service driver does not report all transient shape allocations; the separate
shaping rows above do.

The tradeoff is explicit. Compared with the old version, scoped reuse raises the
plain/Unicode 1,000-label cold peak by 1,160/3,131 bytes, and owner mount peak by
3,464 bytes. A single-label owner's cold mount requests 1,066 additional bytes
and seven allocations, peaks 3,048 bytes higher and retains the same 16,302
bytes after the pass. Its edit requests 656 additional bytes/six allocations and
peaks 2,641 bytes higher, retaining the same 708-byte delta. Warm retained-growth
deltas rise by 416/963 bytes for 1,000 plain/Unicode labels; these are not absolute
scratch-size measurements. All prepare/render allocation rows and pixel hashes
remain equal for matched inputs.

## Actual allocation stacks and lifetimes

Valgrind 3.27.1 DHAT profiles are preserved under `dhat/`, with full tool logs.
They execute the identical ordinary 1,000-label owner driver (mount, render,
edit) and are allocation-stack diagnostics. Release frames have symbols, with
inlining; they do not provide DWARF source-line attribution. The source methods
below identify buffers directly, rather than guessing their identity from size.
[dhat-summary.json](dhat-summary.json) groups their actual first text-stack frames;
`summarize-dhat.py` reproduces that grouping without timing fields.

| Whole process | Requested bytes | Allocation blocks | Peak live bytes | End live bytes |
| --- | ---: | ---: | ---: | ---: |
| 0.11 baseline | 12,197,358 | 32,777 | 3,446,152 | 608 |
| 0.12 fresh-layout control | 13,006,476 | 42,281 | 3,446,152 | 608 |
| 0.12 scoped reuse | 7,145,516 | 20,309 | 3,446,152 | 608 |

| Actual stack/buffer group | Fresh-layout bytes / blocks | Reused bytes / blocks |
| --- | ---: | ---: |
| Engine `Shaper::shape_text` (`ShapedText::reserve` character/cluster/glyph vectors) | 1,326,000 / 6,000 | 3,744 / 12 |
| Engine `ShapedRun` vector growth | 1,152,000 / 2,000 | 1,152 / 2 |
| Engine `FontInstance` vector growth | 512,000 / 2,000 | 512 / 2 |
| Parley `RunData` vector growth | 640,000 / 2,000 | 640 / 2 |
| Parley style-metrics resolution | 288,000 / 2,000 | 288 / 2 |
| Parley `LineItemData` vector growth | 320,000 / 2,000 | 320 / 2 |

Residual per-paragraph allocations remain: the style-feature table accounts for
112,000 bytes/2,000 blocks, line-box style-index storage 16,000/2,000, and
breaker-state cloning 4,000/2,000 in this complete owner run. These are disclosed,
not hidden behind the stable `TextLayout` header size. This bounded change does
not add persistent scratch owners for each one.

`TextShaper` owns the existing optional boxed planner; returned Canvas layouts
own glyphs, optional interaction details and immutable font leases. Runtime
creates its shaper as a local variable for its layout/measurement pass. Parley's
`build_into` calls `LayoutData::clear`, which delegates to Engine's
`ShapedText::clear`; each retains vector capacities for the next paragraph. No
Parley layout is added to Runtime, Node, TextSite, TextSystem or a window. The
single scratch layout is dropped with the shaper. Every planner shape error
replaces scratch with a default layout, releasing a rejected/partially lowered
layout's capacities; successful source/output remain limited by the existing
32 KiB source and 32,768-glyph admission guards. This does not claim to remove
all preexisting temporary upstream/context allocations on hostile-font errors.

Validation: 171 Canvas tests passed across 39 all-target/all-feature targets;
four existing expensive/timing tests remain ignored. The unchanged eight
selection plus 14 Unicode tests pass in release. Strict Canvas Clippy across
all targets/features passes. Recovery regression covers a prior interactive
layout, output-limit rejection, then fresh-equivalent glyphs, size and carets
including an empty paragraph. The engine's long-cluster private regression
passed on the migration source. Original failed line-top/default-instance/source
controls and the incompatible HarfRust 0.14 trial are preserved under `controls/`.

## Registry audit and constraints

[registry-latest-2026-10-22.json](registry-latest-2026-10-22.json) freezes primary
crates.io selections, checksums and declared MSRVs. The reproducible helper is
`tools/audit_dependencies.py` with three offline fixtures. It compares all
workspace normal/build dependency edges, including target-specific dependencies,
against non-yanked stable SemVer maxima, and separately compares the already
prerelease-only family. Dev-only edges are excluded from that production graph;
other tracked lock scopes and hashes are explicitly disclosed. Cargo feature
unification is the `--all-features` metadata view, not proof that every target
configuration ran.

[resolved-text-utilities-697c66c773.json](resolved-text-utilities-697c66c773.json)
records this historical stage's actual resolution: 400 active packages, 379
registry package versions, 274 latest stable, 101 constrained older stable, two
latest prerelease-only and two older prerelease-only. It lists every requiring
parent, version constraint and target condition, plus all eight local vendor
versions and their latest primary releases. GPU29/WGSL beta1 in this snapshot
are intentionally visible; separate integrations must regenerate the final
main audit rather than retag this file. Both new SIMD crates are checked in the
frozen cache at latest stable 1.1.0/0.1.0, even though this isolated graph predates
their integration.

Important remaining constraints:

- Released Engine 0.12 requires HarfRust 0.12. The latest 0.14 removes five
  shaping APIs; the real incompatible build has 15 compile errors. Updating
  requires a separate engine rewrite, not merely a manifest pin.
- Latest Swash 0.2.10 caps Skrifa at 0.44. Fontique/HarfRust 0.12 require
  read-fonts 0.41; direct/new engine Skrifa 0.49 uses 0.46. These actual duplicate
  families are visible in the audit.
- Latest stable Winit 0.30.13 and Softbuffer 0.4.8 still require X11rb 0.13;
  their released Apple/Windows/Wayland dependencies similarly constrain older
  majors. Our direct test dependency can be 0.14 without rewriting those APIs.
- Latest AccessKit Unix/AT-SPI packages still require production Zbus 5.19.
  Test harness Zbus6 is a separate migration; it does not replace those upstream
  production requirements.
- WGSL-RS has an existing beta-only release family. Beta6 aligns Naga30 for the
  separate GPU30 integration; no new prerelease family is selected here.

Declared direct MSRVs in primary evidence: Parley/Engine/Fontique 1.88, Skrifa
1.85, Pollster 1.69, Triomphe 1.85, X11rb 1.68. Separate already chosen Cephal
requires 1.90 and SIMD 1.89. The actual toolchain is recorded in provenance;
this slice does not lower the workspace's effective toolchain requirement.
Vendored Winit edge/IME patches and GPU platform/layer patches are preserved;
their final combined native/platform gates belong to the integrating main.

Reproduction from a pinned `reactivity/` directory:

```sh
cargo test --offline --locked -p gpui_canvas --all-targets --all-features --jobs 2
cargo test --offline --locked --release -p gpui_canvas --test selection --test unicode --jobs 2
cargo clippy --offline --locked -p gpui_canvas --all-targets --all-features --jobs 2 -- -D warnings
python3 vendor/parley_engine/check-clusters.py
python3 -m unittest discover -s tools -p test_dependency_audit.py
python3 tools/audit_dependencies.py --cache evidence/dependency-modernization/registry-latest-2026-10-22.json --output /tmp/current-dependencies.json
```

Rebuild the three existing release examples at each source pin, copy them before
reusing a target directory, then run the capture/profile commands in provenance.
The source, final evidence and final combined main have distinct commits.
