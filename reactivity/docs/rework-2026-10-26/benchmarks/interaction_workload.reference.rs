//! Public changed-work interaction fixture. See interaction-lane/WORKLOAD-CONTRACT.md.
//! There are no native hover/popover/timeline claims and no private phase hooks.
use gpui::{
    Brush, Counters, Error, FontFace, ItemKey, ItemSource, ListId, PresentationToken,
    WindowOptions,
    prelude::*,
    property::{BACKGROUND, Contribution, WIDTH},
};
use std::{
    collections::{HashMap, HashSet},
    hint::black_box,
    time::Instant,
};

const NONE: u32 = u32::MAX;
const LIST: ListId = ListId::new(1);
const ROW_HEIGHT: f64 = 32.;
const ANCHOR: usize = 10;
const INITIAL: [u32; 2] = [1000, 1000];
const LARGE: [u32; 2] = [1200, 600];

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Case {
    HoverSource,
    HoverPaint,
    HoverLayout,
    Popover,
    Resize,
    Animation,
}
impl Case {
    fn parse(value: &str) -> Self {
        match value {
            "hover-source-paint" => Self::HoverSource,
            "hover-property-paint" => Self::HoverPaint,
            "hover-property-layout" => Self::HoverLayout,
            "popover-scroll" => Self::Popover,
            "window-resize-layout" => Self::Resize,
            "app-ticked-geometry" => Self::Animation,
            _ => panic!("unknown scenario {value}"),
        }
    }
    fn name(self) -> &'static str {
        match self {
            Self::HoverSource => "hover-source-paint",
            Self::HoverPaint => "hover-property-paint",
            Self::HoverLayout => "hover-property-layout",
            Self::Popover => "popover-scroll",
            Self::Resize => "window-resize-layout",
            Self::Animation => "app-ticked-geometry",
        }
    }
    fn hover(self) -> bool {
        matches!(
            self,
            Self::HoverSource | Self::HoverPaint | Self::HoverLayout
        )
    }
}

struct Model {
    case: Case,
    side: usize,
    labels: Vec<String>,
    row_labels: Vec<String>,
    hovered: Signal<u32>,
    tick: Signal<u32>,
    popup: Signal<Affine>,
    open: bool,
    toggles: u32,
    hide_last: bool,
    broken: bool,
}
impl Model {
    const HOVER: Source<Self, u32> = Source::new(
        FieldId::new(1),
        "hovered",
        |m| &m.hovered,
        |m| &mut m.hovered,
    );
    const TICK: Source<Self, u32> =
        Source::new(FieldId::new(2), "tick", |m| &m.tick, |m| &mut m.tick);
    const POPUP: Source<Self, Affine> =
        Source::new(FieldId::new(3), "popup", |m| &m.popup, |m| &mut m.popup);
    fn new(case: Case, side: usize) -> Self {
        assert!(matches!(side, 32 | 100));
        Self {
            case,
            side,
            labels: (0..side * side).map(|i| format!("cell-{i:05}")).collect(),
            row_labels: if case == Case::Popover {
                (0..10_000).map(|i| format!("row-{i:05}")).collect()
            } else {
                Vec::new()
            },
            hovered: Signal::new(NONE),
            tick: Signal::new(0),
            popup: Signal::new(popup_transform(400., 0.)),
            open: false,
            toggles: 0,
            hide_last: false,
            broken: false,
        }
    }
    fn base(&self) -> f64 {
        if self.side == 32 { 24. } else { 8. }
    }
    fn row_height(&self) -> f64 {
        if self.side == 32 { 30. } else { 10. }
    }
    fn toggle(&mut self) {
        self.open = !self.open;
        self.toggles += 1;
    }
    fn cell(&self, id: usize) -> El<'_> {
        let base = self.base();
        let cell = div()
            .name(&self.labels[id])
            .w(base)
            .h(base)
            .bg(base_color(id))
            .on_click(|_: &mut Self| {});
        match self.case {
            Case::HoverSource => cell.bg(self.hovered.map_with(id as u32, |hovered, id| {
                if *hovered == id {
                    hover_color()
                } else {
                    base_color(id as usize)
                }
            })),
            Case::Animation => cell
                .w(self.tick.map_with((id, self.side), |tick, (id, side)| {
                    base_for(side) + phase(*tick, id, side)
                }))
                .h(self.tick.map_with((id, self.side), |tick, (id, side)| {
                    base_for(side) + phase(*tick, id, side)
                }))
                .transform(self.tick.map_with(id, |tick, id| {
                    Affine::translation(0., ((*tick as usize + id) & 1) as f32)
                })),
            _ => cell,
        }
    }
}
impl ItemSource for Model {
    fn len(&self) -> usize {
        self.row_labels.len()
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        usize::try_from(key.get())
            .ok()
            .filter(|i| *i < self.row_labels.len())
    }
    fn row(&self, index: usize) -> El<'_> {
        let row = row((
            div().w(8).h(32).bg(base_color(index)),
            text(&self.row_labels[index]).font_size(14).h(32),
        ))
        .gap(8)
        .h(32)
        .bg(if index % 2 == 0 {
            rgb(0xf0f3f8)
        } else {
            Color::WHITE
        });
        if index == ANCHOR {
            row.name("anchor")
        } else {
            row
        }
    }
}
impl View for Model {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::HOVER)
            .direct(Self::TICK)
            .direct(Self::POPUP)
    }
    fn view(&self) -> El<'_> {
        let root = if self.case == Case::Popover {
            column((
                div()
                    .name("opener")
                    .w(1000)
                    .h(40)
                    .bg(rgb(0x234568))
                    .on_click(Self::toggle)
                    .child(text("Options").font_size(14).fg(Color::WHITE).p(8)),
                uniform_list(LIST, self, ROW_HEIGHT)
                    .name("content")
                    .w(1000)
                    .h(960),
                self.open.then(|| {
                    column((
                        text("Item actions").font_size(14).h(24),
                        text("Inspect details").font_size(14).h(24),
                        text("Duplicate item").font_size(14).h(24),
                        text("Move to group").font_size(14).h(24),
                    ))
                    .name("popover")
                    .w(240)
                    .h(160)
                    .p(8)
                    .bg(rgb(0xf8c060))
                    .transform(&self.popup)
                    .on_click(|_: &mut Self| {})
                }),
            ))
            .w(1000)
        } else if self.case == Case::Resize {
            // A wrapping max-content width larger than either viewport makes
            // automatic root width genuinely depend on available constraints.
            // Fixed-size children are never manually resized to mimic flex.
            row((0..self.side * self.side).map(|id| self.cell(id)))
                .gap(2)
                .align(Align::Start)
                .wrap(true)
        } else {
            column((0..self.side).map(|row_index| {
                let line = row((0..self.side).filter_map(move |column_index| {
                    let id = row_index * self.side + column_index;
                    (!(self.hide_last && id + 1 == self.side * self.side)).then(|| self.cell(id))
                }))
                .gap(2)
                .h(self.row_height());
                if self.case == Case::Animation {
                    line.justify(Justify::SpaceBetween)
                } else {
                    line
                }
            }))
        };
        root.transform(if self.broken {
            Affine::scale(0., 1.)
        } else {
            Affine::IDENTITY
        })
    }
}

fn base_color(id: usize) -> Color {
    if id % 2 == 0 {
        rgb(0x406080)
    } else {
        rgb(0x8098b0)
    }
}
fn base_for(side: usize) -> f64 {
    if side == 32 { 24. } else { 8. }
}
fn hover_color() -> Color {
    rgb(0xe05020)
}
fn phase(tick: u32, id: usize, side: usize) -> f64 {
    let period = if side == 32 { 6 } else { 2 };
    let p = (tick as usize + id) % (2 * period);
    if p <= period {
        p as f64
    } else {
        (2 * period - p) as f64
    }
}
fn popup_transform(x: f32, offset: f32) -> Affine {
    // Popover is the third normal-flow sibling after 40px chrome + 960px list.
    Affine::translation(x, 40. + (ANCHOR as f32 + 1.) * 32. - offset - 1000.)
}
fn font() -> FontFace {
    FontFace::new(
        std::fs::read(
            std::env::var("COMPARISON_FONT").expect("COMPARISON_FONT must name pinned Inter"),
        )
        .unwrap(),
    )
    .unwrap()
}
fn mount(model: Model, size: [u32; 2]) -> Win<Model> {
    Win::recording_with_font(
        model,
        WindowOptions {
            size,
            ..Default::default()
        },
        font(),
    )
    .unwrap()
}
fn token(win: &Win<Model>) -> PresentationToken {
    win.with_scene(|_, token| token).unwrap()
}
fn ack(win: &mut Win<Model>) {
    win.presented(token(win)).unwrap();
}
fn target(win: &Win<Model>, name: &str) -> Target {
    win.query().name(name).one().unwrap()
}

#[derive(Clone, Debug)]
struct Expected {
    hover: u32,
    tick: u32,
    open: bool,
    toggles: u32,
    offset: i32,
    popup_x: f32,
    popup_offset: i32,
    size: [u32; 2],
}
impl Default for Expected {
    fn default() -> Self {
        Self {
            hover: NONE,
            tick: 0,
            open: false,
            toggles: 0,
            offset: 0,
            popup_x: 400.,
            popup_offset: 0,
            size: INITIAL,
        }
    }
}
#[derive(Clone, Copy, Default, serde::Serialize)]
struct Sample {
    step: usize,
    routing_ns: u64,
    edit_prepare_ns: u64,
    scene_borrow_ns: u64,
    raster_ns: u64,
    logical_ack_ns: u64,
    total_ns: u64,
    logical_submissions: u64,
    edit_prepare_calls: u64,
    ack_calls: u64,
    width: u32,
    height: u32,
    final_draws: usize,
    hovered_cell: Option<u32>,
}
impl Sample {
    fn finish(&mut self) {
        self.total_ns = self.routing_ns
            + self.edit_prepare_ns
            + self.scene_borrow_ns
            + self.raster_ns
            + self.logical_ack_ns;
    }
}
fn elapsed(start: Instant) -> u64 {
    start.elapsed().as_nanos().try_into().unwrap()
}
struct Driver {
    case: Case,
    side: usize,
    window: Win<Model>,
    mouse: PointerSession,
    targets: Vec<Target>,
    indices: HashMap<Target, u32>,
    hovered_target: Option<Target>,
    expected: Expected,
    raster: bool,
    validate: bool,
    pixels: Vec<u32>,
    last_ack: PresentationToken,
}
impl Driver {
    fn new(case: Case, side: usize, raster: bool, validate: bool) -> Self {
        let mut window = mount(Model::new(case, side), INITIAL);
        ack(&mut window);
        let mut targets = Vec::with_capacity(side * side);
        let mut indices = HashMap::with_capacity(side * side);
        if case != Case::Popover {
            window
                .visit(|part| {
                    if let Some(name) = part.name().and_then(|name| name.strip_prefix("cell-")) {
                        let index: u32 = name.parse().unwrap();
                        assert_eq!(index as usize, targets.len());
                        targets.push(part.target());
                        indices.insert(part.target(), index);
                    }
                })
                .unwrap();
            assert_eq!(targets.len(), side * side);
        }
        let last_ack = token(&window);
        Self {
            case,
            side,
            window,
            mouse: PointerSession::default(),
            targets,
            indices,
            hovered_target: None,
            expected: Expected::default(),
            raster,
            validate,
            pixels: vec![0; LARGE[0] as usize * INITIAL[1] as usize],
            last_ack,
        }
    }
    fn flush(&mut self, sample: &mut Sample) {
        let start = Instant::now();
        let (next, size, draws) = self
            .window
            .with_scene(|scene, token| (token, [scene.width, scene.height], scene.draws().len()))
            .unwrap();
        sample.scene_borrow_ns += elapsed(start);
        assert_ne!(
            next, self.last_ack,
            "changed-work operation produced no new complete sheet"
        );
        sample.logical_submissions += 1;
        if self.raster {
            let start = Instant::now();
            let rendered = self
                .window
                .render_bgrx(&mut self.pixels[..size[0] as usize * size[1] as usize])
                .unwrap();
            sample.raster_ns += elapsed(start);
            assert_eq!(rendered, next);
        }
        let start = Instant::now();
        let commit = self.window.presented(next).unwrap();
        sample.logical_ack_ns += elapsed(start);
        assert!(commit.presentation_valid);
        assert_eq!(commit.prepared_epoch, None);
        self.last_ack = next;
        sample.ack_calls += 1;
        sample.width = size[0];
        sample.height = size[1];
        sample.final_draws = draws;
        if self.validate {
            self.oracle();
        }
    }
    fn hover_id(&self, step: usize) -> Option<u32> {
        let n = self.side * self.side;
        let cycle = step / 4;
        // Keep both scan extremes in steady state, not merely in warmup.
        // The first/last row bands expose reverse painter-order hit traversal.
        let start = match cycle % 4 {
            0 => (cycle / 4 * 7) % self.side,
            1 => n - self.side + (cycle / 4 * 7) % self.side,
            2 => n / 4 + (cycle / 4 * 73) % (n / 4),
            _ => n / 2 + (cycle / 4 * 73) % (n / 4),
        };
        match step % 4 {
            0 => Some(start as u32),
            1 => Some(
                (if start % self.side + 1 < self.side {
                    start + 1
                } else {
                    start - 1
                }) as u32,
            ),
            2 => None,
            _ => Some(((start + n / 2) % n) as u32),
        }
    }
    fn hover(&mut self, step: usize, sample: &mut Sample) {
        let id = self.hover_id(step);
        let start = Instant::now();
        let hit = if let Some(id) = id {
            let base = if self.side == 32 { 24. } else { 8. };
            let row_height = if self.side == 32 { 30. } else { 10. };
            let point = Point {
                x: (id as usize % self.side) as f32 * (base + 2.) + base * 0.5,
                y: (id as usize / self.side) as f32 * row_height + base * 0.5,
            };
            self.window
                .pointer_event(&mut self.mouse, PointerEvent::Move(point))
                .unwrap();
            self.window.hit_target(point).unwrap()
        } else {
            self.window
                .pointer_event(&mut self.mouse, PointerEvent::Leave)
                .unwrap();
            None
        };
        let actual_id = hit.map(|target| *self.indices.get(&target).expect("hit must name a cell"));
        sample.routing_ns += elapsed(start);
        assert_eq!(actual_id, id);
        sample.hovered_cell = id;
        assert_ne!(id.unwrap_or(NONE), self.expected.hover);
        let start = Instant::now();
        if self.case == Case::HoverSource {
            self.window.set(Model::HOVER, id.unwrap_or(NONE)).unwrap();
            sample.edit_prepare_calls += 1;
        } else {
            if let Some(old) = self.hovered_target {
                sample.edit_prepare_calls += 1;
                if self.case == Case::HoverPaint {
                    self.window
                        .set_property(old, BACKGROUND, Contribution::Inherit)
                        .unwrap();
                } else {
                    self.window
                        .set_property(old, WIDTH, Contribution::Inherit)
                        .unwrap();
                }
            }
            if let Some(new) = hit {
                sample.edit_prepare_calls += 1;
                if self.case == Case::HoverPaint {
                    self.window
                        .set_property(
                            new,
                            BACKGROUND,
                            Contribution::Set(Brush::Solid(hover_color())),
                        )
                        .unwrap();
                } else {
                    let base = self.window.root().unwrap().base();
                    self.window
                        .set_property(new, WIDTH, Contribution::Set(Some((base + 4.) as f32)))
                        .unwrap();
                }
            }
        }
        sample.edit_prepare_ns += elapsed(start);
        self.expected.hover = id.unwrap_or(NONE);
        self.hovered_target = hit;
        self.flush(sample);
    }
    fn click_opener(&mut self, sample: &mut Sample) {
        let expected = target(&self.window, "opener");
        let start = Instant::now();
        self.window
            .pointer_event(
                &mut self.mouse,
                PointerEvent::Move(Point { x: 80., y: 20. }),
            )
            .unwrap();
        sample.routing_ns += elapsed(start);
        assert_eq!(
            self.window.hit_target(Point { x: 80., y: 20. }).unwrap(),
            Some(expected),
            "fixed opener point must hit the actual acknowledged opener"
        );
        let start = Instant::now();
        self.window
            .pointer_event(&mut self.mouse, PointerEvent::Press)
            .unwrap();
        self.window
            .pointer_event(&mut self.mouse, PointerEvent::Release)
            .unwrap();
        sample.edit_prepare_ns += elapsed(start);
        sample.edit_prepare_calls += 2;
        self.expected.open = !self.expected.open;
        self.expected.toggles += 1;
        self.flush(sample);
    }
    fn anchor_bottom(&self) -> f32 {
        let mut bottom = None;
        self.window
            .visit(|part| {
                if part.name() == Some("anchor") {
                    let local = part.local_bounds();
                    let map = part.transform().unwrap();
                    bottom = Some(map.ty + map.b * local.x + map.d * (local.y + local.height));
                }
            })
            .unwrap();
        bottom.expect("anchored row must remain realized")
    }
    fn popover(&mut self, step: usize, sample: &mut Sample) {
        match step % 7 {
            0 | 6 => self.click_opener(sample),
            1 | 2 | 4 | 5 => {
                let delta = if matches!(step % 7, 1 | 2) { 32. } else { -32. };
                let start = Instant::now();
                self.window
                    .pointer_event(
                        &mut self.mouse,
                        PointerEvent::Move(Point { x: 80., y: 500. }),
                    )
                    .unwrap();
                sample.routing_ns += elapsed(start);
                let start = Instant::now();
                self.window
                    .pointer_event(
                        &mut self.mouse,
                        PointerEvent::Wheel(ScrollDelta { x: 0., y: delta }),
                    )
                    .unwrap();
                sample.edit_prepare_ns += elapsed(start);
                sample.edit_prepare_calls += 1;
                self.expected.offset += delta as i32;
                self.flush(sample);
                let start = Instant::now();
                let bottom = self.anchor_bottom();
                sample.routing_ns += elapsed(start);
                assert_eq!(
                    bottom,
                    40. + (ANCHOR as f32 + 1.) * 32. - self.expected.offset as f32
                );
                self.expected.popup_offset = self.expected.offset;
                let start = Instant::now();
                self.window
                    .set(
                        Model::POPUP,
                        Affine::translation(self.expected.popup_x, bottom - 1000.),
                    )
                    .unwrap();
                sample.edit_prepare_ns += elapsed(start);
                sample.edit_prepare_calls += 1;
                self.flush(sample);
            }
            3 => {
                self.expected.popup_x = if self.expected.popup_x == 400. {
                    432.
                } else {
                    400.
                };
                let start = Instant::now();
                self.window
                    .set(
                        Model::POPUP,
                        popup_transform(self.expected.popup_x, self.expected.popup_offset as f32),
                    )
                    .unwrap();
                sample.edit_prepare_ns += elapsed(start);
                sample.edit_prepare_calls += 1;
                self.flush(sample);
            }
            _ => unreachable!(),
        }
    }
    fn operation(&mut self, step: usize) -> Sample {
        let mut sample = Sample {
            step,
            ..Default::default()
        };
        match self.case {
            case if case.hover() => self.hover(step, &mut sample),
            Case::Popover => self.popover(step, &mut sample),
            Case::Resize => {
                self.expected.size = if step % 2 == 0 { LARGE } else { INITIAL };
                let start = Instant::now();
                self.window.resize(self.expected.size).unwrap();
                sample.edit_prepare_ns += elapsed(start);
                sample.edit_prepare_calls += 1;
                self.flush(&mut sample);
            }
            Case::Animation => {
                self.expected.tick = step as u32 + 1;
                let start = Instant::now();
                self.window.set(Model::TICK, self.expected.tick).unwrap();
                sample.edit_prepare_ns += elapsed(start);
                sample.edit_prepare_calls += 1;
                self.flush(&mut sample);
            }
            _ => unreachable!(),
        }
        sample.finish();
        self.check_state();
        sample
    }
    fn check_state(&self) {
        let model = self.window.root().unwrap();
        assert_eq!(
            *model.hovered,
            if self.case == Case::HoverSource {
                self.expected.hover
            } else {
                NONE
            }
        );
        assert_eq!(*model.tick, self.expected.tick);
        assert_eq!(
            (model.open, model.toggles),
            (self.expected.open, self.expected.toggles)
        );
        assert!(!model.broken && !model.hide_last);
        if self.case == Case::Popover {
            assert_eq!(
                *model.popup,
                popup_transform(self.expected.popup_x, self.expected.popup_offset as f32)
            );
            let list = self.window.list(LIST).unwrap();
            assert_eq!(
                self.window.list_state(list).unwrap().offset,
                self.expected.offset as f64
            );
        }
    }
    fn oracle(&mut self) {
        self.check_state();
        let mut model = Model::new(self.case, self.side);
        model.hovered = Signal::new(if self.case == Case::HoverSource {
            self.expected.hover
        } else {
            NONE
        });
        model.tick = Signal::new(self.expected.tick);
        model.open = self.expected.open;
        model.toggles = self.expected.toggles;
        model.popup = Signal::new(popup_transform(
            self.expected.popup_x,
            self.expected.popup_offset as f32,
        ));
        let mut oracle = mount(model, self.expected.size);
        ack(&mut oracle);
        if self.case == Case::Popover && self.expected.offset != 0 {
            let list = oracle.list(LIST).unwrap();
            oracle
                .scroll_to_index(list, self.expected.offset as usize / 32)
                .unwrap();
            ack(&mut oracle);
        }
        if matches!(self.case, Case::HoverPaint | Case::HoverLayout) && self.expected.hover != NONE
        {
            let hit = target(&oracle, &format!("cell-{:05}", self.expected.hover));
            if self.case == Case::HoverPaint {
                oracle
                    .set_property(
                        hit,
                        BACKGROUND,
                        Contribution::Set(Brush::Solid(hover_color())),
                    )
                    .unwrap();
            } else {
                let base = oracle.root().unwrap().base();
                oracle
                    .set_property(hit, WIDTH, Contribution::Set(Some((base + 4.) as f32)))
                    .unwrap();
            }
            ack(&mut oracle);
        }
        let actual_words = scene_words(&self.window);
        let expected_words = scene_words(&oracle);
        assert_eq!(
            actual_words.len(),
            expected_words.len(),
            "canonical draw count differs from fresh expected model"
        );
        if let Some(index) = actual_words
            .iter()
            .zip(&expected_words)
            .position(|(actual, expected)| actual != expected)
        {
            panic!(
                "canonical scene differs at draw {index}: {:?} != {:?}",
                actual_words[index], expected_words[index]
            );
        }
        let n = self.expected.size[0] as usize * self.expected.size[1] as usize;
        let mut reference = vec![0; n];
        oracle.render_bgrx(&mut reference).unwrap();
        self.window.render_bgrx(&mut self.pixels[..n]).unwrap();
        if let Some(index) = self.pixels[..n]
            .iter()
            .zip(&reference)
            .position(|(actual, expected)| actual != expected)
        {
            panic!(
                "exact CPU pixels differ at index {index}: {:08x} != {:08x}",
                self.pixels[index], reference[index]
            );
        }
        if self.case != Case::Popover {
            let mut seen = 0;
            self.window
                .visit(|part| {
                    if let Some(name) = part.name().and_then(|name| name.strip_prefix("cell-")) {
                        let index: usize = name.parse().unwrap();
                        assert_eq!(part.target(), self.targets[index]);
                        seen += 1;
                    }
                })
                .unwrap();
            assert_eq!(seen, self.targets.len());
            if self.case == Case::Resize {
                // Independent integer wrap gate. Inspect the actual x reset,
                // rather than assuming automatic roots stretch to the window.
                let words = scene_words(&self.window);
                let base = self.window.root().unwrap().base();
                let columns = ((self.expected.size[0] as f64 + 2.) / (base + 2.)).floor() as usize;
                assert!(columns > 1 && columns < self.side * self.side);
                assert_eq!(f64::from_bits(words[0][8]), 0.);
                assert_eq!(f64::from_bits(words[1][8]), -(base + 2.));
                assert_eq!(
                    f64::from_bits(words[columns - 1][8]),
                    -((columns - 1) as f64 * (base + 2.))
                );
                assert_eq!(
                    f64::from_bits(words[columns][8]),
                    0.,
                    "dependent wrap boundary must follow actual viewport width"
                );
                assert!(
                    f64::from_bits(words[columns][9]) < 0.,
                    "wrapped row must move down"
                );
                let mut line_origins = HashSet::new();
                self.window
                    .visit(|part| {
                        if part.name().is_some_and(|name| name.starts_with("cell-")) {
                            let local = part.local_bounds();
                            assert_eq!([local.width, local.height], [base as f32, base as f32]);
                            line_origins.insert(part.transform().unwrap().ty.to_bits());
                        }
                    })
                    .unwrap();
                assert_eq!(
                    line_origins.len(),
                    (self.side * self.side).div_ceil(columns),
                    "line count must follow viewport constraints, not manual leaf dimensions"
                );
            }
        }
    }
}

// Exact public draw words, no private indices, text resource IDs or target namespaces.
// local_rect(4), inverse(6), clip(4), bounds(4), working premultiplied color(4).
fn scene_words(win: &Win<Model>) -> Vec<[u64; 22]> {
    win.with_scene(|scene, _| {
        scene
            .draws()
            .map(|draw| {
                let mut out = [0; 22];
                for (dst, value) in out[..4].iter_mut().zip([
                    draw.local_rect.x,
                    draw.local_rect.y,
                    draw.local_rect.width,
                    draw.local_rect.height,
                ]) {
                    *dst = value.to_bits() as u64;
                }
                for (dst, value) in out[4..10].iter_mut().zip(draw.inverse) {
                    *dst = value.to_bits();
                }
                for (dst, value) in out[10..14].iter_mut().zip([
                    draw.clip.x,
                    draw.clip.y,
                    draw.clip.width,
                    draw.clip.height,
                ]) {
                    *dst = value.to_bits() as u64;
                }
                for (dst, value) in out[14..18].iter_mut().zip([
                    draw.bounds.x,
                    draw.bounds.y,
                    draw.bounds.width,
                    draw.bounds.height,
                ]) {
                    *dst = value.to_bits() as u64;
                }
                for (dst, value) in out[18..22].iter_mut().zip(draw.color) {
                    *dst = value.to_bits() as u64;
                }
                out
            })
            .collect()
    })
    .unwrap()
}

fn authority_and_disappearance_gates(side: usize) {
    let mut win = mount(Model::new(Case::HoverSource, side), INITIAL);
    let original = token(&win);
    assert_eq!(
        win.hit_target(Point { x: 4., y: 4. }),
        Err(Error::PresentationStale)
    );
    win.presented(original).unwrap();
    let last_name = format!("cell-{:05}", side * side - 1);
    let old_target = target(&win, &last_name);
    win.set(Model::HOVER, (side * side - 1) as u32).unwrap();
    let pending = token(&win);
    assert_ne!(original, pending);
    assert_eq!(
        win.hit_target(Point { x: 4., y: 4. }),
        Err(Error::PresentationStale)
    );
    assert_eq!(win.presented(original), Err(Error::StalePresentation));
    assert!(matches!(
        win.update(|m| m.broken = true),
        Err(Error::Canvas(_))
    ));
    assert_eq!(token(&win), pending);
    let old_ack = win.presented(pending).unwrap();
    assert!(old_ack.source_epoch > old_ack.presentation_epoch);
    assert_eq!(
        win.hit_target(Point { x: 4., y: 4. }),
        Err(Error::PresentationStale)
    );
    win.update(|m| m.broken = false).unwrap();
    ack(&mut win);
    win.update(|m| {
        m.hide_last = true;
        *m.hovered = NONE;
    })
    .unwrap();
    assert_eq!(
        win.set_property(old_target, WIDTH, Contribution::Set(Some(12.))),
        Err(Error::StaleTarget)
    );
    ack(&mut win);
    assert_eq!(
        win.query().name(&last_name).one(),
        Err(Error::MissingElement)
    );
    win.update(|m| m.hide_last = false).unwrap();
    ack(&mut win);
    assert_ne!(target(&win, &last_name), old_target);
    let live = target(&win, "cell-00000");
    let base = win.root().unwrap().base() as f32;
    win.set_property(live, WIDTH, Contribution::Set(Some(base + 4.)))
        .unwrap();
    ack(&mut win);
    win.set_property(live, WIDTH, Contribution::Inherit)
        .unwrap();
    ack(&mut win);
    assert_eq!(win.property(live, WIDTH).unwrap(), Some(base));
    assert_eq!(
        win.contribution(live, WIDTH).unwrap(),
        Contribution::Inherit
    );
    let mut driver = Driver::new(Case::HoverSource, side, false, false);
    driver.oracle();
}

fn counter_delta(after: Counters, before: Counters) -> serde_json::Value {
    let after = serde_json::to_value(after).unwrap();
    let before = serde_json::to_value(before).unwrap();
    let mut result = serde_json::Map::new();
    for (key, value) in after.as_object().unwrap() {
        result.insert(
            key.clone(),
            serde_json::json!(value.as_u64().unwrap() - before[key].as_u64().unwrap()),
        );
    }
    result.into()
}
fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    let case = Case::parse(
        args.first()
            .map(String::as_str)
            .unwrap_or("window-resize-layout"),
    );
    let value = |flag: &str, default: usize| {
        args.iter()
            .position(|s| s == flag)
            .map(|i| args[i + 1].parse().unwrap())
            .unwrap_or(default)
    };
    let side = value("--side", 32);
    let warmup = value("--warmup", 32);
    let count = value("--samples", 240);
    let validate = args.iter().any(|arg| arg == "--validate");
    let raster = args.iter().any(|arg| arg == "--cpu-raster");
    if validate {
        authority_and_disappearance_gates(side);
    }
    let cold = Instant::now();
    let mut driver = Driver::new(case, side, raster, validate);
    let cold_ns = elapsed(cold);
    if let Some(path) = std::env::var_os("INTERACTION_DUMP") {
        std::fs::write(path, driver.window.semantics().unwrap().to_json().unwrap()).unwrap();
    }
    driver.oracle();
    for step in 0..warmup {
        black_box(driver.operation(step));
    }
    driver.window.reset_counters().unwrap();
    let mut samples = Vec::with_capacity(count);
    for step in warmup..warmup + count {
        let before = driver.window.counters();
        let sample = driver.operation(step);
        let after = driver.window.counters();
        samples.push(serde_json::json!({"phases": sample, "work": counter_delta(after, before)}));
    }
    let counters = driver.window.counters();
    driver.oracle();
    let snapshot = driver.window.snapshot().unwrap();
    println!(
        "{}",
        serde_json::json!({
            "scenario": case.name(), "tier_side": side, "logical_controls": side * side,
            "mode": if raster { "cpu-raster" } else { "scene" },
            "timing_eligible": !validate, "correctness_full_trace": validate,
            "scope": "public recording CPU preparation + logical headless ACK; optional full CPU raster; no native present/GPU/upload/scanout",
            "reference_production_pin": "7ac6f33", "stock_counters": true,
            "native_hover": false, "native_popover": false, "native_animation": false,
            "isolated_source_ns": null, "isolated_layout_ns": null, "upload_bytes": null,
            "gpu_ns": null, "native_present_ns": null, "display_latency_ns": null,
            "virtual_hz": 120, "warmup": warmup, "samples_count": count,
            "cold_construct_ns": cold_ns, "counters": counters, "samples": samples,
            "final_nodes": snapshot.nodes.len(), "final_size": snapshot.size,
            "final_state": {"hover": driver.expected.hover, "tick": driver.expected.tick,
                "open": driver.expected.open, "toggles": driver.expected.toggles,
                "scroll_offset": driver.expected.offset, "popup_x": driver.expected.popup_x},
            "all_state_geometry_pixel_gates_passed": true,
        })
    );
}
