use gpui_reactivity_template_lab::{
    Error, Overrides, Property, Representation, Scene, Strategy, Template, Topology,
};

struct Rng(u64);
impl Rng {
    fn next(&mut self, n: usize) -> usize {
        self.0 ^= self.0 << 13;
        self.0 ^= self.0 >> 7;
        self.0 ^= self.0 << 17;
        self.0 as usize % n
    }
}

fn check_navigation(parents: &[Option<u32>]) {
    let topology = Topology::new(parents).unwrap();
    let mut children = vec![Vec::new(); parents.len()];
    for (node, &parent) in parents.iter().enumerate() {
        if let Some(parent) = parent {
            children[parent as usize].push(node as u32);
        }
    }
    for (node, &parent) in parents.iter().enumerate() {
        assert_eq!(topology.parent(node as u32).unwrap(), parent);
        assert_eq!(
            topology.children(node as u32).unwrap().collect::<Vec<_>>(),
            children[node]
        );
        assert_eq!(
            topology.first_child(node as u32).unwrap(),
            children[node].first().copied()
        );
        let sibling = parent.and_then(|parent| {
            let siblings = &children[parent as usize];
            let i = siblings.iter().position(|&n| n == node as u32).unwrap();
            siblings.get(i + 1).copied()
        });
        assert_eq!(topology.next_sibling(node as u32).unwrap(), sibling);
        let mut stack = vec![node as u32];
        let mut count = 0;
        while let Some(node) = stack.pop() {
            count += 1;
            stack.extend(&children[node as usize]);
        }
        assert_eq!(topology.subtree_len(node as u32).unwrap(), count);
    }
    assert_eq!(topology.parent(parents.len() as u32), Err(Error::Node));
}

#[test]
fn succinct_navigation_matches_independent_explicit_trees() {
    for n in [1, 2, 31, 32, 33, 63, 64, 65, 127, 128, 129, 1024] {
        let star: Vec<_> = (0..n)
            .map(|i| if i == 0 { None } else { Some(0) })
            .collect();
        let chain: Vec<_> = (0..n)
            .map(|i| if i == 0 { None } else { Some(i as u32 - 1) })
            .collect();
        check_navigation(&star);
        check_navigation(&chain);
    }
    let mut rng = Rng(0x9123_acef);
    for _ in 0..120 {
        let n = 1 + rng.next(1500);
        let mut children = vec![Vec::new(); n];
        for node in 1..n {
            children[rng.next(node)].push(node);
        }
        let mut order = Vec::new();
        let mut stack = vec![0];
        while let Some(node) = stack.pop() {
            order.push(node);
            stack.extend(children[node].iter().rev().copied());
        }
        let mut ordinal = vec![0; n];
        for (i, &node) in order.iter().enumerate() {
            ordinal[node] = i as u32;
        }
        let mut parents = vec![None; n];
        for node in 0..n {
            for &child in &children[node] {
                parents[ordinal[child] as usize] = Some(ordinal[node]);
            }
        }
        check_navigation(&parents);
    }
    for invalid in [
        vec![],
        vec![Some(0)],
        vec![None, None],
        vec![None, Some(2)],
        vec![None, Some(0), Some(0), Some(1)],
    ] {
        assert!(Topology::new(&invalid).is_err());
    }
}

#[test]
fn immutable_deep_topology_uses_no_recursive_ownership() {
    let parents: Vec<_> = (0..100_000)
        .map(|i| if i == 0 { None } else { Some(i - 1) })
        .collect();
    let topology = Topology::new(&parents).unwrap();
    assert_eq!(topology.parent(99_999).unwrap(), Some(99_998));
    assert_eq!(topology.subtree_len(0).unwrap(), 100_000);
    assert_eq!(topology.bit_bytes(), 25_000);
}

#[test]
fn foreign_stale_and_distinct_equal_template_targets_are_checked() {
    let template = Template::new(&[None, Some(0)], &[]).unwrap();
    let equal = Template::new(&[None, Some(0)], &[]).unwrap();
    let property = Property::new(template.clone(), vec![10u32, 20]).unwrap();
    let mut field = Overrides::new(property);
    let mut a = Scene::new();
    let mut b = Scene::new();
    let first = a.mount(template.clone()).unwrap();
    let foreign = b.mount(template.clone()).unwrap();
    let target = a.target(first, 1).unwrap();
    assert_eq!(a.target(foreign, 1), Err(Error::Instance));
    assert_eq!(
        field.get(&a, b.target(foreign, 1).unwrap()),
        Err(Error::Instance)
    );
    let distinct = a.mount(equal).unwrap();
    assert_eq!(
        field.get(&a, a.target(distinct, 1).unwrap()),
        Err(Error::WrongTemplate)
    );
    assert_eq!(a.target(first, 2), Err(Error::Node));
    field.set(&a, target, 99).unwrap();
    a.unmount(first).unwrap();
    let fresh = a.mount(template).unwrap();
    assert_ne!(first, fresh);
    assert_eq!(field.get(&a, target), Err(Error::Instance));
    assert_eq!(*field.get(&a, a.target(fresh, 1).unwrap()).unwrap(), 20);
    field.set(&b, b.target(foreign, 1).unwrap(), 45).unwrap();
    field.retain_live(&a);
    assert_eq!(field.representation(first), Representation::Shared);
    assert_eq!(*field.get(&b, b.target(foreign, 1).unwrap()).unwrap(), 45);
}

#[derive(Clone, Debug, PartialEq)]
struct Paint {
    color: u32,
    opacity: u8,
}
#[test]
fn independent_typed_fields_share_defaults_and_isolate_instances() {
    let template = Template::new(&[None, Some(0), Some(0)], &[]).unwrap();
    let paint = Property::new(
        template.clone(),
        vec![
            Paint {
                color: 7,
                opacity: 255
            };
            3
        ],
    )
    .unwrap();
    let lengths = Property::new(template.clone(), vec![1.5f32; 3]).unwrap();
    let mut paints = Overrides::new(paint);
    let mut sizes = Overrides::new(lengths);
    let mut scene = Scene::new();
    let a = scene.mount(template.clone()).unwrap();
    let b = scene.mount(template).unwrap();
    let at = scene.target(a, 1).unwrap();
    let bt = scene.target(b, 1).unwrap();
    assert!(std::ptr::eq(
        paints.get(&scene, at).unwrap(),
        paints.get(&scene, bt).unwrap()
    ));
    let initial = paints.payload_bytes();
    assert!(
        !paints
            .set(
                &scene,
                at,
                Paint {
                    color: 7,
                    opacity: 255
                }
            )
            .unwrap()
    );
    assert_eq!(paints.payload_bytes(), initial);
    paints
        .set(
            &scene,
            at,
            Paint {
                color: 42,
                opacity: 90,
            },
        )
        .unwrap();
    sizes.set(&scene, bt, 9.0).unwrap();
    assert_eq!(paints.get(&scene, bt).unwrap().color, 7);
    assert_eq!(*sizes.get(&scene, at).unwrap(), 1.5);
    assert_eq!(
        paints
            .values(&scene, a)
            .unwrap()
            .map(|p| p.color)
            .collect::<Vec<_>>(),
        vec![7, 42, 7]
    );
    paints
        .set(
            &scene,
            at,
            Paint {
                color: 7,
                opacity: 255,
            },
        )
        .unwrap();
    assert_eq!(paints.representation(a), Representation::Shared);
    assert!(std::ptr::eq(
        paints.get(&scene, at).unwrap(),
        paints.get(&scene, bt).unwrap()
    ));
    drop(paints);
    assert_eq!(*sizes.get(&scene, bt).unwrap(), 9.0);
}

#[test]
fn randomized_all_storage_strategies_match_dense_value_oracle() {
    let n = 128;
    let parents: Vec<_> = (0..n)
        .map(|i| if i == 0 { None } else { Some(0) })
        .collect();
    let template = Template::new(&parents, &[]).unwrap();
    let property = Property::new(template.clone(), (0..n as u32).collect()).unwrap();
    let mut scene = Scene::new();
    let instances: Vec<_> = (0..20)
        .map(|_| scene.mount(template.clone()).unwrap())
        .collect();
    for strategy in [Strategy::Sparse, Strategy::Dense, Strategy::Adaptive] {
        let mut field = Overrides::with_strategy(property.clone(), strategy);
        let mut oracle: Vec<Vec<u32>> = vec![(0..n as u32).collect(); instances.len()];
        let mut rng = Rng(0x8172_3671);
        for step in 0..10_000 {
            let instance = rng.next(instances.len());
            let node = rng.next(n);
            let value = if rng.next(4) == 0 {
                node as u32
            } else {
                1000 + rng.next(9999) as u32
            };
            let target = scene.target(instances[instance], node as u32).unwrap();
            assert_eq!(
                field.set(&scene, target, value).unwrap(),
                oracle[instance][node] != value
            );
            oracle[instance][node] = value;
            assert_eq!(*field.get(&scene, target).unwrap(), value);
            if step % 100 == 0 {
                for (i, &instance) in instances.iter().enumerate() {
                    assert_eq!(
                        field
                            .values(&scene, instance)
                            .unwrap()
                            .copied()
                            .collect::<Vec<_>>(),
                        oracle[i]
                    );
                }
            }
        }
        for &instance in &instances {
            for node in 0..n {
                field
                    .set(
                        &scene,
                        scene.target(instance, node as u32).unwrap(),
                        node as u32,
                    )
                    .unwrap();
            }
            assert_eq!(field.representation(instance), Representation::Shared);
        }
    }
}

#[test]
fn explicit_dynamic_region_runs_validate_ownership_and_cycles_atomically() {
    let template = Template::new(&[None, Some(0)], &[0]).unwrap();
    let mut scene = Scene::new();
    let a = scene.mount(template.clone()).unwrap();
    let b = scene.mount(template.clone()).unwrap();
    let c = scene.mount(template).unwrap();
    let ar = scene.target(a, 0).unwrap();
    let br = scene.target(b, 0).unwrap();
    let cr = scene.target(c, 0).unwrap();
    scene.set_region(ar, vec![b, c]).unwrap();
    assert_eq!(scene.region(ar).unwrap(), &[b, c]);
    assert_eq!(scene.set_region(br, vec![a]), Err(Error::Cycle));
    assert_eq!(scene.set_region(br, vec![c]), Err(Error::Attached));
    assert_eq!(scene.set_region(ar, vec![b, b]), Err(Error::Duplicate));
    assert_eq!(
        scene.set_region(scene.target(a, 1).unwrap(), vec![]),
        Err(Error::Region)
    );
    assert_eq!(scene.region(ar).unwrap(), &[b, c]);
    scene.set_region(ar, vec![c]).unwrap();
    scene.set_region(br, vec![a]).unwrap();
    assert_eq!(scene.set_region(cr, vec![b]), Err(Error::Cycle));
    scene.unmount(a).unwrap();
    assert!(scene.region(br).unwrap().is_empty());
    assert!(scene.contains(c));
    scene.set_region(cr, vec![b]).unwrap();
}

#[test]
fn first_patch_does_not_clone_defaults_and_byte_ledger_balances() {
    use std::{cell::Cell, rc::Rc};
    #[derive(Debug)]
    struct Value {
        value: u32,
        clones: Rc<Cell<usize>>,
    }
    impl Clone for Value {
        fn clone(&self) -> Self {
            self.clones.set(self.clones.get() + 1);
            Self {
                value: self.value,
                clones: self.clones.clone(),
            }
        }
    }
    impl PartialEq for Value {
        fn eq(&self, other: &Self) -> bool {
            self.value == other.value
        }
    }
    let clones = Rc::new(Cell::new(0));
    let template = Template::new(&[None, Some(0), Some(0)], &[]).unwrap();
    let defaults = (0..3)
        .map(|value| Value {
            value,
            clones: clones.clone(),
        })
        .collect();
    let property = Property::new(template.clone(), defaults).unwrap();
    let mut scene = Scene::new();
    let instance = scene.mount(template).unwrap();
    let mut field = Overrides::new(property);
    let target = scene.target(instance, 1).unwrap();
    field
        .set(
            &scene,
            target,
            Value {
                value: 42,
                clones: clones.clone(),
            },
        )
        .unwrap();
    assert_eq!(clones.get(), 0);
    assert_eq!(field.ledger().total(), field.payload_bytes());
    assert!(field.ledger().sparse_values > 0);
    assert_eq!(field.ledger().dense_values, 0);
    field
        .set(&scene, target, Value { value: 1, clones })
        .unwrap();
    assert_eq!(field.ledger().sparse_values, 0);
}
