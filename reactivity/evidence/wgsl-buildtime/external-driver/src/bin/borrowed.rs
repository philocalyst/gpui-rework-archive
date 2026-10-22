use std::borrow::Cow;
const SOURCE: &str = include_str!("/tmp/gpui-wgsl-artifact-target/release/build/gpui_gpu-10d85200ae4a7e05/out/ui.wgsl");
fn main() {
    for iteration in 0..4 {
        let allocation = allocation_counter::measure(|| {
            std::hint::black_box(Cow::Borrowed(SOURCE));
        });
        assert_eq!(allocation.count_total, 0);
        assert_eq!(allocation.bytes_total, 0);
        println!("borrowed,{iteration},len={},{allocation:?}", SOURCE.len());
    }
}
