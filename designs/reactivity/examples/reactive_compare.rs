//! `#[reactive]` versus its own lowering — the gate 3 fixture (07 §5, §17.3).
//!
//! One component, written twice with identical fields and identical pixels:
//!
//!   - `sugared::FilterPanel` — ordinary Rust plus the one optional attribute;
//!   - `lowered::FilterPanel` — the exact no-macro form the attribute expands to, by hand.
//!
//! The point of reading them side by side:
//!
//!   1. The macro is *bulk syntax removal only*. Every lowered line exists in 07/11/12 without
//!      it: direct ports (§4), `Sources::project` regions built from an inherent `&self` method
//!      on single sources — never a parenthesized borrow (12 §5) — and owned captures. Same
//!      kernel descriptors, byte-identical (gate 6).
//!   2. Removing the attribute changes SCHEDULING COUNTERS, never pixels, state, focus, events,
//!      or drop order (gate 3). The test at the bottom is that sentence as code.
//!   3. What the macro deliberately does NOT do: see through an opaque helper (both forms get one
//!      owner-grained region), or turn a `Reader<T>` field read into hidden suspension (§5, §7.1).
//!
//! This also exercises 14 §1's element model: `view` returns the concrete `El<'_>` (views are
//! branched on by definition); helpers that stay open to composition return `impl Element + '_`;
//! the `Mode` match and the open/collapsed branch are exactly the case 07 §2 restores — different
//! calls to the same nominal `El<'a>` type unify with zero ceremony, no `el(…)` join (14 §1.2
//! deletes it; there is nothing left for it to do here).
//!
//! This is a syntax sketch against 07/11/12/13; it is not expected to compile against current
//! GPUI.

use gpui::prelude::*;

#[derive(Clone, Copy, PartialEq)]
enum Mode {
    Simple,
    Advanced,
}

struct Preset {
    name: String,
}

// Helpers shared by both forms. Each is joined against a DIFFERENT helper's opaque return type
// below (`simple_form` vs `advanced_form` in the `Mode` match; `dialog(…)` vs `collapsed_hint()`
// in the open/collapsed branch) — a helper-opaque-type join is exactly the case 14 §1.2 keeps
// `El<'_>` for (own code hitting that join changes the helper's return type, it does not reach
// for `el(…)`/`.into()`). So all three are branch-friendly `El<'_>`, not the leaf `impl Element`.

fn simple_form(query: &Signal<String>) -> El<'_> {
    column((
        text_input(query),
        text("Enter to apply").text_xs().text_muted(),
    ))
    .gap(8)
}

fn advanced_form<'a>(query: &'a Signal<String>, limit: &'a Signal<u32>) -> El<'a> {
    column((
        text_input(query),
        row((text("Limit").text_sm(), slider(limit).range(0.0, 500.0).step(10.0))).gap(8),
    ))
    .gap(8)
}

fn collapsed_hint() -> El<'static> {
    text("Press / to filter").text_sm().text_muted()
}

/// The `Mode` match joins `simple_form`/`advanced_form`, and the open/collapsed branch joins
/// `dialog(…)` against `collapsed_hint()` — both are the one case 14 §1.2 keeps a named type for:
/// two different opaque HELPER return types meeting in one expression. Because all three helpers
/// above are declared `El<'_>`, the `if`/`match` below unify with zero ceremony and no `el(…)`
/// join (`El`'s lifetime is covariant, so `El<'static>` unifies fine with the `El<'a>` arms).
fn filter_body<'a>(open: bool, mode: Mode, query: &'a Signal<String>, limit: &'a Signal<u32>) -> El<'a> {
    if open {
        dialog(match mode {
            Mode::Simple => simple_form(query),
            Mode::Advanced => advanced_form(query, limit),
        })
    } else {
        collapsed_hint()
    }
}

// ════════════════════════════════════════════════════════════════════════════════════════════
// FORM 1 — the attribute. This is the same Rust that compiles without it (07 §5).
// ════════════════════════════════════════════════════════════════════════════════════════════

mod sugared {
    use super::*;

    pub struct FilterPanel {
        pub query: Signal<String>,
        pub limit: Signal<u32>,
        pub open: Signal<bool>,
        pub mode: Signal<Mode>,
        pub matched: Signal<usize>,
        pub presets: Vec<Preset>, // plain owner state: changes rerun the owner, and that is fine
    }

    impl FilterPanel {
        fn toggle(&mut self) {
            *self.open = !*self.open;
        }

        /// Opaque helper: the macro does not pretend to see through this call (07 §5).
        fn status_line(&self) -> String {
            format!("{:?} filter", *self.mode)
        }
    }

    impl View for FilterPanel {
        #[reactive]
        fn view(&self) -> El<'_> {
            column((
                // (a) Already a direct port with or without the macro. The attribute changes
                //     nothing here — there is no "more reactive" version of this line.
                text_input(&self.query),

                // (b) Visible signal reads driving structure. The macro cuts this whole branch
                //     into one retained region with the exact edge list {open, mode}.
                filter_body(*self.open, *self.mode, &self.query, &self.limit),

                // (c) A mixed read: one signal (`matched`) + plain owner state (`presets.len()`).
                //     The macro cuts a region on {matched} and captures the len by value; a
                //     presets change reruns the owner and re-installs the region with a new len.
                text(format!("{} of {} presets", *self.matched, self.presets.len())),

                // (d) Opaque helper call: becomes one owner-grained retained region — the same
                //     scheduling it has in the lowered form. Extraction widens scheduling,
                //     never meaning (07 §5).
                text(self.status_line()).text_xs().text_muted(),
            ))
            .gap(12)
            .on_key(Key::Slash, FilterPanel::toggle)
        }
    }
}

// ════════════════════════════════════════════════════════════════════════════════════════════
// FORM 2 — the lowering, by hand. This is the normative meaning (07 §5.1) and the diagnostic a
// fix-it shows. Every construct below is public 07/11/12 surface; nothing is macro-only.
// ════════════════════════════════════════════════════════════════════════════════════════════

mod lowered {
    use super::*;

    pub struct FilterPanel {
        pub query: Signal<String>,
        pub limit: Signal<u32>,
        pub open: Signal<bool>,
        pub mode: Signal<Mode>,
        pub matched: Signal<usize>,
        pub presets: Vec<Preset>,
    }

    impl FilterPanel {
        fn toggle(&mut self) {
            *self.open = !*self.open;
        }

        fn status_line(&self) -> String {
            format!("{:?} filter", *self.mode)
        }
    }

    impl View for FilterPanel {
        fn view(&self) -> El<'_> {
            // (c') The mixed read, made explicit: freeze the owner-grained part as an owned
            // capture. When only `matched` publishes, the region reruns with this value; when
            // `presets` changes, the owner reruns and re-installs the region with a fresh one.
            let total = self.presets.len();

            column((
                // (a') Identical to the sugared form. Direct ports need no lowering.
                text_input(&self.query),

                // (b') The structural branch as an explicit typed region. Dependencies are the
                // tuple on the left — never ambient reads (tuple products keep the tuple form,
                // 12 §5). The closure receives committed references and contains unrestricted
                // Rust (07 §4).
                (&self.open, &self.mode).project(|(open, mode)| {
                    filter_body(*open, *mode, &self.query, &self.limit)
                }),

                // (c'') A single-source region feeding a property sink — an inherent `&self`
                // method, never `(&self.matched).project(…)` (12 §5).
                text(self.matched.project(move |m| format!("{m} of {total} presets"))),

                // (d') Byte-identical to the sugared form: an opaque helper is one owner-grained
                // region in BOTH. The macro had nothing to add here.
                text(self.status_line()).text_xs().text_muted(),
            ))
            .gap(12)
            .on_key(Key::Slash, FilterPanel::toggle)
        }
    }
}

// ── What the macro can NOT lower, in either form ───────────────────────────────────────────────
//
// A `Reader<T>` field read is not silently suspended. This does not compile with or without
// `#[reactive]` — a reader has no `Deref` (07 §7); the fix-it names `project`:
//
// ```rust,compile_fail
// fn view(&self) -> El<'_> {
//     text(&self.story.title) // ERROR: `Reader<Story>` has no field access / no Deref
// }
// ```
//
// The normative spelling at the first async consumer, identical in both forms:
//
// ```rust,ignore
// self.story.project(|story: &Story| h1(&story.title))
// ```

// ── Gate 3 as an executable test: same pixels, different counters ──────────────────────────────

fn fixture<T: View>(panel: T) -> Win<T> {
    Win::demo(panel)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn seeded<F: FnOnce(Signal<String>, Signal<u32>, Signal<bool>, Signal<Mode>, Signal<usize>, Vec<Preset>) -> P, P: View>(
        build: F,
    ) -> Win<P> {
        fixture(build(
            Signal::new(String::new()),
            Signal::new(100),
            Signal::new(false),
            Signal::new(Mode::Simple),
            Signal::new(0),
            vec![Preset { name: "Rustaceans".into() }],
        ))
    }

    #[test]
    fn identical_pixels_and_semantics() {
        let sugared = seeded(|query, limit, open, mode, matched, presets| sugared::FilterPanel {
            query, limit, open, mode, matched, presets,
        });
        let lowered = seeded(|query, limit, open, mode, matched, presets| lowered::FilterPanel {
            query, limit, open, mode, matched, presets,
        });

        for win in [&sugared, &lowered] {
            win.key(Key::Slash); // open
            win.type_text(win.root().query, "rust");
        }

        // Pixels, focus, event order, and state agree exactly (gate 3).
        assert_eq!(sugared.scene_digest(), lowered.scene_digest());
        assert_eq!(sugared.focused_role(), lowered.focused_role());

        // Only the work counters differ: the macro cut branch (b) and label (c) into regions,
        // so a `matched` publish reruns zero owners in both forms, but a *mode* flip reruns the
        // owner only where no region was installed for the opaque helper's dependencies.
        assert!(sugared.counters().owner_reruns <= lowered.counters().owner_reruns);
        assert_eq!(sugared.counters().region_descriptors, lowered.counters().region_descriptors,
            "gate 6: handwritten regions are byte-identical to macro-lowered ones");
    }
}

fn main() {
    Application::run(
        Window::document(sugared::FilterPanel {
            query: Signal::new(String::new()),
            limit: Signal::new(100),
            open: Signal::new(false),
            mode: Signal::new(Mode::Simple),
            matched: Signal::new(0),
            presets: Vec::new(),
        })
        .title("Reactive vs Lowered")
        .size(420, 360),
    );
}
