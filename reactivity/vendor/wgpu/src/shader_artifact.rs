//! Experimental admission for offline shader artifacts, not a validity certificate.
use crate::*;

/// Revision-two artifact policy. Obtain it from the exact target Device.
/// The artifact must independently prove its interface, guards and validity.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Profile(u8);
impl Profile {
    /// Contract revision: one entry per module, SPIR-V 1.0, local indices restricted, loops and integer
    /// division checked, no coordinate-space adjustment or binding arrays.
    pub const fn revision(self) -> u32 {
        2
    }
    /// Variant bits: bit 1 requires buffer guards; bit 0 requires image guards.
    /// A clear bit means the actual device code generator relies on enabled
    /// hardware robustness for that category. This is not adapter support.
    pub const fn variant(self) -> usize {
        self.0 as usize
    }
}
impl Adapter {
    /// Optional feature for this artifact family, or empty on other backends.
    /// This is only a request hint; re-admit against the resulting Device.
    pub fn shader_artifact_features(&self) -> Features {
        #[cfg(vulkan)]
        if self.features().contains(Features::PASSTHROUGH_SHADERS) {
            // SAFETY: only borrow the backend guard to discriminate the API;
            // no raw resource is accessed, changed, submitted or destroyed.
            if unsafe { self.as_hal::<hal::api::Vulkan>() }.is_some() {
                return Features::PASSTHROUGH_SHADERS;
            }
        }
        Features::empty()
    }
}
impl Device {
    /// Admit only a compatible backend, enabled feature and effective codegen
    /// policy. Does not validate caller-supplied artifacts or their interface.
    pub fn shader_artifact_profile(&self) -> Option<Profile> {
        #[cfg(vulkan)]
        if self.features().contains(Features::PASSTHROUGH_SHADERS) {
            // SAFETY: the guard only borrows immutable codegen options; no raw
            // resource is accessed, submitted, changed or destroyed.
            let device = unsafe { self.as_hal::<hal::api::Vulkan>() }?;
            let [buffer, image] = device.shader_artifact_checks()?;
            return Some(Profile((u8::from(buffer) << 1) | u8::from(image)));
        }
        None
    }
}
