//! A bounded native source ingress proof. Exits after the mapped frame's ACK.
use gpui::{Application, NativeError, RendererPolicy, Window, prelude::*};
use std::sync::atomic::{AtomicUsize, Ordering};
static DESCRIPTIONS: AtomicUsize = AtomicUsize::new(0);
static ROWS: AtomicUsize = AtomicUsize::new(0);
#[derive(Clone, Copy)]
struct Frame {
    transform: Affine,
    bits: u64,
}
struct Panel(Signal<Frame>);
impl Panel {
    const FRAME: Source<Self, Frame> =
        Source::new(FieldId::new(1), "frame", |m| &m.0, |m| &mut m.0);
}
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::FRAME)
    }
    fn view(&self) -> El<'_> {
        DESCRIPTIONS.fetch_add(1, Ordering::SeqCst);
        column((
            row((0..32).map(|bit| {
                div().size(8).bg(self.0.map_with(bit, |frame, bit| {
                    if frame.bits & (1 << bit) == 0 {
                        Color::BLACK
                    } else {
                        Color::WHITE
                    }
                }))
            })),
            column((0..1000).map(|_| {
                ROWS.fetch_add(1, Ordering::SeqCst);
                div().size(1).bg(rgb(0x223344))
            }))
            .transform(self.0.map(|frame| frame.transform)),
        ))
    }
}
fn main() -> Result<(), NativeError> {
    let (remote, inbox) = Remote::bounded(1);
    let mut baseline = None;
    let initial = Frame {
        transform: Affine::IDENTITY,
        bits: 0,
    };
    let window = Window::document(Panel(Signal::new(initial)))
        .size(400, 240).renderer(RendererPolicy::ReferenceCpu)
        .with_inbox_for(inbox, Panel::FRAME, |frame, next| *frame = next)
        .on_presented(move |frame| {
            match baseline {
                None => {
                    baseline = Some((frame.source_epoch, DESCRIPTIONS.load(Ordering::SeqCst), ROWS.load(Ordering::SeqCst)));
                    let next = Frame { transform: Affine::translation(9.0, 0.0), bits: 0xa55a_f00f };
                    remote.try_send(next).unwrap();
                }
                Some((epoch, descriptions, rows)) if frame.source_epoch > epoch => {
                    assert_eq!(frame.source_epoch, epoch + 1);
                    assert_eq!(DESCRIPTIONS.load(Ordering::SeqCst), descriptions);
                    assert_eq!(ROWS.load(Ordering::SeqCst), rows);
                    eprintln!("MAPPED_NATIVE_ACK,source_epoch={},presentation_epoch={},owner_reruns=0,row_rebuilds=0,initial_rows={rows},frame_bytes={},signal_bytes={},renderer={:?}", frame.source_epoch, frame.presentation_epoch, std::mem::size_of::<Frame>(), std::mem::size_of::<Signal<Frame>>(), frame.renderer);
                    std::process::exit(0);
                }
                _ => {}
            }
        });
    Application::run_window(window)
}
