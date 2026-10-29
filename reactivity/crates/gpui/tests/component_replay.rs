#![cfg(feature = "component-replay-lab")]
//! Public non-test-library qualification; no timing campaign.
use gpui::{
    local_component::{LocalComponent, Mode, RootRecipe, WidthInput},
    prelude::*,
};
use serde_json::{Value, json};
use std::sync::atomic::{AtomicUsize, Ordering};

static PARENTS: AtomicUsize = AtomicUsize::new(0);
static CHILDREN: AtomicUsize = AtomicUsize::new(0);
struct Child {
    grow: Signal<bool>,
    handler: Signal<bool>,
}
impl Child {
    const GROW: Source<Self, bool> =
        Source::new(FieldId::new(1), "grow", |m| &m.grow, |m| &mut m.grow);
    const HANDLER: Source<Self, bool> = Source::new(
        FieldId::new(2),
        "handler",
        |m| &m.handler,
        |m| &mut m.handler,
    );
}
impl View for Child {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::GROW).field(Self::HANDLER)
    }
    fn view(&self) -> El<'_> {
        CHILDREN.fetch_add(1, Ordering::SeqCst);
        let root = column((
            div().size(8).bg(Color::BLACK),
            (*self.grow).then(|| div().size(8).bg(Color::BLACK)),
        ))
        .w(if *self.grow { 40 } else { 24 })
        .h(24)
        .bg(Color::rgb(255, 0, 0));
        if *self.handler {
            root.on_click(|_: &mut Self| {})
        } else {
            root
        }
    }
}
#[derive(Clone, Copy, Debug)]
enum Appearance {
    Plain,
    Repeated,
    LegacyExtra,
    Nested,
    WrongDescriptor,
    OutsideBinding,
}
trait Fixture: View + Sized + 'static {
    fn new(tail: usize, appearance: Appearance) -> Self;
    fn child() -> Component<Self, Child>;
    fn cap() -> Source<Self, Option<f64>>;
    fn copy_for_oracle(&self) -> Self;
}
macro_rules! fixture {
    ($name:ident, $local:ident, $wrong:ident, $recipe:expr) => {
        struct $name {
            child: Child,
            cap: Signal<Option<f64>>,
            outside: Signal<f64>,
            tail: usize,
            appearance: Appearance,
        }
        impl $name {
            const CHILD: Component<Self, Child> =
                Component::new(FieldId::new(1), "child", |m| &m.child, |m| &mut m.child);
            const CAP: Source<Self, Option<f64>> =
                Source::new(FieldId::new(2), "cap", |m| &m.cap, |m| &mut m.cap);
            const OUTSIDE: Source<Self, f64> = Source::new(
                FieldId::new(3),
                "outside",
                |m| &m.outside,
                |m| &mut m.outside,
            );
        }
        static $local: LocalComponent<$name, Child> =
            LocalComponent::new($name::CHILD, RootRecipe::width($recipe));
        static $wrong: LocalComponent<$name, Child> =
            LocalComponent::new($name::CHILD, RootRecipe::width(WidthInput::Literal(17.0)));
        impl Fixture for $name {
            fn new(tail: usize, appearance: Appearance) -> Self {
                Self {
                    child: Child {
                        grow: Signal::new(false),
                        handler: Signal::new(false),
                    },
                    cap: Signal::new(None),
                    outside: Signal::new(2.0),
                    tail,
                    appearance,
                }
            }
            fn child() -> Component<Self, Child> {
                Self::CHILD
            }
            fn cap() -> Source<Self, Option<f64>> {
                Self::CAP
            }
            fn copy_for_oracle(&self) -> Self {
                Self {
                    child: Child {
                        grow: Signal::new(*self.child.grow),
                        handler: Signal::new(*self.child.handler),
                    },
                    cap: Signal::new(*self.cap),
                    outside: Signal::new(*self.outside),
                    tail: self.tail,
                    appearance: self.appearance,
                }
            }
        }
        impl View for $name {
            fn sources() -> Sources<Self> {
                Sources::new()
                    .field(Self::CAP)
                    .direct(Self::OUTSIDE)
                    .local_component(&$local)
            }
            fn view(&self) -> El<'_> {
                PARENTS.fetch_add(1, Ordering::SeqCst);
                let root = match self.appearance {
                    Appearance::Nested => row(()).child(div().child_local(&$local, self)),
                    Appearance::WrongDescriptor => row(()).child_local(&$wrong, self),
                    _ => row(()).child_local(&$local, self),
                };
                let root = match self.appearance {
                    Appearance::Repeated => root.child_local(&$local, self),
                    Appearance::LegacyExtra => root.child(Self::CHILD.view(self)),
                    Appearance::OutsideBinding => root.child(div().w(&self.outside).h(4)),
                    _ => root,
                };
                root.child(div().w(8).h(24).bg(Color::rgb(0, 0, 255)))
                    .child((0..self.tail).map(|_| column((div().size(1),)).size(1)))
                    .size(64)
                    .bg(Color::WHITE)
            }
        }
    };
}
fixture!(Absent, ABSENT, ABSENT_WRONG, WidthInput::Absent);
fixture!(Literal, LITERAL, LITERAL_WRONG, WidthInput::Literal(24.0));
fixture!(
    Optional,
    OPTIONAL,
    OPTIONAL_WRONG,
    WidthInput::Optional(Optional::CAP)
);

fn window<M: Fixture>(tail: usize, appearance: Appearance, mode: Mode) -> Win<M> {
    let mut win = Win::recording(
        M::new(tail, appearance),
        gpui::WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    if mode != Mode::Replay {
        win.set_local_replay_mode(mode).unwrap();
    }
    ack(&mut win);
    win
}
fn ack<M: View + 'static>(win: &mut Win<M>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn calls() -> [usize; 2] {
    [
        PARENTS.load(Ordering::SeqCst),
        CHILDREN.load(Ordering::SeqCst),
    ]
}
fn reset() {
    PARENTS.store(0, Ordering::SeqCst);
    CHILDREN.store(0, Ordering::SeqCst);
}
fn pixels<M: View + 'static>(win: &mut Win<M>) -> Vec<u8> {
    win.with_pixels(|p, _, _| p.to_vec()).unwrap()
}
fn nodes<M: View + 'static>(win: &Win<M>, identities: bool) -> Value {
    let mut snapshot = win.inspect().unwrap();
    for node in &mut snapshot.nodes {
        node.target = None;
        if !identities {
            node.identity = 0;
        }
    }
    serde_json::to_value(snapshot.nodes).unwrap()
}
fn compare<M: Fixture>(a: &mut Win<M>, b: &mut Win<M>) {
    assert_eq!(pixels(a), pixels(b));
    ack(a);
    ack(b);
    assert_eq!(
        nodes(a, true),
        nodes(b, true),
        "same-cohort semantic identity/layout oracle"
    );
    let mut fresh = Win::recording(
        a.with_model(Fixture::copy_for_oracle).unwrap(),
        gpui::WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    assert_eq!(pixels(a), pixels(&mut fresh), "fresh full producer/pixels");
    ack(&mut fresh);
    assert_eq!(nodes(a, false), nodes(&fresh, false), "fresh full layout");
}
fn allocation(info: allocation_counter::AllocationInfo) -> Value {
    json!({"bytes_total":info.bytes_total,"bytes_max":info.bytes_max,"bytes_current":info.bytes_current,"count_total":info.count_total})
}
fn grow<M: Fixture>(
    name: &str,
    a: &mut Win<M>,
    b: &mut Win<M>,
    value: bool,
    admitted: bool,
    rows: &mut Vec<Value>,
) {
    let before = nodes(a, true);
    reset();
    a.reset_counters().unwrap();
    let aa = allocation_counter::measure(|| {
        a.set(M::child().source(&Child::GROW), value).unwrap();
    });
    let ac = calls();
    let ar = a.local_replay_report().unwrap();
    reset();
    b.reset_counters().unwrap();
    let ba = allocation_counter::measure(|| {
        b.set(M::child().source(&Child::GROW), value).unwrap();
    });
    let bc = calls();
    let br = b.local_replay_report().unwrap();
    assert_eq!(ar.admitted, admitted, "{name}: {ar:?}");
    if admitted {
        assert_eq!(ac, [0, 1]);
        assert_eq!(bc, [1, 1]);
        let origin = ar.origin.as_ref().unwrap();
        assert_eq!(origin.old_range[0], origin.new_range[0]);
        assert_eq!(origin.correspondence[0].1, Some(origin.old_range[0]));
        assert_eq!(origin.correspondence[0].2, origin.root_identity);
    } else {
        assert!(ac[0] >= 1);
    }
    compare(a, b);
    rows.push(json!({"case":name,"grow":value,"calls_replay":ac,"calls_full":bc,"replay":ar,"full":br,
        "allocation_replay":allocation(aa),"allocation_full":allocation(ba),"before":before,"after":nodes(a,true),"replay_counters":a.counters(),"full_counters":b.counters()}));
}
fn sequence<M: Fixture>(label: &str, tail: usize, rows: &mut Vec<Value>) {
    let mut a = window::<M>(tail, Appearance::Plain, Mode::Replay);
    let mut b = window::<M>(tail, Appearance::Plain, Mode::FullRoot);
    for (step, value) in [true, false, true, true].into_iter().enumerate() {
        grow(
            &format!("{label}-{tail}-{step}"),
            &mut a,
            &mut b,
            value,
            true,
            rows,
        );
    }
}

#[test]
#[ignore = "explicit local replay qualification"]
fn public_local_component_replay_qualification() {
    let out = std::path::PathBuf::from(std::env::var("GPUI_COMPONENT_REPLAY_OUTPUT").unwrap());
    std::fs::create_dir(&out).unwrap();
    let mut rows = Vec::new();
    sequence::<Absent>("absent", 0, &mut rows);
    sequence::<Absent>("absent", 128, &mut rows);
    sequence::<Literal>("literal", 0, &mut rows);
    sequence::<Literal>("literal", 128, &mut rows);
    let mut a = window::<Optional>(0, Appearance::Plain, Mode::Replay);
    let mut b = window::<Optional>(0, Appearance::Plain, Mode::FullRoot);
    grow("optional-none", &mut a, &mut b, true, true, &mut rows);
    for (label, value) in [("some16", Some(16.0)), ("none-again", None)] {
        reset();
        a.set(Optional::cap(), value).unwrap();
        let calls = calls();
        b.set(Optional::cap(), value).unwrap();
        assert_eq!(calls, [1, 1]);
        compare(&mut a, &mut b);
        rows.push(json!({"case":label,"calls_replay":calls,"replay":a.local_replay_report().unwrap(),"after":nodes(&a,true)}));
        grow(label, &mut a, &mut b, false, true, &mut rows);
        grow(label, &mut a, &mut b, true, true, &mut rows);
    }
    for appearance in [
        Appearance::Repeated,
        Appearance::LegacyExtra,
        Appearance::Nested,
        Appearance::WrongDescriptor,
        Appearance::OutsideBinding,
    ] {
        let mut a = window::<Absent>(0, appearance, Mode::Replay);
        let mut b = window::<Absent>(0, appearance, Mode::FullRoot);
        grow(
            &format!("fallback-{appearance:?}"),
            &mut a,
            &mut b,
            true,
            false,
            &mut rows,
        );
    }
    let mut a = window::<Absent>(0, Appearance::Plain, Mode::Replay);
    let mut b = window::<Absent>(0, Appearance::Plain, Mode::FullRoot);
    reset();
    a.set(Absent::child().source(&Child::HANDLER), true)
        .unwrap();
    let ac = calls();
    b.set(Absent::child().source(&Child::HANDLER), true)
        .unwrap();
    assert!(!a.local_replay_report().unwrap().admitted);
    assert_eq!(ac, [1, 2]);
    compare(&mut a, &mut b);
    rows.push(json!({"case":"new-handler-fallback","calls_replay":ac,"report":a.local_replay_report().unwrap()}));
    let mut a = window::<Absent>(0, Appearance::Plain, Mode::Replay);
    let mut b = window::<Absent>(0, Appearance::Plain, Mode::FullRoot);
    a.revoke_local_replay().unwrap();
    grow(
        "explicit-revocation",
        &mut a,
        &mut b,
        true,
        false,
        &mut rows,
    );
    grow(
        "after-revocation-full-recovery",
        &mut a,
        &mut b,
        false,
        true,
        &mut rows,
    );
    let mut a = window::<Optional>(0, Appearance::Plain, Mode::Replay);
    let mut b = window::<Optional>(0, Appearance::Plain, Mode::FullRoot);
    // Submit-worthy candidate remains coherent when a newer logical edit fails.
    a.set(Optional::child().source(&Child::GROW), true).unwrap();
    b.set(Optional::child().source(&Child::GROW), true).unwrap();
    let at = a.with_scene(|_, token| token).unwrap();
    let bt = b.with_scene(|_, token| token).unwrap();
    let prior = pixels(&mut a);
    let ae = a.set(Optional::cap(), Some(f64::NAN)).unwrap_err();
    let be = b.set(Optional::cap(), Some(f64::NAN)).unwrap_err();
    assert!(matches!(ae, gpui::SetError::Committed { .. }));
    assert!(matches!(be, gpui::SetError::Committed { .. }));
    assert!(!a.local_replay_report().unwrap().certificate_live);
    assert_eq!(pixels(&mut a), prior);
    assert_eq!(pixels(&mut b), prior);
    a.presented(at).unwrap();
    b.presented(bt).unwrap();
    assert!(
        !a.local_replay_report().unwrap().certificate_live,
        "old ack cannot revive local authority"
    );
    a.set(Optional::cap(), None).unwrap();
    b.set(Optional::cap(), None).unwrap();
    compare(&mut a, &mut b);
    rows.push(json!({"case":"failed-newer-old-ack-recovery","error_replay":format!("{ae:?}"),"error_full":format!("{be:?}"),"report":a.local_replay_report().unwrap(),"after":nodes(&a,true)}));
    grow(
        "post-failure-recovered",
        &mut a,
        &mut b,
        false,
        true,
        &mut rows,
    );
    let mut a = window::<Literal>(0, Appearance::Plain, Mode::Replay);
    let mut b = window::<Literal>(0, Appearance::Plain, Mode::FullRoot);
    let old_root = a.inspect().unwrap().nodes[1].identity;
    a.update(|m| m.tail += 1).unwrap();
    b.update(|m| m.tail += 1).unwrap();
    compare(&mut a, &mut b);
    assert_ne!(
        a.inspect().unwrap().nodes[1].identity,
        old_root,
        "parent child-count change remints the unkeyed region root"
    );
    grow(
        "owner-remint-new-certificate",
        &mut a,
        &mut b,
        true,
        true,
        &mut rows,
    );
    a.update(|m| m.appearance = Appearance::WrongDescriptor)
        .unwrap();
    b.update(|m| m.appearance = Appearance::WrongDescriptor)
        .unwrap();
    compare(&mut a, &mut b);
    assert!(!a.local_replay_report().unwrap().certificate_live);
    grow(
        "replacement-descriptor-fallback",
        &mut a,
        &mut b,
        false,
        false,
        &mut rows,
    );
    nested_boundary_case(&mut rows);
    let mut mutant = window::<Literal>(0, Appearance::Plain, Mode::OmitCallerMutant);
    let mut full = window::<Literal>(0, Appearance::Plain, Mode::FullRoot);
    mutant
        .set(Literal::child().source(&Child::GROW), true)
        .unwrap();
    full.set(Literal::child().source(&Child::GROW), true)
        .unwrap();
    let actual = pixels(&mut full);
    let wrong = pixels(&mut mutant);
    let mismatch = actual.iter().zip(&wrong).filter(|(a, b)| a != b).count();
    assert!(mismatch > 0);
    std::fs::write(out.join("mutant.rgba"), wrong).unwrap();
    std::fs::write(out.join("full.rgba"), actual).unwrap();
    rows.push(json!({"case":"omitted-caller-mutant","wrong_pixel_bytes":mismatch,"report":mutant.local_replay_report().unwrap()}));
    std::fs::write(
        out.join("trace.json"),
        serde_json::to_vec_pretty(&rows).unwrap(),
    )
    .unwrap();
}

struct Outer {
    child: Child,
}
impl Outer {
    const INNER: Component<Self, Child> =
        Component::new(FieldId::new(1), "inner", |m| &m.child, |m| &mut m.child);
}
impl View for Outer {
    fn sources() -> Sources<Self> {
        Sources::new().direct_component(Self::INNER)
    }
    fn view(&self) -> El<'_> {
        Self::INNER.view(self)
    }
}
struct NestedOwner {
    outer: Outer,
}
impl NestedOwner {
    const OUTER: Component<Self, Outer> =
        Component::new(FieldId::new(1), "outer", |m| &m.outer, |m| &mut m.outer);
}
static NESTED: LocalComponent<NestedOwner, Outer> =
    LocalComponent::new(NestedOwner::OUTER, RootRecipe::width(WidthInput::Absent));
impl View for NestedOwner {
    fn sources() -> Sources<Self> {
        Sources::new().local_component(&NESTED)
    }
    fn view(&self) -> El<'_> {
        PARENTS.fetch_add(1, Ordering::SeqCst);
        row(()).child_local(&NESTED, self).size(64)
    }
}
fn nested_boundary_case(rows: &mut Vec<Value>) {
    let make = || {
        Win::recording(
            NestedOwner {
                outer: Outer {
                    child: Child {
                        grow: Signal::new(false),
                        handler: Signal::new(false),
                    },
                },
            },
            gpui::WindowOptions {
                size: [64, 64],
                ..Default::default()
            },
        )
        .unwrap()
    };
    let mut a = make();
    let mut b = make();
    b.set_local_replay_mode(Mode::FullRoot).unwrap();
    assert!(!a.local_replay_report().unwrap().certificate_live);
    let inner = Outer::INNER.source(&Child::GROW);
    reset();
    a.set(NestedOwner::OUTER.source(&inner), true).unwrap();
    let visits = calls();
    b.set(NestedOwner::OUTER.source(&inner), true).unwrap();
    assert_eq!(visits, [1, 1]);
    assert!(!a.local_replay_report().unwrap().admitted);
    assert_eq!(pixels(&mut a), pixels(&mut b));
    ack(&mut a);
    ack(&mut b);
    assert_eq!(nodes(&a, true), nodes(&b, true));
    rows.push(json!({"case":"nested-component-boundary-fallback","calls_replay":visits,"report":a.local_replay_report().unwrap()}));
}
