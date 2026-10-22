//! Independent full Consumer trees are test oracles, never runtime state.
use super::*;
fn cohort<M: View + 'static>(win: &Win<M>) -> Cohort {
    let mut cohort = Cohort::default();
    cohort.refresh(win).unwrap();
    cohort
}
use crate::property::{Contribution, TRANSFORM, WIDTH};
use crate::{
    Affine, El, FieldId, Signal, Source, Sources, WindowOptions, button, column, div, text,
    text_input,
};
use accesskit_consumer::{NodeRef, Tree, TreeChangeHandler};

#[derive(Default)]
struct Changes {
    updated: usize,
    added: usize,
    removed: usize,
}
impl TreeChangeHandler for Changes {
    fn node_added(&mut self, _: &NodeRef<'_>) {
        self.added += 1;
    }
    fn node_updated(&mut self, _: &NodeRef<'_>, _: &NodeRef<'_>) {
        self.updated += 1;
    }
    fn node_removed(&mut self, _: &NodeRef<'_>) {
        self.removed += 1;
    }
    fn focus_moved(&mut self, _: Option<&NodeRef<'_>>, _: Option<&NodeRef<'_>>) {}
}
fn full<M: View + 'static>(win: &Win<M>) -> TreeUpdate {
    project(
        &win.accessibility_sheet().unwrap(),
        win.accessibility_state().unwrap(),
        "Oracle",
        &cohort(win),
    )
}
fn acknowledge<M: View + 'static>(win: &mut Win<M>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn apply<M: View + 'static>(
    win: &Win<M>,
    base: State,
    tree: &mut Tree,
    sparse: Option<usize>,
) -> State {
    let state = win.accessibility_state().unwrap();
    let sheet = win.accessibility_sheet().unwrap();
    let delta = win.accessibility_delta(base, state);
    match sparse {
        Some(count) => assert_eq!(delta.map(<[u32]>::len), Some(count)),
        None => assert!(delta.is_none(), "transition must use full fallback"),
    }
    let update = if let Some(indices) = delta {
        project_sparse(&sheet, indices, &[], &cohort(win))
    } else {
        full(win)
    };
    let mut changes = Changes::default();
    tree.update_and_process_changes(update, &mut changes);
    let expected_update = full(win);
    let ids = expected_update
        .nodes
        .iter()
        .map(|(id, _)| *id)
        .collect::<Vec<_>>();
    let expected = Tree::new(expected_update, true);
    for id in ids {
        let a = tree
            .state()
            .node_by_tree_local_id(id, TreeId::ROOT)
            .unwrap();
        let b = expected
            .state()
            .node_by_tree_local_id(id, TreeId::ROOT)
            .unwrap();
        assert_eq!(a.data(), b.data(), "node{id:?}");
        assert_eq!(a.parent_id(), b.parent_id());
        assert_eq!(
            a.child_ids().collect::<Vec<_>>(),
            b.child_ids().collect::<Vec<_>>()
        );
    }
    assert_eq!(
        tree.state().focus_id_in_tree(),
        expected.state().focus_id_in_tree()
    );
    state
}

struct Many {
    count: usize,
    name: Signal<String>,
    enabled: bool,
    broken: bool,
}
impl Many {
    const NAME: Source<Self, String> =
        Source::new(FieldId::new(1), "name", |m| &m.name, |m| &mut m.name);
    fn new(count: usize) -> Self {
        Self {
            count,
            name: Signal::new("selected".into()),
            enabled: true,
            broken: false,
        }
    }
}
impl View for Many {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::NAME)
    }
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|i| {
            let el = div().w(1).h(1);
            let el = if i == self.count / 2 {
                el.name(&self.name).description(&self.name)
            } else {
                el.name("ordinary")
            };
            if self.enabled {
                el.on_click(|_: &mut Self| {})
            } else {
                el
            }
        }))
        .w(100)
        .bg(if self.enabled {
            crate::Color::WHITE
        } else {
            crate::Color::BLACK
        })
        .transform(if self.broken {
            Affine::scale(0., 1.)
        } else {
            Affine::IDENTITY
        })
    }
}
#[test]
fn hundred_thousand_p_one_leaf_field_and_inspector_match_full_consumer() {
    // MAX_NODES includes the root, hence 99,999 leaf nodes plus one column.
    let mut win = Win::with_size(Many::new(99_999), 100, 100).unwrap();
    let base = win.accessibility_state().unwrap();
    let mut tree = Tree::new(full(&win), true);
    win.accessibility_observe(true).unwrap();
    let target = win.query().name("selected").one().unwrap();
    win.set(Many::NAME, "field edit".to_owned()).unwrap();
    let base = apply(&win, base, &mut tree, Some(1));
    assert_eq!(base.token, win.accessibility_state().unwrap().token);
    win.set_semantic(
        target,
        crate::semantic::NAME,
        Contribution::Set(Some("inspector".into())),
    )
    .unwrap();
    apply(&win, base, &mut tree, Some(1));
    win.focus(target).unwrap();
    let focus = focus_update(&win.accessibility_sheet().unwrap(), &cohort(&win));
    assert!(focus.nodes.is_empty());
    tree.update_and_process_changes(focus, &mut Changes::default());
    assert_eq!(
        tree.state().focus_id_in_tree(),
        tree.state()
            .node_by_tree_local_id(
                NodeId(
                    win.accessibility_sheet()
                        .unwrap()
                        .part_at(50_000)
                        .unwrap()
                        .native_id()
                        * 2
                ),
                TreeId::ROOT
            )
            .unwrap()
            .id()
    );
    let base = win.accessibility_state().unwrap();
    win.set_semantic(
        target,
        crate::semantic::NAME,
        Contribution::Set(Some("inspector".into())),
    )
    .unwrap();
    // Epoch advances with exactly the same native payload; cursor must advance.
    apply(&win, base, &mut tree, Some(0));
}

#[test]
fn nonleaf_replacements_keep_all_ordered_children_and_geometry() {
    let mut win = Win::with_size(Many::new(6), 100, 100).unwrap();
    win.accessibility_observe(true).unwrap();
    let mut tree = Tree::new(full(&win), true);
    let base = win.accessibility_state().unwrap();
    let root = win.inspect().unwrap().nodes[0].target.unwrap();
    win.set_semantic(
        root,
        crate::semantic::DESCRIPTION,
        Contribution::Set(Some("container help".into())),
    )
    .unwrap();
    let base = apply(&win, base, &mut tree, Some(1));
    let leaf = win.query().name("selected").one().unwrap();
    win.set_property(leaf, WIDTH, Contribution::Set(Some(12.)))
        .unwrap();
    let base = apply(&win, base, &mut tree, Some(1));
    win.set_property(
        leaf,
        TRANSFORM,
        Contribution::Set(Affine {
            a: -1.,
            tx: 20.,
            ..Affine::IDENTITY
        }),
    )
    .unwrap();
    let base = apply(&win, base, &mut tree, Some(1));
    win.update(|m| m.enabled = false).unwrap();
    apply(&win, base, &mut tree, Some(6)); // complete action/role replacements
}

#[test]
fn pending_metadata_and_failed_newer_prepare_keep_old_p_and_fallback() {
    let mut win = Win::recording(
        Many::new(6),
        WindowOptions {
            size: [100, 100],
            ..Default::default()
        },
    )
    .unwrap();
    acknowledge(&mut win);
    win.accessibility_observe(true).unwrap();
    let mut tree = Tree::new(full(&win), true);
    let base = win.accessibility_state().unwrap();
    let target = win.query().name("selected").one().unwrap();
    win.set_property(target, WIDTH, Contribution::Set(Some(12.)))
        .unwrap();
    assert_eq!(win.accessibility_state().unwrap(), base);
    assert!(win.accessibility_delta(base, base).is_none());
    win.set_semantic(
        target,
        crate::semantic::DESCRIPTION,
        Contribution::Set(Some("after prepared".into())),
    )
    .unwrap();
    assert_eq!(win.accessibility_state().unwrap(), base);
    acknowledge(&mut win);
    let base = apply(&win, base, &mut tree, None);
    // Preserve a coherent prepared candidate while a newer attempt fails.
    win.set_property(target, WIDTH, Contribution::Set(Some(14.)))
        .unwrap();
    let coherent = win.with_scene(|_, token| token).unwrap();
    assert!(win.update(|m| m.broken = true).is_err());
    win.presented(coherent).unwrap();
    apply(&win, base, &mut tree, None);
}

#[test]
fn missed_epochs_topology_cap_deactivation_and_resize_are_full() {
    let mut win = Win::with_size(Many::new(5000), 100, 100).unwrap();
    win.accessibility_observe(true).unwrap();
    let mut tree = Tree::new(full(&win), true);
    let base = win.accessibility_state().unwrap();
    win.set(Many::NAME, "missed".into()).unwrap();
    win.set(Many::NAME, "latest".into()).unwrap();
    let base = apply(&win, base, &mut tree, None);
    win.update(|m| m.enabled = false).unwrap();
    let base = apply(&win, base, &mut tree, None);
    let (_, observer, capacity, used) = win.accessibility_storage();
    assert_eq!(observer, 80);
    assert!(capacity <= 4096 * 4);
    assert_eq!(used, 0);
    win.update(|m| m.count -= 1).unwrap();
    let base = apply(&win, base, &mut tree, None);
    win.accessibility_observe(false).unwrap();
    win.set(Many::NAME, "inactive".into()).unwrap();
    win.accessibility_observe(true).unwrap();
    let base = apply(&win, base, &mut tree, None);
    win.resize([101, 102]).unwrap();
    apply(&win, base, &mut tree, None);
}

struct Texts {
    value: Signal<String>,
}
impl Texts {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Texts {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.value),
            text_input(&self.value).name("editor"),
            button("button"),
        ))
        .w(200)
    }
}
#[test]
fn synthetic_shape_changes_and_value_children_match_full() {
    let mut win = Win::with_size(
        Texts {
            value: Signal::new("visual".into()),
        },
        200,
        100,
    )
    .unwrap();
    win.accessibility_observe(true).unwrap();
    let mut tree = Tree::new(full(&win), true);
    let base = win.accessibility_state().unwrap();
    let label = win.role(Role::Text).one().unwrap();
    win.set_semantic(
        label,
        crate::semantic::NAME,
        Contribution::Set(Some("different".into())),
    )
    .unwrap();
    let base = apply(&win, base, &mut tree, None);
    win.set(Texts::VALUE, "café naïve".into()).unwrap();
    let base = apply(&win, base, &mut tree, Some(2));
    win.set_semantic(label, crate::semantic::NAME, Contribution::Set(None))
        .unwrap();
    let base = apply(&win, base, &mut tree, Some(1));
    win.set_semantic(label, crate::semantic::NAME, Contribution::Inherit)
        .unwrap();
    apply(&win, base, &mut tree, None);
}

#[test]
fn exact_window_stamp_empty_recovery_and_observer_storage_are_bounded() {
    let mut win = Win::recording(
        Many::new(6),
        WindowOptions {
            size: [100, 100],
            ..Default::default()
        },
    )
    .unwrap();
    acknowledge(&mut win);
    let before = win.accessibility_state().unwrap();
    let inactive = allocation_counter::measure(|| {
        for _ in 0..1000 {
            win.accessibility_observe(false).unwrap();
        }
    });
    assert_eq!(inactive.count_total, 0);
    let active = allocation_counter::measure(|| win.accessibility_observe(true).unwrap());
    let (_, observer, capacity, indices) = win.accessibility_storage();
    assert_eq!(active.count_total, 1);
    assert_eq!(active.bytes_current, observer as i64);
    assert_eq!((capacity, indices), (0, 0));
    win.set(Many::NAME, "edit".into()).unwrap();
    let after = win.accessibility_state().unwrap();
    assert_eq!(win.accessibility_delta(before, after).unwrap().len(), 1);
    let other = Win::with_size(Many::new(6), 100, 100).unwrap();
    assert!(
        win.accessibility_delta(other.accessibility_state().unwrap(), after)
            .is_none()
    );
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
    assert_eq!(
        win.accessibility_delta(before, after).unwrap().len(),
        1,
        "repeat ack preserves exact transition"
    );
    win.presentation_lost().unwrap();
    assert!(!win.accessibility_state().unwrap().valid);
    win.presented(token).unwrap();
    assert_eq!(
        win.accessibility_state().unwrap(),
        after,
        "identical P recovery does not invent a native generation"
    );
    win.accessibility_observe(false).unwrap();
    let (_, observer, capacity, indices) = win.accessibility_storage();
    assert_eq!((observer, capacity, indices), (0, 0, 0));
}

#[test]
fn list_scroll_same_source_epoch_and_reindex_match_full_oracle() {
    use crate::{ItemKey, ItemSource, ListId, uniform_list};
    struct Rows {
        keys: Vec<u64>,
    }
    impl ItemSource for Rows {
        fn len(&self) -> usize {
            self.keys.len()
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(self.keys[index])
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            self.keys.iter().position(|&k| k == key.get())
        }
        fn row(&self, index: usize) -> El<'_> {
            div().name(format!("row {}", self.keys[index])).h(20)
        }
    }
    impl View for Rows {
        fn view(&self) -> El<'_> {
            uniform_list(ListId::new(1), self, 20).w(100).h(60)
        }
    }
    let mut win = Win::with_size(
        Rows {
            keys: (0..100).collect(),
        },
        100,
        60,
    )
    .unwrap();
    win.accessibility_observe(true).unwrap();
    let mut tree = Tree::new(full(&win), true);
    let base = win.accessibility_state().unwrap();
    let list = win.list(ListId::new(1)).unwrap();
    win.scroll(list, 20.).unwrap();
    assert_eq!(base.epoch, win.accessibility_state().unwrap().epoch);
    assert_ne!(base.token, win.accessibility_state().unwrap().token);
    let base = apply(&win, base, &mut tree, None);
    win.update(|m| m.keys.insert(0, 100)).unwrap();
    let base = apply(&win, base, &mut tree, Some(4)); // list count plus three frozen row positions
    win.resize_scaled([100, 60], 1.25).unwrap();
    apply(&win, base, &mut tree, Some(7)); // same size/topology; all seven physical transforms change
}

/// Opt-in, serialized release measurements. The complete Consumer oracle above
/// owns correctness; this fixture measures actual owner turns and node lowering.
#[test]
#[ignore = "serialized release timing; writes CSV rows to stdout"]
fn sparse_transition_measurements() {
    use std::{hint::black_box, time::Instant};
    fn report(case: &str, count: usize, active: bool, mut operation: impl FnMut()) {
        operation(); // warm allocator/descriptor capacity; report steady operation
        let allocation = allocation_counter::measure(&mut operation);
        let mut samples = [0u128; 31];
        for value in &mut samples {
            let start = Instant::now();
            operation();
            *value = start.elapsed().as_nanos();
        }
        samples.sort_unstable();
        println!(
            "SPARSE,{case},{count},{active},{},{},{},{},{},{},{},{}",
            allocation.count_total,
            allocation.bytes_total,
            allocation.bytes_current,
            allocation.bytes_max,
            samples[15],
            samples[29],
            samples[30],
            samples.len(),
        );
    }
    println!(
        "SPARSE,case,p_nodes,active,allocations,total_bytes,net_bytes,peak_bytes,p50_ns,p95_ns,p99_ns,samples"
    );
    for count in [1000, 10_000] {
        for active in [false, true] {
            let mut win = Win::with_size(Many::new(count - 1), 100, 100).unwrap();
            win.accessibility_observe(active).unwrap();
            let target = win.query().name("selected").one().unwrap();
            let mut n = 0;
            report("field_owner_turn", count, active, || {
                n += 1;
                win.set(Many::NAME, format!("field {n}")).unwrap();
            });
            report("identity_owner_turn", count, active, || {
                n += 1;
                win.set_semantic(
                    target,
                    crate::semantic::DESCRIPTION,
                    Contribution::Set(Some(format!("identity {n}"))),
                )
                .unwrap();
            });
            report("geometry_owner_turn", count, active, || {
                n += 1;
                win.set_property(
                    target,
                    WIDTH,
                    Contribution::Set(Some(if n % 2 == 0 { 2. } else { 3. })),
                )
                .unwrap();
            });
            report("dense_owner_turn", count, active, || {
                win.update(|m| m.enabled = !m.enabled).unwrap();
            });
            let (header, observer, capacity, used) = win.accessibility_storage();
            println!("STORAGE,{count},{active},{header},{observer},{capacity},{used}");
        }
    }
    struct Scrolling;
    impl crate::ItemSource for Scrolling {
        fn len(&self) -> usize {
            100_000
        }
        fn key(&self, index: usize) -> crate::ItemKey {
            crate::ItemKey::new(index as u64)
        }
        fn index_of(&self, key: crate::ItemKey) -> Option<usize> {
            usize::try_from(key.get())
                .ok()
                .filter(|&index| index < self.len())
        }
        fn row(&self, index: usize) -> El<'_> {
            div().name(format!("row {index}")).h(20)
        }
    }
    impl View for Scrolling {
        fn view(&self) -> El<'_> {
            crate::uniform_list(crate::ListId::new(1), self, 20)
                .w(100)
                .h(260)
        }
    }
    for active in [false, true] {
        let mut win = Win::with_size(Scrolling, 100, 260).unwrap();
        win.accessibility_observe(active).unwrap();
        let target = win.list(crate::ListId::new(1)).unwrap();
        let mut down = false;
        report("scroll_owner_turn", 27, active, || {
            down = !down;
            win.scroll(target, if down { 20. } else { -20. }).unwrap();
        });
    }
    for count in [1000, 10_000, 100_000] {
        let mut win = Win::with_size(Many::new(count - 1), 100, 100).unwrap();
        win.accessibility_observe(true).unwrap();
        let base = win.accessibility_state().unwrap();
        win.set(Many::NAME, "one changed leaf".into()).unwrap();
        let state = win.accessibility_state().unwrap();
        let delta = win.accessibility_delta(base, state).unwrap();
        assert_eq!(delta.len(), 1);
        let sheet = win.accessibility_sheet().unwrap();
        report("full_projection", count, true, || {
            black_box(project(&sheet, state, "Oracle", &cohort(&win)));
        });
        report("leaf_projection", count, true, || {
            let update = project_sparse(&sheet, delta, &[], &cohort(&win));
            assert_eq!(update.nodes.len(), 1);
            black_box(update);
        });
        let mut tree = Tree::new(project(&sheet, state, "Oracle", &cohort(&win)), true);
        report("full_projection_consumer", count, true, || {
            tree.update_and_process_changes(
                project(&sheet, state, "Oracle", &cohort(&win)),
                &mut Changes::default(),
            );
        });
        report("leaf_projection_consumer", count, true, || {
            tree.update_and_process_changes(
                project_sparse(&sheet, delta, &[], &cohort(&win)),
                &mut Changes::default(),
            );
        });
    }
}

#[test]
fn clipped_logical_index_hint_is_verified_before_sparse_use() {
    struct Clipped {
        name: Signal<String>,
    }
    impl Clipped {
        const NAME: Source<Self, String> =
            Source::new(FieldId::new(1), "name", |m| &m.name, |m| &mut m.name);
    }
    impl crate::ItemSource for Clipped {
        fn len(&self) -> usize {
            1
        }
        fn key(&self, _: usize) -> crate::ItemKey {
            crate::ItemKey::new(1)
        }
        fn index_of(&self, key: crate::ItemKey) -> Option<usize> {
            (key == crate::ItemKey::new(1)).then_some(0)
        }
        fn row(&self, _: usize) -> El<'_> {
            div().h(0)
        }
    }
    impl View for Clipped {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::NAME)
        }
        fn view(&self) -> El<'_> {
            column((
                crate::uniform_list(crate::ListId::new(1), self, 20)
                    .w(100)
                    .h(20),
                div().name(&self.name).description(&self.name).h(20),
            ))
            .w(100)
        }
    }
    let mut win = Win::with_size(
        Clipped {
            name: Signal::new("before".into()),
        },
        100,
        100,
    )
    .unwrap();
    win.accessibility_observe(true).unwrap();
    let base = win.accessibility_state().unwrap();
    let mut tree = Tree::new(full(&win), true);
    let target = win.query().name("before").one().unwrap();
    win.set(Clipped::NAME, "after".into()).unwrap();
    let base = apply(&win, base, &mut tree, None);
    // The inspector's one-entry lookup can fall back to an identity scan.
    win.set_semantic(
        target,
        crate::semantic::DESCRIPTION,
        Contribution::Set(Some("inspector".into())),
    )
    .unwrap();
    apply(&win, base, &mut tree, Some(1));
}

struct VirtualFocusRows;
impl crate::ItemSource for VirtualFocusRows {
    fn len(&self) -> usize {
        100
    }
    fn key(&self, index: usize) -> crate::ItemKey {
        crate::ItemKey::new(index as u64)
    }
    fn index_of(&self, key: crate::ItemKey) -> Option<usize> {
        (key.get() < 100).then_some(key.get() as usize)
    }
    fn row(&self, index: usize) -> El<'_> {
        button(format!("virtual{index}")).w(80).h(20)
    }
}
impl View for VirtualFocusRows {
    fn view(&self) -> El<'_> {
        column((
            crate::uniform_list(crate::ListId::new(91), self, 20)
                .w(80)
                .h(40),
            div().w(80).h(100),
        ))
        .scroll(crate::Axis::Y)
        .w(80)
        .h(60)
    }
}
#[test]
fn virtual_focus_revocation_and_reappearance_match_full_consumer() {
    let mut win = Win::recording(
        VirtualFocusRows,
        WindowOptions {
            size: [100, 100],
            ..Default::default()
        },
    )
    .unwrap();
    acknowledge(&mut win);
    let viewport = win.role(Role::ScrollView).one().unwrap();
    let departed = win.button("virtual0");
    let mut departed_id = None;
    win.visit(|part| {
        if part.target() == departed {
            departed_id = Some(NodeId(part.native_id() * 2));
        }
    })
    .unwrap();
    win.focus(departed).unwrap();
    win.accessibility_observe(true).unwrap();
    let mut tree = Tree::new(full(&win), true);
    let base = win.accessibility_state().unwrap();
    assert_eq!(base.focus, Some(departed));
    win.scroll(viewport, 80.0).unwrap();
    assert_eq!(win.focused().unwrap(), None);
    assert_eq!(win.activate(departed), Err(Error::StaleTarget));
    let pending = apply(&win, base, &mut tree, None);
    assert_eq!(pending.token, base.token, "P geometry still old");
    assert_eq!(pending.focus, None);
    acknowledge(&mut win);
    let hidden = apply(&win, pending, &mut tree, None);
    assert!(
        tree.state()
            .node_by_tree_local_id(departed_id.unwrap(), TreeId::ROOT)
            .is_none()
    );
    win.scroll_to(viewport, crate::ScrollOffset::default())
        .unwrap();
    acknowledge(&mut win);
    let returned = apply(&win, hidden, &mut tree, None);
    assert_eq!(returned.focus, None);
    assert_ne!(win.button("virtual0"), departed);
    assert!(
        tree.state()
            .node_by_tree_local_id(departed_id.unwrap(), TreeId::ROOT)
            .is_none()
    );
}

struct PaintPage {
    color: Signal<crate::Color>,
    map: Signal<Affine>,
}
impl PaintPage {
    const COLOR: Source<Self, crate::Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
    const MAP: Source<Self, Affine> =
        Source::new(FieldId::new(2), "map", |m| &m.map, |m| &mut m.map);
}
impl View for PaintPage {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR).direct(Self::MAP)
    }
    fn view(&self) -> El<'_> {
        div().size(100).transform(&self.map).child(
            button("Paint")
                .size(40)
                .bg(&self.color)
                .on_click(|_: &mut Self| {}),
        )
    }
}
#[test]
fn paint_complete_transitions_preserve_pending_full_rows_and_zero_node_deltas() {
    let mut win = Win::recording(
        PaintPage {
            color: Signal::new(crate::Color::BLACK),
            map: Signal::new(Affine::IDENTITY),
        },
        WindowOptions {
            size: [120, 120],
            ..Default::default()
        },
    )
    .unwrap();
    acknowledge(&mut win);
    let target = win.button("Paint");
    win.focus(target).unwrap();
    let mut base = win.accessibility_state().unwrap();
    let mut tree = Tree::new(full(&win), true);
    win.accessibility_observe(true).unwrap();
    for color in [crate::rgb(0x102030), crate::rgb(0x405060)] {
        win.set(PaintPage::COLOR, color).unwrap();
        assert_eq!(win.accessibility_state().unwrap(), base);
    }
    acknowledge(&mut win);
    base = apply(&win, base, &mut tree, Some(0));
    assert_eq!(win.focused().unwrap(), Some(target));
    win.set(PaintPage::MAP, Affine::translation(5.0, 0.0))
        .unwrap();
    win.set(PaintPage::COLOR, crate::rgb(0x708090)).unwrap();
    acknowledge(&mut win);
    let next = win.accessibility_state().unwrap();
    let count = win.accessibility_delta(base, next).unwrap().len();
    assert!(count > 0);
    base = apply(&win, base, &mut tree, Some(count));
    win.set(PaintPage::MAP, Affine::translation(8.0, 0.0))
        .unwrap();
    let good = win.with_scene(|_, token| token).unwrap();
    assert!(win.set(PaintPage::MAP, Affine::scale(0.0, 1.0)).is_err());
    assert!(win.set(PaintPage::COLOR, crate::rgb(0xa0b0c0)).is_err());
    assert_eq!(win.with_scene(|_, token| token).unwrap(), good);
    win.presented(good).unwrap();
    // Failed collection invalidates sparse trust; the complete older sheet is
    // still consumable through the independent full fallback.
    apply(&win, base, &mut tree, None);
}

#[test]
fn pending_complete_coverage_noop_preserves_exact_consumer_transition() {
    for mode in 0..3 {
        let mut win = Win::recording(
            PaintPage {
                color: Signal::new(crate::Color::BLACK),
                map: Signal::new(Affine::IDENTITY),
            },
            WindowOptions {
                size: [120, 120],
                ..Default::default()
            },
        )
        .unwrap();
        acknowledge(&mut win);
        let target = win.button("Paint");
        win.focus(target).unwrap();
        let base = win.accessibility_state().unwrap();
        let mut tree = Tree::new(full(&win), true);
        win.accessibility_observe(true).unwrap();
        match mode {
            0 => {
                win.set(PaintPage::COLOR, crate::Color::WHITE).unwrap();
            }
            1 => {
                win.set(PaintPage::MAP, Affine::translation(5.0, 0.0))
                    .unwrap();
            }
            _ => {
                win.set_property(
                    target,
                    crate::property::BACKGROUND,
                    Contribution::Set(crate::Color::WHITE),
                )
                .unwrap();
            }
        }
        let candidate = win.with_scene(|_, token| token).unwrap();
        let value = match mode {
            0 => crate::Color::WHITE,
            1 => crate::Color::BLACK,
            _ => crate::rgb(0x123456),
        };
        let commit = win.set(PaintPage::COLOR, value).unwrap();
        assert_eq!(
            win.with_scene(|_, token| token).unwrap(),
            candidate,
            "no new visual candidate needed"
        );
        assert_eq!(commit.prepared_epoch, Some(2));
        assert_eq!(win.accessibility_state().unwrap(), base);
        let next = if mode == 2 {
            crate::rgb(0xabcdef)
        } else {
            crate::Color::BLACK
        };
        win.set(PaintPage::COLOR, next).unwrap();
        let latest = win.with_scene(|_, token| token).unwrap();
        let final_commit = win.set(PaintPage::COLOR, next).unwrap();
        assert_eq!(win.with_scene(|_, token| token).unwrap(), latest);
        assert_eq!(final_commit.prepared_epoch, Some(4));
        win.presented(latest).unwrap();
        apply(&win, base, &mut tree, Some(if mode == 1 { 2 } else { 0 }));
        assert_eq!(win.focused().unwrap(), Some(target));
    }
}

#[test]
fn observer_enabled_after_full_candidate_never_invents_empty_paint_delta() {
    for change in [false, true] {
        let mut win = Win::recording(
            PaintPage {
                color: Signal::new(crate::Color::BLACK),
                map: Signal::new(Affine::IDENTITY),
            },
            WindowOptions {
                size: [120, 120],
                ..Default::default()
            },
        )
        .unwrap();
        acknowledge(&mut win);
        win.set(PaintPage::MAP, Affine::translation(5.0, 0.0))
            .unwrap();
        let base = win.accessibility_state().unwrap();
        let mut tree = Tree::new(full(&win), true);
        win.accessibility_observe(true).unwrap(); // C existed before observer.
        win.set(
            PaintPage::COLOR,
            if change {
                crate::Color::WHITE
            } else {
                crate::Color::BLACK
            },
        )
        .unwrap();
        acknowledge(&mut win);
        apply(&win, base, &mut tree, None);
    }
}

struct SparseInputs {
    value: Signal<String>,
    color: Signal<crate::Color>,
}
impl SparseInputs {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    const COLOR: Source<Self, crate::Color> =
        Source::new(FieldId::new(2), "color", |m| &m.color, |m| &mut m.color);
}
impl View for SparseInputs {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE).direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        column((0..999).map(|i| {
            if i == 500 {
                text_input(&self.value).w(100).h(20)
            } else {
                div().w(1).h(1)
            }
        }))
        .w(120)
        .bg(&self.color)
    }
}
#[test]
fn thousand_node_paint_and_one_input_edit_keep_cohort_frontier_bounded() {
    let mut win = Win::with_size(
        SparseInputs {
            value: Signal::new("before".into()),
            color: Signal::new(crate::Color::BLACK),
        },
        120,
        1200,
    )
    .unwrap();
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let storage = cohort.storage();
    let visits = cohort.full_visits;
    let clones = cohort.source_clones;
    assert_eq!(visits, 2000);
    let mut base = win.accessibility_state().unwrap();
    let mut tree = Tree::new(
        project(&win.accessibility_sheet().unwrap(), base, "Sparse", &cohort),
        true,
    );
    win.accessibility_observe(true).unwrap();
    win.set(SparseInputs::COLOR, crate::Color::WHITE).unwrap();
    let state = win.accessibility_state().unwrap();
    let indices = win.accessibility_delta(base, state).unwrap();
    assert!(indices.is_empty());
    let allocation = allocation_counter::measure(|| {
        let relink = cohort.update_delta(&win, indices).unwrap();
        assert!(relink.parents.is_empty() && !relink.root);
    });
    assert_eq!(allocation.count_total, 0);
    assert_eq!(cohort.storage(), storage);
    assert_eq!(
        (
            cohort.full_visits,
            cohort.source_clones,
            cohort.sparse_visits
        ),
        (visits, clones, 0)
    );
    base = state;
    win.set(SparseInputs::VALUE, "after!".into()).unwrap();
    let state = win.accessibility_state().unwrap();
    let indices = win.accessibility_delta(base, state).unwrap();
    assert_eq!(indices.len(), 1);
    let mut relink = None;
    let allocation =
        allocation_counter::measure(|| relink = Some(cohort.update_delta(&win, indices).unwrap()));
    let relink = relink.unwrap();
    // One small immediate-parent frontier allocation; the input table survives.
    assert_eq!(allocation.count_total, 1);
    assert_eq!(cohort.storage(), storage);
    assert_eq!(
        (
            cohort.full_visits,
            cohort.source_clones,
            cohort.sparse_visits
        ),
        (visits, clones + 1, 2)
    );
    assert_eq!(relink.parents.len(), 1);
    let update = project_sparse(
        &win.accessibility_sheet().unwrap(),
        indices,
        &relink.parents,
        &cohort,
    );
    assert_eq!(update.nodes.len(), 3);
    tree.update_and_process_changes(update, &mut Changes::default());
    let full = project(
        &win.accessibility_sheet().unwrap(),
        state,
        "Sparse",
        &cohort,
    );
    let ids = full.nodes.iter().map(|(id, _)| *id).collect::<Vec<_>>();
    let oracle = Tree::new(full, true);
    for id in ids {
        let actual = tree
            .state()
            .node_by_tree_local_id(id, TreeId::ROOT)
            .unwrap();
        let expected = oracle
            .state()
            .node_by_tree_local_id(id, TreeId::ROOT)
            .unwrap();
        assert_eq!(actual.data(), expected.data());
        assert_eq!(actual.parent_id(), expected.parent_id());
    }
}
