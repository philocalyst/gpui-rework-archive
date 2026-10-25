use core::mem::{size_of,align_of};
#[unsafe(no_mangle)]
pub static PUBLIC_LAYOUTS:[usize;7]=[size_of::<gpui::ColorInput>(),size_of::<gpui::BoolState>(),size_of::<gpui::BoolBinding>(),size_of::<gpui::BoolColors>(),size_of::<gpui::PropInput<gpui::Color>>(),size_of::<gpui::property::PropertyValue>(),align_of::<gpui::property::PropertyValue>()];
