fn main() {
    for iteration in 0..4 {
        let mut source = None;
        let allocation = allocation_counter::measure(|| {
            source = Some(gpui_gpu::shader::ui::WGSL_SOURCE.wgsl_source().unwrap());
        });
        let source = source.unwrap();
        println!("generation,{iteration},len={},capacity={},{allocation:?}", source.len(), source.capacity());
        if iteration == 0 { std::fs::write("/tmp/gpui-wgsl-captures/original-ui.wgsl", &source).unwrap(); }
        std::hint::black_box(&source);
    }
}
