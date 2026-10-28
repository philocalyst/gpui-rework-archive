//! Execute exact compressed-word decoding and retained rect rendering on Vulkan.
//! Portable staging writes, serialized completion; no shared-memory claim.
use serde_json::{Value, json};
use std::{fs, path::Path};
fn bytes(words: &[u32]) -> Vec<u8> {
    words.iter().flat_map(|w| w.to_le_bytes()).collect()
}
fn words(v: &Value) -> Vec<u32> {
    v.as_array()
        .unwrap()
        .iter()
        .map(|x| x.as_u64().unwrap().try_into().unwrap())
        .collect()
}
fn buffer(device: &wgpu::Device, size: u64, usage: wgpu::BufferUsages) -> wgpu::Buffer {
    device.create_buffer(&wgpu::BufferDescriptor {
        label: None,
        size: size.max(4),
        usage,
        mapped_at_creation: false,
    })
}
fn read(device: &wgpu::Device, b: &wgpu::Buffer) -> Vec<u8> {
    let (tx, rx) = std::sync::mpsc::channel();
    b.map_async(wgpu::MapMode::Read, .., move |r| tx.send(r).unwrap());
    device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    rx.recv().unwrap().unwrap();
    let result = b.get_mapped_range(..).unwrap().to_vec();
    b.unmap();
    result
}
fn main() {
    let path = std::env::args().nth(1).expect("jobs.json path");
    let jobs: Value = serde_json::from_slice(&fs::read(&path).unwrap()).unwrap();
    pollster::block_on(async {
        let mut desc = wgpu::InstanceDescriptor::new_without_display_handle();
        desc.backends = wgpu::Backends::VULKAN;
        let instance = wgpu::Instance::new(desc);
        let adapter = instance
            .request_adapter(&wgpu::RequestAdapterOptions {
                force_fallback_adapter: true,
                ..Default::default()
            })
            .await
            .unwrap();
        let info = adapter.get_info();
        eprintln!("adapter={info:?}");
        let (device, queue) = adapter
            .request_device(&wgpu::DeviceDescriptor::default())
            .await
            .unwrap();
        let shader = device.create_shader_module(wgpu::ShaderModuleDescriptor {
            label: Some("compressed display model"),
            source: wgpu::ShaderSource::Wgsl(include_str!("../consume.wgsl").into()),
        });
        // Explicit common layout keeps decode-only unused bindings compatible.
        let entries: Vec<_> = (0..4)
            .map(|i| wgpu::BindGroupLayoutEntry {
                binding: i,
                visibility: wgpu::ShaderStages::COMPUTE,
                ty: wgpu::BindingType::Buffer {
                    ty: wgpu::BufferBindingType::Storage { read_only: i < 2 },
                    has_dynamic_offset: false,
                    min_binding_size: None,
                },
                count: None,
            })
            .collect();
        let layout = device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
            label: None,
            entries: &entries,
        });
        let pl = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
            label: None,
            bind_group_layouts: &[&layout],
            immediate_size: 0,
        });
        let pipeline = |entry| {
            device.create_compute_pipeline(&wgpu::ComputePipelineDescriptor {
                label: None,
                layout: Some(&pl),
                module: &shader,
                entry_point: Some(entry),
                compilation_options: Default::default(),
                cache: None,
            })
        };
        let decode = pipeline("decode");
        let render = pipeline("render");
        let mut reports = Vec::new();
        for series in jobs.as_array().unwrap() {
            let arena_bytes = series["arena_words"].as_u64().unwrap() * 4;
            let capacity = series["slots"].as_u64().unwrap() * 48;
            let arena = buffer(
                &device,
                arena_bytes,
                wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_DST,
            );
            let descriptor = buffer(
                &device,
                64,
                wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_DST,
            );
            let pixels = buffer(
                &device,
                16384,
                wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_SRC,
            );
            let decoded = buffer(
                &device,
                capacity,
                wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_SRC,
            );
            let pixel_read = buffer(
                &device,
                16384,
                wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
            );
            let decode_read = buffer(
                &device,
                capacity,
                wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
            );
            let bindings = [&arena, &descriptor, &pixels, &decoded];
            let entries: Vec<_> = bindings
                .iter()
                .enumerate()
                .map(|(i, b)| wgpu::BindGroupEntry {
                    binding: i as u32,
                    resource: b.as_entire_binding(),
                })
                .collect();
            let group = device.create_bind_group(&wgpu::BindGroupDescriptor {
                label: None,
                layout: &layout,
                entries: &entries,
            });
            for job in series["jobs"].as_array().unwrap() {
                let mut payload_bytes = 0usize;
                let mut calls = 0;
                for write in job["writes"].as_array().unwrap() {
                    let data = bytes(&words(&write["words"]));
                    queue.write_buffer(&arena, write["offset"].as_u64().unwrap() * 4, &data);
                    payload_bytes += data.len();
                    calls += 1;
                }
                let d = words(&job["descriptor"]);
                queue.write_buffer(&descriptor, 0, &bytes(&d));
                let mut encoder = device.create_command_encoder(&Default::default());
                {
                    let mut pass = encoder.begin_compute_pass(&Default::default());
                    pass.set_bind_group(0, &group, &[]);
                    pass.set_pipeline(&decode);
                    pass.dispatch_workgroups((d[4] * 12).div_ceil(64), 1, 1);
                    pass.set_pipeline(&render);
                    pass.dispatch_workgroups(64, 1, 1);
                }
                encoder.copy_buffer_to_buffer(&pixels, 0, &pixel_read, 0, 16384);
                encoder.copy_buffer_to_buffer(&decoded, 0, &decode_read, 0, capacity);
                queue.submit([encoder.finish()]);
                let actual_pixels = read(&device, &pixel_read);
                let actual_words = read(&device, &decode_read);
                let expected_pixels = fs::read(
                    Path::new(&path)
                        .parent()
                        .unwrap()
                        .join(job["pixels"].as_str().unwrap()),
                )
                .unwrap();
                let expected_words = bytes(&words(&job["canonical"]));
                assert_eq!(
                    actual_pixels, expected_pixels,
                    "pixels {} {}",
                    series["name"], job["name"]
                );
                assert_eq!(
                    &actual_words[..expected_words.len()],
                    expected_words,
                    "decode {} {}",
                    series["name"],
                    job["name"]
                );
                reports.push(json!({"series":series["name"],"job":job["name"],"payload_bytes":payload_bytes,"descriptor_bytes":64,"queue_writes":calls+1,"submissions":1,"completion_waits":2,"gpu_arena_bytes":arena_bytes,"decode_output_bytes":capacity,"readback_bytes":capacity+16384,"pixels_exact":true,"words_exact":true}));
            }
        }
        println!(
            "{}",
            serde_json::to_string_pretty(&json!({"adapter":format!("{info:?}"),"frames":reports}))
                .unwrap()
        );
    });
}
