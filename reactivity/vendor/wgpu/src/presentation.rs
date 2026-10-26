//! Native presentation admission and target proof before device creation.
//!
//! This optional path leaves explicit GPU initialization unchanged. Admission is
//! a cheap hint; only the subsequent target-bound adapter request proves support.
use crate::*;
use core::fmt;
use raw_window_handle::{HandleError, HasWindowHandle};

pub use hal::presentation::{PresentationAdmission, PresentationPlan, SurfacePreparation};

/// A handle-only query: no instance, driver, adapter, surface, or device is made.
pub fn automatic_surface_admission(
    window: &impl HasWindowHandle,
) -> Result<PresentationAdmission, HandleError> {
    let admission = hal::presentation::presentation_admission(window.window_handle()?.as_raw());
    let restrict = |mut plan: PresentationPlan| {
        plan.backends &= Instance::enabled_backend_features();
        (!plan.backends.is_empty()).then_some(plan)
    };
    Ok(match admission {
        PresentationAdmission::Candidate(plan) => restrict(plan)
            .map(PresentationAdmission::Candidate)
            .unwrap_or(PresentationAdmission::Unknown),
        PresentationAdmission::NoDeviceHint(plan) => restrict(plan)
            .map(PresentationAdmission::NoDeviceHint)
            .unwrap_or(PresentationAdmission::Unknown),
        other => other,
    })
}

/// Exact intended configuration, checked before requesting a device or pipeline.
#[derive(Clone, Copy, Debug)]
pub struct PresentationRequirements {
    /// Intended surface texture format.
    pub format: TextureFormat,
    /// Explicit color space advertised for that format, or automatic selection.
    pub color_space: SurfaceColorSpace,
    /// Intended compositor alpha mode.
    pub alpha_mode: CompositeAlphaMode,
    /// Concrete intended presentation mode, such as FIFO.
    pub present_mode: PresentMode,
}
impl PresentationRequirements {
    /// Checks concrete supported modes, not an automatic-mode fallback promise.
    pub fn validate(&self, capabilities: &SurfaceCapabilities) -> Result<(), PresentationError> {
        let advertised = if self.color_space == SurfaceColorSpace::Auto {
            capabilities.formats.contains(&self.format)
        } else {
            capabilities
                .format_capabilities
                .iter()
                .any(|entry| entry.format == self.format)
        };
        if !advertised {
            return Err(PresentationError::Format);
        }
        if let Some(space) = self.color_space.to_color_spaces() {
            if !capabilities.color_spaces(self.format).contains(space) {
                return Err(PresentationError::ColorSpace);
            }
        }
        if !capabilities.alpha_modes.contains(&self.alpha_mode) {
            return Err(PresentationError::AlphaMode);
        }
        if !capabilities.present_modes.contains(&self.present_mode) {
            return Err(PresentationError::PresentMode);
        }
        Ok(())
    }
}

/// A target-bound adapter or configuration could not be proved.
#[derive(Debug)]
pub enum PresentationError {
    /// No adapter meets the target-compatible request.
    Adapter(RequestAdapterError),
    /// The intended format is not advertised for this color-space selection.
    Format,
    /// The format does not advertise the intended color space.
    ColorSpace,
    /// The intended compositor alpha mode is unsupported.
    AlphaMode,
    /// The concrete intended presentation mode is unsupported.
    PresentMode,
}
impl fmt::Display for PresentationError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Adapter(error) => error.fmt(f),
            Self::Format => f.write_str("prepared surface format unsupported"),
            Self::ColorSpace => f.write_str("prepared surface color space unsupported"),
            Self::AlphaMode => f.write_str("prepared surface alpha mode unsupported"),
            Self::PresentMode => f.write_str("prepared surface present mode unsupported"),
        }
    }
}
impl core::error::Error for PresentationError {}

/// Target and its proven adapter stay together. No device has been requested,
/// no swapchain configured, and no texture acquired by this operation.
///
/// This proof concerns this surface/adapter cohort, not a persistent promise
/// across target recreation or device loss. Configure still validates the
/// current size; final presentation remains the caller's admission authority.
#[derive(Debug)]
pub struct PresentationAdapter<'window> {
    surface: Surface<'window>,
    adapter: Adapter,
}
impl<'window> PresentationAdapter<'window> {
    /// Transfers the still-unconfigured target and its proven adapter together.
    pub fn into_parts(self) -> (Surface<'window>, Adapter) {
        (self.surface, self.adapter)
    }
}

impl Instance {
    /// Requests an adapter compatible with this exact owned native target, then
    /// validates its intended presentation modes before expensive device work.
    /// `options.compatible_surface` is replaced by the owned `surface`.
    pub async fn request_presentation_adapter<'window>(
        &self,
        surface: Surface<'window>,
        options: &RequestAdapterOptions<'_, '_>,
        requirements: PresentationRequirements,
    ) -> Result<PresentationAdapter<'window>, PresentationError> {
        let adapter = self
            .request_adapter(&RequestAdapterOptions {
                compatible_surface: Some(&surface),
                power_preference: options.power_preference,
                force_fallback_adapter: options.force_fallback_adapter,
                apply_limit_buckets: options.apply_limit_buckets,
            })
            .await
            .map_err(PresentationError::Adapter)?;
        requirements.validate(&surface.get_capabilities(&adapter))?;
        Ok(PresentationAdapter { surface, adapter })
    }
}
