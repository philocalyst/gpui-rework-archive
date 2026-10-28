# Isolated source values and composed delivery qualification

This is the qualified successor to the historical e31 delivery candidate. It fixes the concrete shared-atomic source alias failure before adoption. Production is still isolated; no Main edit or performance adoption is implied.

**Selected source:** `22541342e3c10a962bc61f76088c7bfdb1b21bbd`, in `/tmp/gpui-delivery-isolation-sol`. Production GPUI files are exact `df57f1c38bbe62f9ceb745ba02e509b5630422a5`. `3ae5b7c0be0c07fbc02d4405d0b829e866428a37` only migrates test observers; `22541342e3` only adds the existing GPUI→Triomphe edge to Hummingbird's separate lockfile. `hb-lock-successor-proof.json` proves every package/version/checksum record is unchanged and all compiled workspace GPUI inputs remain identical. Earlier results keep their original source labels.

Root's `ff44c087e36eba331e0bc408a98bcab8e3837467` repair is cherry-picked as `f1234d8451`. It excludes `UnsafeCell` from the private structural source-value capability and admits standard/Triomphe `Arc<T>` only when the canonical pointee also qualifies. Reference-count metadata is excluded from canonical data. The narrow df57 successor admits ArcStr's fixed immutable str bytes; it adds no dependency. Triomphe **0.1.17** moves from an existing dev dependency to a normal GPUI dependency solely for this admission proof; the transport remains standard Arc/Mutex.

The original public repro, preserved in the prior delivery dossier and Root's `0b37` archive, changes canonical B through an aliased `Arc<AtomicU64>` exact edit to A while B's Question remains stale. The complete repro now fails at the public `Source::new`/`SourceValue` bound. General mutable resource models remain supported through coarse owner updates. This is a deliberate pre-1.0 constructor restriction, not a runtime fallback. Representation qualification does not prove arbitrary projector/callback purity or track extrinsic state/reference-count observations. SourceSchema6788 and RuntimeCore restructuring are not included.

The kernel requires genuine pinned **nightly-2026-10-23**, rustc **1.101.0-nightly 7189d39d9**, LLVM23.1.4. GPUI uses `auto_traits`, `negative_impls`, `trait_alias`; this dossier uses no RUSTC_BOOTSTRAP or shipping bootstrap override. Root's official archive verification/Nix loader adaptation provenance is under `/tmp/gpui-nightly-provision-2026-10-23`. Lower-level crates are not given blanket unstable feature requirements.

## Exact functional evidence

Each gate records command, actual compiler/environment and before/after Rust/WGSL/manifest/lock/config hashes. Compilation and execution are separate. No performance timing ran.

| Source | Gate | Result |
|---|---|---|
| 3ae | default no-run, full lib/integration execution | 580 passed, 10 ignored, 63 harnesses |
| 3ae | X11 native no-run, full lib/integration execution | 645 passed, 35 ignored, 63 harnesses |
| 3ae | default and X11 all-target Clippy | both `-D warnings` pass |
| 3ae | runtime tests with 8 test threads | pass; independent per-test drop hooks |
| 3ae | Apple ARM64 / MSVC native library checks | both pass using installed official target std |
| 225 | Hummingbird locked no-run / execution | 50 passed, 14 harnesses |
| 225 | selected source/inbox/isolation/value runtime execution | 30 passed, 4 harnesses |
| 225 | downstream SourceValue contracts | 31/31, 22 expected negatives and 9 positives |
| 225 | three actual native entrypoints | all pass, 8 internal cohorts |
| 225 | actual Linux Registry old-P/failed-new-L/repair | pass |
| 225 | changed-source rustfmt check | pass |

The 225 native replays use the unchanged 3ae-built X11 lib-test ELF, SHA256 `05cde3eaad6fdfb84059d37a81bc4ca5a5c83c17c648f138eb636f52e8db6e4a` (692,530,448 bytes), under the explicit GPUI-input equivalence proof. Its source/binary guards and normal owned WM close/cleanup are recorded. No historical 6474 ELF is reused or overwritten. All private displays, buses and application processes were reaped.

The contracts use Root's canonical artifact discovery and diagnostic rules, adapted only for immutable lease positives and the original Rc observer negatives. They include ArcStr, Image, standard/Triomphe Arc of **owned `gpui_canvas::TextGeometry`**, immutable Arc/trait-object/borrowed cases; nested Signal, Atomic/lock/Cell/RefCell/storage aliases and the complete original alias repro are rejected. Original `Rc<Cell>` / `Rc<RefCell>` observer representations remain compile-negative. Runtime tests instead use noncapturing hooks with function-local static atomics; no cross-test callback swapping/reset is introduced. Test payload ownership, pointer identity, producer-race and panic/destructor checks remain meaningful.

`cross-actual-fingerprints.json` records actual flags: Apple uses root v0/tokio flags; MSVC uses `windows_slim_errors` and `+crt-static`. Generic RUSTFLAGS and encoded flags are unset, so target-specific root configuration applies. The cross gates are library compilation checks, not native execution on those systems.

## Fresh matched whole-consumer costs

All three controls use one new path `/tmp/gpui-delivery-isolation-cost-sol`, target `/tmp/gpui-delivery-isolation-target`, genuine compiler, root config, release/default+SIMD profile and fixed ordinary/component fixtures. A=`22cd93e21d` is current-main602a plus compiler compatibility only; B=`98450106fc8037b6ae6e6be048833f31241c82e2` overlays selected225 with identical ordinary/coarse fixtures; C=`103055929d5da1a71fb3f2418e0666597b0cd874` changes only two fixture lines to typed delivery. A and B explicitly clean **release GPUI only** before rebuilding; GPUI and both examples are fresh:false. C reuses unchanged GPUI (fresh:true) and rebuilds its field fixture (fresh:false).

`matching-proof.json` verifies compiler/path/profile/features/config/rustflags and fixture equality. All normal dependency fingerprint entries are identical except the existing Triomphe edge added to GPUI; Triomphe was already compiled as a dev dependency in A. Embedded font assets have separate before/after hashes. Every ELF is copied before a source switch, executed only for allocation/work oracles, and hash-checked. Whole linked sections, all indexed GPUI/transport bodies, Mutex helpers and CFG frame records are retained. No wrapper-only cost conclusion is used.

| Actual measurement | A compatibility | B final coarse | C final typed |
|---|---:|---:|---:|
| ordinary linked `.text` | 3,675,847 | 3,670,007 | — |
| field linked `.text` | 3,697,959 | 3,691,383 | 3,702,711 |
| field `.rodata` | 6,512,512 | 6,512,216 | 6,512,792 |
| field `.data.rel.ro` | 154,760 | 154,640 | 155,192 |
| ordinary `deliver_ready` own code/frame | 2,993 / 456 | 2,919 / 520 | — |
| field `deliver_ready` own code/frame | 2,933 / 424 | 2,919 / 520 | 10,213 / 1,416 |
| field delivery wrapper own frame | 280 | 280 | 280 |
| field owner constructor allocations | 58 | 57 | 57 |
| field owner requested / retained / peak bytes | 9,719 / 7,891 / 8,051 | 8,903 / 7,075 / 7,235 | same B |
| each eight-edit field batch allocations / requested / peak | 28 / 2,260 / 1,596 | same A | 3 / 136 / 136 |

The ordinary caller tradeoff remains: linked text −5,840B, but delivery own frame **+64B**. Plain Win construction (33 allocations; requested6,792/retained5,564/peak5,732B), update allocations and its 748B/frame168 body are unchanged. Typed delivery removes the owner description in this actual component fixture, but adds **11,328B linked text**, +576B rodata, +552B data.rel.ro and a **1,416B** own delivery frame relative to B coarse. It is not a general animation/performance result. These new values happen to agree with historical e31 text/frame/ledger values; this is a fresh A-versus-final comparison, not a newly matched e31-versus-guard differential. Historical rodata differed by8B and keeps its original pin/path.

Cold capacity8 transport requested/retained832→144B (3→2 allocations). Whole ordinary bound owner requested7,624→6,936/retained6,396→5,708/peak6,564→5,876B; separately Remote16→8, Inbox56→24, boundWin80→48B; emptyWin remains8B. The projected typed binding adds8B inline versus final coarse. Capacity0/1/64 cold requested136/664/2176→80/88/592B. Requested heap, retained heap, interval peak and inline sizes are separate quantities; no RSS/stack-peak claim follows.

The safe queue still locks: send+stage+pop require three acquisitions for a one-message turn; staging amortizes over a batch, each pop locks, and empty/limited probes add acquisitions. Clone/drop also lock and perform Arc RMWs. The linked contended Mutex helper is231B/frame72 in both controls. Other new helpers include try_send373B/frame56, Clone245/frame40, Drop173/frame40 and lane apply1032/frame120; full calls remain in frame/body reports. We do not sum own frames into aggregate stack peak or claim lock-free/latency improvement. Sends, clone/drop and idle work allocate zero in the fixture; actual owner preparation still allocates as shown.

Capacity C means total accepted-undelivered items including the frozen prefix, tightening the former accidental up-to2C behavior. Capacity0 rejects sends; ZST bounds remain logical C. Callback-generated sends wait for a later turn. Failed checked delivery consumes only its failing item; committed prefix and remaining FIFO survive. All inbox producers and Questions revoke before any retired payload destructor can unwind. Sender death/status is emitted once after FIFO; no user callback or T destructor runs under the Mutex. Inbox's new automatic Sync implementation for Send payloads differs from Receiver's prior !Sync, while receiving remains owner-only through mutable APIs.

## Failures retained and source/support bill

No failure was relabelled as coverage: initial ArcStr rejection led to its narrow exemption; the first two text-map probes used the wrong borrowed GPUI view type; an initial downstream harness omitted proc-macro artifact directories and produced E0463; the first default build correctly rejected old Rc observer payloads; the first Hummingbird locked build101 exposed its missing normal dependency edge; an initial shell failed before its gate because Python was not on the narrowed PATH; the first native attempt hit the unchanged5s Xvfb readiness watchdog before any app ran. The separately approved replay kept that same5s startup deadline and all original app deadlines. All source/binary/logs remain under raw/. Initial full cost checkout was cleaned/corrected to sparse before any control compilation.

Machine counter: **31,232 shipping non-test/non-comment core lines**, +4 over e31, +248 over compatibility control30,984 and +245 over main602a30,987. It excludes vendors/dependencies/tests/tools, so the promoted production dependency and support are explicitly separate. The repair relative to e31 changes only GPUI manifest/value guard, runtime test observers, new public isolation tests and one HB lock edge. No runtime field, Box schema, unsafe implementation, lint suppression or mutable global production observer is added. Existing per-field schema ownership remains; no row-memory win is claimed.

`e31-to-isolation.patch` is the bounded successor; the prior full composite and compatibility/toolchain deltas remain in the historical delivery dossier. New source/control patches and the 180-line byte-identical nonshipping fixture inputs are archived separately. No main merge is performed here.

Sealed raw payloads over24KB use deterministic gzip. `file-index.json` records original and stored hashes/sizes; `external-artifacts.json` records the five frozen release ELFs, five full raw disassemblies and the actual native ELF symlink including its resolved hash. Complete selected GPUI/transport/Mutex/Arc function bodies are inside the archive. The full external disassemblies retain all linked allocator/platform/font bodies. Raw support is distinct from shipping source. No timing, native profiling hooks or Main mutation occurred.
