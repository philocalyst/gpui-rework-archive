use gpui::{Color, El, IntoHandler, IntoProp, button};

/// Independent component configuration, with no GPUI property registration.
pub struct Appearance<F = Color, G = f32> {
    pub fill: F,
    pub ink: Color,
    pub gap: G,
}
pub fn choice<'a, M: 'static, S, H, F, G>(label: &'a str, appearance: Appearance<F, G>, activate: H) -> El<'a>
where
    H: IntoHandler<M, S>,
    F: IntoProp<'a, Color>,
    G: IntoProp<'a, f64>,
{
    button(label).bg(appearance.fill).fg(appearance.ink).gap(appearance.gap)
        .w(120).h(30).on_click(activate)
}
