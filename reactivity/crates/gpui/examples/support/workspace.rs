//! Compose the existing application ports without changing either child model.
use super::{graphics::Graphics, todos::Todos};
use gpui::prelude::*;

#[derive(Default)]
pub struct Workspace {
    todos: Todos,
    graphics: Graphics,
}
impl Workspace {
    const TODOS: Component<Self, Todos> =
        Component::new(FieldId::new(1), "todos", |m| &m.todos, |m| &mut m.todos);
    const GRAPHICS: Component<Self, Graphics> = Component::new(
        FieldId::new(2),
        "graphics",
        |m| &m.graphics,
        |m| &mut m.graphics,
    );
}
impl View for Workspace {
    fn sources() -> Sources<Self> {
        // The parent reads no child snapshots outside their descriptions.
        Sources::new()
            .direct_component(Self::TODOS)
            .direct_component(Self::GRAPHICS)
    }
    fn view(&self) -> El<'_> {
        row((
            Self::TODOS.view(self).w(540),
            Self::GRAPHICS.view(self).w(560),
        ))
    }
}
