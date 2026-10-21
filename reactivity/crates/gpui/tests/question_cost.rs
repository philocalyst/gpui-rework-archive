//! Manual paired owner-turn evidence, not a claim that these APIs do equal work.
use gpui::{Completion, Questions, Reader, Remote, WindowOptions, prelude::*};
use std::{convert::Infallible, hint::black_box, sync::mpsc, time::Instant};
struct Direct {
    input: Signal<u64>,
    answer: Signal<u64>,
}
impl Direct {
    const INPUT: Source<Self, u64> =
        Source::new(FieldId::new(1), "input", |m| &m.input, |m| &mut m.input);
}
impl View for Direct {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::INPUT)
    }
    fn view(&self) -> El<'_> {
        column((text(&self.input), text(&self.answer)))
    }
}
struct Asked {
    input: Signal<u64>,
    answer: Reader<u64>,
}
impl Asked {
    const INPUT: Source<Self, u64> =
        Source::new(FieldId::new(1), "input", |m| &m.input, |m| &mut m.input);
}
impl View for Asked {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::INPUT)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.input),
            self.answer.project(|value| text(value.to_string())),
        ))
    }
}
fn options() -> WindowOptions {
    WindowOptions {
        size: [240, 100],
        ..Default::default()
    }
}
fn remote(iterations: u64) -> u128 {
    let (remote, inbox) = Remote::bounded(1);
    let mut win = Win::recording(
        Direct {
            input: Signal::new(0),
            answer: Signal::new(0),
        },
        options(),
    )
    .unwrap()
    .with_inbox(inbox, |model, value| *model.answer = value)
    .unwrap();
    let started = Instant::now();
    for i in 1..=iterations {
        win.set(Direct::INPUT, i).unwrap();
        remote.try_send(i).unwrap();
        black_box(win.deliver_ready(8).unwrap());
    }
    started.elapsed().as_nanos() / u128::from(iterations)
}
fn question(iterations: u64) -> u128 {
    let (send, jobs) = mpsc::sync_channel(1);
    let (questions, answer) = Questions::new()
        .question(
            Asked::INPUT,
            |value| *value,
            move |input, cap: Completion<u64, Infallible>| {
                send.try_send((input, cap)).unwrap();
                Ok(())
            },
        )
        .unwrap();
    let mut win = Win::recording_questions(
        Asked {
            input: Signal::new(0),
            answer,
        },
        questions,
        options(),
    )
    .unwrap();
    let (value, cap) = jobs.recv().unwrap();
    cap.complete(Ok(value)).unwrap();
    win.deliver_ready(8).unwrap();
    let started = Instant::now();
    for i in 1..=iterations {
        win.set(Asked::INPUT, i).unwrap();
        let (value, cap) = jobs.try_recv().unwrap();
        cap.complete(Ok(value)).unwrap();
        black_box(win.deliver_ready(8).unwrap());
    }
    started.elapsed().as_nanos() / u128::from(iterations)
}
#[test]
#[ignore = "manual release paired evidence; each question also describes status/content regions"]
fn paired_real_owner_turn_cost() {
    println!("round,kind,ns_per_edit_and_delivery");
    // Warm each independent path before alternating measurement order.
    black_box(remote(10));
    black_box(question(10));
    for round in 0..7 {
        let (r, q) = if round % 2 == 0 {
            (remote(200), question(200))
        } else {
            let q = question(200);
            (remote(200), q)
        };
        println!("{round},remote,{r}\n{round},question,{q}");
    }
}
