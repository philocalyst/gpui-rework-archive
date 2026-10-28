use gpui::{Commit, Error, WindowOptions, prelude::*};
use std::{hint::black_box, time::Instant};

const BASE: &str = "office café אבג";
const OTHER: &str = "dense café אבג";
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Case {
    Tiny,
    Small,
    Transform,
    Pending,
    OneMap,
    AllMaps,
    Origin,
    Contract,
}
impl Case {
    fn parse(value: &str) -> Self {
        match value {
            "tiny1" => Self::Tiny,
            "small32" => Self::Small,
            "transform32k" => Self::Transform,
            "pending32k" => Self::Pending,
            "one-map32k" => Self::OneMap,
            "all-map32k" => Self::AllMaps,
            "origin32k" => Self::Origin,
            "contract32k" => Self::Contract,
            _ => panic!("unknown case"),
        }
    }
    fn name(self) -> &'static str {
        match self {
            Self::Tiny => "tiny1",
            Self::Small => "small32",
            Self::Transform => "transform32k",
            Self::Pending => "pending32k",
            Self::OneMap => "one-map32k",
            Self::AllMaps => "all-map32k",
            Self::Origin => "origin32k",
            Self::Contract => "contract32k",
        }
    }
    fn count(self) -> usize {
        match self {
            Self::Tiny => 1,
            Self::Small => 32,
            _ => 32768,
        }
    }
    fn cycles(self) -> usize {
        match self {
            Self::Tiny => 20000,
            Self::Small => 1000,
            Self::AllMaps | Self::Contract => 2,
            _ => 4,
        }
    }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Lane {
    Update,
    Typed,
}
impl Lane {
    fn parse(value: &str) -> Self {
        match value {
            "update" => Self::Update,
            "typed" => Self::Typed,
            _ => panic!("unknown lane"),
        }
    }
    fn name(self) -> &'static str {
        match self {
            Self::Update => "update",
            Self::Typed => "typed",
        }
    }
}
#[derive(Clone, Copy, Debug)]
struct Structural {
    count: usize,
    padding: f64,
    alternate: bool,
}
struct Model {
    case: Case,
    lane: Lane,
    transform: Signal<Affine>,
    value: Signal<String>,
    padding: Signal<f64>,
    structural: Signal<Structural>,
}
impl Model {
    const TRANSFORM: Source<Self, Affine> = Source::new(
        FieldId::new(1),
        "transform",
        |m| &m.transform,
        |m| &mut m.transform,
    );
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(2), "value", |m| &m.value, |m| &mut m.value);
    const PADDING: Source<Self, f64> = Source::new(
        FieldId::new(3),
        "padding",
        |m| &m.padding,
        |m| &mut m.padding,
    );
    const STRUCTURAL: Source<Self, Structural> = Source::new(
        FieldId::new(4),
        "structural",
        |m| &m.structural,
        |m| &mut m.structural,
    );
    fn new(case: Case, lane: Lane) -> Self {
        Self {
            case,
            lane,
            transform: Signal::new(Affine::IDENTITY),
            value: Signal::new(BASE.into()),
            padding: Signal::new(2.),
            structural: Signal::new(Structural {
                count: case.count(),
                padding: 2.,
                alternate: false,
            }),
        }
    }
    fn child(&self, index: usize) -> El<'_> {
        let value = match self.case {
            Case::AllMaps => text(&self.value),
            Case::OneMap if index == self.structural.count / 2 => text(&self.value),
            Case::Contract if self.structural.alternate && index == self.structural.count / 2 => {
                text(OTHER)
            }
            _ => text(BASE),
        };
        let value = if self.case == Case::Origin && self.lane == Lane::Typed {
            value.w(184).p(&self.padding)
        } else {
            value
                .w(180. + self.structural.padding * 2.)
                .p(self.structural.padding)
        };
        if index == 0
            && matches!(
                self.case,
                Case::Tiny | Case::Small | Case::Transform | Case::Pending
            )
        {
            value.transform(&self.transform)
        } else {
            value
        }
    }
}
impl View for Model {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::TRANSFORM)
            .direct(Self::VALUE)
            .direct(Self::PADDING)
            .field(Self::STRUCTURAL)
    }
    fn view(&self) -> El<'_> {
        column((0..self.structural.count).map(|index| self.child(index)))
            .child(div().size(2).bg(Color::BLACK))
    }
}
fn ack<M: View + 'static>(win: &mut Win<M>) -> Commit {
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap()
}
fn mount(case: Case, lane: Lane) -> (Win<Model>, Commit) {
    let mut win = Win::recording(
        Model::new(case, lane),
        WindowOptions {
            size: [400, 400],
            ..Default::default()
        },
    )
    .unwrap();
    let c = ack(&mut win);
    (win, c)
}
fn edit(win: &mut Win<Model>, case: Case, lane: Lane, phase: usize) -> Commit {
    match case {
        Case::Tiny | Case::Small | Case::Transform | Case::Pending => {
            let x = if case == Case::Pending {
                match phase % 4 {
                    0 => 0.125,
                    1 => 0.25,
                    2 => 0.375,
                    _ => 0.5,
                }
            } else if phase % 2 == 0 {
                0.125
            } else {
                0.25
            };
            let map = black_box(Affine::translation(x, 0.));
            match lane {
                Lane::Update => win.update(|m| *m.transform = map).unwrap(),
                Lane::Typed => win.set(Model::TRANSFORM, map).unwrap(),
            }
        }
        Case::OneMap | Case::AllMaps => {
            let value = black_box(if phase % 2 == 0 { OTHER } else { BASE }).to_owned();
            match lane {
                Lane::Update => win.update(|m| *m.value = value).unwrap(),
                Lane::Typed => win.set(Model::VALUE, value).unwrap(),
            }
        }
        Case::Origin if lane == Lane::Typed => win
            .set(
                Model::PADDING,
                black_box(if phase % 2 == 0 { 3. } else { 2. }),
            )
            .unwrap(),
        Case::Origin | Case::Contract => {
            let alternate = phase % 2 == 0;
            let value = black_box(Structural {
                count: if case == Case::Contract && alternate {
                    case.count() / 2
                } else {
                    case.count()
                },
                padding: if case == Case::Origin && alternate {
                    3.
                } else {
                    2.
                },
                alternate: case == Case::Contract && alternate,
            });
            match lane {
                Lane::Update => win.update(|m| *m.structural = value).unwrap(),
                Lane::Typed => win.set(Model::STRUCTURAL, value).unwrap(),
            }
        }
    }
}
fn cycle(win: &mut Win<Model>, case: Case, lane: Lane, cycle: usize) -> Commit {
    if case == Case::Pending {
        let start = (cycle % 2) * 2;
        black_box(edit(win, case, lane, start));
        black_box(edit(win, case, lane, start + 1));
    } else {
        black_box(edit(win, case, lane, cycle));
    }
    ack(win)
}
fn mix(sum: &mut u64, value: u64) {
    *sum = (*sum ^ value).wrapping_mul(0x100000001b3);
}
fn point(sum: &mut u64, p: Point) {
    mix(sum, p.x.to_bits().into());
    mix(sum, p.y.to_bits().into());
}
fn rect(sum: &mut u64, r: Rect) {
    for v in [r.x, r.y, r.width, r.height] {
        mix(sum, v.to_bits().into());
    }
}
fn observe<M: View + 'static>(win: &Win<M>) -> (usize, usize, u64) {
    let mut sum = 0xcbf29ce484222325u64;
    let mut parts = 0;
    let mut texts = 0;
    win.visit(|part| {
        parts += 1;
        mix(&mut sum, part.role() as u64);
        rect(&mut sum, part.bounds());
        rect(&mut sum, part.local_bounds());
        if let Some(map) = part.transform() {
            mix(&mut sum, 1);
            for v in [map.a, map.b, map.c, map.d, map.tx, map.ty] {
                mix(&mut sum, v.to_bits().into());
            }
        } else {
            mix(&mut sum, 0);
        }
        for value in [part.text(), part.value()] {
            if let Some(value) = value {
                mix(&mut sum, 1);
                for byte in value.bytes() {
                    mix(&mut sum, byte.into());
                }
            } else {
                mix(&mut sum, 0);
            }
        }
        if let Some(geometry) = part.text_geometry() {
            texts += 1;
            point(&mut sum, geometry.origin());
            mix(&mut sum, geometry.layout().text_len() as u64);
            for unit in geometry.layout().graphemes() {
                let range = unit.text_range();
                mix(&mut sum, range.start.byte() as u64);
                mix(&mut sum, range.end.byte() as u64);
                rect(&mut sum, unit.bounds());
                mix(&mut sum, unit.line() as u64);
            }
        }
    })
    .unwrap();
    (parts, texts, sum)
}
fn pointers(win: &Win<Model>) -> Vec<usize> {
    let mut result = Vec::new();
    win.visit(|part| {
        if let Some(g) = part.text_geometry() {
            result.push(g.layout() as *const _ as usize);
        }
    })
    .unwrap();
    result
}
fn emit_state(win: &mut Win<Model>, case: Case, lane: Lane, stage: &str) {
    let (parts, texts, sum) = observe(win);
    let snap = win.snapshot().unwrap();
    let scene = win
        .with_scene(|scene, _| {
            let mut hash = 0xcbf29ce484222325u64;
            mix(&mut hash, scene.width.into());
            mix(&mut hash, scene.height.into());
            for value in scene.clear {
                mix(&mut hash, value.to_bits().into());
            }
            assert_eq!(scene.images().count(), 0);
            for draw in scene.draws() {
                rect(&mut hash, draw.local_rect);
                rect(&mut hash, draw.bounds);
                rect(&mut hash, draw.clip);
                for value in draw.inverse {
                    mix(&mut hash, value.to_bits());
                }
                for value in draw.color {
                    mix(&mut hash, value.to_bits().into());
                }
                mix(&mut hash, u64::from(draw.source.is_solid()));
                if let Some(radius) = draw.source.corner_radius() {
                    mix(&mut hash, 1);
                    mix(&mut hash, radius.to_bits().into());
                } else {
                    mix(&mut hash, 0);
                }
                if let Some(mask) = draw.source.mask() {
                    mix(&mut hash, mask.width as u64);
                    mix(&mut hash, mask.height as u64);
                    for byte in mask.coverage {
                        mix(&mut hash, (*byte).into());
                    }
                } else {
                    mix(&mut hash, 0);
                }
            }
            hash
        })
        .unwrap();
    let mut parent_sum = 0xcbf29ce484222325u64;
    for node in &snap.nodes {
        mix(&mut parent_sum, node.parent.map_or(u64::MAX, |n| n as u64));
    }
    println!(
        "{{\"case\":\"{}\",\"lane\":\"{}\",\"stage\":\"{stage}\",\"parts\":{parts},\"texts\":{texts},\"checksum\":{sum},\"parents\":{parent_sum},\"scene\":{scene},\"source\":{},\"presentation\":{},\"prepared\":{},\"valid\":{}}}",
        case.name(),
        lane.name(),
        snap.source_epoch,
        snap.presentation_epoch,
        snap.prepared_epoch.map_or("null".into(), |n| n.to_string()),
        snap.presentation_valid
    );
}
fn preflight(case: Case, lane: Lane) {
    let (mut win, c0) = mount(case, lane);
    assert_eq!(c0.source_epoch, c0.presentation_epoch);
    assert!(c0.prepared_epoch.is_none());
    emit_state(&mut win, case, lane, "C0-ACK");
    let p0 = observe(&win);
    let old = pointers(&win);
    win.reset_counters().unwrap();
    let c1 = edit(&mut win, case, lane, 0);
    let t1 = win.with_scene(|_, t| t).unwrap();
    assert_eq!(observe(&win), p0);
    assert_eq!(c1.source_epoch, c0.source_epoch + 1);
    assert_eq!(c1.presentation_epoch, c0.presentation_epoch);
    assert_eq!(c1.prepared_epoch, Some(c1.source_epoch));
    emit_state(&mut win, case, lane, "C1-P-old");
    let a1 = ack(&mut win);
    assert_eq!(a1.source_epoch, a1.presentation_epoch);
    assert!(a1.prepared_epoch.is_none());
    let new = pointers(&win);
    let same = old.iter().zip(&new).filter(|(a, b)| a == b).count();
    if matches!(
        case,
        Case::Tiny | Case::Small | Case::Transform | Case::Pending
    ) || case == Case::Origin && lane == Lane::Update
    {
        assert_eq!(old, new);
    }
    if case == Case::AllMaps || case == Case::Origin && lane == Lane::Typed {
        assert_eq!(same, 0);
    }
    if case == Case::OneMap {
        assert_eq!(same, case.count() - 1);
    }
    emit_state(&mut win, case, lane, "C1-ACK");
    let old_p = observe(&win);
    edit(&mut win, case, lane, 1);
    let pending = win.with_scene(|_, t| t).unwrap();
    assert_eq!(observe(&win), old_p);
    edit(
        &mut win,
        case,
        lane,
        if case == Case::Pending { 2 } else { 0 },
    );
    let t2 = win.with_scene(|_, t| t).unwrap();
    assert_ne!(pending, t2);
    assert_eq!(win.presented(pending), Err(Error::StalePresentation));
    assert_eq!(win.presented(t1), Err(Error::StalePresentation));
    assert_eq!(observe(&win), old_p);
    emit_state(&mut win, case, lane, "C2-P-old");
    ack(&mut win);
    emit_state(&mut win, case, lane, "C2-ACK");
    let counters = win.counters();
    if lane == Lane::Typed && case != Case::Contract {
        assert_eq!(counters.descriptions, 0);
        assert_eq!(counters.owner_reruns, 0);
    }
    println!(
        "{{\"case\":\"{}\",\"lane\":\"{}\",\"stage\":\"proof\",\"map_count_before\":{},\"map_count_after\":{},\"maps_preserved\":{same},\"descriptions\":{},\"owner_reruns\":{},\"source_operations\":{},\"paint_passes\":{},\"route\":\"{}\"}}",
        case.name(),
        lane.name(),
        old.len(),
        new.len(),
        counters.descriptions,
        counters.owner_reruns,
        counters.source_operations,
        counters.paint_passes,
        if lane == Lane::Update {
            "Win.update"
        } else if case == Case::Contract {
            "Source.field"
        } else if case == Case::Origin {
            "Source.direct-padding-layout"
        } else {
            "Source.direct"
        }
    );
    if case == Case::Pending {
        cycle(&mut win, case, lane, 0);
    }
    emit_state(&mut win, case, lane, "sample-final");
}
fn sample(case: Case, lane: Lane) {
    let (mut win, _) = mount(case, lane);
    let warm = cycle(&mut win, case, lane, 0);
    win.reset_counters().unwrap();
    let mut final_commit = warm;
    let started = Instant::now();
    for index in 1..=case.cycles() {
        final_commit = black_box(cycle(
            black_box(&mut win),
            black_box(case),
            black_box(lane),
            black_box(index),
        ));
    }
    let elapsed = started.elapsed().as_nanos();
    black_box(&win);
    let updates = case.cycles() * if case == Case::Pending { 2 } else { 1 };
    assert_eq!(
        final_commit.source_epoch,
        warm.source_epoch + updates as u64
    );
    assert_eq!(final_commit.presentation_epoch, final_commit.source_epoch);
    assert!(final_commit.prepared_epoch.is_none());
    assert!(final_commit.presentation_valid);
    let counters = win.counters();
    assert_eq!(counters.source_operations, updates as u64);
    if lane == Lane::Typed && case != Case::Contract {
        assert_eq!(counters.descriptions, 0);
        assert_eq!(counters.owner_reruns, 0);
    }
    let (parts, texts, sum) = observe(&win);
    println!(
        "{{\"case\":\"{}\",\"lane\":\"{}\",\"cycles\":{},\"updates\":{updates},\"parts\":{parts},\"texts\":{texts},\"checksum\":{sum},\"source\":{},\"presentation\":{},\"prepared\":false,\"descriptions\":{},\"nanoseconds\":{elapsed}}}",
        case.name(),
        lane.name(),
        case.cycles(),
        final_commit.source_epoch,
        final_commit.presentation_epoch,
        counters.descriptions
    );
}

struct Input {
    value: Signal<String>,
    calls: usize,
    x: f32,
}
impl View for Input {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Source::new(
            FieldId::new(1),
            "value",
            |m| &m.value,
            |m| &mut m.value,
        ))
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.value).w(240).h(32),
            checkbox("check", false)
                .name("check")
                .w(240)
                .h(40)
                .transform(Affine::translation(self.x, 0.))
                .on_click(|m: &mut Self| m.calls += 1),
        ))
    }
}
fn public_hit(win: &Win<Input>, point: Point) -> Option<Target> {
    win.hit_target(point).unwrap()
}
fn public_input(win: &mut Win<Input>, session: &mut PointerSession, event: PointerEvent) -> Commit {
    win.pointer_event(session, event).unwrap()
}
fn public_query(win: &Win<Input>) -> (usize, usize, u64) {
    observe(win)
}
fn public_prepare(win: &mut Win<Input>, x: f32) -> Commit {
    win.update(|m| m.x = x).unwrap()
}
fn codegen_oracle() {
    let mut win = Win::recording(
        Input {
            value: Signal::new("office café אבג".into()),
            calls: 0,
            x: 0.,
        },
        WindowOptions {
            size: [400, 400],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    let check = win.query().name("check").one().unwrap();
    win.click(check).unwrap();
    let before = ack(&mut win);
    assert_eq!(win.root().unwrap().calls, 1);
    let inside = black_box(Point { x: 12., y: 52. });
    assert_eq!(public_hit(black_box(&win), inside), Some(check));
    assert_eq!(public_hit(&win, black_box(Point { x: 400., y: 52. })), None);
    let query = public_query(black_box(&win));
    let mut session = PointerSession::default();
    for event in [
        PointerEvent::Move(inside),
        PointerEvent::Press,
        PointerEvent::Cancel,
    ] {
        let c = public_input(black_box(&mut win), &mut session, black_box(event));
        assert_eq!(c.source_epoch, before.source_epoch);
        assert_eq!(c.presentation_epoch, before.presentation_epoch);
        assert!(c.prepared_epoch.is_none());
    }
    assert_eq!(public_query(&win), query);
    assert_eq!(win.root().unwrap().calls, 1);
    public_prepare(black_box(&mut win), black_box(0.125));
    let c1 = win.with_scene(|_, t| t).unwrap();
    public_prepare(&mut win, black_box(0.25));
    assert_eq!(public_query(&win), query);
    assert_eq!(win.presented(c1), Err(Error::StalePresentation));
    let final_commit = ack(&mut win);
    let after = public_query(&win);
    assert_ne!(after, query);
    println!(
        "{{\"mode\":\"codegen\",\"parts\":{},\"texts\":{},\"checksum\":{},\"source\":{},\"presentation\":{},\"session_bytes\":{},\"win_bytes\":{}}}",
        after.0,
        after.1,
        after.2,
        final_commit.source_epoch,
        final_commit.presentation_epoch,
        size_of::<PointerSession>(),
        size_of::<Win<Input>>()
    );
}
fn main() {
    let args = std::env::args().collect::<Vec<_>>();
    match args.get(1).map(String::as_str) {
        Some("preflight") => preflight(Case::parse(&args[2]), Lane::parse(&args[3])),
        Some("sample") => sample(Case::parse(&args[2]), Lane::parse(&args[3])),
        Some("codegen") => codegen_oracle(),
        _ => panic!("use preflight|sample CASE update|typed, or codegen"),
    }
}
