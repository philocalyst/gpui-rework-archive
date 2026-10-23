//! Test-only whole-owner allocator requests; these counters are not RSS.
use super::*;
use crate::prelude::*;
#[path = "../../examples/support/graphics.rs"]
mod graphics;
#[cfg(all(target_os = "linux", any(feature = "x11", feature = "x11-minimal")))]
use crate::native::test_todos as todos;
#[cfg(not(all(target_os = "linux", any(feature = "x11", feature = "x11-minimal"))))]
#[path = "../../examples/support/todos.rs"]
mod todos;
#[path = "../../examples/support/workspace.rs"]
mod workspace;

struct Cohort {
    nodes: usize,
    routes: usize,
    captured: bool,
    generation: usize,
    total: usize,
}
impl Cohort {
    fn site<'a>(&self, node: usize, element: El<'a>) -> El<'a> {
        if node >= self.routes {
            element
        } else if self.captured {
            let capture = [node + self.generation; 128];
            element.on_click(move |m: &mut Self| m.total += capture.iter().sum::<usize>())
        } else {
            element.on_click(|m: &mut Self| m.total += 1)
        }
    }
}
impl View for Cohort {
    fn view(&self) -> El<'_> {
        self.site(
            0,
            column((1..self.nodes).map(|node| self.site(node, div().size(1)))),
        )
    }
}
fn owner<M: View + 'static>(name: &str, model: M, edit: impl FnOnce(&mut Win<M>)) {
    let mut keep = None;
    let allocation = allocation_counter::measure(|| {
        let mut win = Win::recording(model, WindowOptions::default()).unwrap();
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        edit(&mut win);
        keep = Some(win);
    });
    let win = keep.as_ref().unwrap();
    let runtime = win.runtime().unwrap();
    let routes = runtime.nodes.iter().filter(|node| node.has_route()).count();
    println!(
        "ROUTE_OWNER,name={name},nodes={},routes={routes},node_capacity={},node_bytes={},runtime={},win={},requests={},requested={},live_requests={},live={},peak={}",
        runtime.nodes.len(),
        runtime.nodes.capacity(),
        runtime.nodes.capacity() * size_of::<Node>(),
        size_of::<Runtime<M>>(),
        size_of::<Win<M>>(),
        allocation.count_total,
        allocation.bytes_total,
        allocation.count_current,
        allocation.bytes_current,
        allocation.bytes_max
    );
    drop(keep);
}

#[test]
#[ignore = "explicit allocator/capacity ledger, no timing"]
fn complete_owner_route_requests() {
    println!(
        "ROUTE_HEADERS,node={},option_node={},runtime_unit={},win={},handler={},el={},draft={}",
        size_of::<Node>(),
        size_of::<Option<Node>>(),
        size_of::<Runtime<()>>(),
        size_of::<Win<Cohort>>(),
        size_of::<Option<Handler>>(),
        size_of::<El<'_>>(),
        size_of::<crate::element::DraftNode<'_>>()
    );
    // There is no public zero-node View: even an empty div retains one row.
    for (nodes, routes) in [
        (1, 0),
        (1, 1),
        (100, 0),
        (100, 1),
        (100, 66),
        (100, 67),
        (100, 100),
    ] {
        for captured in [false, true] {
            for update in [false, true] {
                let model = Cohort {
                    nodes,
                    routes,
                    captured,
                    generation: 0,
                    total: 0,
                };
                let drafts = model.view().flatten();
                println!(
                    "ROUTE_DRAFT,nodes={nodes},routes={routes},captured={captured},len={},capacity={},bytes={}",
                    drafts.len(),
                    drafts.capacity(),
                    drafts.capacity() * size_of::<crate::element::DraftNode<'_>>()
                );
                drop(drafts);
                let name = format!("n{nodes}_h{routes}_capture{captured}_update{update}");
                owner(&name, model, |win| {
                    if update {
                        win.update(|m| m.generation += 1).unwrap();
                    }
                });
            }
        }
    }
    for routes in [0, 164, 8192] {
        for update in [false, true] {
            let name = format!("n16384_h{routes}_capturefalse_update{update}");
            owner(
                &name,
                Cohort {
                    nodes: 16384,
                    routes,
                    captured: false,
                    generation: 0,
                    total: 0,
                },
                |win| {
                    if update {
                        win.update(|m| m.generation += 1).unwrap();
                    }
                },
            );
        }
    }
    for (before, after) in [(100, 1), (1, 100), (100, 0), (0, 100)] {
        for captured in [false, true] {
            let name = format!("n100_h{before}_to{after}_capture{captured}");
            owner(
                &name,
                Cohort {
                    nodes: 100,
                    routes: before,
                    captured,
                    generation: 0,
                    total: 0,
                },
                |win| {
                    win.update(|m| {
                        m.generation += 1;
                        m.routes = after;
                    })
                    .unwrap();
                },
            );
        }
    }
    owner("workspace_mount", workspace::Workspace::default(), |_| {});
    owner("workspace_rotate", workspace::Workspace::default(), |win| {
        win.activate(win.button("Rotate")).unwrap();
    });
}
