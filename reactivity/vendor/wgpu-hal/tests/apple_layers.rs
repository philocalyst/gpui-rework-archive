//! Custom harness: AppKit objects must be created on the process main thread,
//! not Rust's normal test-worker threads. No Metal device/GPU is required.
#[cfg(target_os = "macos")]
fn main() {
    use objc2::{MainThreadMarker, class, msg_send, rc::Retained, runtime::Bool};
    use objc2_foundation::NSObject;
    use objc2_quartz_core::{CALayer, CAMetalLayer};
    use raw_window_handle::{
        AppKitDisplayHandle, AppKitWindowHandle, RawDisplayHandle, RawWindowHandle,
    };
    use std::{
        ptr::NonNull,
        sync::mpsc,
        time::{Duration, Instant},
    };
    use wgpu_hal::Instance as _;

    #[link(name = "AppKit", kind = "framework")]
    unsafe extern "C" {}
    let _main = MainThreadMarker::new().expect("custom test main must run on main thread");
    // SAFETY: Main-thread construction of an ordinary NSView, retained until
    // every raw-handle surface created from it has been destroyed.
    let view: Retained<NSObject> = unsafe { msg_send![class!(NSView), new] };
    let _: () = unsafe { msg_send![&*view, setWantsLayer: Bool::YES] };
    let root: Retained<CALayer> = unsafe { msg_send![&*view, layer] };
    let software_sibling = CALayer::new();
    root.addSublayer(&software_sibling);
    // SAFETY: Main thread owns all hierarchy mutation during these reads.
    let count = || unsafe { root.sublayers() }.map_or(0, |layers| layers.len());
    let initial = count();
    let instance = wgpu_hal::metal::Instance {};
    let create = || unsafe {
        // The NSView is live on the main thread throughout every surface lease.
        instance
            .create_surface(
                RawDisplayHandle::AppKit(AppKitDisplayHandle::new()),
                RawWindowHandle::AppKit(AppKitWindowHandle::new(NonNull::from(&*view).cast())),
            )
            .unwrap()
    };
    for _ in 0..20 {
        let surface = create();
        assert_eq!(count(), initial + 1, "one owned injected Metal layer");
        drop(surface);
        assert_eq!(count(), initial, "synchronous main-thread detach");
        assert!(software_sibling.superlayer().is_some());
        root.setContentsScale(2.0);
        root.setContentsScale(1.0);
    }

    // A worker may drop Send+Sync HAL Surface. Destruction must return without
    // waiting for main, and its retained cleanup lease must detach when pumped.
    let surface = create();
    let (send, receive) = mpsc::sync_channel(1);
    let worker = std::thread::spawn(move || {
        drop(surface);
        send.send(()).unwrap();
    });
    receive
        .recv_timeout(Duration::from_secs(2))
        .expect("surface drop must not join/wait for main queue");
    worker.join().unwrap();
    let deadline = Instant::now() + Duration::from_secs(2);
    while count() != initial {
        assert!(
            Instant::now() < deadline,
            "queued owned-layer detach did not complete"
        );
        // SAFETY: The imported static names the default main-thread runloop mode.
        let mode = unsafe { objc2_core_foundation::kCFRunLoopDefaultMode };
        objc2_core_foundation::CFRunLoop::run_in_mode(mode, 0.01, true);
    }

    // The public external-layer API borrows an already owned layer. It must
    // never detach it or affect another sibling when the HAL Surface is dropped.
    let caller_root = CALayer::new();
    let caller_layer = CAMetalLayer::new();
    caller_root.addSublayer(&caller_layer);
    let surface = instance.create_surface_from_layer(&caller_layer);
    drop(surface);
    assert_eq!(unsafe { caller_root.sublayers() }.unwrap().len(), 1);
    assert!(caller_layer.superlayer().is_some());
    // Exercise the raw-window-metal pre_existing path too, not only HAL's
    // explicit external-layer constructor. This NSView hosts caller's Metal
    // root, which is itself attached under a caller-owned parent layer.
    let preexisting_view: Retained<NSObject> = unsafe { msg_send![class!(NSView), new] };
    let _: () = unsafe { msg_send![&*preexisting_view, setWantsLayer: Bool::YES] };
    let _: () = unsafe { msg_send![&*preexisting_view, setLayer: &*caller_layer] };
    caller_root.addSublayer(&caller_layer);
    let surface = unsafe {
        instance
            .create_surface(
                RawDisplayHandle::AppKit(AppKitDisplayHandle::new()),
                RawWindowHandle::AppKit(AppKitWindowHandle::new(
                    NonNull::from(&*preexisting_view).cast(),
                )),
            )
            .unwrap()
    };
    drop(surface);
    assert!(
        caller_layer.superlayer().is_some(),
        "pre-existing raw-handle layer belongs to caller"
    );
    assert_eq!(unsafe { caller_root.sublayers() }.unwrap().len(), 1);
    software_sibling.removeFromSuperlayer();
    caller_layer.removeFromSuperlayer();
    println!("Apple Metal owned-layer main/worker cleanup and borrowed-layer preservation passed");
}
#[cfg(not(target_os = "macos"))]
fn main() {
    eprintln!("apple_layers requires macOS; no platform assertion ran");
}
