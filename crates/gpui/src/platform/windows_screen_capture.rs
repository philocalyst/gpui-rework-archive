use crate::{DevicePixels, Size};
use std::sync::Arc;
use windows_061::Win32::Graphics::Direct3D11::ID3D11Texture2D;

/// A Windows Graphics Capture frame backed by a native D3D11 texture.
///
/// This value retains a COM reference to the frame texture, so clones keep the texture alive
/// independently of the capture callback that produced it. `size` is in device pixels.
/// `display_time` is the native capture timestamp, not a GPUI presentation deadline.
#[derive(Clone)]
pub struct WindowsScreenCaptureFrame {
    texture: Arc<ID3D11Texture2D>,
    size: Size<DevicePixels>,
    display_time: u64,
}

impl WindowsScreenCaptureFrame {
    #[cfg(feature = "screen-capture")]
    pub(crate) fn new(
        texture: ID3D11Texture2D,
        size: Size<DevicePixels>,
        display_time: u64,
    ) -> Self {
        Self {
            texture: Arc::new(texture),
            size,
            display_time,
        }
    }

    /// Borrows the native texture containing this frame.
    pub fn texture(&self) -> &ID3D11Texture2D {
        &self.texture
    }

    /// Returns the frame dimensions in device pixels.
    pub fn size(&self) -> Size<DevicePixels> {
        self.size
    }

    /// Returns the capture timestamp in 100-nanosecond units.
    pub fn display_time(&self) -> u64 {
        self.display_time
    }
}

impl std::fmt::Debug for WindowsScreenCaptureFrame {
    fn fmt(&self, formatter: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        formatter
            .debug_struct("WindowsScreenCaptureFrame")
            .field("size", &self.size)
            .field("display_time", &self.display_time)
            .finish_non_exhaustive()
    }
}
