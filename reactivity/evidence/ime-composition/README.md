# Scoped IME composition

This is an unadopted review candidate based on `ce79d00fb004859994c8574254bbd091e964a2d4`. Tested source is `a623ee8e3ff7ccfc2d0ea87ee97c8eee2e985a27`; review commit `21116abc62e2c305fbffdfe8492fefa2ba414d4a` has exactly the same tree and a direct ce79 parent. Main was not changed.

`ImeSession`, `ImeEvent` and `Win::ime_event` use ordinary exclusive window input. Preedit prepares immutable display text without writing Signal or advancing Source epoch. Repeated and empty preedits preserve the original replacement. Commit drops composition-only buffers and calls canonical `replace_input` once, retaining ordinary Source capacity policy. An ordinary editing key after empty preedit cancels that composition, restores its Source selection, and resumes the existing keyboard path. A no-op Input activation publishes cancellation too; ignored control text does not cancel it.

Authority checks include a checked process nonce, window/Target, FieldId, exact Source epoch and retained Source lease. Equal-byte external edits, rebind, blur, invalid input and cancellation revoke it. Candidate and presented snapshots retain their own display bytes, selections and marked ranges. Failed newer preparation cannot substitute mutable logical state into an eligible older ACK. No new unsafe code, dependencies, model addresses, Rc, Cell or RefCell were added.

Marked ranges and raw cursors use display UTF-8 bytes. Valid character boundaries inside combining or ZWJ graphemes are accepted; geometry and canonical selection choose the nearest grapheme boundary by byte distance, ties downstream. Invalid byte boundaries fail closed. Committed selection retains its existing grapheme rules.

Initial font selection uses `Window::text_font`, with `Win::recording_with_font` for recordings and `Win::set_text_font` afterward. WindowOptions remains Copy and 24 bytes. This selects an existing FontFace, without adding fallback. Tests include 73,036 bytes of genuine OFL Noto outlines, with pinned source/license hashes in `tests/fonts/ime/provenance.json`.

## Native and accessibility scope

The common native adapter accepts Winit IME events and uses cross-platform allowed/caret APIs. Cursor areas come from acknowledged physical geometry, including transforms, clipping and DPR. Pinned Winit 0.30.13 documentation/source establishes UTF-8 byte cursors, Commit without Preedit, and empty Preedit before Commit.

Requested or observed native turnover waits for a real Disabled event before another source is admitted. AboutToWait is not an acknowledgement. Backends that never acknowledge cancellation remain conservatively quarantined until window close; ordinary keyboard and explicit scoped IME remain available. Tests exercise normalized Winit callbacks in real X11 windows and compare complete server BGRX pixels. They do not synthesize an OS candidate engine.

AccessKit preview text, caret and runs describe acknowledged display bytes. A display lease different from current Source is read-only and has no Source edit authority; the actual AT-SPI EditableText method returns false. This is a stated limitation, not full IME plus editable accessibility parity. Neither physical AppKit input nor VoiceOver is qualified.

## Qualification

Results overlap where focused cases replay a larger suite; do not sum those replays as independent coverage.

| Source/profile | Actual result |
|---|---|
| a623 Linux native GPUI library and all integration suites calling `Win::key`, plus property selection | 414 passed, 0 failed, 33 ignored; 13 frozen executables |
| a623 public IME, included above | 15 passed |
| a623 native focused fixtures | AccessKit, ownership, native/query/packet ledgers, and 9-stage X11 lifecycle/pixel fixture passed |
| a623 native wire | Genuine AT-SPI CJK/old-candidate ACK/commit fixture passed at DPR 1.25 |
| a623 scalar GPUI library/frontier/components/IME | 210 passed, 0 failed, 5 ignored; 4 executables |
| a623 GPUI/Canvas/GPU strict checks | All targets, all features, Clippy `-D warnings` passed |
| a623 documentation | 33 passed |
| a623 unchanged external consumer | 1 passed, locked/offline; the same assertion failed on 9e |
| a623 Mac affected contracts/adapters | Public IME 15, property selection 10, native IME/accessibility, runtime IME and geometry ledger passed; 3 frozen MachOs |

Each final Linux gate matched all 2,073 build-input hashes and helper hashes before/after. Actual Cargo JSON, executable identities and commands are retained. The final native executable contains the complete baseline-identical 18,995-byte WGSL and all eight SPIR-V artifacts; the exact validator accepts each artifact. Source inputs include Cargo/toolchain/config and vendored dependencies. Builds use pinned content freshness; changed GPUI was package-cleaned before the final test-only correction. Mac independently matches 2,073 source inputs and all three MachOs before/after.

Earlier fa36 broad qualification ran 109 executables: 1,056 passed, 1 failed, 42 ignored. Canvas passed 258 cases, including all 48 density cohorts and exhaustive Unicode coverage; GPU passed 71, including 56 readbacks. GPUI's sole failure was the old Window builder expectation (208 versus actual 216), corrected and covered by final property-selection tests. This is predecessor coverage for unchanged Canvas/GPU source, not a claim that the entire 109-executable suite ran again on a623.

The earlier full Mac 9e suite ran 71 MachOs: 723 passed, 3 failed, 12 ignored. Its known Darwin first-lock allocation failures remain charged: `future_wrapper_has_no_result_slot_or_poll_allocation`, `preallocated_frozen_prefix_has_no_per_message_allocations`, and `preallocated_transport_and_idle_turns_do_not_allocate`. Final affected Mac checks do not erase those baseline failures. Apple ARM and Windows MSVC metadata checks also passed on the earlier native implementation; no Windows runtime parity is claimed.

## Costs

Seven-library shipping inventory is 35,755 lines versus ce79's 34,852: **+903**, excluding tests/comments/vendors and counting the helper once. The keyboard correction adds 19 lines over 9e. Cargo, lockfiles and dependencies are unchanged; the existing EcoVec dependency still costs 2,315 separately charged lines.

| Value/header | Measured bytes |
|---|---:|
| Cold Editing | 96 → 104 |
| TextResources | 120 → 128 |
| NativeHost<Todos> | 752 → 768 |
| Window<Companion> builder | 208 → 216 |
| Borrowed query Context stack value | 128 → 136 |
| Part | 16, unchanged |
| ImeSession / ImeTarget / native Bridge | 8 / 32 / 48 |
| Public ImeEvent / MarkedText | 40 / 48 |
| Ime / Active / Preview / MarkSnapshot | 88 / 56 / 120 / 40 |

Runtime, Node, TextSite and Presented add no fields. The native bridge allocates lazily; its 48-byte quarantine can survive until Disabled/window close, without retaining a composition String. The global nonce costs eight static bytes and one checked Relaxed atomic update per Enabled. The final key path adds a transient optional PresentationToken snapshot; optimized stack size was not isolated.

After ordinary selection, Enabled adds two allocations retaining/peaking at 144 requested bytes. Promoting 25 text bytes uses one 41-byte allocation. A measured 24-byte preedit reuses its 24-byte String capacity on cursor-only and smaller updates; after ACK, display strong count is two and Source strong count three. SharedText clones/drops retain their existing reference-count work, including the temporary previous-display lease during update. No reference-count elimination is claimed.

Changed display text is assembled contiguously and copied once into immutable ArcStr because the existing Parley planner consumes `&str`. Cursor-only equal display bytes reuse the lease. Charge full physical String capacity and geometric spare, plus up to three distinct immutable L/old-C/old-P displays during preparation. Cancellation drops active buffers immediately; older C/P leases live until their actual ACK lifetime ends. The logical 32 KiB admission bound is not a physical-capacity bound. Commit drops assembly before canonical Source allocation.

The first-preedit calling-thread workload measured 265 allocations, 122,770 bytes allocated, 5,782 retained and 53,250 peak. It includes shaping/scene work, excludes parallel-worker allocations and is not a universal peak or latency result.

The matched ce79→fa36 debug2 qualification ELF grew 24,485,920 bytes, with executable sections growing 4,543,504 bytes; this includes tests and fonts. The separate matched 9e→a623 debug0 unit-test ELF grows 56,352 bytes (172,583,544→172,639,896), including the expanded native fixture. Neither isolates optimized shipping machine code. No performance claim is made.

## Retained failures and artifacts

Three compiled one-line mutants fail actual assertions: removing epoch authority admits `samelate` after equal external edit; using candidate marks in P leaks range 4..10 over old `baseé` instead of 4..6; retargeting a requested native stream before Disabled writes `late` into the next field after AboutToWait.

An external consumer exposed a real 9e bug: Enabled → Preedit("x") → Preedit("") → ordinary Text("!") left `base`, rather than `base!`. Its unchanged fixture passes on a623. The first correction attempt, 9310, retained 13 passes and two incorrect new assertions: empty Text was treated as a no-op, and a superseded ACK was expected to succeed. Correct tests use Input Enter and explicit `StalePresentation`; production correction is unchanged.

[Result and artifact receipts](result.json) include exact commands, profiles and hashes. The final remote artifact archive contains 18 positive and one negative actual executable, both exact source archives and identical consumer fixtures: **209,168,688 bytes**, SHA256 `518a6e17a76760c71bfe4ab9f1819ec81a312fcb47d8d6c33917a2cb2d2960d1`. Streamed re-extraction and original hashes match. The 9310 failed-test archive is retained separately. All raw failures, earlier font/fixture/setup corrections and immutable predecessor capsules remain available.

Authorized cache reclamation verified the preserved 9e source/ELF archive first, wrote deletion manifests, removed only 1,869 non-executable non-symlink rlib/rmeta/d/o cache files (1,666,608,167 bytes), then rechecked all 100 executable ELF hashes, 2,073 source files and all evidence/seal files. No executable, source or evidence was removed. All owned jobs and children are reaped; final remote free space is 9,553,330,176 bytes, above the 8 GiB floor. Root review and composed qualification are required before adoption.

Final Mac logs are collected at `/tmp/gpui-mac-collected-root-20261024/ime-a623/logs.tar.gz`: 117,229 bytes, SHA256 `a30ff304940adbdb473ca316727c9565a3fd28b7d4f9d77838d9ed5ce3a03ca1`. All 31 local log/metadata member hashes were independently rechecked; Root rehashed the three external actual MachOs against their receipts. See [Mac receipts](mac.json).
