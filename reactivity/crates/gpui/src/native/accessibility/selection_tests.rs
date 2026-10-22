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
            node: NodeId(id.0 + 1 + anchor_run),
            character_index: anchor,
        },
        focus: TextPosition {
            node: NodeId(id.0 + 1 + focus_run),
            character_index: focus,
        },
    }
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
        .node_by_tree_local_id(NodeId(id.0 + 1), TreeId::ROOT)
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
        assert_eq!(size_of::<Queued>(), 48);
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
