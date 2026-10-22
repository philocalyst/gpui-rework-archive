//! Slot-count/codegen control only: no kernel or production Route implementation.
//! Four methods match the existing trait's method count, not its full ABI types.
use std::any::Any;
pub trait Route {
    fn admit(&self) -> u8 {
        0
    }
    fn invoke(&self, _: &mut dyn Any) {}
    fn owner_scope(&self) -> u32 {
        0
    }
    fn property(&self, _: &mut u8) {}
}
struct Ordinary;
impl Route for Ordinary {}
struct Selection<F, R> {
    proposal: F,
    reply: R,
}
impl<F: Fn(), R: Fn()> Route for Selection<F, R> {
    fn admit(&self) -> u8 {
        1
    }
    fn property(&self, _: &mut u8) {
        (self.proposal)();
        (self.reply)();
    }
}
fn proposal() {}
fn reply() {}
pub fn ordinary() -> Box<dyn Route> {
    Box::new(Ordinary)
}
pub fn selection() -> Box<dyn Route> {
    Box::new(Selection { proposal, reply })
}
