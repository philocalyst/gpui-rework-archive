Typed mapped properties: isolated, unadopted source spike

Source pin: 0062bf589829c4f28807ad0fde3e13285379294c
Worktree: /tmp/gpui-mapped-properties-sol, branch spike/mapped-properties-sol
Base: a221d24c315e40dbe3c3f93daa28a41bf5ff561b
Independent Reader fix: 8c56ff0bbedbcdfde7484a97182b104aadccdbf5,
  adopted separately on Main as 7df96981b8dd7c32ac5ff4d899b501bf30a0f3e2.
This dossier is an evidence-only successor to the source pin. The benchmark
source/host was not changed or measured here; remote baseline remains 63e0.
No timing or speedup claim follows from these functional/allocator results.

Result and remaining cost

One exact with_inbox_for update to one Signal<Frame> drives an Affine transform
and 32 distinct Color properties with one source read, 33 destination compares,
zero owner reruns/descriptions, and stable logical identities for 1,000 rows.
A native X11 ReferenceCpu Application demo reaches the next presentation ACK
with zero owner reruns/row rebuilds; Frame is 32B and Signal<Frame> is 40B.

The property patch itself is allocation-free after construction. A visible
mapped-color edit still uses full scene preparation. In the 10,000-row cohort,
ONE mapped color update requested 1,215,456 bytes in 15 allocations, with
1,211,600B peak and no net retention. This is a substantial remaining cost,
not an optimized graphics update. Batching through existing Canvas paint-bank
transactions is a separate proposed slice, outside this frozen implementation.
Ordinary unrelated/direct-only Color updates keep their existing slot fast path.

Public API and authority

  .transform(self.frame.map(|frame| frame.transform))
  .bg(self.frame.map_with(bit, |frame, bit| {
      if frame.bits & (1 << bit) == 0 { Color::BLACK } else { Color::WHITE }
  }))

SignalMap is in the prelude. map/map_with need no marker trait, user type,
macro, or per-destination heap allocation. Copy captures plus parameters must
fit 16B at alignment <=8. Construction retains a checked error which mount
returns as Error::MapStorage; oversize captures do not panic or silently box.

This deliberately amends the prior literal/signal-only description contract:
user computation may map registered typed sources into existing CLOSED typed
properties. PropertyId, validation, reflection, impact, and setters stay closed.
The mapper must be total, deterministic and read only its input/immutable
parameters, with no I/O or external mutable reads. This is a semantic purity
law like Source::new, not a Rust-enforced effect system. Full descriptions
currently invoke each map twice; exact patches invoke each map once.

Mapper identity is not compared across descriptions. Destination/property
identity drives reconciliation; coarse owner description conservatively rebuilds
recipes and marks the candidate dirty. No pointer identity, forged FieldId,
revision-only shortcut, callback address equality, or capture equality is used.

A patch borrows the current registered source once, evaluates all outputs into
retained scratch, and validates every mapped and direct sink before any write.
It then compares effective styles/updates inspector bases while the color bank
is still old, and updates stable bank slots after all comparisons. This ordering
handles a masked first direct sink sharing its slot with a later visible peer.
No source loan survives the transition to destination mutation.

Storage choice and rejected alternatives

A per-destination boxed capturing callback would add one allocation/header per
map and was rejected as the default. A static fn plus explicit small parameter
is ergonomic but still needs retained typed storage at the heterogeneous
boundary; function pointers of one type cannot be grouped only by TypeId.
A safe boxed mapper per group is simpler but still allocates/retains a vtable
object for each distinct captured recipe. The chosen bounded experiment uses a
24B Copy-only inline callable (16B payload + typed thunk), with checked layout
admission and an isolated internal crate. gpui keeps forbid(unsafe_code).

The helper's two unsafe operations pair exact typed write/read after size and
alignment checks; F: Copy + Send + Sync + 'static. It transfers no ownership,
exposes no raw storage, holds no output, and has no destructor or heap fallback.
Four ordinary tests cover ZST/function pointers, full captures, padded static
references, clones/moves/reallocation/thread transfer, borrowed input and
layout rejection. The independent Miri archive adds provenance qualification
and a deliberately weakened-size-check actual UB control (details below).

Mapped-only fanout owns records, direct destinations, and reusable value scratch
behind one cold Box. Ordinary Fanout remains 32B, Destination 4B, Binding 24B,
Draft 24B, ElementExtra 56B and Decorations 48B. MappedRecord is 32B, Recipe 24B,
PropertyValue 28B, MappedFanout 88B. The 33-map fanout requests 2,068B including
its payload and retained record/value arrays. Each mapped Color also needs a
48B stable SourceColor in the existing bank; temporary discovery bindings are
8B each. Different mapped colors from the same source never share one output
slot. Direct Color ports of that source may share their ordinary identity slot.

Erased temporary PropInput grows: baseline Color24/Affine32/number16 to 48B
for each in this candidate. This does not enlarge every retained node or packed
destination, but may affect cold stack/code. Whole-linked machine-code/frame
cost comparison against Main7df is assigned separately; it is not qualified here.
Mixed mapped/direct semantic descriptions can use one additional base wrapper;
normalization prevents recursive growth and literal/direct overwrite releases it.

Allocator ledger (requested bytes, not allocator usable size/RSS)

33 descriptions, outer collection preallocated:
  literal: 0 requests, 0B
  direct: 66 requests, 2,640B retained/requested
  mapped: 66 requests, 3,432B retained/requested
1,000 alternating mixed builder overwrites: 5 requests/232B retained;
  direct overwrite leaves 80B, literal overwrite leaves 0B.
Original direct builder floor remains literal0B, one-port80B, two-port104B,
  eight-port248B retained; see description-allocation.log.
Small private 33-map owner cohort: 196 requests,119,150B requested,
  34,168B retained,37,688B peak. Its input model differs from public Frame32B;
  this is an actual private-cohort total, not a public Frame32B owner estimate.
First and warm private property patches: 0 requests/0B.

10,000 shared direct-color rows, without / with one unrelated mapped color:
  nodes:             10,001 / 10,002
  cold requests:     21,876 / 21,883
  requested:         23,838,905 / 25,599,926B
  retained:          5,396,597 / 5,396,730B
  peak:              6,318,800 / 6,544,442B
  style lane:        10,425 / 10,498B
  mapped fanout:     0 / 148B
These whole-cohort deltas include container capacity effects; do not add them
to component bills. In BOTH cohorts an ordinary direct-color exact tick uses
0 allocations,1 source read,0 destination compares,0 owner reruns,0 paint passes.
4,094 unique mapped-color private patches: 0 allocations/0 retained growth.

Qualification and actual negative controls

Final default cargo test: 634 passed,10 ignored,69 harnesses including docs.
Final native X11 targeted test: 247 passed,30 ignored,4 harnesses.
Both default and X11 all-target Clippy with -D warnings: exit0.
Native example build/run: exit0. native-run.log records the real ACK.
Native scope is ingress/ACK and counters; native pixels, masking, and coalesced
candidate internals are not inspected by the demo. Presentation/inspector laws
are covered by recording/public API tests and the private atomicity complement.

The seven public mapped tests cover coherent 33-output updates, stable rows,
ACK/hit authority, invalid affine quarantine/repair, forged source rejection
before callback, signal replacement/rebinding, Reader/question coarse fallback,
numeric/direct-text mixtures, builder order, capture errors/overwrite, and the
masked-first shared direct-color regression. A private late-invalid-affine
case checks earlier paint sinks and masked inspector bases remain untouched.

Actual pre-fix controls retained externally (external-elf-index.json):
- Historical-color growth failed at 4,094 updates: 10 allocations,
  130,944B requested and65,472B retained. Final stable slots plateau at0B.
  Its before/after sourceguards are included and match.
- First masked direct-color sink hid a later unmasked shared peer: actual test
  exit101, changed_nodes0 instead of1. Final three-phase code passes; fully
  masked updates still have zero changed nodes/paint and reveal current base.
  This negative ELF/log is retained; no negative sourceguard was captured.
- Original a221 Reader counterexample compiled then failed exit101; the original
  local baseline ELF was overwritten. Parent independently reproduced/froze it
  and adopted the fix with its own evidence under evidence/inbox-reader-refresh.
  This dossier includes local negative/fixed logs and the fixed ELF hash only.

Independent helper Miri evidence (supplied by parent, not rerun here):
  official isolated 7189d39d9 toolchain, final exact helper source;
  seeds0..7 x Stacked/Tree strict provenance:16 invocations,64 cases passed;
  actual weakened-size-admission fault triggers Miri undefined behavior.
  inline-call-miri-root.tar.gz SHA256:
  4729fa7ba1b037db2e1dd54a18d76bb2a99577bb21684b686b48c5a9874a98cc
Miri is substantial evidence, not a universal proof of the unsafe helper.

Luna's read-only lifecycle review is preserved verbatim in luna-review.txt.
It reviewed an earlier frozen three-phase snapshot; its warning about the old
80B MappedFanout allocator log is superseded by the fresh88B log in this dossier.
The final cached-output postpass extraction, header prints, and u64 native demo
were subsequently qualified by the final frozen batch.

Source count and reproducibility

Unmodified existing six-library Syn/Tokei tool:31813 base ->32272 candidate.
New shipping inline-call helper:50 non-test/non-comment lines,0 build.rs lines.
All shipping core:32322,delta509 vs a221; Reader fix1 is independent, leaving
508 mapped-spike core lines vs adopted Reader Main. Manifests/build metadata,
all tests and example are physically charged in source commit diff:
15 files,1738 inserted/38 deleted. source-bill.json and per-file records included.

Final build/test/run sourceguards cover ALL11,401 tracked/unignored files under
reactivity (target ignored), with before/after/after-native exact equality:
9f7c903d6456b43039956d9429f48e5c32b9ce2901456907b19db084b0d4157f
The evidence-only commit adds this directory after that frozen run; no tested
file was edited. evidence-integrity.json verifies all frozen file hashes.

Commands used (source native/nightly envs; CARGO_BUILD_JOBS=2):
  cargo test -p gpui -p gpui_inline_call --offline
  cargo test -p gpui --lib mapped_qualification --offline -- --nocapture --test-threads=1
  cargo clippy -p gpui -p gpui_inline_call --all-targets --offline -- -D warnings
  cargo test -p gpui --features x11 --lib --test mapped_properties --test source_inbox_reader_gate --test style_ports --offline
  cargo clippy -p gpui --features x11 --all-targets --offline -- -D warnings
  cargo build -p gpui --example mapped_properties --features x11 --offline --message-format=json
  DISPLAY=:120 timeout 30s target/debug/examples/mapped_properties
Native run used a dedicated local Xvfb, not a remote host. The configured :93
display was unavailable on the first attempt; final :120 run succeeded.
See compressed logs, qualification.json, toolchain versions and manifest.sha256.
