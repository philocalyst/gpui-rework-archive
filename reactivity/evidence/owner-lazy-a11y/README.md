# Owner-lazy native accessibility action transport

Shipping source: `157b995e7ee6d184aa7327bfce229d8ef5b7edda`, based on `7a5e1619a2`. Final test source: `112c27e728ffad16e31ce19b238ef22c5634f10c`. The producer is `/tmp/gpui-a11y-owner-channel-sol`; external captures are `/tmp/gpui-a11y-owner-channel-captures`. No public API, dependency, lockfile, vendor, or unsafe changes. SourceTween remains separately frozen and unadopted.

The owner constructs the existing bounded action channel only inside an active adapter update factory, after successful projection and immediately before returning the first real tree. It installs the receiver before publishing the sender through `OnceLock`. Skipped/inactive factories allocate no queue. Callbacks never initialize it: synthetic prepublication requests are discarded before payload decoding. Published actions retain capacity64, budget16, terminal overflow, checked activation sessions, and close revocation. Once initialized, the queue survives deactivation.

The final source also removes the global publication stamp. It did not identify an old provider arriving after the next generation was stored. Each command still resolves its exact window/site; dynamic input roots additionally require current presentation, registered field and immutable source lease. Position-bearing commands decode only never-recycled current geometry run IDs. Root-only intents carry no old text position. Observed source ABA retires roots; unpublished ABA restoring the exact acknowledged empty lease intentionally preserves position-free authority. `authority.md` covers every command and boundary. No source or geometry lease is borrowed across threads.

## Source and support bill

The production patch changes one file, physical +51/−44. Syn/Tokei noncomment, nontest core count is **30692→30686 (−6)**. Queue-only intermediate `b2440d0745c5604b038be3b4dc7da0a40cf5ffd4` is preserved, with +13 core lines and its original stamp checks. Final tests change four files, physical +596/−2, including the 284-line actual Registry failure fixture. Test/observer/client/codegen support is separate from shipping. `shipping.patch` and `tests.patch` are independently applicable to the stated base; no standalone Cargo patch requirements.

## Measured memory and layout

Cold ingress is one allocation/88B; the original eagerly installed ingress was three/4312B. Before first provider publication the final source removes **4224B and two allocations**. Installed transport is 512B smaller because queued commands shrink48→40B. Shared remains72B: the OnceLock increase replaces the removed stamp. Receiver and Option<Receiver> are both16B.

The matched cfgtest whole-window opening fixture reports 864→862 allocations, 197→195 live allocations, retained50586→46362B (**−4224B**), and **unchanged90734B peak**. Original execution paths requested209286→205063B (−4223B). The one-byte residual is the baseline/candidate argv0 pathname length: Winit clones it for WM_CLASS. Replaying both frozen executables at the same physical path yields209251→205027B (**−4224B**), with the same retained/peak/counts. Both raw pairs are retained; no equality was forced.

Compiler production layouts are unchanged: Bridge/OptionBridge176B, Shared72B, Window<Empty>72B, NativeHost<Empty>528B, Win8B/OptionWin16B. The cfgtest Bridge208B contains32B of test counters and is not the production layout. These are requested/live allocator bytes and static layouts, not RSS or process-memory claims.

## Matched release code and stack bill

Controls use the same physical source/target path, actual compiler/config/flags/features/fixture lock, explicit release package cleaning on switches, and fresh:false checks. Flags include v0, tokio_unstable and emit-stack-sizes. Exact fingerprints and source guards are archived.

* Linked text −96B, rodata +128B, data.rel.ro +200B: these three sections total **+232B**.
* Ordinary dispatch code7524→7500B, frame3000B unchanged, one Instant::now call unchanged. Every NativeHost method frame is unchanged.
* Bridge::new code619→467B, frame200→136B. The original calls the channel constructor (code678/frame760); the final constructor does not.
* Bridge::drain code3112→3088B, frame1416→1432B: **+16B even on ordinary unpublished WorkReady**, reserved before its publication check. This cost is retained and not tuned away.
* sync code5550→5547B, frame744B unchanged. Borrowed factory capture80→96B (**+16B temporary**); active factory closure312B/frame184; first-init helpers73B/frame40 and170B/frame88.
* Action callback code1002→951B, frame168→152B. Adapter constructor code1522/frame280 is unchanged.

These are individual static frames and call edges, not a summed stack peak or speed result. No timing was run.

## Qualification, with exact attribution

All gates use unchanged production157. Default all-target534passed/10ignored across71harnesses and native library215passed/26ignored used test source `f180681fbdf4322c0cfc214ca75e2001f31dec01`. Final owner accessibility54passed/6ignored used `69b442fa3b0058b75471c5e397121d5d9bca6d66`. These owner tests include failed-L/old-P/repair and are distinct from actual provider coverage. X11 all-target Clippy-Dwarnings passed, including the final test-only additions. AppleARM64 and MSVC native library compilation passed with root config, unset generic RUSTFLAGS, and recorded actual target flags (MSVC crt-static/slim-errors).

Frozen native test binary at f180 passes late service activation, real D-Bus Unicode editing/selection/stale-provider/reactivation/owner replacement/destruction, checkbox role/state/action events, and cold no-session-bus Window. Real Registry replay covers Unicode extents/hit/reversed selection/caret/insert/delete, action and reactivation. Public ordinary Window publishes a real first tree and closes through WM_DELETE_WINDOW with exit0.

The final additional actual Registry fixture at112c uses ordinary Window::document and public routes only. EditableText queues unsupported 🚀; the public presentation-error callback observes Canvas::MissingGlyph. The original provider continues exposing seed and unchanged extents. Another old-provider edit is queued before the original Repair button Action; that callback asserts the failed logical `bad🚀` survived, proving the edit was rejected by source admission. Repair publishes new text authority, the old provider is rejected, and caret2 plus final value `done` are acknowledged. No owner.update/set, private Target seeding, or owner-side repair drives the workflow. Frozen binary SHA256 is `f93cb64a3da6db28b77ba67587d60d93018c3420d2a96bd87971530a3530e8f4`; source guards match before/after. One actual test passed, separately from the54-case owner suite.

Preserved negatives: the first157 suite had52passes/one failure from a second stale Queued48 size assertion, corrected only in tests. A Registry launcher using --a11y=1 without memory settings stalled at deactivation; the identical frozen binary passed under the repository launcher policy (--a11y=0/GSETTINGS_BACKEND=memory), without enlarging deadlines. The first two new failure fixtures incorrectly waited for a replacement provider after failed-L; both hit their30s watchdog, while traces showed the actual presentation error. Warm unchanged P correctly publishes no replacement. Correcting that expectation alone produced the final passing proof. All failed sources, frozen binaries, logs and corrected scripts remain separately identified.

`summary.json`, `capture-manifest.json`, and `captures.tar.gz` contain source-qualified ledgers, compiler artifacts/fingerprints, assembly/call-chain records, runner/observer patches, platform source pins and client outputs. Large frozen ELF binaries and full ELF JSON stay external with hashes; compact GPUI frame inventories are archived. Historical draft/sealer output is excluded. There is no native timing, foreign runtime, RSS, total stack high-water, animation, or projected-source claim.
