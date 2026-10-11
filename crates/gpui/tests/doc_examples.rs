//! Checks that apply to every code example in GPUI's documentation.

use std::{fs, path::Path};

/// Rustdoc compiles doctests into one binary, and actions register themselves
/// by name when that binary starts. If two examples declared the same action,
/// every example that creates an app would panic. Examples that declare actions
/// must therefore be compiled on their own, with `standalone_crate`.
#[test]
fn examples_that_declare_actions_are_standalone() {
    let root = Path::new(env!("CARGO_MANIFEST_DIR"));
    let mut offenders = Vec::new();
    for dir in ["src", "docs"] {
        visit(&root.join(dir), &mut |path, text| {
            for (line, info, body) in code_blocks(path, text) {
                let declares_action = body.contains("actions!(")
                    || body.contains("register_action!(")
                    || (body.contains("derive(") && body.contains("Action"));
                let is_rust = info
                    .split(',')
                    .all(|attr| matches!(attr.trim(), "" | "rust" | "no_run" | "should_panic"));
                if declares_action && is_rust {
                    offenders.push(format!("{}:{line}", path.display()));
                }
            }
        });
    }
    assert!(
        offenders.is_empty(),
        "these examples declare actions; mark them ```standalone_crate:\n{}",
        offenders.join("\n")
    );
}

fn visit(dir: &Path, f: &mut impl FnMut(&Path, &str)) {
    for entry in fs::read_dir(dir).unwrap() {
        let path = entry.unwrap().path();
        if path.is_dir() {
            visit(&path, f);
        } else if matches!(path.extension().and_then(|e| e.to_str()), Some("rs" | "md")) {
            f(&path, &fs::read_to_string(&path).unwrap());
        }
    }
}

/// Returns the line, info string and body of each fenced code block in a
/// Markdown file or in the doc comments of a Rust file.
fn code_blocks(path: &Path, text: &str) -> Vec<(usize, String, String)> {
    let is_rust = path.extension().is_some_and(|e| e == "rs");
    let mut blocks = Vec::new();
    let mut open: Option<(usize, String, String)> = None;
    for (index, line) in text.lines().enumerate() {
        let line = if is_rust {
            let trimmed = line.trim_start();
            match trimmed.strip_prefix("///").or_else(|| trimmed.strip_prefix("//!")) {
                Some(doc) => doc.strip_prefix(' ').unwrap_or(doc),
                None => continue,
            }
        } else {
            line
        };
        match (&mut open, line.trim_start().strip_prefix("```")) {
            (None, Some(info)) => open = Some((index + 1, info.trim().to_string(), String::new())),
            (Some(_), Some(_)) => blocks.push(open.take().unwrap()),
            (Some((_, _, body)), None) => {
                body.push_str(line);
                body.push('\n');
            }
            (None, None) => {}
        }
    }
    blocks
}
