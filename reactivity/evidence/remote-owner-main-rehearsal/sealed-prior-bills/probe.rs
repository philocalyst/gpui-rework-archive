#![crate_type = "lib"]
use gpui::{Remote, SendError};
#[unsafe(no_mangle)]
#[inline(never)]
pub fn remote_clone(remote: &Remote<u64>) -> Remote<u64> { remote.clone() }
#[unsafe(no_mangle)]
#[inline(never)]
pub fn remote_send(remote: &Remote<u64>, value: u64) -> Result<(), SendError<u64>> { remote.try_send(value) }
#[unsafe(no_mangle)]
#[inline(never)]
pub fn remote_drop(remote: Remote<u64>) { drop(remote); }
pub struct Page { total: u64 }
impl gpui::View for Page {
    fn view(&self) -> gpui::El<'_> { gpui::div().into() }
}
type OrdinaryWin = gpui::Win<Page, gpui::Lane<u64, fn(&mut Page, u64), ()>>;
#[unsafe(no_mangle)]
#[inline(never)]
pub fn ordinary_delivery(win: &mut OrdinaryWin, budget: usize) -> Result<gpui::Delivery, gpui::DeliveryError> { win.deliver_ready(budget) }
