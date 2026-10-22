//! Same fixture and ownership scope as the frozen owned control.
use gpui_gpu::{GpuContext, RendererState, wgpu};
use gpui_gpu_owner_fixture as fixture;

struct Window {
    state: RendererState,
    texture: wgpu::Texture,
    view: wgpu::TextureView,
}
struct Owner {
    context: GpuContext,
    windows: Vec<Window>,
}

fn main() {
    let n: usize = std::env::args()
        .nth(1)
        .expect("window count")
        .parse()
        .unwrap();
    let (_instance, adapter) = fixture::adapter();
    let mut scenes = fixture::scenes(n);
    let mut owner = None;
    let cold = allocation_counter::measure(|| {
        // Match the frozen same-device control's actual device descriptor.
        let (device, queue) = fixture::device(&adapter);
        let context = pollster::block_on(GpuContext::new(device, queue, fixture::FORMAT)).unwrap();
        let mut windows = Vec::with_capacity(n);
        for canvas in &scenes {
            let state = RendererState::new(&context);
            let texture = fixture::target(context.device(), canvas);
            let view = texture.create_view(&Default::default());
            windows.push(Window {
                state,
                texture,
                view,
            });
        }
        owner = Some(Owner { context, windows });
    });
    let owned = owner.as_mut().unwrap();
    let warm = allocation_counter::measure(|| {
        for (window, canvas) in owned.windows.iter_mut().zip(&scenes) {
            window
                .state
                .render(&owned.context, canvas.prepared_scene(), &window.view)
                .unwrap();
            owned
                .context
                .device()
                .poll(wgpu::PollType::wait_indefinitely())
                .unwrap();
        }
    });
    println!(
        "shared,{n},headers:owner={},holder={},window={},context={},state={},cold={cold:?},warm={warm:?}",
        size_of::<Owner>(),
        size_of_val(&owner),
        size_of::<Window>(),
        size_of::<GpuContext>(),
        size_of::<RendererState>()
    );
    println!(
        "combined,requests={},retained_heap={},peak_heap={},owner_stack={}",
        cold.count_total + warm.count_total,
        cold.bytes_current + warm.bytes_current,
        (cold.bytes_max as i64).max(cold.bytes_current + warm.bytes_max as i64),
        size_of::<Owner>()
    );
    let owned = owner.as_mut().unwrap();
    for (index, (window, canvas)) in owned.windows.iter_mut().zip(&mut scenes).enumerate() {
        let first = fixture::pixels(
            owned.context.device(),
            owned.context.queue(),
            &window.texture,
        );
        window
            .state
            .redraw(&owned.context, &window.view)
            .unwrap()
            .unwrap();
        assert_eq!(
            first,
            fixture::pixels(
                owned.context.device(),
                owned.context.queue(),
                &window.texture
            )
        );
        assert_eq!(window.state.image_stats().unwrap().uploaded_bytes, 0);
        println!(
            "resources,{index},stats={:?},images={:?}",
            window.state.stats(),
            window.state.image_stats()
        );
        println!("pixels,{index},{:016x}", fixture::check(&first, canvas));
        fixture::counters(owned.context.device());
    }
    let drop = allocation_counter::measure(|| drop(owner));
    println!("drop={drop:?}; constructor_calls:devices=1,modules=1,pipelines=1");
}
