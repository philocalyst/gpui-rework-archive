//! Frozen pre-refactor public-API control; do not adapt it to the shared API.
use gpui_gpu::{Renderer, wgpu};
use gpui_gpu_owner_fixture as fixture;

struct Window {
    renderer: Renderer,
    texture: wgpu::Texture,
    view: wgpu::TextureView,
}

fn main() {
    let mut args = std::env::args().skip(1);
    let mode = args.next().expect("same-device | per-device");
    let n: usize = args.next().expect("window count").parse().unwrap();
    assert!(matches!(mode.as_str(), "same-device" | "per-device"));
    let (_instance, adapter) = fixture::adapter();
    let mut scenes = fixture::scenes(n);
    let mut owner = Vec::new();
    let cold = allocation_counter::measure(|| {
        let shared = (mode == "same-device").then(|| fixture::device(&adapter));
        owner = Vec::with_capacity(n);
        for canvas in &scenes {
            let renderer = if let Some((device, queue)) = &shared {
                pollster::block_on(Renderer::new(
                    device.clone(),
                    queue.clone(),
                    fixture::FORMAT,
                ))
                .unwrap()
            } else {
                pollster::block_on(Renderer::request(&adapter, fixture::FORMAT)).unwrap()
            };
            let texture = fixture::target(renderer.device(), canvas);
            let view = texture.create_view(&Default::default());
            owner.push(Window {
                renderer,
                texture,
                view,
            });
        }
    });
    let warm = allocation_counter::measure(|| {
        for (window, canvas) in owner.iter_mut().zip(&scenes) {
            window
                .renderer
                .render(canvas.prepared_scene(), &window.view)
                .unwrap();
            window
                .renderer
                .device()
                .poll(wgpu::PollType::wait_indefinitely())
                .unwrap();
        }
    });
    println!(
        "owned,{mode},{n},headers:owner={},window={},renderer={},cold={cold:?},warm={warm:?}",
        size_of_val(&owner),
        size_of::<Window>(),
        size_of::<Renderer>()
    );
    println!(
        "combined,requests={},retained_heap={},peak_heap={},owner_stack={}",
        cold.count_total + warm.count_total,
        cold.bytes_current + warm.bytes_current,
        (cold.bytes_max as i64).max(cold.bytes_current + warm.bytes_max as i64),
        size_of_val(&owner)
    );
    for (index, (window, canvas)) in owner.iter_mut().zip(&mut scenes).enumerate() {
        let first = fixture::pixels(
            window.renderer.device(),
            window.renderer.queue(),
            &window.texture,
        );
        window.renderer.redraw(&window.view).unwrap().unwrap();
        assert_eq!(
            first,
            fixture::pixels(
                window.renderer.device(),
                window.renderer.queue(),
                &window.texture
            )
        );
        assert_eq!(window.renderer.image_stats().unwrap().uploaded_bytes, 0);
        println!(
            "resources,{index},stats={:?},images={:?}",
            window.renderer.stats(),
            window.renderer.image_stats()
        );
        println!("pixels,{index},{:016x}", fixture::check(&first, canvas));
        fixture::counters(window.renderer.device());
    }
    let drop = allocation_counter::measure(|| drop(owner));
    println!(
        "drop={drop:?}; constructor_calls:devices={},modules={n},pipelines={n}",
        if mode == "same-device" { 1 } else { n }
    );
}
