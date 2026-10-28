#[inline(never)]
fn checksum(text: &str) -> usize {
    let mut sum = 0_usize;
    let result = gpui_coverage_events_spike::visit(text, |index, character| {
        sum = sum.wrapping_add(index).wrapping_add(character as usize);
        Ok::<(), std::convert::Infallible>(())
    });
    result.unwrap_or_else(|never| match never {});
    sum
}

fn main() {
    let input = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "ASCII é אבג العربية हिन्दी 👩‍💻\t tail".to_owned());
    println!("{}", checksum(std::hint::black_box(&input)));
}
