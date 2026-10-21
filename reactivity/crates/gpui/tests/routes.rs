use gpui::{ActionKind, Error, WindowOptions, prelude::*};
use std::sync::{
    Arc,
    atomic::{AtomicUsize, Ordering},
};

struct Routes {
    count: usize,
    amount: usize,
    total: usize,
    input: Signal<String>,
}
impl Routes {
    const INPUT: Source<Self, String> =
        Source::new(FieldId::new(1), "input", |m| &m.input, |m| &mut m.input);
}
impl View for Routes {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::INPUT)
    }
    fn view(&self) -> El<'_> {
        let amount = self.amount;
        column((
            column((0..self.count).map(|index| {
                // Plain and actionable nodes deliberately share the same branch.
                if index % 2 == 0 {
                    button(format!("row {index}"))
                        .on_click(move |m: &mut Self| m.total += index + 1)
                } else {
                    text("plain")
                }
            })),
            text_input(&self.input),
            button("stable").on_click(move |m: &mut Self| m.total += amount),
        ))
    }
}

#[test]
fn current_routes_follow_replaced_captures_across_dense_sparse_and_empty_branches() {
    let mut win = Win::demo(Routes {
        count: 64,
        amount: 1,
        total: 0,
        input: Signal::new(String::new()),
    });
    let stable = win.button("stable");
    let input = win.input();
    let mut expected = 0;
    for (count, amount) in [(64, 2), (3, 5), (0, 11), (32, 17), (1, 23)] {
        win.update(|m| {
            m.count = count;
            m.amount = amount;
        })
        .unwrap();
        assert_eq!(win.button("stable"), stable);
        assert_eq!(win.input(), input);
        win.activate(stable).unwrap();
        expected += amount;
        if count > 0 {
            let index = (count - 1) & !1;
            win.activate(win.button(&format!("row {index}"))).unwrap();
            expected += index + 1;
        }
        assert_eq!(win.with_model(|m| m.total).unwrap(), expected);
        win.type_text(input, "a").unwrap();
    }
    assert_eq!(win.with_model(|m| m.input.to_string()).unwrap(), "aaaaa");
}

#[test]
fn an_old_sheet_cannot_restore_a_replaced_or_removed_current_callback() {
    struct Page {
        amount: usize,
        calls: usize,
        enabled: bool,
    }
    impl View for Page {
        fn view(&self) -> El<'_> {
            let amount = self.amount;
            let site = div().size(32).bg(if amount == 1 {
                Color::BLACK
            } else {
                Color::WHITE
            });
            if self.enabled {
                site.on_click(move |m: &mut Self| m.calls += amount)
            } else {
                site
            }
        }
    }
    let mut win = Win::recording(
        Page {
            amount: 1,
            calls: 0,
            enabled: true,
        },
        WindowOptions {
            size: [32, 32],
            ..Default::default()
        },
    )
    .unwrap();
    let original = win.with_scene(|_, token| token).unwrap();
    win.presented(original).unwrap();
    let target = win.snapshot().unwrap().nodes[0].target.unwrap();
    win.update(|m| m.amount = 7).unwrap();
    assert_eq!(win.snapshot().unwrap().presentation_epoch, 0);
    win.activate(target).unwrap();
    assert_eq!(win.with_model(|m| m.calls).unwrap(), 7);
    win.update(|m| m.enabled = false).unwrap();
    win.visit(|part| assert!(part.actions().contains(ActionKind::Activate)))
        .unwrap(); // Old P still describes what was shown.
    assert_eq!(win.activate(target), Err(Error::NotInteractive));
    assert_eq!(win.presented(original), Err(Error::StalePresentation));
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    win.visit(|part| assert!(!part.actions().contains(ActionKind::Activate)))
        .unwrap();
}

struct Retire {
    drops: Arc<AtomicUsize>,
    panic: bool,
}
impl Retire {
    fn retain(&self) {}
}
impl Drop for Retire {
    fn drop(&mut self) {
        self.drops.fetch_add(1, Ordering::SeqCst);
        assert!(!self.panic, "route destructor failed");
    }
}
struct Captures {
    count: usize,
    drops: Arc<AtomicUsize>,
    invalid: bool,
    panic: bool,
    unregistered: Signal<String>,
}
impl View for Captures {
    fn view(&self) -> El<'_> {
        column((
            column((0..self.count).map(|index| {
                let guard = Retire {
                    drops: self.drops.clone(),
                    panic: self.panic && index == 1,
                };
                button(format!("capture {index}")).on_click(move |_: &mut Self| guard.retain())
            })),
            self.invalid.then(|| text_input(&self.unregistered)),
        ))
    }
}
fn captures(drops: &Arc<AtomicUsize>, count: usize, panic: bool) -> Captures {
    Captures {
        count,
        drops: drops.clone(),
        invalid: false,
        panic,
        unregistered: Signal::new(String::new()),
    }
}

#[test]
fn rejected_description_drops_new_captures_and_retires_old_authority_before_recovery() {
    let drops = Arc::new(AtomicUsize::new(0));
    let mut win = Win::demo(captures(&drops, 3, false));
    let old = win.button("capture 2");
    assert!(matches!(
        win.update(|m| m.invalid = true),
        Err(Error::UnregisteredInput { .. })
    ));
    assert_eq!(drops.load(Ordering::SeqCst), 3); // Rejected new captures.
    assert_eq!(win.activate(old), Err(Error::StaleTarget));
    win.update(|m| {
        m.invalid = false;
        m.count = 1;
    })
    .unwrap();
    assert_eq!(drops.load(Ordering::SeqCst), 6); // Former current cohort.
    assert_eq!(win.activate(old), Err(Error::StaleTarget));
    win.activate(win.button("capture 0")).unwrap();
    assert_eq!(drops.load(Ordering::SeqCst), 7); // Action caused redescription.
    win.close();
    assert_eq!(drops.load(Ordering::SeqCst), 8);
}

#[test]
fn a_retired_routes_destructor_panic_quarantines_and_drops_every_capture_once() {
    let drops = Arc::new(AtomicUsize::new(0));
    let mut win = Win::demo(captures(&drops, 4, true));
    let target = win.button("capture 0");
    let mut old_nodes = win.snapshot().unwrap().nodes;
    for node in &mut old_nodes {
        node.target = None;
    }
    assert_eq!(win.update(|m| m.count = 0), Err(Error::OwnerPanicked));
    assert_eq!(drops.load(Ordering::SeqCst), 4);
    assert_eq!(win.activate(target), Err(Error::Poisoned));
    let snapshot = win.snapshot().unwrap();
    assert!(snapshot.poisoned);
    assert_eq!(snapshot.nodes, old_nodes);
    assert_eq!(win.inspect().unwrap().nodes, old_nodes);
    win.close();
    assert_eq!(drops.load(Ordering::SeqCst), 4);
}
