use gpui::prelude::*;
struct Model(u32);
impl Model {
    fn increment(&mut self) {
        self.0 += 1;
    }
}
impl View for Model {
    fn view(&self) -> El<'_> {
        button("Unit route").w(120).h(32).on_click(Self::increment)
    }
}
#[test]
fn ordinary_unit_action_cost() {
    let mut owner = None;
    let mount = allocation_counter::measure(|| owner = Some(Win::new(Model(0)).unwrap()));
    let mut owner = owner.unwrap();
    let target = owner.button("Unit route");
    owner.click(target).unwrap();
    let action = allocation_counter::measure(|| {
        owner.click(target).unwrap();
    });
    assert_eq!(owner.root().unwrap().0, 2);
    println!(
        "ordinary_unit_cost,Win={},El={},mount_count={},mount_requested={},mount_retained={},action_count={},action_requested={},action_retained={}",
        size_of_val(&owner),
        size_of::<El<'_>>(),
        mount.count_total,
        mount.bytes_total,
        mount.bytes_current,
        action.count_total,
        action.bytes_total,
        action.bytes_current
    );
}
