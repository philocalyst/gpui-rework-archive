//! An element-based 100-node camera graph for issue #273.
//!
//! Camera pan/zoom is applied once to the graph subtree; node hitboxes and
//! pointer events follow that transform. The node transform is intentionally
//! nested and rotated to exercise composition.

use gpui::{
    App, Bounds, Context, CoordinateSpace, DispatchPhase, ElementTransform, Hitbox, MouseButton,
    MouseDownEvent, MouseMoveEvent, MouseUpEvent, Pixels, Point, Radians, Render, ScrollDelta,
    ScrollWheelEvent, Window, WindowBounds, WindowOptions, div, point, prelude::*, px, rgb, size,
};

#[path = "../shared/prelude.rs"]
mod example_prelude;

const NODE_COUNT: usize = 100;
const NODE_WIDTH: f32 = 168.0;
const NODE_HEIGHT: f32 = 88.0;
const GRID_COLUMNS: usize = 10;
const GRID_STEP_X: f32 = 230.0;
const GRID_STEP_Y: f32 = 150.0;

#[derive(Clone, Copy)]
enum Drag {
    Pan {
        last_window_point: Point<Pixels>,
    },
    Node {
        index: usize,
        grab_offset: Point<Pixels>,
    },
}

struct GraphState {
    zoom: f32,
    pan: Point<Pixels>,
    nodes: Vec<Point<Pixels>>,
    drag: Option<Drag>,
}

impl GraphState {
    fn new() -> Self {
        let nodes = (0..NODE_COUNT)
            .map(|index| {
                let column = index % GRID_COLUMNS;
                let row = index / GRID_COLUMNS;
                point(
                    px(72.0 + column as f32 * GRID_STEP_X),
                    px(68.0 + row as f32 * GRID_STEP_Y),
                )
            })
            .collect();
        Self {
            zoom: 1.0,
            pan: point(px(24.0), px(24.0)),
            nodes,
            drag: None,
        }
    }

    fn camera(&self) -> ElementTransform {
        ElementTransform::default()
            .scale(self.zoom)
            .translate(self.pan)
    }

    fn zoom_at_window_point(
        &mut self,
        camera_space: &CoordinateSpace,
        pointer: Point<Pixels>,
        wheel: ScrollDelta,
    ) {
        let wheel_y = match wheel {
            ScrollDelta::Pixels(delta) => f32::from(delta.y),
            ScrollDelta::Lines(delta) => delta.y * 32.0,
        };
        if wheel_y == 0.0 {
            return;
        }

        // The platform gives us a window point. Resolve it through the same
        // camera mapping used by layout, then preserve that graph point.
        let Some(world_anchor) = camera_space.from_window(pointer) else {
            return;
        };
        let next_zoom = (self.zoom * (-wheel_y * 0.0015).exp()).clamp(0.25, 4.0);
        let zoom_change = self.zoom - next_zoom;
        self.pan += point(world_anchor.x * zoom_change, world_anchor.y * zoom_change);
        self.zoom = next_zoom;
    }
}

struct CameraGraph {
    state: std::rc::Rc<std::cell::RefCell<GraphState>>,
}

impl CameraGraph {
    fn new() -> Self {
        Self {
            state: std::rc::Rc::new(std::cell::RefCell::new(GraphState::new())),
        }
    }
}

impl Render for CameraGraph {
    fn render(&mut self, window: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
        let state = self.state.borrow();
        let camera = state.camera();
        let node_positions = state.nodes.clone();
        let viewport = Bounds::new(point(px(0.), px(0.)), window.viewport_size());
        let camera_space = CoordinateSpace::new(camera.resolve(viewport));
        drop(state);
        let state_for_wheel = self.state.clone();
        let camera_space_for_wheel = camera_space.clone();
        let state_for_pan_down = self.state.clone();
        let state_for_pan_move = self.state.clone();
        let state_for_node_move = self.state.clone();
        let state_for_up = self.state.clone();

        div()
            .size_full()
            .bg(rgb(0x10141d))
            .overflow_hidden()
            // This viewport hitbox handles empty-space panning and wheel zoom.
            .on_mouse_down_all(
                move |event: &MouseDownEvent,
                      phase: DispatchPhase,
                      hitbox: &Hitbox,
                      window: &mut Window,
                      _cx: &mut App| {
                    if phase == DispatchPhase::Bubble
                        && event.button == MouseButton::Middle
                        && hitbox.is_hovered(window)
                    {
                        state_for_pan_down.borrow_mut().drag = Some(Drag::Pan {
                            last_window_point: window.window_mouse_position(),
                        });
                        window.capture_pointer(hitbox.id);
                        window.refresh();
                    }
                },
            )
            .on_mouse_move_all(
                move |_event: &MouseMoveEvent,
                      _phase: DispatchPhase,
                      _hitbox: &Hitbox,
                      window: &mut Window,
                      _cx: &mut App| {
                    let window_point = window.window_mouse_position();
                    let mut state = state_for_pan_move.borrow_mut();
                    if let Some(Drag::Pan { last_window_point }) = state.drag {
                        state.pan += window_point - last_window_point;
                        state.drag = Some(Drag::Pan {
                            last_window_point: window_point,
                        });
                        window.refresh();
                    }
                },
            )
            .on_mouse_up_all(
                move |event: &MouseUpEvent,
                      _phase: DispatchPhase,
                      _hitbox: &Hitbox,
                      window: &mut Window,
                      _cx: &mut App| {
                    if event.button == MouseButton::Left || event.button == MouseButton::Middle {
                        state_for_up.borrow_mut().drag = None;
                        window.refresh();
                    }
                },
            )
            .on_scroll_wheel(
                move |event: &ScrollWheelEvent, window: &mut Window, _cx: &mut App| {
                    let pointer = window.window_mouse_position();
                    state_for_wheel.borrow_mut().zoom_at_window_point(
                        &camera_space_for_wheel,
                        pointer,
                        event.delta,
                    );
                    window.refresh();
                },
            )
            .child(
                div()
                    .absolute()
                    .left_0()
                    .top_0()
                    .size_full()
                    .transform(camera)
                    .on_mouse_move_all(
                        move |event: &MouseMoveEvent,
                              _phase: DispatchPhase,
                              _hitbox: &Hitbox,
                              window: &mut Window,
                              _cx: &mut App| {
                            if !event.dragging() {
                                return;
                            }
                            let mut state = state_for_node_move.borrow_mut();
                            if let Some(Drag::Node { index, grab_offset }) = state.drag {
                                // This listener is inside the camera transform:
                                // the event position is already in graph space.
                                state.nodes[index] = event.position - grab_offset;
                                window.refresh();
                            }
                        },
                    )
                    .children(
                        node_positions
                            .into_iter()
                            .enumerate()
                            .map(|(index, position)| {
                                graph_node(
                                    index,
                                    position,
                                    self.state.clone(),
                                    camera_space.clone(),
                                )
                            }),
                    ),
            )
    }
}

fn graph_node(
    index: usize,
    position: Point<Pixels>,
    state: std::rc::Rc<std::cell::RefCell<GraphState>>,
    camera_space: CoordinateSpace,
) -> impl IntoElement {
    let rotation = Radians(((index % 7) as f32 - 3.0) * 0.018);
    div()
        .absolute()
        .left(position.x)
        .top(position.y)
        .w(px(NODE_WIDTH))
        .h(px(NODE_HEIGHT))
        .transform(
            ElementTransform::default()
                .origin(point(0.5, 0.5))
                .rotate(rotation),
        )
        .on_mouse_down_all(
            move |event: &MouseDownEvent,
                  phase: DispatchPhase,
                  hitbox: &Hitbox,
                  window: &mut Window,
                  _cx: &mut App| {
                if phase == DispatchPhase::Bubble
                    && event.button == MouseButton::Left
                    && hitbox.is_hovered(window)
                {
                    let pointer = window.window_mouse_position();
                    let Some(graph_point) = camera_space.from_window(pointer) else {
                        return;
                    };
                    let mut state = state.borrow_mut();
                    // Invert only the camera here. Inverting the
                    // rotated node event would make the grab offset
                    // jump as soon as dragging begins.
                    let node_origin = state.nodes[index];
                    state.drag = Some(Drag::Node {
                        index,
                        grab_offset: graph_point - node_origin,
                    });
                    window.capture_pointer(hitbox.id);
                    window.refresh();
                }
            },
        )
        .child(
            div()
                .size_full()
                .flex()
                .flex_col()
                .justify_between()
                .p_3()
                .rounded_lg()
                .border_1()
                .border_color(rgb(0x48546a))
                .bg(rgb(0x202a3b))
                .shadow_lg()
                .child(
                    div()
                        .text_sm()
                        .font_weight(gpui::FontWeight::SEMIBOLD)
                        .text_color(rgb(0xe7edf7))
                        .child(format!("Node {index:02}")),
                )
                .child(
                    div()
                        .text_xs()
                        .text_color(rgb(0x9cabc2))
                        .child(format!("graph object · {index:03}")),
                ),
        )
}

fn main() {
    gpui_platform::application().run(|cx: &mut App| {
        let bounds = gpui::Bounds::centered(None, size(px(1100.), px(760.)), cx);
        cx.open_window(
            WindowOptions::new().window_bounds(Some(WindowBounds::Windowed(bounds))),
            |_, cx| cx.new(|_| CameraGraph::new()),
        )
        .expect("Failed to open camera graph window");
        example_prelude::init_example(cx, "Transformed Camera Graph");
    });
}
