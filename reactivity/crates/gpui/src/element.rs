//! Ordinary borrowed descriptions, explicit consuming lowering and typed routes.
//!
//! Public descriptions own headers/children and borrow operands. They have no
//! ambient arena or generative frame lifetime. All structural traversal and
//! disposal is iterative, including disposal before lowering and during unwind.
use std::{any::Any, marker::PhantomData};

use crate::{
    View,
    component::Component,
    property::PropertyId,
    source::{BindError, FieldAction, FieldId, IntoText, Sources, Text},
    style::{Affine, Align, Color, Flex, Flow, Justify, Style},
    style_port::{IntoProp, StyleSignal, Value},
};

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub(crate) enum NodeKind {
    Div,
    Text,
    Input,
    Button,
    List,
    ListItem,
    Image,
    Scroll,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, serde::Serialize)]
pub enum Role {
    Generic,
    Text,
    TextInput,
    Button,
    List,
    ListItem,
    Image,
    ScrollView,
}

impl NodeKind {
    pub(crate) const fn role(self) -> Role {
        match self {
            Self::Div => Role::Generic,
            Self::Text => Role::Text,
            Self::Input => Role::TextInput,
            Self::Button => Role::Button,
            Self::List => Role::List,
            Self::ListItem => Role::ListItem,
            Self::Image => Role::Image,
            Self::Scroll => Role::ScrollView,
        }
    }
}

/// A mount-site route. Its identity is the retained site, never a code address.
/// Ordinary method items are zero-sized captures, so their Box needs no allocation.
pub(crate) struct Handler(Box<dyn Route>);

trait Route {
    fn validate(&self, receiver: &dyn Any, sources: &dyn Any)
    -> Result<Option<FieldId>, BindError>;
    fn invoke(&self, receiver: &mut dyn Any) -> Result<(), BindError>;
    fn owner_scope(&self, _receiver: &dyn Any, _sources: &dyn Any) -> Result<u32, BindError> {
        Ok(0)
    }
}

impl Handler {
    pub(crate) fn validate(
        &self,
        receiver: &dyn Any,
        sources: &dyn Any,
    ) -> Result<Option<FieldId>, BindError> {
        self.0.validate(receiver, sources)
    }

    pub(crate) fn invoke(&self, receiver: &mut dyn Any) -> Result<(), BindError> {
        self.0.invoke(receiver)
    }

    pub(crate) fn owner_scope(
        &self,
        receiver: &dyn Any,
        sources: &dyn Any,
    ) -> Result<u32, BindError> {
        self.0.owner_scope(receiver, sources)
    }

    pub(crate) fn component_check<P: 'static, C: View + 'static>(
        component: Component<P, C>,
    ) -> Self {
        Self(Box::new(MethodRoute {
            callback: |_: &mut C| {},
            model: PhantomData::<fn(C)>,
        }))
        .in_component(component)
    }

    pub(crate) fn in_component<P: 'static, C: View + 'static>(
        self,
        component: Component<P, C>,
    ) -> Self {
        Self(Box::new(ComponentRoute {
            component,
            handler: self,
        }))
    }
}

// One cold adapter per installed child route; no model pointer or per-node
// shared owner. Nested adapters follow the explicit parent projection chain.
struct ComponentRoute<P, C> {
    component: Component<P, C>,
    handler: Handler,
}
impl<P: 'static, C: View + 'static> Route for ComponentRoute<P, C> {
    fn validate(
        &self,
        receiver: &dyn Any,
        sources: &dyn Any,
    ) -> Result<Option<FieldId>, BindError> {
        let parent = receiver
            .downcast_ref::<P>()
            .ok_or(BindError::ReceiverMismatch)?;
        let sources = sources
            .downcast_ref::<Sources<P>>()
            .ok_or(BindError::ReceiverMismatch)?;
        self.component
            .validate_handler(parent, sources, &self.handler)
    }
    fn owner_scope(&self, receiver: &dyn Any, sources: &dyn Any) -> Result<u32, BindError> {
        let parent = receiver
            .downcast_ref::<P>()
            .ok_or(BindError::ReceiverMismatch)?;
        let sources = sources
            .downcast_ref::<Sources<P>>()
            .ok_or(BindError::ReceiverMismatch)?;
        self.component.handler_scope(parent, sources, &self.handler)
    }
    fn invoke(&self, receiver: &mut dyn Any) -> Result<(), BindError> {
        let parent = receiver
            .downcast_mut::<P>()
            .ok_or(BindError::ReceiverMismatch)?;
        self.handler.invoke(self.component.project_mut(parent)?)
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

    fn invoke(&self, receiver: &mut dyn Any) -> Result<(), BindError> {
        let receiver = receiver
            .downcast_mut::<M>()
            .ok_or(BindError::ReceiverMismatch)?;
        (self.callback)(receiver);
        Ok(())
    }
}

// Validation and invocation share the one source descriptor and update capture.
// An exact action has one box allocation, rather than separately boxed callbacks
// that duplicate Source. Mount checks registered read identity; invocation checks
// exclusive projector agreement before exposing a mutable value to the callback.
// The runtime must validate before exact-source admission.
impl<M: 'static, T: 'static, F: Fn(&mut T)> Route for FieldAction<M, T, F> {
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

    fn invoke(&self, receiver: &mut dyn Any) -> Result<(), BindError> {
        let receiver = receiver
            .downcast_mut::<M>()
            .ok_or(BindError::ReceiverMismatch)?;
        FieldAction::invoke(self, receiver)
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
    components: ComponentBoundaries,
    extra: Option<Box<crate::semantic::ElementExtra<'a>>>,
}

// The declaration payload order is explicitly preorder: local text/route first,
// then children from left to right. Children are emptied before any child El is
// dropped, so no structural destructor calls itself recursively at tree depth.
impl Drop for El<'_> {
    fn drop(&mut self) {
        drop(self.text.take());
        drop(self.extra.take());
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
    /// Clip a container and retain independent scrolling on the selected local
    /// axes. The viewport participates in ordinary layout; children keep their
    /// intrinsic extent. Rotated/sheared viewport clips are rejected at prepare.
    /// Invalid element kinds are builder errors; use `try_scroll` to handle them.
    pub fn scroll(self, axes: crate::Axis) -> Self {
        self.try_scroll(axes)
            .expect("scroll belongs to an ordinary container")
    }
    pub fn try_scroll(mut self, axes: crate::Axis) -> Result<Self, crate::ScrollError> {
        if !matches!(self.kind, NodeKind::Div | NodeKind::Scroll) {
            return Err(crate::ScrollError::UnsupportedElement);
        }
        self.extra
            .get_or_insert_with(|| {
                Box::new(crate::semantic::ElementExtra::Decorations(
                    Default::default(),
                ))
            })
            .make_scroll(axes)?;
        self.kind = NodeKind::Scroll;
        Ok(self)
    }

    pub(crate) fn image(resource: &'a crate::Image) -> Self {
        let mut element = Self::new(NodeKind::Image, None);
        element.extra = Some(Box::new(crate::semantic::ElementExtra::Image {
            spec: crate::image::ImageSpec {
                geometry: Default::default(),
                resource,
                sampling: crate::ImageSampling::Linear,
            },
            semantic: None,
        }));
        element
    }
    /// Selects nearest or bilinear reconstruction for an image declaration.
    pub fn sampling(mut self, sampling: crate::ImageSampling) -> Self {
        match self
            .extra
            .as_deref_mut()
            .and_then(|extra| extra.image_mut())
        {
            Some(spec) => spec.sampling = sampling,
            _ => panic!("sampling belongs to an image declaration"),
        }
        self
    }
    pub(crate) fn reader(projector: Box<dyn crate::reader::Projector + 'a>) -> Self {
        let mut element = Self::new(NodeKind::Div, None);
        element.extra = Some(Box::new(crate::semantic::ElementExtra::Reader {
            projector,
            semantic: None,
            map: None,
        }));
        element
    }
    /// First-read fallback for a Reader projection. Refreshing retains its
    /// preceding ready child; failures remain a distinct visible verdict.
    pub fn loading(mut self, render: fn() -> El<'static>) -> Self {
        match self
            .extra
            .as_deref_mut()
            .and_then(|extra| extra.projection_mut())
        {
            Some((projector, _)) => projector.loading(render),
            _ => panic!("loading belongs to a Reader projection"),
        }
        self
    }
    pub fn failed(mut self, render: for<'v> fn(crate::Failure<'v>) -> El<'v>) -> Self {
        match self
            .extra
            .as_deref_mut()
            .and_then(|extra| extra.projection_mut())
        {
            Some((projector, _)) => projector.failed(render),
            _ => panic!("failed belongs to a Reader projection"),
        }
        self
    }
    fn new(kind: NodeKind, text: Option<Text<'a>>) -> Self {
        Self {
            kind,
            text,
            children: Vec::new(),
            style: Style::default(),
            on_click: None,
            components: ComponentBoundaries::default(),
            extra: None,
        }
    }

    pub(crate) fn uniform_list(
        id: crate::ListId,
        source: &'a dyn crate::ItemSource,
        row_height: f64,
    ) -> Self {
        let mut element = Self::new(NodeKind::List, None);
        element.extra = Some(Box::new(crate::semantic::ElementExtra::List(
            crate::list::ListSpec {
                id,
                source,
                row_height,
                map: None,
            },
        )));
        element
    }

    /// Uniform circular corners for this element's background, own image and
    /// hit region. Descendants are not clipped. Invalid radii fail admission.
    pub fn rounded(mut self, radius: impl IntoProp<'a, f32>) -> Self {
        let radius = radius.into_prop();
        if let Some(value) = radius.literal() {
            if let Some(extra) = self.extra.as_deref_mut() {
                extra.unbind(PropertyId::CornerRadius);
            }
            // Preserve the original radius builder's deferred, typed admission
            // and raw f32 bits, including invalid NaN payloads until admission.
            self.extra
                .get_or_insert_with(|| {
                    Box::new(crate::semantic::ElementExtra::Decorations(
                        Default::default(),
                    ))
                })
                .set_geometry(crate::property::GeometryStyle {
                    corner_radius: value,
                });
        } else {
            self.bind_property(
                PropertyId::CornerRadius,
                radius.signal().expect("signal radius"),
            );
        }
        self
    }
    pub fn rounded_md(self) -> Self {
        self.rounded(6.0)
    }
    /// An explicit accessible name, separate from an input's edited value.
    pub fn name(mut self, name: impl IntoText<'a>) -> Self {
        self.annotations_mut().name = Some(name.into_text());
        self
    }
    pub fn description(mut self, description: impl IntoText<'a>) -> Self {
        self.annotations_mut().description = Some(description.into_text());
        self
    }
    fn annotations_mut(&mut self) -> &mut crate::semantic::Annotations<'a> {
        self.extra
            .get_or_insert_with(|| {
                Box::new(crate::semantic::ElementExtra::Semantic(Default::default()))
            })
            .annotations_mut()
    }

    pub fn child<C, S>(mut self, children: C) -> Self
    where
        C: ChildSeq<'a, S>,
    {
        assert!(
            matches!(
                self.kind,
                NodeKind::Div | NodeKind::Button | NodeKind::Scroll
            ),
            "this element does not accept children"
        );
        children.append(&mut self.children);
        self
    }

    pub fn on_click<M: 'static, S, H: IntoHandler<M, S>>(self, handler: H) -> Self {
        handler.install(self)
    }

    fn bind_property(&mut self, id: PropertyId, signal: &'a dyn StyleSignal) {
        self.extra
            .get_or_insert_with(|| {
                Box::new(crate::semantic::ElementExtra::Decorations(
                    Default::default(),
                ))
            })
            .bind(id, signal);
    }

    #[inline]
    fn unbind_property(&mut self, id: PropertyId) {
        if self.extra.is_some() {
            Self::unbind_existing_property(&mut self.extra, id);
        }
    }

    #[cold]
    fn unbind_existing_property(
        extra: &mut Option<Box<crate::semantic::ElementExtra<'a>>>,
        id: PropertyId,
    ) {
        if let Some(value) = extra.as_deref_mut() {
            value.unbind(id);
            if value.empty() {
                *extra = None;
            }
        }
    }

    fn literal_properties<const CODE: u16, const SIZE: bool, T: Value, I: IntoProp<'a, T>>(
        &mut self,
        input: I,
    ) {
        let id = const {
            let id = PropertyId::from_code(CODE).expect("closed property code");
            assert!(matches!(
                id.info().destination,
                crate::property::PropertyDestination::Style
            ));
            id
        };
        // Keep the original input type through conversion/admission: e.g. an
        // integer is statically finite, so literal callers need no float error
        // branches for a value that cannot reach them.
        let scalar = input
            .into_prop()
            .literal()
            .expect("sealed literal")
            .scalar();
        let value = scalar.narrow(id).expect("invalid literal style property");
        PropertyId::set_literal::<CODE>(&mut self.style, value)
            .expect("invalid literal style property");
        self.unbind_property(id);
        if SIZE {
            let id = PropertyId::Height;
            let value = scalar.narrow(id).expect("invalid literal style property");
            PropertyId::set_literal::<{ PropertyId::Height as u16 }>(&mut self.style, value)
                .expect("invalid literal style property");
            self.unbind_property(id);
        }
    }

    // The sealed input family is resolved before erasure. In particular, the
    // literal instantiation has no signal callback, binding or allocation path.
    fn property_input<const CODE: u16, const SIZE: bool, T: Value, I: IntoProp<'a, T>>(
        &mut self,
        input: I,
    ) {
        const { assert!(!SIZE || CODE == PropertyId::Width as u16) };
        let id = const { PropertyId::from_code(CODE).expect("closed property code") };
        if I::IS_LITERAL {
            self.literal_properties::<CODE, SIZE, T, I>(input);
        } else {
            let input = input.into_prop();
            if let Some(signal) = input.signal() {
                self.bind_property(id, signal);
                if SIZE {
                    self.bind_property(PropertyId::Height, signal);
                }
            } else {
                self.literal_properties::<CODE, SIZE, T, _>(input);
            }
        }
    }
    pub fn w(mut self, width: impl IntoProp<'a, f64>) -> Self {
        self.property_input::<{ PropertyId::Width as u16 }, false, f64, _>(width);
        self
    }
    pub fn h(mut self, height: impl IntoProp<'a, f64>) -> Self {
        self.property_input::<{ PropertyId::Height as u16 }, false, f64, _>(height);
        self
    }
    pub fn size(mut self, size: impl IntoProp<'a, f64>) -> Self {
        self.property_input::<{ PropertyId::Width as u16 }, true, f64, _>(size);
        self
    }
    pub fn gap(mut self, gap: impl IntoProp<'a, f64>) -> Self {
        self.property_input::<{ PropertyId::Gap as u16 }, false, f64, _>(gap);
        self
    }
    pub fn p(mut self, padding: impl IntoProp<'a, f64>) -> Self {
        self.property_input::<{ PropertyId::Padding as u16 }, false, f64, _>(padding);
        self
    }
    pub fn font_size(mut self, size: impl IntoProp<'a, f64>) -> Self {
        self.property_input::<{ PropertyId::FontSize as u16 }, false, f64, _>(size);
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
    pub fn fg(mut self, color: impl IntoProp<'a, Color>) -> Self {
        self.property_input::<{ PropertyId::Foreground as u16 }, false, Color, _>(color);
        self
    }
    pub fn bg(mut self, color: impl IntoProp<'a, Color>) -> Self {
        self.property_input::<{ PropertyId::Background as u16 }, false, Color, _>(color);
        self
    }
    pub fn transform(mut self, transform: impl IntoProp<'a, Affine>) -> Self {
        self.property_input::<{ PropertyId::Transform as u16 }, false, Affine, _>(transform);
        self
    }
    pub fn flow(mut self, flow: impl IntoProp<'a, Flow>) -> Self {
        self.property_input::<{ PropertyId::Flow as u16 }, false, Flow, _>(flow);
        self
    }
    pub fn align(mut self, align: impl IntoProp<'a, Align>) -> Self {
        self.property_input::<{ PropertyId::Align as u16 }, false, Align, _>(align);
        self
    }
    pub fn justify(mut self, justify: impl IntoProp<'a, Justify>) -> Self {
        self.property_input::<{ PropertyId::Justify as u16 }, false, Justify, _>(justify);
        self
    }
    pub fn wrap(mut self, wrap: impl IntoProp<'a, bool>) -> Self {
        self.property_input::<{ PropertyId::Wrap as u16 }, false, bool, _>(wrap);
        self
    }
    pub fn layout(self, recipe: impl crate::FlexRecipe<'a>) -> Self {
        recipe.apply_to(self)
    }
    pub fn flex(self) -> Self {
        self.layout(Flex::row())
    }
    pub fn apply<T>(self, f: impl FnOnce(Self) -> T) -> T {
        f(self)
    }

    pub(crate) fn map_handlers(&mut self, map: impl Fn(Handler) -> Handler + Copy + 'static) {
        let mut pending = vec![self];
        while let Some(element) = pending.pop() {
            if let Some(handler) = element.on_click.take() {
                element.on_click = Some(map(handler));
            }
            let mut boundary = element.components.0.as_deref_mut();
            while let Some(item) = boundary {
                let check = item.check.take().expect("boundary check is installed");
                item.check = Some(map(check));
                boundary = item.next.0.as_deref_mut();
            }
            if let Some(spec) = element.extra.as_mut().and_then(|extra| extra.list_mut()) {
                let previous = spec.map.take();
                spec.map = Some(Box::new(move |row: &mut El<'_>| {
                    if let Some(previous) = &previous {
                        previous(row);
                    }
                    row.map_handlers(map);
                }));
            }
            pending.extend(element.children.iter_mut());
            if let Some((_, pending_map)) = element
                .extra
                .as_deref_mut()
                .and_then(|extra| extra.projection_mut())
            {
                let previous = pending_map.take();
                *pending_map = Some(Box::new(move |child: &mut El<'_>| {
                    if let Some(previous) = &previous {
                        previous(child);
                    }
                    child.map_handlers(map);
                }));
            }
        }
    }

    pub(crate) fn component<P: 'static, C: View + 'static>(
        mut self,
        component: Component<P, C>,
    ) -> Self {
        let next = std::mem::take(&mut self.components);
        self.components.0 = Some(Box::new(ComponentBoundary {
            check: Some(Handler::component_check(component)),
            next,
        }));
        self
    }

    /// Consumes each header once, transferring routes/owned operands and copying
    /// borrowed operands only when the runtime promotes a changed destination.
    #[cfg(test)]
    pub(crate) fn flatten(self) -> Vec<DraftNode<'a>> {
        self.flatten_lists(usize::MAX, &(), |_, _, _, _| {
            Err(crate::ListError::MissingViewport)
        })
        .unwrap()
        .nodes
    }

    pub(crate) fn flatten_lists(
        self,
        limit: usize,
        readers: &'a dyn crate::reader::ReaderValues,
        mut plan: impl FnMut(
            crate::ListId,
            Style,
            &dyn crate::ItemSource,
            f64,
        ) -> Result<crate::list::ListPlan, crate::ListError>,
    ) -> Result<Description<'a>, crate::Error> {
        use crate::list::{ListDraft, RowDraft};
        let mut output = Vec::new();
        let mut viewports: Vec<crate::list::ViewportDraft> = Vec::new();
        let mut annotations = Vec::new();
        let mut images = Vec::new();
        let mut geometry = Vec::new();
        let mut style_ports = Vec::new();
        let mut pending = vec![(None, self, None::<(usize, crate::ItemKey, u32, f32, f32)>)];
        while let Some((parent, mut element, slot)) = pending.pop() {
            if output.len() >= limit {
                return Err(crate::ListError::ResourceLimit.into());
            }
            let index = output.len() as u32;
            if let Some((list, key, item_index, y, height)) = slot {
                let crate::list::ViewportDraft::List(draft) = &mut viewports[list] else {
                    unreachable!("row belongs to list")
                };
                draft.rows.push(RowDraft {
                    index: index as usize,
                    key,
                    item_index,
                    y,
                    height,
                });
            }
            let crate::semantic::ExtraParts {
                list: spec,
                annotations: annotation,
                projection: projector,
                image,
                axes,
                geometry: shape,
                bindings,
            } = element
                .extra
                .take()
                .map(|extra| extra.into_parts())
                .unwrap_or_default();
            let mut shape = shape.unwrap_or_default();
            for binding in bindings {
                let value = binding.signal.scalar().admit(binding.property)?;
                match binding.property.info().destination {
                    crate::property::PropertyDestination::Style => {
                        binding.property.set_erased(&mut element.style, value)?;
                    }
                    crate::property::PropertyDestination::Geometry => {
                        let crate::property::PropertyValue::Number(radius) = value else {
                            unreachable!()
                        };
                        shape.corner_radius = radius;
                    }
                }
                style_ports.push(crate::style_port::Draft {
                    node: index,
                    property: binding.property,
                    signal: binding.signal,
                });
            }
            if let Some(axes) = axes {
                viewports.push(crate::list::ViewportDraft::Scroll(
                    crate::scroll::ScrollDraft {
                        index: index as usize,
                        axes,
                    },
                ));
            }
            if shape.corner_radius.to_bits() != 0 {
                geometry.push((index as usize, shape));
            }
            if let Some(mut spec) = image {
                spec.geometry = shape;
                images.push(crate::image::ImageDraft { node: index, spec });
            }
            if let Some((projector, map)) = projector {
                let mut child = projector.render(readers);
                if let Some(map) = map {
                    map(&mut child);
                }
                element.children.push(child);
            }
            if !annotation.is_empty() {
                annotations.push(crate::semantic::AnnotationDraft {
                    node: index,
                    text: annotation,
                });
            }
            if let Some(spec) = spec {
                let mut list_plan = plan(spec.id, element.style, spec.source, spec.row_height)?;
                let list = viewports.len();
                let start = list_plan.viewport.visible_range.start;
                let row_height = list_plan.viewport.row_height;
                let intra = list_plan.viewport.offset - start as f64 * row_height;
                let mut rows = Vec::with_capacity(list_plan.keys.len());
                for (offset, key) in list_plan.keys.iter().copied().enumerate() {
                    let item_index = start + offset;
                    let y = (offset as f64 * row_height - intra) as f32;
                    let mut row = spec.source.row(item_index);
                    if let Some(map) = &spec.map {
                        map(&mut row);
                    }
                    let mut wrapper = Self::new(NodeKind::ListItem, None);
                    wrapper.children.push(row);
                    wrapper.style.height = Some(row_height as f32);
                    rows.push((
                        Some(index),
                        wrapper,
                        Some((
                            list,
                            key,
                            u32::try_from(item_index)
                                .map_err(|_| crate::ListError::ResourceLimit)?,
                            y,
                            row_height as f32,
                        )),
                    ));
                }
                if spec.source.len() != list_plan.viewport.len {
                    return Err(crate::ListError::ChangedSource.into());
                }
                // Keys have served their admission purpose. Retain only row metadata.
                list_plan.keys.clear();
                viewports.push(crate::list::ViewportDraft::List(ListDraft {
                    index: index as usize,
                    id: spec.id,
                    plan: list_plan,
                    rows: Vec::with_capacity(rows.len()),
                }));
                pending.extend(rows.into_iter().rev());
            } else {
                let children = std::mem::take(&mut element.children);
                pending.extend(
                    children
                        .into_iter()
                        .rev()
                        .map(|child| (Some(index), child, None)),
                );
            }
            output.push(DraftNode {
                parent,
                kind: element.kind,
                text: element.text.take(),
                style: element.style,
                on_click: element.on_click.take(),
                components: std::mem::take(&mut element.components),
            });
        }
        Ok(Description {
            nodes: output,
            viewports,
            annotations,
            images,
            geometry,
            style_ports,
        })
    }
}

// Sparse boundary metadata has one pointer in ordinary leaf descriptions.
// Component roots prepend outer boundaries; disposal is iterative even for an
// unlowered element containing many nested boundaries on the same visual root.
#[derive(Default)]
pub(crate) struct ComponentBoundaries(Option<Box<ComponentBoundary>>);
pub(crate) struct ComponentBoundary {
    pub(crate) check: Option<Handler>,
    next: ComponentBoundaries,
}
impl ComponentBoundaries {
    pub(crate) fn iter(&self) -> impl Iterator<Item = &ComponentBoundary> {
        std::iter::successors(self.0.as_deref(), |item| item.next.0.as_deref())
    }
}
impl Drop for ComponentBoundaries {
    fn drop(&mut self) {
        while let Some(mut boundary) = self.0.take() {
            self.0 = boundary.next.0.take();
        }
    }
}

pub(crate) struct Description<'a> {
    pub geometry: Vec<(usize, crate::property::GeometryStyle)>,
    pub style_ports: Vec<crate::style_port::Draft<'a>>,
    pub nodes: Vec<DraftNode<'a>>,
    pub viewports: Vec<crate::list::ViewportDraft>,
    pub annotations: Vec<crate::semantic::AnnotationDraft<'a>>,
    pub images: Vec<crate::image::ImageDraft<'a>>,
}
pub(crate) struct DraftNode<'a> {
    pub(crate) parent: Option<u32>,
    pub(crate) kind: NodeKind,
    pub(crate) text: Option<Text<'a>>,
    pub(crate) style: Style,
    pub(crate) on_click: Option<Handler>,
    pub(crate) components: ComponentBoundaries,
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
impl<M: 'static, T: 'static, F: Fn(&mut T) + 'static> IntoHandler<M, shape::Field>
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
        assert_eq!(
            handler.invoke(&mut wrong_receiver),
            Err(BindError::ReceiverMismatch)
        );
        assert_eq!(
            handler.validate(&wrong_receiver, &()),
            Err(BindError::ReceiverMismatch)
        );
        let mut model = Model {
            count: Signal::new(1),
            other: Signal::new(7),
        };
        assert_eq!(handler.validate(&model, &Sources::<Model>::new()), Ok(None));
        assert_eq!(handler.invoke(&mut model), Ok(()));
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
        assert_eq!(handler.invoke(&mut 0_u32), Err(BindError::ReceiverMismatch));
        assert_eq!(handler.invoke(&mut model), Ok(()));
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
        assert_eq!(nodes[0].kind.role(), Role::TextInput);
        assert!(nodes[0].text.as_ref().unwrap().signal().is_some());
        assert_eq!(nodes[0].style.width, Some(320.0));
        assert_eq!(nodes[0].style.height, Some(24.0));
        assert_eq!(nodes[0].style.fg, Color::rgb(1, 2, 3));
    }

    #[test]
    #[allow(clippy::needless_borrows_for_generic_args)] // borrowed-input conformance
    fn static_and_erased_literals_match_the_canonical_typed_schema() {
        use crate::{PropInput, property::*};
        fn same(a: &Style, b: &Style) {
            macro_rules! fields {
                ($($property:ident),+) => {$(
                    assert!($property.same_authoring(&$property.get(a), &$property.get(b)),
                        "{}", $property.info().name);
                )+};
            }
            fields!(
                WIDTH, HEIGHT, GAP, PADDING, FONT_SIZE, FOREGROUND, BACKGROUND, FLOW, TRANSFORM,
                ALIGN, JUSTIFY, WRAP
            );
        }
        macro_rules! check {
            ($method:ident, $input:ty, $property:ident, $literal:expr, $expected:expr) => {{
                let literal = $literal;
                let mut expected = Style::default();
                $property.set(&mut expected, $expected).unwrap();
                let erased: PropInput<'_, $input> = literal.into_prop();
                for element in [
                    div().$method(literal),
                    div().$method(&literal),
                    div().$method(erased),
                ] {
                    same(&element.style, &expected);
                    assert!(element.extra.is_none(), "literal must not install an extra");
                }
            }};
        }
        macro_rules! numbers {
            ($($ty:ty),+) => {$(
                check!(w, f64, WIDTH, 3 as $ty, Some(3.0));
                check!(h, f64, HEIGHT, 3 as $ty, Some(3.0));
                check!(gap, f64, GAP, 3 as $ty, 3.0);
                check!(p, f64, PADDING, 3 as $ty, 3.0);
                check!(font_size, f64, FONT_SIZE, 3 as $ty, 3.0);
            )+};
        }
        numbers!(f32, f64, u8, u16, u32, u64, usize, i8, i16, i32, i64, isize);
        check!(w, f64, WIDTH, -0.0_f64, Some(-0.0));
        check!(p, f64, PADDING, -0.0_f32, -0.0);
        // Preserve the inherited IntoLength→f64→f32 conversion, including its
        // double-rounding boundaries, rather than silently switching casts.
        let midpoint = (1_u64 << 63) + (1_u64 << 39) + 1;
        check!(w, f64, WIDTH, midpoint, Some((midpoint as f64) as f32));
        let midpoint = (1_i64 << 62) + (1_i64 << 38) + 1;
        check!(h, f64, HEIGHT, midpoint, Some((midpoint as f64) as f32));
        for color in [
            Color::rgb(1, 2, 3),
            Color::display_p3(-0.0, 0.5, 1.0, 0.5).unwrap(),
            Color::linear_srgb(-2.0, -0.0, 3.0, 1.0).unwrap(),
            Color::oklch(0.5, 0.2, 123.0, 0.75).unwrap(),
        ] {
            check!(fg, Color, FOREGROUND, color, color);
            check!(bg, Color, BACKGROUND, color, color);
        }
        let map = Affine {
            a: 1.0,
            b: -0.0,
            c: 0.0,
            d: -1.0,
            tx: -0.0,
            ty: 4.0,
        };
        check!(transform, Affine, TRANSFORM, map, map);
        check!(flow, Flow, FLOW, Flow::Row, Flow::Row);
        check!(align, Align, ALIGN, Align::Baseline, Align::Baseline);
        check!(
            justify,
            Justify,
            JUSTIFY,
            Justify::SpaceEvenly,
            Justify::SpaceEvenly
        );
        check!(wrap, bool, WRAP, true, true);
    }

    #[test]
    #[allow(clippy::needless_borrows_for_generic_args)]
    fn literal_radius_retains_original_bits_until_typed_admission() {
        use crate::PropInput;
        for radius in [-1.0, -0.0, f32::INFINITY, f32::from_bits(0xff80_0001)] {
            let erased: PropInput<'_, f32> = radius.into_prop();
            for mut element in [
                div().rounded(radius),
                div().rounded(&radius),
                div().rounded(erased),
            ] {
                let parts = element.extra.take().unwrap().into_parts();
                assert_eq!(
                    parts.geometry.unwrap().corner_radius.to_bits(),
                    radius.to_bits()
                );
            }
        }
        let radius = Signal::new(3.0);
        let mut result = None;
        let cost = allocation_counter::measure(|| {
            result = Some(div().rounded(&radius).rounded(0.0));
        });
        // Removing the last radius binding reuses its existing decoration box.
        assert_eq!(cost.count_total, 2);
        assert_eq!(
            cost.bytes_total as usize,
            size_of::<crate::semantic::ElementExtra<'_>>()
                + size_of::<crate::style_port::Binding<'_>>()
        );
        assert_eq!(
            cost.bytes_current as usize,
            size_of::<crate::semantic::ElementExtra<'_>>()
        );
        drop(result);
    }

    #[test]
    fn size_ledger_counts_inline_route_and_style_costs() {
        eprintln!(
            "El={} Style={} DraftNode={} Handler={} ComponentRoute={}",
            size_of::<El<'_>>(),
            size_of::<Style>(),
            size_of::<DraftNode<'_>>(),
            size_of::<Handler>(),
            size_of::<ComponentRoute<(), ()>>()
        );
        let el = text("borrowed");
        assert_eq!(el.children.capacity(), 0);
        assert!(el.on_click.is_none());
    }
}
