//! Editable project-tree example. Run with `cargo run -p gpui_ce_elements --example tree_list`.

use std::{
    cell::{Ref, RefCell, RefMut},
    collections::HashMap,
    rc::Rc,
};

use gpui::{
    App, Bounds, Context, SharedString, Window, WindowBounds, WindowOptions, div, prelude::*, px,
    rgb, size,
};
use gpui_ce_elements::tree_list::{
    DropPosition, TreeChange, TreeListHandle, TreeModel, reduce_drag_roots, tree_list,
};

#[path = "../../gpui/examples/example_support/fonts.rs"]
mod example_support;

type NodeId = u64;

struct Node {
    label: String,
    parent: Option<NodeId>,
    children: Vec<NodeId>,
    pinned: bool,
    folder: bool,
    detail: String,
}

#[derive(Default)]
struct DemoTree {
    roots: Vec<NodeId>,
    nodes: HashMap<NodeId, Node>,
    next_id: NodeId,
    generated_branch: Option<(NodeId, usize)>,
}

/// Local shared adapter: the widget reads through `TreeModel`, while app
/// actions mutate the same backing tree through interior mutability.
struct DemoModel {
    tree: RefCell<DemoTree>,
}

impl DemoModel {
    fn borrow(&self) -> Ref<'_, DemoTree> {
        self.tree.borrow()
    }

    fn borrow_mut(&self) -> RefMut<'_, DemoTree> {
        self.tree.borrow_mut()
    }
}

impl DemoTree {
    fn insert(&mut self, parent: Option<NodeId>, index: usize, label: impl Into<String>) -> NodeId {
        self.insert_kind(parent, index, label, false, "")
    }

    fn insert_kind(
        &mut self,
        parent: Option<NodeId>,
        index: usize,
        label: impl Into<String>,
        folder: bool,
        detail: impl Into<String>,
    ) -> NodeId {
        let id = self.next_id;
        self.next_id += 1;
        self.nodes.insert(
            id,
            Node {
                label: label.into(),
                parent,
                children: Vec::new(),
                pinned: false,
                folder,
                detail: detail.into(),
            },
        );
        let siblings = self.children_mut(parent);
        siblings.insert(index.min(siblings.len()), id);
        id
    }

    fn children(&self, parent: Option<NodeId>) -> &[NodeId] {
        match parent {
            Some(id) => self
                .nodes
                .get(&id)
                .map_or(&[], |node| node.children.as_slice()),
            None => &self.roots,
        }
    }

    fn generated_id(index: usize) -> NodeId {
        (1 << 63) | index as NodeId
    }
    fn generated_index(id: NodeId) -> Option<usize> {
        (id & (1 << 63) != 0).then_some((id & !(1 << 63)) as usize)
    }
    fn generated_count(&self) -> usize {
        self.generated_branch.map_or(0, |(_, count)| count)
    }
    fn label(&self, id: NodeId) -> Option<String> {
        if let Some(index) = Self::generated_index(id) {
            return (index < self.generated_count())
                .then(|| format!("generated-file-{index:06}.rs"));
        }
        self.nodes.get(&id).map(|node| node.label.clone())
    }
    fn is_folder(&self, id: NodeId) -> bool {
        if Self::generated_index(id).is_some() {
            return false;
        }
        self.nodes.get(&id).is_some_and(|node| node.folder)
    }
    fn detail(&self, id: NodeId) -> String {
        if let Some(index) = Self::generated_index(id) {
            return format!("{:>4} KB", index % 128 + 1);
        }
        self.nodes
            .get(&id)
            .map_or_else(String::new, |node| node.detail.clone())
    }

    fn children_mut(&mut self, parent: Option<NodeId>) -> &mut Vec<NodeId> {
        match parent {
            Some(id) => &mut self.nodes.get_mut(&id).expect("parent exists").children,
            None => &mut self.roots,
        }
    }

    fn rename(&mut self, id: NodeId, name: &str) -> Result<(), String> {
        let name = name.trim();
        if name.is_empty() {
            return Err("A name cannot be empty".into());
        }
        if name.contains('/') {
            return Err("Names cannot contain '/'".into());
        }
        self.nodes
            .get_mut(&id)
            .ok_or("This item no longer exists")?
            .label = name.to_owned();
        Ok(())
    }

    fn remove_subtree(&mut self, id: NodeId) -> Vec<NodeId> {
        let Some(parent) = self.nodes.get(&id).and_then(|node| node.parent) else {
            self.roots.retain(|candidate| *candidate != id);
            return self.remove_nodes(id);
        };
        self.children_mut(Some(parent))
            .retain(|candidate| *candidate != id);
        self.remove_nodes(id)
    }

    fn remove_nodes(&mut self, id: NodeId) -> Vec<NodeId> {
        let mut removed = Vec::new();
        let mut stack = vec![id];
        while let Some(id) = stack.pop() {
            if let Some(node) = self.nodes.remove(&id) {
                stack.extend(node.children.iter().copied());
                removed.push(id);
            }
        }
        removed
    }

    fn move_nodes(
        &mut self,
        ids: &[NodeId],
        parent: Option<NodeId>,
        mut index: usize,
    ) -> Result<(), String> {
        if let Some(parent_id) = parent {
            if !self.nodes.contains_key(&parent_id) {
                return Err("The destination no longer exists".into());
            }
        }
        let selected: std::collections::HashSet<_> = ids.iter().copied().collect();
        if ids.iter().any(|id| !self.nodes.contains_key(id)) {
            return Err("A moved item no longer exists".into());
        }
        let roots: Vec<_> = ids
            .iter()
            .copied()
            .filter(|id| {
                let mut ancestor = self.nodes.get(id).and_then(|node| node.parent);
                while let Some(parent_id) = ancestor {
                    if selected.contains(&parent_id) {
                        return false;
                    }
                    ancestor = self.nodes.get(&parent_id).and_then(|node| node.parent);
                }
                true
            })
            .collect();
        for id in &roots {
            let mut ancestor = parent;
            while let Some(parent_id) = ancestor {
                if parent_id == *id {
                    return Err("An item cannot be moved into its own descendant".into());
                }
                ancestor = self.nodes.get(&parent_id).and_then(|node| node.parent);
            }
        }
        let mut positions = HashMap::new();
        for id in &roots {
            let old_parent = self.nodes.get(id).and_then(|node| node.parent);
            if let Some(old_index) = self
                .children(old_parent)
                .iter()
                .position(|candidate| candidate == id)
            {
                positions.insert(*id, (old_parent, old_index));
            }
        }
        index -= positions
            .values()
            .filter(|(old_parent, old_index)| *old_parent == parent && *old_index < index)
            .count();
        // The widget passes reduced drag roots in current model preorder; keep
        // that order so moving a large selection does not scan the whole tree.
        let mut removals: Vec<_> = positions.values().copied().collect();
        removals
            .sort_by_key(|(old_parent, old_index)| (*old_parent, std::cmp::Reverse(*old_index)));
        for (old_parent, old_index) in removals {
            self.children_mut(old_parent).remove(old_index);
        }
        let max_index = self.children(parent).len();
        index = index.min(max_index);
        self.children_mut(parent)
            .splice(index..index, roots.iter().copied());
        for id in roots {
            self.nodes.get_mut(&id).expect("moved item exists").parent = parent;
        }
        Ok(())
    }
}

impl TreeModel<NodeId> for DemoModel {
    fn roots_len(&self) -> usize {
        self.tree.borrow().roots.len()
    }
    fn root_at(&self, index: usize) -> Option<NodeId> {
        self.tree.borrow().roots.get(index).copied()
    }
    fn child_count(&self, parent: &NodeId) -> usize {
        let tree = self.tree.borrow();
        if DemoTree::generated_index(*parent).is_some() {
            return 0;
        }
        if tree.generated_branch.is_some_and(|(id, _)| id == *parent) {
            return tree.generated_count();
        }
        tree.nodes.get(parent).map_or(0, |node| node.children.len())
    }
    fn is_branch(&self, id: &NodeId) -> bool {
        let tree = self.tree.borrow();
        if tree
            .generated_branch
            .is_some_and(|(branch, _)| branch == *id)
        {
            return true;
        }
        tree.nodes.get(id).is_some_and(|node| node.folder)
    }
    fn child_at(&self, parent: &NodeId, index: usize) -> Option<NodeId> {
        let tree = self.tree.borrow();
        if tree.generated_branch.is_some_and(|(id, _)| id == *parent) {
            return (index < tree.generated_count()).then(|| DemoTree::generated_id(index));
        }
        tree.nodes.get(parent)?.children.get(index).copied()
    }
    fn parent(&self, id: &NodeId) -> Option<NodeId> {
        let tree = self.tree.borrow();
        if let Some(index) = DemoTree::generated_index(*id) {
            return (index < tree.generated_count()).then(|| tree.generated_branch.unwrap().0);
        }
        tree.nodes.get(id)?.parent
    }
    fn contains(&self, id: &NodeId) -> bool {
        let tree = self.tree.borrow();
        DemoTree::generated_index(*id).is_some_and(|index| index < tree.generated_count())
            || tree.nodes.contains_key(id)
    }
    fn index_of_child(&self, parent: &NodeId, child: &NodeId) -> Option<usize> {
        let tree = self.tree.borrow();
        if tree
            .generated_branch
            .is_some_and(|(branch, _)| branch == *parent)
        {
            return DemoTree::generated_index(*child)
                .filter(|index| *index < tree.generated_count());
        }
        tree.nodes
            .get(parent)?
            .children
            .iter()
            .position(|candidate| candidate == child)
    }
}

fn demo_model() -> Rc<DemoModel> {
    let mut tree = DemoTree {
        next_id: 1,
        ..Default::default()
    };
    let workspace = tree.insert_kind(None, 0, "gpui-elements", true, "WORKSPACE");
    let src = tree.insert_kind(Some(workspace), 0, "src", true, "12 items");
    let ui = tree.insert_kind(Some(src), 0, "tree_list", true, "4 items");
    tree.insert_kind(Some(ui), 0, "tree_list.rs", false, "18.4 KB");
    tree.insert_kind(Some(ui), 1, "row.rs", false, "9.2 KB");
    tree.insert_kind(Some(ui), 2, "selection.rs", false, "6.8 KB");
    tree.insert_kind(Some(src), 1, "main.rs", false, "2.1 KB");
    let docs = tree.insert_kind(Some(workspace), 1, "docs", true, "3 items");
    tree.insert_kind(Some(docs), 0, "architecture.md", false, "8.6 KB");
    tree.insert_kind(Some(docs), 1, "decisions.md", false, "3.2 KB");
    tree.insert_kind(Some(docs), 2, "release-notes.md", false, "1.4 KB");
    let assets = tree.insert_kind(Some(workspace), 2, "assets", true, "2 items");
    tree.insert_kind(Some(assets), 0, "brand-mark.svg", false, "24 KB");
    tree.insert_kind(Some(assets), 1, "palette.json", false, "1.2 KB");
    tree.insert_kind(None, 1, "Cargo.toml", false, "4.6 KB");
    tree.insert_kind(None, 2, "README.md", false, "6.1 KB");
    Rc::new(DemoModel {
        tree: RefCell::new(tree),
    })
}

struct TreeListExample {
    model: Rc<DemoModel>,
    handle: TreeListHandle<NodeId>,
    selected: Vec<NodeId>,
    status: String,
    stress_id: Option<NodeId>,
    stress_count: usize,
    compact: bool,
    reduced_motion: bool,
}

impl TreeListExample {
    fn button(
        id: &'static str,
        label: impl Into<SharedString>,
        action: impl Fn(&mut Window, &mut App) + 'static,
    ) -> impl IntoElement {
        div()
            .id(id)
            .px_3()
            .py_1()
            .rounded_md()
            .bg(rgb(0x303744))
            .hover(|s| s.bg(rgb(0x414b5b)))
            .text_sm()
            .cursor_pointer()
            .child(label.into())
            .on_click(move |_, window, cx| action(window, cx))
    }

    fn add_item(&mut self, cx: &mut Context<Self>) {
        let anchor = self.selected.last().copied();
        let mut model = self.model.borrow_mut();
        let parent = anchor
            .and_then(|id| {
                model
                    .nodes
                    .get(&id)
                    .map(|node| if !node.folder { node.parent } else { Some(id) })
            })
            .flatten();
        let index = model.children(parent).len();
        model.insert(parent, index, "new item");
        drop(model);
        self.handle.refresh(
            self.model.as_ref(),
            TreeChange::ChildrenChanged { parent },
            cx,
        );
        self.status = "Added a new item".into();
        cx.notify();
    }

    fn delete_selection(&mut self, cx: &mut Context<Self>) {
        if self.selected.is_empty() {
            self.status = "Select rows to remove".into();
            cx.notify();
            return;
        }
        let ids = self.selected.clone();
        let mut model = self.model.borrow_mut();
        let mut removed_events = Vec::new();
        for id in ids {
            if model.nodes.contains_key(&id) {
                let parent = model.nodes.get(&id).and_then(|node| node.parent);
                let removed = model.remove_subtree(id);
                removed_events.push((parent, removed));
            }
        }
        drop(model);
        let removed_count: usize = removed_events
            .iter()
            .map(|(_, removed)| removed.len())
            .sum();
        for (parent, removed) in removed_events {
            self.handle.refresh(
                self.model.as_ref(),
                TreeChange::NodesRemoved { parent, removed },
                cx,
            );
        }
        self.selected.clear();
        self.status = format!("Removed {removed_count} node(s)");
        cx.notify();
    }

    fn toggle_stress(&mut self, cx: &mut Context<Self>) {
        let mut model = self.model.borrow_mut();
        let previous_stress_id = self.stress_id.take();
        let removing = previous_stress_id.is_some();
        if let Some(id) = previous_stress_id {
            model.remove_subtree(id);
            model.generated_branch = None;
            self.status = format!(
                "Removed the {:>7} generated-row stress branch",
                self.stress_count
            );
        } else {
            let root_index = model.roots.len();
            self.stress_count = if self.stress_count == 100_000 {
                1_000_000
            } else {
                100_000
            };
            let id = model.insert_kind(
                None,
                root_index,
                format!("Generated files · {}", self.stress_count),
                true,
                "VIRTUAL",
            );
            model.generated_branch = Some((id, self.stress_count));
            self.stress_id = Some(id);
            self.status = format!(
                "Added {} lazily generated rows; expand and scroll",
                self.stress_count
            );
        }
        drop(model);
        if removing {
            self.handle.refresh(
                self.model.as_ref(),
                TreeChange::NodesRemoved {
                    parent: None,
                    removed: vec![previous_stress_id.unwrap()],
                },
                cx,
            );
        } else {
            self.handle.refresh(
                self.model.as_ref(),
                TreeChange::ChildrenChanged { parent: None },
                cx,
            );
        }
        cx.notify();
    }

    fn reveal_sample(&mut self, cx: &mut Context<Self>) {
        let id = self
            .model
            .borrow()
            .nodes
            .iter()
            .find_map(|(id, node)| (node.label == "tree_list.rs").then_some(*id));
        if let Some(id) = id {
            self.handle.reveal(self.model.as_ref(), id, cx);
            self.handle.focus_item(self.model.as_ref(), id, cx);
            self.handle.select_ids(self.model.as_ref(), [id], cx);
            self.status = format!("Revealed and focused tree_list.rs · #{id}");
        }
        cx.notify();
    }

    fn rename_sample(&mut self, cx: &mut Context<Self>) {
        let id = self
            .model
            .borrow()
            .nodes
            .iter()
            .find_map(|(id, node)| (node.label == "tree_list.rs").then_some(*id));
        if let Some(id) = id {
            self.handle.focus_item(self.model.as_ref(), id, cx);
            self.handle.start_rename(id, cx);
            self.status = "Editing tree_list.rs · Enter saves, Escape cancels".into();
        }
        cx.notify();
    }
}

impl Render for TreeListExample {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let model = self.model.clone();
        let label_model = model.clone();
        let this = cx.entity();
        let tree_handle = self.handle.clone();
        let selected_count = self.selected.len();
        let status = self.status.clone();
        let row_model = model.clone();
        let row_tree_handle = tree_handle.clone();
        let selected_entity = this.clone();
        let rename_model = model.clone();
        let rename_entity = this.clone();
        let drop_model = model.clone();
        let drop_entity = this.clone();

        let tree = tree_list(model.clone(), "project-tree", move |id| {
            SharedString::from(
                label_model
                    .borrow()
                    .label(*id)
                    .unwrap_or_else(|| "<removed>".into()),
            )
        })
        .initially_expanded([1, 2, 3, 8, 12])
        .handle(tree_handle.clone())
        .row_height(px(if self.compact { 24. } else { 32. }))
        .row_height_for({
            let row_model = model;
            let compact = self.compact;
            move |id| {
                px(if compact {
                    24.
                } else if row_model.borrow().is_folder(*id) {
                    32.
                } else {
                    28.
                })
            }
        })
        .reduced_motion(self.reduced_motion)
        .render_row(move |row, label_slot, _window, _cx| {
            let id = row.id;
            let (pinned, folder, detail) = {
                let data = row_model.borrow();
                (
                    data.nodes.get(&id).is_some_and(|node| node.pinned),
                    data.is_folder(id),
                    data.detail(id),
                )
            };
            let pin_model = row_model.clone();
            let pin_handle = row_tree_handle.clone();
            div()
                .flex()
                .items_center()
                .justify_between()
                .flex_1()
                .min_w_0()
                .child(
                    div()
                        .w(px(20.))
                        .text_color(if folder { rgb(0xe8b86d) } else { rgb(0x8da4c3) })
                        .child(if folder { "▰" } else { "◇" }),
                )
                .child(label_slot)
                .child(div().flex_1())
                .child(
                    div()
                        .mr_2()
                        .text_xs()
                        .text_color(rgb(0x7f8a9b))
                        .child(detail),
                )
                .child(
                    div()
                        .id(format!("pin-{}", id))
                        .px_2()
                        .rounded_md()
                        .text_xs()
                        .text_color(if pinned { rgb(0xffd166) } else { rgb(0x788397) })
                        .hover(|s| s.bg(rgb(0x465168)))
                        .cursor_pointer()
                        .child(if pinned { "★" } else { "☆" })
                        .on_click(move |_, _, cx| {
                            if let Some(node) = pin_model.borrow_mut().nodes.get_mut(&id) {
                                node.pinned = !node.pinned;
                            }
                            cx.stop_propagation();
                            pin_handle.refresh(
                                pin_model.as_ref(),
                                TreeChange::DataChanged { id },
                                cx,
                            );
                        }),
                )
                .into_any_element()
        })
        .on_selection_change(move |ids, _, app| {
            let _ = selected_entity.update(app, |this, cx| {
                this.selected = ids;
                cx.notify();
            });
        })
        .on_rename({
            let rename_handle = tree_handle.clone();
            move |id, new_label, _, app| {
                rename_model
                    .borrow_mut()
                    .rename(*id, new_label)
                    .map_err(SharedString::from)?;
                rename_handle.refresh(
                    rename_model.as_ref(),
                    TreeChange::DataChanged { id: *id },
                    app,
                );
                let _ = rename_entity.update(app, |this, cx| {
                    this.status = format!("Renamed node #{id}");
                    cx.notify();
                });
                Ok(())
            }
        })
        .can_drop({
            let validate_model = drop_model.clone();
            move |_, position: &DropPosition<NodeId>| {
                position.parent.is_none_or(|parent| {
                    let model = validate_model.borrow();
                    model
                        .generated_branch
                        .is_none_or(|(generated, _)| generated != parent)
                        && model.nodes.get(&parent).is_some_and(|node| node.folder)
                })
            }
        })
        .on_drop({
            let drop_handle = tree_handle;
            move |ids, position: DropPosition<NodeId>, _, app| {
                let moved_roots = reduce_drag_roots(drop_model.as_ref(), ids);
                let mut model = drop_model.borrow_mut();
                let mut source_groups: HashMap<Option<NodeId>, Vec<NodeId>> = HashMap::new();
                for id in &moved_roots {
                    source_groups
                        .entry(model.nodes.get(id).and_then(|node| node.parent))
                        .or_default()
                        .push(*id);
                }
                model
                    .move_nodes(&moved_roots, position.parent, position.index)
                    .map_err(SharedString::from)?;
                drop(model);
                for (from_parent, moved) in source_groups {
                    drop_handle.refresh(
                        drop_model.as_ref(),
                        TreeChange::NodesMoved {
                            from_parent,
                            to_parent: position.parent,
                            moved,
                        },
                        app,
                    );
                }
                let _ = drop_entity.update(app, |this, cx| {
                    this.status = format!("Moved {} node(s)", ids.len());
                    cx.notify();
                });
                Ok(())
            }
        });

        let add_entity = this.clone();
        let delete_entity = this.clone();
        let stress_entity = this.clone();
        let reveal_entity = this.clone();
        let rename_sample_entity = this.clone();
        let density_entity = this.clone();
        let motion_entity = this;
        div().size_full().bg(rgb(0x171a21)).text_color(rgb(0xe7eaf0)).p_6()
            .flex().flex_col().gap_4()
            .child(div().flex().items_center().justify_between()
                .child(div().flex().flex_col().gap_1()
                    .child(div().text_xl().font_weight(gpui::FontWeight::BOLD).child("Workspace explorer"))
                    .child(div().text_sm().text_color(rgb(0x9ba6b7)).child("gpui-elements  /  src  /  tree_list.rs")))
                .child(div().px_3().py_1().rounded_full().bg(rgb(0x252c37)).text_sm()
                    .child(format!("{selected_count} selected"))))
            .child(div().flex().gap_2()
                .child(Self::button("add-item", "＋ Add", move |_, app| { let _ = add_entity.update(app, |this, cx| this.add_item(cx)); }))
                .child(Self::button("delete-selection", "⌫ Delete", move |_, app| { let _ = delete_entity.update(app, |this, cx| this.delete_selection(cx)); }))
                .child(Self::button("stress-branch", if self.stress_id.is_some() { "Remove stress data" } else { "Generate 100k / 1M" }, move |_, app| { let _ = stress_entity.update(app, |this, cx| this.toggle_stress(cx)); }))
                .child(Self::button("reveal-sample", "⌖ Reveal sample", move |_, app| { let _ = reveal_entity.update(app, |this, cx| this.reveal_sample(cx)); }))
                .child(Self::button("rename-sample", "Rename sample", move |_, app| { let _ = rename_sample_entity.update(app, |this, cx| this.rename_sample(cx)); }))
                .child(Self::button("density-toggle", if self.compact { "Compact rows" } else { "Comfortable rows" }, move |_, app| { let _ = density_entity.update(app, |this, cx| { this.compact = !this.compact; cx.notify(); }); }))
                .child(Self::button("motion-toggle", if self.reduced_motion { "Motion: reduced" } else { "Motion: full" }, move |_, app| { let _ = motion_entity.update(app, |this, cx| { this.reduced_motion = !this.reduced_motion; cx.notify(); }); })))
            .child(div().flex_1().min_h_0().rounded_lg().border_1().border_color(rgb(0x303744)).bg(rgb(0x1d222b)).p_2().child(tree))
            .child(div().text_xs().text_color(rgb(0x9ba6b7))
                .child("Click to select · Ctrl/⌘ click for multi-select · Shift click for range · arrows navigate · F2 or double-click to rename · drag rows to move"))
            .child(div().text_xs().text_color(rgb(0x788397)).child(status))
    }
}

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        gpui_ce_elements::init(cx);
        if !example_support::load_fonts(cx) {
            return;
        }
        let bounds = Bounds::centered(None, size(px(980.0), px(680.0)), cx);
        cx.open_window(
            WindowOptions {
                window_bounds: Some(WindowBounds::Windowed(bounds)),
                ..Default::default()
            },
            |_, cx| {
                cx.new(|_| TreeListExample {
                    model: demo_model(),
                    handle: TreeListHandle::default(),
                    selected: Vec::new(),
                    status: "Ready · expand a branch or start renaming with F2".into(),
                    stress_id: None,
                    stress_count: 0,
                    compact: false,
                    reduced_motion: false,
                })
            },
        )
        .expect("open tree-list example window");
        cx.activate(true);
    });
}
