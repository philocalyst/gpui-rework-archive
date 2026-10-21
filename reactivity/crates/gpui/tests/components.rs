//! Reusable contained state uses explicit typed parent projections, with no
//! model addresses, implicit receiver guesses, or component-specific runtime.
use gpui::{BindError, Error, prelude::*};
use serde::{Deserialize, Serialize};
use std::{cell::Cell, rc::Rc};

#[derive(Default, Serialize, Deserialize)]
struct Counter {
    label: String,
    count: Signal<u32>,
    name: Signal<String>,
    plain: u32,
    #[serde(skip)]
    views: Rc<Cell<u32>>,
}
impl Counter {
    const COUNT: Source<Self, u32> =
        Source::new(FieldId::new(1), "count", |m| &m.count, |m| &mut m.count);
    const NAME: Source<Self, String> =
        Source::new(FieldId::new(2), "name", |m| &m.name, |m| &mut m.name);
    fn new(label: &str) -> Self {
        Self {
            label: label.into(),
            ..Self::default()
        }
    }
    fn coarse(&mut self) {
        *self.count += 1;
        self.plain += 1;
    }
}
impl View for Counter {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COUNT).direct(Self::NAME)
    }
    fn view(&self) -> El<'_> {
        self.views.set(self.views.get() + 1);
        column((
            text(&self.count),
            text(&self.name),
            text_input(&self.name).w(140).h(24),
            text(format!("{} plain {}", self.label, self.plain)),
            button(format!("{} exact", self.label))
                .on_click(Self::COUNT.update(|count| *count += 1)),
            button(format!("{} method", self.label)).on_click(Self::coarse),
        ))
        .gap(2)
    }
}
#[derive(Default, Serialize, Deserialize)]
struct Pair {
    left: Counter,
    right: Counter,
    swap: bool,
    bad_writer: bool,
    nested_visual: bool,
    #[serde(skip)]
    views: Rc<Cell<u32>>,
}
impl Pair {
    const LEFT: Component<Self, Counter> =
        Component::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
    const RIGHT: Component<Self, Counter> =
        Component::new(FieldId::new(2), "right", |m| &m.right, |m| &mut m.right);
    const BAD: Component<Self, Counter> =
        Component::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.right);
    fn new() -> Self {
        Self {
            left: Counter::new("Left"),
            right: Counter::new("Right"),
            ..Self::default()
        }
    }
}
impl View for Pair {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct_component(Self::LEFT)
            .direct_component(Self::RIGHT)
    }
    fn view(&self) -> El<'_> {
        self.views.set(self.views.get() + 1);
        let left = if self.bad_writer {
            Self::BAD.view(self)
        } else {
            Self::LEFT.view(self)
        };
        let right = Self::RIGHT.view(self);
        if self.nested_visual {
            left.child(right)
        } else if self.swap {
            row((right, left)).gap(8)
        } else {
            row((left, right)).gap(8)
        }
    }
}
fn visits(win: &Win<Pair>) -> (u32, u32, u32) {
    win.with_model(|m| (m.views.get(), m.left.views.get(), m.right.views.get()))
        .unwrap()
}
fn values(win: &Win<Pair>) -> (u32, u32, u32, u32, String, String) {
    win.with_model(|m| {
        (
            *m.left.count,
            *m.right.count,
            m.left.plain,
            m.right.plain,
            m.left.name.to_string(),
            m.right.name.to_string(),
        )
    })
    .unwrap()
}
#[test]
fn identical_component_types_dispatch_methods_actions_and_editable_ports_to_their_own_state() {
    let win = Win::with_size(Pair::new(), 420, 300).unwrap();
    let left = win.button("Left exact");
    let right = win.button("Right exact");
    let inputs: Vec<_> = win
        .snapshot()
        .unwrap()
        .nodes
        .iter()
        .filter(|node| node.role == "TextInput")
        .map(|node| node.target.unwrap())
        .collect();
    assert_eq!(inputs.len(), 2);
    let before = visits(&win);
    win.reset_counters().unwrap();
    win.click(left).unwrap();
    win.click(right).unwrap();
    win.click(right).unwrap();
    win.type_text(inputs[0], "one").unwrap();
    win.type_text(inputs[1], "two").unwrap();
    assert_eq!(values(&win), (1, 2, 0, 0, "one".into(), "two".into()));
    assert_eq!(
        visits(&win),
        before,
        "direct component ports do not describe parent or either child"
    );
    assert_eq!(win.counters().exact_updates, 5);
    win.click(win.button("Left method")).unwrap();
    assert_eq!(values(&win), (2, 2, 1, 0, "one".into(), "two".into()));
    assert_eq!(
        visits(&win),
        (before.0 + 1, before.1 + 1, before.2 + 1),
        "arbitrary contained methods retain parent scheduling grain"
    );
    win.click(right).unwrap();
    assert_eq!(
        values(&win).1,
        3,
        "unrelated target survives a same-topology owner description"
    );
}
#[test]
fn moving_and_restoring_models_preserves_state_and_remints_target_authority() {
    let win = Win::with_size(Pair::new(), 420, 300).unwrap();
    let target = win.button("Left exact");
    let moved = Box::new(win);
    moved.click(target).unwrap();
    moved.type_text(moved.input(), "saved").unwrap();
    let encoded = moved.source_json().unwrap();
    let restored = Win::<Pair>::from_json(&encoded).unwrap();
    assert_eq!(values(&restored), values(&moved));
    assert_eq!(restored.activate(target), Err(Error::StaleTarget));
    restored.click(restored.button("Right method")).unwrap();
    assert_eq!(values(&restored).1, 1);
    assert_eq!(values(&moved).1, 0);
}
#[test]
fn changing_component_owners_at_equal_ordinals_revokes_old_targets() {
    let win = Win::with_size(Pair::new(), 420, 300).unwrap();
    let left = win.button("Left exact");
    let right = win.button("Right exact");
    win.update(|m| m.swap = true).unwrap();
    assert_eq!(win.activate(left), Err(Error::StaleTarget));
    assert_eq!(win.activate(right), Err(Error::StaleTarget));
    win.click(win.button("Right exact")).unwrap();
    assert_eq!(values(&win).0, 0);
    assert_eq!(values(&win).1, 1);
}
#[test]
fn an_action_with_a_bad_component_writer_is_checked_before_mutation_or_epoch_admission() {
    let mut pair = Pair::new();
    pair.bad_writer = true;
    let win = Win::with_size(pair, 420, 300).unwrap();
    for label in ["Left exact", "Left method"] {
        assert_eq!(
            win.activate(win.button(label)),
            Err(Error::Binding(BindError::ComponentProjectionMismatch(
                Pair::LEFT.id()
            )))
        );
        let snapshot = win.snapshot().unwrap();
        assert_eq!(snapshot.source_epoch, 0);
        assert!(!snapshot.poisoned);
        assert_eq!(values(&win).0, 0);
        assert_eq!(values(&win).1, 0);
    }
    win.update(|m| m.bad_writer = false).unwrap();
    win.click(win.button("Left exact")).unwrap();
    assert_eq!(values(&win).0, 1);
}

struct Conservative {
    child: Counter,
}
impl Conservative {
    const CHILD: Component<Self, Counter> =
        Component::new(FieldId::new(1), "child", |m| &m.child, |m| &mut m.child);
}
impl View for Conservative {
    fn sources() -> Sources<Self> {
        Sources::new().component(Self::CHILD)
    }
    fn view(&self) -> El<'_> {
        column((
            text(if *self.child.count == 0 {
                "zero"
            } else {
                "nonzero"
            }),
            Self::CHILD.view(self),
        ))
    }
}
#[test]
fn default_registration_refreshes_parent_snapshots_even_when_the_child_field_is_direct() {
    let win = Win::new(Conservative {
        child: Counter::new("Child"),
    })
    .unwrap();
    win.click(win.button("Child exact")).unwrap();
    assert!(win.find_text("nonzero").is_ok());
    assert!(win.find_text("zero").is_err());
    assert_eq!(win.counters().coarse_updates, 1);
}
struct Outer {
    pair: Pair,
}
impl Outer {
    // Local component ID 1 and descendant field ID 1 are deliberately reused.
    const PAIR: Component<Self, Pair> =
        Component::new(FieldId::new(1), "pair", |m| &m.pair, |m| &mut m.pair);
}
impl View for Outer {
    fn sources() -> Sources<Self> {
        Sources::new().direct_component(Self::PAIR)
    }
    fn view(&self) -> El<'_> {
        Self::PAIR.view(self)
    }
}
#[test]
fn nested_component_roots_qualify_reused_ids_and_compose_typed_route_authority() {
    let win = Win::new(Outer { pair: Pair::new() }).unwrap();
    win.reset_counters().unwrap();
    win.click(win.button("Right exact")).unwrap();
    assert_eq!(
        win.with_model(|m| (*m.pair.left.count, *m.pair.right.count))
            .unwrap(),
        (0, 1)
    );
    assert_eq!(win.counters().owner_reruns, 0);
    win.type_text(win.input(), "nested").unwrap();
    assert_eq!(
        win.with_model(|m| m.pair.left.name.to_string()).unwrap(),
        "nested"
    );
    win.click(win.button("Left method")).unwrap();
    assert_eq!(win.with_model(|m| m.pair.left.plain).unwrap(), 1);
}

struct ReadOnly {
    value: String,
}
impl View for ReadOnly {
    fn view(&self) -> El<'_> {
        text(&self.value)
    }
}
struct Spoof {
    left: ReadOnly,
    right: ReadOnly,
}
impl Spoof {
    const GOOD: Component<Self, ReadOnly> =
        Component::new(FieldId::new(1), "left", |m| &m.left, |m| &mut m.left);
    const SPOOF: Component<Self, ReadOnly> =
        Component::new(FieldId::new(1), "left", |m| &m.right, |m| &mut m.right);
}
impl View for Spoof {
    fn sources() -> Sources<Self> {
        Sources::new().component(Self::GOOD)
    }
    fn view(&self) -> El<'_> {
        Self::SPOOF.view(self)
    }
}
#[test]
fn read_only_boundaries_also_check_the_registered_projector_not_only_the_id() {
    assert!(matches!(
        Win::new(Spoof {
            left: ReadOnly {
                value: "left".into()
            },
            right: ReadOnly {
                value: "right".into()
            }
        }),
        Err(Error::Binding(BindError::ComponentProjectionMismatch(_)))
    ));
}

struct BadMount {
    first: Counter,
    second: Counter,
}
impl BadMount {
    const BAD: Component<Self, Counter> =
        Component::new(FieldId::new(1), "bad", |m| &m.first, |m| &mut m.second);
}
impl View for BadMount {
    fn sources() -> Sources<Self> {
        Sources::new().component(Self::BAD)
    }
    fn view(&self) -> El<'_> {
        panic!("bad schema must fail before View")
    }
}
#[test]
fn registration_checks_exclusive_projection_before_describing_the_owner() {
    assert!(matches!(
        Win::new(BadMount {
            first: Counter::new("a"),
            second: Counter::new("b")
        }),
        Err(Error::Binding(BindError::ComponentProjectionMismatch(_)))
    ));
}

#[test]
fn visual_parentage_does_not_infer_model_ownership_or_exclusive_access() {
    let mut pair = Pair::new();
    pair.nested_visual = true;
    let win = Win::new(pair).unwrap();
    win.click(win.button("Right exact")).unwrap();
    win.type_text(win.input(), "left only").unwrap();
    assert_eq!(values(&win), (0, 1, 0, 0, "left only".into(), "".into()));
}

struct Panicking {
    child: Counter,
    bad: bool,
}
impl Panicking {
    const GOOD: Component<Self, Counter> =
        Component::new(FieldId::new(1), "child", |m| &m.child, |m| &mut m.child);
    const BAD: Component<Self, Counter> = Component::new(
        FieldId::new(1),
        "child",
        |m| &m.child,
        |_| panic!("application projector fault"),
    );
}
impl View for Panicking {
    fn sources() -> Sources<Self> {
        Sources::new().component(Self::GOOD)
    }
    fn view(&self) -> El<'_> {
        if self.bad {
            Self::BAD.view(self)
        } else {
            Self::GOOD.view(self)
        }
    }
}
#[test]
fn panicking_component_projectors_follow_the_owner_quarantine_boundary() {
    let win = Win::new(Panicking {
        child: Counter::new("Child"),
        bad: true,
    })
    .unwrap();
    assert_eq!(
        win.activate(win.button("Child exact")),
        Err(Error::OwnerPanicked)
    );
    let snapshot = win.snapshot().unwrap();
    assert_eq!(snapshot.source_epoch, 0);
    assert!(snapshot.poisoned);
    assert_eq!(win.with_model(|m| *m.child.count).unwrap(), 0);
    assert_eq!(win.update(|m| m.bad = false), Err(Error::Poisoned));
}
