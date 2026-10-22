// These synchronous process tests exercise a standalone CLI, not a UI owner.
#![allow(clippy::disallowed_methods)]
use std::{
    fs,
    io::Write,
    path::PathBuf,
    process::{Command, Stdio},
    sync::atomic::{AtomicUsize, Ordering},
};
static NEXT: AtomicUsize = AtomicUsize::new(0);
struct Directory(PathBuf);
impl Directory {
    fn new() -> Self {
        let path = std::env::temp_dir().join(format!(
            "gpui-migrate-cli-{}-{}",
            std::process::id(),
            NEXT.fetch_add(1, Ordering::Relaxed)
        ));
        fs::create_dir(&path).unwrap();
        Self(path)
    }
    fn command(&self) -> Command {
        let mut command = Command::new(env!("CARGO_BIN_EXE_gpui"));
        command.current_dir(&self.0).arg("migrate");
        command
    }
}
impl Drop for Directory {
    fn drop(&mut self) {
        fs::remove_dir_all(&self.0).unwrap();
    }
}
const SOURCE: &str = "use gpui::{div,px,Styled};\nfn f(){ let café=\"💜\"; div().w(px(12.3)); }\n";

#[test]
fn default_is_a_git_applicable_diff_and_apply_preserves_other_bytes() {
    let directory = Directory::new();
    let path = directory.0.join("música rust.rs");
    fs::write(&path, SOURCE).unwrap();
    let output = directory.command().arg("música rust.rs").output().unwrap();
    assert!(
        output.status.success(),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    assert_eq!(fs::read_to_string(&path).unwrap(), SOURCE);
    assert!(String::from_utf8_lossy(&output.stdout).contains("12.3_f32"));
    let mut git = Command::new("git")
        .current_dir(&directory.0)
        .args(["apply", "--check", "-"])
        .stdin(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .unwrap();
    git.stdin.take().unwrap().write_all(&output.stdout).unwrap();
    let checked = git.wait_with_output().unwrap();
    assert!(
        checked.status.success(),
        "{}",
        String::from_utf8_lossy(&checked.stderr)
    );
    let applied = directory
        .command()
        .arg("--apply")
        .arg("música rust.rs")
        .output()
        .unwrap();
    assert!(applied.status.success());
    assert_eq!(
        fs::read_to_string(&path).unwrap(),
        SOURCE.replace("px(12.3)", "12.3_f32")
    );
    let twice = directory
        .command()
        .arg("--apply")
        .arg("música rust.rs")
        .output()
        .unwrap();
    assert!(twice.status.success());
    assert!(twice.stdout.is_empty());
}

#[test]
fn parse_failure_rejects_the_whole_apply_batch() {
    let directory = Directory::new();
    fs::write(directory.0.join("good.rs"), SOURCE).unwrap();
    fs::write(directory.0.join("broken.rs"), "fn broken( {").unwrap();
    let output = directory
        .command()
        .arg("--apply")
        .arg(".")
        .output()
        .unwrap();
    assert_eq!(output.status.code(), Some(2));
    assert_eq!(
        fs::read_to_string(directory.0.join("good.rs")).unwrap(),
        SOURCE
    );
    assert!(output.stdout.is_empty());
    assert!(String::from_utf8_lossy(&output.stderr).contains("parse error"));
}

#[test]
fn crlf_and_missing_terminal_newline_have_valid_diff_markers() {
    for source in [SOURCE.replace('\n', "\r\n"), SOURCE.trim_end().to_owned()] {
        let directory = Directory::new();
        fs::write(directory.0.join("input.rs"), &source).unwrap();
        let output = directory.command().arg("input.rs").output().unwrap();
        assert!(output.status.success());
        let mut git = Command::new("git")
            .current_dir(&directory.0)
            .args(["apply", "--check", "-"])
            .stdin(Stdio::piped())
            .stderr(Stdio::piped())
            .spawn()
            .unwrap();
        git.stdin.take().unwrap().write_all(&output.stdout).unwrap();
        let checked = git.wait_with_output().unwrap();
        assert!(
            checked.status.success(),
            "{}",
            String::from_utf8_lossy(&checked.stderr)
        );
    }
}

#[cfg(unix)]
#[test]
fn explicit_symlinks_are_rejected_and_file_permissions_survive_apply() {
    use std::os::unix::fs::{PermissionsExt, symlink};
    let directory = Directory::new();
    let source = directory.0.join("input.rs");
    fs::write(&source, SOURCE).unwrap();
    fs::set_permissions(&source, fs::Permissions::from_mode(0o640)).unwrap();
    symlink(&source, directory.0.join("link.rs")).unwrap();
    let output = directory
        .command()
        .arg("--apply")
        .arg("link.rs")
        .output()
        .unwrap();
    assert_eq!(output.status.code(), Some(2));
    assert_eq!(fs::read_to_string(&source).unwrap(), SOURCE);
    assert!(
        directory
            .command()
            .arg("--apply")
            .arg("input.rs")
            .output()
            .unwrap()
            .status
            .success()
    );
    assert_eq!(
        fs::metadata(source).unwrap().permissions().mode() & 0o777,
        0o640
    );
}
