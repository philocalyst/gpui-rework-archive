//! Combined compressed-directory rendering, audited decoding and deferred fences.
//! Staging writes are ordered; no host-coherent shared-memory claim.
use serde_json::{Value, json};
use std::{
    collections::BTreeMap,
    fs,
    path::{Path, PathBuf},
};
fn words(v: &Value) -> Vec<u32> {
    v.as_array()
        .unwrap()
        .iter()
        .map(|x| x.as_u64().unwrap().try_into().unwrap())
        .collect()
}
fn bytes(v: &[u32]) -> Vec<u8> {
    v.iter().flat_map(|x| x.to_le_bytes()).collect()
}
fn buffer(device: &wgpu::Device, size: u64, usage: wgpu::BufferUsages) -> wgpu::Buffer {
    device.create_buffer(&wgpu::BufferDescriptor {
        label: None,
        size: size.max(4),
        usage,
        mapped_at_creation: false,
    })
}
struct Pending {
    command: Option<wgpu::CommandBuffer>,
    readback: wgpu::Buffer,
    expected: Vec<u8>,
    expected_pixels: Vec<u8>,
    audit_bytes: u64,
    submitted: bool,
}
fn finish(
    id: u64,
    device: &wgpu::Device,
    pending: &mut BTreeMap<u64, Pending>,
    out: &Path,
) -> Value {
    let frame = pending.remove(&id).expect("only live fence may finish");
    assert!(frame.submitted);
    let (tx, rx) = std::sync::mpsc::channel();
    frame
        .readback
        .map_async(wgpu::MapMode::Read, .., move |r| tx.send(r).unwrap());
    device.poll(wgpu::PollType::wait_indefinitely()).unwrap();
    rx.recv().unwrap().unwrap();
    let raw = frame.readback.get_mapped_range(..).unwrap().to_vec();
    frame.readback.unmap();
    fs::write(out.join(format!("readback-{id}.u32")), &raw).unwrap();
    let (audit, pixels) = raw.split_at(frame.audit_bytes as usize);
    let byte_errors = audit
        .iter()
        .zip(&frame.expected)
        .filter(|(a, b)| a != b)
        .count();
    let pixel_errors = pixels
        .iter()
        .zip(&frame.expected_pixels)
        .filter(|(a, b)| a != b)
        .count();
    fs::write(out.join(format!("pixels-{id}.rgba")), pixels).unwrap();
    fs::write(out.join(format!("audit-{id}.bin")), audit).unwrap();
    assert_eq!(audit.len(), frame.expected.len());
    assert_eq!(pixels.len(), frame.expected_pixels.len());
    assert_eq!(
        (byte_errors, pixel_errors),
        (0, 0),
        "decode/resource/pixels differ at fence {id}"
    );
    json!({"fence":id,"audit_bytes_checked":audit.len(),"pixel_bytes_checked":pixels.len(),"completion_waits":1,"exact":true})
}
fn main() {
    let path = PathBuf::from(std::env::args().nth(1).unwrap());
    let root = path.parent().unwrap();
    let script: Value = serde_json::from_slice(&fs::read(&path).unwrap()).unwrap();
    let output = root.join("gpu-readback");
    fs::create_dir_all(&output).unwrap();
    pollster::block_on(async {
        let mut d = wgpu::InstanceDescriptor::new_without_display_handle();
        d.backends = wgpu::Backends::VULKAN;
        let instance = wgpu::Instance::new(d);
        let adapter = instance
            .request_adapter(&wgpu::RequestAdapterOptions {
                force_fallback_adapter: true,
                ..Default::default()
            })
            .await
            .unwrap();
        let info = adapter.get_info();
        eprintln!("adapter={info:?}");
        let (device, queue) = adapter.request_device(&Default::default()).await.unwrap();
        let shader = device.create_shader_module(wgpu::ShaderModuleDescriptor {
            label: Some("combined radix display"),
            source: wgpu::ShaderSource::Wgsl(include_str!("../hot.wgsl").into()),
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
        let pl = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
            label: None,
            bind_group_layouts: &[Some(&layout)],
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
        let audit_pipeline = pipeline("audit");
        let render_pipeline = pipeline("render");
        let authority = buffer(
            &device,
            8,
            wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_DST,
        );
        let pixels = buffer(
            &device,
            16384,
            wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_SRC,
        );
        let heap = buffer(
            &device,
            script["arena_bytes"].as_u64().unwrap(),
            wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_DST,
        );
        let hot = buffer(
            &device,
            script["hot_capacity_bytes"].as_u64().unwrap_or(4),
            wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_DST,
        );
        let mut pending = BTreeMap::new();
        let mut reports = Vec::new();
        let mut peak = 0;
        let mut queued = 0;
        let mut queue_peak = 0;
        for frame in script["frames"].as_array().unwrap() {
            for fence in frame["wait_before"].as_array().unwrap() {
                reports.push(finish(
                    fence.as_u64().unwrap(),
                    &device,
                    &mut pending,
                    &output,
                ));
                queued -= 1;
            }
            let id = frame["id"].as_u64().unwrap();
            assert!(!pending.contains_key(&id));
            let mut payload = 0;
            let mut calls = 0;
            for write in frame["writes"].as_array().unwrap() {
                let data = bytes(&words(&write["words"]));
                queue.write_buffer(&heap, write["offset"].as_u64().unwrap(), &data);
                payload += data.len();
                calls += 1;
            }
            if let Some(writes) = frame["hot_writes"].as_array() {
                for write in writes {
                    let data = bytes(&words(&write["words"]));
                    queue.write_buffer(&hot, write["offset"].as_u64().unwrap(), &data);
                    payload += data.len();
                    calls += 1;
                }
            }
            queue.write_buffer(&authority, 0, &bytes(&words(&frame["authority"])));
            if frame["publication_only"].as_bool().unwrap_or(false) {
                for old in frame["submit_deferred"].as_array().unwrap() {
                    let p: &mut Pending = pending.get_mut(&old.as_u64().unwrap()).unwrap();
                    assert!(!p.submitted);
                    queue.submit(p.command.take());
                    p.submitted = true;
                    queued += 1;
                    queue_peak = queue_peak.max(queued);
                }
                reports.push(json!({"publication_only":id,"payload_bytes":payload,"authority_bytes":8,"queue_writes":calls+1}));
                continue;
            }
            let expected = fs::read(root.join(frame["expected"].as_str().unwrap())).unwrap();
            let expected_pixels = fs::read(root.join(frame["pixels"].as_str().unwrap())).unwrap();
            let args = words(&frame["args"]);
            assert_eq!(expected.len() % 4, 0);
            let params = buffer(
                &device,
                args.len() as u64 * 4,
                wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_DST,
            );
            queue.write_buffer(&params, 0, &bytes(&args));
            let result = buffer(
                &device,
                expected.len() as u64,
                wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_SRC,
            );
            let readback = buffer(
                &device,
                expected.len() as u64 + 16384,
                wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
            );
            let buffers = [&heap, &params, &authority, &pixels, &result, &hot];
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
            let mut encoder = device.create_command_encoder(&Default::default());
            {
                let mut pass = encoder.begin_compute_pass(&Default::default());
                pass.set_pipeline(&audit_pipeline);
                pass.set_bind_group(0, &group, &[]);
                pass.dispatch_workgroups((expected.len() as u32 / 4).div_ceil(64), 1, 1);
            }
            {
                let mut pass = encoder.begin_compute_pass(&Default::default());
                pass.set_pipeline(&render_pipeline);
                pass.set_bind_group(0, &group, &[]);
                pass.dispatch_workgroups(64, 1, 1);
            }
            encoder.copy_buffer_to_buffer(&result, 0, &readback, 0, expected.len() as u64);
            encoder.copy_buffer_to_buffer(&pixels, 0, &readback, expected.len() as u64, 16384);
            let mut command = Some(encoder.finish());
            let submitted = !frame["defer"].as_bool().unwrap();
            if submitted {
                queue.submit(command.take());
                queued += 1;
                queue_peak = queue_peak.max(queued);
            }
            pending.insert(
                id,
                Pending {
                    command,
                    readback,
                    audit_bytes: expected.len() as u64,
                    expected,
                    expected_pixels,
                    submitted,
                },
            );
            peak = peak.max(pending.len());
            for old in frame["submit_deferred"].as_array().unwrap() {
                let p = pending.get_mut(&old.as_u64().unwrap()).unwrap();
                assert!(!p.submitted);
                queue.submit(p.command.take());
                p.submitted = true;
                queued += 1;
                queue_peak = queue_peak.max(queued);
            }
            reports.push(json!({"frame":id,"payload_bytes":payload,"parameter_bytes":args.len()*4,"authority_bytes":8,"queue_writes":calls+2,"deferred":!submitted,"pending_frames":pending.len(),"queued_without_completion_wait":queued}));
        }
        for fence in script["end_waits"].as_array().unwrap() {
            reports.push(finish(
                fence.as_u64().unwrap(),
                &device,
                &mut pending,
                &output,
            ));
        }
        assert!(pending.is_empty());
        println!("{}",serde_json::to_string_pretty(&json!({"adapter":format!("{info:?}"),"arena_bytes":script["arena_bytes"],"peak_pending_frames":peak,"peak_queued_before_wait":queue_peak,"reports":reports,"scope":"actual directory decode, resource reads and retained pixels; restricted opaque integer renderer, staged writes; no display scanout or coherent shared memory"})).unwrap());
    });
}
