//! Resident prototype endpoint. Timing includes actual staging and GPU completion.
use serde_json::{Value, json};
use std::{
    fs,
    io::{self, BufRead, Write},
    time::Instant,
};
fn bytes(v: &Value) -> Vec<u8> {
    v.as_array()
        .unwrap()
        .iter()
        .flat_map(|x| (x.as_u64().unwrap() as u32).to_le_bytes())
        .collect()
}
fn buffer(d: &wgpu::Device, size: u64, usage: wgpu::BufferUsages) -> wgpu::Buffer {
    d.create_buffer(&wgpu::BufferDescriptor {
        label: None,
        size: size.max(4),
        usage,
        mapped_at_creation: false,
    })
}
fn reply(out: &mut impl Write, v: Value) {
    serde_json::to_writer(&mut *out, &v).unwrap();
    out.write_all(b"\n").unwrap();
    out.flush().unwrap();
}
fn main() {
    pollster::block_on(run());
}
async fn run() {
    let stdin = io::stdin();
    let mut lines = stdin.lock().lines();
    let mut output = io::BufWriter::new(io::stdout().lock());
    let init: Value = serde_json::from_str(&lines.next().unwrap().unwrap()).unwrap();
    assert_eq!(init["op"], "init");
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
    let (device, queue) = adapter.request_device(&Default::default()).await.unwrap();
    let shader = device.create_shader_module(wgpu::ShaderModuleDescriptor {
        label: Some("qualified A/full traversal"),
        source: wgpu::ShaderSource::Wgsl(
            if init["hot"].as_bool().unwrap() {
                include_str!("../hot.wgsl")
            } else {
                include_str!("../radix.wgsl")
            }
            .into(),
        ),
    });
    let entries: Vec<_> = (0..6)
        .map(|i| wgpu::BindGroupLayoutEntry {
            binding: i,
            visibility: wgpu::ShaderStages::COMPUTE,
            ty: wgpu::BindingType::Buffer {
                ty: wgpu::BufferBindingType::Storage {
                    read_only: i < 3 || i == 5,
                },
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
    let pipeline_layout = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
        label: None,
        bind_group_layouts: &[Some(&layout)],
        immediate_size: 0,
    });
    let pipeline = device.create_compute_pipeline(&wgpu::ComputePipelineDescriptor {
        label: None,
        layout: Some(&pipeline_layout),
        module: &shader,
        entry_point: Some("render"),
        compilation_options: Default::default(),
        cache: None,
    });
    let storage = wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_DST;
    let heap = buffer(&device, init["arena_bytes"].as_u64().unwrap(), storage);
    let params = buffer(&device, 28, storage);
    let authority = buffer(&device, 8, storage);
    let pixels = buffer(
        &device,
        16384,
        wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_SRC,
    );
    let audit = buffer(&device, 4, wgpu::BufferUsages::STORAGE);
    let hot = buffer(&device, init["hot_bytes"].as_u64().unwrap(), storage);
    let buffers = [&heap, &params, &authority, &pixels, &audit, &hot];
    let entries: Vec<_> = buffers
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
    let readback = buffer(
        &device,
        16384,
        wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
    );
    reply(
        &mut output,
        json!({"ready":true,"adapter":format!("{info:?}"),"arena_bytes":init["arena_bytes"],"hot_bytes":init["hot_bytes"],"pixel_bytes":16384,"fixed_argument_bytes":28,"authority_bytes":8,"unused_audit_binding_bytes":4,"diagnostic_readback_bytes":16384}),
    );
    for line in lines {
        let message: Value = serde_json::from_str(&line.unwrap()).unwrap();
        match message["op"].as_str().unwrap() {
            "frame" => {
                let start = Instant::now();
                let mut upload = 0;
                let mut calls = 0;
                for (name, target) in [("writes", &heap), ("hot_writes", &hot)] {
                    for w in message[name].as_array().unwrap() {
                        let data = bytes(&w["words"]);
                        queue.write_buffer(target, w["offset"].as_u64().unwrap(), &data);
                        upload += data.len();
                        calls += 1;
                    }
                }
                let args = bytes(&message["args"]);
                assert_eq!(args.len(), 28);
                queue.write_buffer(&params, 0, &args);
                let current = bytes(&message["authority"]);
                assert_eq!(current.len(), 8);
                queue.write_buffer(&authority, 0, &current);
                upload += args.len() + current.len();
                calls += 2;
                let staged = Instant::now();
                let mut encoder = device.create_command_encoder(&Default::default());
                {
                    let mut pass = encoder.begin_compute_pass(&Default::default());
                    pass.set_pipeline(&pipeline);
                    pass.set_bind_group(0, &group, &[]);
                    pass.dispatch_workgroups(64, 1, 1);
                }
                let command = encoder.finish();
                let encoded = Instant::now();
                queue.submit([command]);
                device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
                let done = Instant::now();
                reply(
                    &mut output,
                    json!({"complete":true,"upload_bytes":upload,"queue_writes":calls,"staging_ns":staged.duration_since(start).as_nanos(),"encoding_ns":encoded.duration_since(staged).as_nanos(),"submit_completion_ns":done.duration_since(encoded).as_nanos(),"worker_ns":done.duration_since(start).as_nanos()}),
                );
            }
            "verify" => {
                let mut encoder = device.create_command_encoder(&Default::default());
                encoder.copy_buffer_to_buffer(&pixels, 0, &readback, 0, 16384);
                queue.submit([encoder.finish()]);
                let (tx, rx) = std::sync::mpsc::channel();
                readback.map_async(wgpu::MapMode::Read, .., move |r| tx.send(r).unwrap());
                device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
                rx.recv().unwrap().unwrap();
                let actual = readback.get_mapped_range(..).unwrap().to_vec();
                readback.unmap();
                let expected = fs::read(message["expected"].as_str().unwrap()).unwrap();
                assert_eq!(actual, expected);
                reply(&mut output, json!({"exact":true}));
            }
            "close" => {
                reply(&mut output, json!({"closed":true}));
                break;
            }
            _ => panic!("unknown endpoint operation"),
        }
    }
}
