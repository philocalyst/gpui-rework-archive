use gpui::{prelude::*, Commit, Error, WindowOptions};
struct Model { text: Signal<String>, calls: usize }
impl View for Model {
    fn sources() -> Sources<Self> { Sources::new().direct(Source::new(FieldId::new(1), "text", |m| &m.text, |m| &mut m.text)) }
    fn view(&self) -> El<'_> { column((text_input(&self.text).w(240).h(32), checkbox("check", false).w(240).h(40).on_click(|m: &mut Self| m.calls += 1))) }
}
#[inline(never)]
fn dispatch(win: &mut Win<Model>, session: &mut PointerSession, event: PointerEvent) -> Result<Commit, Error> { win.pointer_event(session, event) }
#[inline(never)]
fn position_only(session: &PointerSession) -> Option<Point> { session.position() }
fn ack(win: &mut Win<Model>) { let token = win.with_scene(|_, token| token).unwrap(); win.presented(token).unwrap(); }
fn main() {
    let mut win = Win::recording(Model { text: Signal::new("search".into()), calls: 0 }, WindowOptions { size: [720,900], ..Default::default() }).unwrap();
    ack(&mut win); win.click(win.input()).unwrap(); ack(&mut win);
    let mut session = PointerSession::default();
    for event in [PointerEvent::Move(Point{x:12.,y:52.}), PointerEvent::Press, PointerEvent::Release] { dispatch(&mut win, &mut session, std::hint::black_box(event)).unwrap(); }
    assert_eq!(win.root().unwrap().calls,1);
    let point = position_only(std::hint::black_box(&session)).unwrap();
    assert_eq!([point.x.to_bits(),point.y.to_bits()],[12f32.to_bits(),52f32.to_bits()]);
    println!("calls=1 point={point:?} session={} optional={}",size_of::<PointerSession>(),size_of::<Option<PointerSession>>());
}
