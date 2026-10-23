use wgpu::util::DeviceExt;
fn read(device: &wgpu::Device, buffer: &wgpu::Buffer) -> Vec<u8> {
    let (send, recv) = std::sync::mpsc::channel();
    buffer
        .slice(..)
        .map_async(wgpu::MapMode::Read, move |result| {
            send.send(result).unwrap()
        });
    device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    recv.recv().unwrap().unwrap();
    let bytes = buffer.slice(..).get_mapped_range().unwrap().to_vec();
    buffer.unmap();
    bytes
}
fn words(values: &[u32]) -> Vec<u8> {
    values.iter().flat_map(|v| v.to_ne_bytes()).collect()
}
fn main() {
    let mut desc = wgpu::InstanceDescriptor::new_without_display_handle();
    desc.backends = wgpu::Backends::VULKAN;
    desc.flags = wgpu::InstanceFlags::VALIDATION | wgpu::InstanceFlags::VALIDATION_INDIRECT_CALL;
    let instance = wgpu::Instance::new(desc);
    let adapter =
        pollster::block_on(instance.request_adapter(&wgpu::RequestAdapterOptions::default()))
            .unwrap();
    println!("adapter={:?}", adapter.get_info());
    let (device, queue) = pollster::block_on(adapter.request_device(&wgpu::DeviceDescriptor {
        trace: wgpu::Trace::Directory(std::path::PathBuf::from(std::env::args().nth(1).unwrap())),
        ..Default::default()
    }))
    .unwrap();
    if std::env::args().nth(2).as_deref() == Some("lost") {
        let callbacks = std::sync::Arc::new(std::sync::atomic::AtomicUsize::new(0));
        let called = callbacks.clone();
        let reentrant = device.clone();
        device.set_device_lost_callback(move |reason, message| {
            assert_eq!(reason, wgpu::DeviceLostReason::Unknown);
            assert_eq!(message, "Indirect validation setup failed");
            called.fetch_add(1, std::sync::atomic::Ordering::SeqCst);
            let _ = reentrant.create_buffer(&wgpu::BufferDescriptor {
                label: None,
                size: 16,
                usage: wgpu::BufferUsages::INDIRECT,
                mapped_at_creation: false,
            });
            // Reacquiring callback registration must not deadlock.
            reentrant.set_device_lost_callback(|_, _| {});
        });
        let scope = device.push_error_scope(wgpu::ErrorFilter::Validation);
        for _ in 0..2 {
            let _ = device.create_buffer(&wgpu::BufferDescriptor {
                label: None,
                size: 16,
                usage: wgpu::BufferUsages::INDIRECT,
                mapped_at_creation: false,
            });
        }
        assert_eq!(callbacks.load(std::sync::atomic::Ordering::SeqCst), 1);
        assert!(pollster::block_on(scope.pop()).is_none());
        println!("poll after lost: {:?}", device.poll(wgpu::PollType::Poll));
        println!("public WGPU device-lost callback fired once, reentered buffer creation and callback registration; validation scope empty");
        return;
    }
    let output = device.create_buffer(&wgpu::BufferDescriptor {
        label: None,
        size: 4,
        usage: wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_SRC,
        mapped_at_creation: false,
    });
    let readback = device.create_buffer(&wgpu::BufferDescriptor {
        label: None,
        size: 256,
        usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
        mapped_at_creation: false,
    });
    let module = device.create_shader_module(wgpu::ShaderModuleDescriptor { label: None, source: wgpu::ShaderSource::Wgsl("@group(0) @binding(0) var<storage, read_write> output: atomic<u32>; @compute @workgroup_size(1) fn main() { atomicAdd(&output, 1u); }".into()) });
    let pipeline = device.create_compute_pipeline(&wgpu::ComputePipelineDescriptor {
        label: None,
        layout: None,
        module: &module,
        entry_point: Some("main"),
        compilation_options: Default::default(),
        cache: None,
    });
    let group = device.create_bind_group(&wgpu::BindGroupDescriptor {
        label: None,
        layout: &pipeline.get_bind_group_layout(0),
        entries: &[wgpu::BindGroupEntry {
            binding: 0,
            resource: output.as_entire_binding(),
        }],
    });
    if std::env::args().nth(2).as_deref() == Some("direct-only") {
        let mut encoder = device.create_command_encoder(&Default::default());
        {
            let mut pass = encoder.begin_compute_pass(&Default::default());
            pass.set_pipeline(&pipeline);
            pass.set_bind_group(0, &group, &[]);
            pass.dispatch_workgroups(1, 1, 1);
        }
        encoder.copy_buffer_to_buffer(&output, 0, &readback, 0, 4);
        queue.submit([encoder.finish()]);
        let bytes = read(&device, &readback);
        assert_eq!(u32::from_ne_bytes(bytes[..4].try_into().unwrap()), 1);
        println!("direct-only dispatch readback=1");
        return;
    }
    // The application pipeline and its layout exist before the first INDIRECT buffer.
    let args = device.create_buffer_init(&wgpu::util::BufferInitDescriptor {
        label: None,
        contents: &words(&[
            3,
            1,
            1,
            device.limits().max_compute_workgroups_per_dimension + 1,
            1,
            1,
        ]),
        usage: wgpu::BufferUsages::INDIRECT,
    });
    let mut encoder = device.create_command_encoder(&Default::default());
    {
        let mut pass = encoder.begin_compute_pass(&Default::default());
        pass.set_pipeline(&pipeline);
        pass.set_bind_group(0, &group, &[]);
        pass.dispatch_workgroups(1, 1, 1);
        pass.dispatch_workgroups_indirect(&args, 0);
        pass.dispatch_workgroups_indirect(&args, 12);
    }
    encoder.copy_buffer_to_buffer(&output, 0, &readback, 0, 4);
    queue.submit([encoder.finish()]);
    let bytes = read(&device, &readback);
    assert_eq!(u32::from_ne_bytes(bytes[..4].try_into().unwrap()), 4);
    println!("direct dispatch + valid indirect + rejected oversized indirect: output=4");
    let shader = device.create_shader_module(wgpu::ShaderModuleDescriptor { label: None, source: wgpu::ShaderSource::Wgsl("@vertex fn vs(@builtin(vertex_index) index: u32) -> @builtin(position) vec4<f32> { let positions = array(vec2(-1.0,-1.0),vec2(3.0,-1.0),vec2(-1.0,3.0)); return vec4(positions[index],0.0,1.0); } @fragment fn fs() -> @location(0) vec4<f32> { return vec4(1.0,0.0,0.0,1.0); }".into()) });
    let pipeline = device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
        label: None,
        layout: None,
        vertex: wgpu::VertexState {
            module: &shader,
            entry_point: Some("vs"),
            compilation_options: Default::default(),
            buffers: &[],
        },
        fragment: Some(wgpu::FragmentState {
            module: &shader,
            entry_point: Some("fs"),
            compilation_options: Default::default(),
            targets: &[Some(wgpu::ColorTargetState {
                format: wgpu::TextureFormat::Rgba8Unorm,
                blend: None,
                write_mask: wgpu::ColorWrites::ALL,
            })],
        }),
        primitive: Default::default(),
        depth_stencil: None,
        multisample: Default::default(),
        multiview_mask: None,
        cache: None,
    });
    let draw = device.create_buffer_init(&wgpu::util::BufferInitDescriptor {
        label: None,
        contents: &words(&[3, 1, 0, 0, 3, 1, 0, 1]),
        usage: wgpu::BufferUsages::INDIRECT,
    });
    for mode in ["direct", "indirect", "rejected_first_instance"] {
        let texture = device.create_texture(&wgpu::TextureDescriptor {
            label: None,
            size: wgpu::Extent3d {
                width: 1,
                height: 1,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: wgpu::TextureFormat::Rgba8Unorm,
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
            view_formats: &[],
        });
        let view = texture.create_view(&Default::default());
        let mut encoder = device.create_command_encoder(&Default::default());
        {
            let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                label: None,
                color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                    view: &view,
                    depth_slice: None,
                    resolve_target: None,
                    ops: wgpu::Operations {
                        load: wgpu::LoadOp::Clear(wgpu::Color::BLACK),
                        store: wgpu::StoreOp::Store,
                    },
                })],
                ..Default::default()
            });
            pass.set_pipeline(&pipeline);
            if mode == "direct" {
                pass.draw(0..3, 0..1);
            } else {
                pass.draw_indirect(&draw, if mode == "indirect" { 0 } else { 16 });
            }
        }
        encoder.copy_texture_to_buffer(
            wgpu::TexelCopyTextureInfo {
                texture: &texture,
                mip_level: 0,
                origin: wgpu::Origin3d::ZERO,
                aspect: wgpu::TextureAspect::All,
            },
            wgpu::TexelCopyBufferInfo {
                buffer: &readback,
                layout: wgpu::TexelCopyBufferLayout {
                    offset: 0,
                    bytes_per_row: Some(256),
                    rows_per_image: None,
                },
            },
            wgpu::Extent3d {
                width: 1,
                height: 1,
                depth_or_array_layers: 1,
            },
        );
        queue.submit([encoder.finish()]);
        let bytes = read(&device, &readback);
        assert_eq!(
            &bytes[..4],
            if mode == "rejected_first_instance" {
                &[0, 0, 0, 255]
            } else {
                &[255, 0, 0, 255]
            }
        );
        println!("render {mode}: {:?}", &bytes[..4]);
    }
}
