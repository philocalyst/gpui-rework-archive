use gpui::{Color, El, IntoHandler, IntoProp, button};

/// This library owns its appearance vocabulary; callers supply values/sources.
pub struct Appearance<F = Color, R = f32> {
    pub fill: F,
    pub ink: Color,
    pub radius: R,
}
pub fn primary<'a, M: 'static, S, H, F, R>(label: &'a str, appearance: Appearance<F, R>, activate: H) -> El<'a>
where
    H: IntoHandler<M, S>,
    F: IntoProp<'a, Color>,
    R: IntoProp<'a, f32>,
{
    button(label).bg(appearance.fill).fg(appearance.ink).rounded(appearance.radius)
        .w(120).h(30).on_click(activate)
}
