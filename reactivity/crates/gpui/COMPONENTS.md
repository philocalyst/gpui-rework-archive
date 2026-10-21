# Contained stateful components

`Component<Parent, Child>` declares a typed path to ordinary parent-owned state.
The child retains the public `View::view(&self) -> El<'_>` API, its own source
schema, and handlers such as `.on_click(Counter::increment)` or
`.on_click(Counter::COUNT.update(|count| *count += 1))`.

```rust,ignore
const LEFT: Component<Pair, Counter> = Component::new(
    FieldId::new(1), "left", |pair| &pair.left, |pair| &mut pair.left,
);
const RIGHT: Component<Pair, Counter> = Component::new(
    FieldId::new(2), "right", |pair| &pair.right, |pair| &mut pair.right,
);
impl View for Pair {
    fn sources() -> Sources<Self> {
        Sources::new().component(LEFT).component(RIGHT)
    }
    fn view(&self) -> El<'_> {
        row((LEFT.view(self), RIGHT.view(self)))
    }
}
```

The compiled example is [tests/components.rs](tests/components.rs). IDs and names
are local to a parent's schema; two instances reuse the same child field IDs.
Nested schemas receive checked, disjoint scope ranges. The runtime retains an
8-byte `(scope ordinal, local field ID)` key, never a model address. `FieldId::get`
returns the local ID; qualified keys are not durable or cross-window capabilities.
Source serialization persists ordinary model values. Restoration rebuilds schemas
and remints Target authority.

Registration checks shared/exclusive projector agreement before View runs. Every
handler invocation also validates its registered shared path, then checks the
exclusive path before exposing mutable child state. Mismatches return binding
errors before source epoch advancement; application projector/callback panics
quarantine the parent owner. Projectors must be pure, stable selectors of the same
field. Address comparison is a consistency check under a borrow, not a proof of
arbitrary application purity or a source of exclusive access: only the declared
`fn(&mut Parent) -> &mut Child` grants that access.

`component` conservatively refreshes the parent after child edits. This preserves
parent branches and formatting over child state, even if the child declares its
field direct. `direct_component` explicitly promises the parent has no ordinary
snapshot dependency outside the child description/direct operands. A direct path
at every ancestor plus a child `direct` source allows a field action or text edit
to patch its own destinations without invoking any View. A child `field` source
still refreshes the owner. Arbitrary child methods always use the parent's
scheduling grain, so unrelated child views may run.

Visual parentage does not grant model ownership. Checked typed boundary guards
qualify the full owner path, including when `LEFT.view(self).child(RIGHT.view(self))`
visually nests two sibling owners. Changing the explicit owner at a retained site
remounts that subtree and revokes old Targets rather than silently redirecting them.

This is the contained-component primitive permitted by PLAN's ownership model.
It is not the future scope-owned, generational `Entity<T>` slab or an independent
child scheduler. Static contained schemas must terminate and be acyclic; admission
bounds their projection depth to 128. Dynamic optional/list ownership, queued
cross-owner sends, structural journaling and component-source setters are separate
work. Ordinary application schema/view construction must itself terminate.

## Current cost ledger (x86_64)

| Item | Bytes / allocation |
|---|---:|
| Static Component descriptor | 40; no model ownership |
| Qualified FieldId | 8, previously 4 |
| Sources header | 104 |
| Registered component entry including child Sources header | 160, one box per declared component |
| Handler inline handle | 16, unchanged |
| Child route adapter | 56, one box per handler per containing boundary |
| Temporary boundary check | 56, one box per boundary per ancestor |
| El / DraftNode / Style | 176 / 160 / 96 |
| Boundary metadata header in each El/DraftNode | 8, absent boundaries allocate nothing |
| Retained owner scope field | one u32 per node |

Each real boundary owns one 24-byte metadata list cell; its chain is disposed of
iteratively. Registry vectors, source descriptor boxes, child-group vectors,
allocator overhead and existing retained text/layout storage are additional costs.
Method-item callbacks remain zero-sized; the component adapter is their added cold
allocation. Typed action payloads remain stored once inside their original route.
No component edge, Signal or retained node owns an Arc/Rc to model state.

Description wraps descendant routes at each containing boundary, so work scales
with node count times component nesting depth. Static projection validation uses
the existing pairwise source-alias check. Public source scans materialize one
owned key/revision vector; direct field dispatch does not scan or describe the
unrelated subtree. These costs are explicit initial implementation limits, not a
claim of independently scheduled components or an allocation-free description.
