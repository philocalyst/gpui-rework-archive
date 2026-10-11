//! Paint-only capture wrapper for caching a child's visual output.

use gpui::{
    AnyElement, App, Bounds, Element, ElementId, GlobalElementId, InspectorElementId, IntoElement,
    LayoutId, PaintSnapshot, Pixels, ScaledPixels, Window,
};

/// Wraps a child and captures its scene output during paint. The wrapper adds no event
/// handlers or accessibility nodes; those remain owned by the live child while it exists.
pub struct PaintSnapshotElement {
    child: AnyElement,
    snapshot: Option<PaintSnapshot>,
    on_capture: Option<Box<dyn FnMut(Option<PaintSnapshot>, Bounds<ScaledPixels>, &mut App)>>,
}

impl PaintSnapshotElement {
    /// Creates a capture wrapper around a child element.
    pub fn new(child: impl IntoElement) -> Self {
        Self {
            child: child.into_any_element(),
            snapshot: None,
            on_capture: None,
        }
    }

    /// Returns the most recently captured paint-only snapshot, if it was supported and bounded.
    pub fn snapshot(&self) -> Option<&PaintSnapshot> {
        self.snapshot.as_ref()
    }

    /// Registers a callback that receives the owned snapshot after each paint. `None` reports
    /// that the child emitted unsupported or over-budget scene content.
    pub fn on_capture(
        mut self,
        callback: impl FnMut(Option<PaintSnapshot>, Bounds<ScaledPixels>, &mut App) + 'static,
    ) -> Self {
        self.on_capture = Some(Box::new(callback));
        self
    }
}

impl Element for PaintSnapshotElement {
    type RequestLayoutState = ();
    type PrepaintState = ();

    fn id(&self) -> Option<ElementId> {
        None
    }
    fn source_location(&self) -> Option<&'static std::panic::Location<'static>> {
        None
    }

    fn request_layout(
        &mut self,
        _: Option<&GlobalElementId>,
        _: Option<&InspectorElementId>,
        window: &mut Window,
        cx: &mut App,
    ) -> (LayoutId, ()) {
        (self.child.request_layout(window, cx), ())
    }

    fn prepaint(
        &mut self,
        _: Option<&GlobalElementId>,
        _: Option<&InspectorElementId>,
        _: Bounds<Pixels>,
        _: &mut (),
        window: &mut Window,
        cx: &mut App,
    ) {
        self.child.prepaint(window, cx);
    }

    fn paint(
        &mut self,
        _: Option<&GlobalElementId>,
        _: Option<&InspectorElementId>,
        bounds: Bounds<Pixels>,
        _: &mut (),
        _: &mut (),
        window: &mut Window,
        cx: &mut App,
    ) {
        let (_, snapshot) =
            window.capture_paint_snapshot(bounds, |window| self.child.paint(window, cx));
        self.snapshot = snapshot.clone();
        if let Some(callback) = &mut self.on_capture {
            callback(snapshot, bounds.scale(window.scale_factor()), cx);
        }
    }
}

impl IntoElement for PaintSnapshotElement {
    type Element = Self;

    fn into_element(self) -> Self::Element {
        self
    }
}
