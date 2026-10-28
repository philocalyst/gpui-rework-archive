//! Admission for opportunistic GPU presentation with software recovery.
//!
//! This query performs only handle classification and filesystem metadata reads.
//! It never loads a driver, constructs an instance, or changes a native target.
use raw_window_handle::RawWindowHandle;

/// When creating a surface preserves an already visible software frame.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum SurfacePreparation {
    /// Safe native surface creation may run on a worker before device creation.
    /// The unconfigured Vulkan WSI surface does not replace the software target.
    BeforeDevice,
    /// Creating a surface can attach a visible native layer. Keep creation on
    /// the event thread until renderer preparation is complete.
    AfterRenderer,
}

/// A cheap candidate hint, not proof that an adapter can present to the target.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PresentationPlan {
    /// Only backends compatible with this software-recovery policy.
    pub backends: wgt::Backends,
    pub surface_preparation: SurfacePreparation,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum PresentationAdmission {
    Candidate(PresentationPlan),
    /// Explicit opt-in may try remote/custom ICDs despite this missing hint.
    NoDeviceHint(PresentationPlan),
    /// Flip-model presentation prevents subsequent software GDI use of this HWND.
    SoftwareRecoveryUnavailable,
    /// There is no qualified automatic presentation path for this target.
    Unknown,
}

/// Classifies a native target without constructing any graphics resources.
///
/// Win32 DX12 flip presentation cannot restore GDI on the same HWND after the
/// first successful Present1, even after destroying the swapchain. Explicit GPU
/// use remains available outside this software-recovery admission policy.
/// <https://learn.microsoft.com/en-us/windows/win32/api/dxgi/ne-dxgi-dxgi_swap_effect>
///
/// Metal retains its established late main-thread layer attachment. Its early
/// adapter discovery is still headless; this is not a target-compatibility proof.
pub fn presentation_admission(target: RawWindowHandle) -> PresentationAdmission {
    let admission = classify(target);
    #[cfg(all(target_os = "linux", vulkan))]
    if let PresentationAdmission::Candidate(plan) = admission {
        if !linux_device_hint() {
            return PresentationAdmission::NoDeviceHint(plan);
        }
    }
    admission
}

fn classify(target: RawWindowHandle) -> PresentationAdmission {
    match target {
        RawWindowHandle::Win32(_) => PresentationAdmission::SoftwareRecoveryUnavailable,
        #[cfg(all(target_vendor = "apple", metal))]
        RawWindowHandle::AppKit(_) | RawWindowHandle::UiKit(_) => {
            PresentationAdmission::Candidate(PresentationPlan {
                backends: wgt::Backends::METAL,
                surface_preparation: SurfacePreparation::AfterRenderer,
            })
        }
        #[cfg(all(target_os = "linux", vulkan))]
        RawWindowHandle::Xlib(_) | RawWindowHandle::Xcb(_) => {
            PresentationAdmission::Candidate(PresentationPlan {
                backends: wgt::Backends::VULKAN,
                surface_preparation: SurfacePreparation::BeforeDevice,
            })
        }
        #[cfg(all(target_os = "linux", vulkan))]
        RawWindowHandle::Wayland(_) => {
            // A retained target cannot currently be hidden promptly through
            // Winit's Wayland set_visible (a no-op). Keep its worker window-free
            // until renderer readiness rather than retaining a closed target.
            PresentationAdmission::Candidate(PresentationPlan {
                backends: wgt::Backends::VULKAN,
                surface_preparation: SurfacePreparation::AfterRenderer,
            })
        }
        _ => PresentationAdmission::Unknown,
    }
}

// This remains a hint: render nodes do not prove hardware or display support.
// Remote/custom ICD users may opt in explicitly. Permission errors preserve the
// previous policy of trying discovery rather than claiming no device exists.
#[cfg(all(target_os = "linux", vulkan))]
fn linux_device_hint() -> bool {
    use std::{io::ErrorKind, path::Path};
    for node in ["/dev/nvidiactl", "/dev/dxg"] {
        match Path::new(node).metadata() {
            Ok(_) => return true,
            Err(error) if error.kind() == ErrorKind::NotFound => {}
            Err(_) => return true,
        }
    }
    match std::fs::read_dir("/dev/dri") {
        Ok(entries) => entries.into_iter().any(|entry| match entry {
            Ok(entry) => entry
                .file_name()
                .to_str()
                .is_none_or(|n| n.starts_with("renderD")),
            Err(_) => true,
        }),
        Err(error) => error.kind() != ErrorKind::NotFound,
    }
}
