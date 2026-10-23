# Own-focus release baseline 4d

This is a preserved control, not the final position representation. Source
`4d79537a3b1c5758f0e60885ca596412b9a95390` is based on
`c00c030a98e6218d306073d3e2a98ae8ee554cc1`. The private own-focus release proof
fixes a deterministic public manual-ACK failure and the actual native rapid
click. A later representation correction must retain its own qualification pin.

A press enters through current P and records its successfully prepared caret
focus candidate. Release first uses ordinary current-presentation admission;
only that exact pending focus sequence with S=P+1, complete S, valid P, clean
logical state, equal dimensions/density and the same window can use old P.
Release then performs a fresh P hit and normal target resolution/route admission.
Every failed press or release consumes authority before callbacks. The global
geometry gate is unchanged. Input-selection presses receive no focus proof.
Built-in inspector is excluded because its epoch captions can change geometry;
contained ordinary components work. This is an explicit temporary inspector
limit, not complete inspector rapid-click parity.

## Exact results

- Full default: 546 reported passes, 8 ignored; native/x11: 603 passes, 29
  ignored, including doctests. The raw per-suite results retain their scopes.
- Default and native all-target Clippy with warnings denied pass.
- Apple aarch64 and MSVC x86-64 desktop/all-target checks pass with build-std.
- Checked-in root config is present; both global Rust flag variables are unset.
  Actual Cargo fingerprint flags are recorded. Windows uses its target-specific
  slim-errors/static-CRT flags. No generic override masks them.
- Before/after guards match all 1,968 tracked configuration, library, vendor and
  test files. External consumer source/lock hashes also match before/after.
- All public pointer cases, failed own-focus preparation/source exhaustion,
  source/no-op/metadata changes, geometry/replacement, resize/DPI ABA, loss,
  namespace, stale ACK, cancellation and finite-bit cases pass.

The external native consumer contains byte-identical app source from queue pin
`365efc09f1207718aac7c7cfa3d9f7bfa3a5d5b9`; only manifest dependency paths point
to this core tree. It uses ordinary Window::document, real SQLite/worker/Reader,
X11 input and a private AT-SPI Registry. No private host/model seeding or app
instrumentation is added. CPU is the explicitly tested renderer. No audio is
attached. This does not qualify the app for foreign C SDKs; its standalone
SQLite cross-target failures remain in the separate queue archive.

`controls/old-failure-client.py` and `controls/gpui-rapid-pointer-native-client.py`
are byte-identical. The first failed against the frozen queue/native artifact
SHA a07cf39a122f75a4d42bc225671eb25dd979b620c537f69c1012a55a219a79d1; the second
passes on this core. Both use a complete rapid xdotool click with no wait between
Down and Up. The loop client additionally sends two whole rapid clicks and
checks false/true state with the same provider IDs, alongside Space and AT
selection/reorder/retirement/undo. Waits observe whole-action results; they do
not hold the mouse down for ACK. Source pins are explicit: the older core was
c88, whose input source is identical to the c00 input baseline. This is behavioral
evidence, not a timed or isolated linked-size A/B claim.

## Costs and preserved negative

The six-library Syn/Tokei count grows 30,468→30,537 (+69 shipping code lines).
Input test code adds 110 lines; the public test file adds 332, counted separately.
No dependency, runtime owner, per-node field, callback ABI or unsafe code is
added. PointerSession remains 32 B, align 8, but **Option<PointerSession> grows
32→40 B** because the private NaN position representation loses the old compiler
niche. No production optional-session owner currently exists, but this public
wrapper cost is unacceptable as the final representation. The successor will
use a safe private nonzero encoded coordinate to recover the first Option niche.

Actual x86-64 public carriers before/after: event 24 B, Win 8 B, optional Win
16 B, Window 72 B and optional Window 72 B are unchanged. Private Pressed and
optional Pressed are 24 B. The measured model's Runtime is 1,864 B default or
1,880 B native; native header ledger reports NativeHost 752 B. These are sizes
and alignments, not summed stack peaks or cache-line residency promises.
`artifacts.json` identifies the frozen app, native unit and default/native pointer
executables. No timings or runtime speed claims are made.
