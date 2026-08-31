use super::*;
use anyhow::{Context as _, anyhow};
use std::sync::{
    Arc,
    atomic::{AtomicBool, Ordering},
};

pub(super) fn screen_sources(
    foreground_executor: &ForegroundExecutor,
) -> oneshot::Receiver<Result<Vec<Rc<dyn ScreenCaptureSource>>>> {
    let (sources_tx, sources_rx) = oneshot::channel();
    std::thread::spawn(|| {
        let sources = scap::get_all_targets().map(|targets| {
            targets
                .into_iter()
                .filter_map(|target| match target {
                    scap::Target::Display(display) => Some(ScapCaptureSource {
                        size: crate::size(
                            DevicePixels(display.width as i32),
                            DevicePixels(display.height as i32),
                        ),
                        target: display,
                    }),
                    scap::Target::Window(_) => None,
                })
                .collect()
        });
        sources_tx.send(sources).ok();
    });
    to_dyn_screen_capture_sources(sources_rx, foreground_executor)
}

struct ScapCaptureSource {
    target: scap::Display,
    size: Size<DevicePixels>,
}

impl ScreenCaptureSource for ScapCaptureSource {
    fn metadata(&self) -> Result<SourceMetadata> {
        Ok(SourceMetadata {
            resolution: self.size,
            label: Some(self.target.title.clone().into()),
            is_main: None,
            id: self.target.id as u64,
        })
    }

    fn stream(
        &self,
        foreground_executor: &ForegroundExecutor,
        frame_callback: Box<dyn Fn(ScreenCaptureFrame) + Send>,
    ) -> oneshot::Receiver<Result<Box<dyn ScreenCaptureStream>>> {
        capture_display(&self.target, foreground_executor, frame_callback)
    }
}

pub(super) fn capture_display(
    display: &scap::Display,
    foreground_executor: &ForegroundExecutor,
    frame_callback: Box<dyn Fn(ScreenCaptureFrame) + Send>,
) -> oneshot::Receiver<Result<Box<dyn ScreenCaptureStream>>> {
    let (stream_tx, stream_rx) = oneshot::channel();
    let display = display.clone();
    std::thread::spawn(
        move || match new_capturer(Some(scap::Target::Display(display.clone()))) {
            Ok(mut capturer) => {
                capturer.start_capture();
                run_capture(capturer, display, frame_callback, stream_tx);
            }
            Err(error) => {
                stream_tx.send(Err(error)).ok();
            }
        },
    );
    to_dyn_screen_capture_stream(stream_rx, foreground_executor)
}

pub(super) fn start_default_target(
    foreground_executor: &ForegroundExecutor,
) -> oneshot::Receiver<Result<Vec<Rc<dyn ScreenCaptureSource>>>> {
    let (sources_tx, sources_rx) = oneshot::channel();
    std::thread::spawn(|| {
        let start_result = gpui_util::maybe!({
            let mut capturer = new_capturer(None)?;
            capturer.start_capture();
            let first_frame = capturer
                .get_next_frame()
                .context("failed to get the first screen capture frame")?;
            let size = frame_size(&first_frame);
            let target = capturer
                .target()
                .context("unable to determine the capture target")?
                .clone();
            Ok((capturer, size, target))
        });

        match start_result {
            Ok((capturer, size, scap::Target::Display(display))) => {
                let (stream_call_tx, stream_call_rx) = std::sync::mpsc::sync_channel(1);
                if sources_tx
                    .send(Ok(vec![DefaultTargetSource {
                        stream_call_tx,
                        size,
                        target: display.clone(),
                    }]))
                    .is_err()
                {
                    return;
                }
                let Ok((stream_tx, frame_callback)) = stream_call_rx.recv() else {
                    return;
                };
                run_capture(capturer, display, frame_callback, stream_tx);
            }
            Ok(_) => {
                sources_tx
                    .send(Err(anyhow!("screen capture target is not a display")))
                    .ok();
            }
            Err(error) => {
                sources_tx.send(Err(error)).ok();
            }
        }
    });
    to_dyn_screen_capture_sources(sources_rx, foreground_executor)
}

struct DefaultTargetSource {
    stream_call_tx: std::sync::mpsc::SyncSender<(
        oneshot::Sender<Result<ScapStream>>,
        Box<dyn Fn(ScreenCaptureFrame) + Send>,
    )>,
    target: scap::Display,
    size: Size<DevicePixels>,
}

impl ScreenCaptureSource for DefaultTargetSource {
    fn metadata(&self) -> Result<SourceMetadata> {
        Ok(SourceMetadata {
            resolution: self.size,
            label: None,
            is_main: None,
            id: self.target.id as u64,
        })
    }

    fn stream(
        &self,
        foreground_executor: &ForegroundExecutor,
        frame_callback: Box<dyn Fn(ScreenCaptureFrame) + Send>,
    ) -> oneshot::Receiver<Result<Box<dyn ScreenCaptureStream>>> {
        let (stream_tx, stream_rx) = oneshot::channel();
        match self.stream_call_tx.try_send((stream_tx, frame_callback)) {
            Ok(()) => {}
            Err(std::sync::mpsc::TrySendError::Full((stream_tx, _)))
            | Err(std::sync::mpsc::TrySendError::Disconnected((stream_tx, _))) => {
                stream_tx
                    .send(Err(anyhow!(
                        "the default screen capture source can only create one stream"
                    )))
                    .ok();
            }
        }
        to_dyn_screen_capture_stream(stream_rx, foreground_executor)
    }
}

fn new_capturer(target: Option<scap::Target>) -> Result<scap::capturer::Capturer> {
    scap::capturer::Capturer::build(scap::capturer::Options {
        fps: 60,
        show_cursor: true,
        show_highlight: true,
        output_type: scap::frame::FrameType::YUVFrame,
        output_resolution: scap::capturer::Resolution::Captured,
        crop_area: None,
        target,
        excluded_targets: None,
    })
}

fn run_capture(
    mut capturer: scap::capturer::Capturer,
    display: scap::Display,
    frame_callback: Box<dyn Fn(ScreenCaptureFrame) + Send>,
    stream_tx: oneshot::Sender<Result<ScapStream>>,
) {
    let cancelled = Arc::new(AtomicBool::new(false));
    let size = crate::size(
        DevicePixels(display.width as i32),
        DevicePixels(display.height as i32),
    );
    if stream_tx
        .send(Ok(ScapStream {
            cancelled: Arc::clone(&cancelled),
            display,
            size,
        }))
        .is_err()
    {
        return;
    }
    while !cancelled.load(Ordering::Acquire) {
        match capturer.get_next_frame() {
            Ok(frame) => frame_callback(ScreenCaptureFrame(frame)),
            Err(error) => {
                log::error!("halting screen capture after frame error: {error}");
                break;
            }
        }
    }
    capturer.stop_capture();
}

struct ScapStream {
    cancelled: Arc<AtomicBool>,
    display: scap::Display,
    size: Size<DevicePixels>,
}

impl ScreenCaptureStream for ScapStream {
    fn metadata(&self) -> Result<SourceMetadata> {
        Ok(SourceMetadata {
            resolution: self.size,
            label: Some(self.display.title.clone().into()),
            is_main: None,
            id: self.display.id as u64,
        })
    }
}

impl Drop for ScapStream {
    fn drop(&mut self) {
        self.cancelled.store(true, Ordering::Release);
    }
}

fn frame_size(frame: &scap::frame::Frame) -> Size<DevicePixels> {
    let (width, height) = match frame {
        scap::frame::Frame::YUVFrame(frame) => (frame.width, frame.height),
        scap::frame::Frame::RGB(frame) => (frame.width, frame.height),
        scap::frame::Frame::RGBx(frame) => (frame.width, frame.height),
        scap::frame::Frame::XBGR(frame) => (frame.width, frame.height),
        scap::frame::Frame::BGRx(frame) => (frame.width, frame.height),
        scap::frame::Frame::BGR0(frame) => (frame.width, frame.height),
        scap::frame::Frame::BGRA(frame) => (frame.width, frame.height),
    };
    crate::size(DevicePixels(width), DevicePixels(height))
}
