use gpui_composition_api_experiment::indexed::{
    CustomToken, EmptyGroup, Interactive, InteractiveToken, Left, LeftCapability, Parent,
    ParentToken, Projection, ReflectedElement, Right, RightCapability, SharedToken, Styled,
    StyledToken,
};

fn main() {
    let element = ReflectedElement::<EmptyGroup>::new()
        .with(InteractiveToken)
        .with(ParentToken)
        .with(CustomToken);

    // The inherited Styled membership and flag are preserved through later
    // interactive, parent, and user-defined token additions.
    element.bg().on_click().child();

    let with_one_styled = ReflectedElement::<EmptyGroup>::new().with(InteractiveToken);
    let _: Projection<_, StyledToken, _> = with_one_styled.narrow();

    // Once the same marker appears through inheritance and as a direct
    // requirement, callers can select either proof path explicitly.
    let repeated = ReflectedElement::<EmptyGroup>::new()
        .with(InteractiveToken)
        .with(StyledToken);
    let _: Projection<
        _,
        StyledToken,
        Left<Right<Right<gpui_composition_api_experiment::indexed::Here>>>,
    > = repeated.narrow();
    let _: Projection<_, StyledToken, Right<gpui_composition_api_experiment::indexed::Here>> =
        repeated.narrow();

    let shared = ReflectedElement::<EmptyGroup>::new()
        .with(LeftCapability)
        .with(RightCapability);
    let _: Projection<
        _,
        SharedToken,
        Left<Right<Right<gpui_composition_api_experiment::indexed::Here>>>,
    > = shared.narrow();
    let _: Projection<
        _,
        SharedToken,
        Right<Right<gpui_composition_api_experiment::indexed::Here>>,
    > = shared.narrow();
}
