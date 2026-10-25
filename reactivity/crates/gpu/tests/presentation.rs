//! Public vendor admission/configuration gates, requiring no graphics instance.
use gpui_gpu::wgpu::{self, presentation::*, *};

#[test]
fn exact_surface_requirements_reject_each_unsupported_mode_before_device_work() {
    let requirements = PresentationRequirements {
        format: TextureFormat::Bgra8UnormSrgb,
        color_space: SurfaceColorSpace::Srgb,
        alpha_mode: CompositeAlphaMode::Opaque,
        present_mode: PresentMode::Fifo,
    };
    let mut caps = SurfaceCapabilities {
        formats: vec![requirements.format],
        format_capabilities: vec![SurfaceFormatCapabilities {
            format: requirements.format,
            color_spaces: SurfaceColorSpaces::SRGB,
        }],
        present_modes: vec![PresentMode::Fifo],
        ..Default::default()
    };
    assert!(requirements.validate(&caps).is_ok());
    caps.formats.clear();
    caps.format_capabilities.clear();
    assert!(matches!(
        requirements.validate(&caps),
        Err(PresentationError::Format)
    ));
    caps.formats.push(requirements.format);
    caps.format_capabilities.push(SurfaceFormatCapabilities {
        format: requirements.format,
        color_spaces: SurfaceColorSpaces::DISPLAY_P3,
    });
    assert!(matches!(
        requirements.validate(&caps),
        Err(PresentationError::ColorSpace)
    ));
    caps.format_capabilities[0].color_spaces = SurfaceColorSpaces::SRGB;
    caps.alpha_modes.clear();
    assert!(matches!(
        requirements.validate(&caps),
        Err(PresentationError::AlphaMode)
    ));
    caps.alpha_modes.push(requirements.alpha_mode);
    caps.present_modes = vec![PresentMode::Mailbox];
    assert!(matches!(
        requirements.validate(&caps),
        Err(PresentationError::PresentMode)
    ));
}

#[test]
fn an_explicit_hdr_pair_does_not_require_an_auto_sdr_format() {
    let requirements = PresentationRequirements {
        format: TextureFormat::Rgba16Float,
        color_space: SurfaceColorSpace::ExtendedSrgbLinear,
        alpha_mode: CompositeAlphaMode::Opaque,
        present_mode: PresentMode::Fifo,
    };
    let caps = SurfaceCapabilities {
        format_capabilities: vec![SurfaceFormatCapabilities {
            format: requirements.format,
            color_spaces: SurfaceColorSpaces::EXTENDED_SRGB_LINEAR,
        }],
        present_modes: vec![PresentMode::Fifo],
        ..Default::default()
    };
    assert!(requirements.validate(&caps).is_ok());
    assert!(matches!(
        PresentationRequirements {
            color_space: SurfaceColorSpace::Auto,
            ..requirements
        }
        .validate(&caps),
        Err(PresentationError::Format)
    ));
}

#[test]
fn same_hwnd_software_recovery_is_rejected_without_a_graphics_instance() {
    let handle = wgpu::rwh::Win32WindowHandle::new(std::num::NonZeroIsize::new(1).unwrap());
    assert_eq!(
        wgpu::hal::presentation::presentation_admission(handle.into()),
        PresentationAdmission::SoftwareRecoveryUnavailable
    );
}
#[cfg(target_os = "linux")]
#[test]
fn native_target_classification_retains_backend_and_lease_preparation_order() {
    let xlib = wgpu::rwh::XlibWindowHandle::new(1);
    let plan = match wgpu::hal::presentation::presentation_admission(xlib.into()) {
        PresentationAdmission::Candidate(plan) | PresentationAdmission::NoDeviceHint(plan) => plan,
        other => panic!("{other:?}"),
    };
    assert_eq!(plan.backends, wgpu::Backends::VULKAN);
    assert_eq!(plan.surface_preparation, SurfacePreparation::BeforeDevice);
    let wayland = wgpu::rwh::WaylandWindowHandle::new(std::ptr::NonNull::dangling());
    let plan = match wgpu::hal::presentation::presentation_admission(wayland.into()) {
        PresentationAdmission::Candidate(plan) | PresentationAdmission::NoDeviceHint(plan) => plan,
        other => panic!("{other:?}"),
    };
    assert_eq!(plan.backends, wgpu::Backends::VULKAN);
    assert_eq!(plan.surface_preparation, SurfacePreparation::AfterRenderer);
}
