use gpui::App;

#[cfg(target_family = "wasm")]
pub fn load_fonts(cx: &App) -> bool {
    if let Err(error) = cx.text_system().add_fonts(gpui_test::bundled_fonts()) {
        web_sys::console::error_1(&format!("failed to load application fonts: {error:#}").into());
        return false;
    }
    true
}

#[cfg(not(target_family = "wasm"))]
pub fn load_fonts(_cx: &App) -> bool {
    true
}
