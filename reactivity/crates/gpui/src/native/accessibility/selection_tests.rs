use super::*;
use crate::{
    El, FieldId, ItemKey, ItemSource, ListId, Signal, Source, Sources, WindowOptions, text_input,
    uniform_list,
};
use accesskit::{
    ActionHandler, ActivationHandler, DeactivationHandler, TextPosition, TextSelection,
};
use accesskit_consumer::Tree;

const LIST: ListId = ListId::new(1);
#[test]
fn native_text_transport_memory_budget() {
    assert_eq!(size_of::<Command>(), 32);
    assert_eq!(size_of::<Queued>(), 40);
    assert_eq!(size_of::<Ingress>(), 8);
    assert_eq!(size_of::<accesskit::ActionData>(), 40);
    assert_eq!(size_of::<accesskit::TextReplacement>(), 48);
    eprintln!(
        "NATIVE_TEXT_MEMORY shared={} command={} queued={} ingress={} replacement={}",
        size_of::<Shared>(),
        size_of::<Command>(),
        size_of::<Queued>(),
        size_of::<Ingress>(),
        size_of::<accesskit::TextReplacement>()
    );
    let mut transport = None;
    let allocation = allocation_counter::measure(|| transport = Some(Ingress::channel(None)));
    eprintln!(
        "NATIVE_TEXT_INGRESS allocations={} retained={} peak={}",
        allocation.count_total, allocation.bytes_current, allocation.bytes_max
    );
    drop(transport);
}
struct Inputs {
    a: Signal<String>,
    b: Signal<String>,
    rebind: bool,
}
impl Inputs {
    const A: Source<Self, String> = Source::new(FieldId::new(1), "a", |m| &m.a, |m| &mut m.a);
    const B: Source<Self, String> = Source::new(FieldId::new(2), "b", |m| &m.b, |m| &mut m.b);
    fn new(value: &str) -> Self {
        Self {
            a: Signal::new(value.into()),
            b: Signal::new("second".into()),
            rebind: false,
        }
    }
}
impl ItemSource for Inputs {
    fn len(&self) -> usize {
        2
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64 + 1)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        (1..=2).contains(&key.get()).then(|| key.get() as usize - 1)
    }
    fn row(&self, index: usize) -> El<'_> {
        text_input(if index == 0 && !self.rebind {
            &self.a
        } else {
            &self.b
        })
        .w(240)
        .h(40)
    }
}
impl View for Inputs {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::A).direct(Self::B)
    }
    fn view(&self) -> El<'_> {
        uniform_list(LIST, self, 40).w(280).h(100)
    }
}
fn target(win: &Win<Inputs>, key: u64) -> Target {
    let row = win
        .list_item(win.list(LIST).unwrap(), ItemKey::new(key))
        .unwrap();
    win.role(Role::TextInput).within(row).one().unwrap()
}
fn native_id(win: &Win<Inputs>, cohort: &Cohort, target: Target) -> NodeId {
    let mut id = None;
    win.visit(|part| {
        if part.target() == target {
            id = Some(cohort.id(part));
        }
    })
    .unwrap();
    id.unwrap()
}
fn ack(win: &mut Win<Inputs>) {
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
}
fn request(action: accesskit::Action, target_node: NodeId, data: ActionData) -> ActionRequest {
    ActionRequest {
        action,
        target_node,
        target_tree: TreeId::ROOT,
        data: Some(data),
    }
}
fn selection(
    id: NodeId,
    anchor_run: u64,
    anchor: usize,
    focus_run: u64,
    focus: usize,
) -> TextSelection {
    TextSelection {
        anchor: TextPosition {
            node: NodeId(id.0 + 2 + anchor_run),
            character_index: anchor,
        },
        focus: TextPosition {
            node: NodeId(id.0 + 2 + focus_run),
            character_index: focus,
        },
    }
}

#[test]
fn source_aba_and_shared_empty_allocation_cannot_revive_retired_provider_ids() {
    let mut win = Win::demo(Inputs::new(""));
    win.set(Inputs::B, String::new()).unwrap();
    let target = target(&win, 1);
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let old = native_id(&win, &cohort, target);
    let empty = win.accessibility_input(target).unwrap().1.as_ptr();
    win.set(Inputs::A, "different source".into()).unwrap();
    cohort.refresh(&win).unwrap();
    win.set(Inputs::A, String::new()).unwrap();
    cohort.refresh(&win).unwrap();
    assert!(std::ptr::eq(
        empty,
        win.accessibility_input(target).unwrap().1.as_ptr()
    ));
    let restored = native_id(&win, &cohort, target);
    assert_ne!(
        old, restored,
        "retired IDs never recycle even for the same empty allocation"
    );
    assert!(cohort.target(&win, old).is_err());
    assert_eq!(cohort.target(&win, restored).unwrap(), target);

    win.update(|m| m.rebind = true).unwrap();
    cohort.refresh(&win).unwrap();
    assert!(std::ptr::eq(
        empty,
        win.accessibility_input(target).unwrap().1.as_ptr()
    ));
    assert_ne!(restored, native_id(&win, &cohort, target));
    assert!(
        cohort.target(&win, restored).is_err(),
        "field rebinding revokes the same allocation"
    );
}

#[test]
fn unpublished_source_aba_keeps_only_identical_acknowledged_root_authority() {
    let mut win = Win::recording(Inputs::new(""), WindowOptions::default()).unwrap();
    ack(&mut win);
    let target = target(&win, 1);
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let root = native_id(&win, &cohort, target);
    let empty = win.accessibility_input(target).unwrap().1.as_ptr();
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    ingress.do_action(request(
        accesskit::Action::SetValue,
        root,
        ActionData::Value("after identical empty source".into()),
    ));
    win.set(Inputs::A, "unpublished intermediate".into())
        .unwrap();
    win.set(Inputs::A, String::new()).unwrap();
    ack(&mut win);
    cohort.refresh(&win).unwrap();
    assert!(std::ptr::eq(
        empty,
        win.accessibility_input(target).unwrap().1.as_ptr()
    ));
    assert_eq!(native_id(&win, &cohort, target), root);
    // No different source was ever published under this ID. A position-free
    // intent still addresses the same field and exact acknowledged empty lease.
    assert!(
        drain_actions(&ingress, &receiver, &cohort, &mut win).unwrap()[0]
            .as_ref()
            .unwrap()
            .is_ok()
    );
    assert_eq!(
        win.root().unwrap().a.as_str(),
        "after identical empty source"
    );
}

#[test]
fn old_provider_run_endpoints_fail_on_both_sides_of_geometry_publication() {
    let mut win = Win::demo(Inputs::new("e\u{301} אבג"));
    let target = target(&win, 1);
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let root = native_id(&win, &cohort, target);
    let previous = selection(root, 0, 0, 0, 1);
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    // A request queued before publication and an old provider invoked after it
    // carry the same retired run IDs, independently of a global tree counter.
    ingress.do_action(request(
        accesskit::Action::SetTextSelection,
        root,
        ActionData::SetTextSelection(previous),
    ));
    win.set_property(
        target,
        crate::property::FONT_SIZE,
        crate::property::Contribution::Set(24.),
    )
    .unwrap();
    cohort.refresh(&win).unwrap();
    assert_eq!(
        native_id(&win, &cohort, target),
        root,
        "position-free root authority survives"
    );
    ingress.do_action(request(
        accesskit::Action::SetTextSelection,
        root,
        ActionData::SetTextSelection(previous),
    ));
    let update = project(
        &win.accessibility_sheet().unwrap(),
        win.accessibility_state().unwrap(),
        "Inputs",
        &cohort,
    );
    let tree = Tree::new(update, true);
    let current = tree
        .state()
        .node_by_tree_local_id(root, TreeId::ROOT)
        .unwrap()
        .document_range()
        .to_text_selection();
    ingress.do_action(request(
        accesskit::Action::SetTextSelection,
        root,
        ActionData::SetTextSelection(current),
    ));
    let result = drain_actions(&ingress, &receiver, &cohort, &mut win).unwrap();
    assert!(matches!(result[0], Some(Err(Error::InvalidSelection))));
    assert!(matches!(result[1], Some(Err(Error::InvalidSelection))));
    assert!(result[2].as_ref().unwrap().is_ok());
    assert_eq!(
        win.selection(target).unwrap().focus.offset.byte(),
        win.root().unwrap().a.len()
    );
}

#[test]
fn native_selection_and_atomic_replacement_use_acknowledged_grapheme_source() {
    let mut win = Win::recording(Inputs::new("e\u{301}\r\nאבג"), WindowOptions::default()).unwrap();
    ack(&mut win);
    let target = target(&win, 1);
    let mut cohort = Cohort::default();
    assert!(cohort.refresh(&win).unwrap());
    let id = native_id(&win, &cohort, target);
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    let reversed = selection(id, 1, 2, 0, 1);
    ingress.do_action(request(
        accesskit::Action::SetTextSelection,
        id,
        ActionData::SetTextSelection(reversed),
    ));
    assert!(
        drain_actions(&ingress, &receiver, &cohort, &mut win).unwrap()[0]
            .as_ref()
            .unwrap()
            .is_ok()
    );
    assert_eq!(win.selection(target).unwrap().anchor.offset.byte(), 9);
    assert_eq!(win.selection(target).unwrap().focus.offset.byte(), 3);
    let old = Tree::new(
        project(
            &win.accessibility_sheet().unwrap(),
            win.accessibility_state().unwrap(),
            "Inputs",
            &cohort,
        ),
        true,
    );
    let old_input = old.state().node_by_tree_local_id(id, TreeId::ROOT).unwrap();
    assert_eq!(
        old_input
            .text_selection_focus()
            .unwrap()
            .to_global_usv_index(),
        7
    );
    ack(&mut win);
    assert!(!cohort.refresh(&win).unwrap());
    let tree = Tree::new(
        project(
            &win.accessibility_sheet().unwrap(),
            win.accessibility_state().unwrap(),
            "Inputs",
            &cohort,
        ),
        true,
    );
    let input = tree
        .state()
        .node_by_tree_local_id(id, TreeId::ROOT)
        .unwrap();
    assert_eq!(input.document_range().text(), "e\u{301}\r\nאבג");
    assert_eq!(
        input.text_selection_anchor().unwrap().to_global_usv_index(),
        6
    );
    assert_eq!(
        input.text_selection_focus().unwrap().to_global_usv_index(),
        2
    );
    ingress.do_action(request(
        accesskit::Action::ReplaceSelectedText,
        id,
        ActionData::Value("x".into()),
    ));
    assert!(
        drain_actions(&ingress, &receiver, &cohort, &mut win).unwrap()[0]
            .as_ref()
            .unwrap()
            .is_ok()
    );
    assert_eq!(win.root().unwrap().a.as_str(), "e\u{301}xג");
    // A second queued request is bound to the old lease, even before publication.
    ingress.do_action(request(
        accesskit::Action::ReplaceSelectedText,
        id,
        ActionData::Value("bad".into()),
    ));
    assert!(
        drain_actions(&ingress, &receiver, &cohort, &mut win).unwrap()[0]
            .as_ref()
            .unwrap()
            .is_err()
    );
    ack(&mut win);
    assert!(cohort.refresh(&win).unwrap());
    let next = native_id(&win, &cohort, target);
    assert_ne!(next, id);
    let range = selection(next, 0, 1, 0, 2);
    ingress.do_action(request(
        accesskit::Action::ReplaceSelectedText,
        next,
        ActionData::ReplaceText(Box::new(accesskit::TextReplacement {
            selection: range,
            value: "!".into(),
        })),
    ));
    assert!(
        drain_actions(&ingress, &receiver, &cohort, &mut win).unwrap()[0]
            .as_ref()
            .unwrap()
            .is_ok()
    );
    assert_eq!(win.root().unwrap().a.as_str(), "e\u{301}!ג");
}

#[test]
fn independent_inputs_list_rebind_and_provider_restart_do_not_reuse_authority() {
    let mut win = Win::demo(Inputs::new("same"));
    let a = target(&win, 1);
    let b = target(&win, 2);
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let a_id = native_id(&win, &cohort, a);
    let b_id = native_id(&win, &cohort, b);
    win.set(Inputs::B, "changed".into()).unwrap();
    assert!(cohort.refresh(&win).unwrap());
    assert_eq!(native_id(&win, &cohort, a), a_id);
    assert_ne!(native_id(&win, &cohort, b), b_id);
    win.update(|m| m.rebind = true).unwrap();
    assert_eq!(
        target(&win, 1),
        a,
        "list row and input survive the source rebind"
    );
    cohort.refresh(&win).unwrap();
    assert_ne!(native_id(&win, &cohort, a), a_id);
    assert!(cohort.target(&win, a_id).is_err());
    let before = native_id(&win, &cohort, a);
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    ingress.do_action(request(
        accesskit::Action::SetValue,
        before,
        ActionData::Value("discard".into()),
    ));
    ingress.deactivate_accessibility();
    cohort.clear();
    ingress.request_initial_tree();
    cohort.refresh(&win).unwrap();
    assert_ne!(native_id(&win, &cohort, a), before);
    assert!(
        drain_actions(&ingress, &receiver, &cohort, &mut win)
            .unwrap()
            .iter()
            .all(Option::is_none)
    );
    ingress.do_action(request(
        accesskit::Action::SetValue,
        before,
        ActionData::Value("late cached ID".into()),
    ));
    assert_eq!(
        drain_actions(&ingress, &receiver, &cohort, &mut win).unwrap()[0],
        Some(Err(Error::StaleTarget))
    );
    assert_eq!(win.root().unwrap().b.as_str(), "changed");
}

#[test]
fn empty_static_text_does_not_qualify_another_owner() {
    let first = Win::demo(Inputs::new(""));
    let second = Win::demo(Inputs::new(""));
    let mut cohort = Cohort::default();
    cohort.refresh(&first).unwrap();
    let id = native_id(&first, &cohort, target(&first, 1));
    let mut legacy = None;
    first
        .visit(|part| {
            if part.target() == target(&first, 1) {
                legacy = Some(NodeId(part.native_id() * 2));
            }
        })
        .unwrap();
    assert_eq!(
        cohort.target(&first, legacy.unwrap()),
        Err(Error::StaleTarget)
    );
    assert_eq!(cohort.target(&second, id), Err(Error::StaleTarget));
    assert_eq!(cohort.refresh(&second), Err(Error::StaleTarget));
    assert!(cohort.target(&first, id).is_ok());
    assert_eq!(
        Cohort::default().target(&first, NodeId(2)),
        Err(Error::StaleTarget)
    );
}

#[test]
fn long_graphemes_terminal_crlf_and_invalid_foreign_ranges_roundtrip() {
    let value = format!("a{}\r\n", "\u{301}".repeat(200));
    let mut win = Win::demo(Inputs::new(&value));
    let target = target(&win, 1);
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let id = native_id(&win, &cohort, target);
    let tree = Tree::new(
        project(
            &win.accessibility_sheet().unwrap(),
            win.accessibility_state().unwrap(),
            "Inputs",
            &cohort,
        ),
        true,
    );
    let input = tree
        .state()
        .node_by_tree_local_id(id, TreeId::ROOT)
        .unwrap();
    assert_eq!(input.document_range().text(), value);
    assert_eq!(
        input.text_selection_focus().unwrap().to_global_usv_index(),
        203
    );
    let first = tree
        .state()
        .node_by_tree_local_id(NodeId(id.0 + 2), TreeId::ROOT)
        .unwrap();
    assert_eq!(first.data().character_lengths(), &[0, 2]);
    assert_eq!(
        first
            .data()
            .decoded_character_lengths()
            .unwrap()
            .collect::<Vec<_>>(),
        [401, 2]
    );
    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    for selected in [
        selection(id, 0, 999, 0, 0),
        selection(NodeId(id.0 + 500), 0, 0, 0, 0),
    ] {
        ingress.do_action(request(
            accesskit::Action::SetTextSelection,
            id,
            ActionData::SetTextSelection(selected),
        ));
        assert_eq!(
            drain_actions(&ingress, &receiver, &cohort, &mut win).unwrap()[0],
            Some(Err(Error::InvalidSelection))
        );
        assert_eq!(win.root().unwrap().a.as_str(), value);
    }
    if cfg!(target_pointer_width = "64") {
        assert_eq!(size_of::<Queued>(), 40);
        assert_eq!(size_of::<accesskit::ActionData>(), 40);
    }
}

#[test]
fn failed_newer_edit_and_cold_provider_keep_older_candidate_selection() {
    let mut win = Win::recording(Inputs::new("ab"), WindowOptions::default()).unwrap();
    ack(&mut win);
    let target = target(&win, 1);
    let p = |byte| gpui_canvas::TextPosition {
        offset: gpui_canvas::TextOffset::new(byte).unwrap(),
        affinity: gpui_canvas::CaretAffinity::Downstream,
    };
    win.select(
        target,
        gpui_canvas::TextSelection {
            anchor: p(0),
            focus: p(1),
        },
    )
    .unwrap();
    let candidate = win.with_scene(|_, token| token).unwrap();
    assert!(matches!(
        win.type_text(target, "👩\u{200d}💻"),
        Err(Error::Canvas(_))
    ));
    assert_eq!(win.selection(target).unwrap().focus.offset.byte(), 11);
    win.presented(candidate).unwrap();
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let id = native_id(&win, &cohort, target);
    let tree = Tree::new(
        project(
            &win.accessibility_sheet().unwrap(),
            win.accessibility_state().unwrap(),
            "Cold",
            &cohort,
        ),
        true,
    );
    let input = tree
        .state()
        .node_by_tree_local_id(id, TreeId::ROOT)
        .unwrap();
    assert_eq!(input.document_range().text(), "ab");
    assert_eq!(
        input.text_selection_anchor().unwrap().to_global_usv_index(),
        0
    );
    assert_eq!(
        input.text_selection_focus().unwrap().to_global_usv_index(),
        1
    );
    assert!(
        !input
            .data()
            .supports_action(accesskit::Action::SetTextSelection)
    );
    assert!(
        !input
            .data()
            .supports_action(accesskit::Action::ReplaceSelectedText)
    );
    assert!(cohort.target(&win, id).is_err());
    // Position-free ordinary repair remains available on the same owner path.
    win.perform(target, Action::SetValue("repaired")).unwrap();
    ack(&mut win);
    assert!(cohort.refresh(&win).unwrap());
    let repaired = native_id(&win, &cohort, target);
    assert_ne!(repaired, id);
    assert!(cohort.target(&win, repaired).is_ok());
}

#[test]
fn equal_text_field_rebind_survives_failed_prepare_and_older_ack() {
    let mut model = Inputs::new("same");
    model.b = Signal::new("same".into());
    let mut win = Win::recording(model, WindowOptions::default()).unwrap();
    ack(&mut win);
    win.accessibility_observe(true).unwrap();
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let input = target(&win, 1);
    let before_id = native_id(&win, &cohort, input);
    let base = win.accessibility_state().unwrap();
    let root = win.inspect().unwrap().nodes[0].target.unwrap();
    win.set_property(
        root,
        crate::property::TRANSFORM,
        crate::property::Contribution::Set(crate::Affine::translation(1., 0.)),
    )
    .unwrap();
    let old = win.with_scene(|_, token| token).unwrap();
    assert!(
        win.set_property(
            root,
            crate::property::TRANSFORM,
            crate::property::Contribution::Set(crate::Affine::scale(0., 1.))
        )
        .is_err()
    );
    assert!(win.update(|m| m.rebind = true).is_err());
    win.presented(old).unwrap();
    let old_state = win.accessibility_state().unwrap();
    assert!(win.accessibility_delta(base, old_state).is_none());
    cohort.refresh(&win).unwrap();
    assert!(cohort.target(&win, before_id).is_err());
    // Repair produces the current binding without changing any text bytes.
    win.set_property(
        root,
        crate::property::TRANSFORM,
        crate::property::Contribution::Set(crate::Affine::IDENTITY),
    )
    .unwrap();
    ack(&mut win);
    let rebound = win.accessibility_state().unwrap();
    assert!(win.accessibility_delta(old_state, rebound).is_none());
    cohort.refresh(&win).unwrap();
    let id = native_id(&win, &cohort, input);
    assert_ne!(id, before_id);
    assert!(cohort.target(&win, id).is_ok());
    win.set_semantic(
        root,
        crate::semantic::DESCRIPTION,
        crate::property::Contribution::Set(Some("current binding".into())),
    )
    .unwrap();
    let next = win.accessibility_state().unwrap();
    assert_eq!(win.accessibility_delta(rebound, next).unwrap().len(), 1);
    assert!(
        !cohort
            .update_delta(&win, win.accessibility_delta(rebound, next).unwrap())
            .unwrap()
            .root
    );
    assert_eq!(native_id(&win, &cohort, input), id);
}

#[test]
fn late_observer_same_byte_rebind_noop_and_failed_newer_ack_revoke_old_actions() {
    let mut model = Inputs::new("same");
    model.b = Signal::new("same".into());
    let mut win = Win::recording(model, WindowOptions::default()).unwrap();
    ack(&mut win);
    // A provider may have published P before the transition observer activates.
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let input = target(&win, 1);
    let retired = native_id(&win, &cohort, input);
    let base = win.accessibility_state().unwrap();
    let root = win.inspect().unwrap().nodes[0].target.unwrap();
    win.set_property(
        root,
        crate::property::TRANSFORM,
        crate::property::Contribution::Set(crate::Affine::translation(1., 0.)),
    )
    .unwrap();
    win.update(|model| model.rebind = true).unwrap();
    let eligible = win.with_scene(|_, token| token).unwrap();
    assert!(win.snapshot().unwrap().prepared_epoch.is_some());
    win.accessibility_observe(true).unwrap();
    // A is registered but has no destinations after the same-byte B rebind.
    // This must use the generic unchanged publication protocol, not a color slot.
    win.set(Inputs::A, "same".into()).unwrap();
    assert_eq!(win.with_scene(|_, token| token).unwrap(), eligible);
    assert_eq!(win.accessibility_state().unwrap(), base);
    assert!(
        win.set_property(
            root,
            crate::property::TRANSFORM,
            crate::property::Contribution::Set(crate::Affine::scale(0., 1.)),
        )
        .is_err()
    );
    assert!(win.set(Inputs::A, "same".into()).is_err());
    let old_ack = win.presented(eligible).unwrap();
    assert!(old_ack.presentation_epoch < old_ack.source_epoch);
    let acknowledged = win.accessibility_state().unwrap();
    assert!(win.accessibility_delta(base, acknowledged).is_none());
    cohort.refresh(&win).unwrap();
    assert!(cohort.target(&win, retired).is_err());
    let unqualified = native_id(&win, &cohort, input);
    assert!(!cohort.qualified());
    assert!(cohort.target(&win, unqualified).is_err());

    win.set_property(
        root,
        crate::property::TRANSFORM,
        crate::property::Contribution::Set(crate::Affine::IDENTITY),
    )
    .unwrap();
    ack(&mut win);
    cohort.refresh(&win).unwrap();
    assert!(cohort.qualified());
    let current = native_id(&win, &cohort, input);
    assert_ne!(current, retired);
    assert_ne!(current, unqualified);
    let covered = win.accessibility_state().unwrap();
    win.set(Inputs::A, "same".into()).unwrap();
    let next = win.accessibility_state().unwrap();
    assert_eq!(win.accessibility_delta(covered, next), Some(&[][..]));
    cohort
        .update_delta(&win, win.accessibility_delta(covered, next).unwrap())
        .unwrap();
    assert_eq!(native_id(&win, &cohort, input), current);
    assert!(cohort.target(&win, retired).is_err());

    let (mut ingress, receiver) = Ingress::channel(None);
    ingress.request_initial_tree();
    for (id, value) in [(retired, "stale mutation"), (current, "accepted current")] {
        ingress.do_action(request(
            accesskit::Action::SetValue,
            id,
            ActionData::Value(value.into()),
        ));
    }
    let result = drain_actions(&ingress, &receiver, &cohort, &mut win).unwrap();
    assert!(matches!(result[0], Some(Err(Error::StaleTarget))));
    assert!(result[1].as_ref().unwrap().is_ok());
    assert_eq!(win.root().unwrap().a.as_str(), "same");
    assert_eq!(win.root().unwrap().b.as_str(), "accepted current");
}

#[test]
fn cold_unqualified_publication_recovers_after_same_byte_empty_frontier_repair() {
    let mut win = Win::recording(Inputs::new("same"), WindowOptions::default()).unwrap();
    ack(&mut win);
    let input = target(&win, 1);
    let root = win.inspect().unwrap().nodes[0].target.unwrap();
    let map = crate::Affine::translation(1., 0.);
    win.set_property(
        root,
        crate::property::TRANSFORM,
        crate::property::Contribution::Set(map),
    )
    .unwrap();
    let old = win.with_scene(|_, token| token).unwrap();
    assert!(
        win.set_property(
            root,
            crate::property::TRANSFORM,
            crate::property::Contribution::Set(crate::Affine::scale(0., 1.))
        )
        .is_err()
    );
    win.presented(old).unwrap();
    win.accessibility_observe(true).unwrap();
    let cold = win.accessibility_state().unwrap();
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    assert!(!cohort.qualified());
    let policy = Refresh::published(cohort.qualified());
    assert!(policy == Refresh::AfterTransition && policy != Refresh::Immediate);
    let stale = native_id(&win, &cohort, input);
    assert!(cohort.target(&win, stale).is_err());
    win.set_property(
        root,
        crate::property::TRANSFORM,
        crate::property::Contribution::Set(map),
    )
    .unwrap();
    ack(&mut win);
    let repaired = win.accessibility_state().unwrap();
    assert!(win.accessibility_delta(cold, repaired).unwrap().is_empty());
    // Production policy rejects that otherwise-exact empty frontier. Refresh
    // once on this transition, rather than scanning on each unchanged idle.
    assert!(policy != Refresh::Sparse);
    cohort.refresh(&win).unwrap();
    assert!(cohort.qualified());
    let policy = Refresh::published(cohort.qualified());
    assert!(policy == Refresh::Sparse);
    let fresh = native_id(&win, &cohort, input);
    assert_ne!(fresh, stale);
    assert!(cohort.target(&win, stale).is_err());
    assert!(cohort.target(&win, fresh).is_ok());
    let visits = cohort.full_visits;
    let clones = cohort.source_clones;
    win.set_property(
        root,
        crate::property::BACKGROUND,
        crate::property::Contribution::Set(crate::Brush::Solid(crate::Color::WHITE)),
    )
    .unwrap();
    ack(&mut win);
    let paint = win.accessibility_state().unwrap();
    let delta = win.accessibility_delta(repaired, paint).unwrap();
    assert!(delta.is_empty());
    assert!(cohort.update_delta(&win, delta).unwrap().qualified);
    assert_eq!((cohort.full_visits, cohort.source_clones), (visits, clones));
}

#[test]
fn input_root_survives_wrap_and_font_changes_but_old_run_positions_retire() {
    use crate::property::{Contribution, FONT_SIZE, WIDTH};
    let mut win = Win::demo(Inputs::new(
        "office café אבג العربية repeated words for wrapping",
    ));
    let target = target(&win, 1);
    win.focus(target).unwrap();
    let mut cohort = Cohort::default();
    cohort.refresh(&win).unwrap();
    let root = native_id(&win, &cohort, target);
    let snapshot = |win: &Win<Inputs>, cohort: &Cohort| {
        let tree = Tree::new(
            project(
                &win.accessibility_sheet().unwrap(),
                win.accessibility_state().unwrap(),
                "Inputs",
                cohort,
            ),
            true,
        );
        let input = tree
            .state()
            .node_by_tree_local_id(root, TreeId::ROOT)
            .unwrap();
        assert_eq!(tree.state().focus_id_in_tree(), input.id());
        assert_eq!(
            input.document_range().text(),
            win.root().unwrap().a.as_str()
        );
        input.document_range().to_text_selection()
    };
    let mut previous = snapshot(&win, &cohort);
    for change in 0..2 {
        if change == 0 {
            win.set_property(target, WIDTH, Contribution::Set(Some(75.)))
                .unwrap();
        } else {
            win.set_property(target, FONT_SIZE, Contribution::Set(24.))
                .unwrap();
        }
        assert!(cohort.refresh(&win).unwrap());
        assert_eq!(native_id(&win, &cohort, target), root);
        assert_eq!(cohort.target(&win, root).unwrap(), target);
        assert!(
            cohort.selection(root, previous).is_none(),
            "retired child range"
        );
        let current = snapshot(&win, &cohort);
        assert_ne!(current.anchor.node, previous.anchor.node);
        let decoded = cohort.selection(root, current).unwrap();
        assert_eq!(decoded.anchor.offset.byte(), 0);
        assert_eq!(decoded.focus.offset.byte(), win.root().unwrap().a.len());
        previous = current;
    }
    win.set(Inputs::A, "new source".into()).unwrap();
    cohort.refresh(&win).unwrap();
    assert_ne!(native_id(&win, &cohort, target), root);
    assert!(cohort.target(&win, root).is_err());
    assert!(cohort.selection(root, previous).is_none());
}

#[test]
fn keyboard_vertical_selection_projects_the_same_acknowledged_endpoints() {
    let mut win = Win::demo(Inputs::new("abcdefghij\nx\nabcdefghij"));
    let input = target(&win, 1);
    win.focus(input).unwrap();
    win.select(input, crate::TextSelection::caret(8).unwrap())
        .unwrap();
    for expected in [12, 21] {
        win.key(crate::Key::Down { extend: true }).unwrap();
        let mut cohort = Cohort::default();
        cohort.refresh(&win).unwrap();
        let id = native_id(&win, &cohort, input);
        let tree = Tree::new(
            project(
                &win.accessibility_sheet().unwrap(),
                win.accessibility_state().unwrap(),
                "Inputs",
                &cohort,
            ),
            true,
        );
        let node = tree
            .state()
            .node_by_tree_local_id(id, TreeId::ROOT)
            .unwrap();
        assert_eq!(
            node.text_selection_anchor().unwrap().to_global_usv_index(),
            8
        );
        assert_eq!(
            node.text_selection_focus().unwrap().to_global_usv_index(),
            expected
        );
        assert_eq!(win.selection(input).unwrap().focus.offset.byte(), expected);
    }
}
