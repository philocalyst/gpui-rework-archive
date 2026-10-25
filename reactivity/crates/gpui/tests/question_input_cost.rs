//! Identical one-source controls also compile against the pre-family baseline.
//! Run ignored release test on a coordinated quiet CPU; output is raw evidence.
use gpui::{Completion, Questions, StartError, WindowOptions, prelude::*};
use std::{convert::Infallible, hint::black_box, sync::mpsc, time::Instant};
struct Model {
    value: Signal<u64>,
    other: Signal<u64>,
}
impl Model {
    const VALUE: Source<Self, u64> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
    const OTHER: Source<Self, u64> =
        Source::new(FieldId::new(2), "other", |m| &m.other, |m| &mut m.other);
}
impl View for Model {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE).direct(Self::OTHER)
    }
    fn view(&self) -> El<'_> {
        div()
    }
}
fn open() -> (
    Win<Model, impl gpui::LaneSet<Model>>,
    mpsc::Receiver<Completion<u64, Infallible>>,
) {
    let (send, jobs) = mpsc::sync_channel(1);
    let (plan, _) = Questions::new()
        .question(
            Model::VALUE,
            |value| *value,
            move |_, cap| send.try_send(cap).map_err(|_| StartError::Closed),
        )
        .unwrap();
    let win = Win::with_questions(
        Model {
            value: Signal::new(1),
            other: Signal::new(0),
        },
        plan,
        WindowOptions {
            size: [1, 1],
            ..Default::default()
        },
    )
    .unwrap();
    (win, jobs)
}
#[test]
#[ignore = "manual paired release controls; no benchmark threshold"]
fn one_source_operation_cost() {
    let iterations = 20_000u64;
    for case in [
        "exact_unrelated",
        "coalesced_freeze",
        "completion_and_refresh",
    ] {
        let (mut win, jobs) = open();
        let mut cap = Some(jobs.recv().unwrap());
        let start = Instant::now();
        for n in 0..iterations {
            match case {
                "exact_unrelated" => {
                    black_box(win.set(Model::OTHER, n).unwrap());
                }
                "coalesced_freeze" => {
                    black_box(win.set(Model::VALUE, n).unwrap());
                }
                _ => {
                    cap.take().unwrap().complete(Ok(n)).unwrap();
                    black_box(win.deliver_ready(1).unwrap());
                    black_box(win.set(Model::VALUE, n).unwrap());
                    cap = Some(jobs.recv().unwrap());
                }
            }
        }
        let ns = start.elapsed().as_nanos();
        let checksum = *win.root().unwrap().value + *win.root().unwrap().other;
        assert_eq!(
            checksum,
            if case == "exact_unrelated" {
                iterations
            } else {
                iterations - 1
            }
        );
        println!("{case},{iterations},{ns},{checksum}");
        black_box(cap);
    }
}
