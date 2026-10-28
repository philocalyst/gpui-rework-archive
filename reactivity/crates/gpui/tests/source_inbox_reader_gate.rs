//! A source ingress refresh can revoke Ready without consuming a completion.
use gpui::{Completion, QuestionStatus, Questions, StartError, WindowOptions, prelude::*};
use std::{convert::Infallible, sync::mpsc};
struct Panel {
    value: Signal<u32>,
    answer: gpui::Reader<u32>,
}
const VALUE: Source<Panel, u32> =
    Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
impl View for Panel {
    fn sources() -> Sources<Self> {
        Sources::new().direct(VALUE)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.value),
            self.answer.project(|value| text(format!("answer-{value}"))),
        ))
    }
}
#[test]
fn exact_source_inbox_refresh_publishes_pending_reader_chrome_without_a_completion() {
    let (send, jobs) = mpsc::channel();
    let (questions, answer) = Questions::new()
        .question(
            VALUE,
            |value| *value,
            move |input, completion: Completion<u32, Infallible>| {
                send.send((input, completion))
                    .map_err(|_| StartError::Closed)
            },
        )
        .unwrap();
    let (remote, inbox) = Remote::bounded(1);
    let mut win = Win::with_questions(
        Panel {
            value: Signal::new(1),
            answer,
        },
        questions,
        WindowOptions::default(),
    )
    .unwrap()
    .with_inbox_for(inbox, VALUE, |value, next| *value = next)
    .unwrap();
    let (input, completion) = jobs.recv().unwrap();
    assert_eq!(input, 1);
    completion.complete(Ok(10)).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.with_ready(answer, |value| *value).unwrap(), Some(10));
    assert!(win.contains_text("answer-10").unwrap());
    win.reset_counters().unwrap();
    remote.try_send(2).unwrap();
    assert_eq!(win.deliver_ready(1).unwrap().applied, 1);
    assert_eq!(
        win.question_status(answer).unwrap(),
        QuestionStatus::Pending
    );
    assert_eq!(win.with_ready(answer, |value| *value).unwrap(), None);
    assert!(
        win.contains_text("Updating…").unwrap(),
        "Pending must publish Reader chrome even without a completed question"
    );
    assert_eq!(win.counters().owner_reruns, 1);
    let (input, completion) = jobs.recv().unwrap();
    assert_eq!(input, 2);
    completion.complete(Ok(20)).unwrap();
    win.deliver_ready(8).unwrap();
    assert_eq!(win.with_ready(answer, |value| *value).unwrap(), Some(20));
    assert!(win.contains_text("answer-20").unwrap());
    assert!(!win.contains_text("Updating…").unwrap());
}
