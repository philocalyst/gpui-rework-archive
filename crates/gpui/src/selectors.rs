use crate::{
    AnyElement, App, ElementId, ImageStyle, InteractiveElement, Interactivity, IntoElement,
    IntoItemMatch, IntoListMatch, IntoMatchValues, ItemMatch, ListMatch, ParentElement,
    ParentElementTyped, SharedString, StatefulInteractiveElement, StyleRefinement, Styled,
    StyledImage, TextStyleRefinement,
    reflection::{
        Both, Capability, ElementReflection, ReflectedElement, ReflectedTraits, ReflectionGroup,
        ReflectionRequirement,
    },
    window::with_element_arena,
};
use smallvec::SmallVec;
use std::{
    any::TypeId,
    cell::{Cell, Ref, RefCell, RefMut},
    marker::PhantomData,
    mem,
    num::NonZeroUsize,
    rc::Rc,
};

#[cfg(feature = "bench-support")]
#[doc(hidden)]
#[path = "selectors/benchmarks.rs"]
pub mod selector_benchmarks;

mod targets;
pub use targets::{
    CapabilityTarget, ComponentTarget, ConcreteTarget, NativeTarget, PathTarget, ReflectedTarget,
    RoleTarget, SelectionTarget, StyleTarget, ViewTarget,
};

/// The reflection group used by selectors without a reflected trait predicate.
#[doc(hidden)]
pub struct NoReflectedTraits;

impl ReflectionGroup for NoReflectedTraits {
    type Access = crate::reflection::NoAccess;
    type Tables =
        crate::reflection::GroupTables<(), crate::reflection::BuiltinTables<Self::Access>>;

    fn bind_tables(metadata: &'static ElementReflection) -> Option<Self::Tables> {
        use crate::reflection::BuiltinAccess;
        Some(crate::reflection::GroupTables {
            callables: (),
            builtins: Self::Access::bind_tables(metadata)?,
        })
    }
}

/// Selects elements relative to an element tree root.
#[must_use]
pub struct Select<Group = NoReflectedTraits, Target = ReflectedTarget>
where
    Group: ReflectionGroup,
{
    matcher: SelectorMatcher,
    target: Target,
    group: PhantomData<fn() -> Group>,
}

struct SelectorMatcher {
    scope: SelectScope,
    concrete_type: Option<TypeId>,
    subject_type: Option<TypeId>,
    requires_subject: bool,
    subject_predicates: SmallVec<[Box<dyn Fn(&dyn std::any::Any) -> bool>; 1]>,
    schema_admission: Option<fn(crate::reflection::Type) -> bool>,
    schema_cache: Cell<[Option<ValueAdmission>; 2]>,
    reflected_traits: SmallVec<[ReflectionRequirement; 2]>,
    bind_group: Option<fn(&'static ElementReflection) -> bool>,
    reflection_admission: Cell<[Option<ReflectionAdmission>; 2]>,
    element_id: Option<ItemMatch<ElementId>>,
    classes: SmallVec<[ListMatch<SharedString>; 2]>,
    nth: Option<usize>,
    every: Option<NonZeroUsize>,
}

#[derive(Clone, Copy)]
struct ReflectionAdmission {
    metadata: &'static ElementReflection,
    satisfies: bool,
}

#[derive(Clone, Copy)]
struct ValueAdmission {
    ty: crate::reflection::TypeSnapshot,
    satisfies: bool,
}

#[derive(Clone, Copy)]
enum SelectScope {
    This,
    Children,
    Descendants,
}

impl Select<NoReflectedTraits> {
    /// Selects the element on which the selector is installed.
    pub fn this() -> Self {
        Self::new(SelectScope::This)
    }

    /// Selects direct children of the element on which the selector is installed.
    ///
    /// Components and entity views retain a [`crate::ViewElement`] whose child is
    /// the rendered root. Animation wrappers likewise retain their result as a child.
    /// `children()` on a wrapper reaches its child; on its parent it reaches the
    /// wrapper. Use [`Self::descendants`] to cross these boundaries.
    ///
    /// Annotations and deferred scheduling add no depth. Actual elements keep
    /// their declared children.
    pub fn children() -> Self {
        Self::new(SelectScope::Children)
    }

    /// Selects every descendant of the element on which the selector is installed.
    pub fn descendants() -> Self {
        Self::new(SelectScope::Descendants)
    }

    fn new(scope: SelectScope) -> Self {
        Self {
            matcher: SelectorMatcher {
                scope,
                concrete_type: None,
                subject_type: None,
                requires_subject: false,
                subject_predicates: SmallVec::new(),
                schema_admission: None,
                schema_cache: Cell::new([None; 2]),
                reflected_traits: SmallVec::new(),
                bind_group: None,
                reflection_admission: Cell::new([None; 2]),
                element_id: None,
                classes: SmallVec::new(),
                nth: None,
                every: None,
            },
            target: ReflectedTarget,
            group: PhantomData,
        }
    }

    /// Requires trait membership and compatible callable tables, including reflected
    /// parents, before counting positions. Borrowed methods honor concrete implementations
    /// unless marked `#[reflect(wrapper_default)]`.
    pub fn reflects<Traits>(mut self, reflected_traits: Traits) -> Select<Traits::Group>
    where
        Traits: ReflectedTraits,
    {
        reflected_traits.append_requirements(&mut self.matcher.reflected_traits);
        self.matcher.bind_group = Some(|metadata| Traits::Group::bind_tables(metadata).is_some());

        Select {
            matcher: self.matcher,
            target: self.target,
            group: PhantomData,
        }
    }
}

impl<Group: ReflectionGroup> Select<Group, ReflectedTarget> {
    /// Lends a native field or trait view through a checked Rust projection.
    /// This needs no schema and works with external or conditional trait impls.
    pub fn view<Root: 'static, Type: ?Sized + 'static>(
        mut self,
        project: for<'a> fn(&'a mut Root) -> &'a mut Type,
    ) -> Select<Group, ViewTarget<Root, Type>> {
        self.matcher.subject_type = Some(TypeId::of::<Root>());
        Select {
            matcher: self.matcher,
            target: ViewTarget(project),
            group: PhantomData,
        }
    }

    /// Borrows each matching element's style without a reflection declaration.
    pub fn style(
        self,
    ) -> Select<Both<Group, crate::__GpuiReflectStyledGroup>, StyleTarget<StyleRefinement>> {
        let selector = self.and(Styled);
        Select {
            matcher: selector.matcher,
            target: StyleTarget::new(crate::styled::project_style),
            group: PhantomData,
        }
    }

    /// Borrows inherited text style without a reflection declaration.
    pub fn text_style(
        self,
    ) -> Select<Both<Group, crate::__GpuiReflectStyledGroup>, StyleTarget<TextStyleRefinement>>
    {
        let selector = self.and(Styled);
        Select {
            matcher: selector.matcher,
            target: StyleTarget::new(crate::styled::project_text_style),
            group: PhantomData,
        }
    }

    /// Selects ordinary Rust trait objects supplied by the reflected module.
    pub fn role<Type: ?Sized + 'static>(self) -> Select<Group, RoleTarget<Type>> {
        Select {
            matcher: self.matcher,
            target: RoleTarget::new(),
            group: PhantomData,
        }
    }

    /// Lends a field or nested path to the callback, with its Rust type inferred.
    pub fn field<Path>(mut self, path: Path) -> Select<Group, PathTarget<Path>>
    where
        Path: crate::reflection::TypedPath,
        Path::Root: 'static,
    {
        self.matcher.subject_type = Some(TypeId::of::<Path::Root>());
        Select {
            matcher: self.matcher,
            target: PathTarget(path),
            group: PhantomData,
        }
    }

    /// Filters values through a typed field, then lends the complete root value.
    pub fn where_field<Path>(
        mut self,
        path: Path,
        predicate: impl Fn(&Path::Leaf) -> bool + 'static,
    ) -> Select<Group, ConcreteTarget<Path::Root>>
    where
        Path: for<'a> crate::reflection::BorrowPath<'a> + 'static,
        Path::Root: 'static,
    {
        self.matcher.subject_type = Some(TypeId::of::<Path::Root>());
        self.matcher
            .subject_predicates
            .push(Box::new(move |subject| {
                subject
                    .downcast_ref::<Path::Root>()
                    .and_then(|root| path.get(root))
                    .is_some_and(&predicate)
            }));
        Select {
            matcher: self.matcher,
            target: ConcreteTarget(PhantomData),
            group: PhantomData,
        }
    }
}

impl<Group: ReflectionGroup, Root: 'static> Select<Group, ConcreteTarget<Root>> {
    /// Lends a native trait or field view after filtering this exact root type.
    pub fn view<Type: ?Sized + 'static>(
        self,
        project: for<'a> fn(&'a mut Root) -> &'a mut Type,
    ) -> Select<Group, ViewTarget<Root, Type>> {
        Select {
            matcher: self.matcher,
            target: ViewTarget(project),
            group: PhantomData,
        }
    }

    /// Lends a registered native trait view after filtering this exact root type.
    pub fn role<Type: ?Sized + 'static>(self) -> Select<Group, RoleTarget<Type>> {
        Select {
            matcher: self.matcher,
            target: RoleTarget::new(),
            group: PhantomData,
        }
    }

    /// Adds a typed field predicate on the same root type.
    pub fn where_field<Path>(
        mut self,
        path: Path,
        predicate: impl Fn(&Path::Leaf) -> bool + 'static,
    ) -> Self
    where
        Path: for<'a> crate::reflection::BorrowPath<'a, Root = Root> + 'static,
    {
        self.matcher.subject_type = Some(TypeId::of::<Root>());
        self.matcher
            .subject_predicates
            .push(Box::new(move |subject| {
                subject
                    .downcast_ref::<Root>()
                    .and_then(|root| path.get(root))
                    .is_some_and(&predicate)
            }));
        self
    }

    /// Lends a field on the already selected root type.
    pub fn field<Path>(self, path: Path) -> Select<Group, PathTarget<Path>>
    where
        Path: crate::reflection::TypedPath<Root = Root>,
    {
        Select {
            matcher: self.matcher,
            target: PathTarget(path),
            group: PhantomData,
        }
    }
}

impl<Group, Target> Select<Group, Target>
where
    Group: ReflectionGroup,
{
    /// Adds capabilities while preserving all earlier access guarantees.
    /// Built-in builders work on any combination; use `element.with(token,
    /// |view| ...)` to borrow a custom reflected trait.
    pub fn and<Traits: ReflectedTraits>(
        mut self,
        traits: Traits,
    ) -> Select<Both<Group, Traits::Group>, Target> {
        traits.append_requirements(&mut self.matcher.reflected_traits);
        self.matcher.bind_group =
            Some(|metadata| <Both<Group, Traits::Group>>::bind_tables(metadata).is_some());
        self.matcher.reflection_admission.set([None; 2]);
        Select {
            matcher: self.matcher,
            target: self.target,
            group: PhantomData,
        }
    }

    /// Selects a concrete element and lends `&mut Type` to `select_mut`.
    /// No reflection registration is required. Matching uses the type that
    /// survives `IntoElement` conversion; use `component` for authored components.
    pub fn of<Type: 'static>(mut self) -> Select<Group, ConcreteTarget<Type>> {
        self.matcher.concrete_type = Some(TypeId::of::<Type>());
        Select {
            matcher: self.matcher,
            target: ConcreteTarget(PhantomData),
            group: PhantomData,
        }
    }

    /// Lends an authored view before its render method consumes it.
    /// The rendered root is a separate child, and its traits and classes are independent.
    pub fn component<Type: crate::View>(mut self) -> Select<Group, ComponentTarget<Type>> {
        self.matcher.concrete_type = Some(TypeId::of::<crate::ViewElement<Type>>());
        Select {
            matcher: self.matcher,
            target: ComponentTarget(PhantomData),
            group: PhantomData,
        }
    }

    /// Lends a registered custom capability without a trait attribute macro.
    pub fn capability<Type: ?Sized + 'static, Key: ?Sized + 'static>(
        mut self,
        capability: Capability<Type, Key>,
    ) -> Select<Group, CapabilityTarget<Type, Key>> {
        ReflectedTraits::append_requirements(capability, &mut self.matcher.reflected_traits);
        self.matcher.reflection_admission.set([None; 2]);
        Select {
            matcher: self.matcher,
            target: CapabilityTarget(capability),
            group: PhantomData,
        }
    }

    /// Matches one element ID, optionally negated with [`crate::not`].
    ///
    /// Composite IDs such as `("row", 3_usize)` remain one ID. A negated ID also
    /// matches elements without an ID. Calling this method again replaces the ID condition.
    ///
    /// ```compile_fail
    /// use gpui::Select;
    ///
    /// let selector = Select::children().id(["save", "cancel"]);
    /// ```
    ///
    /// ```compile_fail
    /// use gpui::{Select, any};
    ///
    /// let selector = Select::children().id(any(["save", "cancel"]));
    /// ```
    pub fn id<Kind>(mut self, element_id: impl IntoItemMatch<ElementId, Kind>) -> Self {
        self.matcher.element_id = Some(element_id.into_item_match());

        self
    }

    /// Matches class membership using values, arrays, vectors, slices, or tuples.
    ///
    /// Collections require every expression to match. Use [`crate::any`] for OR,
    /// and [`crate::not`] to negate an expression. Repeated calls require all conditions.
    ///
    /// ```
    /// use gpui::{Select, any, not};
    ///
    /// let selector = Select::children().class(("apple", "pear", not("plum")));
    /// let selector = Select::children().class(not(any(["apple", "pear"])));
    /// ```
    pub fn class<Kind>(mut self, class: impl IntoListMatch<SharedString, Kind>) -> Self {
        self.matcher.classes.push(class.into_list_match());

        self
    }

    /// Selects the matching element at a zero-based index in layout order.
    ///
    /// Measurements are excluded, and virtualized lists count only rendered elements.
    /// Prefer color changes over size changes when selecting list rows by position.
    pub fn nth(mut self, idx: usize) -> Self {
        self.matcher.nth = Some(idx);

        self
    }

    /// Selects matching elements at indexes `0, step, 2 * step, ...`.
    ///
    /// Uses the same indexing rules as [`Self::nth`].
    ///
    /// # Panics
    ///
    /// Panics if `step` is zero.
    pub fn every(mut self, step: usize) -> Self {
        self.matcher.every =
            Some(NonZeroUsize::new(step).expect("selector interval must be nonzero"));

        self
    }

    fn into_matcher(self) -> SelectorMatcher {
        self.matcher
    }
}

impl SelectorMatcher {
    #[inline]
    fn matches_reflection(&self, metadata: &'static ElementReflection) -> bool {
        if self.reflected_traits.is_empty() && self.bind_group.is_none() {
            return true;
        }

        let cached = self.reflection_admission.get();

        for admission in cached.into_iter().flatten() {
            if std::ptr::eq(admission.metadata, metadata) {
                return admission.satisfies;
            }
        }

        self.resolve_reflection_admission(metadata)
    }

    #[cold]
    fn resolve_reflection_admission(&self, metadata: &'static ElementReflection) -> bool {
        // Immutable metadata makes admission reusable. Classes and IDs remain per-node checks.
        let satisfies = self
            .reflected_traits
            .iter()
            .all(|requirement| metadata.satisfies(*requirement))
            && self.bind_group.is_none_or(|bind| bind(metadata));
        self.reflection_admission.set([
            Some(ReflectionAdmission {
                metadata,
                satisfies,
            }),
            self.reflection_admission.get()[0],
        ]);

        satisfies
    }

    fn matches_predicates(&self, element: &AnyElement) -> bool {
        if self.requires_subject
            || self.subject_type.is_some()
            || !self.subject_predicates.is_empty()
        {
            let Some(subject) = element.query_subject() else {
                return false;
            };
            if self
                .subject_type
                .is_some_and(|expected| subject.type_id() != expected)
                || self
                    .subject_predicates
                    .iter()
                    .any(|predicate| !predicate(subject))
            {
                return false;
            }
        }
        if let Some(admit) = self.schema_admission {
            let ty = element.query_type();
            let snapshot = ty.snapshot();
            let cached = self.schema_cache.get();
            let satisfies = cached
                .into_iter()
                .flatten()
                .find(|entry| entry.ty.same_schema(snapshot))
                .map(|entry| entry.satisfies)
                .unwrap_or_else(|| {
                    let satisfies = admit(ty);
                    self.schema_cache.set([
                        Some(ValueAdmission {
                            ty: snapshot,
                            satisfies,
                        }),
                        cached[0],
                    ]);
                    satisfies
                });
            if !satisfies {
                return false;
            }
        }
        if self
            .concrete_type
            .is_some_and(|expected| element.reflected_type_id() != expected)
        {
            return false;
        }

        if !self.matches_reflection(element.reflection()) {
            return false;
        }

        if let Some(element_id) = self.element_id.as_ref()
            && !element_id.evaluate(&|expected| element.element_id().as_ref() == Some(expected))
        {
            return false;
        }

        self.classes
            .iter()
            .all(|class| class.matches(element.classes()))
    }

    fn has_position(&self) -> bool {
        self.nth.is_some() || self.every.is_some()
    }

    fn includes_position(&self, idx: usize) -> bool {
        self.nth.is_none_or(|expected| idx == expected)
            && self.every.is_none_or(|step| idx.is_multiple_of(step.get()))
    }

    fn includes_depth(&self, depth: usize) -> bool {
        match self.scope {
            SelectScope::This => depth == 0,
            SelectScope::Children => depth == 1,
            SelectScope::Descendants => depth >= 1,
        }
    }

    fn can_reach_view_contents(&self, depth: usize) -> bool {
        debug_assert!(depth >= 1);

        match self.scope {
            SelectScope::This => false,
            SelectScope::Children => depth == 1,
            SelectScope::Descendants => true,
        }
    }

    fn can_select_future_match(&self, next_match_idx: usize, measuring: bool) -> bool {
        if measuring && self.has_position() {
            return false;
        }

        self.nth.is_none_or(|expected| next_match_idx <= expected)
    }
}

/// An element builder with a pending class list or selector.
///
/// Preserves [`trait@Styled`], [`trait@ParentElement`], [`ParentElementTyped`],
/// [`StyledImage`], [`trait@InteractiveElement`], and [`trait@StatefulInteractiveElement`]
/// when the builder supports them.
/// Conversion attaches annotations to the same node and preserves its reflection.
/// Borrowed methods delegate; consuming trait methods use their defaults.
/// Call inherent or unsupported custom builder methods before annotating.
pub struct Annotated<ElementType> {
    element: ElementType,
    annotation: Annotation,
}

enum Annotation {
    Classes(SmallVec<[SharedString; 2]>),
    Selector(PendingSelector),
}

impl<ElementType: IntoElement> IntoElement for Annotated<ElementType> {
    type Element = AnyElement;

    fn into_element(self) -> Self::Element {
        let mut element = self.element.into_any_element();

        match self.annotation {
            Annotation::Classes(classes) => element.classes_mut().extend(classes),
            Annotation::Selector(selector) => element.add_selector(selector),
        }

        element
    }
}

impl<ElementType: Styled> Styled for Annotated<ElementType> {
    fn style(&mut self) -> &mut StyleRefinement {
        self.element.style()
    }

    fn text_style(&mut self) -> &mut TextStyleRefinement {
        self.element.text_style()
    }
}

impl<ElementType: ParentElement> ParentElement for Annotated<ElementType> {
    fn extend(&mut self, elements: impl IntoIterator<Item = AnyElement>) {
        self.element.extend(elements);
    }
}

impl<ElementType: ParentElementTyped> ParentElementTyped for Annotated<ElementType> {
    type Child = ElementType::Child;

    fn extend(&mut self, elements: impl IntoIterator<Item = Self::Child>) {
        self.element.extend(elements);
    }
}

impl<ElementType: InteractiveElement> InteractiveElement for Annotated<ElementType> {
    fn interactivity(&mut self) -> &mut Interactivity {
        self.element.interactivity()
    }
}

impl<ElementType: StatefulInteractiveElement> StatefulInteractiveElement
    for Annotated<ElementType>
{
}

impl<ElementType: StyledImage> StyledImage for Annotated<ElementType> {
    fn image_style(&mut self) -> &mut ImageStyle {
        self.element.image_style()
    }
}

/// Adds classes and selectors while preserving common builder traits.
///
/// Use [`IntoElement::into_any_element`] where an [`AnyElement`] is required.
///
/// ```
/// use gpui::{Select, div, prelude::*, rgb};
///
/// let icon = div().class("icon").bg(rgb(0x123456)).child(div());
/// let container = div()
///     .map_selected(Select::children().class("icon").reflects(gpui::Styled),
///         |element| element.text_xl())
///     .bg(rgb(0x202020))
///     .child(icon)
///     .into_any_element();
/// ```
pub trait SelectableElement: IntoElement + Sized {
    /// Inspects matching values through their fields and runtime type information.
    /// The borrowed value and all of its field borrows stay inside the callback.
    fn inspect<Group>(
        self,
        selector: Select<Group>,
        mut inspect: impl for<'a> FnMut(crate::reflection::ValueMut<'a>) + 'static,
    ) -> Annotated<Self>
    where
        Group: ReflectionGroup,
    {
        let mut matcher = selector.into_matcher();
        matcher.requires_subject = true;
        let transform = move |mut element: AnyElement| {
            if let Some(value) = element.value_mut() {
                inspect(value);
            }
            element
        };
        Annotated {
            element: self,
            annotation: Annotation::Selector(PendingSelector::new(matcher, transform)),
        }
    }

    /// Edits authored values with an ordinary Rust borrow before layout.
    ///
    /// The callback's argument chooses the type. Components are borrowed before
    /// their render method consumes them, using the same interface as elements.
    /// Keep edits repeatable because layout may measure or retry a node.
    ///
    /// ```
    /// use gpui::{Div, Select, SelectableElement, Styled, div, px};
    /// let tree = div().select(Select::children().class("card"), |card: &mut Div| {
    ///     card.style().size.width = Some(px(120.).into());
    /// });
    /// ```
    fn select<Type: ?Sized + 'static, Group, Target>(
        self,
        selector: Select<Group, Target>,
        mut edit: impl for<'a> FnMut(&'a mut Type) + 'static,
    ) -> Annotated<Self>
    where
        Group: ReflectionGroup,
        Target: NativeTarget<Type>,
    {
        let Select {
            mut matcher,
            mut target,
            ..
        } = selector;
        matcher.subject_type = target.subject_type().or(matcher.subject_type);
        matcher.requires_subject = target.requires_subject();
        matcher.schema_admission = target.schema_admission();
        if let Some(predicate) = target.admission() {
            matcher.subject_predicates.push(predicate);
        }
        // Native projections concern the authored value, including a component
        // inside a rendering wrapper, rather than the wrapper's physical type.
        matcher.concrete_type = None;
        let transform = move |mut element: AnyElement| {
            if let Some(value) = target.project_native(&mut element) {
                edit(value);
            }
            element
        };
        Annotated {
            element: self,
            annotation: Annotation::Selector(PendingSelector::new(matcher, transform)),
        }
    }

    /// Edits the model behind each matching entity before that entity renders.
    ///
    /// GPUI supplies the model's [`crate::Context`] while holding the entity update. The
    /// borrowed model and context stay inside this callback. Use repeatable
    /// assignments because a later render or layout session can select the same
    /// entity again.
    fn select_entity<Model: 'static, Group>(
        self,
        selector: Select<Group>,
        mut edit: impl for<'a> FnMut(&'a mut Model, &'a mut crate::Context<Model>) + 'static,
    ) -> Annotated<Self>
    where
        Group: ReflectionGroup,
    {
        let Select { mut matcher, .. } = selector;
        matcher.subject_type = Some(TypeId::of::<crate::Entity<Model>>());
        matcher.requires_subject = true;
        matcher.concrete_type = None;

        let transform = move |mut element: AnyElement, cx: &mut App| {
            if let Some(entity) = element
                .query_subject_mut()
                .and_then(|subject| subject.downcast_mut::<crate::Entity<Model>>())
            {
                entity.update(cx, |model, model_cx| edit(model, model_cx));
            }
            element
        };

        Annotated {
            element: self,
            annotation: Annotation::Selector(PendingSelector::new_with_context(matcher, transform)),
        }
    }

    /// Tags this element with one class or a collection of positive class names.
    ///
    /// Arrays, vectors, slices, and tuples are supported. Boolean expressions are
    /// only accepted by [`Select::class`].
    ///
    /// Classes stay on the converted node. Default component conversion tags its
    /// [`crate::ViewElement`]; use a class prop in `render` to tag the root.
    /// Tag animated children before wrapping them or inside the animator.
    ///
    /// ```compile_fail
    /// use gpui::{SelectableElement, div, not};
    ///
    /// let element = div().class(not("apple"));
    /// ```
    fn class<Kind>(self, class: impl IntoMatchValues<SharedString, Kind>) -> Annotated<Self> {
        let mut classes = SmallVec::new();
        class.extend_match_values(&mut classes);

        Annotated {
            element: self,
            annotation: Annotation::Classes(classes),
        }
    }

    /// Mutates matching nodes before layout through a borrowed, typed view.
    ///
    /// Use `selector.of::<Type>()` for a concrete element, `component::<Type>()`
    /// for an authored component, or `capability(handle)` for a custom trait view.
    /// Without a projection the callback gets a borrowed reflected element, so
    /// existing style and child builders still work. Borrows cannot escape.
    /// Like `select`, callbacks must be repeatable across measurements and retries.
    fn select_mut<Group, Target>(
        self,
        selector: Select<Group, Target>,
        mut edit: impl for<'a> FnMut(Target::View<'a>) + 'static,
    ) -> Annotated<Self>
    where
        Group: ReflectionGroup,
        Target: SelectionTarget<Group>,
    {
        let Select {
            matcher, target, ..
        } = selector;
        let mut cache = targets::ProjectionCache::new();
        let transform = move |mut element: AnyElement| {
            let metadata = element.reflection();
            if let Some(tables) = cache.resolve(metadata, || target.bind(metadata))
                && let Some(view) = target.project(tables, &mut element)
            {
                edit(view);
            }
            element
        };
        Annotated {
            element: self,
            annotation: Annotation::Selector(PendingSelector::new(matcher, transform)),
        }
    }

    /// Transforms matching elements before layout.
    ///
    /// The callback may run for measurements or retries, so keep results repeatable
    /// and avoid changing application state.
    /// Elements erased inside a callback keep its generation provenance even when
    /// retained for later use. The construction scope is synchronous and cannot
    /// cross an asynchronous suspension.
    fn map_selected<Group, Output>(
        self,
        selector: Select<Group>,
        mut transform: impl FnMut(ReflectedElement<Group>) -> Output + 'static,
    ) -> Annotated<Self>
    where
        Group: ReflectionGroup,
        Output: IntoElement + 'static,
    {
        let mut cache = targets::ProjectionCache::new();
        let transform = move |element: AnyElement| {
            let metadata = element.reflection();
            let Some(tables) = cache.resolve(metadata, || Group::bind_tables(metadata)) else {
                return element;
            };
            transform(ReflectedElement::from_bound(element, tables)).into_any_element()
        };

        Annotated {
            element: self,
            annotation: Annotation::Selector(PendingSelector::new(
                selector.into_matcher(),
                Box::new(transform),
            )),
        }
    }
}

impl<ElementType> SelectableElement for ElementType where ElementType: IntoElement {}

pub(crate) struct ElementMetadata {
    pub(crate) classes: SmallVec<[SharedString; 2]>,
    pub(crate) selectors: Vec<PendingSelector>,
    pub(crate) node_state: Option<SelectorNodeState>,
}

impl ElementMetadata {
    pub(crate) fn new() -> Self {
        Self {
            classes: SmallVec::new(),
            selectors: Vec::new(),
            node_state: None,
        }
    }
}

#[derive(Clone, Debug)]
pub(crate) struct SelectorRuleId(Rc<()>);

impl PartialEq for SelectorRuleId {
    fn eq(&self, other: &Self) -> bool {
        Rc::ptr_eq(&self.0, &other.0)
    }
}

impl Eq for SelectorRuleId {}

#[derive(Clone, Debug)]
struct SelectorSessionId(Rc<()>);

impl PartialEq for SelectorSessionId {
    fn eq(&self, other: &Self) -> bool {
        Rc::ptr_eq(&self.0, &other.0)
    }
}

impl Eq for SelectorSessionId {}

struct SelectorVisit {
    rule: SelectorRuleId,
    session: SelectorSessionId,
}

#[derive(Default)]
pub(crate) struct SelectorNodeState {
    visited: SmallVec<[SelectorVisit; 2]>,
    pub(crate) generated_by: SmallVec<[SelectorRuleId; 2]>,
}

impl SelectorNodeState {
    pub(crate) fn generated(generated_by: SmallVec<[SelectorRuleId; 2]>) -> Self {
        Self {
            generated_by,
            ..Self::default()
        }
    }

    fn record_visit(&mut self, rule: &SelectorRuleId, session: &SelectorSessionId) -> bool {
        self.visited.retain(|visit| visit.session == *session);

        if self.visited.iter().any(|visit| visit.rule == *rule) {
            return false;
        }

        self.visited.push(SelectorVisit {
            rule: rule.clone(),
            session: session.clone(),
        });

        true
    }
}

type SelectorTransform = Box<dyn FnMut(AnyElement, &mut App) -> AnyElement>;

#[derive(Clone)]
pub(crate) struct PendingSelector(Rc<SelectorRule>);

impl PendingSelector {
    fn new(
        matcher: SelectorMatcher,
        mut transform: impl FnMut(AnyElement) -> AnyElement + 'static,
    ) -> Self {
        Self::new_with_context(matcher, move |element, _cx| transform(element))
    }

    fn new_with_context(
        matcher: SelectorMatcher,
        transform: impl FnMut(AnyElement, &mut App) -> AnyElement + 'static,
    ) -> Self {
        Self(Rc::new(SelectorRule {
            identity: SelectorRuleId(Rc::new(())),
            matcher,
            transform: RefCell::new(Some(Box::new(transform))),
        }))
    }

    pub(crate) fn identity(&self) -> SelectorRuleId {
        self.0.identity.clone()
    }
}

struct SelectorRule {
    identity: SelectorRuleId,
    matcher: SelectorMatcher,
    transform: RefCell<Option<SelectorTransform>>,
}

struct SelectorCallbackLease<'rule> {
    rule: &'rule SelectorRule,
    transform: Option<SelectorTransform>,
}

impl SelectorRule {
    fn try_lease(&self) -> Option<SelectorCallbackLease<'_>> {
        let transform = self.transform.borrow_mut().take()?;

        Some(SelectorCallbackLease {
            rule: self,
            transform: Some(transform),
        })
    }
}

impl Drop for SelectorCallbackLease<'_> {
    fn drop(&mut self) {
        let transform = self
            .transform
            .take()
            .expect("selector callback lease is empty");
        self.rule.transform.borrow_mut().replace(transform);
    }
}

#[derive(Clone)]
struct SelectorBinding {
    rule: Rc<SelectorRule>,
    depth: usize,
    position: Option<Rc<Cell<usize>>>,
}

impl SelectorBinding {
    fn next_match_idx(&self) -> usize {
        self.position.as_ref().map_or(0, |position| position.get())
    }
}

struct SelectorPosition {
    rule: SelectorRuleId,
    next_match_idx: Rc<Cell<usize>>,
}

/// Owns visit identity and positional progress for a draw or standalone operation.
/// A session spans layout, prepaint, paint, deferred work, and retries.
struct SelectorSession {
    identity: SelectorSessionId,
    positions: RefCell<SmallVec<[SelectorPosition; 4]>>,
}

impl SelectorSession {
    fn new() -> Self {
        Self {
            identity: SelectorSessionId(Rc::new(())),
            positions: RefCell::new(SmallVec::new()),
        }
    }

    fn position(&self, rule: &SelectorRuleId) -> Rc<Cell<usize>> {
        let mut positions = self.positions.borrow_mut();

        if let Some(position) = positions.iter().find(|position| position.rule == *rule) {
            return position.next_match_idx.clone();
        }

        let next_match_idx = Rc::new(Cell::new(0));
        positions.push(SelectorPosition {
            rule: rule.clone(),
            next_match_idx: next_match_idx.clone(),
        });

        next_match_idx
    }

    fn checkpoint_positions(self: &Rc<Self>) -> SelectorPositionCheckpoint {
        let positions = self
            .positions
            .borrow()
            .iter()
            .map(|position| {
                (
                    position.next_match_idx.clone(),
                    position.next_match_idx.get(),
                )
            })
            .collect();

        SelectorPositionCheckpoint {
            session: self.clone(),
            positions: Some(positions),
        }
    }
}

/// Holds traversal state restored when a nested selector scope ends.
#[derive(Clone)]
struct SelectorScope {
    session: Rc<SelectorSession>,
    bindings: SmallVec<[SelectorBinding; 4]>,
    measurement_depth: usize,
    generated_by: SmallVec<[SelectorRuleId; 2]>,
}

impl SelectorScope {
    fn new() -> Self {
        Self {
            session: Rc::new(SelectorSession::new()),
            bindings: SmallVec::new(),
            measurement_depth: 0,
            generated_by: SmallVec::new(),
        }
    }

    fn activate_selectors(&mut self, selectors: &[PendingSelector]) {
        for selector in selectors {
            if self
                .bindings
                .iter()
                .any(|binding| binding.rule.identity == selector.0.identity)
            {
                continue;
            }

            let position = selector
                .0
                .matcher
                .has_position()
                .then(|| self.session.position(&selector.0.identity));
            self.bindings.push(SelectorBinding {
                rule: selector.0.clone(),
                depth: 0,
                position,
            });
        }
    }

    fn advance_depth(&mut self) {
        for binding in &mut self.bindings {
            binding.depth += 1;
        }
    }

    fn can_affect_view_contents(&self) -> bool {
        let measuring = self.measurement_depth > 0;

        self.bindings.iter().any(|binding| {
            binding.rule.matcher.can_reach_view_contents(binding.depth)
                && binding
                    .rule
                    .matcher
                    .can_select_future_match(binding.next_match_idx(), measuring)
        })
    }
}

#[derive(Clone)]
struct SelectorOwner(Rc<()>);

impl SelectorOwner {
    fn matches(&self, owner: &Self) -> bool {
        Rc::ptr_eq(&self.0, &owner.0)
    }
}

/// Coordinates selector scopes for one window.
pub(crate) struct SelectorRuntime {
    owner: SelectorOwner,
    active: Rc<RefCell<Option<SelectorScope>>>,
}

#[derive(Clone)]
pub(crate) struct SelectorRuntimeHandle {
    active: Rc<RefCell<Option<SelectorScope>>>,
}

impl SelectorRuntimeHandle {
    pub(crate) fn generation_ancestry(&self) -> SmallVec<[SelectorRuleId; 2]> {
        self.active
            .borrow()
            .as_ref()
            .map(|scope| scope.generated_by.clone())
            .unwrap_or_default()
    }
}

/// Captures traversal state while sharing its session's live position counters.
#[derive(Clone)]
pub(crate) struct CapturedSelectorScope {
    owner: SelectorOwner,
    scope: SelectorScope,
}

#[derive(Clone, Copy, PartialEq, Eq)]
pub(crate) enum SelectorPhase {
    RequestLayout,
    Prepaint,
    Paint,
}

#[must_use = "the construction binding lasts until this guard is dropped"]
pub(crate) struct SelectorConstructionGuard {
    // Restore the arena selected on entry, even after allocation routing changes.
    slot: Option<Rc<RefCell<Option<SelectorRuntimeHandle>>>>,
    previous: Option<SelectorRuntimeHandle>,
}

impl Drop for SelectorConstructionGuard {
    fn drop(&mut self) {
        if let Some(slot) = self.slot.take() {
            slot.replace(self.previous.take());
        }
    }
}

#[must_use = "the selector scope lasts until this guard is dropped"]
pub(crate) struct SelectorScopeGuard {
    active: Option<Rc<RefCell<Option<SelectorScope>>>>,
    previous: Option<SelectorScope>,
    _construction: SelectorConstructionGuard,
}

impl SelectorScopeGuard {
    fn unchanged(construction: SelectorConstructionGuard) -> Self {
        Self {
            active: None,
            previous: None,
            _construction: construction,
        }
    }
}

impl Drop for SelectorScopeGuard {
    fn drop(&mut self) {
        if let Some(active) = self.active.take() {
            active.replace(self.previous.take());
        }
    }
}

#[must_use = "the generation ancestry lasts until this guard is dropped"]
struct SelectorGenerationGuard<'a> {
    runtime: &'a SelectorRuntime,
    previous: SmallVec<[SelectorRuleId; 2]>,
    _construction: SelectorConstructionGuard,
}

impl Drop for SelectorGenerationGuard<'_> {
    fn drop(&mut self) {
        self.runtime.borrow_scope_mut().generated_by = mem::take(&mut self.previous);
    }
}

/// Restores positional progress on drop unless committed, including on unwind.
#[must_use = "selector positions roll back unless this checkpoint is committed"]
pub(crate) struct SelectorPositionCheckpoint {
    session: Rc<SelectorSession>,
    positions: Option<SmallVec<[(Rc<Cell<usize>>, usize); 4]>>,
}

impl SelectorPositionCheckpoint {
    /// Keeps position changes made since this checkpoint.
    pub(crate) fn commit(mut self) {
        self.positions.take();
    }
}

impl Drop for SelectorPositionCheckpoint {
    fn drop(&mut self) {
        let Some(positions) = self.positions.take() else {
            return;
        };

        let previous_count = positions.len();

        for (position, idx) in positions {
            position.set(idx);
        }

        // Keep newly registered cells for retained scopes and bindings.
        for position in self.session.positions.borrow().iter().skip(previous_count) {
            position.next_match_idx.set(0);
        }
    }
}

impl SelectorRuntime {
    pub(crate) fn new() -> Self {
        Self {
            owner: SelectorOwner(Rc::new(())),
            active: Rc::new(RefCell::new(None)),
        }
    }

    /// Binds element construction to this window for the guard's lifetime.
    pub(crate) fn bind_construction(&self) -> SelectorConstructionGuard {
        let slot = with_element_arena(|arena| arena.selector_runtime.clone());
        let unchanged = slot
            .borrow()
            .as_ref()
            .is_some_and(|runtime| Rc::ptr_eq(&runtime.active, &self.active));

        if unchanged {
            return SelectorConstructionGuard {
                slot: None,
                previous: None,
            };
        }

        let previous = slot.replace(Some(SelectorRuntimeHandle {
            active: self.active.clone(),
        }));

        SelectorConstructionGuard {
            slot: Some(slot),
            previous,
        }
    }

    /// Enters a fresh session, restoring the previous scope when the guard is dropped.
    pub(crate) fn enter_session(&self) -> SelectorScopeGuard {
        self.enter_scope(SelectorScope::new())
    }

    /// Reuses the active session or enters a fresh one for the guard's lifetime.
    pub(crate) fn enter_session_if_needed(&self) -> SelectorScopeGuard {
        if self.active.borrow().is_some() {
            return SelectorScopeGuard::unchanged(self.bind_construction());
        }

        self.enter_session()
    }

    pub(crate) fn enter_element(
        &self,
        element: &mut AnyElement,
        phase: SelectorPhase,
        cx: &mut App,
    ) -> SelectorScopeGuard {
        let selectors = element.attached_selectors();
        let unchanged = selectors.is_empty()
            && self.active.borrow().as_ref().is_some_and(|scope| {
                scope.bindings.is_empty()
                    && scope.generated_by == element.selector_generation_ancestry()
            });

        if unchanged {
            return SelectorScopeGuard::unchanged(self.bind_construction());
        }

        let scope = self
            .active
            .borrow()
            .clone()
            .unwrap_or_else(SelectorScope::new);
        let guard = self.enter_scope(scope);
        self.borrow_scope_mut().activate_selectors(&selectors);

        if phase == SelectorPhase::RequestLayout && element.is_before_layout() {
            self.apply(element, cx);
        }

        // Apply selectors at the element's depth before advancing to its children.
        let mut scope = self.borrow_scope_mut();
        scope.generated_by = element.selector_generation_ancestry();
        scope.advance_depth();

        guard
    }

    pub(crate) fn enter_measurement(&self) -> SelectorScopeGuard {
        let mut scope = self
            .active
            .borrow()
            .clone()
            .unwrap_or_else(SelectorScope::new);
        scope.measurement_depth += 1;

        self.enter_scope(scope)
    }

    pub(crate) fn capture_scope(&self) -> CapturedSelectorScope {
        CapturedSelectorScope {
            owner: self.owner.clone(),
            scope: self.borrow_scope().clone(),
        }
    }

    /// Enters a captured scope from this window's currently active session.
    pub(crate) fn enter_captured_scope(
        &self,
        captured: CapturedSelectorScope,
    ) -> SelectorScopeGuard {
        assert!(
            self.owner.matches(&captured.owner),
            "captured selector scope belongs to another window"
        );
        assert!(
            self.borrow_scope().session.identity == captured.scope.session.identity,
            "captured selector scope belongs to another session"
        );

        self.enter_scope(captured.scope)
    }

    pub(crate) fn checkpoint_positions(&self) -> SelectorPositionCheckpoint {
        self.borrow_scope().session.checkpoint_positions()
    }

    pub(crate) fn can_affect_view_contents(&self) -> bool {
        self.borrow_scope().can_affect_view_contents()
    }

    fn borrow_scope(&self) -> Ref<'_, SelectorScope> {
        Ref::map(self.active.borrow(), |active| {
            active
                .as_ref()
                .expect("selector traversal requires an active session")
        })
    }

    fn borrow_scope_mut(&self) -> RefMut<'_, SelectorScope> {
        RefMut::map(self.active.borrow_mut(), |active| {
            active
                .as_mut()
                .expect("selector traversal requires an active session")
        })
    }

    fn enter_scope(&self, scope: SelectorScope) -> SelectorScopeGuard {
        let construction = self.bind_construction();
        let previous = self.active.replace(Some(scope));

        SelectorScopeGuard {
            active: Some(self.active.clone()),
            previous,
            _construction: construction,
        }
    }

    fn enter_generation(
        &self,
        generated_by: SmallVec<[SelectorRuleId; 2]>,
    ) -> SelectorGenerationGuard<'_> {
        let construction = self.bind_construction();
        let previous = mem::replace(&mut self.borrow_scope_mut().generated_by, generated_by);

        SelectorGenerationGuard {
            runtime: self,
            previous,
            _construction: construction,
        }
    }

    #[cfg(any(test, feature = "bench-support"))]
    fn enter_attached(&self, selectors: &[PendingSelector]) -> SelectorScopeGuard {
        let scope = self.borrow_scope().clone();
        let guard = self.enter_scope(scope);
        self.borrow_scope_mut().activate_selectors(selectors);

        guard
    }

    #[cfg(feature = "bench-support")]
    fn enter_children(&self) -> SelectorScopeGuard {
        let mut scope = self.borrow_scope().clone();
        scope.advance_depth();

        self.enter_scope(scope)
    }

    fn apply(&self, element: &mut AnyElement, cx: &mut App) {
        let mut selector_idx = 0;

        loop {
            let candidate = {
                let scope = self.borrow_scope();

                scope.bindings.get(selector_idx).cloned().map(|binding| {
                    (
                        binding,
                        scope.measurement_depth > 0,
                        scope.session.identity.clone(),
                    )
                })
            };

            let Some((binding, measuring, session)) = candidate else {
                break;
            };

            selector_idx += 1;
            let rule = binding.rule;

            if !rule.matcher.includes_depth(binding.depth)
                || (measuring && rule.matcher.has_position())
                || element
                    .selector_generation_ancestry()
                    .contains(&rule.identity)
                || rule.transform.borrow().is_none()
            {
                continue;
            }

            if !element
                .selector_node_state_mut()
                .record_visit(&rule.identity, &session)
                || !rule.matcher.matches_predicates(element)
            {
                continue;
            }

            if let Some(position) = binding.position {
                let idx = position.get();
                position.set(idx + 1);

                if !rule.matcher.includes_position(idx) {
                    continue;
                }
            }

            let Some(mut callback) = rule.try_lease() else {
                continue;
            };

            let attached = element.attached_selectors();
            let selected = element.take();
            let mut ancestry = selected.selector_generation_ancestry();
            ancestry.push(rule.identity.clone());

            let replacement = {
                let _generation = self.enter_generation(ancestry);

                callback
                    .transform
                    .as_mut()
                    .expect("selector callback lease is empty")(selected, cx)
            };

            assert!(
                replacement.is_before_layout(),
                "selector replacement must not have requested layout"
            );

            element.replace(replacement);
            element.inherit_attached_selectors(attached);
            self.borrow_scope_mut()
                .activate_selectors(&element.attached_selectors());
        }
    }
}

#[cfg(test)]
mod tests;
