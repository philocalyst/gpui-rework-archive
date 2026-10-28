//! Complete native-bridge small-text controls; source and owner routes.
use super::*;
use crate::{FieldId, Source, Sources, prelude::*};
#[derive(Clone, Copy)]
pub(super) struct Options {
    count: usize,
    fields: usize,
    owner: bool,
}
impl Options {
    pub(super) fn parse(case: &str) -> Option<Self> {
        let suffix = case.strip_prefix("text-")?;
        let parts: Vec<_> = suffix.split('-').collect();
        assert_eq!(parts.len(), 3);
        let count = parts[0].parse().unwrap();
        let fields = parts[1].parse().unwrap();
        assert!([0, 25, 1000].contains(&count) && [1, 2, 4].contains(&fields));
        assert!(["source", "owner"].contains(&parts[2]));
        Some(Self {
            count,
            fields,
            owner: parts[2] == "owner",
        })
    }
}
struct Page {
    values: [Signal<String>; 4],
    options: Options,
}
impl Page {
    const F: [Source<Self, String>; 4] = [
        Source::new(FieldId::new(1), "a", |m| &m.values[0], |m| &mut m.values[0]),
        Source::new(FieldId::new(2), "b", |m| &m.values[1], |m| &mut m.values[1]),
        Source::new(FieldId::new(3), "c", |m| &m.values[2], |m| &mut m.values[2]),
        Source::new(FieldId::new(4), "d", |m| &m.values[3], |m| &mut m.values[3]),
    ];
}
fn placed<'a>(x: f32, y: f32, child: El<'a>) -> El<'a> {
    div()
        .w(0)
        .h(0)
        .transform(Affine::translation(x, y))
        .child(child)
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::F[0])
            .direct(Self::F[1])
            .direct(Self::F[2])
            .direct(Self::F[3])
    }
    fn view(&self) -> El<'_> {
        column((
            self.values
                .iter()
                .take(self.options.fields)
                .enumerate()
                .map(|(i, v)| placed(8. + i as f32 * 80., 8., text(v).font_size(12).w(72).h(20))),
            placed(
                8.,
                128.,
                text("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz. ")
                    .font_size(12)
                    .w(944)
                    .h(20),
            ),
            (0..self.options.count).map(|i| {
                placed(
                    4. + (i % 25) as f32 * 38.,
                    152. + (i / 25) as f32 * 14.,
                    text("label").font_size(10).w(36).h(14),
                )
            }),
        ))
        .w(960)
        .h(720)
        .fg(Color::BLACK)
        .bg(Color::WHITE)
    }
}
fn value(frame: usize, index: usize) -> String {
    if (frame + index).is_multiple_of(2) {
        "0011"
    } else {
        "1100"
    }
    .into()
}
fn window(options: Options, values: [String; 4]) -> Win<Page> {
    Win::recording(
        Page {
            values: values.map(Signal::new),
            options,
        },
        WindowOptions {
            size: [960, 720],
            ..Default::default()
        },
    )
    .unwrap()
}
pub(super) fn run(gpu: &mut GpuSurface, case: &str, options: Options) {
    let allocations = std::env::var_os("GPUI_SCROLL_ALLOC").is_some();
    let frames: usize = std::env::var("GPUI_SCROLL_FRAMES")
        .unwrap()
        .parse()
        .unwrap();
    assert!(frames >= 4);
    let setup = Instant::now();
    let mut owner = None;
    let mut mount = || owner = Some(window(options, std::array::from_fn(|i| value(1, i))));
    let mount_allocation = if allocations {
        Some(allocation_counter::measure(mount))
    } else {
        mount();
        None
    };
    let mount_ns = setup.elapsed().as_nanos();
    let mut owner = owner.unwrap();
    let output = texture(gpu, [960, 720]);
    let view = output.create_view(&Default::default());
    let first = Instant::now();
    let mut initial = || present(gpu, &mut owner, &view);
    let first_allocation = if allocations {
        Some(allocation_counter::measure(initial))
    } else {
        initial();
        None
    };
    let first_ns = first.elapsed().as_nanos();
    owner.reset_counters().unwrap();
    let mut samples = Vec::with_capacity(frames + 16);
    for frame in 0..frames + 16 {
        let start = Instant::now();
        let mut operation = || {
            if options.owner {
                owner
                    .update(|m| {
                        for (i, slot) in m.values.iter_mut().enumerate().take(options.fields) {
                            **slot = value(frame, i);
                        }
                    })
                    .unwrap();
            } else {
                for i in 0..options.fields {
                    owner.set(Page::F[i], value(frame, i)).unwrap();
                }
            }
            present(gpu, &mut owner, &view);
        };
        let allocation = if allocations {
            Some(allocation_counter::measure(operation))
        } else {
            operation();
            None
        };
        let elapsed = start.elapsed().as_nanos();
        samples.push((frame, elapsed, gpu.renderer.retained_stats(), allocation));
    }
    assert_eq!(
        owner.counters().owner_reruns,
        if options.owner {
            (frames + 16) as u64
        } else {
            0
        }
    );
    let expected = std::array::from_fn(|i| {
        if i < options.fields {
            value(frames + 15, i)
        } else {
            value(1, i)
        }
    });
    for (i, v) in expected.iter().enumerate() {
        assert_eq!(owner.root().unwrap().values[i].as_str(), v);
    }
    let mut full = window(options, expected);
    full.presented(full.with_scene(|_, t| t).unwrap()).unwrap();
    let actual = owner.with_pixels(|p, _, _| p.to_vec()).unwrap();
    assert!(
        actual == full.with_pixels(|p, _, _| p.to_vec()).unwrap(),
        "small text canonical scene differs from a fresh owner"
    );
    let hash = check(gpu, &owner, &output);
    let epoch = owner.snapshot().unwrap().source_epoch;
    println!("SETUP,{case},{mount_ns},{first_ns},{hash:016x},{epoch}");
    for (label, allocation) in [("mount", mount_allocation), ("first", first_allocation)] {
        if let Some(a) = allocation {
            println!(
                "SETUP_ALLOC,{case},{label},{},{},{},{}",
                a.count_total, a.bytes_total, a.bytes_current, a.bytes_max
            );
        }
    }
    println!(
        "HEADERS,SceneDamage={},RetainedRenderer={},GpuSurface={}",
        size_of::<crate::runtime::paint::SceneDamage>(),
        size_of::<gpui_gpu::RetainedRenderer>(),
        size_of::<GpuSurface>()
    );
    for (frame, ns, stats, allocation) in samples {
        if let Some(a) = allocation {
            println!(
                "ALLOC,{case},{frame},{},{},{},{},{},{}",
                a.count_total,
                a.bytes_total,
                a.bytes_current,
                a.bytes_max,
                stats.image_bytes,
                stats.copied_pixels
            );
        } else {
            println!(
                "FRAME,{case},{frame},{ns},{},{},{}",
                stats.composited_pixels, stats.copied_pixels, stats.image_bytes
            );
        }
    }
}
