use super::*;
fn cohort<M: View + 'static>(win: &Win<M>) -> Cohort {
    let mut cohort = Cohort::default();
    cohort.refresh(win).unwrap();
    cohort
}
use crate::{
    Affine, El, FieldId, Signal, Source, Sources, WindowOptions, button, column, div, text,
    text_input,
};
use accesskit::{ActionHandler, ActivationHandler, DeactivationHandler};
use accesskit_consumer::{NodeRef, Tree, TreeChangeHandler};

struct Page {
    value: Signal<String>,
    clicks: u32,
    show: bool,
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    fn new() -> Self {
        Self {
            value: Signal::new("value != name".into()),
            clicks: 0,
            show: true,
        }
    }
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.value).w(100).h(25),
            if self.show {
                button("Invoke")
                    .w(100)
                    .h(25)
                    .on_click(|m: &mut Self| m.clicks += 1)
            } else {
                div().w(100).h(25)
            },
            text(format!("count {}", self.clicks)),
        ))
        .w(160)
        .transform(Affine {
            tx: -10.0,
            ty: 5.0,
            ..Affine::IDENTITY
        })
    }
}
fn projection<M: View + 'static>(win: &Win<M>) -> TreeUpdate {
    project(
        &win.accessibility_sheet().unwrap(),
        win.accessibility_state().unwrap(),
        "Test document",
        &cohort(win),
    )
}
fn id<M: View + 'static>(win: &Win<M>, target: Target) -> NodeId {
    let mut found = None;
    win.visit(|part| {
        if part.target() == target {
            found = Some(cohort(win).id(part));
        }
    })
    .unwrap();
    found.unwrap()
}
fn request(
    action: accesskit::Action,
    target_node: NodeId,
    data: Option<ActionData>,
) -> ActionRequest {
    ActionRequest {
        action,
        target_tree: TreeId::ROOT,
        target_node,
        data,
    }
}
#[derive(Default)]
struct Changes {
    added: usize,
    updated: usize,
    removed: usize,
    focus: usize,
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
    fn focus_moved(&mut self, _: Option<&NodeRef<'_>>, _: Option<&NodeRef<'_>>) {
        self.focus += 1;
    }
}

#[test]
fn consumer_validates_topology_names_values_full_geometry_and_live_focus() {
    let mut win = Win::with_size(Page::new(), 120, 120).unwrap();
    let input = win.input();
    let input_id = id(&win, input);
    let button = win.button("Invoke");
    let button_id = id(&win, button);
    let update = projection(&win);
    assert_eq!(update.nodes[0].0, ROOT);
    assert_eq!(update.nodes[0].1.role(), accesskit::Role::Window);
    assert_eq!(update.nodes[0].1.label(), Some("Test document"));
    let mut tree = Tree::new(update, true);
    let state = tree.state();
    let node = state.node_by_tree_local_id(input_id, TreeId::ROOT).unwrap();
    assert_eq!(node.role(), accesskit::Role::TextInput);
    assert_eq!(node.data().label(), None);
    assert_eq!(node.data().value(), Some("value != name"));
    let full = node.bounding_box().unwrap();
    assert!(full.x0 < 0.0);
    assert!(full.x1 - full.x0 > f64::from(win.bounds(input).unwrap().width));
    assert!(
        node.data().transform().is_some(),
        "leaf input carries its exact text affine"
    );
    assert!(node.data().supports_action(accesskit::Action::SetValue));
    assert!(
        node.data()
            .supports_action(accesskit::Action::SetTextSelection)
    );
    assert!(
        node.data()
            .supports_action(accesskit::Action::ReplaceSelectedText)
    );
    assert_eq!(
        state
            .node_by_tree_local_id(button_id, TreeId::ROOT)
            .unwrap()
            .data()
            .label(),
        Some("Invoke")
    );
    let before = win.counters();
    win.focus(input).unwrap();
    let focus = focus_update(&win.accessibility_sheet().unwrap(), &cohort(&win));
    assert!(focus.nodes.is_empty());
    assert_eq!(focus.focus, input_id);
    let mut changes = Changes::default();
    tree.update_and_process_changes(focus, &mut changes);
    assert_eq!(changes.focus, 1);
    assert_eq!((changes.added, changes.removed), (0, 0));
    // The consumer itself reports focus-state changes on the old/new focus
    // nodes even though this bridge sent no replacement node payloads.
    assert_eq!(changes.updated, 2);
    assert_eq!(win.counters(), before);
    win.clear_focus().unwrap();
    tree.update_and_process_changes(
        focus_update(&win.accessibility_sheet().unwrap(), &cohort(&win)),
        &mut changes,
    );
    assert_eq!(
        tree.state().focus_in_tree().data().role(),
        accesskit::Role::Window
    );
    win.perform(button, Action::Activate).unwrap();
    tree.update_and_process_changes(projection(&win), &mut changes);
    assert!(win.contains_text("count 1").unwrap());
    assert_eq!(id(&win, button), button_id);
    win.update(|m| m.show = false).unwrap();
    tree.update_and_process_changes(projection(&win), &mut changes);
    assert!(
        tree.state()
            .node_by_tree_local_id(button_id, TreeId::ROOT)
            .is_none()
    );
    assert!(changes.removed > 0);
    win.update(|m| m.show = true).unwrap();
    tree.update_and_process_changes(projection(&win), &mut changes);
    assert_ne!(id(&win, win.button("Invoke")), button_id);
}

#[test]
fn scalar_text_run_has_exact_utf8_lengths_and_no_fabricated_selection() {
    for (value, lengths) in [("aé🦀", &[1, 2, 4][..]), ("aé🦀\r\n", &[1, 2, 4, 2][..])] {
        let mut root = Node::new(accesskit::Role::Window);
        root.push_child(NodeId(2));
        let mut input = Node::new(accesskit::Role::TextInput);
        input.set_value(value);
        input.push_child(NodeId(3));
        input.add_action(accesskit::Action::SetValue);
        let run = super::text::text_run(value);
        assert_eq!(run.character_lengths(), lengths);
        assert!(run.character_positions().is_none());
        let tree = Tree::new(
            TreeUpdate {
                nodes: vec![(ROOT, root), (NodeId(2), input), (NodeId(3), run)],
                tree: Some(TreeInfo::new(ROOT)),
                tree_id: TreeId::ROOT,
                focus: NodeId(2),
            },
            true,
        );
        let input = tree
            .state()
            .node_by_tree_local_id(NodeId(2), TreeId::ROOT)
            .unwrap();
        assert!(input.supports_text_ranges());
        assert_eq!(input.document_range().text(), value);
        assert!(input.raw_text_selection().is_none());
        assert!(
            !input
                .data()
                .supports_action(accesskit::Action::SetTextSelection)
        );
    }
}

#[test]
fn native_text_boundaries_keep_crlf_together_and_cover_every_utf8_byte() {
    for (value, lengths) in [
        ("", &[][..]),
        ("\r\n", &[2][..]),
        ("\r\n\r\n", &[2, 2][..]),
        ("aé🦀\r\n", &[1, 2, 4, 2][..]),
        ("a\rb\n", &[1, 1, 1, 1][..]),
        ("\r\r\n", &[1, 2][..]),
        ("\n\r", &[1, 1][..]),
    ] {
        let run = super::text::text_run(value);
        assert_eq!(run.character_lengths(), lengths, "{value:?}");
        let mut offset = 0;
        for &length in run.character_lengths() {
            offset += usize::from(length);
            assert!(value.is_char_boundary(offset), "{value:?} at {offset}");
        }
        assert_eq!(offset, value.len(), "{value:?}");
        assert!(run.character_positions().is_none());
        assert!(!run.supports_action(accesskit::Action::SetTextSelection));
    }
}

#[test]
fn projection_uses_old_p_during_pending_edit_and_failed_preparation() {
    let mut win = Win::recording(
        Page::new(),
        WindowOptions {
            size: [120, 120],
            ..Default::default()
        },
    )
    .unwrap();
    assert_eq!(win.accessibility_state().unwrap().token, None);
    let first = win.with_scene(|_, token| token).unwrap();
    win.presented(first).unwrap();
    assert_eq!(win.accessibility_state().unwrap().token, Some(first));
    let mut published = cohort(&win);
    let project_p = |win: &Win<Page>, cohort: &Cohort| {
        project(
            &win.accessibility_sheet().unwrap(),
            win.accessibility_state().unwrap(),
            "Test document",
            cohort,
        )
    };
    let old = project_p(&win, &published);
    win.set(Page::VALUE, "next".to_owned()).unwrap();
    assert_eq!(project_p(&win, &published), old);
    let second = win.with_scene(|_, token| token).unwrap();
    assert_ne!(first, second);
    assert_eq!(win.accessibility_state().unwrap().token, Some(first));
    win.presented(second).unwrap();
    assert_eq!(win.accessibility_state().unwrap().token, Some(second));
    published.refresh(&win).unwrap();
    let expected = project_p(&win, &published);
    assert_ne!(expected, old);
    // The unsupported scalar commits S; neither failed candidate text nor its
    // geometry may appear in AccessKit's coherent preceding sheet.
    assert!(win.set(Page::VALUE, "next\u{1f680}".to_owned()).is_err());
    assert_eq!(project_p(&win, &published), expected);
    assert_eq!(win.accessibility_state().unwrap().token, Some(second));
}

#[test]
fn placeholder_actions_do_not_initialize_or_saturate_transport() {
    let mut ingress = Ingress::new(None);
    ingress.request_initial_tree();
    let position = accesskit::TextPosition {
        node: NodeId(1),
        character_index: 0,
    };
    let measured = allocation_counter::measure(|| {
        for _ in 0..CAPACITY * 2 {
            ingress.do_action(request(accesskit::Action::Click, NodeId(8), None));
            ingress.do_action(request(
                accesskit::Action::SetTextSelection,
                NodeId(1 << 63),
                Some(ActionData::SetTextSelection(accesskit::TextSelection {
                    anchor: position,
                    focus: position,
                })),
            ));
        }
    });
    assert_eq!(measured.count_total, 0);
    // Even an oversized synthetic placeholder payload is discarded, rather
    // than poisoning the later real provider's bounded action transport.
    ingress.do_action(request(
        accesskit::Action::SetValue,
        NodeId(1 << 63),
        Some(ActionData::Value("x".repeat(MAX_VALUE_BYTES + 1).into())),
    ));
    assert!(ingress.0.sender.get().is_none());
    assert!(!ingress.0.overflow.load(Ordering::Acquire));
}

#[test]
fn owner_publication_allocates_transport_once_and_retains_it_across_sessions() {
    let mut ingress = None;
    let cold = allocation_counter::measure(|| ingress = Some(Ingress::new(None)));
    let mut ingress = ingress.unwrap();
    assert_eq!(cold.count_total, 1, "only the shared ingress owner exists");
    let mut receiver = None;
    let first = allocation_counter::measure(|| {
        ingress.prepare_publication(&mut receiver);
    });
    assert_eq!(first.count_total, 2, "bounded channel control and slots");
    ingress.request_initial_tree();
    ingress.do_action(request(accesskit::Action::Click, NodeId(8), None));
    let old_session = ingress.0.session.load(Ordering::Acquire);
    let repeated = allocation_counter::measure(|| {
        ingress.deactivate_accessibility();
        ingress.request_initial_tree();
        ingress.prepare_publication(&mut receiver);
    });
    assert_eq!(repeated.count_total, 0);
    assert_ne!(old_session, ingress.0.session.load(Ordering::Acquire));
    assert_eq!(
        receiver.as_ref().unwrap().try_recv().unwrap().session,
        old_session
    );
    eprintln!(
        "OWNER_QUEUE cold_count={} cold_bytes={} first_count={} first_bytes={} shared={} receiver={} optional_receiver={} bridge={}",
        cold.count_total,
        cold.bytes_current,
        first.count_total,
        first.bytes_current,
        size_of::<Shared>(),
        size_of::<Receiver<Queued>>(),
        size_of::<Option<Receiver<Queued>>>(),
        size_of::<Bridge>()
    );
}

#[test]
fn provider_boundary_qualifies_text_ids_without_rejecting_unchanged_authority() {
    let mut win = Win::demo(Page::new());
    let mut published = cohort(&win);
    let input = id(&win, win.input());
    assert!(input.0 >= 1 << 63);
    let button = id(&win, win.button("Invoke"));
    let mut ingress = Ingress::new(None);
    ingress.request_initial_tree();
    let mut receiver = None;
    // Model the factory boundary: projection succeeds, then transport is
    // installed before the returned tree becomes observable.
    let update = project(
        &win.accessibility_sheet().unwrap(),
        win.accessibility_state().unwrap(),
        "Test document",
        &published,
    );
    ingress.prepare_publication(&mut receiver);
    let tree = Tree::new(update, true);
    assert!(
        tree.state()
            .node_by_tree_local_id(input, TreeId::ROOT)
            .is_some()
    );
    let edit = || {
        request(
            accesskit::Action::SetValue,
            input,
            Some(ActionData::Value("fresh".into())),
        )
    };
    ingress.do_action(edit());
    let result = drain_actions(&ingress, receiver.as_ref().unwrap(), &published, &mut win).unwrap();
    assert!(result[0].as_ref().unwrap().is_ok());
    assert_eq!(&**win.root().unwrap().value, "fresh");

    published.refresh(&win).unwrap();
    let mut next_input = None;
    win.visit(|part| {
        if part.target() == win.input() {
            next_input = Some(published.id(part));
        }
    })
    .unwrap();
    let next_input = next_input.unwrap();
    assert_ne!(next_input, input, "changed source retires the old root ID");
    // Old and new providers may run on either side of returning the next tree.
    // The retired source ID fails regardless of that callback interleaving.
    ingress.do_action(request(
        accesskit::Action::SetValue,
        input,
        Some(ActionData::Value("retired source".into())),
    ));
    ingress.do_action(request(
        accesskit::Action::SetValue,
        next_input,
        Some(ActionData::Value("current intent".into())),
    ));
    ingress.do_action(request(accesskit::Action::Click, button, None));
    ingress.prepare_publication(&mut receiver);
    let result = drain_actions(&ingress, receiver.as_ref().unwrap(), &published, &mut win).unwrap();
    assert!(matches!(result[0], Some(Err(Error::StaleTarget))));
    assert!(result[1].as_ref().unwrap().is_ok());
    assert!(result[2].as_ref().unwrap().is_ok());
    assert_eq!(&**win.root().unwrap().value, "current intent");
    assert_eq!(win.root().unwrap().clicks, 1);
}

#[test]
fn activation_exhaustion_keeps_the_session_and_fails_closed() {
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    ingress.0.session.store(u64::MAX, Ordering::Release);
    ingress.deactivate_accessibility();
    assert_eq!(ingress.0.session.load(Ordering::Acquire), u64::MAX);
    assert!(ingress.0.overflow.load(Ordering::Acquire));
    let mut win = Win::demo(Page::new());
    assert!(matches!(
        drain_actions(&ingress, &receiver, &cohort(&win), &mut win),
        Err(NativeError::AccessibilityOverloaded)
    ));
    assert!(ingress.0.closed.load(Ordering::Acquire));
    ingress.do_action(request(accesskit::Action::Click, NodeId(8), None));
    assert!(receiver.try_recv().is_err());
}

#[test]
fn native_callbacks_are_inert_bounded_and_activation_bypasses_saturation() {
    let (mut ingress, receiver) = Ingress::channel(None);
    assert!(ingress.request_initial_tree().is_none());
    let mut win = Win::demo(Page::new());
    let button = id(&win, win.button("Invoke"));
    for _ in 0..CAPACITY {
        ingress.do_action(request(accesskit::Action::Click, button, None));
    }
    assert_eq!(win.root().unwrap().clicks, 0);
    assert!(!ingress.0.overflow.load(Ordering::Acquire));
    ingress.0.initial.store(false, Ordering::Release);
    assert!(ingress.request_initial_tree().is_none());
    assert!(ingress.0.initial.load(Ordering::Acquire));
    ingress.do_action(request(accesskit::Action::Click, button, None));
    assert!(matches!(
        drain_actions(&ingress, &receiver, &cohort(&win), &mut win),
        Err(NativeError::AccessibilityOverloaded)
    ));
    assert_eq!(win.root().unwrap().clicks, 0);
    assert!(ingress.0.closed.load(Ordering::Acquire));
}

#[test]
fn owner_budget_fifo_old_live_targets_and_revocation() {
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    let mut win = Win::recording(Page::new(), WindowOptions::default()).unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let button = id(&win, win.button("Invoke"));
    let input = id(&win, win.input());
    for _ in 0..APPLY_BUDGET + 1 {
        ingress.do_action(request(accesskit::Action::Click, button, None));
    }
    let results = drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap();
    assert_eq!(
        results.into_iter().flatten().filter(Result::is_ok).count(),
        APPLY_BUDGET
    );
    assert_eq!(win.root().unwrap().clicks, APPLY_BUDGET as u32);
    // Position-free action still reaches this surviving site in old P while a
    // later prepared frame waits; it is not rejected by an arbitrary epoch gate.
    assert_eq!(
        drain_actions(&ingress, &receiver, &cohort(&win), &mut win)
            .unwrap()
            .into_iter()
            .flatten()
            .filter(Result::is_ok)
            .count(),
        1
    );
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    ingress.do_action(request(
        accesskit::Action::SetValue,
        input,
        Some(ActionData::Value("first".into())),
    ));
    ingress.do_action(request(
        accesskit::Action::SetValue,
        input,
        Some(ActionData::Value("last".into())),
    ));
    let results = drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap();
    assert!(results[0].as_ref().unwrap().is_ok());
    assert!(
        results[1].as_ref().unwrap().is_err(),
        "second edit retains the old input lease"
    );
    assert_eq!(&**win.root().unwrap().value, "first");
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    ingress.do_action(request(
        accesskit::Action::SetValue,
        input,
        Some(ActionData::Value("last".into())),
    ));
    drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap();
    assert_eq!(&**win.root().unwrap().value, "last");
    win.update(|m| m.show = false).unwrap();
    ingress.do_action(request(accesskit::Action::Click, button, None));
    let results = drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap();
    assert!(matches!(results[0], Some(Err(Error::StaleTarget))));
    ingress.do_action(request(
        accesskit::Action::SetValue,
        input,
        Some(ActionData::Value("discard".into())),
    ));
    ingress.deactivate_accessibility();
    // An accepted command belongs to this activation session. Deactivation
    // cancels it even if reactivation happens before the owner can drain.
    ingress.request_initial_tree();
    drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap();
    assert_eq!(&**win.root().unwrap().value, "last");
    ingress.request_initial_tree();
    win.close();
    ingress.do_action(request(accesskit::Action::Click, button, None));
    assert!(matches!(
        drain_actions(&ingress, &receiver, &Cohort::default(), &mut win).unwrap()[0],
        Some(Err(Error::Closed))
    ));
}

#[test]
fn unsupported_foreign_tree_and_utf8_byte_limit() {
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    ingress.do_action(request(
        accesskit::Action::SetTextSelection,
        NodeId(1),
        None,
    ));
    let mut foreign = request(accesskit::Action::Click, NodeId(1), None);
    foreign.target_tree = TreeId("00000000-0000-0000-0000-000000000001".parse().unwrap());
    ingress.do_action(foreign);
    assert!(receiver.try_recv().is_err());
    let at_limit = "é".repeat(MAX_VALUE_BYTES / 2);
    ingress.do_action(request(
        accesskit::Action::SetValue,
        NodeId(1),
        Some(ActionData::Value(at_limit.into())),
    ));
    assert!(!ingress.0.overflow.load(Ordering::Acquire));
    assert!(
        matches!(receiver.try_recv().unwrap().command, Command::SetValue(_, value) if value.len() == MAX_VALUE_BYTES)
    );
    ingress.do_action(request(
        accesskit::Action::SetValue,
        NodeId(1),
        Some(ActionData::Value(
            "é".repeat(MAX_VALUE_BYTES / 2 + 1).into(),
        )),
    ));
    assert!(ingress.0.overflow.load(Ordering::Acquire));
}

#[test]
fn idle_state_and_focus_transport_do_not_allocate() {
    let (mut ingress, receiver) = Ingress::channel(None);
    let mut win = Win::demo(Page::new());
    let published = cohort(&win);
    let measured = allocation_counter::measure(|| {
        for _ in 0..1000 {
            let _ = win.accessibility_state().unwrap();
            ingress.request_initial_tree();
            ingress.deactivate_accessibility();
            drain_actions(&ingress, &receiver, &published, &mut win).unwrap();
        }
    });
    assert_eq!(measured.count_total, 0);
}

#[test]
fn semantic_only_change_advances_p_epoch_at_the_same_scene_token() {
    let mut win = Win::demo(Page::new());
    let target = win.input();
    let before = win.accessibility_state().unwrap();
    win.set_semantic(
        target,
        crate::semantic::NAME,
        crate::property::Contribution::Set(Some("Task".into())),
    )
    .unwrap();
    let after = win.accessibility_state().unwrap();
    assert_eq!(before.token, after.token);
    assert_ne!(before.epoch, after.epoch);
    let update = projection(&win);
    let input = update
        .nodes
        .iter()
        .find(|(native, _)| *native == id(&win, target))
        .unwrap();
    assert_eq!(input.1.label(), Some("Task"));
    assert_eq!(input.1.value(), Some("value != name"));
    win.set_semantic(
        target,
        crate::semantic::DESCRIPTION,
        crate::property::Contribution::Set(Some("Help".into())),
    )
    .unwrap();
    assert_eq!(
        projection(&win)
            .nodes
            .iter()
            .find(|(native, _)| *native == id(&win, target))
            .unwrap()
            .1
            .description(),
        Some("Help")
    );
}

use crate::native::test_library as library;

#[test]
fn library_projects_bounded_frozen_count_positions_and_never_resurrects_ids() {
    let mut win = Win::recording(
        library::Library::new(250_000),
        WindowOptions {
            size: [760, 600],
            ..Default::default()
        },
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let list = win.list(library::LIBRARY).unwrap();
    let list_id = id(&win, list);
    let row0 = id(&win, win.list_item(list, crate::ItemKey::new(0)).unwrap());
    let row2 = id(&win, win.list_item(list, crate::ItemKey::new(2)).unwrap());
    let initial = projection(&win);
    // Wrapped TextRuns add native children; viewport materialization still
    // stays bounded independently from the250,000 source rows.
    assert!(
        initial.nodes.len() < 256,
        "native nodes={}",
        initial.nodes.len()
    );
    assert_eq!(
        initial
            .nodes
            .iter()
            .find(|(id, _)| *id == list_id)
            .unwrap()
            .1
            .size_of_set(),
        Some(250_000)
    );
    let rows: Vec<_> = initial
        .nodes
        .iter()
        .filter(|(_, n)| n.role() == accesskit::Role::ListItem)
        .collect();
    assert_eq!(rows.len(), 13);
    assert_eq!(
        rows.iter()
            .map(|(_, n)| n.position_in_set().unwrap())
            .collect::<Vec<_>>(),
        (0..13).collect::<Vec<_>>()
    );
    win.update(|library| library.catalogue.prepend()).unwrap();
    assert_eq!(
        projection(&win),
        initial,
        "logical list metadata must not leak into older P"
    );
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let mut tree = Tree::new(initial, true);
    tree.update_and_process_changes(projection(&win), &mut Changes::default());
    assert_eq!(
        tree.state()
            .node_by_tree_local_id(list_id, TreeId::ROOT)
            .unwrap()
            .data()
            .size_of_set(),
        Some(250_001)
    );
    assert_eq!(
        id(&win, win.list_item(list, crate::ItemKey::new(2)).unwrap()),
        row2
    );
    let before = win.accessibility_state().unwrap();
    win.scroll(list, 32.0).unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let after = win.accessibility_state().unwrap();
    assert_eq!(before.epoch, after.epoch);
    assert_ne!(
        before.token, after.token,
        "presentation-only scrolling must update native tree"
    );
    tree.update_and_process_changes(projection(&win), &mut Changes::default());
    assert!(
        tree.state()
            .node_by_tree_local_id(row0, TreeId::ROOT)
            .is_none()
    );
    assert_eq!(
        id(&win, win.list_item(list, crate::ItemKey::new(2)).unwrap()),
        row2
    );
}

#[test]
fn root_and_synthetic_ids_cannot_invoke_real_sites() {
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    let mut win = Win::demo(Page::new());
    let input = id(&win, win.input());
    for native in [ROOT, NodeId(input.0 + 1), NodeId(u64::MAX)] {
        ingress.do_action(request(accesskit::Action::Click, native, None));
    }
    let applied = drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap();
    assert!(
        applied
            .into_iter()
            .flatten()
            .all(|result| result == Err(Error::StaleTarget))
    );
    assert_eq!(win.root().unwrap().clicks, 0);
}

#[test]
fn renamed_static_text_preserves_content_and_explicit_none_then_inherits() {
    struct Greeting(String);
    impl View for Greeting {
        fn view(&self) -> El<'_> {
            text(&self.0)
                .name("Greeting")
                .description("Help")
                .w(100)
                .h(30)
        }
    }
    let mut win = Win::demo(Greeting("Hello".into()));
    let target = win.role(Role::Text).one().unwrap();
    let native = id(&win, target);
    let mut tree = Tree::new(projection(&win), true);
    let check = |tree: &Tree, expected_name: Option<&str>, content: &str| {
        let parent = tree
            .state()
            .node_by_tree_local_id(native, TreeId::ROOT)
            .unwrap();
        assert_eq!(parent.role(), accesskit::Role::Group);
        assert_eq!(
            accesskit_consumer::common_filter(&parent),
            accesskit_consumer::FilterResult::Include
        );
        assert_eq!(parent.data().label(), expected_name);
        assert_eq!(parent.data().value(), None);
        let label = parent
            .children()
            .find(|child| child.role() == accesskit::Role::Label)
            .unwrap();
        assert_eq!(label.data().value(), Some(content));
        assert_eq!(label.role(), accesskit::Role::Label);
        assert_eq!(label.parent_id(), Some(parent.id()));
        let actual = label.bounding_box().unwrap();
        let expected = parent.bounding_box().unwrap();
        for (a, b) in [actual.x0, actual.y0, actual.x1, actual.y1]
            .into_iter()
            .zip([expected.x0, expected.y0, expected.x1, expected.y1])
        {
            assert!((a - b).abs() < 1e-3);
        }
        assert!(!label.data().supports_action(accesskit::Action::Click));
    };
    check(&tree, Some("Greeting"), "Hello");
    win.update(|m| m.0 = "Changed text".into()).unwrap();
    tree.update_and_process_changes(projection(&win), &mut Changes::default());
    check(&tree, Some("Greeting"), "Changed text");
    win.set_semantic(
        target,
        crate::semantic::NAME,
        crate::property::Contribution::Set(None),
    )
    .unwrap();
    tree.update_and_process_changes(projection(&win), &mut Changes::default());
    check(&tree, None, "Changed text");
    // Inherit reveals the declaration, then an explicit matching name reaches
    // the normal one-node Label representation without losing actual text.
    win.set_semantic(
        target,
        crate::semantic::NAME,
        crate::property::Contribution::Inherit,
    )
    .unwrap();
    tree.update_and_process_changes(projection(&win), &mut Changes::default());
    check(&tree, Some("Greeting"), "Changed text");
    let child = tree
        .state()
        .node_by_tree_local_id(native, TreeId::ROOT)
        .unwrap()
        .data()
        .children()[0];
    win.set_semantic(
        target,
        crate::semantic::NAME,
        crate::property::Contribution::Set(Some("Changed text".into())),
    )
    .unwrap();
    tree.update_and_process_changes(projection(&win), &mut Changes::default());
    assert_eq!(
        tree.state()
            .node_by_tree_local_id(native, TreeId::ROOT)
            .unwrap()
            .role(),
        accesskit::Role::Label
    );
    assert!(
        tree.state()
            .node_by_tree_local_id(child, TreeId::ROOT)
            .is_none()
    );
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    ingress.do_action(request(accesskit::Action::Click, child, None));
    assert!(matches!(
        drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap()[0],
        Some(Err(Error::StaleTarget))
    ));
    struct Plain;
    impl View for Plain {
        fn view(&self) -> El<'_> {
            text("Original")
        }
    }
    let mut plain = Win::demo(Plain);
    let target = plain.role(Role::Text).one().unwrap();
    let native = id(&plain, target);
    plain
        .set_semantic(
            target,
            crate::semantic::NAME,
            crate::property::Contribution::Set(Some("Override".into())),
        )
        .unwrap();
    let mut tree = Tree::new(projection(&plain), true);
    let carrier = tree
        .state()
        .node_by_tree_local_id(native, TreeId::ROOT)
        .unwrap()
        .data()
        .children()[0];
    assert!(
        tree.state()
            .node_by_tree_local_id(carrier, TreeId::ROOT)
            .is_some()
    );
    plain
        .set_semantic(
            target,
            crate::semantic::NAME,
            crate::property::Contribution::Inherit,
        )
        .unwrap();
    tree.update_and_process_changes(projection(&plain), &mut Changes::default());
    assert_eq!(
        tree.state()
            .node_by_tree_local_id(native, TreeId::ROOT)
            .unwrap()
            .data()
            .value(),
        Some("Original")
    );
    assert!(
        tree.state()
            .node_by_tree_local_id(carrier, TreeId::ROOT)
            .is_none()
    );
}

#[test]
#[ignore = "explicit projection allocation/timing ledger; run alone in release mode"]
fn projection_ledger() {
    struct Many(usize);
    impl View for Many {
        fn view(&self) -> El<'_> {
            column((0..self.0).map(|_| button("Name").w(50).h(1).on_click(|_: &mut Self| {})))
                .w(100)
        }
    }
    eprintln!(
        "GPUI_ACCESSKIT_SIZES bridge_test_bytes={} state={} queued={} native_node={}",
        std::mem::size_of::<Bridge>(),
        std::mem::size_of::<State>(),
        std::mem::size_of::<Queued>(),
        std::mem::size_of::<Node>()
    );
    let mut held_transport = None;
    let transport = allocation_counter::measure(|| {
        held_transport = Some(Ingress::channel(None));
    });
    eprintln!(
        "GPUI_ACCESSKIT_INGRESS allocations={} requested_retained={} requested_peak={}",
        transport.count_total, transport.bytes_current, transport.bytes_max
    );
    for count in [100, 1000, 10_000] {
        let win = Win::with_size(Many(count), 100, 100).unwrap();
        let mut held = None;
        let allocations = allocation_counter::measure(|| {
            held = Some(projection(&win));
        });
        let nodes = held.take().unwrap().nodes.len();
        let mut samples = Vec::new();
        for _ in 0..31 {
            let start = std::time::Instant::now();
            let update = projection(&win);
            samples.push(start.elapsed().as_nanos());
            std::hint::black_box(update);
        }
        samples.sort_unstable();
        eprintln!(
            "GPUI_ACCESSKIT_PROJECTION n={count} nodes={nodes} allocations={} retained={} peak={} p50_ns={} p95_ns={} p99_ns={}",
            allocations.count_total,
            allocations.bytes_current,
            allocations.bytes_max,
            samples[15],
            samples[29],
            samples[30]
        );
    }
}

struct ScrollPage;
impl View for ScrollPage {
    fn view(&self) -> El<'_> {
        column((0..5).map(|index| button(format!("row{index}")).w(160).h(32)))
            .scroll(crate::Axis::BOTH)
            .w(80)
            .h(64)
            .name("viewport")
    }
}
#[test]
fn scroll_consumer_has_frozen_range_full_offscreen_bounds_and_owner_actions() {
    let mut win = Win::recording(
        ScrollPage,
        WindowOptions {
            size: [100, 100],
            ..Default::default()
        },
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let viewport = win.role(Role::ScrollView).one().unwrap();
    let child = win.button("row4");
    let viewport_id = id(&win, viewport);
    let child_id = id(&win, child);
    let mut tree = Tree::new(projection(&win), true);
    let state = tree.state();
    let scroll = state
        .node_by_tree_local_id(viewport_id, TreeId::ROOT)
        .unwrap();
    assert_eq!(scroll.role(), accesskit::Role::ScrollView);
    assert!(scroll.clips_children());
    assert_eq!(
        (
            scroll.data().scroll_x_min(),
            scroll.data().scroll_x_max(),
            scroll.data().scroll_y_max()
        ),
        (Some(0.0), Some(80.0), Some(96.0))
    );
    assert!(scroll.data().supports_action(accesskit::Action::ScrollDown));
    assert!(
        scroll
            .data()
            .supports_action(accesskit::Action::SetScrollOffset)
    );
    let child_node = state.node_by_tree_local_id(child_id, TreeId::ROOT).unwrap();
    assert!(child_node.data().bounds().unwrap().y0 > 100.0);
    assert!(
        child_node
            .data()
            .supports_action(accesskit::Action::ScrollIntoView)
    );
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    ingress.do_action(request(
        accesskit::Action::ScrollDown,
        viewport_id,
        Some(ActionData::ScrollUnit(accesskit::ScrollUnit::Page)),
    ));
    assert!(matches!(
        drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap()[0],
        Some(Ok(_))
    ));
    assert_eq!(
        win.viewport(viewport).unwrap().offset.y,
        0.0,
        "pending C cannot change native P metadata"
    );
    assert!(matches!(
        win.perform(viewport, Action::ScrollIntoView),
        Err(Error::NotInteractive)
    ));
    let pending = projection(&win);
    assert_eq!(
        pending
            .nodes
            .iter()
            .find(|(id, _)| *id == viewport_id)
            .unwrap()
            .1
            .scroll_y(),
        Some(0.0)
    );
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    tree.update_and_process_changes(projection(&win), &mut Changes::default());
    assert_eq!(
        tree.state()
            .node_by_tree_local_id(viewport_id, TreeId::ROOT)
            .unwrap()
            .data()
            .scroll_y(),
        Some(64.0)
    );
    ingress.do_action(request(accesskit::Action::ScrollIntoView, child_id, None));
    assert!(matches!(
        drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap()[0],
        Some(Ok(_))
    ));
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    assert_eq!(win.viewport(viewport).unwrap().offset.y, 96.0);
    ingress.do_action(request(
        accesskit::Action::SetScrollOffset,
        viewport_id,
        Some(ActionData::SetScrollOffset(accesskit::Point {
            x: 10.0,
            y: 20.0,
        })),
    ));
    assert!(matches!(
        drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap()[0],
        Some(Ok(_))
    ));
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    assert_eq!(
        win.viewport(viewport).unwrap().offset,
        crate::ScrollOffset { x: 10.0, y: 20.0 }
    );
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
}

struct ReflectedScrollPage;
impl View for ReflectedScrollPage {
    fn view(&self) -> El<'_> {
        ScrollPage.view().transform(Affine {
            a: -1.5,
            d: -2.0,
            tx: 160.0,
            ty: 150.0,
            ..Affine::IDENTITY
        })
    }
}
#[test]
fn native_scroll_coordinates_are_physical_displacements_with_reflection_and_dpi() {
    let mut win = Win::recording_scaled(
        ReflectedScrollPage,
        WindowOptions {
            size: [360, 320],
            ..Default::default()
        },
        2.0,
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let target = win.role(Role::ScrollView).one().unwrap();
    let node_id = id(&win, target);
    let projected = projection(&win);
    let node = &projected
        .nodes
        .iter()
        .find(|(id, _)| *id == node_id)
        .unwrap()
        .1;
    assert_eq!(
        (
            node.scroll_x_min(),
            node.scroll_x_max(),
            node.scroll_y_min(),
            node.scroll_y_max()
        ),
        (Some(-240.0), Some(0.0), Some(-384.0), Some(0.0))
    );
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    ingress.do_action(request(
        accesskit::Action::SetScrollOffset,
        node_id,
        Some(ActionData::SetScrollOffset(accesskit::Point {
            x: -90.0,
            y: -200.0,
        })),
    ));
    assert!(matches!(
        drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap()[0],
        Some(Ok(_))
    ));
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    assert_eq!(
        win.viewport(target).unwrap().offset,
        crate::ScrollOffset { x: 30.0, y: 50.0 }
    );
    let projected = projection(&win);
    let node = &projected
        .nodes
        .iter()
        .find(|(id, _)| *id == node_id)
        .unwrap()
        .1;
    assert_eq!(
        (node.scroll_x(), node.scroll_y()),
        (Some(-90.0), Some(-200.0))
    );
    ingress.do_action(request(
        accesskit::Action::ScrollDown,
        node_id,
        Some(ActionData::ScrollUnit(accesskit::ScrollUnit::Page)),
    ));
    assert!(matches!(
        drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap()[0],
        Some(Ok(_))
    ));
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    assert_eq!(win.viewport(target).unwrap().offset.y, 0.0);
    ingress.do_action(request(
        accesskit::Action::ScrollLeft,
        node_id,
        Some(ActionData::ScrollUnit(accesskit::ScrollUnit::Item)),
    ));
    assert!(matches!(
        drain_actions(&ingress, &receiver, &cohort(&win), &mut win).unwrap()[0],
        Some(Ok(_))
    ));
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    assert_eq!(win.viewport(target).unwrap().offset.x, 62.0);
    // Malformed native floating-point payloads never enter the owner queue.
    ingress.do_action(request(
        accesskit::Action::SetScrollOffset,
        node_id,
        Some(ActionData::SetScrollOffset(accesskit::Point {
            x: f64::NAN,
            y: 0.0,
        })),
    ));
    assert!(receiver.try_recv().is_err());
    assert_eq!(win.snapshot().unwrap().source_epoch, 0);
}

#[test]
fn checkbox_native_carrier_sizes() {
    use std::mem::size_of;
    macro_rules! carrier {
        ($ty:ty) => {
            println!(
                "CHECKBOX_NATIVE_CARRIER {} size={} align={}",
                stringify!($ty),
                size_of::<$ty>(),
                std::mem::align_of::<$ty>()
            );
        };
    }
    carrier!(Bridge);
    carrier!(State);
    carrier!(Option<State>);
    carrier!(Queued);
    carrier!(Command);
    carrier!(Node);
    carrier!(Cohort);
    carrier!(text::Relink);
    println!(
        "CHECKBOX_NATIVE_LAYOUT bridge_test={} state={} option_state={} queued={} command={} node={} cohort_test={} relink={}",
        size_of::<Bridge>(),
        size_of::<State>(),
        size_of::<Option<State>>(),
        size_of::<Queued>(),
        size_of::<Command>(),
        size_of::<Node>(),
        size_of::<Cohort>(),
        size_of::<text::Relink>()
    );
}

#[test]
fn ime_accesskit_uses_acknowledged_display_and_selection_without_preview_edit_authority() {
    fn display(mut tree: TreeUpdate) -> TreeUpdate {
        // Pending/failed logical work may revoke live action capabilities.
        // Every acknowledged display byte, selection, TextRun and bound stays P.
        for (_, node) in &mut tree.nodes {
            node.clear_actions();
            node.clear_read_only();
        }
        tree
    }
    struct Input {
        value: Signal<String>,
        broken: bool,
    }
    impl Input {
        const VALUE: Source<Self, String> =
            Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    }
    impl View for Input {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::VALUE)
        }
        fn view(&self) -> El<'_> {
            column((
                text_input(&self.value).w(180),
                div()
                    .size(2)
                    .bg(crate::Color::BLACK)
                    .transform(if self.broken {
                        Affine::scale(0., 1.)
                    } else {
                        Affine::IDENTITY
                    }),
            ))
        }
    }
    let mut win = Win::recording(
        Input {
            value: Signal::new("base".into()),
            broken: false,
        },
        WindowOptions::default(),
    )
    .unwrap();
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let input = win.input();
    win.focus(input).unwrap();
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let mut session = crate::ImeSession::default();
    win.ime_event(&mut session, crate::ImeEvent::Enabled)
        .unwrap();
    let initial = projection(&win);
    win.ime_event(
        &mut session,
        crate::ImeEvent::Preedit {
            text: "e\u{301}",
            cursor: Some((1, 1)),
        },
    )
    .unwrap();
    assert_eq!(
        display(projection(&win)),
        display(initial),
        "candidate must not leak into AccessKit P"
    );
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let current = projection(&win);
    let native = id(&win, input);
    let node = &current
        .nodes
        .iter()
        .find(|(id, _)| *id == native)
        .unwrap()
        .1;
    assert_eq!(node.value(), Some("basee\u{301}"));
    assert!(node.text_selection().is_some());
    assert!(!node.supports_action(accesskit::Action::ReplaceSelectedText));
    assert!(!node.supports_action(accesskit::Action::SetTextSelection));
    assert!(!node.supports_action(accesskit::Action::SetValue));
    assert!(node.is_read_only());
    let tree = Tree::new(current.clone(), true);
    assert_eq!(
        tree.state()
            .node_by_tree_local_id(native, TreeId::ROOT)
            .unwrap()
            .raw_text_selection()
            .unwrap()
            .focus
            .character_index,
        4
    );
    win.ime_event(
        &mut session,
        crate::ImeEvent::Preedit {
            text: "אבג",
            cursor: Some((2, 2)),
        },
    )
    .unwrap();
    let old_candidate = win.with_scene(|_, t| t).unwrap();
    assert_eq!(display(projection(&win)), display(current.clone()));
    assert!(win.update(|m| m.broken = true).is_err());
    assert_eq!(display(projection(&win)), display(current.clone()));
    win.presented(old_candidate).unwrap();
    let acknowledged = projection(&win);
    assert_eq!(
        acknowledged
            .nodes
            .iter()
            .find(|(node, _)| *node == id(&win, input))
            .unwrap()
            .1
            .value(),
        Some("baseאבג")
    );
    assert_eq!(win.read(Input::VALUE).unwrap(), "base");
    assert!(
        win.ime_cursor_area(&session).unwrap().is_none(),
        "revoked L cannot expose native caret from old C"
    );
    win.update(|m| m.broken = false).unwrap();
    win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    let restored = projection(&win);
    let node = &restored
        .nodes
        .iter()
        .find(|(node, _)| *node == id(&win, input))
        .unwrap()
        .1;
    assert_eq!(node.value(), Some("base"));
    assert!(node.supports_action(accesskit::Action::ReplaceSelectedText));
}

#[test]
fn overscan_native_projection_excludes_buffered_rows_and_reuses_returning_ids() {
    let mut model = library::Library::new(250_000);
    model.overscan = 2;
    let mut win = Win::recording(
        model,
        WindowOptions {
            size: [760, 600],
            ..Default::default()
        },
    )
    .unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let list = win.list(library::LIBRARY).unwrap();
    let first = id(&win, win.list_item(list, crate::ItemKey::new(0)).unwrap());
    let initial = projection(&win);
    let mut tree = Tree::new(initial.clone(), true);
    for index in [1, 0, 10] {
        let previous = projection(&win);
        win.scroll_to_index(list, index).unwrap();
        assert_eq!(projection(&win), previous, "P remains frozen before ACK");
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
        let current = projection(&win);
        let positions: Vec<_> = current
            .nodes
            .iter()
            .filter(|(_, n)| n.role() == accesskit::Role::ListItem)
            .map(|(_, n)| n.position_in_set().unwrap())
            .collect();
        assert_eq!(positions, (index..index + 13).collect::<Vec<_>>());
        tree.update_and_process_changes(current, &mut Changes::default());
        assert_eq!(
            tree.state()
                .node_by_tree_local_id(first, TreeId::ROOT)
                .is_some(),
            index == 0
        );
        if index == 0 {
            assert_eq!(
                id(&win, win.list_item(list, crate::ItemKey::new(0)).unwrap()),
                first
            );
        }
    }
}
