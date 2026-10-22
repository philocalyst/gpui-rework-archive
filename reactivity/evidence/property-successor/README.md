# Outlined property activation successor

Production base: `021dcb5d29a84269c896674823b3a508d7b22d97`.
Test-only baseline: `b8453e4eec`.
Shipping source: `49707a4a4afc07e204133183ed3d548b065f66ed`.
The production delta is one `#[inline(never)]` on `activate_property`; no cold
annotation, callback ABI, field, owner, manifest, dependency or vendor change.
The two added public tests contain 151 Rust code lines. Libraries gain one code
line (30,467 to 30,468 using the previous six-library inventory); build 18 stays
unchanged. Control/client/parser sources and emitted assembly are evidence,
separately retained here, not shipping work claimed as deletion.

PropertyState remains 80B with both canonical resolved value and exact stored
contribution. A proposed 48B compact representation was rejected before any
production implementation. The public shell test finds GPUI Inspector by
public role/name query, stores Set(width 111), and observes canonical width 320
after built-in inspector refresh. A public property_selection reply preserves
canonical 320 and stored Set 111 simultaneously. Deriving Set(canonical) would
lose author state. The shell's existing admission and forced-width behavior
are unchanged. Baseline source hashes and the first/repeated proofs are frozen.

Matched linked release controls use byte-identical main.rs and Cargo.lock,
opt-level 3, lto=false, codegen-units 1, debug 0, strip=none and offline/locked
resolution. Only source/patch roots differ. Each actually invokes three
callbacks and checks width80. Original 42a and qualified 021 controls remain
frozen in the preceding property-selection archive. No timing was collected.

| Cohort | 021 .text| outlined .text| 021 caller frame| outlined caller frame|
|---|---:|---:|---:|---:|
|ordinary|3,404,391|3,404,487|3,816|3,416|
|property opt-in|3,404,791|3,404,887|3,816|3,416|

The original 42a caller frame was 3,608 B. Main code falls 10,196 to 7,809 B;
the outlined helper is 2,472 code bytes with a 488 B compiler-reported frame.
The opt-in path now calls that helper; ordinary dispatch retains its existing
branch and does not execute that call. Both executables retain the helper in
linked code. Whole .text grows 96 B, .eh_frame grows 88 B and the instrumented
.stack_sizes section grows 10 B in each cohort. .rodata and .data.rel.ro are
identical to 021. Entire unstripped control files grow 424 B ordinary and 416 B
opt-in, including ELF symbols/metadata/layout, not a shipping-size assertion.
MethodRoute::invoke and after_source_changed code/frame measurements are
unchanged. Full sections, symbols, hashes and selected assembly are archived.

Frames are compiler stack-size metadata for control-crate-generated code,
not dynamic call depth, dependency frames or peak stack use. They are never
added together. Outlining isolates the larger opt-in working frame and removes
this measured ordinary caller regression at the cost of a call and linked
code growth; no speed, total-stack, RSS or native allocator claim follows.

The exact same unoptimized allocation-counter fixture ran before and after
the attribute. Both ordinary/property mount and action count/requested-byte/
retained-byte/peak-byte rows are exactly equal; 100 equal resizes allocate zero.
The property cohort has its existing extra requested allocations (47 actions
versus 45 ordinary,12,948 versus 11,268 requested bytes across three actions),
which this attribute does not eliminate. These are requested Rust allocation
counters, distinct from release code/stack controls and native memory.

Exact-source qualification is recorded in raw logs and source hashes:

- 31 public tests: 9 property actions, 11 changed-identity union, 9 selection,
  one shell counterexample and one matched allocation fixture; all passed.
- Native 202 library tests plus 10 public selection/header tests passed;
  26 library tests remain intentionally ignored.
- All-target native Clippy with warnings denied and targeted formatting passed.
- Apple aarch64 and Windows x86_64 MSVC all-target desktop+parallel compilation
  passed with build-std. All 1,965 tracked source/vendor/config hashes matched
  before and after qualification.
- Actual private-Xvfb native pointer/ACK/stale-target recovery passed using the
  frozen native executable and existing public consumer behavior.
- Independent real AT-SPI Registry replay passed on the frozen ordinary
  Window::document example: checkbox Action, library Action, actual
  EditableText.SetTextContents, Apply, Inherit, Refresh and acknowledged
  character/component extents. The exact preceding frozen client was reused;
  no app instrumentation or private target/model seeding was added.

Cross compilation is not foreign UI execution.
The frozen debug native test is 722,549,856 B and the public example 441,481,320 B;
hashes identify those test artifacts, not shipping binary sizes. State 80,
borrowed phase 40, request 48, ordinary invoke ABI and all retained headers remain
the qualified 021 definitions; the native/header tests rerun those assertions.

Use the production commit alone for the one-line successor, or include the
test-only baseline for the two public fixtures. `raw/source-and-tests.patch`
contains all changed crate files. No main source was modified. Two initial
tool-launch mistakes (python absent from PATH, then an unsupported rustfmt
flag spelling) were corrected using the pinned Python and `--edition 2024`;
failed launch outputs were excluded from qualified artifacts and all successful
controls have their own frozen hashes/logs.
