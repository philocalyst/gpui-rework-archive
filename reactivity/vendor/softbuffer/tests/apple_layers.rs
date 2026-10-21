//! AppKit must run on the process main thread. Use a custom harness rather than
//! letting Rust's test harness put NSView creation on arbitrary worker threads.
#[cfg(target_os = "macos")]
fn main() {
    use objc2::{class, msg_send, rc::Retained, runtime::Bool, MainThreadMarker};
    use objc2_foundation::NSObject;
    use objc2_quartz_core::CALayer;
    use raw_window_handle::{
        AppKitWindowHandle, DisplayHandle, HandleError, HasDisplayHandle, HasWindowHandle,
        RawWindowHandle, WindowHandle,
    };
    use std::{
        marker::PhantomData,
        num::NonZeroU32,
        ptr::NonNull,
        sync::mpsc,
        time::{Duration, Instant},
    };

    #[link(name = "AppKit", kind = "framework")]
    unsafe extern "C" {}
    static_assertions::assert_impl_all!(softbuffer::Surface<(), ()>: Send);
    let _main = MainThreadMarker::new().expect("custom test main must run on main thread");
    // A non-owning raw-handle lease, tied to the main-owned NSView borrow.
    // It transfers only handle identity; it never sends or dereferences NSView.
    #[derive(Clone, Copy)]
    struct Window<'a> {
        raw: usize,
        _view: PhantomData<fn() -> &'a NSObject>,
    }
    impl<'a> Window<'a> {
        fn new(view: &'a NSObject) -> Self {
            Self {
                raw: NonNull::from(view).as_ptr() as usize,
                _view: PhantomData,
            }
        }
    }
    impl HasDisplayHandle for Window<'_> {
        fn display_handle(&self) -> Result<DisplayHandle<'_>, HandleError> {
            Ok(DisplayHandle::appkit())
        }
    }
    impl HasWindowHandle for Window<'_> {
        fn window_handle(&self) -> Result<WindowHandle<'_>, HandleError> {
            // SAFETY: The lifetime marker borrows the live main-owned NSView. No
            // surface or worker lease outlives that view, and the pointer is
            // merely exported here, never dereferenced from this raw lease.
            Ok(unsafe {
                WindowHandle::borrow_raw(RawWindowHandle::AppKit(AppKitWindowHandle::new(
                    NonNull::new(self.raw as *mut std::ffi::c_void).unwrap(),
                )))
            })
        }
    }
    let view: Retained<NSObject> = unsafe { msg_send![class!(NSView), new] };
    let _: () = unsafe { msg_send![&*view, setWantsLayer: Bool::YES] };
    let root: Retained<CALayer> = unsafe { msg_send![&*view, layer] };
    let window = Window::new(&view);
    let context = softbuffer::Context::new(window).unwrap();
    let other = CALayer::new();
    root.addSublayer(&other);
    let initial = unsafe { root.sublayers() }.map_or(0, |layers| layers.len());
    for _ in 0..20 {
        let mut surface = softbuffer::Surface::new(&context, window).unwrap();
        assert_eq!(unsafe { root.sublayers() }.unwrap().len(), initial + 1);
        surface
            .resize(NonZeroU32::new(8).unwrap(), NonZeroU32::new(8).unwrap())
            .unwrap();
        let mut buffer = surface.buffer_mut().unwrap();
        buffer.fill(0x00_12_34_56);
        buffer.present().unwrap();
        drop(surface);
        assert_eq!(
            unsafe { root.sublayers() }.unwrap().len(),
            initial,
            "CG surface must not leave an attached contents layer"
        );
        assert!(
            other.superlayer().is_some(),
            "caller-owned sibling must survive"
        );
        // Stale KVO callbacks must be deregistered before observer destruction.
        root.setContentsScale(2.0);
        root.setContentsScale(1.0);
    }
    let surface = softbuffer::Surface::new(&context, window).unwrap();
    std::thread::scope(|scope| {
        let (send, receive) = mpsc::sync_channel(1);
        let worker = scope.spawn(move || {
            drop(surface);
            send.send(()).unwrap();
        });
        receive
            .recv_timeout(Duration::from_secs(2))
            .expect("CG drop must not wait for main queue");
        worker.join().unwrap();
    });
    let deadline = Instant::now() + Duration::from_secs(2);
    while unsafe { root.sublayers() }.unwrap().len() != initial {
        assert!(
            Instant::now() < deadline,
            "queued CG KVO/layer cleanup did not complete"
        );
        let mode = unsafe { objc2_core_foundation::kCFRunLoopDefaultMode };
        objc2_core_foundation::CFRunLoop::run_in_mode(mode, 0.01, true);
    }
    root.setContentsScale(2.0);
    root.setContentsScale(1.0);
    other.removeFromSuperlayer();
    println!("Apple software layer presentation/drop, KVO and sibling preservation passed");
}
#[cfg(not(target_os = "macos"))]
fn main() {
    eprintln!("apple_layers requires macOS; no platform assertion ran");
}
