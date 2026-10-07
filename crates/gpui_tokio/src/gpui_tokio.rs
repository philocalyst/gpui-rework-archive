//! Tokio adapters for GPUI's executor traits.
//!
//! This crate bridges Tokio futures into GPUI's application scheduling model.
//! [`init`] creates and owns a small multi-thread runtime; use
//! [`init_from_handle`] when the embedding application owns runtime setup and
//! shutdown.

use std::future::Future;

use gpui::{App, AppContext, Global, ReadGlobal, Task};
use gpui_util::defer;

pub use tokio::task::JoinError;

/// Initializes the Tokio wrapper using a new Tokio runtime with 2 worker threads.
///
/// GPUI stores the runtime as an app global and shuts it down in the background
/// when the app releases that global. If you need more threads or share the
/// runtime with other application code, create it yourself and pass a handle to
/// [`init_from_handle`].
pub fn init(cx: &mut App) {
    let runtime = tokio::runtime::Builder::new_multi_thread()
        // Since we now have two executors, let's try to keep our footprint small
        .worker_threads(2)
        .enable_all()
        .build()
        .expect("Failed to initialize Tokio");

    let handle = runtime.handle().clone();
    cx.set_global(GlobalTokio {
        owned_runtime: Some(runtime),
        handle,
    });
}

/// Initializes the Tokio wrapper using a Tokio runtime handle owned elsewhere.
///
/// GPUI does not shut down the supplied runtime when the app releases its
/// global handle.
pub fn init_from_handle(cx: &mut App, handle: tokio::runtime::Handle) {
    cx.set_global(GlobalTokio {
        owned_runtime: None,
        handle,
    });
}

struct GlobalTokio {
    owned_runtime: Option<tokio::runtime::Runtime>,
    handle: tokio::runtime::Handle,
}

impl Global for GlobalTokio {}

impl Drop for GlobalTokio {
    fn drop(&mut self) {
        if let Some(runtime) = self.owned_runtime.take() {
            runtime.shutdown_background();
        }
    }
}

/// Namespace for Tokio-to-GPUI task adapters.
pub struct Tokio {}

impl Tokio {
    /// Spawns `f` on Tokio and returns its join result as a GPUI task.
    ///
    /// Await the task to receive `Ok(output)` or a Tokio [`JoinError`]. Dropping
    /// the GPUI task aborts the Tokio task; detaching the GPUI task keeps the
    /// join task alive so it can finish without a consumer.
    pub fn spawn<C, Fut, R>(cx: &C, f: Fut) -> Task<Result<R, JoinError>>
    where
        C: AppContext,
        Fut: Future<Output = R> + Send + 'static,
        R: Send + 'static,
    {
        cx.read_global(|tokio: &GlobalTokio, cx| {
            let join_handle = tokio.handle.spawn(f);
            let abort_handle = join_handle.abort_handle();
            let cancel = defer(move || {
                abort_handle.abort();
            });
            cx.background_spawn(async move {
                let result = join_handle.await;
                drop(cancel);
                result
            })
        })
    }

    /// Spawns `f` on Tokio and flattens its result into `anyhow::Result`.
    ///
    /// Both an error returned by `f` and a Tokio join failure become an error
    /// in the returned GPUI task. Dropping the GPUI task aborts the Tokio task.
    pub fn spawn_result<C, Fut, R>(cx: &C, f: Fut) -> Task<anyhow::Result<R>>
    where
        C: AppContext,
        Fut: Future<Output = anyhow::Result<R>> + Send + 'static,
        R: Send + 'static,
    {
        cx.read_global(|tokio: &GlobalTokio, cx| {
            let join_handle = tokio.handle.spawn(f);
            let abort_handle = join_handle.abort_handle();
            let cancel = defer(move || {
                abort_handle.abort();
            });
            cx.background_spawn(async move {
                let result = join_handle.await?;
                drop(cancel);
                result
            })
        })
    }

    /// Returns the configured Tokio runtime handle.
    ///
    /// Panics if [`init`] or [`init_from_handle`] has not been called for `cx`.
    pub fn handle(cx: &App) -> tokio::runtime::Handle {
        GlobalTokio::global(cx).handle.clone()
    }
}
