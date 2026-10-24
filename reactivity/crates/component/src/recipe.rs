//! Static style recipes are ordinary functions, composed without erasure.
use gpui::El;

/// Concrete description transformations. The `FnOnce` supertrait preserves
/// closure argument/return lifetime inference at ordinary builder call sites.
pub trait Recipe<'a>: FnOnce(El<'a>) -> El<'a> + Sized {
    fn then<R: Recipe<'a>>(self, next: R) -> impl Recipe<'a> {
        move |element| next(self(element))
    }
}
impl<'a, F: FnOnce(El<'a>) -> El<'a>> Recipe<'a> for F {}

pub(crate) fn style<'a>(element: El<'a>, recipe: impl Recipe<'a>) -> El<'a> {
    recipe(element)
}
