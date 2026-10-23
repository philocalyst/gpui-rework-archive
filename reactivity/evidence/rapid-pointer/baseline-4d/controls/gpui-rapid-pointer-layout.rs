use gpui::{prelude::*, Window};
struct Page;
impl View for Page { fn view(&self) -> El<'_> { text("layout") } }
fn main() {
    println!("point={} option_point={} target={} session={} option_session={} session_align={} event={} win={} option_win={} window={} option_window={}",
        size_of::<Point>(), size_of::<Option<Point>>(), size_of::<Target>(),
        size_of::<PointerSession>(), size_of::<Option<PointerSession>>(), align_of::<PointerSession>(),
        size_of::<PointerEvent>(), size_of::<Win<Page>>(), size_of::<Option<Win<Page>>>(),
        size_of::<Window<Page>>(), size_of::<Option<Window<Page>>>());
}
