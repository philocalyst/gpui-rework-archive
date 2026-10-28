The three shader profiles use identical exact-0062 core and 739c mapped full Todo
source, except GPU renderer.rs and shader.rs. Profiles are original0062,
certified-solid7ccc65d267, and banked-four1a553e6726. No Main source is adopted or
copied into these builds. Fonts, driver, renderer policy, row counts, marker,
inbox, clocks, features and actions remain unchanged.

Builds and copies hold the shared host lease, at most four jobs, with an 8 GiB
free-space floor. Each profile resets those two files to the baseline, applies
its frozen overlay, verifies all 2,036 source files, package-cleans gpui_gpu,
builds a fresh release ELF, and preserves the actual generated ui.wgsl plus
source, compiler/build and ELF receipts. Only one profile build runs at a time;
all builds and copies must finish before native trials.

Before the registered trials, each profile runs native positive Busy, suppressed
Complete and stale-marker controls. The positive must pass the full model,
ordered callbacks, targeted drawable/revision and normal-close gates; each fault
must be rejected for its expected evidence gap. Historical six-failure and
independent host-receipt audits remain mandatory.

Exclusive native trials use two-second Busy and six-second Animation, one second
warmup, three repetitions per profile. Profile order is original/certified/banked4,
banked4/certified/original, then certified/original/banked4. Mode order alternates.
No thresholds or workload are relaxed and no failing cell is replaced. Animation
requires zero scheduler skips, expected model updates, zero mapped owner/row
descriptions after first present, real marker/viewport changes, canonical model,
normal close and at least floor(60*duration)-2 host receipts with valid clocks,
monotonicity and exact recorded subset. Long host gaps remain diagnostic warnings.
All outcomes retain CPU/PSS/RSS and delivered work; failed delivery is diagnostic
only. There is no automatic 30-second promotion.

The app includes real Todo text and 1,000 eager rows during Animation. Its mapped
colors use the paint bank; renderer mode bit8 selects banked_fragment for nonempty,
nonuniform tiles. This is a source-level route argument, not a hardware counter
or attribution of an anonymous JIT function. Host receipts/readbacks do not prove
physical smoothness; the headless llvmpipe host cannot supply hardware GPU use or
scanout measurements. Previous 75-row and 21-row campaigns remain immutable.

The observer also records diagnostic static client-RGB differences between the
three positive controls, and final animation marker/row-displacement phase from
one coherent PPM. These supplement the unchanged eligibility gates; neither is
used to relax delivery requirements or identify a physical display boundary.
