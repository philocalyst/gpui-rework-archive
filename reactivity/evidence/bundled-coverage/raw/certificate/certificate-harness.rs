#![forbid(unsafe_code)]
mod text {
static PRIMARY_BYTES: [u8; 2_049_096] = *include_bytes!("/tmp/gpui-coverage-integration-root/reactivity/crates/canvas/assets/NotoSans.ttf");
static ARABIC_BYTES: [u8; 240_456] = *include_bytes!("/tmp/gpui-coverage-integration-root/reactivity/crates/canvas/assets/arabic/NotoSansArabic-Regular.ttf");
static HEBREW_BYTES: [u8; 26_900] = *include_bytes!("/tmp/gpui-coverage-integration-root/reactivity/crates/canvas/assets/hebrew/NotoSansHebrew-Regular.ttf");
#[path = "/tmp/gpui-coverage-integration-root/reactivity/crates/canvas/src/text/bundled_coverage.rs"]
mod bundled_coverage;
}
