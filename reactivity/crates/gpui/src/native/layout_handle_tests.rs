//! Raw producer diagnostics only. No retained-layout optimization or GPU parity claim.
use super::structural_trace_tests::Tree;
use super::*;
use crate::prelude::*;
use serde_json::{Value, json};

fn allocation(a: allocation_counter::AllocationInfo) -> Value {
    json!({"bytes":a.bytes_total,"count":a.count_total,"retained_delta":a.bytes_current,"peak_delta":a.bytes_max})
}
fn run<M: View + 'static>(
    case: &str,
    operations: &[&str],
    build: impl Fn(usize) -> M,
    update: impl Fn(&mut Win<M>, usize),
    output: &std::path::Path,
) -> Value {
    let mut owner = Win::with_size(build(0), 64, 64).unwrap();
    let mut previous = None;
    let mut previous_pixels = None;
    let mut frames = Vec::new();
    for (step, &operation) in operations.iter().enumerate() {
        if step != 0 {
            owner.structural_reset();
        }
        let source = allocation_counter::measure(|| {
            if step != 0 {
                update(&mut owner, step);
            }
        });
        let mut captured = None;
        let capture_allocation = allocation_counter::measure(|| {
            captured = Some(owner.layout_capture());
        });
        let captured = captured.unwrap();
        let mut comparison = None;
        let comparison_allocation = allocation_counter::measure(|| {
            comparison = previous.as_ref().map(|old| captured.compare(old));
        });
        let mut capture_report = None;
        let report_allocation = allocation_counter::measure(|| {
            capture_report = Some(captured.report());
        });
        let actual = owner.with_pixels(|p, _, _| p.to_vec()).unwrap();
        let mut fresh = Win::with_size(build(step), 64, 64).unwrap();
        let expected = fresh.with_pixels(|p, _, _| p.to_vec()).unwrap();
        let wrong = actual.iter().zip(&expected).filter(|(a, b)| a != b).count();
        let changed = previous_pixels
            .as_ref()
            .map(|old: &Vec<u8>| old.iter().zip(&actual).filter(|(a, b)| a != b).count());
        std::fs::write(
            output.join(format!("{case}-{operation}.actual.rgba")),
            &actual,
        )
        .unwrap();
        std::fs::write(
            output.join(format!("{case}-{operation}.fresh.rgba")),
            &expected,
        )
        .unwrap();
        frames.push(json!({"operation":operation,"source_allocation":allocation(source),"capture_allocation":allocation(capture_allocation),"comparison_allocation":allocation(comparison_allocation),"report_allocation":allocation(report_allocation),"layout":capture_report,"comparison":comparison,"producer":owner.structural_observation(),"fresh_cpu_wrong_bytes":wrong,"changed_pixel_bytes":changed}));
        assert_eq!(
            wrong, 0,
            "fresh full CPU producer oracle; no GPU parity inference"
        );
        previous = Some(captured);
        previous_pixels = Some(actual);
    }
    json!({"case":case,"frames":frames,"scope":"diagnostic full captures and comparisons outside Source; original producer/layout/render unchanged"})
}
pub(super) struct Resources {
    next: Signal<bool>,
    images: [crate::Image; 2],
}
impl Resources {
    pub(super) const NEXT: Source<Self, bool> =
        Source::new(FieldId::new(1), "next", |s| &s.next, |s| &mut s.next);
    pub(super) fn new(next: bool) -> Self {
        let image = |color: [u8; 4]| {
            crate::Image::rgba8(
                2,
                2,
                crate::ImageProfile::Srgb,
                crate::AlphaMode::Straight,
                color.repeat(4).into_boxed_slice(),
            )
            .unwrap()
        };
        Self {
            next: Signal::new(next),
            images: [image([255, 0, 0, 255]), image([0, 0, 255, 255])],
        }
    }
}
impl View for Resources {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::NEXT)
    }
    fn view(&self) -> El<'_> {
        column((
            text(if *self.next { "nn" } else { "mm" })
                .font_size(12)
                .w(48)
                .h(16),
            crate::image(&self.images[usize::from(*self.next)])
                .w(16)
                .h(16),
        ))
        .size(64)
        .bg(Color::WHITE)
        .rounded(4.0)
        .clip()
        .transform(Affine::translation(1., 0.))
    }
}
pub(super) struct Constrained {
    pub(super) narrow: Signal<bool>,
}
impl Constrained {
    pub(super) const NARROW: Source<Self, bool> =
        Source::new(FieldId::new(1), "narrow", |s| &s.narrow, |s| &mut s.narrow);
}
impl View for Constrained {
    fn sources() -> Sources<Self> {
        Sources::new().field(Self::NARROW)
    }
    fn view(&self) -> El<'_> {
        column((
            column((text("alpha beta gamma delta").font_size(12),)).w(if *self.narrow {
                24
            } else {
                56
            }),
            div().w(12).h(8).bg(Color::rgb(0, 0, 255)),
        ))
        .size(64)
        .bg(Color::WHITE)
        .clip()
    }
}
#[test]
#[ignore = "explicit layout handle authority trace"]
fn live_layout_handles() {
    let output = std::path::PathBuf::from(std::env::var("GPUI_LAYOUT_HANDLE_OUTPUT").unwrap());
    std::fs::create_dir(&output).unwrap();
    let mut cases = Vec::new();
    for (keyed, fillers) in [(true, 4), (true, 256), (false, 4)] {
        let keys = |i| match i {
            1 => vec![1, 9, 2, 3],
            3 => vec![3, 1, 2],
            _ => vec![1, 2, 3],
        };
        cases.push(run(
            &format!("{}-{fillers}", if keyed { "keyed" } else { "unkeyed" }),
            &["initial", "insert", "remove", "move"],
            |i| Tree::new(keyed, fillers, keys(i)),
            |owner, i| {
                owner.set(Tree::KEYS, keys(i)).unwrap();
            },
            &output,
        ));
        std::fs::write(
            output.join("trace.json"),
            serde_json::to_vec_pretty(&cases).unwrap(),
        )
        .unwrap();
    }
    cases.push(run(
        "resources",
        &["initial", "replace", "return"],
        |i| Resources::new(i == 1),
        |owner, i| {
            owner.set(Resources::NEXT, i == 1).unwrap();
        },
        &output,
    ));
    std::fs::write(
        output.join("trace.json"),
        serde_json::to_vec_pretty(&cases).unwrap(),
    )
    .unwrap();
    cases.push(run(
        "constraints",
        &["initial", "narrow", "return"],
        |i| Constrained {
            narrow: Signal::new(i == 1),
        },
        |owner, i| {
            owner.set(Constrained::NARROW, i == 1).unwrap();
        },
        &output,
    ));
    std::fs::write(
        output.join("trace.json"),
        serde_json::to_vec_pretty(&cases).unwrap(),
    )
    .unwrap();
}
