//! Shared attribution probe; public owner operations and private patch work are
//! deliberately reported separately. The private patch phase does not publish S/P.
use super::*;
use std::{hint::black_box, time::Instant};

#[derive(Clone, Copy, Debug)]
enum Case {
    All,
    Sparse,
    Partial,
    Masked,
    Converging,
    Diverse,
}
impl Case {
    fn name(self) -> &'static str {
        match self {
            Self::All => "all",
            Self::Sparse => "sparse",
            Self::Partial => "partial",
            Self::Masked => "masked",
            Self::Converging => "converging",
            Self::Diverse => "diverse",
        }
    }
    fn bound(self, index: usize) -> bool {
        match self {
            Self::Sparse => index == 0,
            Self::Partial => (index / 8) % 2 == 0,
            _ => true,
        }
    }
}
struct Theme {
    count: usize,
    case: Case,
    color: Signal<Color>,
}
impl Theme {
    const COLOR: Source<Self, Color> =
        Source::new(FieldId::new(1), "color", |m| &m.color, |m| &mut m.color);
    fn new(count: usize, case: Case, color: Color) -> Self {
        Self {
            count,
            case,
            color: Signal::new(color),
        }
    }
}
fn literal() -> Color {
    Color::rgb(1, 2, 3)
}
fn initial() -> Color {
    Color::rgb(4, 5, 6)
}
fn color(turn: usize) -> Color {
    [
        literal(),
        Color::rgb(7, 8, 9),
        initial(),
        Color::rgb(10, 11, 12),
    ][turn % 4]
}
impl View for Theme {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::COLOR)
    }
    fn view(&self) -> El<'_> {
        div().size(256).child((0..self.count).map(|index| {
            let width = match self.case {
                Case::Diverse => index + 1,
                Case::Converging => (index / 2) % 8 + 1,
                _ => index % 8 + 1,
            };
            let element = div().w(width).h(1);
            if matches!(self.case, Case::Converging) {
                if index % 2 == 0 {
                    element.bg(&self.color).fg(literal())
                } else {
                    element.bg(literal()).fg(&self.color)
                }
            } else if self.case.bound(index) {
                element.bg(&self.color).fg(&self.color)
            } else {
                element.bg(initial()).fg(initial())
            }
        }))
    }
}

fn mount(count: usize, case: Case) -> Win<Theme> {
    let mut owner = Win::recording(
        Theme::new(count, case, initial()),
        WindowOptions {
            size: [64, 64],
            ..Default::default()
        },
    )
    .unwrap();
    acknowledge(&mut owner);
    if matches!(case, Case::Masked) {
        let target = owner.inspect().unwrap().nodes[1].target.unwrap();
        owner
            .set_property(
                target,
                crate::property::BACKGROUND,
                crate::property::Contribution::Set(initial()),
            )
            .unwrap();
        acknowledge(&mut owner);
    }
    owner.reset_counters().unwrap();
    owner
}

fn measure<R>(
    phase: &str,
    case: Case,
    count: usize,
    rounds: usize,
    capture: bool,
    operation: impl FnOnce() -> R,
) -> R {
    let start = capture.then(Instant::now);
    let mut result = None;
    let allocation = allocation_counter::measure(|| result = Some(operation()));
    let ns = start.map_or(0, |start| start.elapsed().as_nanos());
    println!(
        "phase,{phase},{},{count},{rounds},{ns},{},{},{},{}",
        case.name(),
        allocation.count_total,
        allocation.bytes_total,
        allocation.bytes_current,
        allocation.bytes_max
    );
    result.unwrap()
}

fn report(phase: &str, owner: &Win<Theme>, value: Color) {
    let runtime = owner.runtime().unwrap();
    let (mode, retained, slots, entry_bytes) = match &runtime.styles {
        styles::Styles::Default => ("default", 0, 0, 0),
        styles::Styles::Dense(values) => (
            "dense",
            values.capacity() * size_of::<Style>(),
            0,
            size_of::<Style>(),
        ),
        styles::Styles::Shared { palette, indices } => (
            "shared",
            size_of_val(palette.as_ref()) + size_of_val(indices.as_ref()),
            palette.len(),
            palette.first().map_or(0, size_of_val),
        ),
    };
    let mut digest = 0xcbf29ce484222325u64;
    for (index, node) in runtime.nodes.iter().enumerate() {
        let style = runtime.styles.get(index);
        if index != 0 {
            let item = index - 1;
            let (bg, fg) = if matches!(runtime.model.case, Case::Converging) {
                if item % 2 == 0 {
                    (value, literal())
                } else {
                    (literal(), value)
                }
            } else if runtime.model.case.bound(item) {
                (value, value)
            } else {
                (initial(), initial())
            };
            let bg = if matches!(runtime.model.case, Case::Masked) && item == 0 {
                initial()
            } else {
                bg
            };
            assert!(style.bg.same_authoring(bg), "{phase} {item} bg");
            assert!(style.fg.same_authoring(fg), "{phase} {item} fg");
            assert_eq!(node.parent.index(), Some(0));
        }
        for word in style_key(*style, true) {
            digest = (digest ^ u64::from(word)).wrapping_mul(0x100000001b3);
        }
    }
    assert_eq!(runtime.counters.descriptions, 0);
    assert_eq!(runtime.counters.owner_reruns, 0);
    println!(
        "after,{phase},{},{},{mode},{retained},{slots},{entry_bytes},{digest:016x},{},{},{},{}",
        runtime.model.case.name(),
        runtime.model.count,
        runtime.counters.source_reads,
        runtime.counters.destination_compares,
        size_of::<Runtime<Theme>>(),
        size_of::<styles::Styles>()
    );
}

#[inline(never)]
fn patch_probe(owner: &mut Win<Theme>, value: Color) {
    let mut runtime = owner.runtime_mut().unwrap();
    Theme::COLOR
        .modify(&mut runtime.model, |target| *target = value)
        .unwrap();
    runtime.changed_nodes = 0;
    assert!(!runtime.patch(FieldId::new(1)).unwrap());
}

#[inline(never)]
fn read_probe(owner: &Win<Theme>, rounds: usize) -> u64 {
    let runtime = owner.runtime().unwrap();
    let mut checksum = 0u64;
    for _ in 0..rounds {
        for index in 0..runtime.nodes.len() {
            let style = runtime.styles.get(index);
            checksum = checksum
                .wrapping_add(u64::from(style.gap.to_bits()))
                .wrapping_add(u64::from(style.font_size.to_bits()));
        }
    }
    black_box(checksum)
}

fn run(count: usize, case: Case, capture: bool) {
    let mut owner = measure("mount-ack", case, count, 1, capture, || mount(count, case));
    report("mount-ack", &owner, initial());
    let checksum = measure("warm-read", case, count, 16, capture, || {
        read_probe(&owner, 16)
    });
    println!("read-digest,{},{count},{checksum:016x}", case.name());
    measure("first-patch", case, count, 1, capture, || {
        patch_probe(&mut owner, color(0))
    });
    report("first-patch", &owner, color(0));
    measure("four-patches", case, count, 4, capture, || {
        for turn in 1..=4 {
            patch_probe(&mut owner, color(turn));
        }
    });
    report("four-patches", &owner, color(4));
    owner.reset_counters().unwrap();
    measure("noop-patch", case, count, 1, capture, || {
        patch_probe(&mut owner, color(4))
    });
    assert_eq!(owner.runtime().unwrap().changed_nodes, 0);
    report("noop-patch", &owner, color(4));
    drop(owner);
    let mut owner = mount(count, case);
    measure("first-public-ack", case, count, 1, capture, || {
        owner.set(Theme::COLOR, color(0)).unwrap();
        acknowledge(&mut owner);
    });
    report("first-public-ack", &owner, color(0));
    measure("four-public-acks", case, count, 4, capture, || {
        for turn in 1..=4 {
            owner.set(Theme::COLOR, color(turn)).unwrap();
            acknowledge(&mut owner);
        }
    });
    report("four-public-acks", &owner, color(4));
}

fn pixels_guard(case: Case) {
    let mut changed = Win::with_size(Theme::new(60, case, initial()), 64, 64).unwrap();
    changed.set(Theme::COLOR, literal()).unwrap();
    let mut fresh = Win::with_size(Theme::new(60, case, literal()), 64, 64).unwrap();
    // Masked setup is deliberately a separate property-presence control; this
    // pixel oracle compares equal declarations without installing that mask.
    let a = changed.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    let b = fresh.with_pixels(|pixels, _, _| pixels.to_vec()).unwrap();
    assert_eq!(a, b, "independent fresh CPU image");
    let digest = a.iter().fold(0xcbf29ce484222325u64, |hash, byte| {
        (hash ^ u64::from(*byte)).wrapping_mul(0x100000001b3)
    });
    println!("pixel-digest,{},{digest:016x}", case.name());
}

#[test]
#[ignore = "explicit guard/capture mode; coordinate timings with other agents"]
fn source_fanout_phase_control() {
    let mode = std::env::var("STYLE_BATCH_MODE").expect("set guard or capture explicitly");
    assert!(["guard", "capture"].contains(&mode.as_str()));
    let capture = mode == "capture";
    if capture {
        assert_eq!(
            std::env::var("STYLE_BATCH_QUIET").as_deref(),
            Ok("approved")
        );
    }
    let variant = option_env!("STYLE_BATCH_VARIANT").expect("build with a frozen variant marker");
    let source = option_env!("STYLE_BATCH_SOURCE").expect("build with a frozen source marker");
    println!("pin,{variant},{source}");
    for case in [
        Case::All,
        Case::Sparse,
        Case::Partial,
        Case::Masked,
        Case::Converging,
        Case::Diverse,
    ] {
        pixels_guard(case);
        for count in if capture {
            &[60, 139, 4096, 65536][..]
        } else {
            &[60, 139][..]
        } {
            run(*count, case, capture);
        }
    }
}
