//! Run in release mode. Defaults to the complete requested size/density matrix;
//! --quick selects a small smoke sweep. Timings are single-process microbenchmarks.
use gpui_reactivity_core::Tree;
use gpui_reactivity_template_lab::{Overrides, Property, Scene, Strategy, Target, Template};
use std::{
    hint::black_box,
    io::{self, Write},
    mem::size_of,
    time::Instant,
};

#[derive(Clone)]
struct EagerNode {
    parent: u32,
    first: u32,
    next: u32,
    value: u32,
}
struct Query {
    target: Target,
    instance: usize,
    node: usize,
}
fn nanos(start: Instant) -> u128 {
    start.elapsed().as_nanos()
}
fn rate(ns: u128, n: usize) -> f64 {
    if n == 0 { 0.0 } else { ns as f64 / n as f64 }
}
fn parents(n: usize) -> Vec<Option<u32>> {
    (0..n)
        .map(|i| {
            if i == 0 {
                None
            } else if i % 8 == 1 {
                Some(0)
            } else {
                Some(i as u32 - 1)
            }
        })
        .collect()
}
fn eager_pattern(parents: &[Option<u32>]) -> Vec<EagerNode> {
    let mut nodes: Vec<_> = parents
        .iter()
        .map(|parent| EagerNode {
            parent: parent.unwrap_or(u32::MAX),
            first: u32::MAX,
            next: u32::MAX,
            value: 0,
        })
        .collect();
    let mut last = vec![u32::MAX; nodes.len()];
    for (i, &parent) in parents.iter().enumerate() {
        if let Some(parent) = parent {
            let p = parent as usize;
            if last[p] == u32::MAX {
                nodes[p].first = i as u32;
            } else {
                nodes[last[p] as usize].next = i as u32;
            }
            last[p] = i as u32;
        }
    }
    nodes
}
fn run(instances: usize, nodes: usize, permille: usize, strategy: Strategy, kind: &str) {
    let parents = parents(nodes);
    let template = Template::new(&parents, &[]).unwrap();
    let property = Property::new(template.clone(), vec![0u32; nodes]).unwrap();
    let static_bytes = template.payload_bytes();
    let default_bytes = property.payload_bytes();
    let mut scene = Scene::with_capacity(instances);
    let mut ids = Vec::with_capacity(instances);
    let mount = Instant::now();
    for _ in 0..instances {
        ids.push(scene.mount(template.clone()).unwrap());
    }
    let mount_ns = nanos(mount);
    let mut overrides = Overrides::with_strategy(property, strategy);
    let cells = instances * nodes;
    let changes = cells * permille / 1000;
    let patch = Instant::now();
    for i in 0..changes {
        let cell = i * cells / changes;
        overrides
            .set(
                &scene,
                scene
                    .target(ids[cell / nodes], (cell % nodes) as u32)
                    .unwrap(),
                1,
            )
            .unwrap();
    }
    let patch_ns = nanos(patch);
    let override_bytes = overrides.payload_bytes();
    let handle_bytes = size_of::<Vec<gpui_reactivity_template_lab::InstanceId>>()
        + ids.capacity() * size_of::<gpui_reactivity_template_lab::InstanceId>();
    let total =
        static_bytes + default_bytes + scene.payload_bytes() + override_bytes + handle_bytes;
    let pattern = eager_pattern(&parents);
    let eager_mount = Instant::now();
    let mut eager: Vec<_> = (0..instances).map(|_| pattern.clone()).collect();
    let eager_mount_ns = nanos(eager_mount);
    let eager_bytes = size_of::<Vec<Vec<EagerNode>>>()
        + eager.capacity() * size_of::<Vec<EagerNode>>()
        + eager
            .iter()
            .map(|v| v.capacity() * size_of::<EagerNode>())
            .sum::<usize>();
    let fields_mount = Instant::now();
    let mut eager_fields: Vec<_> = (0..instances).map(|_| vec![0u32; nodes]).collect();
    let fields_mount_ns = nanos(fields_mount);
    let eager_field_bytes = static_bytes
        + size_of::<Vec<Vec<u32>>>()
        + eager_fields.capacity() * size_of::<Vec<u32>>()
        + eager_fields.iter().map(|v| v.capacity() * 4).sum::<usize>();
    let eager_patch = Instant::now();
    for i in 0..changes {
        let cell = i * cells / changes;
        eager[cell / nodes][cell % nodes].value = 1;
    }
    let eager_patch_ns = nanos(eager_patch);
    let field_patch = Instant::now();
    for i in 0..changes {
        let cell = i * cells / changes;
        eager_fields[cell / nodes][cell % nodes] = 1;
    }
    let field_patch_ns = nanos(field_patch);
    let mut rng = 0x81ac_9172u64;
    let queries: Vec<_> = (0..65_536)
        .map(|_| {
            rng ^= rng << 13;
            rng ^= rng >> 7;
            rng ^= rng << 17;
            let cell = rng as usize % cells;
            Query {
                target: scene
                    .target(ids[cell / nodes], (cell % nodes) as u32)
                    .unwrap(),
                instance: cell / nodes,
                node: cell % nodes,
            }
        })
        .collect();
    let read = Instant::now();
    let mut sum = 0u64;
    for q in &queries {
        sum += u64::from(*overrides.get(&scene, q.target).unwrap());
    }
    let read_ns = nanos(read);
    black_box(sum);
    let eager_read = Instant::now();
    let mut eager_sum = 0u64;
    for q in &queries {
        eager_sum += u64::from(eager[q.instance][q.node].value);
    }
    let eager_read_ns = nanos(eager_read);
    assert_eq!(sum, eager_sum);
    let field_read = Instant::now();
    let mut field_sum = 0u64;
    for q in &queries {
        field_sum += u64::from(eager_fields[q.instance][q.node]);
    }
    let field_read_ns = nanos(field_read);
    assert_eq!(sum, field_sum);
    let iterate = Instant::now();
    let mut all_sum = 0u64;
    for &id in &ids {
        all_sum += overrides
            .values(&scene, id)
            .unwrap()
            .map(|&v| u64::from(v))
            .sum::<u64>();
    }
    let iterate_ns = nanos(iterate);
    assert_eq!(all_sum, changes as u64);
    let eager_iterate = Instant::now();
    let eager_all: u64 = eager
        .iter()
        .flat_map(|v| v.iter())
        .map(|v| u64::from(v.value))
        .sum();
    let eager_iterate_ns = nanos(eager_iterate);
    assert_eq!(all_sum, eager_all);
    let field_iterate = Instant::now();
    let field_all: u64 = eager_fields
        .iter()
        .flat_map(|v| v.iter())
        .map(|&v| u64::from(v))
        .sum();
    let field_iterate_ns = nanos(field_iterate);
    assert_eq!(all_sum, field_all);
    // Physical payload model: exact pinned core slot width and full Vec capacity
    // at these power-of-two sizes, plus one typed u32 lane per instance.
    let core_model = size_of::<Vec<(Tree, Vec<u32>)>>()
        + instances
            * (size_of::<Tree>() + size_of::<Vec<u32>>() + nodes * (Tree::entry_bytes() + 4));
    // Keep topology-bearing eager nodes observable, not merely the value field.
    black_box(
        eager
            .iter()
            .map(|v| v[0].parent ^ v[0].first ^ v[0].next)
            .fold(0, |a, b| a ^ b),
    );
    println!(
        "{kind},{strategy:?},{instances},{nodes},{permille},{changes},{static_bytes},{default_bytes},{},{handle_bytes},{override_bytes},{total},{eager_bytes},{eager_field_bytes},{core_model},{:.2},{:.2},{:.2},{:.2},{:.2},{:.2},{:.2},{:.2},{:.2},{:.2},{:.2},{:.2}",
        scene.descriptor_bytes(),
        rate(mount_ns, instances),
        rate(eager_mount_ns, instances),
        rate(fields_mount_ns, instances),
        rate(patch_ns, changes),
        rate(read_ns, queries.len()),
        rate(eager_read_ns, queries.len()),
        rate(field_read_ns, queries.len()),
        rate(iterate_ns, cells),
        rate(eager_iterate_ns, cells),
        rate(eager_patch_ns, changes),
        rate(field_patch_ns, changes),
        rate(field_iterate_ns, cells)
    );
    io::stdout().flush().unwrap();
}
fn main() {
    let quick = std::env::args().any(|arg| arg == "--quick");
    println!(
        "kind,strategy,instances,nodes,permille,changes,template_bytes,default_bytes,descriptor_bytes,handle_bytes,override_bytes,total_payload,eager_node_payload,eager_field_payload,core_model_payload,mount_ns_per_instance,eager_mount_ns_per_instance,field_mount_ns_per_instance,patch_ns,read_ns,eager_read_ns,field_read_ns,iterate_ns_per_value,eager_iterate_ns_per_value,eager_patch_ns,field_patch_ns,field_iterate_ns_per_value"
    );
    let instance_counts: &[usize] = if quick { &[100] } else { &[100, 1000, 10000] };
    let node_counts: &[usize] = if quick { &[128] } else { &[16, 128, 1024] };
    for &instances in instance_counts {
        for &nodes in node_counts {
            for density in [0, 1, 10, 100, 1000] {
                run(instances, nodes, density, Strategy::Adaptive, "matrix");
            }
        }
    }
    for density in [1, 10, 100, 250, 500, 750, 1000] {
        for strategy in [Strategy::Sparse, Strategy::Dense] {
            run(100, 1024, density, strategy, "crossover");
        }
    }
    for nodes in [16, 128, 1024] {
        let template = Template::new(&parents(nodes), &[]).unwrap();
        let start = Instant::now();
        let mut check = 0;
        for query in 0..65_536 {
            let node = (query % nodes) as u32;
            check ^= template.topology().parent(node).unwrap().unwrap_or(0);
            check ^= template.topology().next_sibling(node).unwrap().unwrap_or(0);
            check ^= template.topology().subtree_len(node).unwrap() as u32;
        }
        let ns = nanos(start);
        black_box(check);
        eprintln!(
            "navigation nodes={nodes} bp_bytes={} index_bytes={} parent+sibling+subtree_ns={:.2}",
            template.topology().bit_bytes(),
            template.topology().index_bytes(),
            rate(ns, 65_536)
        );
    }
}
