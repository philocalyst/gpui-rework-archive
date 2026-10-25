use std::{collections::HashMap, hint::black_box, mem::size_of, sync::OnceLock, time::Instant};

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
struct Node {
    value: u64,
    calls: u64,
}

type Style = fn(&mut Node, u64) -> u64;
type Interact = fn(&mut Node, bool) -> u64;
type Parent = fn(&mut Node) -> u64;

#[derive(Clone, Copy)]
struct Record {
    style: Style,
    interact: Interact,
    parent: Parent,
}

fn style_a(n: &mut Node, x: u64) -> u64 {
    n.value = n.value.wrapping_add(x + 3);
    n.calls += 1;
    n.value
}
fn style_b(n: &mut Node, x: u64) -> u64 {
    n.value = n.value.rotate_left(3).wrapping_add(x + 5);
    n.calls += 1;
    n.value
}
fn style_c(n: &mut Node, x: u64) -> u64 {
    n.value ^= x.wrapping_mul(17);
    n.calls += 1;
    n.value
}
fn interact_a(n: &mut Node, x: bool) -> u64 {
    n.value = n.value.wrapping_add(if x { 7 } else { 2 });
    n.calls += 1;
    n.value
}
fn interact_b(n: &mut Node, x: bool) -> u64 {
    n.value = n.value.rotate_right(2) ^ if x { 11 } else { 4 };
    n.calls += 1;
    n.value
}
fn interact_c(n: &mut Node, x: bool) -> u64 {
    n.value = n.value.wrapping_mul(if x { 3 } else { 5 });
    n.calls += 1;
    n.value
}
fn parent_a(n: &mut Node) -> u64 {
    n.value = n.value.wrapping_add(13);
    n.calls += 1;
    n.value
}
fn parent_b(n: &mut Node) -> u64 {
    n.value = n.value.rotate_left(1) ^ 19;
    n.calls += 1;
    n.value
}
fn parent_c(n: &mut Node) -> u64 {
    n.value = n.value.wrapping_mul(7).wrapping_add(23);
    n.calls += 1;
    n.value
}

const RECORDS: [Record; 3] = [
    Record {
        style: style_a,
        interact: interact_a,
        parent: parent_a,
    },
    Record {
        style: style_b,
        interact: interact_b,
        parent: parent_b,
    },
    Record {
        style: style_c,
        interact: interact_c,
        parent: parent_c,
    },
];

// A lending native object: one trait-object call per selected capability.
trait Native: Sync {
    fn style(&self, n: &mut Node, x: u64) -> u64;
    fn interact(&self, n: &mut Node, x: bool) -> u64;
    fn parent(&self, n: &mut Node) -> u64;
}
struct NativeA;
struct NativeB;
struct NativeC;
impl Native for NativeA {
    fn style(&self, n: &mut Node, x: u64) -> u64 {
        style_a(n, x)
    }
    fn interact(&self, n: &mut Node, x: bool) -> u64 {
        interact_a(n, x)
    }
    fn parent(&self, n: &mut Node) -> u64 {
        parent_a(n)
    }
}
impl Native for NativeB {
    fn style(&self, n: &mut Node, x: u64) -> u64 {
        style_b(n, x)
    }
    fn interact(&self, n: &mut Node, x: bool) -> u64 {
        interact_b(n, x)
    }
    fn parent(&self, n: &mut Node) -> u64 {
        parent_b(n)
    }
}
impl Native for NativeC {
    fn style(&self, n: &mut Node, x: u64) -> u64 {
        style_c(n, x)
    }
    fn interact(&self, n: &mut Node, x: bool) -> u64 {
        interact_c(n, x)
    }
    fn parent(&self, n: &mut Node) -> u64 {
        parent_c(n)
    }
}
static NATIVES: [&dyn Native; 3] = [&NativeA, &NativeB, &NativeC];

// `Dense` models an assigned schema ordinal and a compiled selector's fixed slot list.
// The registry is contiguous; resolution happens once per node, then calls use record fields.
const DENSE: [Record; 3] = RECORDS;
static HASH_REGISTRY: OnceLock<HashMap<usize, Record>> = OnceLock::new();

#[derive(Clone, Copy)]
enum Op {
    Style,
    Interact,
    Parent,
}
const OPS: [Op; 3] = [Op::Style, Op::Interact, Op::Parent];
fn invoke(record: &Record, n: &mut Node, op: Op, i: usize) -> u64 {
    match op {
        Op::Style => (record.style)(n, i as u64),
        Op::Interact => (record.interact)(n, i % 2 == 0),
        Op::Parent => (record.parent)(n),
    }
}
fn invoke_dyn(native: &dyn Native, n: &mut Node, op: Op, i: usize) -> u64 {
    match op {
        Op::Style => native.style(n, i as u64),
        Op::Interact => native.interact(n, i % 2 == 0),
        Op::Parent => native.parent(n),
    }
}

fn run_dynamic(ids: &[usize], calls: usize) -> u64 {
    let lookup = HASH_REGISTRY.get_or_init(|| RECORDS.into_iter().enumerate().collect());
    let mut sum = 0u64;
    let mut nodes = [Node::default(); 3];
    for (i, &id) in ids.iter().enumerate() {
        let rec = lookup.get(&id).unwrap();
        let n = &mut nodes[id];
        for j in 0..calls {
            sum = sum.wrapping_add(invoke(rec, n, OPS[j % 3], i + j));
        }
    }
    black_box(sum ^ nodes.iter().map(|n| n.value ^ n.calls).sum::<u64>())
}
fn run_prebound(ids: &[usize], calls: usize) -> u64 {
    // Two-entry MRU cache mirrors current selector schema alternation behavior.
    let mut cache: [(Option<usize>, Option<Record>); 2] = [(None, None); 2];
    let mut sum = 0u64;
    let mut nodes = [Node::default(); 3];
    for (i, &id) in ids.iter().enumerate() {
        let rec = if cache[0].0 == Some(id) {
            cache[0].1.unwrap()
        } else if cache[1].0 == Some(id) {
            let hit = cache[1].1.unwrap();
            cache = [(Some(id), Some(hit)), cache[0]];
            hit
        } else {
            let rec = RECORDS[id];
            cache = [(Some(id), Some(rec)), cache[0]];
            rec
        };
        let n = &mut nodes[id];
        for j in 0..calls {
            sum = sum.wrapping_add(invoke(&rec, n, OPS[j % 3], i + j));
        }
    }
    black_box(sum ^ nodes.iter().map(|n| n.value ^ n.calls).sum::<u64>())
}
fn run_trait_object(ids: &[usize], calls: usize) -> u64 {
    let mut sum = 0u64;
    let mut nodes = [Node::default(); 3];
    for (i, &id) in ids.iter().enumerate() {
        let n = &mut nodes[id];
        for j in 0..calls {
            sum = sum.wrapping_add(invoke_dyn(NATIVES[id], n, OPS[j % 3], i + j));
        }
    }
    black_box(sum ^ nodes.iter().map(|n| n.value ^ n.calls).sum::<u64>())
}
fn run_dense(ids: &[usize], calls: usize) -> u64 {
    let mut sum = 0u64;
    let mut nodes = [Node::default(); 3];
    for (i, &id) in ids.iter().enumerate() {
        let rec = &DENSE[id];
        let n = &mut nodes[id];
        for j in 0..calls {
            sum = sum.wrapping_add(invoke(rec, n, OPS[j % 3], i + j));
        }
    }
    black_box(sum ^ nodes.iter().map(|n| n.value ^ n.calls).sum::<u64>())
}

fn measure(_label: &str, f: impl Fn() -> u64) -> (f64, u64) {
    let rounds = 40;
    let mut checksum = 0u64;
    let start = Instant::now();
    for _ in 0..rounds {
        checksum = checksum.wrapping_add(black_box(f()));
    }
    (start.elapsed().as_nanos() as f64 / rounds as f64, checksum)
}

fn main() {
    let n = 120_000;
    let scenarios = [
        ("stable", (0..n).map(|_| 0).collect::<Vec<_>>()),
        ("alternate-2", (0..n).map(|i| i % 2).collect()),
        ("alternate-3", (0..n).map(|i| i % 3).collect()),
    ];
    println!(
        "Directional release benchmark; ns per selector-target batch (includes loop + mutable work); elements={n}"
    );
    println!("strategy          schema       calls  ns/batch  ns/call  checksum");
    for (scenario, ids) in scenarios {
        for calls in [1, 4, 16] {
            let (base, expected) = measure("dynamic", || run_dynamic(&ids, calls));
            for (name, f) in [
                ("hash-resolve", run_dynamic as fn(&[usize], usize) -> u64),
                ("prebound-MRU2", run_prebound),
                ("native-trait-object", run_trait_object),
                ("dense-index", run_dense),
            ] {
                let (ns, checksum) = if name == "hash-resolve" {
                    (base, expected)
                } else {
                    measure(name, || f(&ids, calls))
                };
                assert_eq!(checksum, expected, "{name} diverged for {scenario}/{calls}");
                println!(
                    "{name:18} {scenario:12} {calls:5} {:9.0} {:8.2} {checksum}",
                    ns,
                    ns / n as f64
                );
            }
        }
    }
    println!(
        "\nApproximate static payloads (excluding allocator/hash bucket overhead): Record={} bytes; Native vtable pointer={} bytes; dense registry={} bytes; 2-entry MRU cache={} bytes",
        size_of::<Record>(),
        size_of::<&dyn Native>(),
        size_of::<[Record; 3]>(),
        size_of::<[(Option<usize>, Option<Record>); 2]>()
    );
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn all_dispatches_agree_for_supported_call_shapes() {
        for ids in [&[0][..], &[0, 1][..], &[0, 1, 2, 1, 0][..]] {
            for calls in [1, 4, 16] {
                let a = run_dynamic(ids, calls);
                assert_eq!(run_prebound(ids, calls), a);
                assert_eq!(run_trait_object(ids, calls), a);
                assert_eq!(run_dense(ids, calls), a);
            }
        }
    }
}
