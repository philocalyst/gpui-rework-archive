use accesskit::{ActionHandler, ActionRequest, Node, NodeId, Role, TreeId, TreeInfo, TreeUpdate};
use accesskit_atspi_common::{
    Adapter, AdapterCallback, AppContext, Event, FullNodeId, PlatformRoot, WindowBounds,
};
struct NoAction;
impl ActionHandler for NoAction {
    fn do_action(&mut self, _: ActionRequest) {}
}
struct NoCallback;
impl AdapterCallback for NoCallback {
    fn register_interfaces(
        &self,
        _: &Adapter,
        _: FullNodeId,
        _: accesskit_atspi_common::InterfaceSet,
    ) {
    }
    fn unregister_interfaces(
        &self,
        _: &Adapter,
        _: FullNodeId,
        _: accesskit_atspi_common::InterfaceSet,
    ) {
    }
    fn emit_event(&self, _: &Adapter, _: Event) {}
}
fn adapters() -> (Vec<Adapter>, PlatformRoot) {
    let app = AppContext::new(None);
    let adapters = [9, 3, 7]
        .into_iter()
        .map(|id| {
            let mut window = Node::new(Role::Window);
            window.set_label(format!("window {id}"));
            Adapter::with_id(
                id,
                &app,
                NoCallback,
                TreeUpdate {
                    nodes: vec![(NodeId(1), window)],
                    tree: Some(TreeInfo::new(NodeId(1))),
                    tree_id: TreeId::ROOT,
                    focus: NodeId(1),
                },
                false,
                WindowBounds::default(),
                NoAction,
            )
        })
        .collect::<Vec<_>>();
    let root = adapters[0].platform_root();
    (adapters, root)
}
#[test]
fn out_of_order_actual_native_children_keep_their_append_ordinals() {
    let (_adapters, root) = adapters();
    assert_eq!(
        root.map_child_ids::<Vec<_>, _>(|child| child.0).unwrap(),
        vec![9, 3, 7]
    );
    for index in 0..3 {
        let node = root.child_at_index(index).unwrap().unwrap();
        assert_eq!(node.index_in_parent().unwrap(), index as i32);
        assert_eq!(node.cache_node().unwrap().index_in_parent, index as i32);
    }
}
#[test]
fn removing_out_of_order_actual_adapter_releases_native_tree() {
    let (mut adapters, root) = adapters();
    drop(adapters.remove(0));
    assert_eq!(
        root.map_child_ids::<Vec<_>, _>(|child| child.0).unwrap(),
        vec![3, 7]
    );
}
