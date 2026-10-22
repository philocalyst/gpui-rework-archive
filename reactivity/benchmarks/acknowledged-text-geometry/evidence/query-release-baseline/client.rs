use gpui::{El, View, Win, column, text};
use std::hint::black_box;
pub struct Page;
impl View for Page {
    fn view(&self) -> El<'_> {
        column((0..32).map(|row| text(format!("row {row}")).w(100).h(24)))
    }
}
#[unsafe(no_mangle)]
#[inline(never)]
pub fn query_visit_control(win: &Win<Page>) -> u64 {
    let mut checksum = 0u64;
    win.visit(|part| {
        let bounds = part.bounds();
        checksum = checksum.wrapping_add(part.role() as u64)
            .wrapping_add(part.text().map_or(0, str::len) as u64)
            .wrapping_add(u64::from(bounds.x.to_bits()))
            .wrapping_add(u64::from(bounds.y.to_bits()))
            .wrapping_add(u64::from(bounds.width.to_bits()))
            .wrapping_add(u64::from(bounds.height.to_bits()));
        black_box(part.target());
    }).unwrap();
    black_box(checksum)
}
fn main() {
    if std::env::args().any(|arg| arg == "--native") {
        gpui::Application::run(Page).unwrap();
    } else {
        let win = Win::demo(Page);
        println!("{}", query_visit_control(&win));
    }
}
