//! Public-interface allocation census and routing after sparse slots move.
use gpui::{Win, WindowOptions, prelude::*};

struct Buttons {
    count: usize,
    stride: usize,
    clicks: usize,
}
impl Buttons {
    fn click(&mut self) {
        self.clicks += 1;
    }
}
impl View for Buttons {
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|index| {
            let el = div().size(1);
            if self.stride != 0 && index % self.stride == 0 {
                el.on_click(Self::click)
            } else {
                el
            }
        }))
    }
}
macro_rules! layer {
    ($name:ident, $child:ty) => {
        struct $name {
            child: $child,
        }
        impl $name {
            const CHILD: Component<Self, $child> =
                Component::new(FieldId::new(1), "child", |m| &m.child, |m| &mut m.child);
        }
        impl View for $name {
            fn sources() -> Sources<Self> {
                Sources::new().direct_component(Self::CHILD)
            }
            fn view(&self) -> El<'_> {
                Self::CHILD.view(self)
            }
        }
    };
}
layer!(One, Buttons);
layer!(Two, One);
layer!(Three, Two);
layer!(Four, Three);
fn model(count: usize, stride: usize) -> Buttons {
    Buttons {
        count,
        stride,
        clicks: 0,
    }
}

fn census<M: View + 'static>(name: &str, model: M) {
    let mut description = None;
    let view = allocation_counter::measure(|| {
        description = Some(model.view());
    });
    println!(
        "VIEW {name} allocations={} requested={} retained={} peak={}",
        view.count_total, view.bytes_total, view.bytes_current, view.bytes_max
    );
    drop(description);
    let mut owner = None;
    let open = allocation_counter::measure(|| {
        let mut win = Win::recording(
            model,
            WindowOptions {
                size: [32, 32],
                ..Default::default()
            },
        )
        .unwrap();
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        owner = Some(win);
    });
    let mut win = owner.unwrap();
    let targets = win
        .snapshot()
        .unwrap()
        .nodes
        .into_iter()
        .filter_map(|node| node.target)
        .collect::<Vec<_>>();
    println!(
        "OPEN {name} targets={} allocations={} requested={} retained={} peak={}",
        targets.len(),
        open.count_total,
        open.bytes_total,
        open.bytes_current,
        open.bytes_max
    );
    if let Some(target) = targets.last() {
        win.activate(*target).unwrap();
    }
    std::hint::black_box(win);
}

#[test]
fn public_allocation_census() {
    for count in [0, 1, 63, 64, 65, 4096] {
        for stride in [0, 64, 1] {
            census(&format!("root-{count}-{stride}"), model(count, stride));
        }
    }
    for count in [1, 100, 10000] {
        census(
            &format!("depth1-{count}"),
            One {
                child: model(count, 1),
            },
        );
        census(
            &format!("depth4-{count}"),
            Four {
                child: Three {
                    child: Two {
                        child: One {
                            child: model(count, 1),
                        },
                    },
                },
            },
        );
    }
}

#[test]
fn sparse_routes_survive_description_growth_removal_and_replacement() {
    let mut win = Win::demo(model(130, 64));
    for expected in 1..=3 {
        let target = win
            .snapshot()
            .unwrap()
            .nodes
            .into_iter()
            .filter_map(|node| node.target)
            .nth(expected - 1)
            .unwrap();
        win.activate(target).unwrap();
        assert_eq!(win.root().unwrap().clicks, expected);
    }
    let stale = win
        .snapshot()
        .unwrap()
        .nodes
        .into_iter()
        .filter_map(|node| node.target)
        .next_back()
        .unwrap();
    win.update(|m| {
        m.count = 65;
        m.stride = 0;
    })
    .unwrap();
    assert!(win.activate(stale).is_err());
    assert!(
        win.snapshot()
            .unwrap()
            .nodes
            .iter()
            .all(|node| node.target.is_none())
    );
    win.update(|m| {
        m.count = 129;
        m.stride = 1;
    })
    .unwrap();
    let targets = win
        .snapshot()
        .unwrap()
        .nodes
        .into_iter()
        .filter_map(|node| node.target)
        .collect::<Vec<_>>();
    assert_eq!(targets.len(), 129);
    for index in [0, 62, 63, 64, 127, 128] {
        win.activate(targets[index]).unwrap();
    }
    assert_eq!(win.root().unwrap().clicks, 9);
}

#[test]
fn each_target_calls_its_own_capture_after_sparse_slots_move() {
    struct Routes {
        last: Option<usize>,
        sparse: bool,
    }
    impl View for Routes {
        fn view(&self) -> El<'_> {
            column((0..130).map(|index| {
                let el = div().size(1).name(index.to_string());
                if !self.sparse || [0, 63, 64, 65, 128, 129].contains(&index) {
                    el.on_click(move |m: &mut Routes| m.last = Some(index))
                } else {
                    el
                }
            }))
        }
    }
    let mut win = Win::demo(Routes {
        last: None,
        sparse: false,
    });
    for sparse in [false, true, false] {
        win.update(|m| m.sparse = sparse).unwrap();
        let nodes = win.snapshot().unwrap().nodes;
        for (index, node) in nodes.iter().skip(1).enumerate() {
            if let Some(target) = node.target {
                win.activate(target).unwrap();
                assert_eq!(win.root().unwrap().last, Some(index));
            }
        }
    }
}

#[path = "../examples/support/graphics.rs"]
mod graphics;
#[path = "../examples/support/library.rs"]
mod library;
#[path = "../examples/support/todos.rs"]
mod todos;
#[path = "../examples/support/workspace.rs"]
mod workspace;

#[test]
fn ordinary_application_allocation_census() {
    census("todos-default", todos::Todos::default());
    census("workspace-default", workspace::Workspace::default());
    census("library-250000", library::Library::new(250_000));
}
