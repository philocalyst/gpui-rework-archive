//! Optimized ordinary consumer of both static property destinations.
use gpui::{Commit, El, Error, Target, View, Win, div};
use gpui::property::{Contribution, CORNER_RADIUS, GAP};
use std::hint::black_box;
struct Card;
impl View for Card {
    fn view(&self) -> El<'_> { div().size(32).rounded(8.0) }
}
#[inline(never)]
fn read_geometry(win: &Win<Card>, target: Target) -> Result<f32, Error> {
    win.property(target, CORNER_RADIUS)
}
#[inline(never)]
fn read_style(win: &Win<Card>, target: Target) -> Result<f32, Error> {
    win.property(target, GAP)
}
#[inline(never)]
fn edit_geometry(win: &mut Win<Card>, target: Target, radius: f32) -> Result<Commit, Error> {
    win.set_property(target, CORNER_RADIUS, Contribution::Set(radius))
}
fn main() -> Result<(), Error> {
    let mut win = Win::demo(Card);
    let mut target = None;
    win.visit(|part| target = Some(part.target()))?;
    let target = target.unwrap();
    assert_eq!(read_geometry(black_box(&win), black_box(target))?, 8.0);
    assert_eq!(read_style(black_box(&win), black_box(target))?, 0.0);
    edit_geometry(black_box(&mut win), black_box(target), black_box(12.0))?;
    assert_eq!(read_geometry(black_box(&win), black_box(target))?, 12.0);
    Ok(())
}
