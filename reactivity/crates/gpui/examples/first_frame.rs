//! Preparation and direct software output through the public application API.
#[path = "support/graphics.rs"]
mod graphics;
#[path = "support/todos.rs"]
mod todos;
use gpui::{View, Win, WindowOptions};
use std::time::Instant;

fn measure<V: View + 'static>(name: &str, model: V, size: [u32; 2]) -> Result<(), gpui::Error> {
    let started = Instant::now();
    let mut win = Win::recording(
        model,
        WindowOptions {
            size,
            ..Default::default()
        },
    )?;
    let prepared = started.elapsed();
    let mut output = vec![0; size[0] as usize * size[1] as usize];
    let started = Instant::now();
    let token = win.render_bgrx(&mut output)?;
    let rendered = started.elapsed();
    win.presented(token)?;
    println!(
        "{name},{},{},{}",
        prepared.as_micros(),
        rendered.as_micros(),
        win.with_scene(|scene, _| scene.draws().len())?
    );
    Ok(())
}
fn main() -> Result<(), gpui::Error> {
    println!("program,prepare_us,raster_us,draws");
    for _ in 0..10 {
        measure("todos", todos::Todos::default(), [540, 620])?;
        measure("graphics", graphics::Graphics::default(), [560, 440])?;
    }
    Ok(())
}
