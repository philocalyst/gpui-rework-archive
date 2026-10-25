pub fn policy() -> gpui::RendererPolicy {
    match std::env::args().nth(1).as_deref() {
        Some("--cpu") => gpui::RendererPolicy::ReferenceCpu,
        Some("--gpu") => gpui::RendererPolicy::Gpu,
        None | Some("--auto") => gpui::RendererPolicy::Auto,
        _ => panic!("expected --cpu, --gpu or --auto"),
    }
}
