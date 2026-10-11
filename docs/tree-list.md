# Tree list

`gpui_ce_elements::tree_list` is a model-backed tree view for editable, nested data. The widget owns the visible projection and interaction state; the application owns node identity, data, mutation policy, and persistence. This boundary keeps a tree useful for files, outlines, mailboxes, scene graphs, and other hierarchies without making the component a filesystem widget.

## Model contract

Implement `TreeModel<Id>` for a read-only view of your application model. `Id` should be a stable identity (for example a database key or `Arc`-backed key), not a row number or label. The model provides indexed root and child access, parent lookup, and membership checks. Keep indexed access inexpensive because the view asks for children while building its visible preorder.

The demo uses an app-owned in-memory model with a `HashMap` of nodes and ordered child ID vectors. It implements `TreeModel` on a local `DemoModel` wrapper that owns a `RefCell<DemoTree>`. This lets the widget read through the trait while app actions mutate the same data. The adapter and full implementation live in [the example](../crates/gpui_elements/examples/tree_list.rs); applications with asynchronous or transactional data can implement the trait over their own store.

```rust,ignore
struct DemoModel {
    tree: RefCell<DemoTree>,
}

impl TreeModel<NodeId> for DemoModel {
    fn roots_len(&self) -> usize { self.tree.borrow().roots.len() }
    fn root_at(&self, index: usize) -> Option<NodeId> {
        self.tree.borrow().roots.get(index).copied()
    }
    fn child_count(&self, parent: &NodeId) -> usize {
        self.tree.borrow().nodes.get(parent).map_or(0, |node| node.children.len())
    }
    fn child_at(&self, parent: &NodeId, index: usize) -> Option<NodeId> {
        self.tree.borrow().nodes.get(parent)?.children.get(index).copied()
    }
    fn parent(&self, id: &NodeId) -> Option<NodeId> {
        self.tree.borrow().nodes.get(id)?.parent
    }
    fn contains(&self, id: &NodeId) -> bool {
        self.tree.borrow().nodes.contains_key(id)
    }
    // Override when the model knows a node is a branch before children exist.
    fn is_branch(&self, id: &NodeId) -> bool {
        self.tree.borrow().nodes.get(id).is_some_and(|node| node.folder)
    }
}
```

The trait is deliberately structural. Keep labels, icons, checked or pinned state, permissions, and persistence in your application model or row delegate. Use immutable IDs through rename and move operations so selection and focus do not depend on changing text.

Construct the widget from the same shared model, a stable element ID, and a label projection. Store the handle in the owning view so external controls can report changes later:

```rust,ignore
let label_model = model.clone();
let rename_model = model.clone();
let rename_handle = tree_handle.clone();
let tree = tree_list(model.clone(), "files", move |id| {
    label_model.borrow().nodes.get(id)
        .map_or_else(|| SharedString::from("<removed>"), |node| node.label.clone().into())
})
.handle(tree_handle.clone())
.row_height(px(28.)) // fixed height used by each row and scroll geometry
.on_rename(move |id, new_name, _, cx| {
    rename_model.borrow_mut().rename(*id, new_name).map_err(SharedString::from)?;
    rename_handle.refresh(rename_model.as_ref(), TreeChange::DataChanged { id: *id }, cx);
    Ok(())
});
```

Call `gpui_ce_elements::init(cx)` once during application startup to register the default editable-text bindings used by the inline rename field. Register application-specific overrides after it.

## Rendering and interaction

Create a tree view with a shared model and a label projection. The optional row renderer receives the default label slot and owns its layout, so it can place that slot beside application controls without rebuilding the label or editing field. The example adds a pin button to demonstrate that a control inside a row can have its own action while the rest of the row remains selectable.

The example demonstrates keyboard navigation, multi-selection, modifier selection, range selection, and selection retention while a branch is collapsed. Its workspace explorer uses folder/file glyphs, per-row metadata, pin actions, and folder-aware row heights. The density control switches between compact and comfortable rows, while the reduced-motion control lets you compare animated and immediate structural updates. “Reveal sample” expands the path to a known file, scrolls it into view, focuses it, and selects it through the external handle API. “Rename sample” starts editing through that same handle. F2 starts renaming and selects the full name; double-click starts editing at the pointer caret. Enter commits and Escape cancels. Rename validation belongs to the application callback, which can return an error for the UI to show. Drag and drop reports a resolved insertion position to the application. The application performs and persists the actual move in its model.

The model must be changed before reporting a notification. Attach a `TreeListHandle` and call `refresh` through it after a mutation:

```rust,ignore
let handle = TreeListHandle::<NodeId>::default();
let tree = tree_list(model.clone(), "files", label).handle(handle.clone());

// After inserting a child into `parent`:
handle.refresh(
    model.as_ref(),
    TreeChange::ChildrenChanged { parent: Some(parent) },
    cx,
);
```

Use the precise child notifications when the mutation has exact sibling indexes. `ChildInserted { parent, index, inserted }` identifies one inserted child in the already-updated sibling list. `ChildRemoved { parent, index, removed }` identifies its old index and the removed subtree IDs in preorder; capture those IDs before mutating the model. `ChildMoved { from_parent, from_index, to_parent, to_index, moved }` reports a subtree move using the final destination index. These notifications update the cached visible projection with a narrow splice. For batched changes, `ChildrenChanged { parent }` refreshes an affected sibling list; use `parent: None` when the root list changes. `NodesRemoved { parent, removed }` prunes removed IDs and any IDs no longer present in the model. `NodesMoved { from_parent, to_parent, moved }` applies a batched move as one projection rebuild. `DataChanged { id }` reports a row-content change whose structure stayed the same. `Reset` clears ID-associated expansion, focus, and selection state before rebuilding after a logical model replacement, even if the replacement reuses IDs. Prefer the narrowest notification that accurately describes the change.

The handle exposes `selected_ids(cx)`, `expanded_ids(cx)`, and `focused_id(cx)` for sibling UI such as an inspector or action bar. `set_expanded(model, id, expanded, cx)` changes a branch from an external control; `reveal(model, id, cx)` expands its ancestor chain and scrolls it into view; `focus_item(model, id, cx)` reveals and focuses it; `select_ids(model, ids, cx)` replaces selection; and `start_rename(id, cx)` begins an edit for a visible row. The example’s Reveal sample and Rename sample controls exercise these operations. Hidden selected IDs are included in selection insertion order.

Moves should be validated against the current model before mutation: reject missing IDs, cycles, protected destinations, and stale insertion positions. The drop callback receives dragged IDs and a resolved insertion position identifying the destination parent and index before the move. The demo reduces selected descendants when an ancestor is already being moved, keeps row order, adjusts same-list insertion indexes, performs the model operation, then reports `NodesMoved`. Persist the model operation as one logical change so observers do not see an intermediate detached node.

## Example

Run the interactive explorer from the workspace root:

```sh
cargo run -p gpui_ce_elements --example tree_list
```

The example calls `gpui_ce_elements::init(cx)` at the beginning of `App::run`, before opening its window. Applications should do the same once during startup so Enter, Escape, and text selection shortcuts work in the built-in rename editor.

The sample has an editable project tree, per-row metadata, pin actions, add/delete controls, density and motion toggles, and lazily generated 100,000- or 1,000,000-row stress branches. Generated rows use deterministic stable IDs and are synthesized by indexed model access, so the example does not allocate a million node records to exercise virtualization. Its model uses stable integer IDs and ordered child vectors for ordinary project data. It is intentionally an in-memory demonstration; restarting the program resets changes.

## Current scope

The component is early and its API may evolve. The current implementation supports fixed or model-provided row heights through `row_height_for`, tree navigation, range and modifier selection, hidden-selection retention, inline rename, validated internal row drag and drop with a before/inside/after preview, edge autoscroll, and expansion after a 600 ms drag-hover dwell. A model-provided height callback gives the virtual list exact per-row heights; report `DataChanged` if a row's height changes. Structural transitions are bounded to rows already materialized by the viewport, and reduced-motion mode skips them. The platform's reduced-motion preference is always honored even when the builder override requests motion. Async persistence is not included in this example. Consult the source and example for the behavior available in the current checkout.

Only expanded branches enter the cached projection, and rendering builds viewport rows. Precise indexed insert, remove, and move notifications read only the changed subtree and the indexed destination slot or preceding sibling; updating positional indexes still scans the affected cached suffix. Bulk changes rebuild the visible projection and its identity index. Both paths retain a dense row vector, so mutations do not have logarithmic cost. Projection traversals keep one sibling cursor per active depth, bounding pending traversal work by tree depth; cycle detection still keeps a set proportional to visited IDs. Structural motion keeps at most 256 materialized rows and paint-only outgoing snapshots under an 8 MiB budget. Rows whose capture returns no snapshot, exceeds the budget, or contains unsupported scene content, including shaders, surfaces, or backdrop effects, skip exit snapshot animation. Removed rows leave the model, selection, and hit testing immediately; a captured image may fade out briefly. Surviving and inserted rows animate their layout. The platform's reduced-motion preference or the builder override also skips snapshot animation. Model resets invalidate active edits and drag payloads, including resets that reuse IDs.

## Design references

- [Trees documentation](https://trees.software/docs) demonstrates a path-first identity model, separation between model state and rendering, explicit rename/drop callbacks, and prepared data for larger trees.
- [Lobsters: “A 2026 Survey of Rust GUI Libraries” discussion](https://lobste.rs/c/pvnhd2) sets a higher bar for tree components: scalable visible-row rendering, adaptable models and custom delegates, multi-selection that survives collapse, keyboard interaction, interactive controls inside rows, granular model notifications, and drag feedback. It also points out that tree views share implementation concerns with virtual lists.
- [Qt model/view programming](https://doc.qt.io/qt-6/model-view-programming.html) is a useful reference for separating data models from views and notifying views about precise mutations.
- [React Arborist](https://github.com/brimdata/react-arborist) is a practical reference for editable, virtualized tree interactions in an application framework.

These are design references, not claims of feature parity. The generated stress branch is an exercise for scrolling and projection; it is not a benchmark or a guarantee for arbitrarily large trees.
