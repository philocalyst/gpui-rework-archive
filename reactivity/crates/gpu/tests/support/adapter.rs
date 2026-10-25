// Shared setup for the unchanged pixel oracle and diagnostic examples.
// The historical vulkan-tests feature explicitly selects a fallback adapter.
pub async fn request() -> (wgpu::Instance, wgpu::Adapter) {
    let software = cfg!(feature = "vulkan-tests");
    let (backends, expected) = if software || !cfg!(any(target_os = "macos", target_os = "windows"))
    {
        (wgpu::Backends::VULKAN, wgpu::Backend::Vulkan)
    } else if cfg!(target_os = "macos") {
        (wgpu::Backends::METAL, wgpu::Backend::Metal)
    } else {
        (wgpu::Backends::DX12, wgpu::Backend::Dx12)
    };
    let mut descriptor = wgpu::InstanceDescriptor::new_without_display_handle();
    descriptor.backends = backends;
    let instance = wgpu::Instance::new(descriptor);
    let adapter = instance
        .request_adapter(&wgpu::RequestAdapterOptions {
            force_fallback_adapter: software,
            ..Default::default()
        })
        .await
        .expect("requested GPU oracle adapter must exist");
    let info = adapter.get_info();
    eprintln!("gpu-oracle,software_requested={software},adapter={info:?}");
    assert_eq!(info.backend, expected, "requested backend must be used");
    if !software {
        assert!(
            matches!(
                info.device_type,
                wgpu::DeviceType::IntegratedGpu | wgpu::DeviceType::DiscreteGpu
            ),
            "hardware oracle requires a physical GPU; select vulkan-tests explicitly for software"
        );
    }
    (instance, adapter)
}
