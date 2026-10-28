# One payload buffer for bounded Inbox delivery

Status: isolated, unmerged safe-storage control. Production `5acdf79d410a27dc8efff0bb7c8266951c6e3c84`; final tests `45a294f1255706188e782c128c834707c5f9016f`; base `f9efa331398cbdd9c0bac45a9cce82139a81acbf`. Producer `/tmp/gpui-one-buffer-inbox-sol`. No schema/SourceValue/audio/GPU tree was changed.

The transport now shares one preallocated `VecDeque<T>` through `Arc<Mutex<State<T>>>`. The unique Inbox retains a frozen-prefix length and terminal state. Staging advances only that prefix; applying pops before releasing the lock and calling the handler. A callback enqueue therefore waits for a subsequent turn, while a checked rejection consumes only its rejected item and leaves the frozen FIFO for smaller-budget continuation. No temporary payload collection, callback queue, new public receiving API, unsafe code or dependency is introduced.

`C` explicitly bounds queued accepted values including frozen backlog. This tightens the old accidental transport-C plus staging-C headroom. A currently popped delivery frees its slot before callback execution. Zero rejects sends with Full; ZSTs use the logical C, never VecDeque's allocation capacity. Terminal metadata is frozen once after producer death/FIFO and consumed before its callback runs.

An explicit producer count is updated under the same mutex by Clone/Drop. Arc reference counts do not decide sender death. Last producer drop unlocks before signalling. Native attachment installs the existing Wake then signals, covering pre-bind sends/death and attachment races. Native and headless now use the same ownership structure.

Revocation marks admission closed and detaches the existing queue under lock. Static nested retirement tuples collect every Inbox/Question cancellation before any detached user payload is dropped. No handler or queued T destructor executes under the mutex. Tests cover reentrant destructors, abandoned Inbox, payload-drop panic, callback-fault quarantine, and two active Question Completion leases becoming cancelled before an outer retired payload can unwind. Public headless Win constructs Questions first then appends Inbox lanes; its API cannot reverse that order. Native Window::questions can wrap an existing Inbox; that reverse active nesting is covered by the recursive implementation argument, not claimed as a new runtime fixture.

Every applied success takes three mutex acquisitions: send, stage, pop. Owner-side consumption takes two, plus empty/limited probes. Clone/drop each lock and perform Arc refcount operations. A preempted holder can delay sender/UI work. This is not lock-free and has no latency/throughput/RSS claim. Inbox becomes Sync for T:Send (previous Receiver prevented Sync); it remains unique, non-Clone, with no public shared-reference receiving operation. A Send/non-Sync Receiver payload compiles in the public trait control.

## Measured storage and source bills

Stable Rust1.97.1/LLVM22.1.6, root config, flags/bootstrap unset, offline/locked, jobs1. Default release matched observer uses identical source/lock/features/path/compiler and opt3. Each gpui/observer artifact is fresh:false; release package cleaned before source switches. Input guards match. Capacities are u64 values. Counts are allocator requests/retention, not RSS.

| Default cold capacity | Previous bytes | One-buffer bytes | Previous/new allocations |
|---:|---:|---:|---:|
|0|136|80|1 / 1|
|1|664|88|3 / 2|
|8|832|144|3 / 2|
|64|2176|592|3 / 2|

At C8 the actual whole owner retains 6396→5708 requested heap bytes, reaches 6564→5876 requested-byte peak, and has inline Owner80→48B. Remote16→8, Inbox56→24; empty Win remains8B. All observed coarse apply allocation ledgers are identical (10 allocations/940 requested/832 peak); send/clone/idle allocate zero. Close releases the new payload buffer with Remote still held, whereas old channel/staging storage remains allocated until its handles retire.

The exact native debug cold fixture separately measures C8: 912→184B,4→2 allocations; Remote8→8, Inbox64→24, Lane80→40; empty Win8; binding0alloc. New Shared104/State56. Old native ELF is Root's exactf9 artifact, executed read-only with supplied source/binary guards; this is not a matched native release machine-code result.

Six-library shipping counter:31206→31218, **+12 non-test/non-comment core lines**. No line-count reduction is claimed. Public tests add410 physical lines (394 new storage fixtures plus16 in source_inbox). Archived nonshipping support is183 physical lines:52 fixture,14 guard, and three39-line replay scripts. Source/test patches and machine counter outputs are separate; no observer code is shipping. New production is three files: remote.rs, reader/question.rs, runtime/turn.rs. Public callback arity/ownership and ordinary Win representation are unchanged.

## Codegen control and preserved negative

`baseline-storage-control`, `candidate-storage-control`, `capability-storage-control` and full asm/symbol/section dumps are distinct immutable files. Same public fixture is archived as support. The first one-buffer732 control hid the ordinary handler's always-None identity after Lane.apply outlined: linked.text+4144B; delivery2954→10277B and frame392→1304. It is preserved and rejected.

The final static FIELD_EDITS capability means only “this sealed chain may report an exact source identity.” FieldAction is true; ordinary/status false; Lane/Question wrappers OR their existing children. Immediately after apply, an impossible exact identity becomes None before BOTH Question refresh and source admission. Mixed chains retain actual dynamic accumulation. No inlining attributes or new retained fields are used.

Final matched default release: linked.text3685399→3676215 (−9184), rodata−504, data.rel.ro−176. Ordinary wrapper150B/frame136 and its Win.update793/frame184 remain unchanged. Delivery wrapper250/frame264 unchanged; delivery callee2954→2991B (+37), frame392→472 (+80, retained as a real opt-in cost). New helper callees and old std-channel callees are archived: small wrapper bodies alone are not a win. Frame values are individual fixed reservations including saved registers, not an aggregate stack peak. No performance timing was run.

## Qualification

Final production plus45 tests: native638 passed/61 harnesses,35ignored; default/native all-target strict and changed-file format checks pass; AppleARM64 and MSVC native library checks pass using installed Rust1.97 source/std build (-Zbuild-std with bootstrap explicitly enabled for that cross-build purpose, not a shipping language requirement). Host production gates use bootstrap unset. Final default full result is 573 passed/61 harnesses,10ignored. Earlier732 full default572/61 and final production focused243/9 remain separate controls.

Actual X11 entrypoints cover8 native wake/repair/prebind/postbind/quiescent cohorts.732 passes are separate. Final replay attempt1 expired at the unchanged5s Xvfb readiness watchdog before any GPUI executable ran; log/fixture are retained. Root-authorized distinct v2 with unchanged5s server/15s application deadlines passes all3 entrypoints/8 cohorts, source/ELF guards match, display reaped. No timing inference is made from test-framework elapsed output. One initial strict error was a test observer returning a large DeliveryError; the committed observer now returns unit, with no allow or production change.

Commands, all before/after input hashes, actual Cargo fingerprints, compiler identities, raw failures/passes, exact source/test patches and external ELF hashes accompany the final archive. No main integration or benchmark authorization is implied.

## Reproduction and archive boundaries

The final default/native/strict/cross source guards are in `raw/`; the command JSON/logs retain actual Cargo profiles and flags. `qualification.json` gives parsed harness totals and equal before/after pairs. `support/storage_control.rs` is the single matched default release fixture. Control worktree `/tmp/gpui-one-buffer-inbox-control-sol` has baseline46f121b954, initial732 overlay6e22ec9c54d13c469c39d39fda2d61de0efa379d, and final overlayfba3ed210655f9c7fa376434ee92fabc7b2c1b3a. Both gpui and fixture are freshly compiled on every release switch; the source guards disclose the exact changed files.

Host commands source `/tmp/gpui-native-env.sh`, unset RUSTFLAGS/CARGO_ENCODED_RUSTFLAGS/RUSTC_BOOTSTRAP, and use CARGO_BUILD_JOBS=1 with `/tmp/gpui-one-buffer-inbox-target`. All Cargo commands use `--manifest-path reactivity/Cargo.toml --locked --offline -p gpui`. Full default: `test --lib --tests --message-format=json`; native adds `--features x11`; strict: `clippy --all-targets [--features x11] --message-format=json -- -D warnings`. Cross uses `RUSTC_BOOTSTRAP=1 cargo -Zbuild-std=std,panic_abort check --lib --features native --target {aarch64-apple-darwin,x86_64-pc-windows-msvc}` with generic flags unset and installed sources. No shipping toolchain/config/dependency was changed.

`patches/production.patch` is only the three production files versus f9; `patches/tests.patch` is only the two public test files. The initial732 production patch is retained separately. The native harness scripts show exact commands/unchanged deadlines. Preserve the failed first Xvfb launch and initial strict error as failed attempts, not passed application results. The displayfd-buffer hypothesis probe did not reproduce its hypothesis and is not a diagnosis.

Full immutable ELFs and complete disassembly stay at `/tmp/gpui-one-buffer-inbox-captures`; `external-files.json` hashes them. They are not stored in Git. Selected caller/callee assembly, section/symbol dumps, original logs, compiler/Cargo identities, source/test patches and hashes are archived here. Raw logs are deterministic gzip files (mtime0), named after their original files. There was no performance timing, native release comparison, or claim that these small control ledgers predict whole-application peak/RSS.
