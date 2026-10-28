# Rounded geometry evidence

Final source: `ea981a44e4`, based on `dcdadf4d52`. The discarded radius-table
prototype remains `90ac1f3291` on `codex/rounded-table-prototype`. There are no
performance captures or speed claims. Logs include successful gates and the
failures corrected during development.

`manifest.json` pins every changed production/test source, manifests/lock,
executed test artifacts, the optimized consumer artifact, and copied logs.
Tests ran on x86-64 Linux with Rust 1.97.1, LLVM 22.1.6. Actual Vulkan tests used
Mesa llvmpipe (LLVM 21.1.8), not hardware-performance evidence. Native execution
used Xvfb display 94 and the same Vulkan software adapter; test-only Auto
permission exercises the real GPU-to-softbuffer transition.

Final results:

- Canvas with `parallel`: 123 passing tests/docs, 4 ignored measurements.
- GPUI default: 291 passing tests/docs, 7 ignored measurements/native fixtures.
- GPU: 7 units and 33 actual Vulkan cases, all passing.
- Strict all-target Clippy: GPUI X11+Wayland, Canvas parallel and GPU Vulkan.
- Actual native five-policy Todo fixture: pass, including full X11 fetched-pixel
  comparison after a positive subnormal radius causes Auto GPU-to-CPU fallback.
- Private allocation and header ledgers pass, including sparse list admission
  filtering and geometry reclamation.

## Costs

See `storage.csv`, `allocations.csv`, and their raw ledger logs. Values apply to
this exact pre-Flex/pre-Scroll source baseline, not an inferred merged layout.
Style 88 B, El 176 B, Node 40 B, Presented 80 B and Runtime<()> 2,384 B are
unchanged. Annotations stays 48 B, ElementExtra 56 B and ImageSpec 16 B.
Metadata grows 240 to 248 B only for existing cold metadata owners; an opted-in
Geometry box is 96 B. Its current, P and optional candidate columns use 16 B
entries, separately owned. Retained inspector maps have ordinary BTreeMap
allocation costs and are not included in that entry number. No rounded owner
gets a per-node box, mask, radius resource or reference-counted geometry lease.
A fresh description rebuild can temporarily coexist with prior current state;
these figures are headers/entries, not a whole-process peak-memory claim.

Absent descriptions allocate nothing; rounded-only costs 56 B; rounded+name
costs 104 B in two allocations in either builder order. Images already own a
cold extension, and radius fits its existing padding. The final image resource
header remains 80 B. Adding a rounded placement of an already-present image to
reserved command lanes allocates zero bytes and shares the same pixels across
radii. This is conditional on available command capacity, not a claim that every
new placement can never grow a Vec.

The prototype table grew ImageResources 80 to 88 B and required a 24 B table
header plus a first 32 B allocation (56 B in two allocations). It is retained as
a losing structural comparison. BorrowedSource was already 16 B in that
prototype; the final representation does **not** claim an enum-size reduction.
GPU packet strides remain 96/80/32 B plus 32 B corrections in both variants.

Typed handles stay 8 B. Static Declaration grows 48 to 56 B due to exact
comparison. This baseline has nine old declarations plus one new radius:
9 × 48 = 432 B becomes 10 × 56 = 560 B, a 128 B rodata increase, plus one catalog
pointer. No per-node field pays that cost. Parent Flex IDs 10–12 need ordinary
ExactValue implementations during integration; radius owns ID 13.

## Optimized ordinary caller

`consumer.rs` uses ordinary Win property/get/set APIs in separate no-inline
callers. It was temporarily copied to
`crates/gpui/examples/rounded_property_codegen.rs`, built with:

```
CARGO_TARGET_DIR=/tmp/gpui-rounded-target cargo rustc \
  --manifest-path reactivity/Cargo.toml -p gpui \
  --example rounded_property_codegen -- -C opt-level=3 --emit=asm
```

The produced executable ran successfully. Dependencies use the dev profile;
only this real downstream consumer is explicitly optimized. There is no LTO
or timing comparison. `consumer.s` preserves the three function bodies with
only location/CFI/temporary-debug labels removed. Their linked sizes are 192 B
(read_geometry), 440 B (read_style), and 8,931 B (edit_geometry). These include
existing owner/error/map work, not just the destination seam.

The closed domain dispatch and capture-free closures disappear from these
callers: there is no runtime Style/Geometry discriminator or boxed closure.
The declaration getter still goes through its static function pointer, and the
non-generic Geometry::get remains a call in this mixed-profile probe. This is
not a claim that all declaration/lookup indirection devirtualizes.

## Numerical scope and retained failures

The CPU has one shared f64 paint/input predicate. GPU range/FTZ and arithmetic
admission is narrower. There is no uncertain-circle f64 fallback. Exact HDR
coverage comparisons for Pythagorean sites, neighboring radii, translated
origins and both image filters pass, but do not prove universal sample equality
for every admitted inverse or GPU backend. A sample extremely close to a
circle may disagree despite a small continuous boundary error. See the source
note in `docs/rounded-geometry.md`; no broad exact-coverage claim is made.

`sdr-strict-quantizer-failure.txt` retains an intentionally overstrict SDR byte
comparison that found 187 versus 188 at a transfer quantization boundary. Its
replacement keeps existing SDR ±1 transfer tolerance and additionally requires
**exact** RGBA16F bytes for white-over-transparent, where coverage is an exact
multiple of 1/16. Thus tolerance cannot hide a changed coverage bit in those HDR
fixtures. The independent reviewer also requested an image-material HDR test;
it passes through the image flag/color-word path, not only the solid helper.

`fixture-target-error.txt` retains a private cleanup test that initially
unwrapped a diagnostic snapshot target for a non-actionable div. Its correction
uses the existing private capability constructor; production code was unchanged.
`clippy-condition-failure.txt` retains the nested-if lint fixed by combining two
short-circuit predicates. Actual Vulkan and native gates were rerun afterward.
