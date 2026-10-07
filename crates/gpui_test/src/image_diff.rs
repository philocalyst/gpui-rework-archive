/// Raw and visible pixel differences between two captured images.
#[derive(Clone, Debug, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct ImageDifference {
    /// Pixels with an RGBA difference or present in only one input image.
    pub changed_pixels: u64,
    /// Pixels in the comparison canvas spanning both image dimensions.
    pub total_pixels: u64,
    /// Largest absolute raw RGBA channel difference in an 8-bit channel.
    pub max_channel_error: u8,
    /// Mean absolute difference across all RGBA channels, in the range 0–255.
    pub mean_channel_error: f64,
    /// Half-open bounding rectangle containing every exact changed pixel.
    #[serde(default)]
    pub bounds: Option<PixelRegion>,
    /// Alpha-aware premultiplied-pixel difference statistics.
    #[serde(default)]
    pub visible: Option<VisibleDifference>,
    /// Whether the input dimensions differed. Inputs are compared over their union bounds.
    #[serde(default)]
    pub size_changed: bool,
}

/// Pixel rectangle containing exact image differences.
#[derive(Clone, Copy, Debug, PartialEq, Eq, serde::Serialize, serde::Deserialize)]
pub struct PixelRegion {
    /// Left edge of the region.
    pub x: u32,
    /// Top edge of the region.
    pub y: u32,
    /// Width of the half-open region.
    pub width: u32,
    /// Height of the half-open region.
    pub height: u32,
}

/// Differences after treating RGB as alpha-premultiplied for visibility.
#[derive(Clone, Debug, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct VisibleDifference {
    /// Pixels with any visible premultiplied RGB or alpha difference.
    pub changed_pixels: u64,
    /// Largest visible channel difference in the range 0–255.
    pub max_channel_error: f64,
    /// Mean visible channel difference across RGBA channels, in the range 0–255.
    pub mean_channel_error: f64,
}

/// How a comparison image marks differences.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum DiffMode {
    /// Mark every exact RGBA difference with solid red.
    Exact,
    /// Blend red in proportion to visible pixel error over the current image.
    Magnitude,
}

/// Image comparison statistics and a visualization with the dimensions of the union of inputs.
#[derive(Clone, Debug)]
pub struct ImageComparison {
    /// The selected exact-mask or magnitude heatmap visualization.
    pub image: image::RgbaImage,
    /// Exact RGBA statistics plus alpha-aware visible statistics.
    pub difference: ImageDifference,
}

/// Pixel-motion differences between two pairs of RGBA frames.
#[derive(Clone, Debug, Default, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct MotionDifference {
    /// Pixels in the comparison canvas spanning all four image dimensions.
    pub total_pixels: u64,
    /// Pixels with a visible motion or image-extent difference.
    pub changed_pixels: u64,
    /// Largest per-channel difference between signed frame deltas, in the range 0–510.
    pub max_channel_error: f64,
    /// Mean difference across premultiplied RGBA and image-presence deltas.
    pub mean_channel_error: f64,
    /// Half-open bounding rectangle containing every changed pixel.
    pub bounds: Option<PixelRegion>,
}

/// Pixel-motion statistics paired with a transition-difference visualization.
#[derive(Clone, Debug)]
pub struct TransitionComparison {
    /// The exact transition mask or magnitude heatmap over the current frame.
    pub image: image::RgbaImage,
    /// Visible motion and frame-extent difference statistics.
    pub difference: MotionDifference,
}

mod images;
mod motion;
pub use images::compare_images;
pub use motion::{compare_transition_images, compare_transitions};

fn transition_dimensions(frames: [&image::RgbaImage; 4]) -> (u32, u32) {
    frames.into_iter().fold((0, 0), |(width, height), frame| {
        (width.max(frame.width()), height.max(frame.height()))
    })
}

fn premultiplied_channel(pixel: [u8; 4], channel: usize) -> i32 {
    if channel == 3 {
        i32::from(pixel[3]) * 255
    } else {
        i32::from(pixel[channel]) * i32::from(pixel[3])
    }
}

fn composite_over_checker(pixel: [u8; 4], x: u32, y: u32) -> image::Rgba<u8> {
    let checker: u8 = if (x / 8 + y / 8).is_multiple_of(2) {
        224
    } else {
        192
    };
    let alpha = u16::from(pixel[3]);
    let channel = |value: u8| {
        ((u16::from(value) * alpha + u16::from(checker) * (255 - alpha) + 127) / 255) as u8
    };
    image::Rgba([channel(pixel[0]), channel(pixel[1]), channel(pixel[2]), 255])
}

fn blend_red(context: image::Rgba<u8>, strength: f64) -> image::Rgba<u8> {
    let strength = strength.clamp(0.0, 1.0);
    let blend =
        |channel: u8| (f64::from(channel) * (1.0 - strength) + 255.0 * strength).round() as u8;
    image::Rgba([
        blend(context[0]),
        (f64::from(context[1]) * (1.0 - strength)).round() as u8,
        (f64::from(context[2]) * (1.0 - strength)).round() as u8,
        255,
    ])
}

fn mean(sum: f64, total_channels: u64) -> f64 {
    if total_channels == 0 {
        0.0
    } else {
        sum / total_channels as f64
    }
}

#[cfg(test)]
mod tests;
