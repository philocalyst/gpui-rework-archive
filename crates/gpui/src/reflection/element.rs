//! Owned and borrowed views of an erased element.

use super::{CallableReflectionToken, ElementReflection, ReflectionGroup};
use crate::{
    AnyElement, App, Bounds, Element, ElementId, GlobalElementId, InspectorElementId, IntoElement,
    LayoutId, Pixels, Window,
};
use std::{any::Any, marker::PhantomData, panic};

mod sealed {
    pub trait Receiver {}
    impl Receiver for crate::AnyElement {}
    impl Receiver for &mut crate::AnyElement {}
}

/// Storage for a reflected view. Implementations preserve the original receiver.
#[doc(hidden)]
pub trait ReflectionReceiver: sealed::Receiver {
    fn element(&self) -> &AnyElement;
    fn element_mut(&mut self) -> &mut AnyElement;
}

impl ReflectionReceiver for AnyElement {
    fn element(&self) -> &AnyElement {
        self
    }
    fn element_mut(&mut self) -> &mut AnyElement {
        self
    }
}

impl ReflectionReceiver for &mut AnyElement {
    fn element(&self) -> &AnyElement {
        self
    }
    fn element_mut(&mut self) -> &mut AnyElement {
        self
    }
}

/// An element view exposing a statically checked set of capabilities.
/// The default storage owns the element; borrowed views lend it for one scope.
/// Borrowed methods dispatch to its concrete type; owned builders and explicit
/// `#[reflect(wrapper_default)]` methods use their trait bodies.
pub struct ReflectedElement<Group, Receiver = AnyElement>
where
    Group: ReflectionGroup,
{
    pub(crate) element: Receiver,
    tables: Group::Tables,
    group: PhantomData<fn() -> Group>,
}

impl<Group, Receiver> ReflectedElement<Group, Receiver>
where
    Group: ReflectionGroup,
    Receiver: ReflectionReceiver,
{
    fn from_bound_receiver(element: Receiver, tables: Group::Tables) -> Self {
        Self {
            element,
            tables,
            group: PhantomData,
        }
    }

    pub(crate) fn from_bound(element: Receiver, tables: Group::Tables) -> Self {
        Self::from_bound_receiver(element, tables)
    }

    /// Temporarily narrows this view to one statically admitted capability.
    /// The borrow ends before another capability can access the receiver.
    pub fn with<Token, Proof, Output>(
        &mut self,
        token: Token,
        edit: impl FnOnce(ReflectedElement<Token::Group, &mut AnyElement>) -> Output,
    ) -> Output
    where
        Token: CallableReflectionToken,
        Group: super::ContainsCallable<Token, Proof>,
    {
        let _ = token;
        let tables = Token::Group::bind_tables(self.element.element().reflection())
            .expect("admitted capability must have its exact native method tables");
        edit(ReflectedElement::from_bound_receiver(
            self.element.element_mut(),
            tables,
        ))
    }

    /// Borrows the concrete element when its type matches.
    pub fn downcast_ref<Type: 'static>(&self) -> Option<&Type> {
        self.element.element().downcast_ref()
    }

    /// Borrows the concrete element when its type matches.
    pub fn downcast_mut<Type: 'static>(&mut self) -> Option<&mut Type> {
        self.element.element_mut().downcast_mut()
    }

    /// Lends a registered capability admitted by this view's static trait set.
    /// Each projection reborrows the receiver, so two mutable views cannot overlap.
    pub fn capability<Type: ?Sized + 'static, Key: ?Sized + 'static, Proof>(
        &mut self,
        capability: super::Capability<Type, Key>,
    ) -> &mut Type
    where
        Group: super::ContainsCallable<super::Capability<Type, Key>, Proof>,
    {
        let _ = capability;
        let methods =
            <Group as super::ContainsCallable<super::Capability<Type, Key>, Proof>>::methods(
                &self.tables,
            );
        methods
            .get_mut(self.element.element_mut().inner_element_mut())
            .expect("admitted capability must target this receiver")
    }

    #[doc(hidden)]
    pub fn __reflection_parts_mut<Token>(
        &mut self,
        _token: Token,
    ) -> (&'static Token::Methods, &mut dyn Any)
    where
        Token: CallableReflectionToken,
        Group: super::IncludesCallableTrait<Token>,
    {
        let methods = <Group as super::IncludesCallableTrait<Token>>::methods(&self.tables);
        let element = self.element.element_mut();
        (methods, element.inner_element_mut())
    }

    #[doc(hidden)]
    pub fn __reflection_parts<Token>(&self, _token: Token) -> (&'static Token::Methods, &dyn Any)
    where
        Token: CallableReflectionToken,
        Group: super::IncludesCallableTrait<Token>,
    {
        let methods = <Group as super::IncludesCallableTrait<Token>>::methods(&self.tables);
        let element = self.element.element();
        (methods, element.inner_element())
    }
}

impl<Group: ReflectionGroup> ReflectedElement<Group> {
    #[cfg(any(test, feature = "bench-support"))]
    pub(crate) fn new(element: AnyElement) -> Self {
        let tables = Group::bind_tables(element.reflection())
            .expect("admitted reflection group must have its exact native method tables");
        Self::from_bound(element, tables)
    }
}

impl<Group> Element for ReflectedElement<Group>
where
    Group: ReflectionGroup,
{
    type RequestLayoutState = <AnyElement as Element>::RequestLayoutState;
    type PrepaintState = <AnyElement as Element>::PrepaintState;

    fn reflection(&self) -> &'static ElementReflection {
        self.element.reflection()
    }

    fn into_any(self) -> AnyElement {
        self.element
    }

    fn id(&self) -> Option<ElementId> {
        <AnyElement as Element>::id(&self.element)
    }

    fn source_location(&self) -> Option<&'static panic::Location<'static>> {
        <AnyElement as Element>::source_location(&self.element)
    }

    fn request_layout(
        &mut self,
        global_id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, Self::RequestLayoutState) {
        <AnyElement as Element>::request_layout(
            &mut self.element,
            global_id,
            inspector_id,
            window,
            cx,
        )
    }

    fn prepaint(
        &mut self,
        global_id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        window: &mut Window,
        cx: &mut App,
    ) -> Self::PrepaintState {
        <AnyElement as Element>::prepaint(
            &mut self.element,
            global_id,
            inspector_id,
            bounds,
            request_layout,
            window,
            cx,
        )
    }

    fn paint(
        &mut self,
        global_id: Option<&GlobalElementId>,
        inspector_id: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        request_layout: &mut Self::RequestLayoutState,
        prepaint: &mut Self::PrepaintState,
        window: &mut Window,
        cx: &mut App,
    ) {
        <AnyElement as Element>::paint(
            &mut self.element,
            global_id,
            inspector_id,
            bounds,
            request_layout,
            prepaint,
            window,
            cx,
        );
    }
}

impl<Group> IntoElement for ReflectedElement<Group>
where
    Group: ReflectionGroup,
{
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }

    fn into_any_element(self) -> AnyElement {
        self.element
    }
}
