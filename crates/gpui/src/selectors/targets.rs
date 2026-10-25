//! Lending projections selected before an element enters layout.

use crate::reflection::{Capability, ElementReflection, ReflectedElement, ReflectionGroup};
use crate::{AnyElement, ViewElement};
use std::marker::PhantomData;

/// Projects a matched element for a synchronous mutation callback.
///
/// Every returned view borrows the original node. The callback cannot retain it
/// or return a replacement, and projections never allocate another element.
#[doc(hidden)]
pub trait SelectionTarget<Group: ReflectionGroup>: 'static {
    /// Immutable, receiver-independent data prepared for one concrete schema.
    type Tables: Copy + 'static;
    type View<'a>;
    fn bind(&self, metadata: &'static ElementReflection) -> Option<Self::Tables>;
    fn project<'a>(
        &self,
        tables: Self::Tables,
        element: &'a mut AnyElement,
    ) -> Option<Self::View<'a>>;
}

/// The default projection lends the selected reflected capabilities.
#[doc(hidden)]
pub struct ReflectedTarget;

/// A native Rust borrow selected from an authored value.
#[doc(hidden)]
pub trait NativeTarget<Type: ?Sized + 'static>: 'static {
    /// The root type inspected before positional predicates are counted.
    fn subject_type(&self) -> Option<std::any::TypeId>;

    fn requires_subject(&self) -> bool {
        true
    }

    fn admission(&self) -> Option<Box<dyn Fn(&dyn std::any::Any) -> bool>> {
        None
    }

    fn schema_admission(&self) -> Option<fn(crate::reflection::Type) -> bool> {
        None
    }

    fn project_native<'a>(&mut self, element: &'a mut AnyElement) -> Option<&'a mut Type>;
}

type StyleMethods =
    <crate::__GpuiReflectStyled as crate::reflection::CallableReflectionToken>::Methods;

/// A built-in style field prepared once for each concrete element schema.
#[doc(hidden)]
pub struct StyleTarget<Leaf: 'static> {
    cache: ProjectionCache<&'static StyleMethods>,
    project: for<'a> fn(&'static StyleMethods, &'a mut dyn std::any::Any) -> &'a mut Leaf,
}

impl<Leaf: 'static> StyleTarget<Leaf> {
    pub(super) fn new(
        project: for<'a> fn(&'static StyleMethods, &'a mut dyn std::any::Any) -> &'a mut Leaf,
    ) -> Self {
        Self {
            cache: ProjectionCache::new(),
            project,
        }
    }
}

impl<Leaf: 'static> NativeTarget<Leaf> for StyleTarget<Leaf> {
    fn subject_type(&self) -> Option<std::any::TypeId> {
        None
    }
    fn requires_subject(&self) -> bool {
        false
    }

    fn project_native<'a>(&mut self, element: &'a mut AnyElement) -> Option<&'a mut Leaf> {
        let metadata = element.reflection();
        let methods = self
            .cache
            .resolve(metadata, || metadata.resolve(crate::Styled))?;
        Some((self.project)(methods, element.inner_element_mut()))
    }
}

/// A native trait view supplied by the authored value's schema.
#[doc(hidden)]
pub struct RoleTarget<Type: ?Sized + 'static> {
    cache:
        ProjectionCache<crate::reflection::RoleProjection<Type>, crate::reflection::TypeSnapshot>,
}
impl<Type: ?Sized + 'static> RoleTarget<Type> {
    pub(super) fn new() -> Self {
        Self {
            cache: ProjectionCache::new(),
        }
    }
}

/// A native projection supplied directly at the query site.
#[doc(hidden)]
pub struct ViewTarget<Root, Type: ?Sized + 'static>(
    pub(super) for<'a> fn(&'a mut Root) -> &'a mut Type,
);

impl<Root: 'static, Type: ?Sized + 'static> NativeTarget<Type> for ViewTarget<Root, Type> {
    fn subject_type(&self) -> Option<std::any::TypeId> {
        Some(std::any::TypeId::of::<Root>())
    }

    fn project_native<'a>(&mut self, element: &'a mut AnyElement) -> Option<&'a mut Type> {
        Some((self.0)(
            element.query_subject_mut()?.downcast_mut::<Root>()?,
        ))
    }
}

impl<Type: ?Sized + 'static> NativeTarget<Type> for RoleTarget<Type> {
    fn subject_type(&self) -> Option<std::any::TypeId> {
        None
    }

    fn schema_admission(&self) -> Option<fn(crate::reflection::Type) -> bool> {
        Some(|ty| ty.has_role::<Type>())
    }

    fn project_native<'a>(&mut self, element: &'a mut AnyElement) -> Option<&'a mut Type> {
        let schema = element.query_type();
        let projection = self
            .cache
            .resolve(schema.snapshot(), || schema.role::<Type>())?;
        projection.get_mut(element.query_subject_mut()?)
    }
}

/// A typed field, enum payload, or composition of nested paths.
#[doc(hidden)]
pub struct PathTarget<Path>(pub(super) Path);

impl<Path> NativeTarget<Path::Leaf> for PathTarget<Path>
where
    Path: for<'a> crate::reflection::BorrowPath<'a> + Clone + 'static,
    Path::Root: 'static,
    Path::Leaf: 'static,
{
    fn subject_type(&self) -> Option<std::any::TypeId> {
        Some(std::any::TypeId::of::<Path::Root>())
    }

    fn admission(&self) -> Option<Box<dyn Fn(&dyn std::any::Any) -> bool>> {
        let path = self.0.clone();
        Some(Box::new(move |subject| {
            subject
                .downcast_ref::<Path::Root>()
                .is_some_and(|root| path.get(root).is_some())
        }))
    }

    fn project_native<'a>(&mut self, element: &'a mut AnyElement) -> Option<&'a mut Path::Leaf> {
        self.0
            .get_mut(element.query_subject_mut()?.downcast_mut::<Path::Root>()?)
    }
}

impl<Type: 'static> NativeTarget<Type> for ReflectedTarget {
    fn subject_type(&self) -> Option<std::any::TypeId> {
        Some(std::any::TypeId::of::<Type>())
    }

    fn project_native<'a>(&mut self, element: &'a mut AnyElement) -> Option<&'a mut Type> {
        element.query_subject_mut()?.downcast_mut()
    }
}

impl<Group: ReflectionGroup> SelectionTarget<Group> for ReflectedTarget {
    type Tables = Group::Tables;
    type View<'a> = ReflectedElement<Group, &'a mut AnyElement>;

    fn bind(&self, metadata: &'static ElementReflection) -> Option<Self::Tables> {
        Group::bind_tables(metadata)
    }

    fn project<'a>(
        &self,
        tables: Self::Tables,
        element: &'a mut AnyElement,
    ) -> Option<Self::View<'a>> {
        Some(ReflectedElement::from_bound(element, tables))
    }
}

/// A projection of the concrete element that survives conversion.
#[doc(hidden)]
pub struct ConcreteTarget<Type>(pub(super) PhantomData<fn(Type) -> Type>);

impl<Type: 'static> NativeTarget<Type> for ConcreteTarget<Type> {
    fn subject_type(&self) -> Option<std::any::TypeId> {
        Some(std::any::TypeId::of::<Type>())
    }

    fn project_native<'a>(&mut self, element: &'a mut AnyElement) -> Option<&'a mut Type> {
        element.query_subject_mut()?.downcast_mut()
    }
}

impl<Group: ReflectionGroup, Type: 'static> SelectionTarget<Group> for ConcreteTarget<Type> {
    type Tables = ();
    type View<'a> = &'a mut Type;

    fn bind(&self, _metadata: &'static ElementReflection) -> Option<Self::Tables> {
        Some(())
    }

    fn project<'a>(&self, (): (), element: &'a mut AnyElement) -> Option<Self::View<'a>> {
        element.downcast_mut()
    }
}

/// A projection of an authored component before its one-time render.
#[doc(hidden)]
pub struct ComponentTarget<Type>(pub(super) PhantomData<fn(Type) -> Type>);

impl<Type: crate::View> NativeTarget<Type> for ComponentTarget<Type> {
    fn subject_type(&self) -> Option<std::any::TypeId> {
        Some(std::any::TypeId::of::<Type>())
    }

    fn project_native<'a>(&mut self, element: &'a mut AnyElement) -> Option<&'a mut Type> {
        element.query_subject_mut()?.downcast_mut()
    }
}

impl<Group: ReflectionGroup, Type: crate::View> SelectionTarget<Group> for ComponentTarget<Type> {
    type Tables = ();
    type View<'a> = &'a mut Type;

    fn bind(&self, _metadata: &'static ElementReflection) -> Option<Self::Tables> {
        Some(())
    }

    fn project<'a>(&self, (): (), element: &'a mut AnyElement) -> Option<Self::View<'a>> {
        element
            .downcast_mut::<ViewElement<Type>>()?
            .pending_view_mut()
    }
}

/// A registered custom view, including traits with fixed associated types.
#[doc(hidden)]
pub struct CapabilityTarget<Type: ?Sized + 'static, Key: ?Sized + 'static>(
    pub(super) Capability<Type, Key>,
);

impl<Group: ReflectionGroup, Type: ?Sized + 'static, Key: ?Sized + 'static> SelectionTarget<Group>
    for CapabilityTarget<Type, Key>
{
    type Tables = &'static crate::reflection::capability::CapabilityTable<Type, Key>;
    type View<'a> = &'a mut Type;

    fn bind(&self, metadata: &'static ElementReflection) -> Option<Self::Tables> {
        use crate::reflection::ReflectionToken;
        metadata.method_table(self.0.reflected_trait())
    }

    fn project<'a>(
        &self,
        tables: Self::Tables,
        element: &'a mut AnyElement,
    ) -> Option<Self::View<'a>> {
        tables.get_mut(element.inner_element_mut())
    }
}

/// Each selector retains at most two prepared schema records. Records contain
/// immutable table references, never references into a node or its state.
#[derive(Clone, Copy)]
pub(super) struct ProjectionCache<Tables: Copy, Schema: SchemaIdentity = &'static ElementReflection>
{
    entries: [Option<ProjectionEntry<Tables, Schema>>; 2],
}

pub(super) trait SchemaIdentity: Copy {
    fn same(self, other: Self) -> bool;
}
impl SchemaIdentity for &'static ElementReflection {
    fn same(self, other: Self) -> bool {
        std::ptr::eq(self, other)
    }
}
impl SchemaIdentity for crate::reflection::TypeSnapshot {
    fn same(self, other: Self) -> bool {
        self.same_schema(other)
    }
}

#[derive(Clone, Copy)]
struct ProjectionEntry<Tables: Copy, Schema: SchemaIdentity> {
    schema: Schema,
    tables: Option<Tables>,
}

impl<Tables: Copy, Schema: SchemaIdentity> ProjectionCache<Tables, Schema> {
    pub(super) fn new() -> Self {
        Self { entries: [None; 2] }
    }

    pub(super) fn resolve(
        &mut self,
        schema: Schema,
        bind: impl FnOnce() -> Option<Tables>,
    ) -> Option<Tables> {
        for entry in self.entries.into_iter().flatten() {
            if schema.same(entry.schema) {
                return entry.tables;
            }
        }
        let tables = bind();
        self.entries = [Some(ProjectionEntry { schema, tables }), self.entries[0]];
        tables
    }
}
