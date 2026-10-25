use gpui::{Completion, LaneSet, Questions, Reader, StartError, WindowOptions, prelude::*};
use std::convert::Infallible;

struct Nested {
    child: Signal<String>,
}
struct Page {
    outer: Signal<Nested>,
    answer: Reader<String>,
}
impl Page {
    const INNER: Source<Self, String> = Source::new(
        FieldId::new(2),
        "inner",
        |m| &m.outer.child,
        |m| &mut m.outer.child,
    );
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::INNER)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.outer.child),
            self.answer
                .project(|value| text(value.clone()))
                .loading(|| text("pending")),
        ))
    }
}
fn start(value: String, completion: Completion<String, Infallible>) -> Result<(), StartError> {
    completion.complete(Ok(format!("answer:{value}"))).unwrap();
    Ok(())
}
fn drain<M: View + 'static, L: LaneSet<M>>(owner: &mut Win<M, L>) {
    for _ in 0..8 {
        if !owner.deliver_ready(8).unwrap().more {
            return;
        }
    }
    panic!("synchronous completion failed to settle in eight batches");
}

#[test]
fn coarse_replacement_refreshes_same_address_zero_revision_inner_source() {
    let (questions, answer) = Questions::new()
        .question(Page::INNER, Clone::clone, start)
        .unwrap();
    let mut owner = Win::with_questions(
        Page {
            outer: Signal::new(Nested {
                child: Signal::new("old".into()),
            }),
            answer,
        },
        questions,
        WindowOptions::default(),
    )
    .unwrap();
    drain(&mut owner);
    assert!(owner.contains_text("answer:old").unwrap());
    let before = &owner.root().unwrap().outer.child as *const Signal<String>;
    owner
        .update(|model| {
            *model.outer = Nested {
                child: Signal::new("new".into()),
            };
        })
        .unwrap();
    drain(&mut owner);
    assert_eq!(before, &owner.root().unwrap().outer.child);
    assert_eq!(owner.root().unwrap().outer.child.revision().get(), 0);
    assert!(owner.contains_text("new").unwrap());
    assert!(owner.contains_text("answer:new").unwrap());
}

struct HeapPage {
    outer: Signal<Vec<Signal<String>>>,
    answer: Reader<String>,
}
impl HeapPage {
    const INNER: Source<Self, String> = Source::new(
        FieldId::new(2),
        "inner",
        |m| &m.outer[0],
        |m| &mut m.outer[0],
    );
}
impl View for HeapPage {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::INNER)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.outer[0]),
            self.answer
                .project(|value| text(value.clone()))
                .loading(|| text("pending")),
        ))
    }
}
#[test]
fn coarse_in_place_heap_edit_refreshes_inner_text_and_question() {
    let (questions, answer) = Questions::new()
        .question(HeapPage::INNER, Clone::clone, start)
        .unwrap();
    let mut owner = Win::with_questions(
        HeapPage {
            outer: Signal::new(vec![Signal::new("old".into())]),
            answer,
        },
        questions,
        WindowOptions::default(),
    )
    .unwrap();
    drain(&mut owner);
    let before = &owner.root().unwrap().outer[0] as *const Signal<String>;
    owner.update(|model| model.outer[0].push('!')).unwrap();
    drain(&mut owner);
    assert_eq!(before, &owner.root().unwrap().outer[0]);
    assert!(owner.contains_text("old!").unwrap());
    assert!(owner.contains_text("answer:old!").unwrap());
}

#[test]
fn nested_signal_state_construction_default_and_serde_remain_general() {
    let nested = Signal::new(vec![Signal::new(7_u32)]);
    let json = serde_json::to_string(&nested).unwrap();
    let restored: Signal<Vec<Signal<u32>>> = serde_json::from_str(&json).unwrap();
    assert_eq!(*restored[0], 7);
    let empty = Signal::<Vec<Signal<u32>>>::default();
    assert!(empty.is_empty());
}

#[test]
fn generic_leaf_declaration_and_erased_leaf_values_remain_supported() {
    fn declare<M, T: gpui::SourceValue>(
        read: fn(&M) -> &Signal<T>,
        write: fn(&mut M) -> &mut Signal<T>,
    ) -> Source<M, T> {
        Source::new(FieldId::new(0), "leaf", read, write)
    }
    struct Model(Signal<Box<dyn std::any::Any + gpui::SourceValue>>);
    let declaration = declare::<Model, _>(|model| &model.0, |model| &mut model.0);
    let copy = declaration;
    assert_eq!(declaration.id(), copy.id());
    let model = Model(Signal::new(Box::new(7_u32)));
    assert_eq!(
        (&**model.0 as &dyn std::any::Any).downcast_ref::<u32>(),
        Some(&7)
    );
}
