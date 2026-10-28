# Native text selection: frozen source and evidence

Production source ends at `33e0c730ad`; `3bad14a8dc` adds only provenance notes
and two memory-budget tests. Base is `6e9839856d`. Integrate the eight commits
in the source order listed below. This evidence is separate from production.

| Source | Change / qualification |
| --- | --- |
| `7564ef38c1` | Initial complete source; retained separate-owner/multi-allocation control |
| `0abd0694bc` | Shared Editing owner, single exceptional allocation, standard macOS setter; retained full-discovery control |
| `5fa32de81d` | Sparse cohort update and sticky input-binding barriers |
| `c9c50f09bc` | Correct old Observer size expectation from 80 to 96 |
| `352c512f3e` | Recover unqualified cold publication after identical-output repair |
| `1b441bfd8f` | Separate validated focus-hint optimization |
| `33e0c730ad` | Static target lookup, pre-publication admission gate, checked text bounds |
| `3bad14a8dc` | Adapter provenance and memory gates |

## Behavior and authority

Semantic SetTextSelection and ReplaceSelectedText use ordinary Win selection
and replacement, including source codecs, admission, grapheme validation, and
post-edit caret repair. Private atomic ReplaceText carries a range and value in
one action. Sequential select-then-replace is not used for AT-SPI Insert/Delete.
Explicit ordinary ranges refer to current source; native ranges additionally
require their publication/session, window namespace, input identity, field,
and immutable source allocation to remain current. Affinity is logical and
native positions use selectable-unit indices, not assumed UTF-16 indices.

P text and P selection survive failed newer preparation and eligible older C
ACK. Logical revocation immediately releases its source lease; no new geometry
is paired with old P. A cold provider may publish coherent old text/selection
while its source actions are withdrawn. AfterTransition forces authority
rediscovery on the next actual stamp change, including an exact-empty semantic
delta after same-byte repair. Unchanged idle does no work. Provider clear drops
input leases/storage but retains namespace and monotonic IDs. Bridge cannot
drain actions before its first publication; queued pre-publication actions are
rejected by their old publication revision after publication.

Input control and TextRun IDs use the high half of the ID namespace. Static
IDs retain logical*2. A sorted cohort lookup rejects old low-ID input requests;
reconciliation includes NodeKind in identity reuse, so a static identity cannot
become an input. Unbound and cross-window cohorts reject requests.

The observer's monotonic epoch/sequence lower bounds retain equal-byte field
rebind authority across failed preparation and older ACK. A native full base
must cover both bounds before sparse transitions resume. Actual preparation
sequence allocation uses checked_add and never wraps. The same-source case
has a direct adversarial Observer trace; the source-advanced case additionally
has an ordinary public rebind/failure/older-ACK/repair trace. Existing ordinary
list-scroll tests exercise source-unchanged preparation and compacted P.

Qualified exact paint does no cohort discovery, table allocation, or source
clone. One changed input preflights then replaces only its frontier entry and
re-emits its immediate parent to retire native IDs. Parent child-list relinking
can inspect/output all siblings; that necessary topology work is not claimed
O(1). Full discovery is two P visits plus input-table construction and sort on
topology/missed authority transitions. The preserved 0abd source does this
discovery on every semantic stamp change; it is a losing structural control,
not a source-pinned timing comparison. The 1,000-node fixture independently
checks zero paint allocation/visits/clones, two one-input frontier visits, one
lease clone, unchanged table storage, one parent-frontier allocation, and three
native output nodes against a complete AccessKit Consumer tree.

Focus uses an existing logical index only after checking acknowledged P identity.
No focus returns the native root immediately. Compacted/older-P mismatch falls
back to searching P, so no constant-time claim covers those cases. The hint is
stack-only; no second index or hot header field is retained.

## Encoding and platform contract

See all three vendor GPUI_PATCHES.md files for exact archive pins, licenses,
and private schema compatibility. Ordinary lengths keep the upstream Vec<u8>
and serialized array. Exceptional data is `{units,data}`: N unit bytes followed
by K little-endian u32 lengths, one for each zero escape. All escaped lengths
must exceed 255. A borrowed checked decoder validates complete consumption,
checked sums and UTF-8 boundaries. Tests cover 255/256, an 8,193-byte grapheme,
mixed ordinary/escaped units, CRLF, terminal empty runs and malformed snapshots.
Raw geometry arrays retain N selectable units. This is a coordinated private
fork, not transparent compatibility with upstream-only raw/serde consumers.

The decoder currently validates the entire run on each decoding request.
Repeated range-capability/position conversion can therefore repeat O(N) work;
normalization-once is deferred, with no unsafe proof marker or extra node flag.
Explicit native edits round-trip Linux scalar and Apple UTF-16 offsets and
reject interior graphemes/surrogates, overflow, foreign run IDs, and out-of-range
positions. Linux explicit edit ranges reject reversal; reverse selections remain valid.
Canvas admits at most 32 KiB text; run and unit byte conversions are checked.

Linux EditableText InsertText interprets length as bytes and position as scalar
offset. It accepts the whole string when the length exceeds its UTF-8 size,
rejects negative/split-UTF-8 prefixes, and uses one atomic replacement action.
DeleteText uses the same explicit range writer. Clipboard cut/copy/paste remains
unsupported. macOS upstream 0.27.1 did not implement selected-text mutation;
the private fork adds capability-checked setAccessibilitySelectedText:. Earlier
blanket support claims for unpatched macOS were incorrect. Windows UIA exposes
selection and full-value SetValue; no absent selected-text mutation operation
is invented. Apple/MSVC evidence below is compilation, not native AT runtime.

Wrapped TextRun rectangles, character geometry, magnifier/caret rectangles,
and native geometric text hit testing are still required followup work. They
are omitted here rather than borrowing mutable live layout for old P. The
smallest future authority seam is the existing TextSite shaped TextLayout,
shared immutably/COW across P/C with exact source and placement leases, after
reviewing lazy interaction-map mutation. No second per-character tree exists.

## 64-bit requested memory ledger

| Structure | Bytes / ownership |
| --- | --- |
| Runtime, Node, TextSite | No header growth |
| Existing Metadata.editing slot | 8, unchanged; no extra snapshot slot/allocation |
| LogicalSelection / Option | 40 / 40 |
| SelectionSnapshot / Option | 24 / 24, existing NonZero identity niche |
| Shared Editing | 88 cold; logical plus P/C offsets; +48 over logical-only owner |
| Revoked logical with old P/C | Bounded 40 empty bytes; no logical source lease |
| Observer | 96 active-provider bytes, formerly80; two sticky bounds16 |
| Cohort | 40 empty header per Bridge, one window namespace and monotonic ID cursor |
| Input | 40 per published input; table only while provider active |
| Ingress / Shared | 8 / 72; Arc allocation bookkeeping is additional |
| Command / Queued | 32 / 48; queued was40, +512 for64 payload slots before channel overhead |
| Channel(None) | 3 allocations, 4,312 requested retained/peak bytes measured |
| Selection / atomic replacement payload | Box32 / Box48, plus replacement UTF-8 backing |
| AccessKit Node / PropertyValue / indices | 128 / 40 / 87, unchanged |
| Exceptional descriptor | 24 inline, one frozen N+4K byte allocation |

The optional wake path, platform adapter trees/threads, allocator rounding, RSS,
and transport-side payload construction are not included in Channel(None).
Shared72 includes the extra publication atomic; no cross-platform native-floor
performance claim follows from this one allocation fixture. Normal native,
desktop, x11 and wayland include accessibility; explicit *-minimal profiles
disable AT transport through private native-core implementation cfgs.

Allocation controls use identical standalone Node fixtures with distinct Cargo
package/target identities. Counts include construction scratch; clone retained
bytes include node value/properties, not just length storage. Full-u32 is only
a payload Vec control, not a complete alternative native stack.

| Fixture | 7564 length retained | Final retained | Final construction allocations / total bytes | Full-u32 payload |
| --- | ---: | ---: | ---: | ---: |
| 1,024 ordinary units | 1,024 | 1,024 | 8 / 2,040 | 4,096 |
| 1,024 with one401-byte unit | 1,060 | 1,028 | 10 / 3,076 | 4,096 |
| One8,193-byte unit | 37 | 5 | 3 / 21 | 4 |

Ordinary Vec capacity may exceed N; it is not universally exactly N retained
bytes. Final escaped payload is exactly N+4K. The huge one-unit case loses one
payload byte to full-u32. Final clone allocations are3 in every fixture versus
5 for escaped7564. The 0abd single-allocation control retained the same final
payload but mixed construction used11 allocations/5,124 total bytes; one final
reserve_exact avoids geometric tail growth followed by shrinking/copying.

## Source-pinned gates and raw evidence

- 3bad: strict x11 all-target Clippy;36 native unit/transition passes,5 ignored;
  ordinary public26 passes (7 serialization,6 semantics,13 selection).
- 33e: real Xvfb113 AT-SPI Todo transcript passes reversed selection4→0,
  caret2, UTF8=9/USV=6 InsertText, caret10, invalid interiors/reversed/UTF8,
  DeleteText4..10 and caret4. Late service/owner replacement/destruction and
  no-session-bus presentation each pass. Owned Xvfb stopped afterward.
- 33e: locked/offline Apple and MSVC desktop+parallel all-target checks pass
  with build-std. The later3bad change is docs/budget tests only.
- AccessKit361 and Consumer208 pass on the same frozen vendor blobs as3bad.
  1b x11-minimal all-target check passes; later production changes are within
  accessibility cfgs. Focus guard fixture passes; shared Editing lifecycle3
  passes. No foreign-platform native runtime claim is made.

The 5fa run had32 passes and one stale80-byte size assertion; c9c corrects it to
96 and passes. A 1b native attempt ran before org.a11y.Bus registered and failed
ServiceUnknown; waiting for its actual DBus name fixes environment readiness.
Earlier dead-display112 and dconf-enabled-status attempts were invalid
environment setups, not successful behavior evidence. Raw controls are retained
without converting these attempts into product regressions or speed claims.

Official final first-party non-test shipping count is27,430 (27,417 src plus13
build), +624 versus base26,806. This excludes vendors and evidence, so they are
charged separately: imported AccessKit3,097, Consumer3,658, macOS2,286 shipping
non-test lines; existing patched AT-SPI common3,614 and Unix2,312. The evidence
probe plus counter add53 non-test lines. These are complete package costs,
not just patch hunks. Generated serde/schema macro expansion is not claimed as
source lines. No library build scripts exist in the three imported packages.

Reproduce from the source worktree using `/tmp/gpui-native-env.sh`, two jobs,
and an isolated CARGO_TARGET_DIR. Core count uses the root-owned shipping
build-script-aware core_lines.py; raw/candidate/core-lines.json pins its helper,
Tokei, sources and manifests. The extra ledger uses:

```sh
python3 reactivity/evidence/native-text-selection/count_extra.py "$HELPER" "$TOKEI"
cargo run --offline --locked --release --manifest-path reactivity/evidence/native-text-selection/codec-probe/Cargo.toml
cargo test --offline --locked --manifest-path reactivity/Cargo.toml -p gpui --features x11 --lib native::accessibility
cargo clippy --offline --locked --manifest-path reactivity/Cargo.toml -p gpui --features x11 --all-targets -- -D warnings
RUSTC_BOOTSTRAP=1 cargo check --offline --locked --manifest-path reactivity/Cargo.toml -p gpui --features desktop,gpui_canvas/parallel --all-targets --target aarch64-apple-darwin -Zbuild-std=std,panic_abort --jobs 2
```

Repeat the last command for x86_64-pc-windows-msvc. Native ignored tests require
an isolated DBus session and real org.a11y.Bus/registry; wait for its name before
starting the Todo test. Lifecycle replacement uses its own private bus fixture.
Archive and fixture/binary hashes are under raw/. Binary artifacts remain in
the isolated /tmp evidence directories; the committed evidence contains hashes
and raw text, not opaque executable artifacts.
