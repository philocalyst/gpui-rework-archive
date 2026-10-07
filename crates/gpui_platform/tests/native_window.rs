#[cfg(not(target_family = "wasm"))]
fn main() {
    if std::env::var_os("GPUI_RUN_PLATFORM_TESTS").as_deref() != Some(std::ffi::OsStr::new("1")) {
        return;
    }
    gpui_ce_platform::testing::run_window_checks(|report| {
        let json = serde_json::to_string_pretty(&report).expect("serialize native window report");
        if let Some(path) = std::env::var_os("GPUI_PLATFORM_TEST_OUTPUT") {
            std::fs::write(path, &json).expect("write native window report");
        } else {
            println!("{json}");
        }
        if report.status != gpui::WindowCheckStatus::Passed {
            std::process::exit(1);
        }
    });
}

#[cfg(target_family = "wasm")]
fn main() {}
