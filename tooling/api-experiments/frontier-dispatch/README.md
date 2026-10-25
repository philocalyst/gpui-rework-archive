# Frontier dispatch experiment

This is a standalone, std-only model of selector capability dispatch. It keeps
the receiver mutation and typed method signatures, while removing GPUI layout,
reflection macro expansion, and the full element tree. The four compared paths
are:

* `hash-resolve`: look up a heterogeneous method record by schema in a
  process-owned `HashMap` once per selected element.
* `prebound-MRU2`: keep typed function pointers in a heterogeneous `Record`
  and use a two-entry most-recent schema cache before lending it to the calls.
* `native-trait-object`: lend one `&dyn Native` and make object-safe capability
  calls through it.
* `dense-index`: resolve a schema ordinal into a contiguous precompiled record.

The call mix runs 1, 4, or 16 typed operations on each element. Schema streams
are stable, alternate between two schemas, or rotate among three. The benchmark
does identical state mutations and verifies each path's checksum against the
hash lookup path. There is no unsafe code or external dependency.

Run it without invoking the GPUI workspace:

```sh
cargo test --manifest-path tooling/api-experiments/frontier-dispatch/Cargo.toml \
  --target-dir /tmp/frontier_dispatch_trial_target
cargo run --release --manifest-path tooling/api-experiments/frontier-dispatch/Cargo.toml \
  --target-dir /tmp/frontier_dispatch_trial_target
```

## Directional results

One local release run on 120,000 selected elements, averaged over 40 batches.
Numbers below are nanoseconds per element including the loop and identical
mutable work, so they are not isolated virtual-call costs.

| Schema stream | Calls/element | Hash lookup | Prebound | Trait object | Dense index |
| --- | ---: | ---: | ---: | ---: | ---: |
| stable | 1 | 9.67 | 2.53 | 2.51 | 2.96 |
| stable | 4 | 13.97 | 11.42 | 11.08 | 14.55 |
| stable | 16 | 60.23 | 51.21 | 54.70 | 50.67 |
| alternate-2 | 1 | 19.33 | 5.96 | 3.97 | 4.85 |
| alternate-2 | 4 | 27.83 | 19.53 | 14.06 | 16.32 |
| alternate-2 | 16 | 73.19 | 65.78 | 65.47 | 57.07 |
| alternate-3 | 1 | 15.02 | 7.10 | 3.92 | 4.52 |
| alternate-3 | 4 | 26.60 | 21.93 | 20.84 | 14.52 |
| alternate-3 | 16 | 71.77 | 66.03 | 67.67 | 54.64 |

The shape is more useful than any point estimate: resolving a schema record
once and using typed slots can matter when each element gets one call. When
each element gets many calls, the shared state mutation dominates and the gap
shrinks. A two-entry cache is sensitive to alternation and cache checks; the
dense index is consistently simple but requires a global ordinal contract.
The trait-object path is competitive in this toy, but its combined `Native`
interface makes every implementer expose every capability and does not model
compile-time capability admission or concrete-vs-wrapper-default policy.

`Record` is 24 bytes (three differently typed function pointers), a trait
object reference is 16 bytes, a three-schema dense table is 72 bytes, and the
two-entry prebound cache is 80 bytes. These are payload sizes only. The hash
registry additionally needs buckets and keys. In GPUI, nested group records
can scale with the number of reflected traits and are stored per selector's
two-entry projection cache; process-owned metadata currently stores descriptors
plus boxed tables in a `HashMap`.

## Adoption judgment

The most promising production-scale change is narrower than replacing the
reflection model: project an already-bound nested group record using its
compile-time proof when `ReflectedElement::with` narrows to a contained token.
`with` currently calls `Token::Group::bind_tables` again against the concrete
element metadata even though the outer group already contains the composed
tables and `ContainsCallable` has an index to the token's exact slot. A safe
proof-indexed projection could skip repeated metadata lookup and rebinding while
preserving the existing generated tables, receiver lifetime, and wrapper
semantics. It needs a table-projection method on the proof and focused tests for
nested `Both` groups. This prototype does not measure that exact change, so it
is an adoption hypothesis, not a demonstrated production win.

The dense-schema route is only attractive if GPUI has an independently useful
stable schema numbering scheme; assigning global ordinals adds registry and
initialization constraints. A universal native trait object weakens the
capability boundary and complicates custom traits with associated types. A
prebound record is closest to current architecture and already appears in the
selector target cache, but enlarging every cached record with redundant slots
would increase per-selector memory. Avoid unsafe type erasure: the current
typed `Any` downcast and static references make the safety story clearer.

These synthetic timings are directional only. They omit selector matching,
metadata cold initialization, tree traversal, component targets, cache misses
outside the chosen schema streams, allocations during real metadata creation,
and optimized calls from real derive-generated implementations. Do not use
them as GPUI performance claims.
