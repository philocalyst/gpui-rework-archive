//! Explicit allocation/timing fixture; no measurement runs in ordinary tests.
use super::style_ledger::{library, todos, workspace};
use super::*;
use crate::prelude::*;

struct Panels {
    count: usize,
    mode: u8,
    frame: u32,
}
impl View for Panels {
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|index| {
            let a = match self.mode {
                0 | 4 => 1.0,
                1 => 1.0 + (index % 2) as f32 / 8.0,
                2 => 1.0 + (index % 32) as f32 / 64.0,
                _ => 1.0 + index as f32 / 4096.0,
            };
            div()
                .size(1)
                .bg(if self.mode == 4 {
                    Color::TRANSPARENT
                } else {
                    Color::BLACK
                })
                .transform(Affine {
                    a,
                    b: 0.0,
                    c: 0.0,
                    d: 1.0,
                    tx: (self.frame % 4) as f32,
                    ty: 0.0,
                })
        }))
        .transform(if self.mode == 4 {
            Affine::scale(0.0, 0.0)
        } else {
            Affine::IDENTITY
        })
    }
}
fn ack<M: View + 'static>(win: &mut Win<M>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn open<M: View + 'static>(model: M, size: [u32; 2]) -> Win<M> {
    let mut win = Win::recording(
        model,
        WindowOptions {
            size,
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win
}
fn cost(label: &str, operations: usize, mut operation: impl FnMut()) {
    let start = std::time::Instant::now();
    for _ in 0..operations {
        operation();
    }
    println!("cost,{label},{operations},{}", start.elapsed().as_nanos());
}
#[test]
#[ignore = "explicit paired release fixture; coordinate quiet CPU window"]
fn presented_space_cost() {
    let mut todos = open(todos::Todos::default(), [640, 1000]);
    let add = todos.button("Add");
    let input = todos.input();
    for index in 0..32 {
        todos.type_text(input, &format!("Task {index}")).unwrap();
        todos.activate(add).unwrap();
        ack(&mut todos);
    }
    let mut workspace = open(workspace::Workspace::default(), [1100, 800]);
    let rotate = workspace.button("Rotate");
    let mut library = open(library::Library::new(250_000), [760, 600]);
    let list = library.list(library::LIBRARY).unwrap();
    for round in 0..3 {
        for count in [0, 2, 4096] {
            for mode in 0..5 {
                cost(
                    &format!("mount_{count}_{mode}"),
                    if count == 4096 { 4 } else { 32 },
                    || {
                        std::hint::black_box(open(
                            Panels {
                                count,
                                mode,
                                frame: 0,
                            },
                            [640, 480],
                        ));
                    },
                );
                let mut win = open(
                    Panels {
                        count,
                        mode,
                        frame: 0,
                    },
                    [640, 480],
                );
                cost(&format!("update_{count}_{mode}"), 16, || {
                    win.update(|model| model.frame += 1).unwrap();
                    ack(&mut win);
                });
                cost(&format!("visit_{count}_{mode}"), 32, || {
                    win.visit(|part| {
                        std::hint::black_box((
                            part.transform(),
                            part.local_bounds(),
                            part.unclipped_bounds(),
                        ));
                    })
                    .unwrap();
                });
            }
        }
        cost("todos_equal", 32, || {
            todos.update(|_| {}).unwrap();
        });
        cost("workspace_rotate", 32, || {
            workspace.activate(rotate).unwrap();
            ack(&mut workspace);
        });
        cost("library_equal", 32, || {
            library.update(|_| {}).unwrap();
        });
        let mut index = 0;
        cost("library_scroll", 16, || {
            index = (index + 1003) % 250_000;
            library.scroll_to_index(list, index).unwrap();
            ack(&mut library);
        });
        println!("round,{round}");
    }
}
#[test]
#[ignore = "whole owner requested allocation/live/peak ledger, including layout and Canvas"]
fn presented_space_owner_memory() {
    println!(
        "sizes,Presented={},Prepared={},Runtime={}",
        size_of::<Presented>(),
        size_of::<Prepared>(),
        size_of::<Runtime<()>>()
    );
    for count in [0, 2, 4096] {
        for mode in 0..5 {
            for pending in [false, true] {
                let mut owner = None;
                let allocation = allocation_counter::measure(|| {
                    let mut win = open(
                        Panels {
                            count,
                            mode,
                            frame: 0,
                        },
                        [640, 480],
                    );
                    if pending {
                        win.update(|model| model.frame += 1).unwrap();
                        win.resize([641, 480]).unwrap();
                    }
                    owner = Some(win);
                });
                println!(
                    "owner_memory,{count},{mode},{pending},{},{},{},{},{}",
                    allocation.count_total,
                    allocation.bytes_total,
                    allocation.count_current,
                    allocation.bytes_current,
                    allocation.bytes_max
                );
                std::hint::black_box(owner);
            }
        }
    }
}
