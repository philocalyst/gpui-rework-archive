//! Static style recipes are ordinary functions, composed without erasure.
use gpui::El;

/// A description transformation. Functions and closures implement this trait;
/// their concrete captures remain on the caller's stack.
pub trait Recipe<'a>: Sized {
    fn apply(self, element: El<'a>) -> El<'a>;
    fn then<R: Recipe<'a>>(self, next: R) -> Then<Self, R> {
        Then(self, next)
    }
}
impl<'a, F: FnOnce(El<'a>) -> El<'a>> Recipe<'a> for F {
    fn apply(self, element: El<'a>) -> El<'a> {
        self(element)
    }
}
/// Ordered composition. Only the properties set by the later recipe change.
pub struct Then<A, B>(A, B);
impl<'a, A: Recipe<'a>, B: Recipe<'a>> Recipe<'a> for Then<A, B> {
    fn apply(self, element: El<'a>) -> El<'a> {
        self.1.apply(self.0.apply(element))
    }
}

pub(crate) fn style<'a>(element: El<'a>, recipe: impl Recipe<'a>) -> El<'a> {
    recipe.apply(element)
}
