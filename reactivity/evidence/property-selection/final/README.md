# Qualified property selection/state API

Base: `42a5aed2c2e5df98cbb0c558e29687fe23840f98`.
Shipping source: `021dcb5d29a84269c896674823b3a508d7b22d97` (reviewed behavior8b69).
No production edits followed qualification. Main adoption/combined gates are
separate. `raw/source.patch` contains the exact11-file source diff; no dependency,
lockfile, vendor or ordinary-route invoke change. Four manifest lines register
the new native-feature-gated public example.

`property_selection` receives its activation site's own Target on the stack and
returns a selected target/property, or None. Both constructors use one private
PropertyRoute and the existing property phase/admission slot. Component projection
checks and route restoration/quarantine remain intact. Inspect does not fabricate
a property-change identity; Edit preserves the corrected42a identity marker and
sole after_source_changed barrier. None retains its zero-change/zero-source-op
behavior. No retained runtime/model/node owner or generic queue was introduced.

`property_action` now replies with owned PropertyState rather than unit. This is
an explicit pre-1.0 source change for typed unit-result handlers; four local
callback signatures were migrated. State contains target/id/canonical resolved
value/exact stored contribution, captured after kernel apply and before mutable
reply. A reply's later source edit may produce different current state after
description. The snapshot promises neither that future value nor preparation
or ACK. The shared closed PropertyId destination mapping makes a kind/destination
read error after a successful typed edit unreachable; all13 descriptors are
exercised with equal Set, changed values in every family, Inherit and equal
Inherit. No defensive secondary schema/check was added.

The public property_editor example runs Window::document(Companion::default()).
Its explicit Inspect application mode replaces the library root's click action;
ordinary mode retains caller behavior. This is root selection, not descendant
picking or bubbling. The contained editor can Refresh, and Inherit reads the
newly revealed source value instead of retaining the old selection value. The
public tests prove Set193.25→source170→Inherit170, then source211.75→Refresh211.75.

Exact-source gates:

- Default/full:533 passed,8 ignored,54 groups.
- Native desktop+x11+wayland+parallel:202 library +10 public tests passed,
  26 ignored library tests. The public header guard is native-only.
- Native all-target Clippy -Dwarnings: passed.
- Apple aarch64 and Windows x86_64 MSVC desktop+parallel all-target compilation:
  passed with build-std. No foreign runtime/hardware claim.
- Actual private-Xvfb native pointer test:1 passed, including real selection,
  editable draft, invalid input recovery, Apply, server pixels, stale target and
  actual ACK. Exact test name is
  native::property_action_tests::native_contained_property_entry_recovers_and_reports_stale_targets.
- Independent ordinary public executable with real AT-SPI Registry: passed.
  ../public-replay contains frozen client, binary hash, acknowledged text/extents,
  real checkbox/library actions, EditableText.SetTextContents, Apply/Inherit/
  Refresh and application width restoration. No private host/model seeding.

Public tests also cover foreign/empty/stale selection, recovery, ordinary caller
behavior, mutable component-projector disagreement, callback snapshot timing,
old P with pending C/stale ACK and accepted logical state across failed prepare
and repair. Existing9 property-action and11 identity-union cases pass in the full
suite. Existing panic/restoration and all13 ordinary inspector families remain
covered. All Cargo commands use offline+locked and two jobs. Logs are raw; their
Cargo durations are not interpreted as performance measurements.

Measured64-bit carriers: Handler16, Admission16, request/Option48, owned state/
Result80, private borrowed phase40 (previous32). Method-item captures remain0.
Actual public Win8, Option<Win>16, Window<Companion>/Option208, Companion136 and
ValueEntry104. Logical Node40, Presented64, Style88, El176 and Draft152 guards
pass; no retained header was modified. These are sizeof values, not whole-stack
claims. The new public consumer contains two additional controls and an explicit
mode; its aggregate allocation ledger is charged, not called a free UI.

The matched optimized headless controls deliberately record a negative:

| Cohort |42a .text|021 .text|delta|42a main frame|021 main frame|
|---|---:|---:|---:|---:|---:|
|ordinary|3,403,527|3,404,391|+864|3,608|3,816|
|property opt-in|3,403,895|3,404,791|+896|3,608|3,816|

Main code9,579→10,196 bytes. Ordinary MethodRoute::invoke remains77 code/40 stack
bytes; after_source_changed remains9,351 code/1,128 stack. PropertyRoute::property
in the opt-in control is231→261 code and56→72 stack. The property activation path
is inlined into main here: unchanged ordinary invoke ABI does not prevent a208B
caller-frame increase. No stack peak is inferred by adding frames. The .rodata
sections are6,500,208→6,499,968 ordinary and6,500,336→6,500,096 opt-in; they include
path/constants/layout effects, not a claimed API memory saving. Exact linked
bytes, hashes, sections and selected compiler stack-size metadata are archived.

Controls have byte-identical main.rs, equal model/operations, same release
opt-level3/lto=false/codegen-units1/debug0/strip=none, fixed matching dependency
locks and source pins42a/021. Both variants actually execute3 callbacks and verify
width80. The first base build generated the standalone lock offline; subsequent
variants are locked. Source-root patch paths differ as recorded. -Zemit-stack-sizes
is applied only to the control crate, so dependency frames are excluded; metadata
is not call-depth/dynamic-stack proof. No timing, RSS or native allocator claim.
Binaries remain frozen outside Git; JSON hashes identify them. A successor outline
or compact-state experiment must keep these exact021 controls as its baseline.

Source bill: shipping libraries30,420→30,467 (+47); build-script18 unchanged.
Changed Rust adds573 code lines:47 shipping,48 public example/support,478 tests/
ledgers, plus4 manifest registration lines. Tools/evidence and the earlier222-line
compile-only sketch/vtable controls are separately charged. Final selected
control/model/parser sources are copied here; they are not shipping or excluded
work claimed as deletion. The unstripped debug native test executable is
722,549,856 bytes, SHA dfed1f223e7451888d6050952055c4234bfb1509ce78d95147da14cdb410b2bc;
the public debug example is441,481,320 bytes, SHA
fa942a5f2660128c2bfce53c731f35d636c33ee6cad7227351605b534f41a418.
These identify test artifacts, not shipping binary sizes.
