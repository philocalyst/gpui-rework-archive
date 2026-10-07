//! Optional screen-capture source discovery and stream adaptation.
//!
//! Source enumeration is asynchronous because native capture APIs and desktop portals may prompt
//! or negotiate permissions. The returned handles are reference-counted and platform-owned;
//! callers should retain them while consuming a stream.

use crate::{
    ForegroundExecutor, ScreenCaptureFrame, ScreenCaptureSource, ScreenCaptureStream,
    SourceMetadata,
};
use anyhow::Result;
use futures::channel::oneshot;
use std::rc::Rc;

#[path = "screen_capture/windows.rs"]
mod platform;

/// Discover capture sources on the foreground executor.
///
/// Wayland source discovery cannot enumerate portal targets; use the platform's default-target
/// operation when available. Unsupported platforms resolve to an empty list.
pub fn screen_sources(
    foreground_executor: &ForegroundExecutor,
) -> oneshot::Receiver<Result<Vec<Rc<dyn ScreenCaptureSource>>>> {
    platform::screen_sources(foreground_executor)
}

fn to_dyn_screen_capture_sources<T: ScreenCaptureSource + 'static>(
    sources_rx: oneshot::Receiver<Result<Vec<T>>>,
    foreground_executor: &ForegroundExecutor,
) -> oneshot::Receiver<Result<Vec<Rc<dyn ScreenCaptureSource>>>> {
    let (dyn_sources_tx, dyn_sources_rx) = oneshot::channel();
    foreground_executor
        .spawn(async move {
            match sources_rx.await {
                Ok(Ok(results)) => dyn_sources_tx
                    .send(Ok(results
                        .into_iter()
                        .map(|source| Rc::new(source) as Rc<dyn ScreenCaptureSource>)
                        .collect()))
                    .ok(),
                Ok(Err(error)) => dyn_sources_tx.send(Err(error)).ok(),
                Err(oneshot::Canceled) => None,
            }
        })
        .detach();
    dyn_sources_rx
}

fn to_dyn_screen_capture_stream<T: ScreenCaptureStream + 'static>(
    stream_rx: oneshot::Receiver<Result<T>>,
    foreground_executor: &ForegroundExecutor,
) -> oneshot::Receiver<Result<Box<dyn ScreenCaptureStream>>> {
    let (dyn_stream_tx, dyn_stream_rx) = oneshot::channel();
    foreground_executor
        .spawn(async move {
            match stream_rx.await {
                Ok(Ok(stream)) => dyn_stream_tx
                    .send(Ok(Box::new(stream) as Box<dyn ScreenCaptureStream>))
                    .ok(),
                Ok(Err(error)) => dyn_stream_tx.send(Err(error)).ok(),
                Err(oneshot::Canceled) => None,
            }
        })
        .detach();
    dyn_stream_rx
}
