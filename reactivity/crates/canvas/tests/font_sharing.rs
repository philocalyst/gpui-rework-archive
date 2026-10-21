use gpui_canvas::{Affine, Canvas, Color, Error, FontFace, Point, Rect, TextSystem};

#[test]
fn shared_face_accepts_cross_service_layouts_but_caches_are_independent() {
    let face = FontFace::bundled().unwrap();
    let mut first = TextSystem::from_font(face.clone());
    let mut second = TextSystem::from_font(face.clone());
    assert!(first.font_face().same_face(second.font_face()));
    let layout = first.shape("office café", 18.0, None).unwrap();
    assert_eq!(first.ink_bounds(&layout), second.ink_bounds(&layout));
    assert_eq!(first.cache_bytes(), 0);
    assert_eq!(second.cache_bytes(), 0);
    let mut a = Canvas::new(128, 40).unwrap();
    let mut b = Canvas::new(128, 40).unwrap();
    let clip = Rect::new(0.0, 0.0, 128.0, 40.0);
    a.draw_text(
        &mut first,
        &layout,
        Point::default(),
        Affine::IDENTITY,
        clip,
        Color::WHITE,
    )
    .unwrap();
    assert!(first.cache_bytes() > 0);
    assert_eq!(second.cache_bytes(), 0);
    b.draw_text(
        &mut second,
        &layout,
        Point::default(),
        Affine::IDENTITY,
        clip,
        Color::WHITE,
    )
    .unwrap();
    assert!(second.cache_bytes() > 0);
    assert_eq!(a.pixels(), b.pixels());
    let retained = a.pixels().to_vec();
    first.clear_cache();
    assert_eq!(first.cache_bytes(), 0);
    assert!(second.cache_bytes() > 0);
    assert_eq!(a.pixels(), retained);
    let foreign = FontFace::new(include_bytes!("../assets/NotoSans.ttf")).unwrap();
    assert!(!face.same_face(&foreign));
    assert_eq!(
        TextSystem::from_font(foreign).ink_bounds(&layout),
        Err(Error::ForeignLayout)
    );
}

#[test]
fn supplied_font_bytes_are_owned_once_by_the_shared_face() {
    let bytes = include_bytes!("../assets/NotoSans.ttf").to_vec();
    let face = FontFace::new(&bytes).unwrap();
    drop(bytes);
    let first = TextSystem::from_font(face.clone());
    let second = TextSystem::from_font(face);
    let layout = first.shape("café", 18.0, None).unwrap();
    assert!(second.ink_bounds(&layout).unwrap().width > 0.0);
    assert!(FontFace::new(b"invalid").is_err());
}

/// Run each count in a fresh process to avoid confusing prior allocator retention
/// with simultaneously live font duplication. No rendering or glyph-cache work.
#[test]
#[ignore = "RSS/timing measurement; GPUI_FONT_SERVICES=1,2,8 in separate processes"]
fn live_services_measurement() {
    let count = std::env::var("GPUI_FONT_SERVICES")
        .unwrap_or_else(|_| "1".into())
        .parse::<usize>()
        .unwrap();
    assert!([1, 2, 8].contains(&count));
    let before = rss_kib();
    let mut services = Vec::with_capacity(count);
    let mut times = Vec::with_capacity(count);
    for _ in 0..count {
        let now = std::time::Instant::now();
        services.push(TextSystem::bundled().unwrap());
        times.push(now.elapsed().as_nanos());
    }
    assert!(
        services
            .iter()
            .all(|s| s.font_face().same_face(services[0].font_face()))
    );
    let live = rss_kib();
    let start = std::time::Instant::now();
    drop(services);
    let drop_us = start.elapsed().as_micros();
    let after = rss_kib();
    println!(
        "services={count},init_ns={times:?},rss_before_kib={before:?},rss_live_kib={live:?},rss_after_drop_kib={after:?},drop_us={drop_us},font_face_header_bytes={},text_system_header_bytes={}",
        std::mem::size_of::<FontFace>(),
        std::mem::size_of::<TextSystem>()
    );
}
fn rss_kib() -> Option<usize> {
    let status = std::fs::read_to_string("/proc/self/status").ok()?;
    status
        .lines()
        .find(|line| line.starts_with("VmRSS:"))?
        .split_whitespace()
        .nth(1)?
        .parse()
        .ok()
}
