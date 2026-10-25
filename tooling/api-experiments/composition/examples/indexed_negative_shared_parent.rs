use gpui_composition_api_experiment::indexed::{
    EmptyGroup, LeftCapability, ReflectedElement, RightCapability, SharedToken,
};

fn main() {
    let group = ReflectedElement::<EmptyGroup>::new()
        .with(LeftCapability)
        .with(RightCapability);
    let _ = group.narrow::<SharedToken, _>();
}
