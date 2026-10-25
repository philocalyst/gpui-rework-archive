use gpui_composition_api_experiment::indexed::{
    EmptyGroup, InteractiveToken, ReflectedElement, StyledToken,
};

fn main() {
    let repeated = ReflectedElement::<EmptyGroup>::new()
        .with(InteractiveToken)
        .with(StyledToken);
    let _ = repeated.narrow::<StyledToken, _>();
}
