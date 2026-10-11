use std::{
    cell::{Cell, RefCell},
    collections::HashSet,
    rc::Rc,
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
    time::Duration,
};

use crate::tree_list::{DropPosition, TreeChange, TreeListHandle, TreeModel, tree_list};
use gpui::{Context, Modifiers, Render, TestAppContext, Window, div, point, prelude::*, px};

#[derive(Clone)]
struct Node {
    parent: Option<usize>,
    children: Vec<usize>,
    label: String,
}

#[derive(Default)]
struct Model {
    roots: Vec<usize>,
    nodes: Vec<Node>,
    row_heights: Vec<f32>,
    default_row_height: f32,
    forbidden_label_ids: HashSet<usize>,
    reset_on_rename: bool,
}

impl Model {
    fn roots(count: usize) -> Self {
        Self {
            roots: (0..count).collect(),
            nodes: (0..count)
                .map(|index| Node {
                    parent: None,
                    children: Vec::new(),
                    label: format!("row {index}"),
                })
                .collect(),
            row_heights: vec![24.; count],
            default_row_height: 24.,
            forbidden_label_ids: HashSet::new(),
            reset_on_rename: false,
        }
    }

    fn with_branch() -> Self {
        let mut model = Self::roots(4);
        model.nodes.push(Node {
            parent: Some(0),
            children: Vec::new(),
            label: "child a".into(),
        });
        model.nodes.push(Node {
            parent: Some(0),
            children: Vec::new(),
            label: "child b".into(),
        });
        model.nodes[0].children = vec![4, 5];
        model.row_heights.extend([24., 24.]);
        model
    }
}

impl TreeModel<usize> for RefCell<Model> {
    fn roots_len(&self) -> usize {
        self.borrow().roots.len()
    }
    fn root_at(&self, index: usize) -> Option<usize> {
        self.borrow().roots.get(index).copied()
    }
    fn child_count(&self, parent: &usize) -> usize {
        self.borrow()
            .nodes
            .get(*parent)
            .map_or(0, |node| node.children.len())
    }
    fn child_at(&self, parent: &usize, index: usize) -> Option<usize> {
        self.borrow()
            .nodes
            .get(*parent)?
            .children
            .get(index)
            .copied()
    }
    fn parent(&self, id: &usize) -> Option<usize> {
        self.borrow().nodes.get(*id)?.parent
    }
    fn contains(&self, id: &usize) -> bool {
        let model = self.borrow();
        model.roots.contains(id) || model.nodes.iter().any(|node| node.children.contains(id))
    }
}

struct Harness {
    model: Rc<RefCell<Model>>,
    selected: Rc<RefCell<Vec<Vec<usize>>>>,
    renamed: Rc<RefCell<Vec<(usize, String)>>>,
    row_contexts: Rc<RefCell<Vec<(usize, bool, Option<String>)>>>,
    label_calls: Option<Arc<AtomicUsize>>,
    delegate_calls: Option<Rc<Cell<usize>>>,
    handle: TreeListHandle<usize>,
    render_calls: Option<Arc<AtomicUsize>>,
    dropped: Option<Rc<RefCell<Vec<(Vec<usize>, DropPosition<usize>)>>>>,
    expanded: Vec<usize>,
}

impl Render for Harness {
    fn render(&mut self, _window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        if let Some(calls) = &self.render_calls {
            calls.fetch_add(1, Ordering::Relaxed);
        }
        let model_for_label = self.model.clone();
        let label_calls = self.label_calls.clone();
        let mut list = tree_list(self.model.clone(), "tree-list", move |id| {
            if let Some(calls) = &label_calls {
                calls.fetch_add(1, Ordering::Relaxed);
            }
            let model = model_for_label.borrow();
            assert!(
                !model.forbidden_label_ids.contains(id),
                "label adapter must not read removed row {id} during exit presentation"
            );
            model.nodes[*id].label.clone().into()
        })
        .row_height(px(self.model.borrow().default_row_height))
        .row_height_for({
            let model = self.model.clone();
            move |id| px(model.borrow().row_heights.get(*id).copied().unwrap_or(24.))
        })
        .initially_expanded(self.expanded.clone());

        let selected = self.selected.clone();
        list = list.on_selection_change(move |ids, _, _| selected.borrow_mut().push(ids));
        list = list.handle(self.handle.clone());

        let row_contexts = self.row_contexts.clone();
        let delegate_calls = self.delegate_calls.clone();
        let row_heights = self.model.clone();
        list = list.render_row(move |row, label, _window, _cx| {
            row_contexts.borrow_mut().push((
                row.id,
                row.editing,
                row.rename_error.map(|error| error.to_string()),
            ));
            let height = row_heights
                .borrow()
                .row_heights
                .get(row.id)
                .copied()
                .unwrap_or(24.);
            let mut row_content = div()
                .w_full()
                .h(px(height))
                .flex()
                .items_center()
                .child(label);
            if let Some(calls) = delegate_calls.clone() {
                let row_id = row.id;
                row_content = row_content.child(
                    div()
                        .id(format!("delegate-{row_id}"))
                        .w(px(96.))
                        .h(px(24.))
                        .child("Action")
                        .on_click(move |_, _, cx| {
                            calls.set(calls.get() + 1);
                            cx.stop_propagation();
                        }),
                );
            }
            row_content.into_any_element()
        });

        let model = self.model.clone();
        let renamed = self.renamed.clone();
        let handle = self.handle.clone();
        list = list.on_rename(move |id, value, _, cx| {
            renamed.borrow_mut().push((*id, value.to_owned()));
            if model.borrow().reset_on_rename {
                handle.refresh(model.as_ref(), TreeChange::Reset, cx);
            }
            if value == "invalid" {
                return Err("invalid name".into());
            }
            model.borrow_mut().nodes[*id].label = value.to_owned();
            Ok(())
        });
        if let Some(dropped) = self.dropped.clone() {
            list = list.on_drop(move |ids, position, _, _| {
                dropped.borrow_mut().push((ids.to_vec(), position));
                Ok(())
            });
        }
        list.h(px(180.)).w_full()
    }
}

fn setup(
    cx: &mut TestAppContext,
    model: Model,
    expanded: Vec<usize>,
    label_calls: Option<Arc<AtomicUsize>>,
    delegate_calls: Option<Rc<Cell<usize>>>,
    render_calls: Option<Arc<AtomicUsize>>,
    dropped: Option<Rc<RefCell<Vec<(Vec<usize>, DropPosition<usize>)>>>>,
) -> (
    Rc<RefCell<Model>>,
    Rc<RefCell<Vec<Vec<usize>>>>,
    Rc<RefCell<Vec<(usize, String)>>>,
    Rc<RefCell<Vec<(usize, bool, Option<String>)>>>,
    TreeListHandle<usize>,
    &mut gpui::VisualTestContext,
) {
    cx.update(crate::init);
    let model = Rc::new(RefCell::new(model));
    let selected = Rc::new(RefCell::new(Vec::new()));
    let renamed = Rc::new(RefCell::new(Vec::new()));
    let row_contexts = Rc::new(RefCell::new(Vec::new()));
    let handle = TreeListHandle::default();
    let handle_for_view = handle.clone();
    let model_for_view = model.clone();
    let selected_for_view = selected.clone();
    let renamed_for_view = renamed.clone();
    let row_contexts_for_view = row_contexts.clone();
    let (view, cx) = cx.add_window_view(|_, _| Harness {
        model: model_for_view,
        selected: selected_for_view,
        renamed: renamed_for_view,
        row_contexts: row_contexts_for_view,
        label_calls,
        delegate_calls,
        handle: handle_for_view,
        render_calls,
        dropped,
        expanded,
    });
    let _ = view;
    cx.update(|window, _| window.activate());
    cx.run_until_parked();
    (model, selected, renamed, row_contexts, handle, cx)
}

fn click_row(cx: &mut gpui::VisualTestContext, row: usize, modifiers: Modifiers) {
    cx.simulate_click(point(px(12.), px(row as f32 * 24. + 12.)), modifiers);
}

#[gpui::test]
fn rendering_ten_thousand_rows_only_builds_the_visible_window(cx: &mut TestAppContext) {
    let calls = Arc::new(AtomicUsize::new(0));
    let (_model, _selected, _renamed, _row_contexts, _handle, _cx) = setup(
        cx,
        Model::roots(10_000),
        vec![],
        Some(calls.clone()),
        None,
        None,
        None,
    );

    let rendered_labels = calls.load(Ordering::Relaxed);
    assert!(
        rendered_labels > 0,
        "the tree should render visible row labels"
    );
    assert!(
        rendered_labels < 50,
        "expected viewport-bounded row rendering, got {rendered_labels} labels"
    );
}

#[gpui::test]
fn pointer_and_keyboard_selection_support_ranges_and_toggle(cx: &mut TestAppContext) {
    let (_model, selected, _renamed, _row_contexts, _handle, cx) =
        setup(cx, Model::roots(8), vec![], None, None, None, None);

    click_row(cx, 1, Modifiers::none());
    click_row(cx, 4, Modifiers::shift());
    let last = selected.borrow().last().cloned().unwrap_or_default();
    let ids: std::collections::HashSet<_> = last.into_iter().collect();
    assert_eq!(ids, [1, 2, 3, 4].into_iter().collect());

    click_row(cx, 6, Modifiers::secondary_key());
    let last = selected.borrow().last().cloned().unwrap_or_default();
    assert!(
        last.contains(&1)
            && last.contains(&2)
            && last.contains(&3)
            && last.contains(&4)
            && last.contains(&6)
    );

    cx.simulate_keystrokes("up");
    let last = selected.borrow().last().cloned().unwrap_or_default();
    assert!(
        last.contains(&5),
        "arrow navigation should move focus/selection to the preceding visible row"
    );
    cx.simulate_keystrokes("secondary-a");
    let all: std::collections::HashSet<_> =
        selected.borrow().last().unwrap().iter().copied().collect();
    assert_eq!(all, (0..8).collect());
}

#[gpui::test]
fn rename_commits_once_and_escape_cancels_even_after_blur(cx: &mut TestAppContext) {
    let (model, _selected, renamed, _row_contexts, _handle, cx) =
        setup(cx, Model::roots(4), vec![], None, None, None, None);

    click_row(cx, 0, Modifiers::none());
    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("改名");
    cx.simulate_keystrokes("enter");
    click_row(cx, 1, Modifiers::none());
    assert_eq!(model.borrow().nodes[0].label, "改名");
    assert_eq!(&*renamed.borrow(), &[(0, "改名".to_owned())]);

    click_row(cx, 1, Modifiers::none());
    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("discard me");
    cx.simulate_keystrokes("escape");
    click_row(cx, 2, Modifiers::none());
    assert_eq!(model.borrow().nodes[1].label, "row 1");
    assert_eq!(
        renamed.borrow().len(),
        1,
        "a canceled edit must not be committed by later blur"
    );
}

#[gpui::test]
fn keyboard_expands_and_collapses_visible_branches(cx: &mut TestAppContext) {
    let (_model, selected, _renamed, _row_contexts, _handle, cx) =
        setup(cx, Model::with_branch(), vec![], None, None, None, None);

    click_content(cx, 0);
    cx.simulate_keystrokes("right");
    cx.executor().advance_clock(Duration::from_millis(200));
    cx.run_until_parked();
    cx.update(|window, _| window.refresh());
    cx.run_until_parked();
    click_content(cx, 1);
    assert_eq!(selected.borrow().last().cloned(), Some(vec![4]));

    click_content(cx, 0);
    cx.simulate_keystrokes("left");
    cx.executor().advance_clock(Duration::from_millis(200));
    cx.run_until_parked();
    cx.update(|window, _| window.refresh());
    cx.run_until_parked();
    click_content(cx, 1);
    assert_eq!(selected.borrow().last().cloned(), Some(vec![1]));
}

#[gpui::test]
fn interactive_row_content_runs_its_action_without_changing_selection(cx: &mut TestAppContext) {
    let calls = Rc::new(Cell::new(0));
    let (_model, selected, _renamed, _row_contexts, _handle, cx) = setup(
        cx,
        Model::roots(3),
        vec![],
        None,
        Some(calls.clone()),
        None,
        None,
    );

    click_row(cx, 0, Modifiers::none());
    assert_eq!(selected.borrow().last().cloned(), Some(vec![0]));
    let selection_events = selected.borrow().len();

    cx.simulate_click(point(px(96.), px(12.)), Modifiers::none());
    assert_eq!(calls.get(), 1, "the nested row action should run");
    assert_eq!(
        selected.borrow().len(),
        selection_events,
        "a handled child action should not bubble into row selection"
    );
}

fn click_content(cx: &mut gpui::VisualTestContext, row: usize) {
    click_content_with_modifiers(cx, row, Modifiers::none());
}

fn click_content_with_modifiers(
    cx: &mut gpui::VisualTestContext,
    row: usize,
    modifiers: Modifiers,
) {
    cx.simulate_click(point(px(80.), px(row as f32 * 24. + 12.)), modifiers);
}

#[gpui::test]
fn collapsing_ancestor_repairs_hidden_focus_before_next_row_navigation(cx: &mut TestAppContext) {
    let (_model, selected, _renamed, _row_contexts, _handle, cx) =
        setup(cx, Model::with_branch(), vec![0], None, None, None, None);

    // Focus the first child, then collapse its ancestor through the disclosure control.
    click_content(cx, 1);
    cx.simulate_click(point(px(12.), px(12.)), Modifiers::none());
    cx.simulate_keystrokes("down");

    let last = selected.borrow().last().cloned().unwrap_or_default();
    assert!(
        last.contains(&1),
        "after collapse, Down should advance from the visible parent to the next root"
    );
}

#[gpui::test]
fn accessibility_marks_the_focused_row_as_active_descendant(cx: &mut TestAppContext) {
    let (_model, _selected, _renamed, _row_contexts, _handle, cx) =
        setup(cx, Model::roots(3), vec![], None, None, None, None);
    cx.update(|window, _| window.set_a11y_forced(true));
    click_content(cx, 0);

    let json = cx.update(|window, _| window.debug_a11y_tree_json().unwrap());
    assert!(
        !json.contains("\"expanded\""),
        "leaf rows must not be announced as expandable branches"
    );
    let active_id = json
        .split("\"active_descendant_focus\": \"")
        .nth(1)
        .and_then(|rest| rest.split('"').next())
        .expect("focused tree row should be reported as the active descendant");
    let key = format!("\"{active_id}\": {{");
    let active_node = json
        .split_once(&key)
        .map(|(_, rest)| rest)
        .expect("active descendant should have an accessibility node");
    assert!(
        active_node.contains("\"label\": \"row 0\""),
        "the active descendant should be the focused row node, not the tree container: {active_node}"
    );
}

#[gpui::test]
fn structural_refresh_keeps_surviving_selection_and_removes_deleted_ids(cx: &mut TestAppContext) {
    let (model, _selected, _renamed, _row_contexts, handle, cx) =
        setup(cx, Model::roots(8), vec![], None, None, None, None);

    click_content(cx, 5);
    assert_eq!(cx.update(|_, app| handle.selected_ids(app)), vec![5]);

    cx.update(|_, app| {
        {
            let mut data = model.borrow_mut();
            data.nodes.push(Node {
                parent: None,
                children: Vec::new(),
                label: "inserted before selection".into(),
            });
            data.roots.insert(0, 8);
        }
        handle.refresh(
            model.as_ref(),
            TreeChange::ChildrenChanged { parent: None },
            app,
        );
    });
    assert_eq!(cx.update(|_, app| handle.selected_ids(app)), vec![5]);

    cx.update(|_, app| {
        model.borrow_mut().roots.retain(|id| *id != 5);
        handle.refresh(
            model.as_ref(),
            TreeChange::NodesRemoved {
                parent: None,
                removed: vec![5],
            },
            app,
        );
    });
    assert!(cx.update(|_, app| handle.selected_ids(app)).is_empty());
}

#[gpui::test]
fn an_idle_tree_does_not_redraw_repeatedly(cx: &mut TestAppContext) {
    let calls = Arc::new(AtomicUsize::new(0));
    let (_model, _selected, _renamed, _row_contexts, _handle, cx) = setup(
        cx,
        Model::roots(100),
        vec![],
        None,
        None,
        Some(calls.clone()),
        None,
    );
    let before = calls.load(Ordering::Relaxed);

    cx.run_until_parked();
    cx.executor().advance_clock(Duration::from_secs(1));
    cx.run_until_parked();

    let after = calls.load(Ordering::Relaxed);
    assert!(
        after.saturating_sub(before) <= 1,
        "an idle tree should not trigger repeated view renders, got {before} before and {after} after"
    );
}

#[gpui::test]
fn dragging_a_multiselection_calls_drop_with_a_resolved_tree_position(cx: &mut TestAppContext) {
    let drops = Rc::new(RefCell::new(Vec::new()));
    let (_model, _selected, _renamed, _row_contexts, _handle, cx) = setup(
        cx,
        Model::roots(8),
        vec![],
        None,
        None,
        None,
        Some(drops.clone()),
    );

    click_content(cx, 0);
    click_content_with_modifiers(cx, 1, Modifiers::shift());

    let source = point(px(80.), px(12.));
    let target = point(px(80.), px(50.));
    cx.simulate_mouse_down(source, gpui::MouseButton::Left, Modifiers::none());
    cx.simulate_mouse_move(target, Some(gpui::MouseButton::Left), Modifiers::none());
    // The first move crosses GPUI's drag threshold; a second move updates the tree preview.
    cx.simulate_mouse_move(target, Some(gpui::MouseButton::Left), Modifiers::none());
    cx.simulate_mouse_up(target, gpui::MouseButton::Left, Modifiers::none());

    let drops = drops.borrow();
    assert_eq!(
        drops.len(),
        1,
        "accepted drag should reach the app's drop callback"
    );
    assert_eq!(
        drops[0].0,
        vec![0, 1],
        "a selected drag should move the selected roots together"
    );
    assert_eq!(
        drops[0].1,
        DropPosition {
            parent: None,
            index: 2
        }
    );
}

#[gpui::test]
fn rename_validation_keeps_editor_open_and_blur_commits_but_escape_cancels(
    cx: &mut TestAppContext,
) {
    let (model, _selected, renamed, _row_contexts, _handle, cx) =
        setup(cx, Model::roots(4), vec![], None, None, None, None);

    click_row(cx, 0, Modifiers::none());
    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("invalid");
    cx.simulate_keystrokes("enter");
    assert_eq!(model.borrow().nodes[0].label, "row 0");
    assert_eq!(
        renamed.borrow().last().cloned(),
        Some((0, "invalid".to_owned()))
    );

    cx.simulate_keystrokes("escape");
    click_row(cx, 1, Modifiers::none());
    assert_eq!(model.borrow().nodes[0].label, "row 0");
    assert_eq!(
        renamed.borrow().len(),
        1,
        "Escape must discard the rejected value before later blur"
    );

    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("blur commit");
    click_row(cx, 2, Modifiers::none());
    assert_eq!(model.borrow().nodes[1].label, "blur commit");
    assert_eq!(
        renamed.borrow().last().cloned(),
        Some((1, "blur commit".to_owned())),
        "leaving a valid edit should commit it once"
    );
}

#[gpui::test]
fn rejected_rename_does_not_leak_to_the_next_edited_row(cx: &mut TestAppContext) {
    let (model, _selected, renamed, row_contexts, _handle, cx) =
        setup(cx, Model::roots(4), vec![], None, None, None, None);

    click_row(cx, 0, Modifiers::none());
    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("invalid");
    cx.simulate_keystrokes("enter");
    assert_eq!(
        renamed.borrow().last().cloned(),
        Some((0, "invalid".into()))
    );
    assert_eq!(model.borrow().nodes[0].label, "row 0");

    cx.simulate_keystrokes("escape");
    click_row(cx, 1, Modifiers::none());
    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("row B");
    assert!(
        row_contexts
            .borrow()
            .iter()
            .any(|(id, editing, error)| *id == 1 && *editing && error.is_none())
    );
    cx.simulate_keystrokes("enter");

    assert_eq!(renamed.borrow().last().cloned(), Some((1, "row B".into())));
    assert_eq!(model.borrow().nodes[1].label, "row B");
    assert!(
        !row_contexts
            .borrow()
            .iter()
            .any(|(id, _editing, error)| *id == 1 && error.is_some())
    );
}

#[gpui::test]
fn clicking_inside_editor_places_the_caret_without_stealing_focus(cx: &mut TestAppContext) {
    let (model, _selected, _renamed, _row_contexts, _handle, cx) =
        setup(cx, Model::roots(4), vec![], None, None, None, None);

    click_row(cx, 0, Modifiers::none());
    cx.simulate_keystrokes("f2");
    // The input spans the row; clicking at its far end must place the caret there
    // while the editor retains focus.
    cx.simulate_click(point(px(600.), px(12.)), Modifiers::none());
    cx.simulate_input("X");
    cx.simulate_keystrokes("enter");

    assert_eq!(model.borrow().nodes[0].label, "row 0X");
}

#[gpui::test]
fn double_clicking_static_label_midpoint_opens_editor_at_caret(cx: &mut TestAppContext) {
    let (model, _selected, _renamed, row_contexts, _handle, cx) =
        setup(cx, Model::roots(4), vec![], None, None, None, None);
    model.borrow_mut().nodes[0].label = "row 猫".into();
    cx.update(|window, _| window.refresh());
    cx.run_until_parked();

    // Measure with the same inherited text style as the static label. The row
    // has a 16px disclosure slot and a 4px flex gap before the label.
    let midpoint_x = cx.update(|window, _| {
        let text = "row 猫";
        let style = window.text_style();
        let run = style.to_run(text.len());
        let width = window
            .text_system()
            .shape_line(
                text.into(),
                style.font_size.to_pixels(window.rem_size()),
                &[run],
                None,
            )
            .width();
        px(20.) + width / 2.
    });
    let midpoint = point(midpoint_x, px(12.));
    cx.simulate_event(gpui::MouseDownEvent {
        button: gpui::MouseButton::Left,
        position: midpoint,
        modifiers: Modifiers::none(),
        click_count: 2,
        first_mouse: false,
    });
    cx.simulate_event(gpui::MouseUpEvent {
        button: gpui::MouseButton::Left,
        position: midpoint,
        modifiers: Modifiers::none(),
        click_count: 2,
    });
    cx.simulate_input("X");
    cx.simulate_keystrokes("enter");

    assert!(
        row_contexts
            .borrow()
            .iter()
            .any(|(id, editing, _)| *id == 0 && *editing)
    );
    let label = model.borrow().nodes[0].label.clone();
    let inserted_at = label.find('X').expect("typed text should be inserted");
    assert!(
        inserted_at > 0 && inserted_at < label.len() - 1,
        "click should place the caret inside the Unicode label: {label}"
    );
}

#[gpui::test]
fn handle_operations_reveal_focus_select_rename_and_expand(cx: &mut TestAppContext) {
    let (model, selected, _renamed, _row_contexts, handle, cx) =
        setup(cx, Model::with_branch(), vec![], None, None, None, None);

    assert!(cx.update(|_, app| handle.reveal(model.as_ref(), 4, app)));
    assert_eq!(cx.update(|_, app| handle.expanded_ids(app)), vec![0]);
    assert!(cx.update(|_, app| handle.focus_item(model.as_ref(), 4, app)));
    assert_eq!(cx.update(|_, app| handle.focused_id(app)), Some(4));
    cx.update(|_, app| handle.select_ids(model.as_ref(), [5, 4, 999], app));
    assert_eq!(cx.update(|_, app| handle.selected_ids(app)), vec![5, 4]);
    assert_eq!(selected.borrow().last(), Some(&vec![5, 4]));
    assert!(cx.update(|_, app| handle.start_rename(4, app)));
    assert!(cx.update(|_, app| handle.set_expanded(model.as_ref(), 0, false, app)));
    assert!(!cx.update(|_, app| handle.start_rename(4, app)));
}

#[gpui::test]
fn collapsing_a_branch_cancels_an_edit_on_its_hidden_child(cx: &mut TestAppContext) {
    let (model, _selected, renamed, _row_contexts, handle, cx) =
        setup(cx, Model::with_branch(), vec![0], None, None, None, None);

    click_content(cx, 1);
    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("unsaved hidden edit");
    assert!(cx.update(|_, app| handle.set_expanded(model.as_ref(), 0, false, app)));
    cx.run_until_parked();
    click_content(cx, 1);

    assert_eq!(model.borrow().nodes[4].label, "child a");
    assert!(
        renamed.borrow().iter().all(|(id, _)| *id != 4),
        "collapsing an edited row's ancestor must not commit its hidden draft"
    );
}

#[gpui::test]
fn selection_callback_reports_pruned_ids_after_model_deletion(cx: &mut TestAppContext) {
    let (model, selected, _renamed, _row_contexts, handle, cx) =
        setup(cx, Model::roots(5), vec![], None, None, None, None);

    cx.update(|_, app| handle.select_ids(model.as_ref(), [1, 3], app));
    cx.run_until_parked();
    model.borrow_mut().roots.retain(|id| *id != 3);
    cx.update(|_, app| {
        handle.refresh(
            model.as_ref(),
            TreeChange::ChildRemoved {
                parent: None,
                index: 3,
                removed: vec![3],
            },
            app,
        );
    });
    cx.run_until_parked();

    assert_eq!(cx.update(|_, app| handle.selected_ids(app)), vec![1]);
    assert_eq!(selected.borrow().last(), Some(&vec![1]));
}

#[gpui::test]
fn structural_child_notifications_keep_selection_identity_and_anchor(cx: &mut TestAppContext) {
    let (model, _selected, _renamed, _row_contexts, handle, cx) =
        setup(cx, Model::roots(5), vec![], None, None, None, None);

    click_content(cx, 2);
    cx.update(|_, app| {
        let mut data = model.borrow_mut();
        data.nodes.push(Node {
            parent: None,
            children: Vec::new(),
            label: "inserted".into(),
        });
        data.row_heights.push(24.);
        data.roots.insert(1, 5);
        drop(data);
        handle.refresh(
            model.as_ref(),
            TreeChange::ChildInserted {
                parent: None,
                index: 1,
                inserted: 5,
            },
            app,
        );
    });
    assert_eq!(cx.update(|_, app| handle.selected_ids(app)), vec![2]);
    cx.executor().advance_clock(Duration::from_millis(200));
    cx.run_until_parked();
    cx.update(|window, _| window.refresh());
    cx.run_until_parked();
    click_content_with_modifiers(cx, 5, Modifiers::shift());
    assert_eq!(
        cx.update(|_, app| handle.selected_ids(app)),
        vec![2, 3, 4],
        "the range should extend from the stable anchor identity to row four"
    );
    cx.update(|_, app| handle.select_ids(model.as_ref(), [2], app));

    cx.update(|_, app| {
        let mut data = model.borrow_mut();
        let moved_index = data.roots.iter().position(|id| *id == 2).unwrap();
        data.roots.remove(moved_index);
        data.roots.insert(0, 2);
        drop(data);
        handle.refresh(
            model.as_ref(),
            TreeChange::ChildMoved {
                from_parent: None,
                from_index: moved_index,
                to_parent: None,
                to_index: 0,
                moved: vec![2],
            },
            app,
        );
    });
    assert_eq!(cx.update(|_, app| handle.selected_ids(app)), vec![2]);

    cx.update(|_, app| {
        model.borrow_mut().roots.retain(|id| *id != 2);
        handle.refresh(
            model.as_ref(),
            TreeChange::ChildRemoved {
                parent: None,
                index: 0,
                removed: vec![2],
            },
            app,
        );
    });
    assert!(cx.update(|_, app| handle.selected_ids(app)).is_empty());
}

#[gpui::test]
fn mixed_row_heights_keep_keyboard_and_wheel_targets_aligned(cx: &mut TestAppContext) {
    let mut model = Model::roots(100);
    for (id, height) in model.row_heights.iter_mut().enumerate() {
        *height = match id % 3 {
            0 => 20.,
            1 => 36.,
            _ => 52.,
        };
    }
    let drops = Rc::new(RefCell::new(Vec::new()));
    let (_model, selected, _renamed, row_contexts, _handle, cx) =
        setup(cx, model, vec![], None, None, None, Some(drops.clone()));

    cx.simulate_click(point(px(80.), px(10.)), Modifiers::none());
    cx.simulate_keystrokes("down");
    assert_eq!(selected.borrow().last().cloned(), Some(vec![1]));
    let source = point(px(80.), px(10.));
    let target = point(px(80.), px(160.));
    cx.simulate_mouse_down(source, gpui::MouseButton::Left, Modifiers::none());
    cx.simulate_mouse_move(target, Some(gpui::MouseButton::Left), Modifiers::none());
    cx.simulate_mouse_move(target, Some(gpui::MouseButton::Left), Modifiers::none());
    cx.simulate_mouse_up(target, gpui::MouseButton::Left, Modifiers::none());
    assert_eq!(drops.borrow().len(), 1);
    assert_eq!(
        drops.borrow()[0].1.index,
        5,
        "drop targeting must use heterogeneous row bounds"
    );

    cx.simulate_mouse_move(point(px(80.), px(100.)), None, Modifiers::none());
    cx.simulate_event(gpui::ScrollWheelEvent {
        position: point(px(80.), px(100.)),
        delta: gpui::ScrollDelta::Pixels(point(px(0.), px(-600.))),
        ..Default::default()
    });
    assert!(row_contexts.borrow().iter().any(|row| row.0 >= 20));
}

#[gpui::test]
fn removed_rows_paint_as_inert_snapshots_without_reaccessing_model(cx: &mut TestAppContext) {
    let actions = Rc::new(Cell::new(0));
    let (model, _selected, _renamed, _row_contexts, handle, cx) = setup(
        cx,
        Model::roots(4),
        vec![],
        None,
        Some(actions.clone()),
        None,
        None,
    );

    click_row(cx, 3, Modifiers::none());
    cx.run_until_parked();

    cx.update(|_, app| {
        {
            let mut data = model.borrow_mut();
            data.roots.retain(|id| *id != 3);
            data.forbidden_label_ids.insert(3);
        }
        handle.refresh(
            model.as_ref(),
            TreeChange::ChildRemoved {
                parent: None,
                index: 3,
                removed: vec![3],
            },
            app,
        );
    });
    cx.run_until_parked();

    let exit_pixels = cx.update(|window, _| {
        window.painted_quads().into_iter().any(|quad| {
            let top = quad.bounds.origin.y.as_f32() / window.scale_factor();
            let bottom = top + quad.bounds.size.height.as_f32() / window.scale_factor();
            top < 96. && bottom > 72.
        })
    });
    assert!(
        exit_pixels,
        "the outgoing row should be represented by paint-only quads"
    );

    // Row three used to have an interactive delegate at this position. Once
    // removed, the painted exit must not retain that control's hit target.
    cx.simulate_click(point(px(96.), px(84.)), Modifiers::none());
    assert_eq!(actions.get(), 0, "an exiting row's delegate must be inert");
}

#[gpui::test]
fn removing_an_edited_row_prevents_a_later_blur_commit(cx: &mut TestAppContext) {
    let (model, selected, renamed, _row_contexts, handle, cx) =
        setup(cx, Model::roots(4), vec![], None, None, None, None);

    click_row(cx, 0, Modifiers::none());
    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("must not be saved");
    cx.update(|_, app| {
        model.borrow_mut().roots.retain(|id| *id != 0);
        handle.refresh(
            model.as_ref(),
            TreeChange::NodesRemoved {
                parent: None,
                removed: vec![0],
            },
            app,
        );
    });
    cx.run_until_parked();
    cx.simulate_keystrokes("down");

    assert!(renamed.borrow().iter().all(|(id, _)| *id != 0));
    assert_eq!(model.borrow().nodes[0].label, "row 0");
    assert_eq!(selected.borrow().last(), Some(&vec![2]));
}

#[gpui::test]
fn a_reentrant_model_reset_does_not_restore_a_stale_rename_error(cx: &mut TestAppContext) {
    let mut model = Model::roots(4);
    model.reset_on_rename = true;
    let (_model, _selected, renamed, row_contexts, handle, cx) =
        setup(cx, model, vec![], None, None, None, None);
    click_content(cx, 0);
    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("invalid");
    cx.simulate_keystrokes("enter");
    assert_eq!(&*renamed.borrow(), &[(0, "invalid".to_owned())]);
    assert_eq!(
        row_contexts.borrow().iter().rev().find(|row| row.0 == 0),
        Some(&(0, false, None))
    );
    assert!(cx.update(|_, cx| handle.selected_ids(cx)).is_empty());
}

#[gpui::test]
fn a_model_reset_rejects_an_existing_drag_even_when_ids_are_reused(cx: &mut TestAppContext) {
    let drops = Rc::new(RefCell::new(Vec::new()));
    let (model, _selected, _renamed, _row_contexts, handle, cx) = setup(
        cx,
        Model::roots(5),
        vec![],
        None,
        None,
        None,
        Some(drops.clone()),
    );
    click_content(cx, 0);
    let source = point(px(80.), px(12.));
    let target = point(px(80.), px(60.));
    cx.simulate_mouse_down(source, gpui::MouseButton::Left, Modifiers::none());
    cx.simulate_mouse_move(target, Some(gpui::MouseButton::Left), Modifiers::none());
    cx.simulate_mouse_move(target, Some(gpui::MouseButton::Left), Modifiers::none());
    cx.update(|_, cx| handle.refresh(model.as_ref(), TreeChange::Reset, cx));
    cx.run_until_parked();
    cx.simulate_mouse_move(target, Some(gpui::MouseButton::Left), Modifiers::none());
    cx.simulate_mouse_up(target, gpui::MouseButton::Left, Modifiers::none());
    assert!(drops.borrow().is_empty());
}

#[gpui::test]
fn scrolling_tree_moves_the_virtualized_viewport(cx: &mut TestAppContext) {
    let (_model, _selected, _renamed, row_contexts, _handle, cx) =
        setup(cx, Model::roots(100), vec![], None, None, None, None);
    cx.simulate_mouse_move(point(px(80.), px(100.)), None, Modifiers::none());
    cx.simulate_event(gpui::ScrollWheelEvent {
        position: point(px(80.), px(100.)),
        delta: gpui::ScrollDelta::Pixels(point(px(0.), px(-600.))),
        ..Default::default()
    });
    assert!(row_contexts.borrow().iter().any(|row| row.0 >= 20));
}

#[gpui::test]
fn scrolling_an_editor_offscreen_keeps_its_input_and_commit_alive(cx: &mut TestAppContext) {
    let (model, _selected, renamed, row_contexts, _handle, cx) =
        setup(cx, Model::roots(100), vec![], None, None, None, None);
    click_content(cx, 0);
    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("draft");
    cx.simulate_mouse_move(point(px(80.), px(100.)), None, Modifiers::none());
    cx.simulate_event(gpui::ScrollWheelEvent {
        position: point(px(80.), px(100.)),
        delta: gpui::ScrollDelta::Pixels(point(px(0.), px(-600.))),
        ..Default::default()
    });
    cx.update(|window, _| window.refresh());
    cx.run_until_parked();
    assert!(row_contexts.borrow().iter().any(|row| row.0 >= 20));
    cx.simulate_input(" after scrolling");
    cx.simulate_keystrokes("enter");
    assert_eq!(model.borrow().nodes[0].label, "draft after scrolling");
    assert_eq!(
        &*renamed.borrow(),
        &[(0, "draft after scrolling".to_owned())]
    );
}

#[gpui::test]
fn moving_an_edited_row_offscreen_keeps_its_editor_attached(cx: &mut TestAppContext) {
    let (model, _selected, renamed, row_contexts, handle, cx) =
        setup(cx, Model::roots(100), vec![], None, None, None, None);

    click_content(cx, 0);
    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("draft");
    cx.simulate_mouse_move(point(px(80.), px(100.)), None, Modifiers::none());
    cx.simulate_event(gpui::ScrollWheelEvent {
        position: point(px(80.), px(100.)),
        delta: gpui::ScrollDelta::Pixels(point(px(0.), px(-600.))),
        ..Default::default()
    });
    cx.update(|window, _| window.refresh());
    cx.run_until_parked();
    row_contexts.borrow_mut().clear();
    cx.update(|_, app| {
        {
            let mut data = model.borrow_mut();
            let moved = data.roots.remove(0);
            data.roots.insert(90, moved);
        }
        handle.refresh(
            model.as_ref(),
            TreeChange::ChildMoved {
                from_parent: None,
                from_index: 0,
                to_parent: None,
                to_index: 90,
                moved: vec![0],
            },
            app,
        );
    });
    cx.update(|window, _| window.refresh());
    cx.run_until_parked();
    assert!(
        row_contexts.borrow().iter().any(|row| row.0 == 0),
        "the focused editor must remain materialized after moving outside the viewport"
    );
    cx.simulate_input(" after move");
    cx.simulate_keystrokes("enter");

    assert_eq!(model.borrow().nodes[0].label, "draft after move");
    assert_eq!(
        &*renamed.borrow(),
        &[(0, "draft after move".to_owned())],
        "the offscreen move should preserve one active editor for the same identity"
    );
}

#[gpui::test]
fn changing_row_density_keeps_an_offscreen_editor_materialized(cx: &mut TestAppContext) {
    let (model, _selected, renamed, row_contexts, _handle, cx) =
        setup(cx, Model::roots(100), vec![], None, None, None, None);
    click_content(cx, 0);
    cx.simulate_keystrokes("f2 secondary-a");
    cx.simulate_input("draft");
    cx.simulate_event(gpui::ScrollWheelEvent {
        position: point(px(80.), px(100.)),
        delta: gpui::ScrollDelta::Pixels(point(px(0.), px(-600.))),
        ..Default::default()
    });
    cx.update(|window, _| window.refresh());
    cx.run_until_parked();
    {
        let mut data = model.borrow_mut();
        data.default_row_height = 32.;
        data.row_heights.fill(32.);
    }
    row_contexts.borrow_mut().clear();
    cx.update(|window, _| window.refresh());
    cx.run_until_parked();
    assert!(row_contexts.borrow().iter().any(|row| row.0 == 0));
    cx.simulate_input(" after density change");
    cx.simulate_keystrokes("enter");
    assert_eq!(model.borrow().nodes[0].label, "draft after density change");
    assert_eq!(
        &*renamed.borrow(),
        &[(0, "draft after density change".to_owned())]
    );
}

#[gpui::test]
fn a_stationary_drag_at_the_viewport_edge_scrolls_before_drop(cx: &mut TestAppContext) {
    let drops = Rc::new(RefCell::new(Vec::new()));
    let (_model, _selected, _renamed, _row_contexts, _handle, cx) = setup(
        cx,
        Model::roots(100),
        vec![],
        None,
        None,
        None,
        Some(drops.clone()),
    );

    click_content(cx, 0);
    let source = point(px(80.), px(12.));
    let edge = point(px(80.), px(179.));
    cx.simulate_mouse_down(source, gpui::MouseButton::Left, Modifiers::none());
    cx.simulate_mouse_move(edge, Some(gpui::MouseButton::Left), Modifiers::none());
    cx.simulate_mouse_move(edge, Some(gpui::MouseButton::Left), Modifiers::none());
    cx.run_until_parked();
    for _ in 0..20 {
        cx.executor().advance_clock(Duration::from_millis(50));
        cx.run_until_parked();
    }
    cx.simulate_mouse_up(edge, gpui::MouseButton::Left, Modifiers::none());

    let drops = drops.borrow();
    assert_eq!(
        drops.len(),
        1,
        "stationary edge drag should keep its drop session active"
    );
    assert!(
        drops[0].1.parent.unwrap_or(drops[0].1.index) > 8,
        "edge dwell should scroll beyond the initial viewport before drop, got {:?}",
        drops[0].1
    );
}
