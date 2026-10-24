use super::*;
use path_backend::{Command, Format, Mask, Origin, Point};
use std::{path::PathBuf, sync::atomic::AtomicU64};
pub(super) static FAIL_BACKEND: AtomicU64 = AtomicU64::new(0);

fn save(name: &str, bytes: &[u8]) {
    if let Some(out) = std::env::var_os("OUTLINE_GATE_OUT") {
        let out = PathBuf::from(out);
        std::fs::create_dir_all(&out).unwrap();
        std::fs::write(out.join(name), bytes).unwrap();
    }
}

#[test]
fn tiny_frozen_masks_and_cold_scratch() {
    for (f, bytes) in [&PRIMARY_BYTES[..], &ARABIC_BYTES[..], &HEBREW_BYTES[..]]
        .into_iter()
        .enumerate()
    {
        let face = FontFace::new(bytes).unwrap();
        let parsed = ttf_parser::Face::parse(bytes, 0).unwrap();
        let mut cache = RasterCache::default();
        for (g, ch) in [' ', 'j', 'é', 'Å', 'م', 'א'].into_iter().enumerate() {
            let Some(id) = parsed.glyph_index(ch) else {
                continue;
            };
            for (z, size) in [0.25, 7.0, 12.5, 16.0, 32.25, 64.0, 512.0]
                .into_iter()
                .enumerate()
            {
                let raster = cache.raster(&face, id.0, size).unwrap();
                let m = &raster.metrics;
                let mut data =
                    format!("{},{},{},{}\n", m.xmin, m.ymin, m.width, m.height).into_bytes();
                data.extend_from_slice(&raster.pixels);
                save(&format!("mask-{f}-{g}-{z}.bin"), &data);
            }
        }
        let id = parsed.glyph_index('j').unwrap_or(ttf_parser::GlyphId(0)).0;
        let mut held = None;
        let cost = allocation_counter::measure(|| {
            let mut cold = RasterCache::default();
            drop(cold.raster(&face, id, 16.0).unwrap());
            cold.cache = HashMap::new();
            cold.cache_bytes = 0;
            held = Some(cold);
        });
        eprintln!(
            "font={f} FontData={} backend={} cold={cost:?}",
            std::mem::size_of::<FontData>(),
            std::mem::size_of_val(&**held.as_ref().unwrap().scaler.as_ref().unwrap())
        );
        let clear = allocation_counter::measure(|| held.as_mut().unwrap().clear_cache());
        eprintln!("font={f} clear={clear:?}");
    }
    let face = FontFace::new(&PRIMARY_BYTES[..]).unwrap();
    let mut cache = RasterCache::default();
    for size in [f32::NAN, f32::INFINITY, -1.0, 0.0, 4097.0] {
        assert!(matches!(
            cache.raster(&face, 0, size),
            Err(Error::InvalidFontSize)
        ));
    }
    assert!(matches!(
        cache.raster(&face, u16::MAX, 16.0),
        Err(Error::InvalidFont)
    ));
    assert!(matches!(
        cache.raster(&face, 58, 4096.0),
        Err(Error::ResourceLimit)
    ));
    assert_eq!(cache.cache_bytes, 0);
}

#[test]
fn explicit_zeno_matches_auto_bounds_with_empty_contours() {
    for shift in [-5.25_f32, -0.125, 0.0, 0.375] {
        let p = |x, y| Point::new(x + shift, y - shift);
        let full = [
            Command::MoveTo(p(-20.2, -10.1)),
            Command::Close,
            Command::MoveTo(p(-2.3, -1.2)),
            Command::LineTo(p(9.4, 0.1)),
            Command::QuadTo(p(12.7, 10.4), p(-1.7, 9.2)),
            Command::Close,
            Command::MoveTo(p(20.9, 19.1)),
            Command::Close,
        ];
        let kept = &full[2..6];
        let (auto, placement) = Mask::new(&full[..])
            .origin(Origin::BottomLeft)
            .format(Format::Alpha)
            .inspect(|_, _, _| {})
            .render();
        let bottom = placement.top - placement.height as i32;
        let (explicit, _) = Mask::new(kept)
            .origin(Origin::BottomLeft)
            .format(Format::Alpha)
            .inspect(|_, _, _| {})
            .size(placement.width, placement.height)
            .offset((-placement.left as f32, -bottom as f32))
            .render();
        assert_eq!(auto, explicit);
        save(&format!("path-{}.bin", shift.to_bits()), &auto);
    }
    let empty = [Command::MoveTo(Point::new(-2.5, 3.25)), Command::Close];
    assert!(
        Mask::new(&empty[..])
            .origin(Origin::BottomLeft)
            .render()
            .0
            .iter()
            .all(|&pixel| pixel == 0)
    );
}

fn index(items: &[Vec<u8>], cff2: bool) -> Vec<u8> {
    let mut out = if cff2 {
        (items.len() as u32).to_be_bytes().to_vec()
    } else {
        (items.len() as u16).to_be_bytes().to_vec()
    };
    if items.is_empty() {
        return out;
    }
    out.push(4);
    let mut offset = 1_u32;
    out.extend(offset.to_be_bytes());
    for item in items {
        offset += item.len() as u32;
        out.extend(offset.to_be_bytes());
    }
    for item in items {
        out.extend(item);
    }
    out
}
fn number(out: &mut Vec<u8>, n: i16) {
    if (-107..=107).contains(&n) {
        out.push((n + 139) as u8);
    } else {
        out.push(28);
        out.extend(n.to_be_bytes());
    }
}
fn chars(segments: usize, cff2: bool) -> Vec<Vec<u8>> {
    let mut triangle = Vec::new();
    for n in [-150, -50] {
        number(&mut triangle, n);
    }
    triangle.push(21);
    for n in [300, 0, -100, 400, -200, -400] {
        number(&mut triangle, n);
    }
    triangle.push(5);
    let mut curve = vec![139, 139, 21];
    for n in [-200, 100, 200, 400, 100, -300] {
        number(&mut curve, n);
    }
    curve.push(8);
    let mut many = if segments == 2048 {
        triangle.clone()
    } else {
        vec![139, 139, 21]
    };
    for i in 0..segments {
        number(&mut many, 0);
        number(&mut many, if i % 2 == 0 { 1000 } else { -1000 });
        many.push(5);
    }
    let mut all = vec![Vec::new(), triangle, curve, vec![139, 139, 21], many];
    if !cff2 {
        for item in &mut all {
            item.push(14);
        }
    }
    all
}
fn tiny_font(cff2: bool, segments: usize) -> Vec<u8> {
    let glyphs = chars(segments, cff2);
    let long = |offset: usize| {
        let mut b = vec![29];
        b.extend((offset as u32).to_be_bytes());
        b.push(17);
        b
    };
    let table = if cff2 {
        let cs = 5 + 6 + 4;
        let mut b = vec![2, 0, 5, 0, 6];
        b.extend(long(cs));
        b.extend(index(&[], true));
        b.extend(index(&glyphs, true));
        b
    } else {
        let names = index(&[b"GPUI".to_vec()], false);
        let placeholder = index(&[long(0)], false);
        let cs = 4 + names.len() + placeholder.len() + 4;
        let mut b = vec![1, 0, 4, 4];
        b.extend(names);
        b.extend(index(&[long(cs)], false));
        b.extend([0, 0, 0, 0]);
        b.extend(index(&glyphs, false));
        b
    };
    let parsed = ttf_parser::Face::parse(&PRIMARY_BYTES, 0).unwrap();
    let raw = |tag: &[u8; 4]| {
        parsed
            .raw_face()
            .table(ttf_parser::Tag::from_bytes(tag))
            .unwrap()
            .to_vec()
    };
    let mut head = raw(b"head");
    head[18..20].copy_from_slice(&1000_u16.to_be_bytes());
    let mut hhea = raw(b"hhea");
    hhea[34..36].copy_from_slice(&(glyphs.len() as u16).to_be_bytes());
    let mut maxp = vec![0, 0, 0x50, 0];
    maxp.extend((glyphs.len() as u16).to_be_bytes());
    let mut hmtx = Vec::new();
    for _ in &glyphs {
        hmtx.extend([1, 244, 0, 0]);
    }
    let mut tables = vec![
        (*b"head", head),
        (*b"hhea", hhea),
        (*b"hmtx", hmtx),
        (*b"maxp", maxp),
        (if cff2 { *b"CFF2" } else { *b"CFF " }, table),
    ];
    tables.sort_by_key(|(tag, _)| *tag);
    let mut out = b"OTTO".to_vec();
    out.extend((tables.len() as u16).to_be_bytes());
    out.extend([0; 6]);
    let mut offset = 12 + tables.len() * 16;
    for (tag, data) in &tables {
        out.extend(tag);
        out.extend([0; 4]);
        out.extend((offset as u32).to_be_bytes());
        out.extend((data.len() as u32).to_be_bytes());
        offset += (data.len() + 3) & !3;
    }
    for (_, data) in tables {
        out.extend(data);
        while out.len() % 4 != 0 {
            out.push(0);
        }
    }
    out
}

#[test]
fn synthetic_cff_cff2_masks_and_deferred_segment_limits() {
    for cff2 in [false, true] {
        let bytes = tiny_font(cff2, 3);
        let face = FontFace::new(&bytes).unwrap();
        let mut cache = RasterCache::default();
        for id in 0..5 {
            for (z, size) in [0.25, 7.0, 12.5, 32.25, 64.0].into_iter().enumerate() {
                let raster = cache.raster(&face, id, size).unwrap();
                let m = &raster.metrics;
                let mut out =
                    format!("{},{},{},{}\n", m.xmin, m.ymin, m.width, m.height).into_bytes();
                out.extend(&raster.pixels);
                save(&format!("cff-{cff2}-{id}-{z}.bin"), &out);
            }
        }
        for segments in [65_536, 65_537] {
            let face = FontFace::new(tiny_font(cff2, segments)).unwrap();
            let font = skrifa::FontRef::from_index(&face.0.bytes, 0).unwrap();
            let outlines = font.outline_glyphs();
            let outline = outlines.get(skrifa::GlyphId::new(4)).unwrap();
            let mut pen = BoundsPen::default();
            let draw = outline.draw(
                DrawSettings::unhinted(Size::new(0.125), LocationRef::default()),
                &mut pen,
            );
            eprintln!(
                "raw draw={draw:?} segments={} invalid={}",
                pen.segments, pen.invalid
            );
            let result = cache.raster(&face, 4, 0.125);
            eprintln!(
                "cff2={cff2} requested={segments} result={:?}",
                result.as_ref().map(|r| r.pixels.len())
            );
            if segments == 65_536 {
                assert!(result.is_ok());
            } else {
                assert!(matches!(result, Err(Error::ResourceLimit)));
            }
        }
        let mut malformed = bytes;
        let n = malformed.len();
        malformed.truncate(n - 8);
        if let Ok(face) = FontFace::new(malformed) {
            assert!(cache.raster(&face, 4, 16.0).is_err());
        }
    }
    let face = FontFace::new(&PRIMARY_BYTES[..]).unwrap();
    let mut cache = RasterCache::default();
    for id in 0..4096 {
        let key = GlyphKey {
            face: 0,
            glyph: id,
            size: 0,
        };
        cache.cache.insert(
            key,
            Arc::new(Raster {
                key,
                metrics: RasterMetrics::default(),
                pixels: vec![],
            }),
        );
    }
    FAIL_BACKEND.store(face.0.id, Ordering::Relaxed);
    let failed = cache.raster(&face, 58, 16.0);
    FAIL_BACKEND.store(0, Ordering::Relaxed);
    assert!(matches!(failed, Err(Error::InvalidFont)));
    assert!(cache.cache.is_empty());
    assert_eq!(cache.cache_bytes, 0);
    drop(cache.raster(&face, 58, 16.0).unwrap());
    for id in 0..4096 {
        let key = GlyphKey {
            face: 0,
            glyph: id,
            size: 0,
        };
        cache.cache.insert(
            key,
            Arc::new(Raster {
                key,
                metrics: RasterMetrics::default(),
                pixels: vec![],
            }),
        );
    }
    let space = ttf_parser::Face::parse(&PRIMARY_BYTES, 0)
        .unwrap()
        .glyph_index(' ')
        .unwrap()
        .0;
    assert!(cache.raster(&face, space, 16.0).unwrap().pixels.is_empty());
    assert!(
        cache.scaler.is_none(),
        "empty cache eviction must drop backend scratch"
    );
}

#[test]
fn frozen_canvas_pixels_and_leased_clear() {
    use crate::{Affine, Canvas, Color, ColorConfig, OutputProfile, Point as CanvasPoint};
    let _registry = BUNDLED_TEST_LOCK.lock().unwrap();
    for (p, config) in [
        ColorConfig::default(),
        ColorConfig::linear_hdr(OutputProfile::Srgb, 203.0).unwrap(),
    ]
    .into_iter()
    .enumerate()
    {
        for (z, density) in [1.0, 1.25, 2.0].into_iter().enumerate() {
            let mut text = TextSystem::bundled().unwrap();
            let layout = text
                .shape("office café jéÅ Αθήνα Привет שלום مرحبا", 16.0, None)
                .unwrap();
            let mut canvas = Canvas::recording(512, 96, config).unwrap();
            canvas.clear(Color::BLACK);
            canvas
                .draw_text_scaled(
                    &mut text,
                    &layout,
                    CanvasPoint { x: 4.25, y: 3.5 },
                    Affine::scale(density, density),
                    Rect::new(3.0, 1.0, 500.0, 88.0),
                    Color::WHITE,
                    density,
                )
                .unwrap();
            let before = canvas.try_pixels().unwrap().to_vec();
            save(&format!("canvas-{p}-{z}.bin"), &before);
            if p == 0 {
                let mut bgrx = vec![0; 512 * 96];
                canvas.render_bgrx(&mut bgrx).unwrap();
                let bytes: Vec<_> = bgrx.into_iter().flat_map(u32::to_le_bytes).collect();
                save(&format!("bgrx-{z}.bin"), &bytes);
            }
            text.clear_cache();
            canvas
                .fill_rect(
                    Rect::new(511.0, 95.0, 0.001, 0.001),
                    Affine::IDENTITY,
                    Rect::new(0.0, 0.0, 512.0, 96.0),
                    Color::BLACK,
                )
                .unwrap();
            assert_eq!(canvas.try_pixels().unwrap(), before);
        }
    }
}

fn glyf_font(kind: usize) -> Vec<u8> {
    let parsed = ttf_parser::Face::parse(&PRIMARY_BYTES, 0).unwrap();
    let raw = |tag: &[u8; 4]| {
        parsed
            .raw_face()
            .table(ttf_parser::Tag::from_bytes(tag))
            .unwrap()
            .to_vec()
    };
    let mut head = raw(b"head");
    head[18..20].copy_from_slice(&16_u16.to_be_bytes());
    head[50..52].copy_from_slice(&1_i16.to_be_bytes());
    let mut hhea = raw(b"hhea");
    hhea[34..36].copy_from_slice(&1_u16.to_be_bytes());
    let mut maxp = raw(b"maxp");
    maxp[4..6].copy_from_slice(&1_u16.to_be_bytes());
    let mut glyf = Vec::new();
    let points = if kind == 0 {
        65_536
    } else if kind == 1 {
        32_767
    } else {
        3
    };
    let contours = if kind == 1 { 32_767_i16 } else { 1 };
    glyf.extend(contours.to_be_bytes());
    glyf.extend([0; 8]);
    if kind != 3 {
        if kind == 1 {
            for i in 0..points {
                glyf.extend((i as u16).to_be_bytes());
            }
        } else {
            glyf.extend(((points - 1) as u16).to_be_bytes());
        }
        glyf.extend([0, 0]);
        if kind <= 1 {
            let mut left = points;
            while left != 0 {
                let run = left.min(256);
                glyf.extend([0x09, (run - 1) as u8]);
                left -= run;
            }
            glyf.resize(glyf.len() + points * 4, 0);
        } else {
            glyf.extend([1, 1, 1]);
            for n in [0_i16, 32767, -32767, 0, 0, 32767] {
                glyf.extend(n.to_be_bytes());
            }
        }
    }
    let mut loca = vec![0; 4];
    loca.extend((glyf.len() as u32).to_be_bytes());
    let mut tables = vec![
        (*b"head", head),
        (*b"hhea", hhea),
        (*b"maxp", maxp),
        (*b"hmtx", vec![1, 244, 0, 0]),
        (*b"glyf", glyf),
        (*b"loca", loca),
    ];
    tables.sort_by_key(|(tag, _)| *tag);
    let mut out = vec![0, 1, 0, 0];
    out.extend((tables.len() as u16).to_be_bytes());
    out.extend([0; 6]);
    let mut offset = 12 + tables.len() * 16;
    for (tag, data) in &tables {
        out.extend(tag);
        out.extend([0; 4]);
        out.extend((offset as u32).to_be_bytes());
        out.extend((data.len() as u32).to_be_bytes());
        offset += (data.len() + 3) & !3;
    }
    for (_, data) in tables {
        out.extend(data);
        while out.len() % 4 != 0 {
            out.push(0);
        }
    }
    out
}

#[test]
fn glyf_memory_geometry_empty_moves_and_transient_recording() {
    for kind in 0..4 {
        let face = FontFace::new(glyf_font(kind)).unwrap();
        let mut cache = RasterCache::default();
        let mut result = None;
        let cost = allocation_counter::measure(|| {
            result = Some(cache.raster(&face, 0, if kind == 2 { 4096.0 } else { 16.0 }));
        });
        let result = result.unwrap();
        eprintln!(
            "glyf kind={kind} outcome={:?} cost={cost:?}",
            result.as_ref().map(|r| r.pixels.len())
        );
        match kind {
            0 => assert!(matches!(result, Err(Error::ResourceLimit))),
            1 => {
                assert_eq!(result.unwrap().pixels.len(), 0);
                assert!(cache.scaler.is_none());
            }
            2 => assert!(matches!(result, Err(Error::InvalidGeometry))),
            3 => assert!(matches!(result, Err(Error::InvalidFont))),
            _ => unreachable!(),
        }
    }
    for segments in [65_536, 65_537] {
        let face = FontFace::new(tiny_font(false, segments)).unwrap();
        let mut cache = RasterCache::default();
        let mut result = None;
        let cost = allocation_counter::measure(|| {
            result = Some(cache.raster(&face, 4, 0.125));
        });
        eprintln!(
            "cff transient requested={segments} outcome={:?} cost={cost:?}",
            result.as_ref().unwrap().as_ref().map(|r| r.pixels.len())
        );
        assert!(cache.scaler.is_none());
    }
    let face = FontFace::new(&PRIMARY_BYTES[..]).unwrap();
    let parsed = ttf_parser::Face::parse(&PRIMARY_BYTES, 0).unwrap();
    let ids: Vec<_> = "office café AVATAR jéÅ"
        .chars()
        .filter_map(|c| parsed.glyph_index(c))
        .map(|g| g.0)
        .collect();
    let mut held = None;
    let cost = allocation_counter::measure(|| {
        let mut cache = RasterCache::default();
        for &id in &ids {
            drop(cache.raster(&face, id, 32.25).unwrap());
        }
        cache.cache = HashMap::new();
        cache.cache_bytes = 0;
        held = Some(cache);
    });
    eprintln!("multi retained backend cost={cost:?}");
    let cache = held.as_mut().unwrap();
    for &id in &ids {
        drop(cache.raster(&face, id, 32.25).unwrap());
    }
    let warm = allocation_counter::measure(|| {
        for &id in &ids {
            drop(cache.raster(&face, id, 32.25).unwrap());
        }
    });
    assert_eq!(warm.count_total, 0);
    eprintln!("multi warm cost={warm:?}");
    let clear = allocation_counter::measure(|| cache.clear_cache());
    eprintln!("multi clear cost={clear:?}");
    assert!(cache.scaler.is_none());
}

#[test]
fn accepted_complex_outline_exact_masks_and_retained_scratch() {
    for cff2 in [false, true] {
        let face = FontFace::new(tiny_font(cff2, 2048)).unwrap();
        let mut held = None;
        let mut pixels = None;
        let cost = allocation_counter::measure(|| {
            let mut cache = RasterCache::default();
            let raster = cache.raster(&face, 4, 32.25).unwrap();
            pixels = Some(raster);
            cache.cache = HashMap::new();
            cache.cache_bytes = 0;
            held = Some(cache);
        });
        let raster = pixels.take().unwrap();
        let m = &raster.metrics;
        let mut data = format!("{},{},{},{}\n", m.xmin, m.ymin, m.width, m.height).into_bytes();
        data.extend(&raster.pixels);
        save(&format!("complex-{cff2}.bin"), &data);
        drop(raster);
        eprintln!("complex cff2={cff2} cost including leased mask={cost:?}");
        assert!(held.as_ref().unwrap().scaler.is_some());
    }
}
