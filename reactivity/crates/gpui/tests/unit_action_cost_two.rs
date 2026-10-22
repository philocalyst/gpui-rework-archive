include!("unit_action_cost.rs");
struct SecondModel {
    padding: [u8; 256],
    count: u32,
}
impl SecondModel {
    fn increment(&mut self) {
        self.count += 1;
    }
}
impl View for SecondModel {
    fn view(&self) -> El<'_> {
        button("Second unit route")
            .w(120)
            .h(32)
            .on_click(Self::increment)
    }
}
#[test]
fn second_ordinary_unit_action_cost() {
    let mut owner = None;
    let mount = allocation_counter::measure(|| {
        owner = Some(
            Win::new(SecondModel {
                padding: [7; 256],
                count: 0,
            })
            .unwrap(),
        )
    });
    let mut owner = owner.unwrap();
    let target = owner.button("Second unit route");
    owner.click(target).unwrap();
    let action = allocation_counter::measure(|| {
        owner.click(target).unwrap();
    });
    assert_eq!(owner.root().unwrap().count, 2);
    assert_eq!(owner.root().unwrap().padding, [7; 256]);
    println!(
        "second_unit_cost,Win={},El={},mount_count={},mount_requested={},mount_retained={},action_count={},action_requested={},action_retained={}",
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
