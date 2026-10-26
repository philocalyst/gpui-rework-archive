# Frontier Rust Language Features for a Compile-Time-Verified Reactive GUI

> Mechanism survey, not the selected public API. The applicability corrections are in
> [06-competitive-update.md](06-competitive-update.md); the stable-Rust decision is in
> [../03-hybrid-plan.md](../03-hybrid-plan.md).

Research date: 2026-08-09. Baseline compiler: **stable Rust 1.97.1** (released 2026-07-16 — confirmed via `static.rust-lang.org/dist/channel-rust-stable.toml`), not the ~1.93 assumed at task start. Samples marked **VERIFIED** were compiled and executed at research time in a temporary edition-2024 Cargo project against that compiler. The temporary project was not committed, so each mechanism selected for implementation must gain an in-repository compile-pass/compile-fail test before it is considered a maintained guarantee. Referenced crates are listed in Appendix A and were read directly from temporary clones.

Target architecture context: GPUI (Zed's UI framework, this repo). GPUI already uses a per-frame bump arena (`crates/gpui/src/arena.rs`), a `cx: &mut Context`/`&mut Window` threading model, `Entity<T>` handles, and runtime phase assertions (`debug_assert_paint`, `crates/gpui/src/window.rs:180-236`) rather than compile-time capability tokens. Every section below is written with an eye to "what would change about GPUI's actual design."

## Selected 2026 API boundary: copyable keys plus access capabilities

The final correction goes further than the original weak-runtime-handle proposal. `State<T>` is a
two-word generational key plus zero-sized `PhantomData`; it is manually `Copy` for every `T`, marked
`!Send + !Sync`, owns no `Rc`/`Weak`, and has no ambient dereference method. `Scope`, `Update`, or the
inferred dynamic `Read` supplies the actual runtime reference and validates runtime/owner/slot
generations. A captured key in layout/paint is inert without the matching capability. This removes
refcount traffic, runtime lifetime hazards, and phase-guarded context-free reads together.

Generated models become contiguous groups of direct field cells whose inferred handle exposes
ordinary typed members. A sealed generic `Property<T>` protocol lets literals, keys, and expression
blueprints feed one builder surface; consuming mount deforests the blueprint into concrete retained
slabs. Opaque property combinators use stable RPIT precise capture (`use<...>`, stable since Rust
1.82) so they capture only named type/lifetime parameters and cannot accidentally retain `Scope`.
`Update` writes isolated drafts or typed deltas, never published `&mut T`; arbitrary dynamic
computations alone receive `Read`. This is an architectural use of stable ownership/capability
types, not a claim that Rust proves dynamic graph edges or owner disposal.

---

## 0. Executive stabilization status table

| # | Feature | Status (Aug 2026) | Stabilized in | Tracking / RFC |
|---|---|---|---|---|
| 1a | Precise capturing `use<..>`, free fns/inherent impls | **Stable** | 1.82.0 (Oct 2024) | rust#123432, RFC 3617 |
| 1b | Precise capturing `use<..>` in trait methods (RPITIT) | **Stable** | 1.87.0 (May 2025) | rust#130044 |
| 1c | Edition 2024 default over-capture of RPIT | **Stable** (edition default) | 1.85.0 / Rust 2024 | rust#117587 |
| 2 | RPITIT / AFIT | **Stable** | 1.75.0 (Dec 2023) | rust#91611, RFC 3425 |
| 2b | RPITIT "refinement" (`#[refine]`) | **No such attribute exists**; governed by warn-by-default lints `refining_impl_trait_{reachable,internal}` | n/a | rust#121718 (open), RFC 3245 |
| 3a | TAIT (`type_alias_impl_trait`) | **Unstable, nightly-only** | — | rust#63063 (open, blocked on types-team#129 / next-gen trait solver) |
| 3b | ATPIT (assoc.-type position impl trait) | **Unstable, nightly-only** | — | same tracking issue, split design |
| 4 | GATs | **Stable** | 1.65.0 (Nov 2022) | — |
| 5a | `adt_const_params` (struct/enum const params) | **Unstable**, "largely complete," no RFC yet | — | rust#95174 (open) |
| 5b | `unsized_const_params` (`&'static str` const params) | **Unstable, barely started** | — | rust#128028 (open) |
| 5c | `generic_const_exprs` | **Unstable, stuck**; being replaced by `min_generic_const_args` | — | superseded effort rust#132980 |
| 5d | `const_trait_impl` ("const traits") | **Unstable**; no accepted RFC on syntax as of 2026 | — | rust#143874 (open), old #67792 closed/superseded |
| 6 | GhostCell / branded lifetimes (`LCell`, `generativity`) | **Library-level pattern on 100% stable Rust today** — no language feature needed | Stable (as a technique) | ICFP 2021 paper; `qcell`, `generativity` crates |
| 8 | `#[track_caller]` + `Location::caller()` | **Stable** (correcting task premise: not 1.42) | **1.46.0** (Aug 2020) | RFC 2091, rust#72445 |
| 8b | `#[track_caller]` on `async fn` | **Unstable**, open design question (caller vs. poller semantics) | — | rust#110011 (open) |
| 9 | Bevy `SystemParam` conflict detection | Types drive access description; **conflict check is a runtime panic/serialize pass at schedule-build time**, not `rustc`-checked | n/a (library pattern) | bevy_ecs source |
| 9b | Variadic generics (language feature) | **No accepted RFC, not close** | — | internals megathread #13879; RustWeek 2025 report |
| 10 | Autoref specialization | Library technique, stable Rust, **macro-only** (doesn't work in generic fn bodies) | n/a | dtolnay case-study |
| 12a | Async closures (`AsyncFn`/`AsyncFnMut`/`AsyncFnOnce`) | **Stable** | **1.85.0** (Feb 2025) | RFC 3668 |
| 12b | `arbitrary_self_types` (custom receivers, e.g. `self: Signal<Self>`) | **Unstable**, active 2026 project goal, driven by Rust-for-Linux | — | rust#44874 (open), RFC 3519 v2 |
| 13 | `#[diagnostic::on_unimplemented]` | **Stable** | **1.78.0** | Rust Reference: attributes/diagnostics |

---

## 1. Precise capturing: `impl Trait + use<'a, T>`

**Status.** Stable for free functions/inherent methods since **1.82.0** (RFC 3617, tracking rust#123432); extended to trait methods (RPITIT) in **1.87.0** (rust#130044, PR #138128). The Rust 2024 edition additionally flipped the *default*: RPIT in free functions now captures **all** in-scope generic type/lifetime parameters unconditionally (matching what trait-fn RPIT and `async fn` already did in every edition) — `use<..>` changed from an *opt-in* precision tool (2021) to an *opt-out* one (2024).

**Mechanics, verified on live rustc 1.97.1.** A method borrowing only from its arguments, not from `&self`, can now say so precisely:

```rust
trait Element {}
struct Label<'a>(&'a str);
impl<'a> Element for Label<'a> {}

struct View;
impl View {
    fn label<'s, 't>(&'s self, text: &'t str) -> impl Element + use<'t> {
        Label(text)
    }
}

fn use_label() {
    let view = View;
    let s = String::from("hello");
    let el = view.label(&s);
    drop(view);   // legal: `el` provably does NOT borrow `view`
    let _ = el;
}
```
This **compiles and runs** (verified). Without `+ use<'t>`, under Rust 2024's default-captures-everything rule, the identical method produces a real borrowck error:
```
error[E0505]: cannot move out of `view` because it is borrowed
note: this call may capture more lifetimes than intended, because Rust 2024
      has adjusted the `impl Trait` lifetime capture rules
help: use the precise capturing `use<...>` syntax to make the captures explicit
   |     fn label<'s, 't>(&'s self, text: &'t str) -> impl Element + use<> {
```

**Why this matters for GPUI.** A `View`/`Element`-builder method that returns `impl Element` and takes `&self` plus borrowed arguments would, under Rust 2024 defaults, have its return type spuriously anchored to `&self`'s lifetime — forcing the caller to keep the view borrowed as long as the returned element is alive, even though the element only borrows the *arguments*. `use<'t>` (or, in trait position, `use<Self, 't>` — note `Self` is **mandatory** in the trait-side list; only method-local lifetimes are elidable) lets a `render`-style method return an element that borrows precisely what it needs and nothing more, without `'static` bounds or heap boxing. This is the single most directly load-bearing feature for "return a view that borrows from state without a `'static` wall."

Sources: [RFC 3617](https://rust-lang.github.io/rfcs/3617-precise-capturing.html), [Rust 1.82.0 blog post](https://blog.rust-lang.org/2024/10/17/Rust-1.82.0/), [Edition Guide: RPIT lifetime capture rules](https://doc.rust-lang.org/edition-guide/rust-2024/rpit-lifetime-capture.html), [PR #138128](https://github.com/rust-lang/rust/pull/138128).

---

## 2. RPITIT / AFIT: refinement, dyn-compatibility, `trait-variant`

**Status.** Both RPITIT and AFIT stabilized together in **1.75.0** (Dec 2023; RFC 3425, rust#91611). `fn f(&self) -> impl Trait` in a trait desugars to an anonymous, unnameable GAT: `type F<'a> = impl Trait; fn f<'a>(&'a self) -> Self::F<'a>;` ([rustc-dev-guide](https://rustc-dev-guide.rust-lang.org/return-position-impl-trait-in-trait.html)).

**Refinement — no `#[refine]` attribute exists.** Verified empirically: `#[refine] fn dummy() {}` produces `error: cannot find attribute 'refine' in this scope`. Refinement (an impl returning a more specific type than the trait's opaque bound promises) is governed purely by two **warn-by-default** lints, `refining_impl_trait_reachable` / `refining_impl_trait_internal` (grouped as `refining_impl_trait`). The design question of whether explicit opt-in should be *required* (RFC 3245) is **still open** as of the most recent activity on rust#121718 (updated 2026-01-08). Verified:
```rust
trait AsDisplay { fn as_display(&self) -> impl Display; }
impl AsDisplay for &str { fn as_display(&self) -> Self { self } }  // refines opaque -> &str
```
compiles with only a warning (`add #[allow(refining_impl_trait)] if intended for public API`). **Semver hazard for a public `View`/`Element` trait**: a concrete `impl View for Label` that refines its return type creates an implicit, warn-only public API surface that generic code against the trait cannot see.

**dyn-compatibility — verified as a hard error, not a lint.**
```rust
trait View {
    fn render<'t>(&self, text: &'t str) -> impl Element + use<'t, Self>;
}
let v: Box<dyn View> = Box::new(MyView);
```
```
error[E0038]: the trait `View` is not dyn compatible
note: ...because method `render` references an `impl Trait` type in its return type
```
`trait View { fn render(&self) -> impl Element + use<'_>; }` compiles fine and works with static/generic dispatch (`fn mount<V: View>(v: &V)`), but **`dyn View` is unconditionally rejected** — no partial workaround exists in the language today, because `impl Trait` here is sugar for a per-impl anonymous associated type, and object-safety requires every associated type to be fixed at vtable-construction time.

**`trait-variant` crate** (cloned `rust-lang/impl-trait-utils`, `trait-variant/src/variant.rs`) solves a *different* problem — adding `Send` (or other) bounds to `async fn`/RPITIT methods via AST rewriting + a generated blanket impl — **not** dyn-compatibility:
```rust
#[trait_variant::make(IntFactory: Send)]
pub trait LocalIntFactory {
    async fn make(&self, x: u32, y: &str) -> i32;
    fn stream(&self) -> impl Iterator<Item = i32>;
}
```
expands to a `Send`-bounded sibling trait `IntFactory: Send` plus `impl<T: IntFactory> LocalIntFactory for T { .. }`. `dyn IntFactory` remains **not** object-safe afterward — the crate only adds auto-trait bounds, it never erases the opaque return type. For actual `dyn` dispatch you still need manual `Box::pin(async move {})` boxing (the pre-1.75 `async-trait` idiom) or a hand-boxed alternative.

**Practical GPUI-relevant sketch (all lines individually verified above):**
```rust
trait View {
    fn render<'t>(&self, cx: &'t Cx) -> impl Element + use<'t, Self>;  // OK; NOT dyn-safe
}
fn mount<V: View>(v: &V, cx: &Cx) { let _el = v.render(cx); }          // OK: monomorphized
// fn mount_dyn(v: &dyn View, cx: &Cx) { .. }                          // COMPILE ERROR
```
To get heterogeneous element collections (GPUI's real `AnyElement`/`AnyView` need), you must erase at a *separate* dyn-safe boundary trait (no RPIT on the object-safe trait itself) — which is in fact what GPUI already does architecturally: ergonomic RPIT-returning builder APIs stay generic/static, and are only converted to a `Box<dyn ...>`-style erased form at the tree-storage boundary.

Sources: [Rust Reference: dyn compatibility](https://doc.rust-lang.org/reference/items/traits.html#object-safety), [RFC 3245](https://rust-lang.github.io/rfcs/3245-refined-impls.html), [impl-trait-utils repo](https://github.com/rust-lang/impl-trait-utils).

---

## 3. TAIT / ATPIT: still nightly-only, confirmed three ways

**Status: unstable as of Rust 1.97.1 / Aug 2026.** Confirmed via (1) `rustc_feature::unstable.rs` on `rust-lang/rust` master (`type_alias_impl_trait` and `impl_trait_in_assoc_type` are both in `unstable.rs`, not `accepted.rs`), (2) tracking issue [rust#63063](https://github.com/rust-lang/rust/issues/63063) — open, `S-tracking-blocked`, most recent activity Jan 2026 (a bug report against the nightly feature), with an explicit blocker comment from a types-team member: *"TAIT is currently blocked on rust-lang/types-team#129... won't entirely get TAIT rdy for stabilization"* — a next-generation-trait-solver dependency, not a syntax question, (3) empirical compile failure on stable 1.97.1:
```rust
type MyIter = impl Iterator<Item = u32>;   // error[E0658]: `impl Trait` in type aliases is unstable
impl ViewFactory for S {
    type Out = impl std::fmt::Debug;        // error[E0658]: `impl Trait` in associated types is unstable
}
```
ATPIT was deliberately split off from TAIT to sidestep some of TAIT's open language-design questions, but **both remain blocked on the same underlying compiler-internals work** and neither has a stabilization date. The May 2026 Rust project-goals update still lists TAIT as a blocked dependency for the Rust-for-Linux initiative.

**Stable workarounds today, in the order a framework would reach for them, for storing an unnameable view/closure type in a struct field:**

1. **Generics + `PhantomData`** — zero-cost, fully monomorphized, but viral (the type parameter propagates through every container) and precludes heterogeneous collections.
2. **`Box<dyn Trait>`** — the standard escape hatch; heap + vtable per element, but works everywhere today, and is effectively what GPUI's `AnyElement`/`AnyView` already do. Requires the trait to be dyn-safe (§2).
3. **`fn` pointers** — only for closures with no captures — rare in a reactive framework, since closures over reactive state almost always capture.
4. **Macro-generated enums** — for a closed, compile-time-known set of primitive element kinds (`enum ElementKind { Div(Div), Text(Text), .. }`); avoids both heap allocation and dynamic dispatch at the cost of exhaustive-match boilerplate.
5. **`smallbox` crate** (cloned `andylokandy/smallbox` v0.8.8, read `src/smallbox.rs`/`src/space.rs`) — stack-allocated small-object optimization for `dyn Trait`, falling back to heap only above a fixed inline capacity:
   ```rust
   pub struct SmallBox<T: ?Sized, Space> {
       space: MaybeUninit<UnsafeCell<Space>>,
       ptr: NonNull<T>,
       _phantom: PhantomData<T>,
   }
   ```
   Unsized values are constructed on **stable Rust** via the `smallbox!(expr)` macro (uses `ptr::addr_of!` to capture unsized metadata without nightly `Unsize`/`CoerceUnsized`); an ergonomic `coerce` feature exists but **requires nightly** (confirmed directly in `lib.rs`: `#![cfg_attr(feature = "coerce", feature(unsize, coerce_unsized))]`). Caveat: if the inline `Space`'s alignment is smaller than the stored value needs, it silently heap-allocates anyway — a footgun worth flagging for a hot render-loop use. This is directly applicable to per-node element storage: most `Element`/`View` values are a handful of words; `SmallBox<dyn Element, S4>` avoids a heap allocation for the majority of nodes.

Sources: [tracking issue #63063](https://github.com/rust-lang/rust/issues/63063), [types-team#129](https://github.com/rust-lang/types-team/issues/129), [ATPIT project goal](https://rust-lang.github.io/rust-project-goals/2024h2/ATPIT.html), [smallbox source](https://github.com/andylokandy/smallbox).

---

## 4. GATs for lending patterns

**Status.** Stable since **1.65.0** (Nov 2022). The [stabilization blog post](https://blog.rust-lang.org/2022/10/28/gats-stabilization/)'s canonical motivating example *is* the lending-iterator pattern:
```rust
trait LendingIterator {
    type Item<'a> where Self: 'a;
    fn next<'a>(&'a mut self) -> Self::Item<'a>;
}
```
Documented remaining limitations, still true today: GATs alone do **not** make a trait dyn-safe (`&dyn for<'a> LendingIterator<Item<'a> = &'a str>` is unsupported); and closures accepting a GAT item generically (`impl for<'a> FnMut(Item<'a>)`) hit a known NLL limitation, expected to be resolved only by full Polonius integration.

**Signal read-guard pattern — VERIFIED to compile and run:**
```rust
trait Signal {
    type Value;
    type Guard<'a>: Deref<Target = Self::Value> where Self: 'a;
    fn read(&self) -> Self::Guard<'_>;
}
struct StateSignal<T> { value: RefCell<T> }
impl<T> Signal for StateSignal<T> {
    type Value = T;
    type Guard<'a> = Ref<'a, T> where T: 'a;
    fn read(&self) -> Ref<'_, T> { self.value.borrow() }  // real impl would also register
}                                                          // the current reactive scope here
```
`Guard<'a>` can be a plain `Ref<'a, T>` for a `RefCell`-backed signal today, or a custom guard type whose `Drop` impl performs dependency-tracking bookkeeping — with zero dynamic dispatch, and the borrow checker statically preventing any write while a read guard is alive (a real, compiler-enforced XOR-mutability guarantee, not a runtime `RefCell` panic path once the guard type is custom).

**GAT lending iterator over children — VERIFIED:**
```rust
trait LendingIterator {
    type Item<'a> where Self: 'a;
    fn next(&mut self) -> Option<Self::Item<'_>>;
}
impl<'e> LendingIterator for ChildrenMut<'e> {
    type Item<'a> = &'a mut Box<dyn Debug> where Self: 'a;
    fn next(&mut self) -> Option<Self::Item<'_>> { .. }
}
```
Lets a tree-walking render pass iterate `&mut` children in place with no `Rc<RefCell<_>>` cloning.

**Real-world crate for the harder cases** — `lending-iterator` (cloned, v0.1.7) + `polonius-the-crab` (cloned, v0.5.0). Important nuance: `lending-iterator` predates GAT stabilization and emulates HKTs via the `nougat` crate's trick, and its own doc comment admits: *"LendingIterator is not really dyn-friendly (although IIUC, with feature(generic_associated_types) it wouldn't have been either)"* — confirming GATs alone never solved dyn-safety, even once stable. Its `find()` needs `polonius_loop!`/`polonius_continue!`/`polonius_return!` macros to work around exactly the documented NLL gap ("look up a node, mutate in place, or fall through to insert" — extremely common in retained-mode diffing):
```rust
fn find<'find>(self: &'find mut Self, mut predicate: impl 'find + FnMut(&Item<'_, Self>) -> bool)
    -> Option<Item<'find, Self>> {
    use polonius_the_crab::prelude::*;
    let mut this = self;
    polonius_loop!(|this| -> Option<Item<'polonius, Self>> {
        let ret = this.next();
        if matches!(ret, Some(ref it) if predicate(it).not()) { polonius_continue!(); }
        polonius_return!(ret);
    })
}
```
**Relevance:** this limitation applies specifically to **borrow-returning lending traversals**:
operations that iterate, retain a borrow from one iteration, and then need to mutate/insert through
the same traversal. It is not a general limitation of every arena `find-or-insert`; index-based
arenas can finish lookup, release the borrow, then mutate by index on stable Rust. Use
`polonius-the-crab` only where a lending traversal is actually the clearest representation, rather
than making it a retained-tree dependency.

Sources: [GAT stabilization post](https://blog.rust-lang.org/2022/10/28/gats-stabilization/), [lending-iterator](https://github.com/danielhenrymantilla/lending-iterator.rs), [polonius-the-crab](https://github.com/danielhenrymantilla/polonius-the-crab.rs).

---

## 5. Const generics frontier

### 5.1 `adt_const_params` — struct/enum const params

Tracking [rust#95174](https://github.com/rust-lang/rust/issues/95174), open. Checklist shows valtrees and structural-equality work done, but *"Author an RFC explaining the current state... since it has significantly diverged from the original RFC"* is the acknowledged blocker (most substantive comment, clarfonthey, Aug 2024). The current (renamed) planning doc, `rust-lang/goals`, `src/2026/const-generics.md`, states: *"the implementation... is largely complete. There are a few next steps... Split out a min_adt_const_params feature... Publish an RFC..."* — i.e., implementation-complete-ish, but **zero accepted design RFC**.

### 5.2 `unsized_const_params` — `&'static str` as a const generic

**This is the feature that would actually enable "typed style keys" like `Signal<"count">`.** It is a *separate, even-earlier* tracking issue, [rust#128028](https://github.com/rust-lang/rust/issues/128028), split out of `adt_const_params` in PR #127722. Its checklist is barely started: *"Experiment with supporting `{ *"hi" }` as a const argument... Author an RFC... Stabilization PR"* — none checked. The `rust-lang/goals` planning doc is explicit about sequencing: *"We intend to explore support for strings **after** stabilizing structs/enums in Const Generics as they are much more complicated."* **Conclusion: `&'static str` const generics are two unstable, sequentially-blocking features away from stable, with no RFC on either.** Do not present this as "coming soon."

### 5.3 `generic_const_exprs` — stuck, confirmed broken on nightly in 2026

Confirmed still actively broken via a **live bug report filed against rustc 1.96.0-nightly** ([rust#153393](https://github.com/rust-lang/rust/issues/153393), ~March 2026). lcnr's [2022 blog post](https://lcnr.de/blog/2022/01/17/generic-const-expressions.html) explains the naive implementation hacked const-eval into the type system unsoundly/unmaintainably. The unblocking successor is **`min_generic_const_args`** (mgca, [rust#132980](https://github.com/rust-lang/rust/issues/132980)) — per the `rust-lang/goals` doc: *"a prototype of a potential minimal stabilizeable improvement... may wind up blocked on the new trait solver being stable first."* Still prototype-stage in 2026.

### 5.4 `const_trait_impl` ("const traits") — not stabilized, contra one low-quality blog claim

One non-authoritative blog claimed 2026 stabilization; **this is false**, contradicted by primary sources. Old tracking rust#67792 was **closed 2025-07-13** in favor of a fresh RFC-driven restart ([rfcs#3762](https://github.com/rust-lang/rfcs/pull/3762)); new tracking [rust#143874](https://github.com/rust-lang/rust/issues/143874) is **still open**, syntax still churning (`~const` → `[const]` bounds, `#[const_trait]` "removed for good"). The `rust-lang/goals` 2026 doc states plainly: *"there has never been an accepted RFC describing its syntax. The goal for the next year is to... finalize the syntax and semantics."* **You cannot write a `const fn` generic over a trait bound on stable Rust today** — const-fn string/style parsing has to route entirely around trait dispatch.

### 5.5 What IS achievable today on 100% stable Rust: const-fn parsing of style strings

Cloned and read `konst` (rodrimati1992, MSRV 1.89.0, `#![no_std]`). This is real and works now — a mature const-fn parsing toolkit built entirely on stable byte-slice/const-loop capabilities. Caveat from its own README: *"As of Rust 1.89.0, string patterns don't work in const contexts"* — so `match s { "px-4" => .. }` on `&str` still isn't legal in `const fn`; all dispatch must go through explicit byte-level `strip_prefix`/equality functions. Core type (`konst/src/parsing.rs:140`):
```rust
pub struct Parser<'a> { parse_direction: ParseDirection, yielded_last_split: bool, start_offset: u32, str: &'a str }
```
with `const fn strip_prefix<'p, P: Pattern<'p>>(&mut self, matched: P) -> Result<&mut Self, ParseError<'a>>` doing byte-level prefix matching, and a `parser_method!` macro dispatching over string prefixes at compile time:
```rust
parser_method!{prev_parser, strip_prefix;
    "name" => name = try_!(parser.split_keep('\n')),
    "amount" => amount = try_!(parser.parse_usize()),
    _ => { return Err(prev_parser.to_other_error(&"could not parse field name")); }
}
```
**Conclusion: a Tailwind-style `"px-4"` utility-class parser, evaluated entirely at compile time (`const` binding, malformed input = compile error via `unwrap!`), is fully realizable on stable Rust today.** What you get: compile-time-checked *syntax*. What you do **not** get without §5.1+§5.2 landing: the *parsed value* being usable as a distinct, type-distinguishing generic parameter — `Signal<COUNT_KEY>` today is a runtime `const` value baked into one common type, not a type-level discriminator, so nothing stops two call sites from silently colliding on the same key beyond ordinary value equality.

### 5.6 Sketch: typed style keys, today vs. with `adt_const_params` + `unsized_const_params`

**Today** — a user-defined enum, including a fieldless `#[repr(u16)]` enum, is **not** a
stable const-generic parameter. Stable const parameters are only integers, `bool`, and `char`.
Use (a) a build-macro-minted *numeric* field id such as `const FIELD: u16`, (b)
`PhantomData<KeyMarker>` marker-type generics (the TCell pattern, §6), or (c) a `konst`-hashed
string in a `u64` const — with ordinary runtime collision checking/debug names where needed.
Do not describe an enum workaround as stable until `adt_const_params` actually stabilizes.

**With both features stabilized (multi-year-out):**
```rust
#![feature(adt_const_params, unsized_const_params)]
struct Signal<const KEY: &'static str, T> { value: T }
let count: Signal<"count", i32> = Signal { value: 0 };
let total: Signal<"total", i32> = Signal { value: 0 };
// genuinely different monomorphized types; fn set(s: &mut Signal<"count", i32>, ..)
// rejects a Signal<"total", i32> argument at the call site — no marker-struct macro needed.
```

Sources: [rust#95174](https://github.com/rust-lang/rust/issues/95174), [rust#128028](https://github.com/rust-lang/rust/issues/128028), [rust#132980](https://github.com/rust-lang/rust/issues/132980), [rust#143874](https://github.com/rust-lang/rust/issues/143874), lcnr's [blog post](https://lcnr.de/blog/2022/01/17/generic-const-expressions.html), `rust-lang/goals` (`src/2026/const-generics.md`, `src/2026/const-traits.md`), [konst](https://github.com/rodrimati1992/konst).

---

## 6. Branded/invariant lifetimes: GhostCell, qcell, generativity

This is the one topic in the entire investigation that is **fully realizable on 100% stable Rust today** — no unstable feature required at all. It is a library/type-system-encoding technique, not a language feature.

### 6.1 The GhostCell paper

Yanovski, Dang, Jung, Dreyer, **"GhostCell: Separating Permissions from Data in Rust"**, ICFP 2021 ([plv.mpi-sws.org/rustbelt/ghostcell](https://plv.mpi-sws.org/rustbelt/ghostcell/)). Core trick, inherited from the ML/Haskell `ST`-monad tradition (Launchbury & Peyton Jones 1994/95) and brought into Rust by Aria Desires' 2015 thesis (which coined "generativity" in this context): an **invariant lifetime brand `'id`** ties a single `GhostToken<'id>` (the permission) to any number of `GhostCell<'id, T>` cells. Borrowing a cell's contents requires borrowing the token the same way (`&`/`&mut`), so the **borrow checker itself** enforces XOR-mutability across arbitrarily many `Rc`-shared cells — zero-cost, no `RefCell`-style runtime flag at all. Formally proven sound by extending RustBelt (mechanized in Coq).

### 6.2 `qcell` — read in full, including its own comparison table

Cloned `uazu/qcell`. Its crate-doc (`src/lib.rs:169-260`) is exactly the pros/cons table requested, quoted **verbatim**:

| Cell | Owner ID | Cell overhead | Borrow check | Owner check | Owner creation check |
|---|---|---|---|---|---|
| `RefCell` | n/a | `usize` | Runtime | n/a | n/a |
| `QCell` | integer | `usize` | Compile-time | Runtime | Runtime |
| `TCell`/`TLCell` | marker type | none | Compile-time | Compile-time | Runtime |
| `LCell` | lifetime | none | Compile-time | Compile-time | Compile-time |

**LCell is the only variant with zero runtime cost on every axis** — the price is `'id` annotation burden ("Requires lifetime annotations on calls and structures," per the crate's own con-list). `TCell`/`TLCell` avoid lifetime annotations by using a process-global (or per-thread) **singleton marker type**, checked at runtime via a `Mutex<HashSet<TypeId>>` in `Drop`, meaning nested/recursive use of the *same* marker type deadlocks/panics — you need a fresh marker struct per logical nesting level, usually macro-minted. `QCell` drops both constraints at the cost of a `usize` runtime owner-ID check per borrow, using a `Pin<Box<OwnerIDTarget>>` for a stable-address identity. The doc explicitly states GhostCell and LCell are architecturally identical, differing only in publication history: *"GhostCell... predated LCell, but was only officially published in 2021... The authors... proved that the logical reasoning behind GhostCell is correct, which indirectly strengthens the theoretical justification for other similar cell types, such as the ones in this crate."*

**LCell's actual implementation** (`src/lcell.rs`) is the classic `for<'id>` HRTB brand-freshness trick:
```rust
type Id<'id> = PhantomData<Invariant<&'id ()>>;
pub struct LCellOwner<'id> { _id: Id<'id> }
impl<'id> LCellOwner<'id> {
    pub fn scope<F>(f: F) where F: for<'scope_id> FnOnce(LCellOwner<'scope_id>) {
        f(Self { _id: PhantomData })
    }
}
```

**Real, compiled evidence that a wrong-arena mix-up is a compile error**, not a runtime bug — from qcell's own trybuild corpus (`trybuild-qcell/src/compiletest/lcell-02.rs`):
```rust
LCellOwner::scope(|mut owner1| {
    LCellOwner::scope(|mut owner2| {
        let c1 = Rc::new(LCell::new(100u32));
        let c1ref1 = owner1.ro(&c1);
        let c1ref2 = owner2.ro(&c1);   // Compile error
    });
});
```
Actual rustc output on file:
```
error[E0521]: borrowed data escapes outside of closure
= note: ... `LCellOwner<'_>` ... which makes the generic argument `'_` invariant
= note: the struct `LCellOwner<'id>` is invariant over the parameter `'id`
```
**Honest ergonomic note:** the diagnostic talks about invariance/escaping, not "wrong owner" — objectively harder for a newcomer to interpret than a hypothetical bespoke message. qcell's own docs concede: *"the Rust compiler error messages may be more confusing with generativity if you make a mistake."*

### 6.3 `generativity` crate — a different brand-minting mechanism

**Naming correction**: the commonly-cited `reem/rust-generativity` URL 404s; the maintained crate is `CAD97/generativity` (what `qcell` itself depends on). Core, quoted from `src/lib.rs`:
```rust
pub struct Id<'id> { phantom: PhantomData<fn(&'id ()) -> &'id ()> }
pub struct Guard<'id> { id: Id<'id> }
struct LifetimeBrand<'id> { phantom: PhantomData<&'id Id<'id>> }
impl<'id> Drop for LifetimeBrand<'id> { fn drop(&mut self) { /* deliberately blank; forces
    the compiler to consider 'id live at drop time */ } }

macro_rules! make_guard {
    ($name:ident) => {
        let branded_place = unsafe { $crate::Id::new() };
        let lifetime_brand = unsafe { $crate::LifetimeBrand::new(&branded_place) };
        let $name = unsafe { $crate::Guard::new(branded_place) };
        // divergence-handling hack, see CAD97/generativity#15
        if let $crate::__private::Some(x) = $crate::__private::None { return x; }
    };
}
```
This achieves brand-freshness **without a nested closure** — instead relying on a local `Drop` impl plus documented reliance on rustc's phase-ordering to force each call site's `'id` to a distinct region. Useful for early-return-heavy code that can't easily nest in `scope(|owner| ..)` closures, at the cost of a scarier `unsafe`-laden implementation.

### 6.4 The `for<'id>` freshness argument, precisely

The mechanism (corroborated by qcell's own doc pointing to Gankra's thesis §6.3, and independently by an [arhan.sh blog post](https://arhan.sh/blog/the-generativity-pattern-in-rust/)): `for<'id> FnOnce(T<'id>)` is a **higher-ranked trait bound** — the *callee* (`scope`), not the caller, picks the concrete region for `'id` on each call, and it must work for *all* `'id`, so the closure body can never name or export a specific `'id`. Rust's region inference treats each textual call as an independent unification problem and never proves two "for-all-`'id`" placeholders equal across calls — so two arenas created via two separate `scope`/`make_guard!` invocations get provably distinct `'id`s from the type checker's perspective, even though there's zero runtime representation of a lifetime at all (100% erased). **Caution**: the trick is only as sound as the mechanism minting the brand — a naive DIY reimplementation (e.g., caching a `struct InvariantToken;` marker across loop iterations, expecting "a new brand per iteration") silently compiles and produces UB, because the *type* is identical across iterations even though the intent was distinctness.

### 6.5 Honest ergonomic assessment, with real production evidence

1. qcell's own con-list is the vendor's admission: **every function touching an `LCell`/`LCellOwner` needs an explicit `'id` generic parameter** on its signature — confirmed in the crate's own doctest signature `fn test<'id>(owner: &mut LCellOwner<'id>, item: &Rc<LCell<'id, Vec<u8>>>)`. This is the "infection" the task asked about, stated by the crate author, not inferred.
2. An [internals.rust-lang.org thread](https://internals.rust-lang.org/t/self-borrowing-data-would-allow-erganomic-generativity/21854) makes a sharper complaint: the token and cell live in *separate* types, so *"[it's] nearly impossible for library authors to hide the complexity of their implementation behind a single struct"* — you cannot cleanly encapsulate a branded arena behind a facade without leaking `'id` into your public API, because Rust has no first-class way to express "this struct owns a lifetime it invented itself." Proposed fixes (existential lifetimes) are multi-year-out compiler roadmap items, not near-term.
3. **No free lunch among the four cell designs** — `QCell` trades the lifetime-annotation burden for a per-borrow runtime check; `TCell`/`TLCell` trade it for a process/thread-global singleton restriction (deadlock/panic on re-entrant same-marker use); `LCell`/GhostCell keep zero runtime cost but pay the full annotation tax.
4. **Real production usage, confirmed via crates.io reverse-dependency counts** — not purely academic:
   - `generativity` (16 reverse deps): **`faer`** (a serious, widely-used pure-Rust linear-algebra library, ~3.95M cumulative downloads via this edge), `qcell` itself, and — most relevant here — **`slint-interpreter`** (1.17.1). Slint is a real, shipping cross-platform GUI framework. Its interpreter documentation states: *"The interpreter uses the generativity crate to ensure type safety, where each `ItemTreeDescription` and its associated `Instance` share a unique lifetime `'id`... particularly important because unlike generated code where types are known statically, the interpreter must track type information at runtime."* This is a direct, on-point precedent for the exact "signal/view from the wrong dynamically-loaded description" scenario a reactive framework would want to prevent.
   - `qcell` (8 reverse deps): `stakker` (actor-model async framework), `qcontext`, `turbo-vision`, others.
   - `ghost-cell` (matthieu-m's direct implementation of the paper's actual API, 3 reverse deps): `token-cell`, and **`simplicity-lang`**, Blockstream's Simplicity smart-contract language.
   - Overall: real, load-bearing usage in serious infrastructure, but single-digit-to-low-teens reverse-dep counts confirm this stays a **specialist technique for soundness-critical internals**, reached for deliberately, not a default choice for typical app code.
5. A ready-made production building block matching the "branded arena index" idea directly: `index-ext`'s `tag` module — *"apply fancy type-level mechanisms to move the bounds check... from the usage site to the construction of the index"*; its `Generative` tag type: *"unique for every created instance, by having a unique lifetime parameter."*

### 6.6 Sketch: `UiArena<'id>` + branded `Signal<'id, T>` — use-after-dispose becomes a compile error

```rust
use generativity::{Guard, Id, make_guard};

#[derive(Clone, Copy, PartialEq, Eq)]
pub struct SignalId<'id, T> { index: u32, _brand: Id<'id>, _ty: PhantomData<fn() -> T> }

pub struct UiArena<'id> { _brand: Id<'id>, signals: Vec<UnsafeCell<Box<dyn Any>>> }
pub struct UiToken<'id> { _brand: Id<'id> }   // the "permission", à la GhostToken

impl<'id> UiArena<'id> {
    pub fn new(guard: Guard<'id>) -> (Self, UiToken<'id>) { .. }
    pub fn create<T: 'static>(&mut self, value: T) -> SignalId<'id, T> { .. }
    pub fn read<'a, T>(&'a self, token: &'a UiToken<'id>, id: SignalId<'id, T>) -> &'a T { .. }
    pub fn write<'a, T>(&'a self, token: &'a mut UiToken<'id>, id: SignalId<'id, T>) -> &'a mut T { .. }
}

make_guard!(guard);
let (mut arena, mut token) = UiArena::new(guard);
let count: SignalId<'_, i32> = arena.create(0);
*arena.write(&mut token, count) += 1;
```
What this buys, exactly matching the `lcell-02.rs`/`E0521` evidence above: (1) use-after-dispose is a compile error — a `SignalId<'id, T>` cannot outlive or be mixed with a differently-branded `UiArena`; (2) "signal from wrong arena" is a compile error, not a runtime panic; (3) reads/writes cost only a `Vec` index — no `RefCell` borrow-flag check, no `Rc` refcount churn; matches `LCell`'s row in the table above (`Cell overhead: none / Borrow check: Compile-time / Owner check: Compile-time / Owner creation check: Compile-time`). The cost, per §6.5: **every framework-public function touching a `Signal` needs an `'id` generic parameter or a `&UiToken<'id>` argument** — real, provable API surface pollution, which is exactly why Slint scopes this pattern to its interpreter internals, not its public component API.

Sources: [GhostCell paper](https://plv.mpi-sws.org/rustbelt/ghostcell/), [qcell](https://github.com/uazu/qcell), [generativity](https://github.com/CAD97/generativity), [internals thread](https://internals.rust-lang.org/t/self-borrowing-data-would-allow-erganomic-generativity/21854), [index-ext](https://docs.rs/index-ext/latest/index_ext/tag/index.html), Slint interpreter docs.

---

## 7. ZST tokens & typestate

### 7.1 Capability tokens

The pattern: a function that may only run during a given dynamic extent takes a token (`&mut Frame`) as a parameter instead of consulting a thread-local/global flag. Because the token is only obtainable from the framework itself, possessing it *is* proof of being in the right context — misuse is "no such value in scope" (compile error) rather than a runtime panic.

**`wgpu::RenderPass<'encoder>`** is a real, load-bearing example — a *lifetime-based*, not ZST, capability: while a `RenderPass` is alive, the borrow checker prevents also touching the parent `CommandEncoder` mutably. wgpu's own docs frame this as a deliberate choice: dropping the lifetime relationship "makes usage of the encoder while this pass is recorded a run-time error instead" — i.e., wgpu explicitly chose the compile-time-checked design over a cheaper runtime-checked one.

**GPUI today does NOT do this** — verified by reading `crates/gpui/src/window.rs` directly. It uses a runtime phase enum plus debug-only assertions:
```rust
pub(crate) enum DrawPhase { .. }                       // window.rs:1282
pub fn not_drawing(&self) -> bool { .. }                // window.rs
#[track_caller]
pub fn debug_assert_paint(&self) {
    debug_assert!(matches!(self.inner.borrow().draw_phase, DrawPhase::Paint),
        "this method can only be called during paint");
}
```
Critically, `debug_assert!` **compiles out entirely in release builds** — the paint-phase invariant has zero enforcement in a release binary today. A capability-token redesign (`fn paint_quad(&mut self, frame: &mut PaintFrame, ..)` where `PaintFrame` is only constructible by GPUI's internal paint loop) would make this a compile error in every build profile, not a debug-only runtime check.

### 7.2 Typestate builders

Canonical sources: Cliff Biffle, ["The Typestate Pattern in Rust"](https://cliffle.com/blog/rust-typestate/) (distinct-struct-per-state vs. generic-marker-type encodings; the mechanism fundamentally relies on Rust's move semantics — a state-transition method consumes `self` by value, so the old-state handle becomes uncallable); Hoverbear, ["Pretty State Machine Patterns in Rust"](https://hoverbear.org/blog/rust-state-machine-pattern/); the [Embedded Rust Book's typestate chapter](https://docs.rust-embedded.org/book/static-guarantees/typestate-programming.html) (frames it as a generalization of the builder pattern, e.g. GPIO pin-mode safety).

The `typestate` crate (cloned `rustype/typestate-rs`) is a proc-macro DSL generating this boilerplate from a state-machine-shaped module (e.g. a traffic-light example where `TrafficLight<Green>` simply has no `to_red()` method — it doesn't exist in that impl block, not a runtime check). **Caveat: last commit 4 Jul 2023** — over three years stale as of Aug 2026; cite as an illustration, not a maintainable dependency.

### 7.3 Sealed traits and privacy-based negative reasoning

[Rust API Guidelines: future-proofing](https://rust-lang.github.io/api-guidelines/future-proofing.html) gives the canonical minimal sealed-trait form (`pub trait T: private::Sealed {}`, `mod private { pub trait Sealed {} }`). A [more thorough treatment](https://predr.ag/blog/definitive-guide-to-sealed-traits-in-rust/) distinguishes two techniques with *different* guarantees: (1) **supertrait sealing** blocks external *implementation* but not *calling* by code that already holds a value; (2) **unconstructible-token sealing** (`fn method(&self, _: private::Token)`) blocks *calling* too, since outside code cannot construct `private::Token` — this is exactly std's `Error::type_id(&self, _: private::Internal)` mechanism, and is the same primitive underlying capability tokens (§7.1): a `pub` type whose *constructor* is crate-private is an unforgeable capability. Explicit caveat: this breaks if the crate ever publicly exposes a value of the token type — a real semver trap.

### 7.4 Sketch: can't call `window.paint()` before `app.run()`

```rust
pub struct Uninit; pub struct Running;  // uninhabited marker states, unconstructible outside this module

pub struct App<S = Uninit> { /* .. */ _state: PhantomData<S> }
impl App<Uninit> {
    pub fn new() -> Self { .. }
    pub fn run(self, callback: impl FnOnce(&mut App<Running>)) {
        let mut running = App { _state: PhantomData };
        callback(&mut running);   // Uninit value is consumed/gone; only path to Running
    }
}
pub struct PaintCapability(());   // ZST, no public constructor
pub struct Window<'a> { app: &'a mut App<Running> }
impl App<Running> {
    pub fn open_window(&mut self) -> Window<'_> { .. }   // only constructible from App<Running>
}
impl<'a> Window<'a> {
    pub fn paint(&mut self, _cap: &PaintCapability, /* .. */) { .. }  // requires a token only
}                                                                      // the framework's paint
                                                                        // loop can construct
```
Result: `App::new().run(|app| ..)` is the only path to a `Window`; `Window::paint` cannot even be *named* before `run()` because `Window` doesn't exist yet (`no method named 'open_window' found for App<Uninit>`, a compile error, not a panic) — and within `run()`, `paint()` additionally requires an unforgeable `PaintCapability`, closing the "call `paint()` from a click handler" hole a bare phase-enum + `debug_assert!` (GPUI's current approach) cannot close in release builds.

---

## 8. `#[track_caller]` + `Location<'static>` as identity

**Stabilization — correcting the task's premise.** `#[track_caller]` and `Location::caller()` did **not** stabilize at 1.42. What shipped at 1.42 (Mar 2020) was an unstable, compiler-internal improvement to `unwrap()`/`expect()` messages. The stable attribute + API stabilized together in **1.46.0** (27 Aug 2020, RFC 2091, rust#72445) — confirmed on the current docs page: *"Stability: 1.46.0 (const: 1.79.0)."*

**Mechanism, precisely.** Per the [rustc-dev-guide](https://rustc-dev-guide.rust-lang.org/backend/implicit-caller-location.html): `#[track_caller]` adds a **hidden argument** (`&'static Location<'static>`) threaded explicitly through the call graph at the MIR level — *not* a runtime stack-walk. Propagation through chains: a tracked fn calling another tracked fn reports the location of "the first call within a non-tracked function body," walking as far up as the tracking chain extends, demonstrated in the stdlib's own doc example (a `#[track_caller]` fn called from a non-tracked wrapper reports the wrapper's *own* call site, not the wrapper's internal call). Because this is a structural, call-graph-level mechanism baked in before codegen, LLVM inlining does not change which location is reported (the argument was already fixed pre-inlining) — a reasonable inference from the mechanism, not separately blog-documented. Works on trait methods (applies to all impls) and generic/monomorphized functions without special-casing.

**Hard, structural limits, not implementation gaps:**
- **Loop collision**: `Location::caller()` resolves to the literal `file!()/line!()/column!()` of the call-site *token in source*. A call site written once inside a loop body is one lexical location; every iteration reports the identical `Location` — there is no runtime disambiguation.
- **Recursion**: same consequence — a recursive call site is one lexical location, so recursion depth is invisible.
- These are definitional to a compile-time-baked mechanism, not bugs to be fixed.

**Real usage: leptos.** `reactive_graph/src/wrappers.rs` uses `#[track_caller]` + `Location::caller()` **strictly for developer-facing diagnostics**, gated behind `#[cfg(any(debug_assertions, leptos_debuginfo))]`:
```rust
#[track_caller]
pub fn derive(derived_signal: impl Fn() -> T + Send + Sync + 'static) -> Self {
    Self { inner: SignalTypes::DerivedSignal(Arc::new(derived_signal)),
           #[cfg(any(debug_assertions, leptos_debuginfo))]
           defined_at: std::panic::Location::caller() }
}
```
Leptos's actual reactive *identity* comes from arena-slot allocation at the (non-looped, non-re-executed) call site itself — sidestepping the loop-collision problem, because unlike React/Compose (which re-execute the whole component body every render), leptos signal-creation calls typically execute exactly once.

**Direct real-world precedent for using `Location` as an implicit hooks-style key, including its documented failure mode: MoonZoon.** A Rust fullstack framework explicitly reached for this and hit the loop-collision problem directly: *"call ids based on a counter/indices are not stable enough... [we] get the Location of the caller... and thus can distinguish different calls by their caller, even if their index is equal"* ([dev.to writeup](https://dev.to/martinkavik/moonzoon-dev-news-3-signals-react-like-hooks-optimizations-39lp)) — confirming `Location` alone is **not sufficient**; it must be combined with an in-scope counter for the loop/list case, structurally identical to why React requires explicit `key=` props inside `.map()`.

**Precedent from other ecosystems**: Jetpack Compose's "positional memoization" ([writeup](https://newsletter.jorgecastillo.dev/p/positional-memoization-in-jetpack)) does the same call-order-based identity, but via *compiler-inserted* group markers from a dedicated compiler plugin — closer in spirit to what `Location::caller()` gives Rust "for free," without needing a custom compiler plugin, but with strictly weaker guarantees (lexical, not dynamic, uniqueness).

**Bottom line**: `Location::caller()` is a legitimate, stable, zero-runtime-cost *default* key for `use_signal(|| 0)`-style implicit state, but any real hooks API built on it needs a fallback counter for loops — it is not, by itself, a complete solution, and this is empirically confirmed by a real Rust framework's design writeup, not speculation.

`#[track_caller]` on `async fn` remains **unstable** (`async_fn_track_caller` feature gate, tracking [rust#110011](https://github.com/rust-lang/rust/issues/110011), open, still gated on nightly per symbol tables through nightlies dated mid-2026), blocked on an unresolved design question: should it report the *original caller* (where `foo()` was written) or the *poller* (which may be a completely different call site — an executor's poll loop)? Quoting the tracking issue: *"there's no way today for the executor to save off caller location information (e.g. in `spawn`) and re-provide it to the polled function."* **If the target framework wants `#[track_caller]`-quality error locations for async effects/handlers defined via native async closures (§12), that ergonomic win is not available on stable Rust today**, and is blocked on an open design question, not merely engineering time.

---

## 9. Bevy-style dependency injection (`SystemParam`)

Source read directly: `bevy/crates/bevy_ecs/src/system/system_param.rs` (sparse-cloned).

**The trait, precisely:**
```rust
pub unsafe trait SystemParam: Sized {
    type State: Send + Sync + 'static;
    type Item<'world, 'state>: SystemParam<State = Self::State>;
    fn init_state(world: &mut World) -> Self::State;
    fn init_access(state: &Self::State, system_meta: &mut SystemMeta,
                    component_access_set: &mut FilteredAccessSet, world: &mut World);
    unsafe fn get_param<'w, 's>(state: &'s mut Self::State, system_meta: &SystemMeta,
                                  world: UnsafeWorldCell<'w>, change_tick: Tick)
        -> Result<Self::Item<'w, 's>, SystemParamValidationError>;
}
```
The trailing safety doc states the contract explicitly as an *unsafe trait invariant the compiler does not check*: `init_access` must correctly register every access `get_param` performs, and none may conflict with prior registrations. The compiler only ensures the `unsafe impl` was written knowingly — it does not verify the invariant holds.

**Access description is type-driven; conflict detection is a runtime pass, not a `rustc` check.** `Res<T>`'s impl (`system_param.rs:672-702`):
```rust
unsafe impl<'a, T: Resource> SystemParam for Res<'a, T> {
    fn init_access(&component_id: &Self::State, system_meta: &mut SystemMeta,
                    component_access_set: &mut FilteredAccessSet, world: &mut World) {
        let mut filter = FilteredAccess::default();
        filter.add_read(component_id);
        filter.and_with(IS_RESOURCE);
        let conflicts = component_access_set.get_conflicts_single(&filter);
        if conflicts.is_empty() { component_access_set.add(filter); return; }
        panic!("error[B0002]: Res<{}> in system {} conflicts with a previous system parameter...");
    }
}
```
This runs at **`Schedule::initialize`**, lazily invoked from the *first* `schedule.run(world)` call — i.e., at app **startup**, not `cargo build` time. Same-system conflicts (`fn sys(a: Res<Foo>, b: ResMut<Foo>)`) hard-panic (documented error `B0002`, https://bevy.org/learn/errors/b0002/). **Cross-system conflicts do not panic at all** — the parallel executor computes each system's access set and uses it to decide which systems may run concurrently vs. must be serialized; `ParamSet<(Query<..>, Query<..>)>` is the escape hatch for a single system wanting two internally-conflicting queries. **Precise characterization: types describe access; a runtime pass at schedule-build/first-run time validates and either panics (same-system) or silently serializes (cross-system). This is never a `rustc` compile error.** The genuinely compile-time-verified part is narrower: you cannot accidentally touch data you didn't declare in your function signature — that's ordinary borrow-checking inside `get_param`'s `unsafe` block, upheld by the documented invariant.

**`all_tuples!`** — moved out of `bevy_ecs`/`bevy_utils` into its own crate, [`variadics_please`](https://github.com/bevyengine/variadics_please), and is **now a proc-macro**, not `macro_rules!` (confirmed by reading its generated source). Bevy's own issue tracker ([bevy#1559](https://github.com/bevyengine/bevy/issues/1559), closed *not planned*) documents why: the proc-macro avoids "weird type parameter orders due to parser constraints" inherent to `macro_rules!` recursive munching, at the cost of degraded rust-analyzer responsiveness inside `bevy_ecs` itself. Either way, this is unambiguously macro-generated boilerplate emulating variadics (concrete impls for arities 0–16), not a language feature.

**Variadic generics (language feature) — no accepted RFC, not close, as of 2026.** [PoignardAzur's RustWeek 2025 report](https://poignardazur.github.io/2025/06/07/report-on-variadics-rustweek/) confirms discussions remain at the survey stage; a necessary precondition (the new trait solver) only recently became partially available, making the lang team "more open to starting discussions" — but the article's own conclusion is just "Eventually." The long-running [internals megathread](https://internals.rust-lang.org/t/analysis-pre-rfc-variadic-generics-in-rust/13879) has never converted to an actual RFC.

**Sketch — context injection replacing `cx: &mut Context` threading:**
```rust
pub trait FromCx<'cx> { fn from_cx(cx: &'cx mut Cx) -> Self; }
impl<'cx, T: 'static> FromCx<'cx> for &'cx Signals<T> { .. }
impl<'cx> FromCx<'cx> for &'cx mut Renderer { .. }

fn my_view(signals: &Signals<Counter>, renderer: &mut Renderer) -> impl IntoElement { .. }
// framework-generated adapter pulls each param via FromCx::from_cx(cx)
```
**What this buys over plain `cx: &mut Context`**: ergonomics (no `cx.` boilerplate per line, self-documenting parameter types) and a documented narrowing of what a given callback touches. **What it does NOT buy**: no additional compiler-verified memory-safety guarantee — the Rust borrow checker already fully verifies `&mut Context` threading for a single call. `Cx` is still one struct behind the scenes; `from_cx` still needs `unsafe`/`UnsafeCell`-style splitting to hand out multiple disjoint `&mut` sub-borrows from one `&mut Cx`, exactly as bevy_ecs's `UnsafeWorldCell` does. The real value-add (multi-callback conflict bookkeeping) only matters once callbacks run concurrently/interleaved — much less relevant to GPUI's current single-threaded, directly-called `cx: &mut Context` model than to an ECS scheduler running systems in parallel.

---

## 10. Autoref/deref specialization

**The technique, precisely** (canonical source: dtolnay's [`case-studies/autoref-specialization`](https://github.com/dtolnay/case-studies/blob/master/autoref-specialization/README.md), read in full). Verbatim rule: *"if a method can be dispatched without autoref then it will be. Only if a method cannot be dispatched without autoref, the compiler will insert an autoref and attempt to resolve it again."* Ordinary, stable method resolution — the trick is arranging trait impls at *different reference depths* so this resolution order acts as a priority list. Real 2-level example from `anyhow` (the crate this technique was built for):
```rust
impl<T: Display> DisplayKind for &T {}     // requires one extra autoref  -> LOWER priority
impl<T: StdError> StdErrorKind for T {}    // no autoref needed           -> HIGHER priority
```
Calling `(&error).anyhow_kind()`: a `StdError`-implementing type matches the higher-priority impl directly; only if that fails does the compiler autoref again (`&&error`) and match the `Display` fallback. [Kalbertodt's N-level generalization](http://lukaskalbertodt.github.io/2019/12/05/generalized-autoref-based-specialization.html): assign priority level *i* of *N* exactly `N-i-1` layers of `&`, called via `(&&&value).foo()` — exactly the pattern in the task prompt — but flags that existing blanket impls (e.g. std's `Display for &T`) can interfere, motivating a local newtype wrapper `Wrapper(x)` to regain full control.

**Hard, explicit limitation, verbatim from dtolnay**: *"The way that this technique applies method resolution cannot be described by a trait bound, so for practical purposes you should think of this technique as working in macros only."* Inside a truly generic function body, method resolution uses the trait bound in scope, not the concrete instantiated type — so **this cannot be used inside `fn demo<T: ???>(value: T)`; it only works at a macro-expansion call site where the concrete type is visible to the resolver.**

**`inventory` crate** (cloned `dtolnay/inventory`, read `src/lib.rs` in full) — a genuinely different mechanism, often mentioned alongside for "framework-quality ergonomics": linker-section-based distributed registration. Each `submit!` invocation anywhere in the dependency graph emits a static into the platform's C++-style init-array section (`.init_array` on ELF, `__mod_init_func` on Mach-O, `.CRT$XCU` on MSVC/PE), which the OS loader runs before `main()`, linking the value onto a global intrusive list `collect!`-declared elsewhere — no central registry call needed from `main`.

**Sketch/honest assessment for `.child(x)` accepting `&str | String | impl Element | Signal<impl IntoElement>`:** what's realistic *without* any hack — a single blanket `impl<T: IntoElement> ... ` trait implemented for each accepted concrete type, called via a generic `fn child(self, child: impl IntoElement) -> Self`. This is ordinary trait polymorphism (not specialization), needs no macro trick, and is what GPUI's actual `IntoElement`/`ParentElement::child` already effectively does. Autoref specialization would only be needed for genuine *specialization* — the exact same call behaving differently depending on which traits `x`'s concrete type happens to implement (e.g. auto-wrapping a `Signal<E>` in a reactive subscription vs. not) — which requires either unsound nightly `#![feature(specialization)]` or the autoref-macro hack, and per the hard limitation above **the hack requires `.child()` to be a macro-expansion site, not a plain generic method as GPUI's fluent builder API needs it to be.** **Conclusion: for a fluent, non-macro builder API, plain blanket `IntoElement` impls (already GPUI's approach) are correct; autoref specialization is real and load-bearing in the ecosystem (anyhow) but a poor fit here, and is explicitly "a hack, not sanctioned by the language" per its own inventor's framing.**

---

## 11. Arena & self-referential structures

### 11.0 GPUI's existing per-frame arena (baseline, read directly)

`crates/gpui/src/arena.rs` implements a custom bump allocator (not `bumpalo` directly): `Chunk { start, end, offset: *mut u8 }` bump-pointer allocates, `Arena::clear()` resets all chunks (running stored `Drop` glue via function pointers). A thread-local `ELEMENT_ARENA: RefCell<Arena>` (`window.rs:273`) is cleared once per frame (`window.rs:425`), elements allocated into it as `ArenaBox<T>` during layout/paint. This is the standard "per-frame bump arena, reset wholesale after paint" pattern — safety comes from disciplined single-frame lifetime scoping, not generational indices or borrow-checked self-reference.

### 11.1 `ouroboros` — `#[self_referencing]`

Cloned, read `ouroboros/src/lib.rs` (crate root, ~400 lines) + macro source. Mechanism: heap-boxes every field (`AliasableBox`, from the `aliasable` crate — a `Box` that doesn't assert unique-noalias, required because self-referential pointers alias into supposedly-unique `Box` memory), and exposes access only through `with_FIELD`/`with_mut` closures reifying a struct-local `'this` lifetime, or (when covariance is syntactically provable) a direct `borrow_FIELD(&self) -> &FieldType` shortcut. Construction goes through a generated builder whose per-field closures run in declaration order against already-placed prior fields.

The unsafe core (`UnsafeSelfCell<ContainedIn, Owner, DependentStatic>`) documents five soundness invariants in comments (owner initialized once, never moved/mutated again; pointer stability across outer-struct moves; owner outlives dependent; dependent dropped before owner). **Covariance restriction is syntactic, not type-level** (`covariance_detection.rs`): `Box`/`Arc`/`Rc` always treated as covariant-transparent; anything unclassifiable requires explicit `#[covariant]`/`#[not_covariant]` annotation, and only covariant fields get the direct `borrow_FIELD` shortcut. **Docs state outright: "There is no `borrow_FIELD_mut`... Rust's borrow checker is currently not capable of ensuring that such a method would be used safely."** Async builders currently require manually `Pin<Box<dyn Future>>`-wrapped closures — ouroboros predates leveraging native async closures (§12) for this.

### 11.2 `self_cell` — simpler, covariant-only, `macro_rules!`-based

Cloned, read `src/unsafe_self_cell.rs` + `src/lib.rs`. Deliberately narrower than ouroboros: `macro_rules!`, not proc-macro (near-zero compile overhead, per the crate's own benchmark: "0.2s"), single owner/dependent shape (not arbitrary field chains), dependent must be `#[covariant]`. Same heap-then-borrow trick. **The README's "Related projects" section is itself useful evidence**: it documents the graveyard of unsound predecessors in this design space — `rental` (deprecated, unmaintained), `Schroedinger` (soundness issues), `owning_ref` (RUSTSEC-2022-0040) — both surviving crates explicitly cite **miri** (`cargo miri test`) as their actual soundness bar, not merely "it compiles." Directly relevant to §12: the README notes *"Using the `async_builder` option requires Rust 1.85 or newer"* — a self-referential-struct crate that has already been upgraded to depend on native async closures (stabilized 1.85, §12.1) for its async construction path.

### 11.3 `yoke` (ICU4X/unicode-org) — erase-then-reborrow "cart" pattern

Sparse-cloned `icu4x/utils/yoke`, read `yoke.rs` (2167 lines), `yokeable.rs`, `cartable_ptr.rs`. Core struct (`yoke.rs:80-94`, comment verbatim):
```rust
pub struct Yoke<Y: for<'a> Yokeable<'a>, C> {
    yokeable: KindaSortaDangling<Y>,   // "this will have a 'static lifetime parameter, that
    cart: C,                           //  parameter is a lie" — field order is load-bearing
}                                       // for drop order (yokeable dropped before cart)
```
The `Yokeable<'a>` trait is an `unsafe trait` with `type Output: 'a`, safe to implement "on types with a covariant lifetime parameter... where `Self::transform()`'s body can simply be `{ self }`" — the same covariance restriction ouroboros/self_cell hit; it's structural to this whole design space, not crate-specific. Construction (`yoke.rs:287-308`):
```rust
pub fn attach_to_cart<F>(cart: C, f: F) -> Self
where F: for<'de> FnOnce(&'de <C as Deref>::Target) -> <Y as Yokeable<'de>>::Output {
    let deserialized = f(cart.deref());
    Self { yokeable: KindaSortaDangling::new(unsafe { Y::make(deserialized) }), cart }
}
```
The `for<'de> FnOnce(..)` HRTB is the soundness mechanism, same species as generativity's brand-freshness trick (§6.4): because `f` must work for *any* `'de`, it structurally cannot smuggle out a reference from its own closure environment with a shorter lifetime. Reborrow (`yoke.rs:386-388`): `pub fn get<'a>(&'a self) -> &'a <Y as Yokeable<'a>>::Output { self.yokeable.transform() }` — reifies the erased lifetime to a real one scoped to `&'a self`, exactly the "View borrowing from Signal's arena, exposed via `.get()`" pattern the task describes. `Yoke::map_project` derives a child `Yoke<P, C>` borrowing only a subset of what the parent borrowed, yoked to the same cart — directly analogous to a child `View` borrowing a subset of a parent `View`'s data.

### 11.4 `Pin<Box<T>>` — when it's actually needed for a widget tree

None of ouroboros/self_cell/yoke need literal `std::pin::Pin` in their public API — they fully own alloc/dealloc and never hand out `&mut` to the owner post-construction (custom `Drop` glue does the pinning-equivalent job). `Pin<Box<T>>` in its literal form becomes necessary specifically when (a) the *caller*, not just the framework, needs to `poll()` a self-borrowing `Future` directly (`Future::poll(self: Pin<&mut Self>, ..)`), or (b) intrusive nodes point directly at sibling addresses (pinned linked lists, e.g. `tokio::sync::Notify`'s waiter list). For a typical retained-mode (parent owns `Vec<Box<dyn Node>>`) or immediate-mode (GPUI's per-frame arena) UI tree, **neither applies** — nodes reference each other via ids/arena indices, not raw self-pointers. `Pin` becomes relevant only if a framework wants to store `impl Future` effects *inline* in a component struct to avoid a heap box per effect — i.e. `Pin` is needed at the async-effect layer, not the widget-tree layer.

### 11.5 `slotmap` — generational safety is a RUNTIME check, not compile-time

Read `slotmap/src/{lib.rs, basic.rs}` directly. `KeyData` packs `idx: u32` + `version: NonZeroU32` (even = vacant, odd = occupied per-slot; a key's stored version is always forced odd via `| 1`). The actual staleness check (`basic.rs:700-706`):
```rust
pub fn get(&self, key: K) -> Option<&V> {
    let kd = key.data();
    self.slots.get(kd.idx as usize)
        .filter(|slot| slot.version == kd.version.get())   // <-- runtime equality check
        .map(|slot| unsafe { &*slot.u.value })
}
```
This is unambiguously a **runtime, `Option`-returning check evaluated at `.get()`/`.remove()` call time** — the classic ABA-problem defense (removed-then-reused index gets a bumped version, so a stale key silently misses instead of returning wrong/dangling data). **Important honesty point**: slotmap prevents use-after-free/UB (you get `None`, never a dangling reference), but does **not** prevent logic bugs where code silently no-ops on a stale key, and the compiler has zero leverage to catch "you're holding a key to something already removed" statically. `unsafe fn get_unchecked` additionally documents an escape hatch bypassing even the runtime check, pushing the soundness burden onto the caller. **This must be clearly distinguished from §6's branded-lifetime approach, which achieves the analogous guarantee at actual compile time** — slotmap is memory-safe-but-not-statically-verified; branded arenas are statically verified but structurally cost an `'id` type parameter everywhere.

### 11.6 Sketch: View borrowing directly from a Signal's arena slot — and why it's probably not worth it

```rust
self_cell!(
    struct SignalView<T: 'static> {
        owner: ArenaBox<T>,          // the signal's slot allocation ("cart")
        #[covariant]
        dependent: RenderedView,     // borrows fields out of `owner`
    }
);
```
**Ergonomic costs, evidenced directly by the crates read above:**
1. **Covariance-only** direct access; anything contravariant (closures over `'this`, `&mut T`) falls back to closure-only `with_mut` access, which doesn't compose across a render tree (you can't just store the derived reference in a struct field usable elsewhere — every access point must thread a closure).
2. **Construction is one up-front builder closure**, not incremental field assignment — awkward for a `View` built up progressively during a render pass.
3. **Heap allocation per self-referential wrapper** — all three approaches heap-box the owner for pointer stability, meaning a per-`View` heap allocation replaces what a plain arena-index would give for free with zero extra allocation. This is in direct tension with GPUI's existing "everything in one per-frame bump arena, nothing individually heap-allocated" design (§11.0) — self-referential wrappers fight the bump-arena philosophy rather than complementing it.
4. **No mutable direct accessor** — ouroboros states outright there is no sound `borrow_FIELD_mut`; a controlled-input widget writing back to its bound signal cannot get a plain `&mut` accessor from any of these crates.
5. Given all this friction, `yoke`'s lighter-weight "erase-to-'static, `.get()` reborrow" (no proc-macro, `map_project` for child views) is the least-bad of the three, but still requires implementing/deriving `unsafe trait Yokeable` per `View` type — ceremony a slotmap+index or GPUI's existing arena+`Rc`/id approach avoids entirely, at the cost of one extra pointer indirection or refcount bump per read. **Bottom line: arena-index/generational-key indirection (accepting slotmap's runtime-checked staleness) is almost certainly the better default for a reactive UI framework's hot render path; self-referential wrappers are better reserved for cold/rare cases** (e.g. a long-lived cached parsed-config view attached to loaded file bytes), not the per-frame `View` tree itself.

Sources: [ouroboros](https://github.com/someguynamedjosh/ouroboros), [self_cell](https://github.com/Voultapher/self_cell), [yoke (icu4x)](https://github.com/unicode-org/icu4x/tree/main/utils/yoke), [slotmap](https://github.com/orlp/slotmap).

---

## 12. Async frontier for UI tasks

### 12.1 Async closures — stabilized 1.85.0, Feb 2025

Confirmed via the [Rust 1.85.0 blog post](https://blog.rust-lang.org/2025/02/20/Rust-1.85.0/): three new prelude traits, `AsyncFn`/`AsyncFnMut`/`AsyncFnOnce` (RFC 3668). Exact shape (RFC text):
```rust
pub trait AsyncFnMut<Args>: AsyncFnOnce<Args> {
    type CallRefFuture<'a>: Future<Output = Self::Output> where Self: 'a;   // <- a GAT
    fn async_call_mut(&mut self, args: Args) -> Self::CallRefFuture<'_>;
}
```
`CallRefFuture<'a>` being a GAT is the crux: the returned future's type can depend on the specific `&'a mut self` used for *that* call, letting the future genuinely borrow the closure's own captures. **Precisely what this fixes vs. `|| async {}`** (quoting the RFC's own contrast): the old workaround — a sync `FnMut` closure returning an async block — structurally **cannot** borrow captures inside the returned future, because `FnMut::call_mut`'s return type is fixed/non-lifetime-generic:
```rust
for_each_city(|city_name| async {
    countries.push(parent_country(city_name).await);   // error: captured variable
});                                                       // cannot escape FnMut closure body
```
Native `async || {}` can borrow, because `async_call_mut`'s `CallRefFuture<'a>` GAT lets the returned future's type vary per-call. A second, independent motivator: before 1.85, generic APIs accepting "a closure returning a future" needed split HRTB bounds (`F: for<'c> FnMut(&'c str) -> Fut, Fut: Future<..>`) producing "mysterious higher-ranked lifetime errors" against real callers; `AsyncFn*` bounds bake this relationship into the trait directly. Backward-compat: anything already implementing `Fn*() -> Fut` gets a blanket `AsyncFn*` impl.

**Corroborating real-world uptake**: `self_cell`'s own README (§11.2) states its `async_builder` option "requires Rust 1.85 or newer" — direct evidence a self-referential-struct crate now depends on native async closures for its async construction path instead of `Pin<Box<dyn Future>>` boilerplate.

### 12.2 Sketch: `.on_click(async |cx| { .. })`

```rust
// Before 1.85 (the boilerplate most async-UI callback APIs still require today):
fn on_click(&mut self, handler: impl Fn(&mut Cx) -> Pin<Box<dyn Future<Output=()>>> + 'static) { .. }
.on_click(|cx| Box::pin(async move { cx.dispatch_action(Save); }))

// After 1.85, with native AsyncFnMut:
fn on_click(&mut self, handler: impl AsyncFnMut(&mut Cx) + 'static) { .. }
.on_click(async |cx| { cx.dispatch_action(Save); })
```
Threefold win: no manual `Box::pin` at every call site; the closure can genuinely borrow across an `.await` point (structurally forbidden by `|| async {}`); the bound composes correctly with generic dispatch code without hand-rolled HRTB spelling.

### 12.3 Waker-based fine-grained wakeups as a reactive scheduler — a plausible idea, NOT how real Rust reactive UI libs currently do it

`Waker` mechanics (confirmed against [std docs](https://doc.rust-lang.org/std/task/struct.Waker.html)): a type-erased `RawWaker{data, vtable}` with `clone/wake/wake_by_ref/drop` fn pointers; the safe alternative is `impl Wake for T { fn wake(self: Arc<Self>) }` + `Waker::from(Arc<W>)`. Contract: "as long as the executor keeps running... each invocation of `wake()` will be followed by at least one `poll()`" — multiple wakes may coalesce into one poll (no 1:1 guarantee), and `Waker: Send + Sync` (atomic refcounting on every clone/drop — pure overhead for a same-thread signal graph that never crosses threads).

**GPUI already uses this machinery** for task scheduling — read directly from `crates/gpui/src/platform_scheduler.rs:73-80`:
```rust
let waker = waker_fn(move || { unparker.unpark(); });
let mut cx = Context::from_waker(&waker);
if let Poll::Ready(()) = future.as_mut().poll(&mut cx) { return true; }
```
The question is whether *signal dependency tracking* (not just task polling) should reuse the same primitive: each effect, on running, registers `Arc<dyn Wake>` with every `Signal` it reads; `Signal::set()` calls `wake()` on every registered waker to mark the effect dirty. **However, checking the most mature fine-grained-reactive Rust UI library directly (leptos's `reactive_graph` crate, `src/traits.rs`) shows it does NOT do this** — it uses a thread-local `Observer` and explicit `Source`/`Subscriber` traits, not `std::task::Waker`. Plausible reasons: `Waker` is deliberately coarse ("poll me again," no payload describing *what* changed, whereas reactive graphs often want targeted invalidation); the `Send+Sync`+vtable-clone cost is unneeded for same-thread graphs; the coalescing semantics are right for "re-poll this task" but underspecified for "here's the precise dirty-leaf set," which reactive graphs generally want full control over (topological/priority ordering, glitch-free batching) that the executor-opaque `Waker` contract doesn't expose. **For the report: this is a cheap-to-prototype, plausible novel design (the primitive already exists in GPUI's own scheduler) but is not empirically validated by existing large Rust reactive UI codebases — flag as a design idea to validate, not "how it's already done."**

### 12.4 Structured concurrency for UI-task lifetime — moro and async-scoped, and the honest limit on "compile-time enforced"

**moro** (cloned) — status: **experimental/stalled**, last crates.io release 0.4.0 (Apr 2022), none since; the May 2025 Rust project-goals update suggests structured-concurrency guidance is being folded into the official Async Book instead of shipping moro itself. API: `moro::async_scope!(|scope| { scope.spawn(async { .. }) }).await`; `Scope<'scope, 'env: 'scope, R>` ties spawned-job borrows to the scope's lifetime.

**The single most important finding here**: moro's own README explains **why it only offers concurrency, not parallelism**, and this is load-bearing for the soundness claim: *"If moro tasks were running in parallel, there would be no way for us to ensure that the parallel threads spawned inside the scope are stopped before `method` returns... I do not believe parallel execution can be safely enabled without modifying the Future trait or Rust in some way."* Structurally confirmed by reading `scope.rs`: spawned jobs live in a `Mutex<Pin<Box<FuturesUnordered<..>>>>` only ever advanced from inside the parent scope future's own `poll_jobs` — no independent executor thread exists, so even `mem::forget`-ing the outer scope future is *sound* (it just stops advancing sub-tasks; nothing else was ever touching that memory independently).

**async-scoped** (cloned) takes the opposite, harder tradeoff — it spawns onto a *real* executor (genuine parallelism, exactly what moro's README says can't be done safely without new language support) — and pays for it with documented, explicit unsafety. Read directly from `src/scoped.rs`:
```rust
#[pin_project(PinnedDrop)]
pub struct Scope<'a, T, Sp: Spawner<T> + Blocker> { .. _marker: PhantomData<fn(&'a ()) -> &'a ()>, .. }
impl<'a, ..> Scope<'a, T, Sp> {
    /// This function is unsafe as `futs` may hold futures which have to be manually driven to completion.
    pub unsafe fn create(spawner: Sp) -> Self { .. }
    pub fn spawn<F: Future<Output = T> + Send + 'a>(&mut self, f: F) {
        let handle = self.spawner().spawn(unsafe {
            std::mem::transmute::<_, Pin<Box<dyn Future<Output = T> + Send>>>(Box::pin(f) as Pin<Box<dyn Future<Output=T>>>)
        });   // explicit transmute erasing 'a to 'static, to hand to a 'static-only executor spawn
    }
}
```
The crate's own docs are explicit: *"For soundness, we drive the stream to completion in the Drop impl. The current thread is blocked until [not-yet-finished futures complete]... since `std::mem::forget` can be used to circumvent this, the API here is inherently unsafe."* The only *safe* convenience entry point is `scope_and_block`, sidestepping the forget-hazard by synchronously blocking before returning control to any code that could leak the `Scope`.

**Direct answer to the honesty question posed in the task**: neither crate gives compiler-*proven* termination. What the `'scope`/`'a` lifetime parameters actually prove is narrower: it's a compile error for a spawned future or its output handle to be moved/leaked *past* the scope's lifetime bound (borrow-escape prevention — real and valuable, but not the same as termination). Termination is a *runtime* guarantee delivered two different ways:
- **moro**: sound-even-under-`mem::forget`, but only because it gave up true OS-level parallelism entirely (sub-tasks are just sub-polls of one future) — and moro itself is not an actively maintained crate as of 2026.
- **async-scoped**: a runtime-inserted blocking join in a `PinnedDrop` impl, explicitly documented as **unsound if the user manages to `mem::forget`/leak-amplify the `Scope` value** before that `Drop` runs. std's own `std::thread::scope` sidesteps this entire hazard class by design (never handing user code ownership of the scope value at all, only `&Scope`, joining explicitly inside `thread::scope`'s own function body) — a structurally stronger pattern than either moro or async-scoped achieves.

**Conclusion for the report: "compile-time-enforced task cancellation on unmount" is an overclaim for both crates.** What's compile-time enforced is lifetime containment of *borrows*; termination remains a runtime contract (blocking join in `Drop`, or moro's structural non-parallelism), with async-scoped's version carrying a documented `mem::forget` escape hatch.

### 12.5 `#[track_caller]` + `async fn` — see §8, still unstable, open design question (caller-vs-poller semantics) as of the live 2026 tracking issue.

Sources: [Rust 1.85.0 blog](https://blog.rust-lang.org/2025/02/20/Rust-1.85.0/), [RFC 3668](https://rust-lang.github.io/rfcs/3668-async-closures.html), [moro](https://github.com/nikomatsakis/moro), [async-scoped](https://github.com/rmanoka/async-scoped), [std::task::Waker docs](https://doc.rust-lang.org/std/task/struct.Waker.html), leptos [`reactive_graph`](https://github.com/leptos-rs/leptos/blob/main/reactive_graph/src/traits.rs).

---

## 13. `arbitrary_self_types` and `#[diagnostic::on_unimplemented]`

**`arbitrary_self_types`** — tracking [rust#44874](https://github.com/rust-lang/rust/issues/44874), RFC 3519 v2. Mechanism: a new `Receiver` trait with an associated `type Target`, blanket-implemented for anything `Deref` (backward compatible with `Box`/`Rc`/`Arc`/`Pin`), letting any crate define custom smart-pointer receivers:
```rust
struct Signal<T>(Box<T>);
impl<T> Receiver for Signal<T> { type Target = T; }
impl MyType { fn process(self: Signal<Self>) { } }   // exactly the pattern the task asked about
```
**Status: still nightly-only as of Aug 2026**, but an active, well-motivated 2026 project goal with real landed compiler infrastructure (main implementation PR #132961, stabilization PR opened at #135881). The May 2026 project-goals update lists it as still unfinished, with a specific in-flight item ("split the autoderef chain") still awaiting review, and notes the team is likely removing a since-abandoned design variant (`arbitrary_self_types_pointer`). Primary driver: **Rust-for-Linux**, which needs custom (non-std) smart-pointer receivers for kernel `Arc` alternatives. **A `fn method(self: Signal<Self>)` GUI-framework API built on this requires nightly indefinitely until stabilization actually lands** — real and credible, but not usable today.

**`#[diagnostic::on_unimplemented]` — IS stable, since 1.78.0.** Exact syntax ([Rust Reference](https://doc.rust-lang.org/reference/attributes/diagnostics.html)):
```rust
#[diagnostic::on_unimplemented(
    message = "My Message for `ImportantTrait<{A}>` is not implemented for `{Self}`",
    label = "My Label", note = "Note 1", note = "Note 2"
)]
trait ImportantTrait<A> {}
```
Keys: `message`/`label`/repeatable `note`; placeholders `{Self}` and `{GenericParamName}`; malformed contents degrade to a warning, not a build failure (deliberate forward/backward-compat design). Distinct from the older, compiler-internal-only `#[rustc_on_unimplemented]` that std itself still mostly uses.

**Real, directly-analogous production precedent: bevy_ecs.** Grepped the cloned `bevy_ecs` source directly — 18+ uses across `resource.rs`, `system/system.rs`, `query/fetch.rs`, `bundle/mod.rs`, etc., originating from [bevy#12377](https://github.com/bevyengine/bevy/issues/12377) whose stated problem is exactly what a reactive GUI's `IntoElement`/`Component` traits would hit: *"current error messages are unhelpful, displaying trait implementation failures for entire tuples with irrelevant generic type suggestions."* Real examples read directly from source:
```rust
// resource.rs:82
#[diagnostic::on_unimplemented(message = "`{Self}` is not a `Resource`", label = "invalid `Resource`",
    note = "consider annotating `{Self}` with `#[derive(Resource)]`")]
pub trait Resource: Component {}

// query/fetch.rs:319
#[diagnostic::on_unimplemented(message = "`{Self}` is not valid to request as data in a `Query`",
    label = "invalid `Query` data", note = "if `{Self}` is a component type, try using `&{Self}` or `&mut {Self}`")]
pub unsafe trait QueryData: WorldQuery { .. }
```

**Sketch for a reactive GUI framework:**
```rust
#[diagnostic::on_unimplemented(
    message = "`{Self}` cannot be used as a GPUI element child",
    label = "not an `IntoElement`",
    note = "if `{Self}` is a `String` or `&str`, check for a missing `.into_element()`",
    note = "if `{Self}` is your own view type, derive it with `#[derive(IntoElement)]`"
)]
pub trait IntoElement { fn into_element(self) -> AnyElement; }
```
Zero runtime cost, no macro machinery, a plain attribute on the trait declaration — directly mirrors the bevy_ecs precedent. Caveat: only fires for `E0277`-class ("trait not implemented") errors, not type mismatches inside an already-satisfied impl; typo'd placeholders silently degrade rather than failing the build, so this needs framework-side CI review, not something the type system verifies for you.

---

## Key synthesis questions

### Combination A: arena Copy signal handles + branded lifetime → use-after-dispose is a compile error

This is §6.6 in full: `UiArena<'id>` (generativity-branded, per §6) holding data, `SignalId<'id, T>` as a plain `Copy` index carrying an invariant `Id<'id>` phantom, reads/writes gated behind `&UiToken<'id>`/`&mut UiToken<'id>`. **This is the strongest, most concretely demonstrated combination in this entire investigation** — it is not speculative; qcell's own trybuild corpus contains a compiled, real `E0521` error (`lcell-02.rs`) proving the exact "wrong arena" mistake is rejected by rustc today, on stable Rust, with a real (if somewhat oblique) diagnostic. Slint ships this exact pattern in its interpreter today for structurally the same reason ("dynamically-loaded component instance vs. its description must not be mixed up").

**Ergonomic tax, stated plainly by the vendor of the closest real analogue (qcell)**: every framework-public function touching a signal needs an `'id` generic parameter or a `&UiToken<'id>` argument — real, provable, viral API surface pollution (confirmed via qcell's own doctest signatures and an internals.rust-lang.org thread specifically complaining that GhostCell-style designs can't be cleanly encapsulated behind a facade because Rust has no first-class "this struct owns a lifetime it invented" mechanism). This is precisely why the one production GUI framework using this trick (Slint) confines it to *interpreter internals*, never the public component-authoring API. **Verdict: use for the framework's own internal arena/signal-storage layer (where GPUI's `Context`/`Entity` machinery already lives), not for user-facing component code** — the same layering choice Slint made.

### Combination B: `&mut`-token contexts, no globals

```rust
fn counter(ui: &mut Ui) -> impl View + use<'_> { .. }
```
Per §1 (precise capturing, stable since 1.82/1.87) this compiles today and returns a view borrowing exactly what it needs from `ui`, nothing more, no `'static` wall. Where the borrow checker fights back, precisely, based on findings above:
- **Storing views**: per §3, you cannot name the `impl View` type to put it in a struct field without TAIT (still nightly-only, blocked on the next-gen trait solver, no ETA) — you're forced to `Box<dyn View>` (requires the trait to stay dyn-safe, i.e. avoid RPIT return types on the object-safe boundary per §2) or `SmallBox` (§3) or a closed macro-generated enum.
- **Event closures capturing `&mut ui`**: any callback wanting to mutate `ui` later (`.on_click(|ui| ui.set_count(...))`) cannot simultaneously hold the `&mut Ui` used to build the view *and* close over another `&mut Ui` for later — this is the textbook "one mutable borrow at a time" wall. The practical resolution the ecosystem actually uses (GPUI included, via `Entity<T>`/`WeakEntity` handles, and per §9's `SystemParam`-style access-splitting) is to *not* close over `&mut Ui` directly in stored callbacks, but over an index/handle that is re-resolved against a *fresh* `&mut Ui` argument each time the callback fires — i.e., the `&mut`-token model composes cleanly for *synchronous, single-call* builder functions (§1's verified example) but does not by itself solve *stored, later-invoked* callback storage; that still needs a handle-based indirection (Combination A, or GPUI's existing `Entity` system) layered on top.

### Combination C: Location-keyed implicit state without a runtime registry

Feasible as a *default*, not as a complete solution — directly confirmed by a real Rust framework's own postmortem (MoonZoon, §8): `Location::caller()` alone collides on loops/lists (same lexical call site → same `Location` every iteration) and on recursion, so any `use_signal(|| 0)`-style hook needs a fallback in-scope counter combined with `Location` for the loop case — structurally identical to why React needs explicit `key=` in `.map()`. **This still requires *some* runtime registry** (a per-component or per-scope slot table keyed by `(Location, counter)`), just not a *global* one — the registry can be scoped to the enclosing component/render-scope rather than process-wide, which is a real ergonomic win over a bare global `HashMap`, but it is not "no runtime residue," it's "runtime residue scoped correctly." Leptos's actual production choice — arena-slot identity fixed at the (once-executed) call site, `Location` reserved purely for diagnostics — is arguably the more robust design precisely because it avoids the loop-collision problem structurally rather than papering over it with a counter.

### What the type system fundamentally cannot verify — the honest runtime residue

Compiled from findings across all four research clusters:
1. **Dynamic dependency graphs** (which signals a given effect reads *this run*, which may differ run-to-run based on runtime branches) are inherently a runtime fact — no static analysis in any of the features surveyed (GATs, branded lifetimes, const generics, RPITIT) can enumerate a data-dependent read set ahead of time. Every real reactive system (leptos included, per §12.3) tracks this with a runtime `Observer`/subscriber list; branded lifetimes (§6) can make *aliasing* of a fixed set of cells provably safe, but say nothing about *which* cells get touched on a given run.
2. **Effect/task termination and ordering** — §12.4 is the sharpest evidence: even the most sophisticated structured-concurrency crates available (moro, async-scoped) only get the borrow checker to prove *lifetime containment of borrows* (a spawned task's captured references can't outlive its scope); actual termination-by-scope-exit is a *runtime* contract (blocking join in `Drop`, or moro's structural non-parallelism trick), and async-scoped's version is explicitly documented as unsound under `mem::forget`. There is no Rust-language mechanism today that proves a future actually completes.
3. **Cross-callback/system resource-conflict detection** (§9) is, even in Bevy — the most "type-driven" example surveyed — a **runtime pass at schedule-build/first-run time**, not a `rustc`-checked property; it uses types to *describe* access, then checks and resolves conflicts (panic or auto-serialize) with ordinary runtime code, not the type checker.
4. **Generational/arena staleness at the "cheap default" tier** (slotmap, §11.5) is unambiguously a runtime `Option`-returning check — the compile-time-verified alternative (branded arenas, §6) exists but costs the `'id`-infection tax; there is no free version of this guarantee.
5. **Refinement/semver drift in opaque return types** (§2) — the compiler *warns* but does not block a concrete impl from silently narrowing a trait's promised `impl Trait` return type; this is a static-analysis-adjacent gap the language has explicitly chosen not to close (RFC 3245 discussion still open).

**Overall shape of the finding**: Rust's frontier features are extremely good at proving **aliasing/lifetime/ownership properties of a fixed, statically-known shape** (which cell can be touched when, which borrow escapes which scope, which lifetime a returned value actually depends on) — and this investigation found real, working, sometimes-already-shipping-in-production (Slint, faer, bevy) evidence for that class of guarantee. They are structurally unable to prove properties that depend on **runtime data flow** (which signal fired, whether a task finished, whether two dynamically-scheduled callbacks' resource sets overlap) — those remain, in every crate/framework surveyed without exception, a runtime bookkeeping layer, at best type-*guided* (types describe what to check) rather than type-*verified* (types alone rule it out). A "compile-time-verified reactive GUI" is therefore honestly describable as: compile-time-verified **memory safety and aliasing discipline** around a runtime-verified **reactivity/scheduling** core — not a framework where the reactive graph itself is statically proven correct.

---

## Appendix A: repositories cloned and read

`qcell`, `generativity` (CAD97/generativity), `konst`, `ouroboros`, `self_cell`, `icu4x` (sparse: `utils/yoke`), `slotmap`, `moro`, `async-scoped`, `bevy` (sparse: `crates/bevy_ecs`), `inventory` (dtolnay), `typestate-rs` (rustype), `impl-trait-utils` (trait-variant), `smallbox`, `lending-iterator`, `polonius-the-crab`.

The research-time verification project contained eight edition-2024 binaries covering the samples
marked VERIFIED in §1–§4 and ran against rustc 1.97.1. It was temporary and is not an artifact in
this repository; [../migration.md](../migration.md) requires maintained compile tests for adopted
mechanisms.

## Appendix B: primary sources index

Rust blog: [1.82.0](https://blog.rust-lang.org/2024/10/17/Rust-1.82.0/), [1.85.0](https://blog.rust-lang.org/2025/02/20/Rust-1.85.0/), [1.75.0 / async-fn-rpit](https://blog.rust-lang.org/2023/12/21/async-fn-rpit-in-traits/), [1.46.0](https://blog.rust-lang.org/2020/08/27/Rust-1.46.0/), [GAT stabilization](https://blog.rust-lang.org/2022/10/28/gats-stabilization/), [Types Team Update 2024](https://blog.rust-lang.org/2024/06/26/types-team-update/), [May 2025 project goals](https://blog.rust-lang.org/2025/06/20/may-project-goals-update/), [2026-04 project goals](https://blog.rust-lang.org/2026/05/18/project-goals-2026-04/). Tracking issues: rust#123432, rust#130044, rust#121718, rust#63063, rust#95174, rust#128028, rust#132980, rust#143874, rust#67792, rust#110011, rust#44874. RFCs: 3617, 3425, 3245, 2091, 3668, 3519 v2, 2515 (TAIT). `rust-lang/goals` planning docs (`src/2026/const-generics.md`, `src/2026/const-traits.md`). Papers: Yanovski et al., GhostCell, ICFP 2021.
