//! Public contract witnesses; no local replay engine or performance experiment.
use gpui::prelude::*;
use serde_json::json;
use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};
static EXTERNAL_DECORATION: AtomicBool = AtomicBool::new(false);
static CHILD_VIEWS: AtomicUsize = AtomicUsize::new(0);
static PARENT_VIEWS: AtomicUsize = AtomicUsize::new(0);
struct Child {
    grow: Signal<bool>,
}
impl Child {
    const GROW: Source<Self, bool> =
        Source::new(FieldId::new(1), "grow", |m| &m.grow, |m| &mut m.grow);
}
impl View for Child {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::GROW)
    }
    fn view(&self) -> El<'_> {
        CHILD_VIEWS.fetch_add(1, Ordering::SeqCst);
        column((
            div().w(8).h(8).bg(Color::BLACK),
            (*self.grow).then(|| div().w(8).h(8).bg(Color::BLACK)),
        ))
        .w(if *self.grow { 40 } else { 24 })
        .h(24)
        .bg(Color::rgb(255, 0, 0))
    }
}
#[derive(Clone, Copy, Debug)]
enum Caller {
    EqualWidth,
    External,
    Omitted,
    Repeated,
}
struct Parent {
    child: Child,
    caller: Caller,
}
impl Parent {
    const CHILD: Component<Self, Child> =
        Component::new(FieldId::new(1), "child", |m| &m.child, |m| &mut m.child);
    fn new(caller: Caller) -> Self {
        Self {
            child: Child {
                grow: Signal::new(false),
            },
            caller,
        }
    }
}
impl View for Parent {
    fn sources() -> Sources<Self> {
        Sources::new().direct_component(Self::CHILD)
    }
    fn view(&self) -> El<'_> {
        PARENT_VIEWS.fetch_add(1, Ordering::SeqCst);
        let child = Self::CHILD.view(self);
        let child = match self.caller {
            Caller::EqualWidth => child.w(24),
            Caller::External if EXTERNAL_DECORATION.load(Ordering::SeqCst) => child.w(16),
            _ => child,
        };
        let repeated = matches!(self.caller, Caller::Repeated).then(|| Self::CHILD.view(self));
        row((child, repeated, div().w(8).h(24).bg(Color::rgb(0, 0, 255))))
            .size(64)
            .bg(Color::WHITE)
    }
}
fn pixels(w: &mut Win<Parent>) -> Vec<u8> {
    w.with_pixels(|p, _, _| p.to_vec()).unwrap()
}
#[test]
#[ignore = "explicit public component contract trace"]
fn public_component_recipe_counterexamples() {
    let out = std::path::PathBuf::from(std::env::var("GPUI_COMPONENT_CONTRACT_OUTPUT").unwrap());
    std::fs::create_dir(&out).unwrap();
    let mut cases = Vec::new();
    for (label, caller, external) in [
        ("equal-setter", Caller::EqualWidth, false),
        ("future-decoration", Caller::External, true),
    ] {
        EXTERNAL_DECORATION.store(false, Ordering::SeqCst);
        let mut full = Win::with_size(Parent::new(caller), 64, 64).unwrap();
        let mut omitted = Win::with_size(Parent::new(Caller::Omitted), 64, 64).unwrap();
        let initial = pixels(&mut full);
        assert_eq!(
            initial,
            pixels(&mut omitted),
            "insufficient certificate sees identical initial pixels"
        );
        let before = full.inspect().unwrap();
        EXTERNAL_DECORATION.store(external, Ordering::SeqCst);
        full.reset_counters().unwrap();
        PARENT_VIEWS.store(0, Ordering::SeqCst);
        CHILD_VIEWS.store(0, Ordering::SeqCst);
        full.set(Parent::CHILD.source(&Child::GROW), true).unwrap();
        let visits = [
            PARENT_VIEWS.load(Ordering::SeqCst),
            CHILD_VIEWS.load(Ordering::SeqCst),
        ];
        assert_eq!(visits, [1, 1]);
        assert_eq!(full.counters().owner_reruns, 1);
        omitted
            .set(Parent::CHILD.source(&Child::GROW), true)
            .unwrap();
        let actual = pixels(&mut full);
        let mutant = pixels(&mut omitted);
        let wrong = actual.iter().zip(&mutant).filter(|(a, b)| a != b).count();
        assert!(wrong > 0);
        let after = full.inspect().unwrap();
        let omitted_snapshot = omitted.inspect().unwrap();
        assert_eq!(
            before.nodes[1].identity, after.nodes[1].identity,
            "surviving component root does not certify caller recipe"
        );
        assert_ne!(
            after.nodes.last().unwrap().bounds,
            omitted_snapshot.nodes.last().unwrap().bounds,
            "following sibling layout depends on caller width"
        );
        for (name, data) in [
            ("initial", initial),
            ("full", actual),
            ("omitted-caller-model", mutant),
        ] {
            std::fs::write(out.join(format!("{label}-{name}.rgba")), data).unwrap();
        }
        cases.push(json!({"case":label,"wrong_pixel_bytes":wrong,"parent_child_view_calls":visits,"before":before,"after":after,"omitted_caller":omitted_snapshot,"counters":full.counters(),"scope":"full public root update versus counterfactual model omitting caller contribution, not an optimized runtime"}));
    }
    EXTERNAL_DECORATION.store(false, Ordering::SeqCst);
    let mut full = Win::with_size(Parent::new(Caller::Repeated), 64, 64).unwrap();
    let before = full.inspect().unwrap();
    let roots: Vec<_> = before
        .nodes
        .iter()
        .filter(|n| n.parent == Some(0))
        .map(|n| n.identity)
        .collect();
    assert_eq!(roots.len(), 3);
    assert_ne!(roots[0], roots[1]);
    PARENT_VIEWS.store(0, Ordering::SeqCst);
    CHILD_VIEWS.store(0, Ordering::SeqCst);
    full.reset_counters().unwrap();
    full.set(Parent::CHILD.source(&Child::GROW), true).unwrap();
    let visits = [
        PARENT_VIEWS.load(Ordering::SeqCst),
        CHILD_VIEWS.load(Ordering::SeqCst),
    ];
    assert_eq!(visits, [1, 2]);
    cases.push(json!({"case":"repeated-occurrence","parent_child_view_calls":visits,"before":before,"after":full.inspect().unwrap(),"counters":full.counters(),"scope":"one registered child source describes two distinct semantic occurrences"}));
    std::fs::write(
        out.join("trace.json"),
        serde_json::to_vec_pretty(&cases).unwrap(),
    )
    .unwrap();
}
