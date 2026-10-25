//! Minimal, standard-library-only sketch of a lending native selector API.

use std::any::Any;
use std::marker::PhantomData;

/// A runtime selector for nodes; selector identity deliberately says nothing about its target type.
#[derive(Clone, Copy)]
pub struct Select {
    class: &'static str,
}

impl Select {
    pub const fn descendants() -> Self {
        Self { class: "" }
    }

    pub const fn class(mut self, class: &'static str) -> Self {
        self.class = class;
        self
    }
}

pub struct Node {
    pub class: &'static str,
    pub value: Box<dyn Any>,
}

/// Root owns the exclusive borrow to the selected storage for the whole callback.
pub struct Root<'root> {
    nodes: &'root mut [Node],
}

impl<'root> Root<'root> {
    pub fn new(nodes: &'root mut [Node]) -> Self {
        Self { nodes }
    }

    /// `T` is inferred from an explicitly typed closure parameter. Its universal borrow is
    /// callback-scoped: no view can be returned or saved by safe code.
    pub fn select<T, S, F>(&mut self, selector: S, mut callback: F)
    where
        T: ?Sized + 'static,
        S: NativeSelector<T>,
        F: for<'a> FnMut(&'a mut T) -> (),
    {
        for node in self
            .nodes
            .iter_mut()
            .filter(|node| selector.matches(node.class))
        {
            if let Some(value) = selector.project(node.value.as_mut()) {
                callback(value);
            }
        }
    }

    /// Escape hatch for a low-level callback over a matched erased node.
    pub fn select_mut<F>(&mut self, selector: Select, mut callback: F)
    where
        F: for<'a> FnMut(&'a mut dyn Any) -> (),
    {
        for node in self
            .nodes
            .iter_mut()
            .filter(|node| node.class == selector.class)
        {
            callback(node.value.as_mut());
        }
    }
}

/// A target-specific projection that still lends only for the duration of each callback.
pub trait NativeSelector<T: ?Sized + 'static> {
    fn matches(&self, class: &'static str) -> bool;
    fn project<'a>(&self, value: &'a mut dyn Any) -> Option<&'a mut T>;
}

impl<T: Any> NativeSelector<T> for Select {
    fn matches(&self, class: &'static str) -> bool {
        self.class == class
    }

    fn project<'a>(&self, value: &'a mut dyn Any) -> Option<&'a mut T> {
        if value.is::<T>() {
            value.downcast_mut::<T>()
        } else {
            value
                .downcast_mut::<ViewElement<T>>()
                .map(ViewElement::pending_view_mut)
        }
    }
}

pub struct Field<Parent, Value> {
    name: &'static str,
    project: for<'a> fn(&'a mut Parent) -> &'a mut Value,
    _types: PhantomData<fn(Parent) -> Value>,
}

impl<Parent, Value> Copy for Field<Parent, Value> {}
impl<Parent, Value> Clone for Field<Parent, Value> {
    fn clone(&self) -> Self {
        *self
    }
}

impl<Parent, Value> Field<Parent, Value> {
    pub const fn new(
        name: &'static str,
        project: for<'a> fn(&'a mut Parent) -> &'a mut Value,
    ) -> Self {
        Self {
            name,
            project,
            _types: PhantomData,
        }
    }

    pub const fn name(self) -> &'static str {
        self.name
    }
}

pub struct FieldSelect<Parent, Value> {
    base: Select,
    field: Field<Parent, Value>,
}

impl Select {
    pub fn field<Parent, Value>(self, field: Field<Parent, Value>) -> FieldSelect<Parent, Value> {
        FieldSelect { base: self, field }
    }
}

impl<Parent: Any, Value: 'static> NativeSelector<Value> for FieldSelect<Parent, Value> {
    fn matches(&self, class: &'static str) -> bool {
        self.base.class == class
    }

    fn project<'a>(&self, value: &'a mut dyn Any) -> Option<&'a mut Value> {
        if value.is::<Parent>() {
            value.downcast_mut::<Parent>().map(self.field.project)
        } else {
            value
                .downcast_mut::<ViewElement<Parent>>()
                .map(|view| (self.field.project)(view.pending_view_mut()))
        }
    }
}

/// Models a pending `RenderOnce` subject wrapper selected before it is rendered.
pub struct ViewElement<View>(View);

impl<View> ViewElement<View> {
    pub fn new(view: View) -> Self {
        Self(view)
    }
    pub fn pending_view_mut(&mut self) -> &mut View {
        &mut self.0
    }
}

/// A method-table-like adapter lets a native role selector lend an unsized trait object.
pub struct RoleSelect<Role: ?Sized + 'static> {
    class: &'static str,
    project: for<'a> fn(&'a mut dyn Any) -> Option<&'a mut Role>,
}

impl<Role: ?Sized + 'static> RoleSelect<Role> {
    pub const fn new(
        class: &'static str,
        project: for<'a> fn(&'a mut dyn Any) -> Option<&'a mut Role>,
    ) -> Self {
        Self { class, project }
    }
}

impl<Role: ?Sized + 'static> NativeSelector<Role> for RoleSelect<Role> {
    fn matches(&self, class: &'static str) -> bool {
        self.class == class
    }
    fn project<'a>(&self, value: &'a mut dyn Any) -> Option<&'a mut Role> {
        (self.project)(value)
    }
}

#[derive(Debug)]
pub struct Card {
    pub title: String,
    pub count: u32,
}

impl Card {
    pub const fn fields() -> CardFields {
        CardFields {
            title: Field::new("title", |card| &mut card.title),
            count: Field::new("count", |card| &mut card.count),
        }
    }
}

pub struct CardFields {
    pub title: Field<Card, String>,
    pub count: Field<Card, u32>,
}

/// A concrete element normally has a direct typed projection. This trait models it.
pub trait Project<T> {
    fn project(&mut self) -> Option<&mut T>;
}

impl Project<Card> for Card {
    fn project(&mut self) -> Option<&mut Card> {
        Some(self)
    }
}

pub fn mutate_direct(card: &mut Card) {
    card.count = card.count.wrapping_add(1);
}

pub fn mutate_any(value: &mut dyn Any) {
    if let Some(card) = value.downcast_mut::<Card>() {
        card.count = card.count.wrapping_add(1);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    trait Titled {
        fn title(&self) -> &str;
    }
    impl Titled for Card {
        fn title(&self) -> &str {
            &self.title
        }
    }

    fn project_titled(value: &mut dyn Any) -> Option<&mut (dyn Titled + 'static)> {
        if value.is::<Card>() {
            value
                .downcast_mut::<Card>()
                .map(|card| card as &mut (dyn Titled + 'static))
        } else {
            value
                .downcast_mut::<ViewElement<Card>>()
                .map(|view| view.pending_view_mut() as &mut (dyn Titled + 'static))
        }
    }

    #[test]
    fn selected_node_and_typed_field_infer_from_the_callback() {
        let mut nodes = [
            Node {
                class: "card",
                value: Box::new(Card {
                    title: "title".into(),
                    count: 0,
                }),
            },
            Node {
                class: "card",
                value: Box::new(ViewElement::new(Card {
                    title: "component".into(),
                    count: 0,
                })),
            },
        ];
        let mut root = Root::new(&mut nodes);
        root.select(Select::descendants().class("card"), |card: &mut Card| {
            card.count += 1
        });
        root.select(
            Select::descendants()
                .class("card")
                .field(Card::fields().title),
            |title| title.push('!'),
        );
        root.select(RoleSelect::new("card", project_titled), |titled| {
            assert!(!titled.title().is_empty());
        });
        drop(root);
        let card = nodes[0].value.downcast_ref::<Card>().unwrap();
        assert_eq!(card.count, 1);
        assert_eq!(card.title, "title!");
        let wrapped = nodes[1].value.downcast_ref::<ViewElement<Card>>().unwrap();
        assert_eq!(wrapped.0.count, 1);
        assert_eq!(wrapped.0.title, "component!");
    }

    #[test]
    fn type_or_parent_mismatch_is_a_safe_non_match() {
        let mut calls = 0;
        let mut nodes = [Node {
            class: "card",
            value: Box::new(String::from("not a card")),
        }];
        let mut root = Root::new(&mut nodes);
        root.select(Select::descendants().class("card"), |_card: &mut Card| {
            calls += 1
        });
        root.select(
            Select::descendants()
                .class("card")
                .field(Card::fields().title),
            |_title: &mut String| calls += 1,
        );
        assert_eq!(calls, 0);
    }
}
