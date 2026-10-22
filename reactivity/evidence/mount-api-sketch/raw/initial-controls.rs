//! Compile-only API alternatives; declarations below have no implementation.
//! No constructor mounts a native window, and no control is executed as a test.
#![cfg(feature = "native-core")]
#![allow(dead_code)]
use gpui::{
    Component, El, Error, FieldId, LaneSet, PresentedFrame, PropertyChange, RendererPolicy, Sources,
    View, Win, Window, button, div, property::{Contribution, PropertyId, PropertyValue}, row,
};

#[derive(Clone, Copy)]
struct PropertyState {
    target: gpui::Target,
    id: PropertyId,
    value: PropertyValue,
    contribution: Contribution<PropertyValue>,
}
// Signature controls only. A real implementation belongs inside the existing
// closed Route admission/transaction path; an application cannot implement it.
trait PropertyBindings {
    fn select<'a, M: 'static, F, R>(element: El<'a>, propose: F, reply: R) -> El<'a>
    where
        F: Fn(&M, gpui::Target) -> Option<(gpui::Target, PropertyId)> + 'static,
        R: Fn(&mut M, Result<PropertyState, &Error>) + 'static;
    fn edit<'a, M: 'static, F, R>(element: El<'a>, propose: F, reply: R) -> El<'a>
    where
        F: Fn(&M) -> Option<PropertyChange> + 'static,
        R: Fn(&mut M, Result<PropertyState, &Error>) + 'static;
}
#[path = "../examples/support/property_workbench.rs"]
mod workbench;
use workbench::Companion;

fn select_self(_: &Companion, target: gpui::Target) -> Option<(gpui::Target, PropertyId)> {
    Some((target, PropertyId::Width))
}
fn receive(model: &mut Companion, result: Result<PropertyState, &Error>) {
    match result {
        Ok(state) => model.editor.select(state.target, state.id, state.value),
        Err(error) => model.editor.status = error.to_string(),
    }
}
fn selected(model: &Companion, _: gpui::Target) -> Option<(gpui::Target, PropertyId)> {
    model.editor.selected.map(|(target, id, _)| (target, id))
}
fn inherit(model: &Companion) -> Option<PropertyChange> {
    selected(model, model.editor.selected?.0).map(|(target, id)| (target, id, Contribution::Inherit))
}
fn selection_control<B: PropertyBindings>(model: &Companion) -> El<'_> {
    const APP: Component<Companion, workbench::LibraryButton> = Component::new(
        FieldId::new(1), "application", |m| &m.application, |m| &mut m.application,
    );
    // Explicit root-route replacement, not additive interception of child input.
    row((
        B::select(APP.view(model), select_self, receive),
        B::select(button("Refresh selection"), selected, receive),
        B::edit(button("Inherit"), inherit, receive),
    ))
}
// Both ownership alternatives can seed the existing public editor, but neither
// solves later canonical property reads without the state exchange above.
fn seed(win: &mut Win<Companion>) -> Result<(), Error> {
    let target = win.query().text("Library button").one()?;
    let value = win.property_value(target, PropertyId::Width)?;
    win.update(|model| model.editor.select(target, PropertyId::Width, value))?;
    Ok(())
}
trait OpeningControl<M: View + 'static, L: LaneSet<M> = ()>: Sized {
    fn adopt(owner: Win<M, L>) -> Result<Self, Error>;
    fn initialize<F>(self, initialize: F) -> Self
    where F: FnOnce(&mut Win<M, L>) -> Result<(), Error> + 'static;
}
fn adopted_control<W: OpeningControl<Companion>>() -> Result<W, Error> {
    let mut owner = Win::with_size(Companion::default(), 800, 600)?;
    seed(&mut owner)?;
    W::adopt(owner)
}
fn initialized_control<W: OpeningControl<Companion>>(window: W) -> W {
    window.initialize(seed)
}
// Canonical masked-source control, using only existing public APIs. Type checked
// but deliberately unexecuted here; production work would add behavioral gates.
fn masked_source_control(mut owner: Win<Companion>) -> Result<(), Error> {
    let target = owner.query().text("Library button").one()?;
    owner.set_property_value(target, PropertyId::Width, Contribution::Set(PropertyValue::Dimension(Some(193.25))))?;
    owner.update(|model| *model.application.width = 170.)?;
    let masked = owner.property_value(target, PropertyId::Width)?;
    owner.set_property_value(target, PropertyId::Width, Contribution::Inherit)?;
    let revealed = owner.property_value(target, PropertyId::Width)?;
    assert_eq!(masked, PropertyValue::Dimension(Some(193.25)));
    assert_eq!(revealed, PropertyValue::Dimension(Some(170.)));
    Ok(())
}
struct Empty;
struct Small([u8; 8]);
struct Large([u8; 128]);
impl View for Empty { fn view(&self) -> El<'_> { div() } }
impl View for Small { fn view(&self) -> El<'_> { div() } }
impl View for Large { fn view(&self) -> El<'_> { div() } }
// Layout controls model a possible opening envelope, not private production ABI.
struct Policy {
    title: String,
    size: [u32; 2],
    error: Option<Box<dyn FnMut(&Error)>>,
    presented: Option<Box<dyn FnMut(PresentedFrame)>>,
    renderer: RendererPolicy,
    inspector: bool,
}
enum Mount<M: View + 'static, L: LaneSet<M> = ()> {
    Root { lanes: L, model: M },
    Owner(Win<M, L>),
}
struct AdoptOpening<M: View + 'static> { mount: Mount<M>, policy: Policy }
struct BoxedOpening<M: View + 'static> {
    model: M,
    policy: Policy,
    initialize: Option<Box<dyn FnOnce(&mut Win<M>) -> Result<(), Error>>>,
}
struct FunctionOpening<M: View + 'static> {
    model: M,
    policy: Policy,
    initialize: Option<fn(&mut Win<M>) -> Result<(), Error>>,
}
// Intentional zero-size diagnostic pass is replaced by exact assertions after
// rustc reports each concrete size; neither pass executes or mounts anything.
const _: [(); 0] = [(); std::mem::size_of::<Win<Empty>>()];
const _: [(); 0] = [(); std::mem::size_of::<Option<Win<Empty>>>()];
const _: [(); 0] = [(); std::mem::size_of::<Window<Empty>>()];
const _: [(); 0] = [(); std::mem::size_of::<Option<Window<Empty>>>()];
const _: [(); 0] = [(); std::mem::size_of::<Window<Small>>()];
const _: [(); 0] = [(); std::mem::size_of::<Window<Large>>()];
const _: [(); 0] = [(); std::mem::size_of::<Window<Companion>>()];
const _: [(); 0] = [(); std::mem::size_of::<Policy>()];
const _: [(); 0] = [(); std::mem::size_of::<Mount<Empty>>()];
const _: [(); 0] = [(); std::mem::size_of::<Mount<Small>>()];
const _: [(); 0] = [(); std::mem::size_of::<Mount<Large>>()];
const _: [(); 0] = [(); std::mem::size_of::<AdoptOpening<Empty>>()];
const _: [(); 0] = [(); std::mem::size_of::<AdoptOpening<Small>>()];
const _: [(); 0] = [(); std::mem::size_of::<AdoptOpening<Large>>()];
const _: [(); 0] = [(); std::mem::size_of::<BoxedOpening<Empty>>()];
const _: [(); 0] = [(); std::mem::size_of::<FunctionOpening<Empty>>()];
const _: [(); 0] = [(); std::mem::size_of::<PropertyState>()];
