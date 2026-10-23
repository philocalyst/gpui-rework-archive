use gpui::{Commit, Error, WindowOptions, prelude::*};
struct Model {
    text: Signal<String>,
    calls: usize,
}
impl View for Model {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Source::new(
            FieldId::new(1),
            "text",
            |m| &m.text,
            |m| &mut m.text,
        ))
    }
    fn view(&self) -> El<'_> {
        column((
            text_input(&self.text).w(240).h(32),
            checkbox("check", false)
                .w(240)
                .h(40)
                .on_click(|m: &mut Self| m.calls += 1),
        ))
    }
}
#[inline(never)]
fn dispatch(
    win: &mut Win<Model>,
    session: &mut PointerSession,
    event: PointerEvent,
) -> Result<Commit, Error> {
    win.pointer_event(session, event)
}
#[inline(never)]
fn hit_only(win: &Win<Model>, point: Point) -> Result<Option<Target>, Error> {
    win.hit_target(point)
}
#[inline(never)]
fn click_only(win: &mut Win<Model>, point: Point) -> Result<Commit, Error> {
    win.click_at(point)
}
fn ack(win: &mut Win<Model>) {
    let token = win.with_scene(|_, token| token).unwrap();
    win.presented(token).unwrap();
}
fn main() {
    assert_eq!(size_of::<PointerSession>(), 32);
    assert_eq!(size_of::<Option<PointerSession>>(), 32);
    assert_eq!(size_of::<PointerEvent>(), 24);
    assert_eq!(size_of::<Point>(), 8);
    assert_eq!(size_of::<Win<Model>>(), 8);
    assert_eq!(size_of::<Option<Win<Model>>>(), 16);
    let mut win = Win::recording(
        Model {
            text: Signal::new("search".into()),
            calls: 0,
        },
        WindowOptions {
            size: [720, 900],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win.click(win.input()).unwrap();
    ack(&mut win);
    let point = std::hint::black_box(Point { x: 12., y: 52. });
    let target = win.query().name("check").one().unwrap();
    assert_eq!(
        hit_only(std::hint::black_box(&win), point).unwrap(),
        Some(target)
    );
    assert_eq!(
        hit_only(&win, std::hint::black_box(Point { x: 720., y: 52. })).unwrap(),
        None
    );
    let mut session = PointerSession::default();
    for event in [
        PointerEvent::Move(point),
        PointerEvent::Press,
        PointerEvent::Release,
    ] {
        dispatch(&mut win, &mut session, std::hint::black_box(event)).unwrap();
    }
    assert_eq!(win.root().unwrap().calls, 1);
    ack(&mut win);
    assert_eq!(hit_only(&win, point).unwrap(), Some(target));
    click_only(&mut win, std::hint::black_box(point)).unwrap();
    ack(&mut win);
    assert_eq!(win.root().unwrap().calls, 2);
    assert_eq!(
        session.position().map(|p| [p.x.to_bits(), p.y.to_bits()]),
        Some([12f32.to_bits(), 52f32.to_bits()])
    );
    println!(
        "calls=2 live_target=true outside_hit=false point_bits=[{},{}] session={} optional={} event={} win={} optional_win={}",
        point.x.to_bits(),
        point.y.to_bits(),
        size_of::<PointerSession>(),
        size_of::<Option<PointerSession>>(),
        size_of::<PointerEvent>(),
        size_of::<Win<Model>>(),
        size_of::<Option<Win<Model>>>()
    );
}
