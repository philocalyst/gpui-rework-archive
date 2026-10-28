# Certified-mask tile traversal: preregistration

The ordinary draw-major experimentd35d2335 gained7–9% text and failed20%;
mask-addressb8e6667b gained3.9% stream and failed20%; four-cell58da795d gained
4.5% stream and failed20%. Both latter mixed screens have late-gap failures.
All remain rejected. Native diagnostic6d63fbf4 establishes zero paint-bank
packets in1,082 preparations,so the four-cell cache was never selected;93.1%
of planned true mask references nevertheless carry its address certificate.
The initial diagnostic mislabeled solids and is preserved separately.

Hypothesis: decouple traversal strategy from paint-bank representation. Starting
from qualified-but-performance-rejected four-cell production7565d788,mark only
nonuniform,nonempty literal-color tiles containing a surviving LOWERED_MASK
reference. Use one currently unused bit30 of the existing tile range end; assert
reference bounds fit below it. Uniform tile bit31 keeps priority. Compute existing
Stats from untagged ranges before tagging. Keep actual indices,counts and record
addresses unchanged. Gated by the existing tile-proofs switch; no tag with proofs
disabled. Banked scenes retain their existing draw-major route without new tags.

Tagged literal tiles use the existing ordered sixteen-color traversal and
four-cell mask reuse. Its load_banked_draw already supports literal colors;
paint binding semantics and traversal selection are independent. Other literal
tiles retain sample-major traversal. Preserve every sample/blend/reduction and
output operation,including HDR signed zeros,clips,resource leases and publication
authority. No new pipeline,persistent buffer,header,API,dependency or unsafe.
Charge extra CSR search,shader bytes,private256-byte sample-color array and
16-byte coverage cache; actual driver register/spill allocation is unknown.
Global shader code-generation effects may still regress unselected scenes.

Before performance: fresh GPU/canvas tests,strict Clippy,336 unchanged public
mask-lattice captures exact against independent pre-changeoracle6faae98a. Private
packet checks must prove tags only reference valid lowered masks,inline/compact
and banked/literal behavior,and proof-disable removes tags. A wrong-Y cache
mutant must fail the exact ordinary public GPU fixture: proof-disabled sampling
is the existing fallback,proof-enabled selects tagged traversal. Preserve its
actual failure and all unsuccessful attempts. Generated/embedded shader guards
mandatory. A separate instrumented native source with only packet logging added
must show selected literal tiles on the real workload,with unchanged shader and
exact initial0/190 images; no timing claims from that instrumentation.

Then early admission screen,not adoption: same matched opt3/fatLTO/CGU1 native
profile and baseline suffix executablecompiled2684821f.17 workload tests per
variant,10 preflights,then64 eight-second processes:8 AB/BA pairs per idle,scroll,
stream,both,initial0,trace,seed20261115. Exact ingress only for stream; owner
otherwise,unchanged native workload source.960x720,same font,X11:94,llvmpipe4.
CPU window visible+1..6s with>=4.8s coverage. Active464–488 updates,<=2 first
second ACK gaps>25ms,zero later; idle0. Any execution/work failure suppresses
the entire mode's ratio. Paired median CPU<=.8 stream/both,<=1.05 scroll; idle
median observed CPU<=baseline with no zero-denominator ratio.10000 paired
bootstrap/type7,seed reset per mode. Keep all observations,no retries/subsets/
threshold changes. Freeze scripts/verifier before observation. No build,test,
edit,analysis or cleanup during timing. At least8GiB reserve throughout.

A pass admits full native/minimal/default/offline/actual-X11 qualification and
independent offline pixels,then unchanged28-case4160-process cost matrix at
seed20261116,then a fresh matched ZGX native comparison. Code/dependency/vendor,
shader/ELF/stack/header,all allocation,cold/RSS and work gates remain mandatory.
No local software Vulkan result closes physical GPU,two hardware classes,
scanout or quality gates. All changes local. Earlier failures are not adopted
individually or retrospectively relabeled.
