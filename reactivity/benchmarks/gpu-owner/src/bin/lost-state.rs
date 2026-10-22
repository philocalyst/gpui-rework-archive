//! Diagnose the live-context precondition with the default validation handler.
use gpui_gpu::{GpuContext, RendererState, wgpu};
use gpui_gpu_owner_fixture as fixture;

fn main() {
    let (_instance, adapter) = fixture::adapter();
    let (device, queue) = fixture::device(&adapter);
    let context = pollster::block_on(GpuContext::new(device, queue, fixture::FORMAT)).unwrap();
    let mut canvas = gpui_canvas::Canvas::recording(8, 8, Default::default()).unwrap();
    canvas.clear(gpui_canvas::Color::WHITE);
    let target = fixture::target(context.device(), &canvas);
    let view = target.create_view(&Default::default());
    let (send, receive) = std::sync::mpsc::channel();
    context
        .device()
        .set_device_lost_callback(move |reason, message| {
            send.send((reason, message)).unwrap();
        });
    context.device().destroy();
    context
        .device()
        .poll(wgpu::PollType::wait_indefinitely())
        .unwrap();
    let (reason, message) = receive.recv().unwrap();
    println!("actual_device_loss={reason:?},{message}");
    let created = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        RendererState::new(&context)
    }));
    match created {
        Ok(mut state) => {
            println!("state_new_after_destroy=returned");
            let rendered = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
                state.render(&context, canvas.prepared_scene(), &view)
            }));
            match rendered {
                Ok(Ok(_)) => println!(
                    "render_after_destroy=returned_submission; not evidence of usable GPU output"
                ),
                Ok(Err(error)) => println!("render_after_destroy=error:{error}"),
                Err(_) => println!("render_after_destroy=wgpu_validation_panic"),
            }
        }
        Err(_) => println!("state_new_after_destroy=wgpu_validation_panic"),
    }
}
