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
    assert_eq!(win.update(|m| m.panic = false), Err(Error::OwnerPanicked));
    assert_eq!(drops.load(Ordering::SeqCst), 8); // Old and rejected new captures.
    assert_eq!(win.activate(target), Err(Error::Poisoned));
    let snapshot = win.snapshot().unwrap();
    assert!(snapshot.poisoned);
    assert_eq!(snapshot.nodes, old_nodes);
    assert_eq!(win.inspect().unwrap().nodes, old_nodes);
    win.close();
    assert_eq!(drops.load(Ordering::SeqCst), 8);
}

// Every visual site keeps its kind and ordinal while handler density changes.
// No child text rows dilute the all-route control.
struct ColumnPage {
    count: usize,
    routes: usize,
    generation: usize,
    called: Option<(usize, usize)>,
    events: Arc<std::sync::Mutex<Vec<(usize, usize)>>>,
}
struct ColumnCapture {
    generation: usize,
    node: usize,
    events: Arc<std::sync::Mutex<Vec<(usize, usize)>>>,
}
impl ColumnCapture {
    fn call(&self, page: &mut ColumnPage) {
        page.called = Some((self.generation, self.node));
    }
}
impl Drop for ColumnCapture {
    fn drop(&mut self) {
        self.events
            .lock()
            .unwrap()
            .push((self.generation, self.node));
    }
}
impl ColumnPage {
    fn route<'a>(&self, node: usize, element: El<'a>) -> El<'a> {
        if node >= self.routes {
            return element;
        }
        let capture = ColumnCapture {
            generation: self.generation,
            node,
            events: self.events.clone(),
        };
        element.on_click(move |page: &mut Self| capture.call(page))
    }
}
impl View for ColumnPage {
    fn view(&self) -> El<'_> {
        self.route(
            0,
            column((1..self.count).map(|node| self.route(node, div().size(8)))),
        )
    }
}

#[test]
fn retained_routes_cross_all_sparse_dense_and_absent_modes_with_exact_retirement_order() {
    let events = Arc::new(std::sync::Mutex::new(Vec::new()));
    let mut win = Win::demo(ColumnPage {
        count: 9,
        routes: 9,
        generation: 0,
        called: None,
        events: events.clone(),
    });
    let targets = win
        .snapshot()
        .unwrap()
        .nodes
        .into_iter()
        .map(|node| node.target.unwrap())
        .collect::<Vec<_>>();
    for (generation, old_routes, routes) in [(1, 9, 2), (2, 2, 0), (3, 0, 9), (4, 9, 6), (5, 6, 7)]
    {
        events.lock().unwrap().clear();
        win.update(|page| {
            page.generation = generation;
            page.routes = routes;
        })
        .unwrap();
        assert_eq!(
            *events.lock().unwrap(),
            (0..old_routes)
                .map(|node| (generation - 1, node))
                .collect::<Vec<_>>()
        );
        let snapshot = win.snapshot().unwrap();
        for (node, target) in targets.iter().copied().enumerate() {
            if node < routes {
                assert_eq!(snapshot.nodes[node].target, Some(target));
            } else {
                assert_eq!(snapshot.nodes[node].target, None);
                assert_eq!(win.activate(target), Err(Error::NotInteractive));
            }
        }
    }
    events.lock().unwrap().clear();
    win.activate(targets[6]).unwrap();
    assert_eq!(win.root().unwrap().called, Some((5, 6)));
    assert_eq!(
        *events.lock().unwrap(),
        (0..7).map(|node| (5, node)).collect::<Vec<_>>()
    );
    events.lock().unwrap().clear();
    win.close();
    assert_eq!(
        *events.lock().unwrap(),
        (0..7).map(|node| (5, node)).collect::<Vec<_>>()
    );
}

#[test]
fn keyed_route_retirement_tracks_consumption_order_and_then_old_row_order() {
    const LIST: ListId = ListId::new(710);
    struct Page {
        keys: Vec<u64>,
        generation: usize,
        selected: Option<u64>,
        events: Arc<std::sync::Mutex<Vec<(usize, usize)>>>,
    }
    impl ItemSource for Page {
        fn len(&self) -> usize {
            self.keys.len()
        }
        fn key(&self, index: usize) -> ItemKey {
            ItemKey::new(self.keys[index])
        }
        fn index_of(&self, key: ItemKey) -> Option<usize> {
            self.keys.iter().position(|value| *value == key.get())
        }
        fn row(&self, index: usize) -> El<'_> {
            let key = self.keys[index];
            let guard = ColumnCapture {
                generation: self.generation,
                node: key as usize,
                events: self.events.clone(),
            };
            button(format!("key {key}")).on_click(move |page: &mut Self| {
                guard.retain();
                page.selected = Some(key);
            })
        }
    }
    impl View for Page {
        fn view(&self) -> El<'_> {
            uniform_list(LIST, self, 16).h(128).w(200)
        }
    }
    let events = Arc::new(std::sync::Mutex::new(Vec::new()));
    let mut win = Win::with_size(
        Page {
            keys: (0..6).collect(),
            generation: 0,
            selected: None,
            events: events.clone(),
        },
        240,
        160,
    )
    .unwrap();
    let kept = win.button("key 1");
    let removed = win.button("key 4");
    win.update(|page| {
        page.keys.reverse();
        page.generation = 1;
    })
    .unwrap();
    assert_eq!(
        *events.lock().unwrap(),
        (0..6).rev().map(|key| (0, key)).collect::<Vec<_>>()
    );
    assert_eq!(win.button("key 1"), kept);
    events.lock().unwrap().clear();
    win.update(|page| {
        page.keys = vec![5, 1, 3];
        page.generation = 2;
    })
    .unwrap();
    assert_eq!(
        *events.lock().unwrap(),
        [5, 1, 3, 4, 2, 0].map(|key| (1, key))
    );
    assert_eq!(win.button("key 1"), kept);
    assert_eq!(win.activate(removed), Err(Error::StaleTarget));
    win.activate(kept).unwrap();
    assert_eq!(win.root().unwrap().selected, Some(1));
}
impl ColumnCapture {
    fn retain(&self) {}
}

#[test]
fn selection_request_and_reply_panics_restore_dense_and_sparse_routes_until_close() {
    struct Owner {
        target: Option<Target>,
        request_panics: bool,
        sparse: bool,
        drops: Arc<AtomicUsize>,
    }
    impl View for Owner {
        fn view(&self) -> El<'_> {
            let guard = Retire {
                drops: self.drops.clone(),
                panic: false,
            };
            let site = div().size(8).on_click(gpui::property_selection(
                move |owner: &Self| {
                    guard.retain();
                    assert!(!owner.request_panics, "selection request panic");
                    Some((owner.target.unwrap(), gpui::PropertyId::Width))
                },
                |_: &mut Self, _| panic!("selection reply panic"),
            ));
            if self.sparse {
                column((site, column((0..32).map(|_| div()))))
            } else {
                site
            }
        }
    }
    for sparse in [false, true] {
        for request_panics in [false, true] {
            let drops = Arc::new(AtomicUsize::new(0));
            let mut win = Win::demo(Owner {
                target: None,
                request_panics,
                sparse,
                drops: drops.clone(),
            });
            let target = win
                .snapshot()
                .unwrap()
                .nodes
                .iter()
                .find_map(|node| node.target)
                .unwrap();
            win.update(|owner| owner.target = Some(target)).unwrap();
            let before = drops.load(Ordering::SeqCst);
            assert_eq!(win.activate(target), Err(Error::OwnerPanicked));
            assert_eq!(drops.load(Ordering::SeqCst), before);
            assert_eq!(win.activate(target), Err(Error::Poisoned));
            win.close();
            assert_eq!(drops.load(Ordering::SeqCst), before + 1);
        }
    }
}
