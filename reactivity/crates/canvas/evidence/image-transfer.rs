fn main() {
    println!("// Generated from Color's f32 byte normalization and existing transfer.\n// The exhaustive channel/alpha oracle in image.rs checks its exact f32 bits.\npub(super) const SRGB_BYTE: [u32; 256] = [");
    for i in 0..256 {
        let v = i as f32 / 255.;
        let bits = gpui_canvas::Color::srgb(v, 0., 0., 1.).unwrap().to_linear_srgb()[0].to_bits();
        print!("0x{:04x}_{:04x},", bits >> 16, bits & 65535);
        if i % 4 == 3 { println!(); }
    }
    println!("];");
}
