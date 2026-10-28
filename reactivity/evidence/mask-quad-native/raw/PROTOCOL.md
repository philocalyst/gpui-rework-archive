# Four-cell mask sampling: preregistration

Parent production9e4ef386 has exact mask-address qualification677b1fb7 but its
native screen b8e6667b3f fails the20% CPU target: stream ratio.960680128;
mixed has a late-gap work failure. That verdict remains rejected. This separate
experiment tests the combined certificate plus bounded per-fragment reuse; it
does not adopt the rejected address-lowering change alone. Baseline remains
qualified suffix productiondf8ca59f, matched native executable compiled2684821f.
All changes local, no application API, dependency, unsafe or pipeline addition.

Hypothesis: for a certified unit mask on the fixed4x4 sample lattice, a single
pixel reaches at most2x2 mask cells. Banked shading may fetch each distinct cell
once before its dependent sample blends. Keep all16 sample colors, painter-order
blend operations, original anchor/delta reduction and output conversion. This
separates bounded independent fetches from dependent consumption, inspired by
BBTree's private operation lanes; it is not an async executor, proven cache-hit
improvement or a claim of equivalence to BBTree updates. Solid/Ripple publication
and resource-lifetime rules remain unchanged.

Only banked, lowered masks with every sample inside their rectangular clip use
the cache. Clip chains and edge pixels retain sample_draw. Cache valid mask cells
only, never neighboring atlas allocations. Invalid cells return literal zero as
the existing sampler does; valid zero coverage retains the same color product
(including HDR signed zero). No averaging before compositing or dropping
transparent blends. At most four coverage values plus bounded local metadata;
no persistent buffer, record, atlas, header or retained-capacity additions.

Qualification before performance screen: fresh-target GPU/canvas tests and strict
Clippy; all336 public mask-lattice captures byte-identical to the pre-change
independent oracle6faae98a and revised parent; typed/generated/embedded WGSL
identity. A bounded mutant forces all cached Y selections to the first row;
the actual public GPU fixture must then fail exact pixels. Preserve all failures.
Use existing public fixture bytes unchanged so the independent oracle is reusable.
Add only necessary adversarial tests if coverage gaps are found; new tests need
an independent pre-change run. Record source/profile/input/artifact guards.

The first admission screen is allowed before repeating unchanged CPU-only full
configuration qualification, to reject futile shader hypotheses early. It is
not adoption. Use matched opt3/fatLTO/CGU1/native profile,17 workload tests per
variant,10 preflights with exact initial0/190 captures, then64 processes:8 AB/BA
pairs of idle/scroll/stream/both,8s each,initial0,trace enabled,shuffle seed20261113.
Normal default ingress means exact for stream and owner for the other modes.
Same font,960x720,X11:94,llvmpipe4threads. CPU interval visible+1..6s must span
>=4.8s. Active464–488 updates,<=2 first-second ACK gaps>25ms,zero later; idle0.
Suppress an entire mode's ratio when any work/cadence/execution gate fails.
Median paired CPU<=.8 stream/both and<=1.05 scroll; idle median observed CPU<=
baseline, no zero-denominator ratio.10000 paired bootstrap/type7,seed reset each
mode. Keep all64 observations, no retries or changed limits. Freeze scripts and
independent verifier before observations; separate execution from performance.
No builds/tests/edits/analysis/cleanup during timing; minimum8GiB reserve.

A passing screen requires full native/minimal/default/offline gates, actual X11
checks, independent offline pixels and bounded mutant, then unchanged28-case
4160-process cost matrix(seed20261114), followed by a new matched ZGX comparison.
Report line/dependency/generatedshader/ELF/stack/header costs, cold behavior,RSS
and allocations; sample cache register/LLVM interference may outweigh savings.
The old pixel-uniform flat regression remains a warning, not an exception.
Physical GPU,two hardware classes,scanout and quality gates remain mandatory
before overall victory. Earlier failures retain their verdicts.


## Native schedule frozen before observation

Candidate production7565d788 fixes the strict-Clippy-only initializer failure
from4af395b9. GPU exact-oracle and wrong-Y mutant gates must finish and be
independently verified before preflights/timing. This is the preregistered early
shader admission screen, not full configuration qualification or adoption.
SPEC.json and PROCESS_ORDER.json freeze seed20261113 and all64 processes.
Baseline build receipts and exact executable are reused unchanged from the
suffix native candidate, compiled2684821f; candidate uses a fresh native target.
No benchmark source differences. Both font/geometry/capture preflights and
source/driver/profile/generated-embeddedshader guards are mandatory.
