use gpui::{Error, prelude::*};
use std::{
    cell::RefCell,
    rc::{Rc, Weak},
};

struct Counter {
    count: Signal<u32>,
    plain: u32,
}
impl Counter {
    const COUNT: Source<Self, u32> =
        Source::new(FieldId::new(1), "count", |m| &m.count, |m| &mut m.count);
    fn coarse(&mut self) {
        self.plain += 1;
        *self.count += 1;
    }
}
impl View for Counter {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COUNT)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.count),
            text(&self.count),
            text(format!("plain {}", self.plain)),
            button("coarse").on_click(Self::coarse),
        ))
        .gap(4)
    }
}

#[test]
fn direct_fanout_reads_once_and_promotes_one_shared_text_payload() {
    let win = Win::with_size(
        Counter {
            count: Signal::new(1),
            plain: 0,
        },
        160,
        120,
    )
    .unwrap();
    win.reset_counters().unwrap();
    win.set(Counter::COUNT, 12).unwrap();
    let counters = win.counters();
    assert_eq!(counters.owner_reruns, 0);
    assert_eq!(counters.source_reads, 1);
    assert_eq!(counters.destination_compares, 2);
    assert_eq!(counters.text_promotions, 1);
    assert_eq!(counters.text_bytes_copied, 2);
    assert_eq!(
        win.snapshot()
            .unwrap()
            .nodes
            .iter()
            .filter(|n| n.text.as_deref() == Some("12"))
            .count(),
        2
    );
}

#[test]
fn arbitrary_methods_refresh_plain_fields_and_equal_revision_signal_replacement() {
    let win = Win::with_size(
        Counter {
            count: Signal::new(0),
            plain: 0,
        },
        160,
        120,
    )
    .unwrap();
    win.reset_counters().unwrap();
    win.click(win.button("coarse")).unwrap();
    assert_eq!(win.counters().owner_reruns, 1);
    assert!(
        win.snapshot()
            .unwrap()
            .nodes
            .iter()
            .any(|n| n.text.as_deref() == Some("plain 1"))
    );
    win.update(|m| m.count = Signal::new(99)).unwrap();
    assert_eq!(win.with_model(|m| m.count.revision().get()).unwrap(), 0);
    assert_eq!(
        win.snapshot()
            .unwrap()
            .nodes
            .iter()
            .filter(|n| n.text.as_deref() == Some("99"))
            .count(),
        2
    );
}

struct Nested {
    expanded: bool,
    presses: usize,
}
impl Nested {
    fn press(&mut self) {
        self.presses += 1;
    }
}
impl View for Nested {
    fn view(&self) -> El<'_> {
        column((
            column((text("a"), self.expanded.then(|| text("extra")))),
            button("stable").on_click(Self::press),
        ))
    }
}

#[test]
fn targets_survive_preorder_shifts_in_an_unrelated_sibling_subtree() {
    let win = Win::with_size(
        Nested {
            expanded: false,
            presses: 0,
        },
        180,
        100,
    )
    .unwrap();
    let stable = win.button("stable");
    let before = win
        .snapshot()
        .unwrap()
        .nodes
        .iter()
        .position(|n| n.text.as_deref() == Some("stable"))
        .unwrap();
    win.update(|m| m.expanded = true).unwrap();
    let after = win
        .snapshot()
        .unwrap()
        .nodes
        .iter()
        .position(|n| n.text.as_deref() == Some("stable"))
        .unwrap();
    assert_ne!(before, after);
    assert_eq!(win.button("stable"), stable);
    win.click(stable).unwrap();
    assert_eq!(win.with_model(|m| m.presses).unwrap(), 1);
}

struct Reentry {
    window: Rc<RefCell<Option<Weak<Win<Self>>>>>,
    rejected: bool,
}
impl Reentry {
    fn attempt(&mut self) {
        let win = self.window.borrow().as_ref().unwrap().upgrade().unwrap();
        self.rejected = win.update(|_| {}).unwrap_err() == Error::Borrowed;
    }
}
impl View for Reentry {
    fn view(&self) -> El<'_> {
        button("reenter").on_click(Self::attempt)
    }
}

#[test]
fn recursive_dispatch_is_rejected_without_reborrowing_the_owner() {
    let cell = Rc::new(RefCell::new(None));
    let win = Rc::new(
        Win::with_size(
            Reentry {
                window: cell.clone(),
                rejected: false,
            },
            120,
            40,
        )
        .unwrap(),
    );
    *cell.borrow_mut() = Some(Rc::downgrade(&win));
    win.activate(win.button("reenter")).unwrap();
    assert!(win.with_model(|m| m.rejected).unwrap());
}

struct PanicOwner {
    value: u32,
}
impl PanicOwner {
    fn fail(&mut self) {
        self.value = 7;
        panic!("application failure");
    }
}
impl View for PanicOwner {
    fn view(&self) -> El<'_> {
        button("panic").on_click(Self::fail)
    }
}

#[test]
fn handler_panics_poison_and_revoke_without_claiming_rollback() {
    let win = Win::with_size(PanicOwner { value: 0 }, 120, 40).unwrap();
    let target = win.button("panic");
    let old = win.scene_digest().unwrap();
    assert_eq!(win.activate(target), Err(Error::OwnerPanicked));
    assert_eq!(win.with_model(|m| m.value).unwrap(), 7);
    let snapshot = win.snapshot().unwrap();
    assert!(snapshot.poisoned);
    assert_eq!(snapshot.source_epoch, 0);
    assert_eq!(win.scene_digest().unwrap(), old);
    assert!(snapshot.nodes.iter().all(|n| n.target.is_none()));
    assert_eq!(win.activate(target), Err(Error::Poisoned));
}

struct Input {
    content: Signal<String>,
}
impl Input {
    const CONTENT: Source<Self, String> = Source::new(
        FieldId::new(1),
        "content",
        |m| &m.content,
        |m| &mut m.content,
    );
}
impl View for Input {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::CONTENT)
    }
    fn view(&self) -> El<'_> {
        column((text_input(&self.content).w(180), text(&self.content)))
    }
}

#[test]
fn input_edits_use_the_registered_string_source_and_share_the_fanout() {
    let win = Win::with_size(
        Input {
            content: Signal::new(String::new()),
        },
        200,
        80,
    )
    .unwrap();
    let input = win.input();
    win.reset_counters().unwrap();
    win.type_text(input, "café").unwrap();
    assert_eq!(win.with_model(|m| m.content.to_string()).unwrap(), "café");
    assert_eq!(win.counters().owner_reruns, 0);
    assert_eq!(win.counters().text_promotions, 1);
    win.backspace(input).unwrap();
    assert_eq!(win.with_model(|m| m.content.to_string()).unwrap(), "caf");
    assert_eq!(
        win.snapshot()
            .unwrap()
            .nodes
            .iter()
            .filter(|n| n.text.as_deref() == Some("caf"))
            .count(),
        2
    );
}

struct Transformed {
    presses: usize,
}
impl Transformed {
    fn press(&mut self) {
        self.presses += 1;
    }
}
impl View for Transformed {
    fn view(&self) -> El<'_> {
        div()
            .size(100)
            .transform(Affine::translation(40.0, 30.0))
            .child(
                button("x")
                    .w(40)
                    .h(25)
                    .bg(rgb(0x336699))
                    .transform(Affine::rotation(0.7))
                    .on_click(Self::press),
            )
    }
}

#[test]
fn rotated_button_hit_uses_the_exact_painted_matrix_not_its_aabb() {
    let win = Win::with_size(Transformed { presses: 0 }, 200, 160).unwrap();
    let snapshot = win.snapshot().unwrap();
    let node = snapshot
        .nodes
        .iter()
        .find(|n| n.text.as_deref() == Some("x"))
        .unwrap();
    let bounds = node.rect();
    assert_eq!(
        win.click_at(Point {
            x: bounds.x + 0.01,
            y: bounds.y + 0.01
        }),
        Err(Error::NotHittable)
    );
    win.click(win.button("x")).unwrap();
    assert_eq!(win.with_model(|m| m.presses).unwrap(), 1);
    assert!(
        win.with_pixels(|p, _, _| p
            .chunks_exact(4)
            .any(|px| px[0] != 255 || px[1] != 255 || px[2] != 255))
            .unwrap()
    );
}

#[test]
fn wide_ancestor_products_recover_before_admitting_a_visible_primitive() {
    struct Compensated;
    impl View for Compensated {
        fn view(&self) -> El<'_> {
            let mut el = div().size(8).bg(Color::rgb(255, 0, 0));
            for _ in 0..3 {
                el = div().size(8).transform(Affine::scale(1e20, 1e20)).child(el);
            }
            for _ in 0..3 {
                el = div()
                    .size(8)
                    .transform(Affine::scale(1e-20, 1e-20))
                    .child(el);
            }
            el
        }
    }
    let win = Win::with_size(Compensated, 8, 8).unwrap();
    win.with_pixels(|pixels, _, _| {
        assert!(
            pixels
                .chunks_exact(4)
                .all(|pixel| pixel == [255, 0, 0, 255])
        )
    })
    .unwrap();
}

struct Domain {
    enabled: bool,
    records: Vec<u8>,
}
struct DomainOwner {
    domain: Signal<Domain>,
}
impl DomainOwner {
    const DOMAIN: Source<Self, Domain> =
        Source::new(FieldId::new(1), "domain", |m| &m.domain, |m| &mut m.domain);
}
impl View for DomainOwner {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::DOMAIN)
    }
    fn view(&self) -> El<'_> {
        column((
            if self.domain.enabled {
                text("enabled")
            } else {
                text("disabled")
            },
            button("domain").on_click(Self::DOMAIN.update(|domain| {
                domain.enabled = true;
                domain.records.push(9);
            })),
        ))
    }
}

#[test]
fn a_non_text_non_clone_domain_action_uses_the_production_dispatcher() {
    let win = Win::with_size(
        DomainOwner {
            domain: Signal::new(Domain {
                enabled: false,
                records: vec![],
            }),
        },
        160,
        80,
    )
    .unwrap();
    win.activate(win.button("domain")).unwrap();
    assert!(
        win.snapshot()
            .unwrap()
            .nodes
            .iter()
            .any(|n| n.text.as_deref() == Some("enabled"))
    );
    assert_eq!(win.with_model(|m| m.domain.records.clone()).unwrap(), [9]);
}

struct BadScene {
    broken: bool,
}
impl BadScene {
    fn break_scene(&mut self) {
        self.broken = true;
    }
    fn recover(&mut self) {
        self.broken = false;
    }
}
impl View for BadScene {
    fn view(&self) -> El<'_> {
        column((
            text("unchanged"),
            button("recover")
                .on_click(Self::recover)
                .transform(if self.broken {
                    Affine::scale(0.0, 1.0)
                } else {
                    Affine::IDENTITY
                }),
            button("break").on_click(Self::break_scene),
        ))
    }
}

#[test]
fn a_rejected_partial_scene_keeps_the_same_output_buffer_and_complete_sheet() {
    let win = Win::with_size(BadScene { broken: false }, 180, 120).unwrap();
    let recover = win.button("recover");
    let old = win.scene_digest().unwrap();
    let pointer = win.with_pixels(|p, _, _| p.as_ptr() as usize).unwrap();
    assert!(win.activate(win.button("break")).is_err());
    assert_eq!(win.scene_digest().unwrap(), old);
    assert_eq!(
        win.with_pixels(|p, _, _| p.as_ptr() as usize).unwrap(),
        pointer
    );
    let snapshot = win.snapshot().unwrap();
    assert_eq!((snapshot.source_epoch, snapshot.presentation_epoch), (1, 0));
    win.activate(recover).unwrap();
    assert_eq!(win.scene_digest().unwrap(), old);
    assert_eq!(
        win.with_pixels(|p, _, _| p.as_ptr() as usize).unwrap(),
        pointer
    );
}

#[test]
fn a_transparent_sites_handler_presence_publishes_new_hit_eligibility() {
    struct OptionalRoute {
        enabled: bool,
        presses: usize,
    }
    impl OptionalRoute {
        fn press(&mut self) {
            self.presses += 1;
        }
    }
    impl View for OptionalRoute {
        fn view(&self) -> El<'_> {
            let site = div().size(40);
            if self.enabled {
                site.on_click(Self::press)
            } else {
                site
            }
        }
    }
    let win = Win::with_size(
        OptionalRoute {
            enabled: false,
            presses: 0,
        },
        40,
        40,
    )
    .unwrap();
    let pixels = win.scene_digest().unwrap();
    assert!(win.snapshot().unwrap().nodes[0].target.is_none());
    win.reset_counters().unwrap();
    win.update(|m| m.enabled = true).unwrap();
    let target = win.snapshot().unwrap().nodes[0].target.unwrap();
    win.click(target).unwrap();
    assert_eq!(win.with_model(|m| m.presses).unwrap(), 1);
    assert_eq!(win.counters().layout_runs, 0);
    assert_eq!(win.scene_digest().unwrap(), pixels);
    win.update(|m| m.enabled = false).unwrap();
    assert!(win.snapshot().unwrap().nodes[0].target.is_none());
    assert_eq!(win.click(target), Err(Error::NotHittable));
    assert_eq!(win.activate(target), Err(Error::NotInteractive));
    assert_eq!(win.scene_digest().unwrap(), pixels);
}

#[test]
fn a_bad_action_writer_is_a_checked_error_without_mutation_or_owner_poisoning() {
    struct Owner {
        first: Signal<u32>,
        second: Signal<u32>,
    }
    impl Owner {
        const FIRST: Source<Self, u32> =
            Source::new(FieldId::new(1), "first", |m| &m.first, |m| &mut m.first);
        // The read identity matches the registry; the exclusive projection does
        // not. Its callback must never run or even acquire a mutable value.
        const BAD: Source<Self, u32> =
            Source::new(FieldId::new(1), "bad", |m| &m.first, |m| &mut m.second);
    }
    impl View for Owner {
        fn sources() -> Sources<Self> {
            Sources::new().field(Self::FIRST)
        }
        fn view(&self) -> El<'_> {
            column((
                text(&self.first),
                button("bad")
                    .on_click(Self::BAD.update(|_| panic!("bad writer reached user callback"))),
                button("good").on_click(Self::FIRST.update(|value| *value += 1)),
            ))
        }
    }
    let win = Win::with_size(
        Owner {
            first: Signal::new(1),
            second: Signal::new(7),
        },
        160,
        120,
    )
    .unwrap();
    let old = win.scene_digest().unwrap();
    win.reset_counters().unwrap();
    assert_eq!(
        win.activate(win.button("bad")),
        Err(Error::Binding(gpui::BindError::ProjectionMismatch(
            Owner::FIRST.id()
        )))
    );
    assert_eq!(
        win.with_model(|m| (
            *m.first,
            *m.second,
            m.first.revision().get(),
            m.second.revision().get()
        ))
        .unwrap(),
        (1, 7, 0, 0)
    );
    let snapshot = win.snapshot().unwrap();
    assert!(!snapshot.poisoned);
    assert_eq!((snapshot.source_epoch, snapshot.presentation_epoch), (0, 0));
    assert_eq!(win.counters().source_operations, 0);
    assert_eq!(win.scene_digest().unwrap(), old);
    let commit = win.activate(win.button("good")).unwrap();
    assert_eq!((commit.source_epoch, commit.presentation_epoch), (1, 1));
    assert_eq!(win.with_model(|m| (*m.first, *m.second)).unwrap(), (2, 7));
}
