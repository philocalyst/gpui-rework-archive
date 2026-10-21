//! No trybuild dependency: rustc compiles actual consumer fixtures and pins the
//! relevant diagnostic. Private scope fixtures include the exact implementation.
use std::{fs, path::PathBuf, process::Command};

#[test]
fn rejected_programs_fail_for_the_intended_reason() {
    let dependencies = std::env::current_exe()
        .unwrap()
        .parent()
        .unwrap()
        .to_owned();
    let mut libraries: Vec<_> = fs::read_dir(&dependencies)
        .unwrap()
        .map(|entry| entry.unwrap().path())
        .filter(|path| {
            path.file_name()
                .unwrap()
                .to_string_lossy()
                .starts_with("libreactivity_api_lab-")
                && path.extension().is_some_and(|ext| ext == "rlib")
        })
        .collect();
    libraries.sort_by_key(|path| fs::metadata(path).unwrap().modified().unwrap());
    let library = libraries.last().expect("cargo-built library");
    let fixtures = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tests/ui");
    let output_dir = std::env::temp_dir().join(format!("reactivity-api-ui-{}", std::process::id()));
    fs::create_dir_all(&output_dir).unwrap();
    for (fixture, diagnostic) in [
        ("borrowed_text_escape.rs", "E0515"),
        ("mutate_borrowed_owner.rs", "E0502"),
        ("cursor_escape.rs", "lifetime may not live long enough"),
        ("cursor_cross_scope.rs", "E0521"),
        ("cursor_inner_to_outer.rs", "E0521"),
        ("forge_child_sequence.rs", "E0277"),
    ] {
        let output = Command::new(std::env::var_os("RUSTC").unwrap_or_else(|| "rustc".into()))
            .arg("--edition=2024")
            .arg("--emit=metadata")
            .arg("--extern")
            .arg(format!("reactivity_api_lab={}", library.display()))
            .arg("-L")
            .arg(format!("dependency={}", dependencies.display()))
            .arg("--out-dir")
            .arg(&output_dir)
            .arg(fixtures.join(fixture))
            .output()
            .unwrap();
        let stderr = String::from_utf8(output.stderr).unwrap();
        assert!(!output.status.success(), "{fixture} unexpectedly compiled");
        assert!(
            stderr.contains(diagnostic),
            "{fixture}: expected {diagnostic}\n{stderr}"
        );
    }
    fs::remove_dir_all(output_dir).unwrap();
}
