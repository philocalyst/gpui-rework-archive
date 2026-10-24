#[path = "support/party.rs"]
mod party;

#[cfg(feature = "native")]
fn main() -> Result<(), gpui::NativeError> {
    gpui::Application::run_window(
        gpui::Window::document(party::Party::default())
            .renderer(gpui::RendererPolicy::ReferenceCpu)
            .title("After dark — Halloween invitations")
            .size(840, 542)
            .inspector(),
    )
}
#[cfg(not(feature = "native"))]
fn main() -> Result<(), gpui::Error> {
    let mut window = gpui::Win::with_size(party::Party::default(), 520, 542)?;
    if let Some(path) = std::env::args().nth(1) {
        let mut bytes = Vec::new();
        window.with_pixels(|pixels, width, height| {
            bytes.extend_from_slice(format!("P6\n{width} {height}\n255\n").as_bytes());
            for pixel in pixels.chunks_exact(4) {
                bytes.extend_from_slice(&pixel[..3]);
            }
        })?;
        std::fs::write(path, bytes).expect("write application-owned capture");
    }
    println!("{}", window.semantics()?.to_json()?);
    Ok(())
}
