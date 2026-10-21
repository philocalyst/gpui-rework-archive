//! Component timings and exact requested heap, not OS first-present latency.
use gpui_canvas::{Affine, Canvas, Color, ColorConfig, Point, Rect, TextSystem};
use std::{hint::black_box, time::Instant};

fn main() {
    let count = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "1".into())
        .parse::<usize>()
        .unwrap();
    assert!([1, 2, 8].contains(&count));
    let mut services = Vec::with_capacity(count);
    let start = Instant::now();
    let init = allocation_counter::measure(|| {
        for _ in 0..count {
            services.push(TextSystem::bundled().unwrap());
        }
    });
    let init_ns = start.elapsed().as_nanos();
    let mut layout = None;
    let start = Instant::now();
    let shape = allocation_counter::measure(|| {
        layout = Some(services[0].shape("office café AVATAR", 16.0, None).unwrap());
    });
    let shape_ns = start.elapsed().as_nanos();
    let layout = layout.unwrap();
    let mut canvas = Canvas::recording(640, 480, ColorConfig::default()).unwrap();
    canvas.clear(Color::WHITE);
    let start = Instant::now();
    let prepare = allocation_counter::measure(|| {
        canvas
            .draw_text(
                &mut services[0],
                &layout,
                Point { x: 8.0, y: 8.0 },
                Affine::IDENTITY,
                Rect::new(0.0, 0.0, 640.0, 480.0),
                Color::BLACK,
            )
            .unwrap();
    });
    let prepare_ns = start.elapsed().as_nanos();
    let mut output = vec![0_u32; 640 * 480];
    let start = Instant::now();
    let render = allocation_counter::measure(|| {
        canvas.render_bgrx(&mut output).unwrap();
    });
    let render_ns = start.elapsed().as_nanos();
    let digest = output
        .iter()
        .fold(0_u64, |a, &v| a.wrapping_mul(31).wrapping_add(u64::from(v)));
    let cache = services[0].cache_bytes();
    let clear = allocation_counter::measure(|| services[0].clear_cache());
    drop(layout);
    drop(canvas);
    let release = allocation_counter::measure(|| drop(services));
    println!(
        "services,init_ns,init_live,init_peak,init_allocs,shape_ns,shape_live,prepare_ns,prepare_live,prepare_peak,render_ns,render_live,mask_payload,clear_live,drop_services_live,digest"
    );
    println!(
        "{count},{init_ns},{},{},{},{shape_ns},{},{prepare_ns},{},{},{render_ns},{},{cache},{},{},{digest}",
        init.bytes_current,
        init.bytes_max,
        init.count_total,
        shape.bytes_current,
        prepare.bytes_current,
        prepare.bytes_max,
        render.bytes_current,
        clear.bytes_current,
        release.bytes_current
    );
    if count == 1 {
        let mut old = None;
        let start = Instant::now();
        let prior = allocation_counter::measure(|| {
            old = Some(
                fontdue::Font::from_bytes(
                    include_bytes!("../assets/NotoSans.ttf") as &[u8],
                    fontdue::FontSettings::default(),
                )
                .unwrap(),
            );
        });
        println!(
            "fontdue_parse_ns={},fontdue_live={},fontdue_peak={},fontdue_allocs={}",
            start.elapsed().as_nanos(),
            prior.bytes_current,
            prior.bytes_max,
            prior.count_total
        );
        black_box(old);
    }
}
