use gpui::{DevicePixels, Size};
pub use gpui_render::font::{FontRasterizationSettings, SubpixelOrder};

pub struct WgpuSurfaceConfig {
    pub size: Size<DevicePixels>,
    pub transparent: bool,
    /// Preferred presentation mode, falling back to FIFO when unsupported.
    pub preferred_present_mode: Option<wgpu::PresentMode>,
}

pub(super) struct RenderingParameters {
    pub(super) path_sample_count: u32,
    pub(super) font_rasterization: FontRasterizationSettings,
}

impl RenderingParameters {
    pub(super) fn new(adapter: &wgpu::Adapter, surface_format: wgpu::TextureFormat) -> Self {
        let format_features = adapter.get_texture_format_features(surface_format);
        let path_sample_count = [4, 2, 1]
            .into_iter()
            .find(|&sample_count| format_features.flags.sample_count_supported(sample_count))
            .unwrap_or(1);
        Self {
            path_sample_count,
            font_rasterization: FontRasterizationSettings::new(
                environment_f32("ZED_FONTS_GAMMA", 1.8),
                environment_f32("ZED_FONTS_GRAYSCALE_ENHANCED_CONTRAST", 1.0),
                environment_f32("ZED_FONTS_SUBPIXEL_ENHANCED_CONTRAST", 0.5),
                SubpixelOrder::RedGreenBlue,
            ),
        }
    }
}

fn environment_f32(name: &str, default: f32) -> f32 {
    std::env::var(name)
        .ok()
        .and_then(|value| value.parse::<f32>().ok())
        .filter(|value| value.is_finite())
        .unwrap_or(default)
}
