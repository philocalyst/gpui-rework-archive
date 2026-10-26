//! Identity is a value: `Target<K>` — Copy, 4 bytes, no enum, no derive, anywhere.
//!
//! Wiring identity is a **field** — declared with the state, bound by one element per
//! describe, passed around by value (`Target<K>` is `Copy`: copying a *name* is harmless;
//! binding is the identity act, and double-bind is a located error). It cannot go stale:
//! binding is re-asserted by each describe, and a claim against an unbound target parks /
//! Miss-attributes (07 §11) — no `Option`, no `Result`. Default focus is `.focus_default()`.
//! Tests hold typed `Win<V>` handles and reach parts through `win.root()` (07 §12); external
//! tooling uses semantic role+name locators; the inspector labels targets by bind site.
//!
//! `Target<K>` is `Copy`, so target-only helpers need no lifetime. A helper that also borrows
//! a `&Signal`/`self` returns an element borrowed for `'_` (`impl Element + '_`) and shares this
//! turn's frame; one that borrows only `Copy` targets is never branched over either, so it takes
//! the lifetime-hiding leaf spelling `impl Element` — no `'static` to write out (14 §1.2). Erased
//! target values are `AnyTarget` — never `TargetHandle`/`TargetRef` — and every param that accepts
//! one spells `impl Into<AnyTarget>` (12 §8).

use gpui::prelude::*;

struct Suggestion {
    id: u64,
    label: String,
}

pub struct Typeahead {
    query: Signal<String>,
    open: Signal<bool>,
    hits: List<Suggestion>,
    /// The parts ARE the public surface. `pub` is the export mechanism —
    /// no `export(..)`, no `.at(..)`, no enum of parts, no derive.
    pub input: Target<TextInput>,
    pub popup: Target<Popup>,
}

impl Typeahead {
    fn new() -> Self {
        Self {
            query: Signal::new(String::new()),
            open: Signal::new(false),
            hits: List::new(),
            input: Target::default(),
            popup: Target::default(),
        }
    }
    fn changed(&mut self, _q: String) {}
    fn hit(hit: &Suggestion) -> impl Element + '_ {
        text(&hit.label)
    }
}

impl View for Typeahead {
    fn view(&self) -> El<'_> {
        // One child verb: the popup stacks over the anchor in the anchor's own coordinate
        // space, out of flow, no `.overlay(…)` (13 §3.3).
        anchor().child(
            text_input(&self.query)
                .target(self.input) // binds the value identity (once per describe);
                // the inspector labels it by THIS line (#[track_caller])
                .focus_default() // focusing &self.typeahead lands here, not the chrome
                .on_change(Typeahead::changed),
        ).child(
            popup(&self.hits, Typeahead::hit)
                .target(self.popup)
                .open(&self.open),
        )
    }
}

struct SearchPage {
    query: Signal<String>,
    /// Split helpers wire through these fields — no enum, no name scope, no resolution pass.
    search: Target<TextInput>,
    find: Target<Button>,
    typeahead: Typeahead,
    tooltip_anchor: Option<AnyTarget>,
}

/// Not in the same function as the Find button. The *field* is the wire. Borrows the signal
/// for the frame, so it names one lifetime shared with the returned element.
fn query_field(query: &Signal<String>, t: Target<TextInput>) -> impl Element + '_ {
    text_input(query).target(t)
}

/// Copy targets pass by value: no lifetimes on target-only helpers.
fn find_button(find: Target<Button>, search: Target<TextInput>) -> impl Element {
    button("Find")
        .target(find)
        .focuses(search) // compile-checked: Target<TextInput> — a Popup won't typecheck
}

/// Reusable: does not name a page. Element lives as long as the passed target ref.
fn find_for(target: impl Into<AnyTarget>) -> impl Element {
    button("Find").focuses(target)
}

/// Chrome around an input. Tab / `.focuses` on this row hits the field, not the icon.
fn decorated_field(query: &Signal<String>) -> impl Element + '_ {
    row((icon(Magnifier), text_input(query).focus_default())).gap(8).items_center()
}

/// Lexical, same function: the variable *is* the target — no Target field needed.
fn find_bar(query: &Signal<String>) -> impl Element + '_ {
    let search = text_input(query);
    let find = button("Find").focuses(&search);
    row((text("Query").labels(&search), search, find)).gap(8).items_center()
}

impl View for SearchPage {
    fn view(&self) -> El<'_> {
        column((
            // Split helpers, same owner — the Target field replaces BSN #Name.
            row((
                query_field(&self.query, self.search),
                find_button(self.find, self.search),
            ))
            .gap(8),
            find_bar(&self.query),
            decorated_field(&self.query),
            row((
                &self.typeahead,
                // Focusing the View lands on its .focus_default() — no part naming needed.
                find_for(&self.typeahead),
            ))
            .gap(8),
            // Cross-component part: pub target, plain field access, by value.
            text("Results stay under the field.").described_by(self.typeahead.popup),
            self.tooltip_anchor
                .map(|h| hover_card().place(below(h)).child(text("Pinned"))),
        ))
        .gap(16)
        .p(24)
    }
}

impl SearchPage {
    fn pin_tooltip(&mut self, handle: AnyTarget) {
        self.tooltip_anchor = Some(handle);
    }
}

fn page() -> SearchPage {
    SearchPage {
        query: Signal::new(String::new()),
        search: Target::default(),
        find: Target::default(),
        typeahead: Typeahead::new(),
        tooltip_anchor: None,
    }
}

/// Tests hold a typed `Win<V>` and spell targets through `win.root()`, exactly like views do
/// (07 §12). Every driver method (`type_text`, `click`) is a turn barrier: it dispatches, drains
/// work, and commits before returning — so assertions need no `settle`, sleep, or scene walk.
/// Targets are `Copy`, so `page.click(page.root().find)` is legal two-phase-borrow Rust.
#[test]
fn find_focuses_the_field() {
    let page = Win::demo(page());

    page.type_text(page.root().search, "kan"); // seed through the field, like a user
    page.click(page.root().find);
    assert!(page.focused(page.root().search));

    page.type_text(page.root().typeahead.input, "ban"); // K-typed: demands Target<TextInput>
    assert!(page.root().typeahead.hits.len() > 0); // committed state read (List derefs to [T])

    // External drivers use semantic locators — which double as an a11y audit:
    page.role(Button, "Find").assert(Visible);
}

fn main() {
    Application::run(Window::document(page()).title("Identity").size(520, 360).centered());
}
