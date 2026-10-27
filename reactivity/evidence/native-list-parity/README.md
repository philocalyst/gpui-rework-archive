# Native keyed-list workload port

The comparison example now uses public uniform_list with a lazy100K item source,
stable index keys, row height28, overscan2 and registered Signal<f64> scroll offset.
Before each owner tick, Driver reads that source into the unchanged reference
Workload, then publishes the next position for Scroll/Both. Wheel and programmatic
scroll therefore survive the next timer tick. Stream-only exact ingress remains.
String generation and publication stay on the UI thread; producer sends only ticks.

Base93f63b4a03; protocol18a82e047a; example52b02729a7; final sourcece00e554f2 adds
final workload-offset diagnostics. Only the example changed: no shipping library,
dependency, vendor, shader or shared reference Workload edits. The source-controlled
list core is qualified separately. All changes remain local; no performance claim.

Ten example tests and strict Clippy pass. The previous positional view is retained
as an independent pixel oracle. Complete pixels match at0,14,16.5,2660 and2799600;
public realized ranges match Workload.row_range and never exceed19. All modes
match reference text and offset progression. Wheel16.5 and programmatic index scroll
feed subsequent UI ticks, keep overlapping target identity and match fresh pixels.
Exact stream delivery still reports one exact update and zero owner reruns.

Six actual X11/software-Vulkan runs pass: exact/owner stream, scroll, both, idle,
and both plus real X11 wheel input. All finish, acknowledge coherent frames, close
and join the producer without presentation errors. Idle emits one initial ACK.
Final workload offset equals2660 +14 per admitted scroll tick +32 for the injected
wheel. Screenshots and exact artifact/input guards are retained. These runs overlap
another isolated compilation; their tick counts are correctness bookkeeping only,
not frame-rate, throughput or latency measurements. Native retained rows are not
measured: the misleading former mounted_rows=range.len log is removed, and public
headless realization is the stated evidence. No hidden model mutation counter is
used to impersonate native row lifetimes.

Reference input correction: the protocol's inherited wheel28 note was wrong.
Pinned ZGX a3678578980e uses40 logical pixels by default on Linux, desktop-setting
adjustments, and scroll resampling enabled by default.28 is row height. GPUI's
existing native conversion remains32. Matching interactive input trajectories,
deferred controls, release profiles, text edge quality and two physical hardware
classes remain gates. Fixed14px timer arithmetic and the16.5px input test are exactly
representable in f32/f64; arbitrary fractional precision equivalence is not claimed.

Shipping code delta0. Example ELF26305568->26306600 (+1032B); list planner2189B with
local stack reservation280, row-style284B, present-walk25808B with4096+216 prologue
reservations are unchanged. This is not a whole-stack or allocation measurement.
Exact artifact SHA8276886e00455a69769067e96d0ff28d5410d8eef83feb9927172608cec4e1ef
is separately preserved. No new complete memory or timing campaign was run.

Run python3 verify.py for source scope, raw file digests, tests, native results,
input guards and preserved executable identity. This is workload preparation for
architecture experiments, not adoption evidence or a ZGX victory.
