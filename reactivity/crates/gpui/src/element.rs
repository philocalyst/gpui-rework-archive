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
    source::{BindError, FieldAction, FieldId, IntoText, SourcePath, Sources, Text},
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
    CheckBox(bool),
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
    CheckBox,
}

impl NodeKind {
    /// State changes preserve the mount site, target and installed route.
    pub(crate) const fn site_kind(self) -> Self {
        match self {
            Self::CheckBox(_) => Self::CheckBox(false),
            kind => kind,
        }
    }
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
            Self::CheckBox(_) => Role::CheckBox,
        }
    }
}

/// A mount-site route. Its identity is the retained site, never a code address.
/// Ordinary method items are zero-sized captures, so their Box needs no allocation.
pub(crate) struct Handler(Box<dyn Route>);

pub(crate) enum Admission {
    Model { exact: Option<FieldId> },
    Window(crate::runtime::inspector::WindowAction),
    Property,
}
trait Route {
    fn admit(&self, receiver: &dyn Any, sources: &dyn Any) -> Result<Admission, BindError>;
    fn invoke(&self, receiver: &mut dyn Any) -> Result<(), BindError>;
    fn invoke_control(&self, receiver: &mut dyn Any, _next: Option<bool>) -> Result<(), BindError> {
        self.invoke(receiver)
    }
    fn owner_scope(&self, _receiver: &dyn Any, _sources: &dyn Any) -> Result<u32, BindError> {
        Ok(0)
    }
    fn property(&self, _phase: PropertyPhase<'_>) -> Result<(), BindError> {
        unreachable!("only an admitted property route performs a property exchange")
    }
}

// Borrowed only for this opt-in vtable call. Ordinary invoke keeps its original
// ABI; neither this phase nor its output is retained in a route or runtime.
enum PropertyPhase<'a> {
    Propose(&'a dyn Any, crate::Target, &'a mut Option<PropertyRequest>),
    Reply(&'a mut dyn Any, Result<&'a PropertyState, &'a crate::Error>),
}

pub(crate) enum PropertyRequest {
    Inspect(crate::Target, PropertyId),
    Edit(PropertyChange),
}

/// Canonical logical state captured immediately before the mutable reply.
/// Later source edits, preparation and presentation may produce newer state.
/// This owned snapshot confers no revision or presentation authority.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct PropertyState {
    pub target: crate::Target,
    pub id: PropertyId,
    pub value: crate::property::PropertyValue,
    pub contribution: crate::property::Contribution<crate::property::PropertyValue>,
}

/// One owned contribution interpreted against the current logical target.
/// This is not a presentation or revision lease.
pub type PropertyChange = (
    crate::Target,
    PropertyId,
    crate::property::Contribution<crate::property::PropertyValue>,
);

/// Build an ordinary click route for an opt-in property editor.
/// `proposal` reads the current owner. None performs no property operation.
/// The result method receives canonical rejection or logical acceptance after
/// the proposal borrow ends. Accepted state is captured after the edit and
/// before the reply; source edits in the reply may produce newer state later.
/// Acceptance does not promise preparation or ACK: those follow through the
/// ordinary window publication/error path.
pub fn property_action<M: 'static, F, R>(
    proposal: F,
    applied_logically: R,
) -> impl IntoHandler<M, shape::Property>
where
    F: Fn(&M) -> Option<PropertyChange> + 'static,
    R: Fn(&mut M, Result<PropertyState, &crate::Error>) + 'static,
{
    PropertyRoute {
        proposal: move |model: &M, _| proposal(model).map(PropertyRequest::Edit),
        applied_logically,
        model: PhantomData,
    }
}

/// Select or refresh a property through current logical state. The proposal's
/// second argument is this activation site's own Target, resolved on the stack.
/// It can return that target or another previously selected target. None is idle.
/// Installing this with `on_click` replaces that site's previous click action;
/// it does not intercept descendants or add picking or event bubbling.
pub fn property_selection<M: 'static, F, R>(
    proposal: F,
    selected: R,
) -> impl IntoHandler<M, shape::Property>
where
    F: Fn(&M, crate::Target) -> Option<(crate::Target, PropertyId)> + 'static,
    R: Fn(&mut M, Result<PropertyState, &crate::Error>) + 'static,
{
    PropertyRoute {
        proposal: move |model: &M, target| {
            proposal(model, target).map(|(target, id)| PropertyRequest::Inspect(target, id))
        },
        applied_logically: selected,
        model: PhantomData,
    }
}
struct PropertyRoute<M, F, R> {
    proposal: F,
    applied_logically: R,
    model: PhantomData<fn(M)>,
}
impl<M: 'static, F, R> Route for PropertyRoute<M, F, R>
where
    F: Fn(&M, crate::Target) -> Option<PropertyRequest>,
    R: Fn(&mut M, Result<PropertyState, &crate::Error>),
{
    fn admit(&self, receiver: &dyn Any, _: &dyn Any) -> Result<Admission, BindError> {
        receiver
            .is::<M>()
            .then_some(Admission::Property)
            .ok_or(BindError::ReceiverMismatch)
    }
    fn invoke(&self, _: &mut dyn Any) -> Result<(), BindError> {
        unreachable!("property routes use their distinct logical transaction")
    }
    fn property(&self, phase: PropertyPhase<'_>) -> Result<(), BindError> {
        match phase {
            PropertyPhase::Propose(receiver, target, output) => {
                let receiver = receiver
                    .downcast_ref::<M>()
                    .ok_or(BindError::ReceiverMismatch)?;
                *output = (self.proposal)(receiver, target);
            }
            PropertyPhase::Reply(receiver, result) => {
                let receiver = receiver
                    .downcast_mut::<M>()
                    .ok_or(BindError::ReceiverMismatch)?;
                (self.applied_logically)(receiver, result.copied());
            }
        }
        Ok(())
    }
}

impl Handler {
    pub(crate) fn window(action: crate::runtime::inspector::WindowAction) -> Self {
        Self(Box::new(action))
    }
    pub(crate) fn admit(
        &self,
        receiver: &dyn Any,
        sources: &dyn Any,
    ) -> Result<Admission, BindError> {
        self.0.admit(receiver, sources)
    }
    // Retained component boundary checks are ordinary model routes. A window
    // action or property proposal cannot substitute for that projection check.
    pub(crate) fn validate(
        &self,
        receiver: &dyn Any,
        sources: &dyn Any,
    ) -> Result<Option<FieldId>, BindError> {
        match self.admit(receiver, sources)? {
            Admission::Model { exact } => Ok(exact),
            Admission::Window(_) | Admission::Property => Err(BindError::ReceiverMismatch),
        }
    }
    pub(crate) fn invoke(&self, receiver: &mut dyn Any) -> Result<(), BindError> {
        self.0.invoke(receiver)
    }
    pub(crate) fn invoke_control(
        &self,
        receiver: &mut dyn Any,
        next: Option<bool>,
    ) -> Result<(), BindError> {
        self.0.invoke_control(receiver, next)
    }

    pub(crate) fn proposal(
        &self,
        receiver: &dyn Any,
        target: crate::Target,
    ) -> Result<Option<PropertyRequest>, BindError> {
        let mut output = None;
        self.0
            .property(PropertyPhase::Propose(receiver, target, &mut output))?;
        Ok(output)
    }
    pub(crate) fn applied_logically(
        &self,
        receiver: &mut dyn Any,
        result: Result<&PropertyState, &crate::Error>,
    ) -> Result<(), BindError> {
        self.0.property(PropertyPhase::Reply(receiver, result))
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
    fn admit(&self, receiver: &dyn Any, sources: &dyn Any) -> Result<Admission, BindError> {
        let parent = receiver
            .downcast_ref::<P>()
            .ok_or(BindError::ReceiverMismatch)?;
        let sources = sources
            .downcast_ref::<Sources<P>>()
            .ok_or(BindError::ReceiverMismatch)?;
        self.component.admit_handler(parent, sources, &self.handler)
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
    fn invoke_control(&self, receiver: &mut dyn Any, next: Option<bool>) -> Result<(), BindError> {
        let parent = receiver
            .downcast_mut::<P>()
            .ok_or(BindError::ReceiverMismatch)?;
        self.handler
            .invoke_control(self.component.project_mut(parent)?, next)
    }
    fn property(&self, phase: PropertyPhase<'_>) -> Result<(), BindError> {
        match phase {
            PropertyPhase::Propose(receiver, target, output) => {
                let parent = receiver
                    .downcast_ref::<P>()
                    .ok_or(BindError::ReceiverMismatch)?;
                self.handler.0.property(PropertyPhase::Propose(
                    (self.component.read)(parent),
                    target,
                    output,
                ))
            }
            PropertyPhase::Reply(receiver, result) => {
                let parent = receiver
                    .downcast_mut::<P>()
                    .ok_or(BindError::ReceiverMismatch)?;
                self.handler.0.property(PropertyPhase::Reply(
                    self.component.project_mut(parent)?,
                    result,
                ))
            }
        }
    }
}

// The receiver type is encoded in this implementation's vtable. PhantomData
// contributes no storage, preserving a zero-sized route for method items.
struct MethodRoute<M, F> {
    callback: F,
    model: PhantomData<fn(M)>,
}

impl<M: 'static, F: Fn(&mut M)> Route for MethodRoute<M, F> {
    fn admit(&self, receiver: &dyn Any, _: &dyn Any) -> Result<Admission, BindError> {
        if receiver.is::<M>() {
            Ok(Admission::Model { exact: None })
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

struct CheckRoute<M, F> {
    callback: F,
    model: PhantomData<fn(M)>,
}
impl<M: 'static, F: Fn(&mut M, bool)> Route for CheckRoute<M, F> {
    fn admit(&self, receiver: &dyn Any, _: &dyn Any) -> Result<Admission, BindError> {
        if receiver.is::<M>() {
            Ok(Admission::Model { exact: None })
        } else {
            Err(BindError::ReceiverMismatch)
        }
    }
    fn invoke(&self, _: &mut dyn Any) -> Result<(), BindError> {
        Err(BindError::ReceiverMismatch)
    }
    fn invoke_control(&self, receiver: &mut dyn Any, next: Option<bool>) -> Result<(), BindError> {
        let receiver = receiver
            .downcast_mut::<M>()
            .ok_or(BindError::ReceiverMismatch)?;
        (self.callback)(receiver, next.ok_or(BindError::ReceiverMismatch)?);
        Ok(())
    }
}

// Validation and invocation share the one source descriptor and update capture.
// An exact action has one box allocation, rather than separately boxed callbacks
// that duplicate Source. Mount checks registered read identity; invocation checks
// exclusive projector agreement before exposing a mutable value to the callback.
// The runtime must validate before exact-source admission.
impl<M: 'static, T: 'static, F: Fn(&mut T), S: SourcePath<M, T>> Route for FieldAction<M, T, F, S> {
    fn admit(&self, receiver: &dyn Any, sources: &dyn Any) -> Result<Admission, BindError> {
        let receiver = receiver
            .downcast_ref::<M>()
            .ok_or(BindError::ReceiverMismatch)?;
        let sources = sources
            .downcast_ref::<Sources<M>>()
            .ok_or(BindError::ReceiverMismatch)?;
        Ok(Admission::Model {
            exact: Some(self.validate_registered(receiver, sources)?),
        })
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
                corner_radius: 0.0,
                clip_children: false,
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
                extra.unbind(PropertyId::CornerRadius.into());
            }
            // Preserve the original radius builder's deferred, typed admission
            // and raw f32 bits, including invalid NaN payloads until admission.
            self.extra
                .get_or_insert_with(|| {
                    Box::new(crate::semantic::ElementExtra::Decorations(
                        Default::default(),
                    ))
                })
                .set_radius(value);
        } else if let Some(map) = radius.mapped() {
            self.bind_mapped_property(PropertyId::CornerRadius, map);
        } else {
            self.bind_property(
                PropertyId::CornerRadius,
                radius.signal().expect("signal radius"),
            );
        }
        self
    }
    /// Intersect this element and its descendants with its local bounds and
    /// current uniform corner radius. Transforms compose normally; this flag
    /// does not alter layout. Rounded corners alone still affect only this part.
    pub fn clip(self) -> Self {
        self.clipped(true)
    }
    /// A typed clipping flag accepting a literal, signal or source map. Radius
    /// and clipping share the geometry domain and its checked publication path.
    pub fn clipped(mut self, clipped: impl IntoProp<'a, bool>) -> Self {
        let clipped = clipped.into_prop();
        if let Some(value) = clipped.literal() {
            if let Some(extra) = self.extra.as_deref_mut() {
                extra.unbind(PropertyId::Clip.into());
            }
            if value || self.extra.is_some() {
                self.extra
                    .get_or_insert_with(|| {
                        Box::new(crate::semantic::ElementExtra::Decorations(
                            Default::default(),
                        ))
                    })
                    .clip_children(value);
            }
        } else if let Some(id) = clipped.boolean_id() {
            self.extra
                .get_or_insert_with(|| {
                    Box::new(crate::semantic::ElementExtra::Semantic(Default::default()))
                })
                .bind_boolean(crate::style_port::boolean::Record::Member {
                    id,
                    sink: PropertyId::Clip.into(),
                    colors: None,
                });
        } else if let Some(map) = clipped.mapped() {
            self.bind_mapped_property(PropertyId::Clip, map);
        } else {
            self.bind_property(PropertyId::Clip, clipped.signal().expect("signal clip"));
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

    /// Opt into a visible focus marker inside the control frame. The caller
    /// chooses its color; the runtime owns focus and clipped affine painting.
    pub fn focus_indicator(mut self, color: Color) -> Self {
        assert!(
            matches!(
                self.kind,
                NodeKind::Input | NodeKind::Button | NodeKind::CheckBox(_)
            ),
            "focus appearance belongs to a semantic control"
        );
        self.extra
            .get_or_insert_with(|| {
                Box::new(crate::semantic::ElementExtra::Semantic(Default::default()))
            })
            .focus_indicator(color);
        self
    }

    /// Disable a semantic control and its named-part descendants. Physical
    /// routes remain installed for normal replacement/drop, but cannot act.
    pub fn disabled(mut self, disabled: impl IntoProp<'a, bool>) -> Self {
        self.control_input(crate::style_port::Sink::DISABLED, disabled.into_prop());
        self
    }
    /// Validation state of an input. It changes neither editing authority nor focus.
    pub fn invalid(mut self, invalid: impl IntoProp<'a, bool>) -> Self {
        assert!(
            self.kind == NodeKind::Input,
            "invalid state belongs to a text input"
        );
        self.control_input(crate::style_port::Sink::INVALID, invalid.into_prop());
        self
    }
    pub(crate) fn bind_boolean(&mut self, record: crate::style_port::boolean::Record<'a>) {
        self.extra
            .get_or_insert_with(|| {
                Box::new(crate::semantic::ElementExtra::Semantic(Default::default()))
            })
            .bind_boolean(record);
    }
    fn control_input(&mut self, sink: crate::style_port::Sink, input: crate::PropInput<'a, bool>) {
        if sink == crate::style_port::Sink::DISABLED
            && input.literal() == Some(false)
            && !matches!(
                self.kind,
                NodeKind::Input | NodeKind::Button | NodeKind::CheckBox(_)
            )
        {
            return;
        }
        assert!(
            matches!(
                self.kind,
                NodeKind::Input | NodeKind::Button | NodeKind::CheckBox(_)
            ),
            "intrinsic state belongs to a semantic control"
        );
        if let Some(value) = input.literal() {
            if let Some(extra) = &mut self.extra {
                extra.unbind(sink);
            }
            if sink == crate::style_port::Sink::CHECKED {
                self.kind = NodeKind::CheckBox(value);
            } else if value || self.extra.is_some() {
                self.extra.get_or_insert_with(|| {
                    Box::new(crate::semantic::ElementExtra::Semantic(Default::default()))
                });
                let extra = self.extra.as_mut().unwrap();
                if sink == crate::style_port::Sink::INVALID {
                    extra.set_invalid(value);
                } else {
                    extra.set_disabled(value);
                }
            }
            if self
                .extra
                .as_deref()
                .is_some_and(crate::semantic::ElementExtra::empty)
            {
                self.extra = None;
            }
        } else if let Some(id) = input.boolean_id() {
            self.bind_boolean(crate::style_port::boolean::Record::Member {
                id,
                sink,
                colors: None,
            });
        } else if let Some(signal) = input.signal() {
            self.extra
                .get_or_insert_with(|| {
                    Box::new(crate::semantic::ElementExtra::Semantic(Default::default()))
                })
                .bind(sink, signal);
        } else if let Some(map) = input.mapped() {
            self.extra
                .get_or_insert_with(|| {
                    Box::new(crate::semantic::ElementExtra::Semantic(Default::default()))
                })
                .bind_map(sink, map.into());
        }
    }
    fn apply_sink(
        sink: crate::style_port::Sink,
        value: crate::property::PropertyValue,
        kind: &mut NodeKind,
        style: &mut Style,
        disabled: &mut bool,
        invalid: &mut bool,
        shape: &mut crate::property::GeometryStyle,
    ) -> Result<(), crate::Error> {
        if let Some(property) = sink.property() {
            match property.info().destination {
                crate::property::PropertyDestination::Style
                | crate::property::PropertyDestination::Paint => {
                    property.set_erased(style, value)?;
                }
                crate::property::PropertyDestination::Geometry => {
                    property.set_geometry(shape, value)?;
                }
            }
        } else {
            let crate::property::PropertyValue::Flag(value) = value else {
                return Err(crate::Error::MapInput);
            };
            if sink == crate::style_port::Sink::CHECKED {
                *kind = NodeKind::CheckBox(value);
            } else if sink == crate::style_port::Sink::INVALID {
                *invalid = value;
            } else {
                *disabled = value;
            }
        }
        Ok(())
    }

    pub fn child<C, S>(mut self, children: C) -> Self
    where
        C: ChildSeq<'a, S>,
    {
        assert!(
            matches!(
                self.kind,
                NodeKind::Div | NodeKind::Button | NodeKind::Scroll | NodeKind::CheckBox(_)
            ),
            "this element does not accept children"
        );
        self.append_children(children);
        self
    }

    fn append_children<C, S>(&mut self, children: C)
    where
        C: ChildSeq<'a, S>,
    {
        let additional = children.lower_bound();
        if self.children.capacity() == 0 {
            self.children.reserve_exact(additional);
        } else {
            self.children.reserve(additional);
        }
        children.append(&mut self.children);
    }

    pub(crate) fn on_window(mut self, action: crate::runtime::inspector::WindowAction) -> Self {
        self.on_click = Some(Handler::window(action));
        self
    }

    pub fn on_click<M: 'static, S, H: IntoHandler<M, S>>(self, handler: H) -> Self {
        handler.install(self)
    }

    /// Replace the checkbox route with a controlled intent callback. Every
    /// activation computes intent from current logical checked state, including
    /// direct source publications, before exposing the mutable model.
    pub fn on_check<M: 'static>(mut self, callback: impl Fn(&mut M, bool) + 'static) -> Self {
        assert!(
            matches!(self.kind, NodeKind::CheckBox(_)),
            "checked intent belongs to a checkbox"
        );
        self.on_click = Some(Handler(Box::new(CheckRoute {
            callback,
            model: PhantomData,
        })));
        self
    }
    fn bind_mapped_property(&mut self, id: PropertyId, operand: crate::style_port::MapOperand<'a>) {
        self.bind_owned_map(id, operand.into());
    }
    fn bind_owned_map(&mut self, id: PropertyId, operand: crate::style_port::OwnedMapOperand<'a>) {
        self.extra
            .get_or_insert_with(|| {
                Box::new(crate::semantic::ElementExtra::Semantic(Default::default()))
            })
            .bind_map(id.into(), operand);
    }

    fn bind_property(&mut self, id: PropertyId, signal: &'a dyn StyleSignal) {
        self.extra
            .get_or_insert_with(|| {
                Box::new(crate::semantic::ElementExtra::Decorations(
                    Default::default(),
                ))
            })
            .bind(id.into(), signal);
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
            value.unbind(id.into());
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
                    | crate::property::PropertyDestination::Paint
            ));
            id
        };
        // Keep the original input type through conversion/admission: e.g. an
        // integer is statically finite, so literal callers need no float error
        // branches for a value that cannot reach them.
        let scalar = input.into_prop().literal_scalar().expect("sealed literal");
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
            } else if input.literal_scalar().is_some() {
                self.literal_properties::<CODE, SIZE, T, _>(input);
            } else {
                if let Some(group) = input.boolean_id() {
                    self.bind_boolean(crate::style_port::boolean::Record::Member {
                        id: group,
                        sink: id.into(),
                        colors: None,
                    });
                    return;
                }
                let map = input.mapped().expect("sealed mapped input");
                if SIZE {
                    self.bind_mapped_property(id, map);
                    self.bind_mapped_property(PropertyId::Height, map);
                } else {
                    self.bind_mapped_property(id, map);
                }
            }
        }
    }
    pub fn w(mut self, width: impl IntoProp<'a, crate::Length>) -> Self {
        self.property_input::<{ PropertyId::Width as u16 }, false, crate::Length, _>(width);
        self
    }
    pub fn h(mut self, height: impl IntoProp<'a, crate::Length>) -> Self {
        self.property_input::<{ PropertyId::Height as u16 }, false, crate::Length, _>(height);
        self
    }
    pub fn size(mut self, size: impl IntoProp<'a, crate::Length>) -> Self {
        self.property_input::<{ PropertyId::Width as u16 }, true, crate::Length, _>(size);
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
    pub(crate) fn color_property<I: IntoProp<'a, Color>>(&mut self, input: I, foreground: bool) {
        if foreground {
            self.property_input::<{ PropertyId::Foreground as u16 }, false, Color, I>(input);
        } else {
            self.property_input::<{ PropertyId::Background as u16 }, false, Color, I>(input);
        }
    }
    pub(crate) fn color_operand(mut self, color: crate::ColorInput<'a>, foreground: bool) -> Self {
        match color.operand() {
            crate::style_port::ColorOperand::Property(input) => {
                self.color_property(input, foreground)
            }
            crate::style_port::ColorOperand::Boolean(selection) => {
                let binding = crate::BoolBinding::new(selection.input);
                let state = binding.state().into_prop();
                let id = state.boolean_id().expect("dynamic boolean palette");
                self = binding.attach(self);
                self.bind_boolean(crate::style_port::boolean::Record::Member {
                    id,
                    sink: if foreground {
                        PropertyId::Foreground.into()
                    } else {
                        PropertyId::Background.into()
                    },
                    colors: Some(selection.colors),
                });
            }
            crate::style_port::ColorOperand::Selection(operand) => self.bind_owned_map(
                if foreground {
                    PropertyId::Foreground
                } else {
                    PropertyId::Background
                },
                operand,
            ),
        }
        self
    }
    pub fn fg(self, color: impl crate::IntoColor<'a>) -> Self {
        color.apply_color(self, true)
    }
    pub fn bg<S>(self, background: impl IntoBackground<'a, S>) -> Self {
        background.apply_background(self)
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
                let BoundaryState::Check(check) =
                    std::mem::replace(&mut item.state, BoundaryState::Scope(0))
                else {
                    unreachable!("only descriptions map component routes")
                };
                item.state = BoundaryState::Check(map(check));
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
            state: BoundaryState::Check(Handler::component_check(component)),
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
        let mut focus_indicators = Vec::new();
        let mut images = Vec::new();
        let mut geometry = Vec::new();
        let mut backgrounds = Vec::new();
        let mut style_ports = Vec::new();
        let mut mapped_ports = Vec::new();
        let mut boolean_description = crate::style_port::boolean::Description::default();
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
                control,
                projection: projector,
                image,
                axes,
                geometry: shape,
                bindings,
                mapped,
                background,
            } = element
                .extra
                .take()
                .map(|extra| extra.into_parts())
                .unwrap_or_default();
            if let Some(gradient) = background {
                backgrounds.push((index as usize, gradient));
            }
            let mut shape = shape.unwrap_or_default();
            let mut disabled = control.disabled;
            let mut invalid = control.invalid;
            for binding in bindings {
                let value = binding.sink.admit(binding.signal.scalar())?;
                Self::apply_sink(
                    binding.sink,
                    value,
                    &mut element.kind,
                    &mut element.style,
                    &mut disabled,
                    &mut invalid,
                    &mut shape,
                )?;
                style_ports.push(crate::style_port::Draft {
                    node: index,
                    sink: binding.sink,
                    signal: binding.signal,
                });
            }
            let (mapped, boolean) = mapped.into_parts();
            boolean_description.append(boolean, index)?;
            for binding in mapped {
                let value = binding.sink.admit(binding.operand.scalar()?)?;
                Self::apply_sink(
                    binding.sink,
                    value,
                    &mut element.kind,
                    &mut element.style,
                    &mut disabled,
                    &mut invalid,
                    &mut shape,
                )?;
                mapped_ports.push(crate::style_port::MapDraft {
                    node: index,
                    sink: binding.sink,
                    value,
                    operand: binding.operand,
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
            if shape.corner_radius.to_bits() != 0 || shape.clip_children {
                geometry.push((index as usize, shape));
            }
            if let Some(mut spec) = image {
                spec.set_geometry(shape);
                images.push(crate::image::ImageDraft { node: index, spec });
            }
            if let Some((projector, map)) = projector {
                let mut child = projector.render(readers);
                if let Some(map) = map {
                    map(&mut child);
                }
                element.append_children(child);
            }
            if let Some(color) = control.focus_indicator {
                focus_indicators.push((index as usize, color));
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
                    wrapper.append_children(row);
                    wrapper.style.height = crate::Length::Points(row_height as f32);
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
                disabled,
                invalid,
                text: element.text.take(),
                style: element.style,
                on_click: element.on_click.take(),
                components: std::mem::take(&mut element.components),
            });
        }
        let boolean_groups = boolean_description.finish()?;
        for group in &boolean_groups {
            for member in &group.members {
                let node = &mut output[member.node as usize];
                let value = if let Some(colors) = member.colors {
                    crate::property::PropertyValue::Color(colors[usize::from(group.value)])
                } else {
                    crate::property::PropertyValue::Flag(group.value)
                };
                let value = member.sink.admit(crate::style_port::Scalar::Value(value))?;
                let mut shape = geometry
                    .iter()
                    .find(|(index, _)| *index == member.node as usize)
                    .map_or(crate::property::GeometryStyle::default(), |(_, shape)| {
                        *shape
                    });
                Self::apply_sink(
                    member.sink,
                    value,
                    &mut node.kind,
                    &mut node.style,
                    &mut node.disabled,
                    &mut node.invalid,
                    &mut shape,
                )?;
                if member.sink.property().is_some_and(|id| {
                    id.info().destination == crate::property::PropertyDestination::Geometry
                }) {
                    if let Some((_, old)) = geometry
                        .iter_mut()
                        .find(|(index, _)| *index == member.node as usize)
                    {
                        *old = shape;
                    } else {
                        geometry.push((member.node as usize, shape));
                    }
                }
            }
        }
        Ok(Description {
            boolean_groups,
            nodes: output,
            viewports,
            annotations,
            focus_indicators,
            images,
            geometry,
            backgrounds,
            style_ports,
            mapped_ports,
        })
    }
}

// Sparse boundary metadata has one pointer in ordinary leaf descriptions.
// Component roots prepend outer boundaries; disposal is iterative even for an
// unlowered element containing many nested boundaries on the same visual root.
#[derive(Default)]
pub(crate) struct ComponentBoundaries(Option<Box<ComponentBoundary>>);
struct ComponentBoundary {
    state: BoundaryState,
    next: ComponentBoundaries,
}
enum BoundaryState {
    Check(Handler),
    Scope(u32),
}
impl ComponentBoundaries {
    pub(crate) fn admit(&mut self, receiver: &dyn Any, sources: &dyn Any) -> Result<(), BindError> {
        let mut scope = 0;
        for boundary in std::iter::successors(self.0.as_deref(), |item| item.next.0.as_deref()) {
            let BoundaryState::Check(check) = &boundary.state else {
                unreachable!("a component boundary is admitted once")
            };
            check.validate(receiver, sources)?;
            // Model ancestry is independent of visual parentage. Identity reuse
            // checks this root against its innermost component boundary.
            scope = check.owner_scope(receiver, sources)?;
        }
        if let Some(boundary) = self.0.as_deref_mut() {
            // Reuse the checked route's storage until this draft is consumed.
            // No dense scope column or additional ordinary-node field is needed.
            boundary.state = BoundaryState::Scope(scope);
            boundary.next = Self::default();
        }
        Ok(())
    }

    pub(crate) fn scope(&self) -> Option<u32> {
        match &self.0.as_deref()?.state {
            BoundaryState::Scope(scope) => Some(*scope),
            BoundaryState::Check(_) => unreachable!("component admission precedes retention"),
        }
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
    pub boolean_groups: Vec<crate::style_port::BooleanDraft<'a>>,
    pub backgrounds: Vec<(usize, &'a gpui_canvas::Gradient)>,
    pub geometry: Vec<(usize, crate::property::GeometryStyle)>,
    pub style_ports: Vec<crate::style_port::Draft<'a>>,
    pub mapped_ports: Vec<crate::style_port::MapDraft<'a>>,
    pub nodes: Vec<DraftNode<'a>>,
    pub viewports: Vec<crate::list::ViewportDraft>,
    pub annotations: Vec<crate::semantic::AnnotationDraft<'a>>,
    pub focus_indicators: Vec<(usize, Color)>,
    pub images: Vec<crate::image::ImageDraft<'a>>,
}
pub(crate) struct DraftNode<'a> {
    pub(crate) parent: Option<u32>,
    pub(crate) kind: NodeKind,
    pub(crate) disabled: bool,
    pub(crate) invalid: bool,
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

/// A controlled two-state checkbox with a visual label and semantic checked state.
/// Accepts bool snapshots or a registered `&Signal<bool>` for direct publication.
/// A snapshot's dependencies must use `Sources::field`/`component`; declaring a
/// direct source does not observe an ordinary Rust dereference or branch.
///
/// ```compile_fail
/// use gpui::{Signal, checkbox};
/// let value = Signal::new(1_u32);
/// let _ = checkbox("Wrong type", &value);
/// ```
/// The model owns `checked`; activation only invokes the installed `on_click`
/// route. Pointer release, Space, Enter and assistive Click share that route.
/// Supply a nonempty label or an explicit accessible `name`.
/// Enter follows the ordinary control activation policy. Without a handler the
/// state remains readable, but the checkbox is neither actionable nor focusable.
/// Style the label/control with the ordinary element properties; this does not
/// install a platform widget or draw a check mark.
pub fn checkbox<'a>(label: impl IntoText<'a>, checked: impl IntoProp<'a, bool>) -> El<'a> {
    let mut element = El::new(NodeKind::CheckBox(false), Some(label.into_text()));
    element.control_input(crate::style_port::Sink::CHECKED, checked.into_prop());
    element
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

/// Closed background authoring: existing literal/signal/mapped colors, or an
/// immutable gradient borrowed for this description. Resources are retained
/// once by the owner rather than cloned for every paint command.
#[allow(private_bounds)]
pub trait IntoBackground<'a, S>: sealed::Background<S> {
    #[doc(hidden)]
    fn apply_background(self, element: El<'a>) -> El<'a>;
}
impl<'a, I: crate::IntoColor<'a>> sealed::Background<Color> for I {}
impl<'a, I: crate::IntoColor<'a>> IntoBackground<'a, Color> for I {
    fn apply_background(self, mut element: El<'a>) -> El<'a> {
        if let Some(extra) = element.extra.as_mut() {
            extra.clear_background();
        }
        self.apply_color(element, false)
    }
}
impl sealed::Background<gpui_canvas::Gradient> for &gpui_canvas::Gradient {}
impl<'a> IntoBackground<'a, gpui_canvas::Gradient> for &'a gpui_canvas::Gradient {
    fn apply_background(self, mut element: El<'a>) -> El<'a> {
        element
            .extra
            .get_or_insert_with(|| {
                Box::new(crate::semantic::ElementExtra::Decorations(
                    Default::default(),
                ))
            })
            .set_background(self);
        element.style.bg = Color::TRANSPARENT;
        element
    }
}

mod sealed {
    pub trait Background<S> {}
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

impl<M, T, F, S> sealed::Handler<M, shape::Field> for FieldAction<M, T, F, S> {}
impl<M, F, R> sealed::Handler<M, shape::Property> for PropertyRoute<M, F, R> {}
impl<M: 'static, F, R> IntoHandler<M, shape::Property> for PropertyRoute<M, F, R>
where
    F: Fn(&M, crate::Target) -> Option<PropertyRequest> + 'static,
    R: Fn(&mut M, Result<PropertyState, &crate::Error>) + 'static,
{
    fn install(self, mut element: El<'_>) -> El<'_> {
        element.on_click = Some(Handler(Box::new(self)));
        element
    }
}
impl<M: 'static, T: 'static, F: Fn(&mut T) + 'static, S: SourcePath<M, T> + 'static>
    IntoHandler<M, shape::Field> for FieldAction<M, T, F, S>
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
    pub struct Property;
}

/// Closed constructor-child family. The inferred shape parameter separates
/// blanket iterator implementations from tuples without an application adapter.
pub trait ChildSeq<'a, S>: sealed::Children<S> {
    #[doc(hidden)]
    const MIN_ELEMENTS: usize = 0;
    #[doc(hidden)]
    fn lower_bound(&self) -> usize {
        Self::MIN_ELEMENTS
    }
    #[doc(hidden)]
    fn append(self, out: &mut Vec<El<'a>>);
}
impl<E: Element> sealed::Children<shape::One> for E {}
impl<'a, E: Element + 'a> ChildSeq<'a, shape::One> for E {
    const MIN_ELEMENTS: usize = 1;
    fn append(self, out: &mut Vec<El<'a>>) {
        out.push(self.into_el());
    }
}
impl<C, S> sealed::Children<shape::Optional<S>> for Option<C> where C: sealed::Children<S> {}
impl<'a, C, S> ChildSeq<'a, shape::Optional<S>> for Option<C>
where
    C: ChildSeq<'a, S>,
{
    fn lower_bound(&self) -> usize {
        self.as_ref().map_or(0, C::lower_bound)
    }
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
    fn lower_bound(&self) -> usize {
        if I::Item::MIN_ELEMENTS == 0 {
            0
        } else {
            self.size_hint().0.saturating_mul(I::Item::MIN_ELEMENTS)
        }
    }
    fn append(self, out: &mut Vec<El<'a>>) {
        for children in self {
            children.append(out);
        }
    }
}
impl<T: View> sealed::Children<shape::Views> for &Vec<T> {}
impl<'a, T: View + 'a> ChildSeq<'a, shape::Views> for &'a Vec<T> {
    fn lower_bound(&self) -> usize {
        self.len()
    }
    fn append(self, out: &mut Vec<El<'a>>) {
        out.extend(self.iter().map(View::view));
    }
}
impl<T: View> sealed::Children<shape::View> for &T {}
impl<'a, T: View + 'a> ChildSeq<'a, shape::View> for &'a T {
    const MIN_ELEMENTS: usize = 1;
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
            const MIN_ELEMENTS: usize = 0_usize$(.saturating_add($ty::MIN_ELEMENTS))+;
            fn lower_bound(&self) -> usize {
                let ($($name,)+) = self;
                0_usize$(.saturating_add($name.lower_bound()))+
            }
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

impl Route for crate::runtime::inspector::WindowAction {
    fn admit(&self, _: &dyn Any, _: &dyn Any) -> Result<Admission, BindError> {
        Ok(Admission::Window(*self))
    }
    fn invoke(&self, _: &mut dyn Any) -> Result<(), BindError> {
        unreachable!("window effects dispatch before model routes")
    }
}

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
    fn window_admission_cannot_be_projected_into_a_component_receiver() {
        let route = Handler::window(crate::runtime::inspector::WindowAction::Inspector(
            crate::runtime::inspector::InspectorAction::Pick,
        ));
        assert!(matches!(
            route.admit(&(), &Sources::<()>::new()),
            Ok(Admission::Window(_))
        ));
        struct Child;
        impl View for Child {
            fn view(&self) -> El<'_> {
                div()
            }
        }
        struct Parent(Child);
        let child = Component::new(FieldId::new(1), "child", |p: &Parent| &p.0, |p| &mut p.0);
        let parent = Parent(Child);
        let sources = Sources::new().component(child);
        assert!(matches!(
            route.in_component(child).admit(&parent, &sources),
            Err(BindError::ReceiverMismatch)
        ));
    }

    #[test]
    fn property_method_items_keep_an_empty_capture_and_ordinary_headers() {
        let action = property_action(|_: &Model| None, |_: &mut Model, _| {});
        assert_eq!(size_of_val(&action), 0);
        let mut nodes = button("apply").on_click(action).flatten();
        let handler = nodes[0].on_click.take().unwrap();
        assert_eq!(size_of_val(handler.0.as_ref()), 0);
        assert_eq!(size_of::<Handler>(), 16);
        assert_eq!(size_of::<Admission>(), 16);
        eprintln!(
            "property_action_headers,Handler={},Admission={},PropertyChange={},OptionChange={},PropertyPhase={}",
            size_of::<Handler>(),
            size_of::<Admission>(),
            size_of::<PropertyChange>(),
            size_of::<Option<PropertyChange>>(),
            size_of::<PropertyPhase<'_>>()
        );
        let model = Model {
            count: Signal::new(0),
            other: Signal::new(0),
        };
        assert!(matches!(
            handler.admit(&model, &Sources::<Model>::new()),
            Ok(Admission::Property)
        ));
        let target = crate::identity::Sites::new().target(1);
        assert!(handler.proposal(&model, target).unwrap().is_none());
        assert_eq!(size_of::<PropertyState>(), 80);
        assert_eq!(size_of::<Result<PropertyState, &crate::Error>>(), 80);
        assert_eq!(size_of::<PropertyRequest>(), 48);
        assert_eq!(size_of::<Option<PropertyRequest>>(), 48);
        assert_eq!(size_of::<PropertyPhase<'_>>(), 40);
        let selection = property_selection(
            |_: &Model, target| Some((target, PropertyId::Width)),
            |_: &mut Model, _| {},
        );
        assert_eq!(size_of_val(&selection), 0);
        eprintln!(
            "property_state_headers,State={},Result={},Request={},OptionRequest={},Phase={},SelectionCapture={}",
            size_of::<PropertyState>(),
            size_of::<Result<PropertyState, &crate::Error>>(),
            size_of::<PropertyRequest>(),
            size_of::<Option<PropertyRequest>>(),
            size_of::<PropertyPhase<'_>>(),
            size_of_val(&selection),
        );
    }

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
        assert!(matches!(
            handler.admit(&wrong_receiver, &()),
            Err(BindError::ReceiverMismatch)
        ));
        let mut model = Model {
            count: Signal::new(1),
            other: Signal::new(7),
        };
        assert!(matches!(
            handler.admit(&model, &Sources::<Model>::new()),
            Ok(Admission::Model { exact: None })
        ));
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
        assert!(
            matches!(handler.admit(&model, &sources), Ok(Admission::Model { exact: Some(field) }) if field == COUNT.id())
        );
        assert!(matches!(
            handler.admit(&model, &()),
            Err(BindError::ReceiverMismatch)
        ));
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
        assert!(
            matches!(handler.admit(&model, &sources), Err(BindError::ProjectionMismatch(field)) if field == COUNT.id())
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
        assert_eq!(nodes[0].style.width, crate::Length::Points(320.0));
        assert_eq!(nodes[0].style.height, crate::Length::Points(24.0));
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
                WIDTH, HEIGHT, GAP, PADDING, FONT_SIZE, FOREGROUND, FLOW, TRANSFORM, ALIGN,
                JUSTIFY, WRAP
            );
            assert!(a.bg.same_authoring(b.bg));
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
                check!(w, f64, WIDTH, 3 as $ty, crate::Length::Points(3.0));
                check!(h, f64, HEIGHT, 3 as $ty, crate::Length::Points(3.0));
                check!(gap, f64, GAP, 3 as $ty, 3.0);
                check!(p, f64, PADDING, 3 as $ty, 3.0);
                check!(font_size, f64, FONT_SIZE, 3 as $ty, 3.0);
            )+};
        }
        numbers!(f32, f64, u8, u16, u32, u64, usize, i8, i16, i32, i64, isize);
        check!(w, f64, WIDTH, -0.0_f64, crate::Length::Points(-0.0));
        check!(p, f64, PADDING, -0.0_f32, -0.0);
        // Preserve the inherited IntoLength→f64→f32 conversion, including its
        // double-rounding boundaries, rather than silently switching casts.
        let midpoint = (1_u64 << 63) + (1_u64 << 39) + 1;
        check!(
            w,
            f64,
            WIDTH,
            midpoint,
            crate::Length::Points((midpoint as f64) as f32)
        );
        let midpoint = (1_i64 << 62) + (1_i64 << 38) + 1;
        check!(
            h,
            f64,
            HEIGHT,
            midpoint,
            crate::Length::Points((midpoint as f64) as f32)
        );
        for color in [
            Color::rgb(1, 2, 3),
            Color::display_p3(-0.0, 0.5, 1.0, 0.5).unwrap(),
            Color::linear_srgb(-2.0, -0.0, 3.0, 1.0).unwrap(),
            Color::oklch(0.5, 0.2, 123.0, 0.75).unwrap(),
        ] {
            check!(fg, Color, FOREGROUND, color, color);
            for element in [
                div().bg(color),
                div().bg(&color),
                div().bg(IntoProp::into_prop(color)),
            ] {
                assert!(element.style.bg.same_authoring(color));
                assert!(element.extra.is_none());
            }
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
            "El={} Style={} DraftNode={} Handler={} ComponentRoute={} ComponentBoundary={}",
            size_of::<El<'_>>(),
            size_of::<Style>(),
            size_of::<DraftNode<'_>>(),
            size_of::<Handler>(),
            size_of::<ComponentRoute<(), ()>>(),
            size_of::<ComponentBoundary>()
        );
        assert_eq!(size_of::<BoundaryState>(), size_of::<Handler>());
        assert_eq!(
            size_of::<ComponentBoundary>(),
            size_of::<Handler>() + size_of::<ComponentBoundaries>()
        );
        let el = text("borrowed");
        assert_eq!(el.children.capacity(), 0);
        assert!(el.on_click.is_none());
    }
}
