# Macro-free trait composition experiments

This crate isolates the Rust type-system side of reflected selector composition. It has no dependencies and does not change GPUI production APIs.

## Findings

Stable Rust can express a reusable multi-trait proof with an ordinary umbrella trait:

```rust
trait DraggableBadge: Draggable + Badge {}
impl<T: Draggable + Badge> DraggableBadge for T {}

fn edit<T: DraggableBadge>(value: &mut T) { /* both traits are available */ }
fn edit_erased(value: &mut dyn DraggableBadge) { /* both traits are available */ }
```

`examples/positive.rs` compiles. `negative_missing_capability.rs` fails because `OnlyDraggable` lacks `Badge`; the compiler points to that missing bound. This is the strongest zero-macro option when callers can name a reusable group. It is ordinary Rust and has no runtime cost for generic functions. The dynamic group trait object uses a single trait-object pointer and Rust's normal vtable dispatch.

There are two important boundaries:

* Stable Rust does not support a trait object such as `dyn Draggable + Badge` for two non-auto traits. An umbrella trait is required.
* A generic parameter cannot stand in for a trait in a bound (`T: Capability` where `Capability` is an arbitrary type parameter). A universal `AllOf<A, B>` marker cannot prove matching native trait bounds by itself. However, an indexed membership tree can prove that a token occurs at a structural path, as the next experiment shows.

The umbrella trait solves static composition but does not provide reflection adapters for a value already erased as GPUI `AnyElement`. GPUI still needs per-trait generated adapters and a runtime registry that can find each requested adapter. A custom umbrella trait can be a convenient named group token, but it cannot erase that work.

When two supertraits define the same method name, `group.label()` is ambiguous exactly as it is for separate generic bounds. `negative_ambiguous_supertrait_method.rs` demonstrates the compiler error. Callers must use UFCS (`DragLabel::label(value)`) or expose one uniquely named forwarding method on the group.

## Indexed membership and access lattice

`src/indexed.rs` implements a real type-level membership proof:

```rust
trait Contains<Token, Index> {}
// Leaf<T>: Contains<T, Here>
// Both<L, R>: Contains<T, Left<I>> if L: Contains<T, I>
// Both<L, R>: Contains<T, Right<I>> if R: Contains<T, I>
```

`ReflectedElement<G>::narrow::<Token, _>()` compiles when the requirement tree contains that token. `indexed_positive.rs` confirms the compiler infers `Index` when a marker has one path. If a token repeats, or a shared supertrait is inherited along two branches, `_` is ambiguous (`E0282`). The positive example then supplies `Left<...>` or `Right<...>` and both projections compile. This is not a coherence overlap: each proof impl has a distinct structural index. It is an inference ambiguity caused by multiple valid proofs.

The access lattice uses `Off`/`On` type flags and an `Or` merge per builtin capability. Every token declares local access bits and its inherited member tree; the group computes its flags recursively from that same tree. `InteractiveToken` includes `StyledToken` as a parent, so the accumulated group gains both flags automatically. Conditional `Styled`, `Interactive`, and `Parent` impls for `ReflectedElement<G>` are gated by `G::Access: HasStyled/HasInteractive/HasParent`. Chaining later parent or custom tokens preserves prior flags. `indexed_negative_missing_builtin.rs` confirms a group without the style flag cannot call `.bg()`.

This makes a generic fluent requirement builder possible without proc-macro-generated group types. The compile-time tree proves membership and derives fixed builtin capabilities. A production GPUI design would still need each callable token tied to its adapter method table and each group registered with the runtime selector; an index proof alone does not produce a trait-object reference from an erased element. A canonicalized requirement tree could avoid duplicate proof ambiguity, but stable Rust does not automatically deduplicate arbitrary token identities. Keeping the index explicit is viable for a lower-level projection API; requiring explicit indices on common supertraits would be poor everyday ergonomics.

## Fluent selector shape

`Selector<Scope, Requirement>` and `.require(Token)` demonstrate a stable, zero-sized builder type that preserves the selector scope while accumulating an `AllOf` requirement marker. Thus `descendants().class("card").require(DraggableToken).require(BadgeToken)` retains `Descendants` and represents intersection semantics. The type has only `PhantomData` fields, so the prototype's selector itself occupies zero bytes.

This is useful API syntax, but runtime query logic still needs to append the matching reflection requirements. The type-level nested list does not provide callable access. For an arbitrary fluent chain, the implementation would need to carry both this marker and a runtime requirement list, then let selector access code resolve each callable adapter. A union query has different semantics: the callback can only use capabilities common to both branches, or it must receive an enum/branch discriminator before branch-specific calls.

## Compared approaches

| Approach | Ergonomics | Proof strength | Works after `AnyElement` erasure? | Main cost |
| --- | --- | --- | --- | --- |
| `T: A + B` | Familiar, concise in generic APIs | Strong for concrete `T` | No | Repeats bounds; no object form |
| Named umbrella `Group: A + B` | Best reusable group syntax | Strong; compiler checks every bound | No by itself | One group trait declaration per reusable bundle |
| Indexed `Both<A, B>` membership tree | Fluent accumulation and projection proofs | Proves membership at an inferred or explicit path | No | Duplicate/shared-parent membership makes inferred indices ambiguous; adapters still needed |
| `AllOf<A, B>` type-level marker | Fluent requirement accumulation | Cannot prove arbitrary trait bounds on stable Rust | No | Needs a membership relation such as `Contains<T, Index>` |
| Existing `trait_set![A, B]` | Concise ad hoc reflected group | Generates the group proof and runtime requirements | Yes | Proc-macro/schema machinery |
| Bit flags for built-in traits | Compact fixed builtin state | Can prove a finite set if APIs encode each state | Only for fixed known builtins | Combinatorial type states or unstable generic const operations; does not extend to user traits |

For GPUI selectors, the indexed tree is the strongest macro-free proof prototype: it can represent arbitrary fluent combinations and infer a unique membership path. Its main ergonomic fault is duplicate ambiguity, especially for shared parents. A named umbrella trait remains concise for a frequently reused bundle. Either design still needs runtime adapter resolution after erasure; generated schemas can supply that registration while the public builder uses an indexed tree.

## Checks and footprint

On the available `rustc 1.101.0-nightly`, `cargo check --example positive` succeeds. The two `negative_*.rs` examples fail at their intended call sites: missing `Badge`, and ambiguous inherited `label`.

The selector marker, proof indices, and access flags are structurally zero-sized because they use only `PhantomData`; no runtime list is kept in the prototype. The paired `individual_bounds` and `umbrella_bound` executables use the same body, one with `T: Draggable + Badge` and one with `T: DraggableBadge`. Release builds were 433,440 and 433,392 bytes, respectively (48 bytes apart), and `size` reported identical text/data sections: 278,528 / 16,384 bytes. This shows the reusable group abstraction itself has no meaningful runtime footprint in this fixture.

The existing `consumer_trial` (which exercises `trait_set![Draggable, Badge, Styled, ParentElement]` through GPUI) completed a warm `cargo check` in 1.18 s wall time / 0.83 s Cargo-reported time on this checkout. That includes GPUI and its dependency graph, so it cannot be compared with the isolated crate's warm 0.13 s check as a macro compile-time benchmark. A fair compile-time or generated-code comparison requires equivalent GPUI consumer fixtures, one using a supported named-group API and one using `trait_set!`, plus clean target directories and repeated runs. The current trait-set macro emits an anonymous proof group and runtime requirement values; those runtime descriptor costs are separate from the zero-sized static marker demonstrated here.
