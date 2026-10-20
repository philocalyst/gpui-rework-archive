# Immutable template formulation experiment

A static subtree can be one immutable object shared by thousands of instances.
Each instance needs a template reference and an identity; it does not need a
mutable topology/style/value record for every static node. This crate tests that
formulation independently of the existing tree/runtime. It is safe Rust, has no
production dependencies, and uses core only as a development benchmark baseline.

```rust
use gpui_reactivity_template_lab::{Template, Scene, Property, Overrides};

let template = Template::new(&[None, Some(0), Some(0)], &[]).unwrap();
let colors = Property::new(template.clone(), vec![0xff_u32; 3]).unwrap();
let widths = Property::new(template.clone(), vec![10.0_f32; 3]).unwrap();
let mut color_edits = Overrides::new(colors);
let mut width_edits = Overrides::new(widths);
let mut scene = Scene::new();
let a = scene.mount(template.clone()).unwrap();
let b = scene.mount(template).unwrap();
let label_a = scene.target(a, 1).unwrap();
let label_b = scene.target(b, 1).unwrap();
color_edits.set(&scene, label_a, 0xaa).unwrap();
width_edits.set(&scene, label_b, 24.0).unwrap();
assert_eq!(*color_edits.get(&scene, label_b).unwrap(), 0xff);
```

Property kinds are ordinary Rust types. An application can define `Paint`, `Text`,
`MeasureKey`, or a compact scalar and keep independent `Property<T>` lanes. There
is no string property name, dynamic value enum, erased value bag or pointer-offset
patching. Defaults are stored once per field; first sparse mutation allocates
only the changed instance's field patch and clones no defaults. Clearing all
patches makes reads return the shared default references again.

## Topology, identity and explicit dynamic structure

The static topology is a balanced-parenthesis bitvector, one open and one close
bit per node. A node's local ordinal is its preorder index. An eight-byte rank/
net-excess/min-excess summary per 64 bits skips words during enclosing-parent and
matching-close searches. One four-byte opening-position sample per 32 nodes
supports ordinal lookup. Index plus bitvector use approximately **0.625 bytes per
node**, before small-array rounding and headers. These are immutable arrays,
not a compressed spelling of per-instance mutable nodes.

This deliberately small index does **not** provide constant-time navigation:
matching/enclosing searches can examine O(nodes/64) words, and sampled opening
selection can scan O(nodes) bits across a large closing run. On the checked
16/128/1024-node shapes, parent + next sibling + subtree-size queries took
49.4/100.7/105.0 ns together. Navigation is one shared-template cost, not one
retained metadata allocation per instance. A full range min-max hierarchy is an
available subsequent tradeoff if these scans dominate.

The representation follows the balanced-parenthesis/range-excess family studied
in [Navarro and Sadakane, Fully-Functional Static and Dynamic Succinct Trees](https://arxiv.org/abs/0905.0768).
[Arroyuelo et al., Succinct Trees in Practice](https://www.dcc.uchile.cl/~gnavarro/ps/alenex10.pdf)
compares practical BP/DFUDS/LOUDS representations. Those papers motivate the
representation; their asymptotic bounds and benchmark numbers are not claims
about this implementation. No template interner or ROBDD is implemented: callers
share an explicit Arc, and independently constructed equal templates remain
distinct objects. No hash-only equality shortcut exists.

Instance capabilities contain a nonwrapping scene id and an append-only slot.
Targets add a checked local ordinal. Foreign scenes, stale unmounted instances,
wrong-template fields and out-of-range ordinals fail before field access. Slots
are never reused; scene descriptors therefore retain mount-history tombstones.
This is a scoped append-only experiment, not a bounded-churn lifetime solution.

A template can declare particular nodes as dynamic regions. `Scene::set_region`
attaches a run of whole child instances to such a node. The static BP topology
never changes. Ownership is exclusive, duplicate children/cycles are rejected,
and validation precedes mutation. Unmounting one instance detaches its dynamic
children; it does not recursively destroy independently owned instances. Dynamic
attachment validation scans sparse runs, and is not a general fast editable tree.
Typed field patches are reclaimed explicitly with `retain_live(scene)` or
`clear_instance`; there is no erased registry coordinating unrelated field types.

## Sparse and dense field storage

An unchanged instance has no field record. Changed instances are sorted by their
full capability, with ordinal-sorted `(node, T)` patches. Adaptive mode promotes
an instance's field to dense values plus a presence bitmap when live sparse-entry
bytes reach the dense field/header size. Dense mode clones that field's defaults
once, not the whole subtree or other fields. Dense fields stay dense until empty;
there is no automatic demotion or history-independent memory claim. Sparse and
Dense policies are also public to allow measured comparison.

For u32 and 1024 nodes the payload threshold is 535 changed cells (52.25%):
`535 × 8 >= 56 + 1024 × 4 + 16 × 8`. Actual Vec capacity matters: at 50% occupancy,
forced sparse overrides used 414,760 bytes for 100 instances versus 433,160 dense;
at 75%, sparse capacity grew to 824,360 while dense stayed 433,160. Dense reads
were already faster at 50% (31.8 vs 57.8 ns), but full field iteration was slower
(1.42 vs 0.86 ns/value). The policy chooses a payload crossover, not a claim of a
universal speed crossover.

## Exact payload ledger

The library reports actual vector capacities and boxed slice lengths. On this
x86_64 build:

| Item | Bytes |
|---|---:|
| Template header including Topology and region-slice handles | 72 |
| BP bits | 8 × ceil(2N/64) |
| Word summaries | 8 × ceil(2N/64) |
| Opening samples | 4 × ceil(N/32) |
| Declared region ordinals | 4 each |
| Property<T> header | 24 |
| Shared defaults | N × size_of(T) |
| Scene header | 56 |
| Instance descriptor | 8 per mount-history slot capacity |
| InstanceId capability / Target capability | 16 / 24 |
| Overrides<u32> header | 40 |
| Changed-instance field descriptor | 48 per patch-vector capacity |
| Sparse u32 entry | 8 per sparse-vector capacity |
| Dense field header | 56 per allocated dense field |
| Dense u32 values | 4 per dense-vector capacity |
| Dense presence bits | 8 × ceil(N/64) |
| Dynamic run descriptor | 48 per run-vector capacity |
| Dynamic child capability | 16 per child-vector capacity |

`OverrideLedger` exposes the header, instance-descriptor, sparse-value, dense-header,
dense-value and presence-bit components separately. `payload_bytes` includes the
corresponding headers and all retained capacity, so clearing a patch can release
its values while retaining outer descriptor capacity. The benchmark total also
includes its retained Vec of instance capabilities (16 bytes/instance plus a
24-byte Vec header), not just the eight-byte scene descriptor.

These are exact owned **payload totals**, not RSS or allocator-usable-size totals.
They exclude Arc control blocks, allocation headers/alignment beyond Rust payload
layouts, benchmark query scratch/prototypes, and heap allocations internal to a
user-defined T. u32 has no internal heap allocation. In particular a dense field
uses additional allocations whose allocator overhead is not silently claimed zero.
The core column is a model from measured `Tree::entry_bytes()` (28), exact node
capacities at the tested power-of-two sizes, one u32 lane/node, and actual Tree/
Vec header widths. It is not a separately materialized or timed core workload.

## Reproduction and measured wins/losses

```sh
cargo test --manifest-path reactivity/Cargo.toml -p gpui_reactivity_template_lab
cargo clippy --manifest-path reactivity/Cargo.toml -p gpui_reactivity_template_lab --all-targets -- -D warnings
cargo run --release --manifest-path reactivity/Cargo.toml -p gpui_reactivity_template_lab --example sweep
# Add -- --quick for a smoke matrix.
```

[results.csv](results.csv) contains all 45 combinations of 100/1000/10000 instances,
16/128/1024 nodes and 0/0.1/1/10/100% overrides, plus 14 forced sparse/dense crossover
cases. Override cells are evenly distributed across the complete instance×node
space; the recorded count makes low-density rounding explicit. The shape has
short chains grouped under one root. Defaults are u32 zeros; changed values are
one. Full-scan checksums prove that updates are present. Random read checksums
match separately patched eager baselines.

| 10,000 instances | This formulation, payload including held ids | Eager nodes, 16 B/node + Vec headers | Shared topology + eager u32 fields |
|---|---:|---:|---:|
| 16 nodes, 0% overrides | 240,300 | 2,800,024 | 880,116 |
| 16 nodes, 10% | 1,215,660 | 2,800,024 | 880,116 |
| 16 nodes, 100% | 2,175,660 | 2,800,024 | 880,116 |
| 1024 nodes, 0% | 244,952 | 164,080,024 | 41,200,736 |
| 1024 nodes, 0.1% | 1,220,312 | 164,080,024 | 41,200,736 |
| 1024 nodes, 1% | 2,180,312 | 164,080,024 | 41,200,736 |
| 1024 nodes, 10% | 11,140,312 | 164,080,024 | 41,200,736 |
| 1024 nodes, 100% | 43,700,312 | 164,080,024 | 41,200,736 |

At 1024 nodes with no overrides, payload is about **670× smaller than eager nodes**
and **168× smaller than eager fields**. Cold mount was 7.3 ns/instance versus
6.33 µs eager-node cloning and 1.72 µs eager-field allocation. Default reads were
7.18 ns versus 13.90 ns from eager fields because the shared default array stays
small and hot.

The loss cases matter. At 16 nodes and 10% overrides, this design already uses
38% more payload than eager fields; at 100%, it uses 2.47× as much. At 1024 nodes
and 100%, it uses 6.1% more payload than eager fields, and random reads take
179.8 ns versus 13.86 ns. The two-level sparse lookup and presence checks cost
real work. This implementation is a strong candidate for shared static structure
and rare overrides, and a poor universal replacement for dense hot state.

Timing method: one release process, AMD Ryzen 7 3700X, Rust 1.97.1, x86_64, serial
wall-clock measurements with black_box/checksums; 65,536 random reads/case and one
full field scan. CPU affinity/frequency are not pinned and the run is not a
statistical confidence interval. Mount excludes template construction, and patch
time includes first-allocation/promotion costs. These are formulation
microbenchmarks, not GUI frame-rate or application RSS claims. Navigation timing
and build output are in [run.log](run.log).

Seven tests cover navigation against independent explicit adjacency trees,
120 randomized shapes, boundary stars/chains, 100,000-deep immutable topology,
30,000 randomized updates across all storage policies against a dense value
oracle, user-defined independently typed fields, no default cloning on first
patch, byte-ledger balance, override/drop isolation, stale/foreign/wrong-template
capabilities, and dynamic-region failure atomicity. No production rendering,
layout, reconciliation, subscription delivery, or arbitrary template mutation
is implemented by this lab.

The same fully overridden 10,000×1024 case measured 106.9 ns per first patch
versus 10.29 ns for eager-field writes, and 1.24 ns per full-scan value versus
0.27 ns for eager fields. Sparse patching optimizes retained storage for rare
changes; it does not make dense writes or scanning intrinsically cheaper.
