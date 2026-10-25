//! Winit types stop at this integration crate. Redraw and lifecycle callbacks
//! are dispatched synchronously; buffering them is not portable.
//!
//! There is deliberately no portable `poll` wrapper: Winit's pump API is absent
//! on web/iOS and has platform-specific callback constraints. Native attachment
//! must use a platform capability, not pretend that all hosts can be pumped.

use crate::WakeGate;
use std::sync::Arc;
use winit::{
    application::ApplicationHandler,
    event::{DeviceEvent, DeviceId, StartCause, WindowEvent},
    event_loop::{ActiveEventLoop, ControlFlow, EventLoop, EventLoopProxy},
    window::WindowId,
};

// This raw capability escape is for platform/render adapters, not component APIs.
pub use winit;

/// A borrowed native callback. No event buffer or cloned text is introduced.
pub enum Callback<'a> {
    NewEvents(StartCause),
    Resumed,
    Suspended,
    Window {
        id: WindowId,
        event: &'a WindowEvent,
    },
    Device {
        id: DeviceId,
        event: &'a DeviceEvent,
    },
    WorkReady,
    AboutToWait,
    MemoryWarning,
    Exiting,
}

/// The integration owner decides which core work to run in each callback.
pub trait Host {
    fn dispatch(&mut self, event_loop: &ActiveEventLoop, callback: Callback<'_>);
}

/// Any-thread wake capability. Cloning it shares one small wake gate.
#[derive(Clone)]
pub struct Wake {
    gate: Arc<WakeGate>,
    proxy: EventLoopProxy<()>,
}

impl Wake {
    /// Signals after enqueuing work; false means the native event loop closed.
    pub fn signal(&self) -> bool {
        self.gate.signal(|| self.proxy.send_event(()).is_ok())
    }
}

/// Adapts the native callbacks without owning application state or a scheduler.
pub struct Driver<H> {
    host: H,
    gate: Arc<WakeGate>,
}

impl<H: Host> Driver<H> {
    /// Binds to an already-created loop. The caller controls loop construction
    /// and main-thread ownership, including embedded hosts and test runners.
    pub fn new(event_loop: &EventLoop<()>, host: H) -> (Self, Wake) {
        let gate = Arc::new(WakeGate::default());
        let wake = Wake {
            gate: Arc::clone(&gate),
            proxy: event_loop.create_proxy(),
        };
        (Self { host, gate }, wake)
    }

    pub fn host(&self) -> &H {
        &self.host
    }

    pub fn host_mut(&mut self) -> &mut H {
        &mut self.host
    }
}

impl<H: Host> ApplicationHandler<()> for Driver<H> {
    fn new_events(&mut self, event_loop: &ActiveEventLoop, cause: StartCause) {
        self.host.dispatch(event_loop, Callback::NewEvents(cause));
    }

    fn resumed(&mut self, event_loop: &ActiveEventLoop) {
        event_loop.set_control_flow(ControlFlow::Wait);
        self.host.dispatch(event_loop, Callback::Resumed);
    }

    fn suspended(&mut self, event_loop: &ActiveEventLoop) {
        self.host.dispatch(event_loop, Callback::Suspended);
    }

    fn user_event(&mut self, event_loop: &ActiveEventLoop, (): ()) {
        self.gate.acknowledge();
        self.host.dispatch(event_loop, Callback::WorkReady);
    }

    fn window_event(&mut self, event_loop: &ActiveEventLoop, id: WindowId, event: WindowEvent) {
        self.host
            .dispatch(event_loop, Callback::Window { id, event: &event });
    }

    fn device_event(&mut self, event_loop: &ActiveEventLoop, id: DeviceId, event: DeviceEvent) {
        self.host
            .dispatch(event_loop, Callback::Device { id, event: &event });
    }

    fn about_to_wait(&mut self, event_loop: &ActiveEventLoop) {
        self.host.dispatch(event_loop, Callback::AboutToWait);
    }

    fn memory_warning(&mut self, event_loop: &ActiveEventLoop) {
        self.host.dispatch(event_loop, Callback::MemoryWarning);
    }

    fn exiting(&mut self, event_loop: &ActiveEventLoop) {
        self.host.dispatch(event_loop, Callback::Exiting);
    }
}
