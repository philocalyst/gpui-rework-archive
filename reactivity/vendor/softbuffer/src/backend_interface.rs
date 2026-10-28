//! Interface implemented by backends

use crate::{InitError, Rect, SoftBufferError};

use raw_window_handle::{HasDisplayHandle, HasWindowHandle};
use std::num::NonZeroU32;

pub(crate) trait ContextInterface<D: HasDisplayHandle + ?Sized> {
    fn new(display: D) -> Result<Self, InitError<D>>
    where
        D: Sized,
        Self: Sized;
}

pub(crate) trait SurfaceInterface<D: HasDisplayHandle + ?Sized, W: HasWindowHandle + ?Sized> {
    type Context: ContextInterface<D>;
    type Buffer<'a>: BufferInterface
    where
        Self: 'a;

    fn new(window: W, context: &Self::Context) -> Result<Self, InitError<W>>
    where
        W: Sized,
        Self: Sized;
    /// Get the inner window handle.
    fn window(&self) -> &W;
    /// Resize the internal buffer to the given width and height.
    fn resize(&mut self, width: NonZeroU32, height: NonZeroU32) -> Result<(), SoftBufferError>;
    /// Present a uniform 0x00RRGGBB image without acquiring a client buffer.
    /// False leaves presentation and buffer history unchanged.
    fn present_solid(&mut self, _color: u32) -> Result<bool, SoftBufferError> {
        Ok(false)
    }
    /// Get a mutable reference to the buffer.
    fn buffer_mut(&mut self) -> Result<Self::Buffer<'_>, SoftBufferError>;
    /// Fetch the buffer from the window.
    fn fetch(&mut self) -> Result<Vec<u32>, SoftBufferError> {
        Err(SoftBufferError::Unimplemented)
    }
}

pub(crate) trait BufferInterface {
    fn width(&self) -> NonZeroU32;
    fn height(&self) -> NonZeroU32;
    fn pixels(&self) -> &[u32];
    fn pixels_mut(&mut self) -> &mut [u32];
    fn age(&self) -> u8;
    fn present_with_damage(self, damage: &[Rect]) -> Result<(), SoftBufferError>;
    fn present(self) -> Result<(), SoftBufferError>;
}
