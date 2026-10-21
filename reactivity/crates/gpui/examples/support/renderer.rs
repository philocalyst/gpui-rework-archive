pub fn policy() -> gpui::RendererPolicy {
    match std::env::args().nth(1).as_deref() {
        Some("--cpu") => gpui::RendererPolicy::ReferenceCpu,
        Some("--gpu") => gpui::RendererPolicy::Gpu,
        None | Some("--auto") => gpui::RendererPolicy::Auto,
        _ => panic!("expected --cpu, --gpu or --auto"),
    }
}

pub fn configure<V: gpui::View>(window: gpui::Window<V>) -> gpui::Window<V> {
    let window = window.renderer(policy());
    if std::env::args().any(|arg| arg == "--startup") {
        let started = std::time::Instant::now();
        let reported = std::cell::Cell::new(None);
        window.on_presented(move |frame| {
            if reported.replace(Some(frame.renderer)) != Some(frame.renderer) {
                eprintln!(
                    "GPUI_PRESENT,{:?},{},{},{}",
                    frame.renderer,
                    frame.source_epoch,
                    frame.presentation_epoch,
                    started.elapsed().as_micros()
                );
            }
        })
    } else {
        window
    }
}
