//! Layout helpers share the application's semantic spacing and zoom snapshot.
use crate::{Space, Theme};
use gpui::{Align, ChildSeq, El};
pub fn stack<'a, C, S>(children: C, theme: &Theme) -> El<'a>
where
    C: ChildSeq<'a, S>,
{
    gpui::column(children).gap(theme.space(Space::Related))
}
pub fn inline<'a, C, S>(children: C, theme: &Theme) -> El<'a>
where
    C: ChildSeq<'a, S>,
{
    gpui::row(children)
        .align(Align::Center)
        .gap(theme.space(Space::Related))
}
pub fn section<'a, C, S>(children: C, theme: &Theme) -> El<'a>
where
    C: ChildSeq<'a, S>,
{
    gpui::column(children)
        .gap(theme.space(Space::Group))
        .p(theme.space(Space::Section))
        .bg(theme.surface())
        .rounded(theme.radius())
}
