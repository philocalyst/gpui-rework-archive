//! Explicit contained-owner projections. A component is ordinary parent-owned
//! state, not an independently scheduled or reference-counted Entity.
use std::any::Any;

use crate::{
    El, View,
    element::{Admission, Handler},
    source::{BindError, FieldId, Sources},
};

/// Declare once per contained field, then register with `Sources::component` and
/// describe with `COMPONENT.view(self)`. The child keeps its own View, methods,
/// and source schema unchanged. IDs/names are local to each parent's schema.
///
/// Projectors must select the same stable child and have no side effects. Shared
/// and exclusive agreement is checked while the parent is borrowed; no model
/// address is retained. Arbitrary child methods use the parent's scheduling grain.
pub struct Component<P, C> {
    pub(crate) id: FieldId,
    pub(crate) name: &'static str,
    pub(crate) read: fn(&P) -> &C,
    pub(crate) write: fn(&mut P) -> &mut C,
}
impl<P, C> Copy for Component<P, C> {}
impl<P, C> Clone for Component<P, C> {
    fn clone(&self) -> Self {
        *self
    }
}
impl<P, C> Component<P, C> {
    pub const fn new(
        id: FieldId,
        name: &'static str,
        read: fn(&P) -> &C,
        write: fn(&mut P) -> &mut C,
    ) -> Self {
        Self {
            id,
            name,
            read,
            write,
        }
    }
    pub const fn id(self) -> FieldId {
        self.id
    }
    pub const fn name(self) -> &'static str {
        self.name
    }
    pub(crate) fn project_mut<'a>(&self, parent: &'a mut P) -> Result<&'a mut C, BindError> {
        let read = (self.read)(parent) as *const C;
        let write = (self.write)(parent);
        if std::ptr::eq(read, write as *const C) {
            Ok(write)
        } else {
            Err(BindError::ComponentProjectionMismatch(self.id))
        }
    }
}
impl<P: 'static, C: View + 'static> Component<P, C> {
    /// Describe this contained field while borrowing its parent normally.
    ///
    /// ```compile_fail
    /// use gpui::{Component, El, FieldId, View, text};
    /// struct Child { value: String }
    /// impl View for Child {
    ///     fn view(&self) -> El<'_> { text(&self.value) }
    /// }
    /// struct Parent { child: Child }
    /// const CHILD: Component<Parent, Child> = Component::new(
    ///     FieldId::new(1), "child", |p| &p.child, |p| &mut p.child,
    /// );
    /// let mut parent = Parent { child: Child { value: "borrowed".into() } };
    /// let element = CHILD.view(&parent);
    /// parent.child.value.push('!');
    /// drop(element);
    /// ```
    pub fn view<'a>(self, parent: &'a P) -> El<'a> {
        let mut element = (self.read)(parent).view();
        element.map_handlers(move |handler| handler.in_component(self));
        element.component(self)
    }
    pub(crate) fn handler_scope(
        &self,
        parent: &P,
        sources: &Sources<P>,
        handler: &Handler,
    ) -> Result<u32, BindError> {
        let registration = sources.component_entry::<C>(self.id)?;
        let child = (self.read)(parent);
        if !std::ptr::eq(child, (registration.component.read)(parent)) {
            return Err(BindError::ComponentProjectionMismatch(self.id));
        }
        handler
            .owner_scope(child as &dyn Any, &registration.sources)
            .map(|scope| registration.qualify_scope(scope))
    }
    pub(crate) fn admit_handler(
        &self,
        parent: &P,
        sources: &Sources<P>,
        handler: &Handler,
    ) -> Result<Admission, BindError> {
        let registration = sources.component_entry::<C>(self.id)?;
        let child = (self.read)(parent);
        if !std::ptr::eq(child, (registration.component.read)(parent)) {
            return Err(BindError::ComponentProjectionMismatch(self.id));
        }
        match handler.admit(child as &dyn Any, &registration.sources)? {
            Admission::Model { exact } => Ok(Admission::Model {
                exact: exact.map(|field| registration.qualify(field)),
            }),
            Admission::Property => Ok(Admission::Property),
            Admission::Window(_) => Err(BindError::ReceiverMismatch),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::source::ComponentEntry;
    use std::mem::size_of;
    #[test]
    fn component_storage_ledger_has_no_owning_model_pointer() {
        eprintln!(
            "Component={} FieldId={} Sources={} ComponentEntry={}",
            size_of::<Component<(), ()>>(),
            size_of::<FieldId>(),
            size_of::<Sources<()>>(),
            size_of::<ComponentEntry<(), ()>>()
        );
        assert_eq!(size_of::<FieldId>(), 8);
        assert_eq!(size_of::<Component<(), ()>>(), 8 + 4 * size_of::<usize>());
    }
}
