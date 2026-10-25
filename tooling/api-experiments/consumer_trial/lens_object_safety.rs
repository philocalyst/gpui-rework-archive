use std::any::Any;

trait Draggable {
    fn drag(&mut self);
}
trait Capability<T: ?Sized> {
    fn lend<'a>(&self, value: &'a mut dyn Any) -> Option<&'a mut T>;
}
struct DraggableLens<T>(std::marker::PhantomData<T>);
impl<T: Draggable + 'static> Capability<dyn Draggable> for DraggableLens<T> {
    fn lend<'a>(&self, value: &'a mut dyn Any) -> Option<&'a mut (dyn Draggable + 'static)> {
        value
            .downcast_mut::<T>()
            .map(|value| value as &mut dyn Draggable)
    }
}
fn object_safe(_: &dyn Capability<dyn Draggable>) {}
fn main() {}
