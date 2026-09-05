+++
title = "Migration, FAQ, and glossary"
description = "Move between GPUI variants with attention to crate names, platform setup, and API differences."
weight = 39
aliases = ["/guides/migration-faq.html"]
[extra]
category = "GUIDES"
legacy_source = "gpui-ce-docs/build/html/guides/migration-faq.html"
+++

Already know Zed’s GPUI? Lovely — you are 90% home. This page maps the deltas to the community edition, repeats the README’s FAQ faithfully, and defines the five words everyone trips over. Where Zed docs and this repo disagree, this repo wins.

## Zed-GPUI to gpui-ce deltas

Verified below means visible in `README.md`, `Cargo.toml`, `justfile`, or `flake.nix` in this checkout. Everything else we hedge as varying by platform/version.

- **It is a community fork, “mostly API compatible, but this is changing”** (`README.md:3-4`). Pin your version, read the changelog before upgrading, and expect gentle drift.
- **Crate renames are real.** The facade is `gpui-ce` (`Cargo.toml:190`: `gpui = { path = "./crates/gpui/", package = "gpui-ce" }`); the platform leaves are `gpui_ce_platform` (`Cargo.toml:191`), `gpui_ce_linux` (`Cargo.toml:192`), plus `gpui_ce_macos`, `gpui_ce_windows`, `gpui_ce_web`, and `gpui_ce_wgpu` in `[workspace.dependencies]`. You still write `cargo add gpui-ce` (`README.md:21`) and `use gpui::{…}` — the package is `gpui-ce`, the imports stay `gpui::`.
- **The entry point is `gpui_platform::application()`** (`README.md:17`, `gpui_platform.rs:13`), never hand-rolled `#[cfg]` platform selection. Web adds `web_init()` plus `application_with_web_backend()` (`gpui_platform.rs:31,51`), and `current_platform(headless)` (`gpui_platform.rs:57`) maps each OS to its backend (`gpui_platform.rs:60,66,73,79`).
- **Publish order and workspace shape are explicit.** The `publish` recipe (`justfile:393`) walks vendored support crates first, then core, then renderers and platform leaves, with `gpui_platform` LAST (`justfile:406`). Mirror or vendor crates in that order or dependency resolution sulks.
- **The dev environment is Nix-managed** (`flake.nix`): Rust toolchain with `wasm32-unknown-unknown` std, `cmake`, `pkg-config`, `fontconfig` and `freetype`, Linux GPU libs (`alsa-lib`, `libxkbcommon`, `vulkan-loader`, `wayland`, `xorg.libX11`, `xorg.libxcb` at `flake.nix:53-61`), macOS SDK hooks, plus `just`, `nushell`, `typos`, `taplo`, `cargo-machete`. `nix develop` should hand you a working build; exact behavior varies by platform/version of Nix.
- **MSRV is 1.92.0** (`justfile:9`, `msrv-check` at `justfile:169-173`). CI also covers fmt, clippy with `-D warnings`, doc tests, WASM stable plus nightly-atomics (`ci-wasm` at `justfile:332`), and examples.
- **Docs are being rebuilt right here.** The README still says “the best way to learn … is to read the Zed source code” (`README.md:49`) — this site exists to retire that sentence, one verified page at a time.

Migration checklist — run these four, in order:

```sh
# 1. Depend on the community package — `gpui` alone resolves elsewhere.
cargo add gpui-ce
# 2. Check native first, so OS errors surface before wasm noise.
just check
# 3. Then the web target, if you ship it (needs the wasm target installed).
just check-wasm
# 4. Full suite, no fail-fast — collect every breakage in one pass.
cargo test --workspace --no-fail-fast
```

1. Replace `gpui::Application` construction with `gpui_platform::application()`.
2. Delete `#[cfg(target_os …)]` platform picks in your code in favor of `current_platform`.
3. Rename `gpui_*` package references to `gpui_ce_*` where Cargo demands it (see `[workspace.dependencies]`, `Cargo.toml:190-198`).
4. Re-run under headless (`gpui_platform::headless()`, `gpui_platform.rs:23`) to smoke out platform-coupled tests.

> **Tip.** One file at a time beats one workspace at a time. Migrate your smallest binary first, keep its error list, and that list becomes your personal guide for the big crates.

## FAQ from README

**Where does work happen?** Join the Discord (`README.md:78`), file an issue, submit a PR. “Even the simplest of issues or worst PRs, we will work with, if you’re willing to rise to the occasion” (`README.md:82`).

**What is the long-term goal?** “To be the premiere Rust GUI library” (`README.md:86`). Roots in Zed’s work (“we will always pull their fixes”, `README.md:89`), ambitions beyond two apps’ use cases (`README.md:91`), GUI authoring “as simple as TUI and CLI development” (`README.md:91`), taking on Electron “with order-of-magnitude performance improvements and platform integrations” (`README.md:93`). That performance multiple is aspirational — measure your own app (see `performance`).

**How does gpui-ce compare to other forks?** “Other efforts (namely WGPUI) … have diverged … They typically serve the interests of the projects that they’re used within … GPUI-CE focuses on stability, and continuously monitors the other forks for good ideas” (`README.md:96`).

**What do I need on macOS?** Xcode plus the Xcode CLT, `xcode-select --install`, then `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer` (`README.md:58-74`). Launch Xcode once to install macOS components.

**How do I learn the APIs?** Today: Zed source plus Discord plus the blog (`README.md:49`). Increasingly: this site, `cargo doc` (`just doc`), and `crates/gpui/examples/` (`window_movable.rs` and friends).

## Glossary

- **Entity.** Owned app state behind a smart-pointer handle (README: “similar to an `Rc`”, `README.md:29`). Create it with `cx.new`, mutate it in `cx.update`, watch it with `cx.observe`. If it must outlive the window, hold a `WeakEntity`.
- **Element.** Low-level imperative building block (`README.md:33`; `crates/gpui/src/element.rs`). Owns layout and paint for itself and its children. `div`, `img`, `canvas`, and `uniform_list` are all elements.
- **View.** An `Entity` that can render (`README.md:31`): implement `Render` and return fresh elements each frame. Views are where your state meets pixels.
- **Context (`Context<T>`, `App`, `Window`).** Your handle to GPUI services (`README.md:35`): `Context<Self>` inside a view (notify, spawn, observe), `App` for global state and windows, `Window` for per-frame input, focus, and dispatch. Tests receive `TestAppContext` (`app/test_context.rs:18`).
- **Action.** A user-defined struct turning keystrokes into logical ops (`README.md:42`; [crates/gpui/src/action.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/action.rs)). Declare it with `actions!` or `#[derive(Action)]`, bind it with keymap entries (`keymap.rs:309-311`), handle it with `on_action`. Unbound keys do nothing — loudly nothing, silently.

> **Pitfall.** Mixing up `Entity` and `Element`. The `Entity` is the state that lives on; the `Element` is the pixels that rebuild every frame. If your click handler mutates pixels instead of state, re-read this glossary with tea.

## Against the field

|  |  |  |  |
| --- | --- | --- | --- |
| **Dimension** | **GPUI-CE** | **Electron / Tauri** | **Iced / Dioxus** |
| UI language | Rust views + tailwind-style props + elements | HTML/CSS/JS in a webview | Rust-native widgets (Iced) / web-tech components (Dioxus) |
| Rendering | GPU scene graph (wgpu core; Metal/DirectX native paths) | Browser compositor; exact GPU path varies by platform/version | Varies by backend/version |
| Distribution | Native binary per OS + WASM canvas build | Bundled runtime (Electron) / system webview (Tauri) | Native binary / web build depending on setup |
| Maturity | Community fork, docs in active construction | Large ecosystems, long histories | Active ecosystems, different control sets |

Table 24: Capability-level comparison, hedged where the truth is version-shaped.

## Try it

1. Migrate one Zed-GPUI file: swap the entry point, rename the package, run `just check`. List every error — that list is your personal migration guide.
2. Explain `Entity` vs `Element` vs `View` to a colleague in three sentences. If you needed four, re-read the glossary.
3. Find one claim this page hedged (“varies by platform/version”) and verify it on two targets. File the result as a docs PR.

> **Note.** Next step: open `Cargo.toml:190-198` and confirm your own `gpui-ce` version pin — then go build something small and joyful.

## Sources

- Fork stance + FAQ: `README.md:3-4,21,29,31,33,35,42,49,58-74,78,82,86,89,91,93,96`
- Workspace renames: `Cargo.toml:190-198`
- Entry points: `crates/gpui_platform/src/gpui_platform.rs:13,23,31,51,57,60,66,73,79`
- Publish order: `justfile:393,406`; MSRV: `justfile:9,169-173`; wasm CI: `justfile:332`
- Nix libs: `flake.nix:53-61`
- Actions + keymap: [crates/gpui/src/action.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/action.rs), `crates/gpui/src/keymap.rs:309-311`
- Test context: [crates/gpui/src/app/test_context.rs](https://github.com/gpui-ce/gpui-ce/blob/main/crates/gpui/src/app/test_context.rs)
