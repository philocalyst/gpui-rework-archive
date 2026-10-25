//! Macro-free Rust experiments for composing trait requirements.
//!
//! These examples separate two problems that are easy to conflate:
//! (1) statically proving that a concrete Rust type implements a combination of
//! traits, and (2) obtaining callable references to those traits after a value
//! has been erased behind `AnyElement`.

use std::marker::PhantomData;

pub mod indexed;

pub trait Draggable {
    fn payload(&self) -> &str;
    fn set_payload(&mut self, payload: String);
}

pub trait Badge {
    fn badge_count(&self) -> usize;
}

/// An ordinary Rust umbrella trait. This is the simplest zero-macro proof that
/// a type satisfies both capabilities.
pub trait DraggableBadge: Draggable + Badge {}

impl<T: Draggable + Badge> DraggableBadge for T {}

pub struct Card {
    payload: String,
    count: usize,
}

impl Card {
    pub fn new(payload: impl Into<String>, count: usize) -> Self {
        Self {
            payload: payload.into(),
            count,
        }
    }
}

impl Draggable for Card {
    fn payload(&self) -> &str {
        &self.payload
    }
    fn set_payload(&mut self, payload: String) {
        self.payload = payload;
    }
}

impl Badge for Card {
    fn badge_count(&self) -> usize {
        self.count
    }
}

/// On concrete values, both APIs are pleasant and statically checked.
pub fn with_individual_bounds<T: Draggable + Badge>(value: &mut T) {
    value.set_payload(format!("{}:{}", value.payload(), value.badge_count()));
}

pub fn with_group_bound<T: DraggableBadge>(value: &mut T) {
    value.set_payload(format!("{}:{}", value.payload(), value.badge_count()));
}

/// A manually implemented combined trait object works as well, with no macro.
/// `dyn DraggableBadge` inherits both method sets and remains object safe.
pub fn edit_erased_group(value: &mut dyn DraggableBadge) {
    value.set_payload(format!("{}:{}", value.payload(), value.badge_count()));
}

/// If the component traits expose the same method name, both the generic-bound
/// and umbrella-bound APIs have the same ambiguity. The caller must choose an
/// explicit trait path (`Draggable::label(value)` / `BadgeLabel::label(value)`).
pub trait DragLabel {
    fn label(&self) -> &'static str;
}
pub trait BadgeLabel {
    fn label(&self) -> &'static str;
}
pub trait LabeledGroup: DragLabel + BadgeLabel {}
impl<T: DragLabel + BadgeLabel> LabeledGroup for T {}

/// Capability markers model a typed selector's accumulated constraints. This
/// part is pure stable Rust and keeps query refinement fluent.
pub struct AllOf<A, B>(PhantomData<fn() -> (A, B)>);
pub struct Selector<Scope, Requirement> {
    _scope: PhantomData<fn() -> Scope>,
    _requirement: PhantomData<fn() -> Requirement>,
}

pub struct This;
pub struct Descendants;
pub struct Children;
pub struct StyledToken;
pub struct ParentToken;
pub struct DraggableToken;
pub struct BadgeToken;

impl<Scope, Requirement> Selector<Scope, Requirement> {
    pub fn require<Token>(self, _: Token) -> Selector<Scope, AllOf<Requirement, Token>> {
        Selector {
            _scope: PhantomData,
            _requirement: PhantomData,
        }
    }

    /// Scope-preserving refinement: changing the capability predicate doesn't
    /// accidentally turn a children query into a descendant query.
    pub fn class(self, _name: &'static str) -> Self {
        self
    }
}

pub fn this() -> Selector<This, ()> {
    Selector {
        _scope: PhantomData,
        _requirement: PhantomData,
    }
}
pub fn descendants() -> Selector<Descendants, ()> {
    Selector {
        _scope: PhantomData,
        _requirement: PhantomData,
    }
}
pub fn children() -> Selector<Children, ()> {
    Selector {
        _scope: PhantomData,
        _requirement: PhantomData,
    }
}

/// `require` composes requirements with intersection semantics. A realistic
/// dynamic query can store the corresponding runtime tokens next to this type.
pub fn fluent_query() -> Selector<Descendants, AllOf<AllOf<(), DraggableToken>, BadgeToken>> {
    descendants()
        .class("card")
        .require(DraggableToken)
        .require(BadgeToken)
}

/// Compile-time proof experiment. User-declared group traits are the stable
/// language feature that permits a generic `T: Group` bound. Rust cannot
/// express `T: C` when `C` is an arbitrary type parameter standing for a trait;
/// capability-specific bridges must be declared up front or generated.
pub trait Satisfies<Group: ?Sized> {}
impl<T: Draggable + Badge> Satisfies<dyn DraggableBadge> for T {}

pub fn proof_by_group<T: Satisfies<dyn DraggableBadge>>(_: &T) {}
