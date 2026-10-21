//! Ordinary borrowed descriptions, explicit consuming lowering and typed routes.
//!
//! Public descriptions own headers/children and borrow operands. They have no
//! ambient arena or generative frame lifetime. All structural traversal and
//! disposal is iterative, including disposal before lowering and during unwind.
use std::{any::Any, marker::PhantomData};

use crate::{
    View,
    source::{BindError, FieldAction, FieldId, IntoText, Sources, Text, TextValue},
    style::{Affine, Color, Flex, IntoLength, Style, nonnegative},
};

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub(crate) enum NodeKind {
    Div,
    Text,
    Input,
    Button,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(crate) enum Role {
    Generic,
    Text,
    TextInput,
    Button,
}

impl NodeKind {
    pub(crate) const fn role(self) -> Role {
        match self {
            Self::Div => Role::Generic,
            Self::Text => Role::Text,
            Self::Input => Role::TextInput,
            Self::Button => Role::Button,
        }
    }
}

/// A mount-site route. Its identity is the retained site, never a code address.
/// Ordinary method items are zero-sized captures, so their Box needs no allocation.
pub(crate) struct Handler(Box<dyn Route>);

trait Route {
    fn validate(&self, receiver: &dyn Any, sources: &dyn Any)
    -> Result<Option<FieldId>, BindError>;
    fn invoke(&self, receiver: &mut dyn Any) -> bool;
}

impl Handler {
    pub(crate) fn validate(
        &self,
        receiver: &dyn Any,
        sources: &dyn Any,
    ) -> Result<Option<FieldId>, BindError> {
        self.0.validate(receiver, sources)
    }

    pub(crate) fn invoke(&self, receiver: &mut dyn Any) -> bool {
        self.0.invoke(receiver)
    }
}

// The receiver type is encoded in this implementation's vtable. PhantomData
// contributes no storage, preserving a zero-sized route for method items.
struct MethodRoute<M, F> {
    callback: F,
    model: PhantomData<fn(M)>,
}

impl<M: 'static, F: Fn(&mut M)> Route for MethodRoute<M, F> {
    fn validate(&self, receiver: &dyn Any, _: &dyn Any) -> Result<Option<FieldId>, BindError> {
        if receiver.is::<M>() {
            Ok(None)
        } else {
            Err(BindError::ReceiverMismatch)
        }
    }

    fn invoke(&self, receiver: &mut dyn Any) -> bool {
        let Some(receiver) = receiver.downcast_mut::<M>() else {
            return false;
        };
        (self.callback)(receiver);
        true
    }
}

// Validation and invocation share the one source descriptor and update capture.
// An exact action has one box allocation, rather than separately boxed callbacks
// that duplicate Source. The runtime must validate before exact-source admission.
impl<M: 'static, T: TextValue, F: Fn(&mut T)> Route for FieldAction<M, T, F> {
    fn validate(
        &self,
        receiver: &dyn Any,
        sources: &dyn Any,
    ) -> Result<Option<FieldId>, BindError> {
        let receiver = receiver
            .downcast_ref::<M>()
            .ok_or(BindError::ReceiverMismatch)?;
        let sources = sources
            .downcast_ref::<Sources<M>>()
            .ok_or(BindError::ReceiverMismatch)?;
        self.validate_registered(receiver, sources)?;
        Ok(Some(self.field_id()))
    }

    fn invoke(&self, receiver: &mut dyn Any) -> bool {
        let Some(receiver) = receiver.downcast_mut::<M>() else {
            return false;
        };
        FieldAction::invoke(self, receiver);
        true
    }
}

/// The concrete branch currency. Leaves have no child allocation; only groups
/// with children own a child Vec. Handlers are allocated only when declared.
#[must_use]
pub struct El<'a> {
    kind: NodeKind,
    text: Option<Text<'a>>,
    children: Vec<El<'a>>,
    style: Style,
    on_click: Option<Handler>,
}

// The declaration payload order is explicitly preorder: local text/route first,
// then children from left to right. Children are emptied before any child El is
// dropped, so no structural destructor calls itself recursively at tree depth.
impl Drop for El<'_> {
    fn drop(&mut self) {
        drop(self.text.take());
        drop(self.on_click.take());
        let mut pending = std::mem::take(&mut self.children);
        pending.reverse();
        while let Some(mut child) = pending.pop() {
            let children = std::mem::take(&mut child.children);
            pending.extend(children.into_iter().rev());
            drop(child);
        }
    }
}

impl<'a> El<'a> {
    fn new(kind: NodeKind, text: Option<Text<'a>>) -> Self {
        Self {
            kind,
            text,
            children: Vec::new(),
            style: Style::default(),
            on_click: None,
        }
    }

    pub fn child<C, S>(mut self, children: C) -> Self
    where
        C: ChildSeq<'a, S>,
    {
        assert!(
            matches!(self.kind, NodeKind::Div | NodeKind::Button),
            "this element does not accept children"
        );
        children.append(&mut self.children);
        self
    }

    pub fn on_click<M: 'static, S, H: IntoHandler<M, S>>(self, handler: H) -> Self {
        handler.install(self)
    }

    pub fn w(mut self, width: impl IntoLength) -> Self {
        self.style.width = Some(nonnegative(width, "width"));
        self
    }
    pub fn h(mut self, height: impl IntoLength) -> Self {
        self.style.height = Some(nonnegative(height, "height"));
        self
    }
    pub fn size(mut self, size: impl IntoLength) -> Self {
        let size = nonnegative(size, "size");
        self.style.width = Some(size);
        self.style.height = Some(size);
        self
    }
    pub fn gap(mut self, gap: impl IntoLength) -> Self {
        self.style.gap = nonnegative(gap, "gap");
        self
    }
    pub fn p(mut self, padding: impl IntoLength) -> Self {
        self.style.padding = nonnegative(padding, "padding");
        self
    }
    pub fn font_size(mut self, size: impl IntoLength) -> Self {
        let size = nonnegative(size, "font size");
        assert!(size > 0.0, "font size must be positive");
        self.style.font_size = size;
        self
    }
    pub fn text_xs(self) -> Self {
        self.font_size(12)
    }
    pub fn text_sm(self) -> Self {
        self.font_size(14)
    }
    pub fn text_lg(self) -> Self {
        self.font_size(18)
    }
    pub fn fg(mut self, color: Color) -> Self {
        self.style.fg = color;
        self
    }
    pub fn bg(mut self, color: Color) -> Self {
        self.style.bg = color;
        self
    }
    pub fn transform(mut self, transform: Affine) -> Self {
        assert!(transform.is_finite(), "transform must be finite");
        self.style.transform = transform;
        self
    }
    pub fn layout(mut self, recipe: Flex) -> Self {
        self.style.flow = recipe.flow;
        if let Some(gap) = recipe.gap {
            self.style.gap = gap;
        }
        self
    }
    pub fn flex(self) -> Self {
        self.layout(Flex::row())
    }
    pub fn apply<T>(self, f: impl FnOnce(Self) -> T) -> T {
        f(self)
    }

    /// Consumes each header once, transferring routes/owned operands and copying
    /// borrowed operands only when the runtime promotes a changed destination.
    pub(crate) fn flatten(self) -> Vec<DraftNode<'a>> {
        let mut output = Vec::new();
        let mut pending = vec![(None, self)];
        while let Some((parent, mut element)) = pending.pop() {
            let index = u32::try_from(output.len()).expect("element count exceeds u32::MAX");
            let children = std::mem::take(&mut element.children);
            output.push(DraftNode {
                parent,
                kind: element.kind,
                text: element.text.take(),
                style: element.style,
                on_click: element.on_click.take(),
                editable: element.kind == NodeKind::Input,
            });
            pending.extend(children.into_iter().rev().map(|child| (Some(index), child)));
        }
        output
    }
}

pub(crate) struct DraftNode<'a> {
    pub(crate) parent: Option<u32>,
    pub(crate) kind: NodeKind,
    pub(crate) text: Option<Text<'a>>,
    pub(crate) style: Style,
    pub(crate) on_click: Option<Handler>,
    pub(crate) editable: bool,
}

pub fn div<'a>() -> El<'a> {
    El::new(NodeKind::Div, None)
}
pub fn text<'a>(text: impl IntoText<'a>) -> El<'a> {
    El::new(NodeKind::Text, Some(text.into_text()))
}
pub fn label<'a>(text: impl IntoText<'a>) -> El<'a> {
    self::text(text)
}
pub fn button<'a>(text: impl IntoText<'a>) -> El<'a> {
    El::new(NodeKind::Button, Some(text.into_text()))
}
/// A two-way text port accepts a writable String signal, never a snapshot.
/// Mounting additionally requires a registered owner-relative source projection.
///
/// ```compile_fail,E0308
/// use gpui::text_input;
/// let _input = text_input("snapshot");
/// ```
///
/// ```compile_fail,E0308
/// use gpui::{Signal, text_input};
/// let scalar = Signal::new(42_u32);
/// let _input = text_input(&scalar);
/// ```
pub fn text_input(text: &gpui_reactivity_state::Signal<String>) -> El<'_> {
    El::new(NodeKind::Input, Some(text.into_text()))
}

pub fn row<'a, C, S>(children: C) -> El<'a>
where
    C: ChildSeq<'a, S>,
{
    div().layout(Flex::row()).child(children)
}
pub fn column<'a, C, S>(children: C) -> El<'a>
where
    C: ChildSeq<'a, S>,
{
    div().layout(Flex::column()).child(children)
}

mod sealed {
    pub trait Element {}
    pub trait Children<S> {}
    pub trait Handler<M, S> {}
}

/// Methods run an ordinary conservative owner turn; a typed field action carries
/// a checked exact-source contract. No user-supplied impact can certify either.
pub trait IntoHandler<M, S>: sealed::Handler<M, S> {
    #[doc(hidden)]
    fn install(self, element: El<'_>) -> El<'_>;
}

impl<M, F: Fn(&mut M) + 'static> sealed::Handler<M, shape::Method> for F {}
impl<M: 'static, F: Fn(&mut M) + 'static> IntoHandler<M, shape::Method> for F {
    fn install(self, mut element: El<'_>) -> El<'_> {
        element.on_click = Some(Handler(Box::new(MethodRoute {
            callback: self,
            model: PhantomData::<fn(M)>,
        })));
        element
    }
}

impl<M, T, F> sealed::Handler<M, shape::Field> for FieldAction<M, T, F> {}
impl<M: 'static, T: TextValue, F: Fn(&mut T) + 'static> IntoHandler<M, shape::Field>
    for FieldAction<M, T, F>
{
    fn install(self, mut element: El<'_>) -> El<'_> {
        element.on_click = Some(Handler(Box::new(self)));
        element
    }
}

/// A sealed leaf return type. Use `El<'_>` when callers need to branch over it;
/// use `impl Element + '_` to hide a borrowed leaf's concrete description type.
pub trait Element: sealed::Element + Sized {
    #[doc(hidden)]
    fn into_el<'a>(self) -> El<'a>
    where
        Self: 'a;
}
impl sealed::Element for El<'_> {}
impl Element for El<'_> {
    fn into_el<'a>(self) -> El<'a>
    where
        Self: 'a,
    {
        self
    }
}

#[doc(hidden)]
pub mod shape {
    pub struct One;
    pub struct Tuple<T>(pub(crate) std::marker::PhantomData<T>);
    pub struct Optional<T>(pub(crate) std::marker::PhantomData<T>);
    pub struct Iter<T>(pub(crate) std::marker::PhantomData<T>);
    pub struct Views;
    pub struct View;
    pub struct Method;
    pub struct Field;
}

/// Closed constructor-child family. The inferred shape parameter separates
/// blanket iterator implementations from tuples without an application adapter.
pub trait ChildSeq<'a, S>: sealed::Children<S> {
    #[doc(hidden)]
    fn append(self, out: &mut Vec<El<'a>>);
}
impl<E: Element> sealed::Children<shape::One> for E {}
impl<'a, E: Element + 'a> ChildSeq<'a, shape::One> for E {
    fn append(self, out: &mut Vec<El<'a>>) {
        out.push(self.into_el());
    }
}
impl<C, S> sealed::Children<shape::Optional<S>> for Option<C> where C: sealed::Children<S> {}
impl<'a, C, S> ChildSeq<'a, shape::Optional<S>> for Option<C>
where
    C: ChildSeq<'a, S>,
{
    fn append(self, out: &mut Vec<El<'a>>) {
        if let Some(children) = self {
            children.append(out);
        }
    }
}
impl<I, S> sealed::Children<shape::Iter<S>> for I
where
    I: Iterator,
    I::Item: sealed::Children<S>,
{
}
impl<'a, I, S> ChildSeq<'a, shape::Iter<S>> for I
where
    I: Iterator,
    I::Item: ChildSeq<'a, S>,
{
    fn append(self, out: &mut Vec<El<'a>>) {
        for children in self {
            children.append(out);
        }
    }
}
impl<T: View> sealed::Children<shape::Views> for &Vec<T> {}
impl<'a, T: View + 'a> ChildSeq<'a, shape::Views> for &'a Vec<T> {
    fn append(self, out: &mut Vec<El<'a>>) {
        out.extend(self.iter().map(View::view));
    }
}
impl<T: View> sealed::Children<shape::View> for &T {}
impl<'a, T: View + 'a> ChildSeq<'a, shape::View> for &'a T {
    fn append(self, out: &mut Vec<El<'a>>) {
        out.push(self.view());
    }
}
impl sealed::Children<shape::Tuple<()>> for () {}
impl<'a> ChildSeq<'a, shape::Tuple<()>> for () {
    fn append(self, _: &mut Vec<El<'a>>) {}
}
macro_rules! tuples {
    ($($ty:ident $shape:ident $name:ident),+) => {
        impl<$($ty,$shape),+> sealed::Children<shape::Tuple<($($shape,)+)>> for ($($ty,)+)
        where $($ty: sealed::Children<$shape>),+ {}
        impl<'a,$($ty,$shape),+> ChildSeq<'a,shape::Tuple<($($shape,)+)>> for ($($ty,)+)
        where $($ty: ChildSeq<'a,$shape>),+ {
            fn append(self,out: &mut Vec<El<'a>>) {
                let ($($name,)+) = self;
                $($name.append(out);)+
            }
        }
    };
}
tuples!(A SA a);
tuples!(A SA a,B SB b);
tuples!(A SA a,B SB b,C SC c);
tuples!(A SA a,B SB b,C SC c,D SD d);
tuples!(A SA a,B SB b,C SC c,D SD d,E SE e);
tuples!(A SA a,B SB b,C SC c,D SD d,E SE e,F SF f);
tuples!(A SA a,B SB b,C SC c,D SD d,E SE e,F SF f,G SG g);
tuples!(A SA a,B SB b,C SC c,D SD d,E SE e,F SF f,G SG g,H SH h);

#[cfg(test)]
mod tests {
    use super::*;
    use crate::source::Source;
    use gpui_reactivity_state::Signal;
    use std::{cell::RefCell, mem::size_of, rc::Rc};

    struct Panel(String);
    impl View for Panel {
        fn view(&self) -> El<'_> {
            text(&self.0)
        }
    }

    #[test]
    fn concrete_branches_opaque_leaves_and_constructor_children_lower() {
        fn leaf(name: &str) -> impl Element + '_ {
            text(name)
        }
        fn static_leaf() -> impl Element {
            text("static")
        }
        fn empty() -> El<'static> {
            text("empty")
        }
        let panels = vec![Panel("first".into()), Panel("second".into())];
        let branch = if panels.is_empty() {
            empty()
        } else {
            panels[0].view()
        };
        let nodes = column((
            branch,
            row(&panels),
            Some(leaf(&panels[1].0)),
            row(panels.iter().map(|panel| text(&panel.0))),
            static_leaf(),
            &panels[0],
        ))
        .gap(8)
        .p(4)
        .flatten();
        assert_eq!(nodes.len(), 11);
        assert_eq!(nodes[0].parent, None);
        assert_eq!(nodes[0].style.gap, 8.0);
        assert_eq!(nodes[0].style.padding, 4.0);
        let parents: Vec<_> = nodes.iter().map(|node| node.parent).collect();
        assert_eq!(
            parents,
            [
                None,
                Some(0),
                Some(0),
                Some(2),
                Some(2),
                Some(0),
                Some(0),
                Some(6),
                Some(6),
                Some(0),
                Some(0)
            ]
        );
    }

    struct Model {
        count: Signal<u32>,
        other: Signal<u32>,
    }
    impl Model {
        fn increment(&mut self) {
            *self.count += 1;
        }
    }
    const COUNT: Source<Model, u32> =
        Source::new(FieldId::new(1), "count", |m| &m.count, |m| &mut m.count);

    #[test]
    fn method_items_keep_zero_sized_callback_and_receiver_check() {
        let mut nodes = button("increment").on_click(Model::increment).flatten();
        let handler = nodes[0].on_click.take().unwrap();
        assert_eq!(std::mem::size_of_val(handler.0.as_ref()), 0);
        assert_eq!(size_of::<Handler>(), 2 * size_of::<usize>());
        let mut wrong_receiver = 10_u32;
        assert!(!handler.invoke(&mut wrong_receiver));
        assert_eq!(
            handler.validate(&wrong_receiver, &()),
            Err(BindError::ReceiverMismatch)
        );
        let mut model = Model {
            count: Signal::new(1),
            other: Signal::new(7),
        };
        assert_eq!(handler.validate(&model, &Sources::<Model>::new()), Ok(None));
        assert!(handler.invoke(&mut model));
        assert_eq!(*model.count, 2);
        assert_eq!(*model.other, 7);
    }

    #[test]
    fn typed_field_routes_validate_projection_before_exact_admission() {
        let mut model = Model {
            count: Signal::new(1),
            other: Signal::new(7),
        };
        let sources = Sources::new().field(COUNT);
        let action = COUNT.update(|count| *count += 1);
        let action_bytes = std::mem::size_of_val(&action);
        let mut nodes = button("increment").on_click(action).flatten();
        let handler = nodes[0].on_click.take().unwrap();
        assert_eq!(std::mem::size_of_val(handler.0.as_ref()), action_bytes);
        assert_eq!(handler.validate(&model, &sources), Ok(Some(COUNT.id())));
        assert_eq!(
            handler.validate(&model, &()),
            Err(BindError::ReceiverMismatch)
        );
        assert!(!handler.invoke(&mut 0_u32));
        assert!(handler.invoke(&mut model));
        assert_eq!(*model.count, 2);
        assert_eq!(*model.other, 7);

        let imposter = Source::new(
            COUNT.id(),
            "imposter",
            |m: &Model| &m.other,
            |m| &mut m.other,
        );
        let mut nodes = button("invalid")
            .on_click(imposter.update(|count| *count += 1))
            .flatten();
        let handler = nodes[0].on_click.take().unwrap();
        assert_eq!(
            handler.validate(&model, &sources),
            Err(BindError::ProjectionMismatch(COUNT.id()))
        );
        assert_eq!(*model.other, 7);
    }

    fn chain(depth: usize) -> El<'static> {
        let mut el = text("bottom");
        for _ in 0..depth {
            el = div().child(el);
        }
        el
    }

    #[test]
    fn adversarial_depth_drop_and_lowering_fit_a_small_stack() {
        std::thread::Builder::new()
            .stack_size(64 * 1024)
            .spawn(|| {
                drop(chain(100_000));
                let rejected =
                    std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| chain(100_000).w(-1)));
                assert!(rejected.is_err());
                let nodes = chain(100_000).flatten();
                assert_eq!(nodes.len(), 100_001);
                assert_eq!(nodes[100_000].parent, Some(99_999));
                assert_eq!(
                    nodes[100_000].text.as_ref().unwrap().borrowed_value(),
                    "bottom"
                );
            })
            .unwrap()
            .join()
            .unwrap();
    }

    #[test]
    fn wide_description_preserves_order() {
        let nodes = row((0..10_000).map(|n| text(n.to_string()))).flatten();
        assert_eq!(nodes.len(), 10_001);
        for (index, node) in nodes[1..].iter().enumerate() {
            assert_eq!(node.parent, Some(0));
            assert_eq!(
                node.text.as_ref().unwrap().borrowed_value(),
                index.to_string()
            );
        }
    }

    #[test]
    fn unlowered_handler_payloads_drop_once_in_preorder() {
        struct Record(usize, Rc<RefCell<Vec<usize>>>);
        impl Drop for Record {
            fn drop(&mut self) {
                self.1.borrow_mut().push(self.0);
            }
        }
        fn tracked(id: usize, log: &Rc<RefCell<Vec<usize>>>) -> El<'static> {
            let record = Record(id, log.clone());
            div().on_click(move |_: &mut ()| {
                let _ = &record;
            })
        }
        let log = Rc::new(RefCell::new(Vec::new()));
        drop(tracked(0, &log).child((tracked(1, &log).child(tracked(2, &log)), tracked(3, &log))));
        assert_eq!(*log.borrow(), [0, 1, 2, 3]);
        log.borrow_mut().clear();
        let nodes = tracked(0, &log)
            .child((tracked(1, &log).child(tracked(2, &log)), tracked(3, &log)))
            .flatten();
        assert!(
            log.borrow().is_empty(),
            "lowering transfers payloads without dropping them"
        );
        drop(nodes);
        assert_eq!(*log.borrow(), [0, 1, 2, 3]);
    }

    #[test]
    fn input_role_and_literal_style_reach_the_same_draft() {
        let owner = Signal::new(String::from("query"));
        let nodes = text_input(&owner)
            .w(320)
            .h(24)
            .fg(Color::rgb(1, 2, 3))
            .transform(Affine::translation(10.0, 20.0))
            .flatten();
        assert!(nodes[0].editable);
        assert_eq!(nodes[0].kind.role(), Role::TextInput);
        assert!(nodes[0].text.as_ref().unwrap().signal().is_some());
        assert_eq!(nodes[0].style.width, Some(320.0));
        assert_eq!(nodes[0].style.height, Some(24.0));
        assert_eq!(nodes[0].style.fg, Color::rgb(1, 2, 3));
    }

    #[test]
    fn size_ledger_counts_inline_route_and_style_costs() {
        eprintln!(
            "El={} Style={} DraftNode={} Handler={}",
            size_of::<El<'_>>(),
            size_of::<Style>(),
            size_of::<DraftNode<'_>>(),
            size_of::<Handler>()
        );
        let el = text("borrowed");
        assert_eq!(el.children.capacity(), 0);
        assert!(el.on_click.is_none());
    }
}
