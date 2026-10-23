# Borrowed projection correctness/cost control

Shipping source is **0cbd09c9d7c6f932c1e54ae28296262fb25904b9**; final private
test/support source is0609e9fa7b, followed by the unrun timing driver98b68895c9.
The source is frozen here before a separate minimal Clippy spelling repair and
generic visitor rename. No timing was run and this is not the final adoption pin.

The public owned Cluster iterator and the private borrowed visitor share the
same `Clusters::advance_cursor` recurrence. Checked preflight needs only ranges
and counts, so it walks line-scoped graphemes and maps source through full_slice.
RTL prefixes and logical lowering borrow Run/Atom/Grapheme and preserve the
original spacing, hard-break and path formulas. Internal Layout grapheme/Atom
invariants remain trusted: corrupt private Atom state can now panic during
emission rather than preflight. Explicit font/source rejection remains before
all callbacks; this does not promise atomic handling of every corrupted private
Layout invariant. Decreasing requests still drain through ordinary cursors,
then exit immediately, including callback errors during that drain.

Qualification at this exact source:

* Canvas parallel193 passed /4 ignored; scalar183 /3, each28 harnesses.
* Independent direct/packed oracle94,176 accepted /41,760 snapped /11,096 distinct.
* Final private9 passed: actual396 producer layouts, malformed/gap/empty controls,
  word/letter spacing, justification, repeated/decreasing requests, early stops
  and errors after a decreasing request. Cost probe passed separately.
* Canvas all-target parallel Clippy `-D warnings` passed.
* Standalone vendor Clippy **does not pass**: the three existing baseline
  diagnostics plus one new `use_self` diagnostic on the callback's `&Run` type.
  Exact baseline/candidate logs are preserved. No lint allowance was added.
* Public83 recording transcript is2,678,729 bytes, SHA-256
  `1d529192f8bce827403feb865c800d20054ef98b96fa8043e29edce018f69a4f`,
  identical to1d5,16B and shared controls. Owner lifetime/allocator output is
  byte-identical to shared: first C381 allocations /20,590,912 requested /
  12,170,700 peak /1,091,736 retained; old P survives new C and failed new L,
  then old C ACK publishes the correct map with zero allocations.

All14 fresh/warm scoped-shaper allocator rows match shared/inline exactly.
The main linked body is4612B/local920B, but also charge logical visitor1979/600,
RTL404/360, shared advance_cursor1538/136, constructor747/56 and pair1113/472.
Constructor writes directly into visitor-local272B state; the272B staging memcpy
and144/136B public Cluster result copies are absent in these hot visitors.
The state itself still exists. A152B offsets construction and168B cold fallback
move remain. Planner14570B/local4536B and shared geometry_with936B remain charged.
Total .text is0x121428: **384B larger** than shared,12,496B above baseline.
These are individual local reservations, not aggregate peak-stack claims.

First-party source stays30,432 including18 build-script lines. Vendor geometry
is476 code lines; run.rs grows342 ->362. Shipping delta from1d5 is366 code lines
(shared325 +21 geometry +20 run). Support helpers/owner remain299 plus the new
variant timing driver (count separately); copied public clients add165 physical
non-test code lines to this archive. Prior shared public copies and198 slot
census copies remain additional archived source. Private test source is
190+253+92 lines. No retained field, owner, global cache, sort, unsafe code,
font/layout algorithm or second shaped tree was added.

Source.patch.gz is the complete crates/vendor diff from1d5 through0cbd;
support.patch.gz is the complete span support diff through98b. Apply both at
1d5bc3061cce3beb3c4857102ed651da501b5cfd and commit locally to reproduce without
unpublished branch objects. Public sources/manifests/locks are included; relocate
their explicit paths. Source/artifact guards, compiler JSON, locks, assembly,
raw logs and transcript accompany the archive. All421 production guards pass
before the worktree proceeds to the later repair. Copied binaries keep distinct
names even when the build cache/worktree is subsequently reused after all runners
finish. Never reinterpret later working-tree bytes as this control's source.

The frozen1d5 shaper build's actual83 Cargo artifacts and81 local rustc .d inputs
are byte-identical in main89aeabd53942c3a4643bcb6fd978e6a24703f6d2. Root manifest /
lock also match; WGPU is absent from that build closure. The full hash proof is
included. This justifies using the explicitly1d5-built baseline for this kernel;
it does not relabel it as an89ae-built binary or qualify current-main application
runtime. Public Win controls here are recording-owner gates, not native protocol,
foreign-platform runtime, renderer frame latency or RSS measurements.

Frozen scoped binary: /tmp/gpui-monotonic-control-bin/stream-borrowed,
SHA-256 `51359736eadad727c0e8d31db7eea0f55ed0ee177591cfd9d032de9ef179e97c`.
Worktree at qualification: /root/gpui-monotonic-caret-borrowed.
