use std::{
    cell::{Cell, RefCell},
    rc::Rc,
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
};

use crate::tree_list::{TreeListHandle, TreeModel, tree_list};
use gpui::{Context, Render, TestAppContext, Window, div, point, prelude::*, px};

const ROOT_COUNT: usize = 1_000_000;

#[derive(Default)]
struct Reads {
    roots_len: Cell<usize>,
    root_at: Cell<usize>,
    child_count: Cell<usize>,
    child_at: Cell<usize>,
    parent: Cell<usize>,
    contains: Cell<usize>,
}

#[derive(Default)]
struct SyntheticRoots {
    count: usize,
    reads: Reads,
}

impl TreeModel<usize> for SyntheticRoots {
    fn roots_len(&self) -> usize {
        self.reads.roots_len.set(self.reads.roots_len.get() + 1);
        self.count
    }

    fn root_at(&self, index: usize) -> Option<usize> {
        self.reads.root_at.set(self.reads.root_at.get() + 1);
        (index < self.count).then_some(index)
    }

    fn child_count(&self, _parent: &usize) -> usize {
        self.reads.child_count.set(self.reads.child_count.get() + 1);
        0
    }

    fn child_at(&self, _parent: &usize, _index: usize) -> Option<usize> {
        self.reads.child_at.set(self.reads.child_at.get() + 1);
        None
    }

    fn parent(&self, _id: &usize) -> Option<usize> {
        self.reads.parent.set(self.reads.parent.get() + 1);
        None
    }

    fn contains(&self, id: &usize) -> bool {
        self.reads.contains.set(self.reads.contains.get() + 1);
        *id < self.count
    }
}

#[derive(Clone, Copy, Default)]
struct ReadSnapshot {
    roots_len: usize,
    root_at: usize,
    child_count: usize,
    child_at: usize,
    parent: usize,
    contains: usize,
}

impl Reads {
    fn snapshot(&self) -> ReadSnapshot {
        ReadSnapshot {
            roots_len: self.roots_len.get(),
            root_at: self.root_at.get(),
            child_count: self.child_count.get(),
            child_at: self.child_at.get(),
            parent: self.parent.get(),
            contains: self.contains.get(),
        }
    }
}

struct MillionRootHarness {
    model: Rc<SyntheticRoots>,
    label_calls: Arc<AtomicUsize>,
    rendered_ids: Rc<RefCell<Vec<usize>>>,
    handle: TreeListHandle<usize>,
}

impl Render for MillionRootHarness {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let labels = self.label_calls.clone();
        let mut tree = tree_list(self.model.clone(), "million-roots", move |id| {
            labels.fetch_add(1, Ordering::Relaxed);
            format!("synthetic row {id}").into()
        })
        .row_height(px(24.))
        .handle(self.handle.clone());

        let rendered_ids = self.rendered_ids.clone();
        tree = tree.render_row(move |row, label, _, _| {
            rendered_ids.borrow_mut().push(row.id);
            div()
                .w_full()
                .h(px(24.))
                .flex()
                .items_center()
                .child(label)
                .into_any_element()
        });

        tree.h(px(180.)).w_full()
    }
}

#[gpui::test]
fn one_million_roots_keep_model_reads_and_rendering_viewport_bounded(cx: &mut TestAppContext) {
    cx.update(crate::init);
    let model = Rc::new(SyntheticRoots {
        count: ROOT_COUNT,
        reads: Reads::default(),
    });
    let label_calls = Arc::new(AtomicUsize::new(0));
    let rendered_ids = Rc::new(RefCell::new(Vec::new()));
    let handle = TreeListHandle::default();
    let (view, cx) = cx.add_window_view({
        let model = model.clone();
        let label_calls = label_calls.clone();
        let rendered_ids = rendered_ids.clone();
        let handle = handle.clone();
        move |_, _| MillionRootHarness {
            model,
            label_calls,
            rendered_ids,
            handle,
        }
    });
    let _ = view;
    cx.update(|window, _| window.activate());
    cx.run_until_parked();

    let initial_reads = model.reads.snapshot();
    let initial_labels = label_calls.load(Ordering::Relaxed);
    let initial_rows = rendered_ids.borrow().len();
    assert!(initial_reads.root_at >= ROOT_COUNT);
    assert!(initial_reads.root_at <= ROOT_COUNT + 128);
    assert!(
        initial_labels > 0 && initial_rows > 0 && initial_labels < 50 && initial_rows < 50,
        "initial view should build only viewport rows: {initial_labels} labels, {initial_rows} delegates"
    );

    let scroll_label_start = label_calls.load(Ordering::Relaxed);
    let scroll_row_start = rendered_ids.borrow().len();
    cx.simulate_event(gpui::ScrollWheelEvent {
        position: point(px(80.), px(100.)),
        delta: gpui::ScrollDelta::Pixels(point(px(0.), px(-30_000_000.))),
        ..Default::default()
    });
    cx.run_until_parked();
    let after_scroll = model.reads.snapshot();
    let scroll_labels = label_calls.load(Ordering::Relaxed) - scroll_label_start;
    let scroll_rows = rendered_ids.borrow().len() - scroll_row_start;
    assert!(
        rendered_ids.borrow().iter().any(|id| *id > 950_000),
        "a large wheel scroll should materialize rows near the million-row tail"
    );
    assert!(scroll_labels > 0 && scroll_rows > 0 && scroll_labels < 50 && scroll_rows < 50);
    assert!(after_scroll.root_at - initial_reads.root_at <= 128);
    assert!(after_scroll.roots_len - initial_reads.roots_len <= scroll_rows + 2);
    assert_eq!(after_scroll.child_at - initial_reads.child_at, 0);
    assert!(after_scroll.child_count - initial_reads.child_count <= scroll_rows + 2);
    assert!(after_scroll.parent - initial_reads.parent <= scroll_rows + 2);
    assert!(after_scroll.contains - initial_reads.contains <= scroll_rows + 2);

    let focus_label_start = label_calls.load(Ordering::Relaxed);
    let focus_row_start = rendered_ids.borrow().len();
    assert!(cx.update(|_, app| handle.focus_item(model.as_ref(), 500_000, app)));
    cx.run_until_parked();
    let after_focus = model.reads.snapshot();
    let focus_labels = label_calls.load(Ordering::Relaxed) - focus_label_start;
    let focus_rows = rendered_ids.borrow().len() - focus_row_start;
    assert!(
        rendered_ids
            .borrow()
            .iter()
            .any(|id| (499_900..=500_100).contains(id)),
        "focus reveal should materialize the requested row's neighborhood"
    );
    assert_eq!(cx.update(|_, app| handle.focused_id(app)), Some(500_000));
    assert!(focus_labels > 0 && focus_rows > 0 && focus_labels < 50 && focus_rows < 50);
    assert!(after_focus.root_at - after_scroll.root_at <= 128);
    assert!(after_focus.roots_len - after_scroll.roots_len <= focus_rows + 2);
    assert_eq!(after_focus.child_at - after_scroll.child_at, 0);
    assert!(after_focus.child_count - after_scroll.child_count <= focus_rows + 2);
    assert!(after_focus.parent - after_scroll.parent <= focus_rows + 2);
    assert!(after_focus.contains - after_scroll.contains <= focus_rows + 2);
}
