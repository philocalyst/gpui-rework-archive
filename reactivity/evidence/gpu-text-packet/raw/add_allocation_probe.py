from pathlib import Path
for suffix in ['', '-control']:
 wt=Path('/home/user/gpui-gpu-text-packet'+suffix+'-lab');gpu=wt/'reactivity/crates/gpu'
 s=(gpu/'examples/text_packet.rs').read_text()
 s=s.replace('//! Canonical text delta plus GPU preparation/submission/completion.','//! Separate caller-thread Rust allocation probe. Durations are not performance evidence.')
 s=s.replace('mod strategy;','mod strategy;\n#[path = "support/text_packet_memory.rs"]\nmod memory;',1)
 s=s.replace('        for frame in 0..70 {\n            let start = Instant::now();','''        eprintln!("LAYOUT,renderer={},retained_renderer={},stats={},canvas={},text_map_bytes={}",size_of::<Renderer>(),size_of::<RetainedRenderer>(),size_of::<gpui_gpu::Stats>(),size_of::<Canvas>(),memory::map_bytes(&renderer));
        for frame in 0..70 {
            let mut sample = None;
            let allocations = allocation_counter::measure(|| {
            let start = Instant::now();''',1)
 s=s.replace('            if frame >= 10 {\n                let s = renderer.stats();','''            sample = Some((host, complete, sparse));
            });
            let (host, complete, sparse) = sample.unwrap();
            if frame >= 10 {
                eprintln!("ALLOC,frame={},requests={},requested={},retained_delta={},peak_new={},text_map_bytes={}",frame-10,allocations.count_total,allocations.bytes_total,allocations.bytes_current,allocations.bytes_max,memory::map_bytes(&renderer));
                let s = renderer.stats();''',1)
 assert 'allocation_counter::measure' in s and 'sample = Some' in s
 (gpu/'examples/text_packet_allocations.rs').write_text(s)
 (gpu/'examples/support/text_packet_memory.rs').write_text('use gpui_gpu::RetainedRenderer;\npub fn map_bytes(renderer: &RetainedRenderer) -> usize { '+('let _ = renderer; 0' if suffix else 'renderer.text_packet_capacity_bytes()')+' }\n')
 p=gpu/'Cargo.toml';s=p.read_text().replace('[dev-dependencies]\n','[dev-dependencies]\nallocation-counter = "=0.8.1"\n',1);s+='\n[[example]]\nname = "text_packet_allocations"\nrequired-features = ["gpu-tests"]\n';p.write_text(s)
 p=wt/'reactivity/Cargo.lock';s=p.read_text();start=s.index('name = "gpui_gpu"\n');pos=s.index('dependencies = [\n',start)+len('dependencies = [\n');s=s[:pos]+' "allocation-counter",\n'+s[pos:];p.write_text(s)
