# Borrowed-description API proof

This dependency-free, safe Rust oracle proves the missing construction/lowering
seam. It is a design experiment, not a renderer or a reactive runtime.

```rust
use reactivity_api_lab::{El, View, Retained, column, describe, row, text, value};

struct Counter { title: String, count: u64, show: bool }
fn empty_state() -> El<'static> { text("empty") }
impl View for Counter {
    fn view(&self) -> El<'_> {
        let content = if self.show {
            row((text(&self.title), value(&self.count)))
        } else {
            empty_state()
        };
        column((content, Some(text("footer"))))
    }
}
let mut counter = Counter { title: "Counter".into(), count: 1, show: true };
let mut retained = Retained::default();
assert_eq!(describe(&counter, &mut retained).text_copies, 2);
counter.count += 1;
assert_eq!(describe(&counter, &mut retained).text_copies, 0);
drop(counter); // Retained contains owned values, never owner borrows.
assert_eq!(retained.nodes().len(), 5);
```

The exact root signatures are `View::view(&self) -> El<'_>` and
`describe(root: &(impl View + ?Sized), retained: &mut Retained) -> Promotion`.
Text and numeric operands use `text(&str) -> El<'_>` and
`value(&u64) -> El<'_>`. No context argument, TLS, UI macro, per-node trait object,
or hidden allocation arena is involved.

`row` and `column` take constructor children; `div()` starts empty and accepts
`.child(...)`. The closed child family accepts a concrete element, tuples of
zero through four sequences, `Option`, ordinary iterators, and `&Vec<T: View>`.
Their exact constructor bound is
`fn row<'a, C, S>(children: C) -> El<'a> where C: ChildSeq<'a, S>`
(likewise `column`). The inferred, sealed shape parameter `S` separates iterator
and tuple implementations without overlapping blanket impls. Users do not name
it in application code. There is no keyed List or shape-delta protocol here;
these are description sequence forms only. `.child` panics on a leaf in this
minimal oracle.

## Explicit amendment to the supplied element statutes

The arena/generativity claims in `final/02-elements.md` sections 1.1 and 8 do not
follow from `view(&self) -> El<'_>`. That method has no arena carrier. This proof
therefore adopts the semantic correction in `reactivity/PLAN.md`:

- Public `El<'a>` **owns its description headers** and borrows operands for an
  ordinary covariant `'a`. It carries no frame brand. It may live as long as its
  operands, span unrelated turns, and combine independently constructed nested
  descriptions. Static helpers shorten into borrowed branch arms.
- `El` cannot escape a borrowed operand or permit exclusive owner mutation while
  that description is subsequently used. It does not promise frame-only lifetime,
  no cross-turn storage, or `!Send`/`!Sync`. Ordinary Rust auto traits apply.
- Only internal lowering cursors have an invariant generative brand. The explicit
  `with_frame` callback quantifies a fresh brand, owns the temporary lowering
  vector, and admits only matching cursors. Escaping a cursor and using either
  outer cursors in inner frames or inner cursors in outer frames are rejected.
  No ambient scope participates in public construction.

`PhantomData` in the internal frame/cursor establishes cursor invariance; it is
not used to pretend public descriptions borrowed an inaccessible frame arena.
These restrictions and permissions are both executable fixtures.

## Ownership and cost ledger

`El` stores one inline enum header. A nonempty group owns a `Vec<El>` child chunk;
leaves allocate nothing and borrow text/value directly. There is no per-leaf box.
Nesting transfers child headers once into their parent's chunk. It does not
re-flatten every descendant into every ancestor. An inline child buffer cannot
directly contain recursive `El` values without an indirection or a separate chunk
owner; a flat owned chunk/offset representation remains a measured alternative,
not a claimed optimization of this oracle.

Measured on the supplied Rust 1.97.1 x86_64 toolchain:

| Record | Bytes |
| --- | ---: |
| `El` (including group Vec header when present) | 32 |
| Temporary lowered operand/header | 32 |
| Owned retained node (including String header when present) | 32 |
| Retained Vec header | 24 |
| Internal branded range cursor | 16 |

The two-group ledger sample has four live child headers, two live group
allocations, eight allocated child slots, and **256 bytes of group payload
capacity**, plus its 32-byte root header. Allocator metadata/rounding and source
strings are additional. Vec growth can allocate/reallocate repeatedly during
construction; the sample's capacity is toolchain behavior, not a stable ABI.

Every `describe` also allocates/grows a traversal-stack Vec (pointer slots) and
an internal lowering Vec (32-byte slots). Retained output grows one 32-byte-slot
Vec and owns each promoted nonempty text allocation. Empty groups/strings do not
require payload allocations. Group and temporary allocations recur on an
unchanged description. Retained capacity is reused. Equal text bytes are compared
before promotion and preserve the existing owned String buffer; the unchanged
test uses a different source allocation with identical bytes and verifies zero
text copies and identical retained buffer address.

Construction and lowering are O(nodes) amortized, plus text comparison/copy bytes.
Every description is rebuilt and visited: no sparse-update or zero-allocation
claim is made. Lowering and retained output use flat iterative traversals/storage.
Public description **drop remains recursive** through group Vecs and can overflow
the stack at adversarial depth. Tests exercise depth 512 and width 4096; they do
not establish arbitrary-depth safety. A production implementation needs an
iterative disposal/owned-chunk design or a documented depth budget.

Promotion updates an exclusively borrowed retained snapshot in place. It is not
an atomic candidate/publication protocol, and preorder value equality here is
not a proof of keyed reconciliation or the mount-cycle identity law. `value`
captures a plain borrowed scalar; this crate installs no permanent signal wire
and retains no source pointer. Field commands, routing, ports, `changed`, layout,
effects, worker handoff and application-purity enforcement remain separate gates.

## Verification

From the parent workspace after its ordinary lockfile refresh:

```sh
cargo test --manifest-path reactivity/Cargo.toml -p reactivity-api-lab --offline
cargo test --manifest-path reactivity/Cargo.toml -p reactivity-api-lab --offline ledger -- --nocapture
```

There are two internal tests, six public API tests, this compiled example, and
six compile-failure programs checked with rustc against the real library/source.
The latter pin escaping borrowed text (`E0515`), mutating a borrowed owner
(`E0502`), escaping a cursor, both nested cross-scope cursor directions (`E0521`),
and external child-family forgery (`E0277`). The test harness verifies diagnostic
causes, not just unsuccessful compilation. No third-party dependencies are used.
