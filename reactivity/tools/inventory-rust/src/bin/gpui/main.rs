//! Standalone review-first migration assistant; no UI runtime dependency.
mod migrate;
#[cfg(test)]
mod tests;
use std::{
    collections::BTreeSet,
    env, fs,
    io::{self, Write},
    path::{Path, PathBuf},
};

const HELP: &str = "gpui migrate [--apply] [--] [paths...]\n\nDefaults to a reviewable unified diff over Rust files under the current directory.\n--apply writes only preflighted local edits; manual diagnostics are never fixed.\nAssumes the pinned legacy GPUI API and the clean-room target API described in README.\nDoes not migrate state, entities, contexts, Render, input controls or whole applications.\nDirectories skip target, vendor, node_modules and .git; symlinks are rejected.\n";

fn files(path: &Path, out: &mut BTreeSet<PathBuf>) -> Result<(), String> {
    let metadata = fs::symlink_metadata(path).map_err(|e| format!("{}: {e}", path.display()))?;
    if metadata.file_type().is_symlink() {
        return Err(format!("{}: symlink rejected", path.display()));
    }
    if metadata.is_dir() {
        for entry in fs::read_dir(path).map_err(|e| e.to_string())? {
            let entry = entry.map_err(|e| e.to_string())?;
            if matches!(
                entry.file_name().to_str(),
                Some("target" | "vendor" | "node_modules" | ".git")
            ) {
                continue;
            }
            if entry.file_type().map_err(|e| e.to_string())?.is_symlink() {
                continue;
            }
            if entry.path().is_dir() || entry.path().extension().is_some_and(|e| e == "rs") {
                files(&entry.path(), out)?;
            }
        }
    } else if metadata.is_file() && path.extension().is_some_and(|e| e == "rs") {
        out.insert(fs::canonicalize(path).map_err(|e| e.to_string())?);
    } else {
        return Err(format!(
            "{}: expected a Rust file or directory",
            path.display()
        ));
    }
    Ok(())
}

fn diff(path: &Path, old: &str, new: &str, out: &mut impl Write) -> io::Result<()> {
    let a: Vec<_> = old.split_inclusive('\n').collect();
    let b: Vec<_> = new.split_inclusive('\n').collect();
    let prefix = a.iter().zip(&b).take_while(|(a, b)| a == b).count();
    let suffix = a[prefix..]
        .iter()
        .rev()
        .zip(b[prefix..].iter().rev())
        .take_while(|(a, b)| a == b)
        .count();
    let start = prefix.saturating_sub(3);
    let end_a = (a.len() - suffix + 3).min(a.len());
    let end_b = (b.len() - suffix + 3).min(b.len());
    let label = path.to_string_lossy();
    writeln!(
        out,
        "--- {}\n+++ {}",
        serde_json::to_string(&format!("a/{label}")).unwrap(),
        serde_json::to_string(&format!("b/{label}")).unwrap()
    )?;
    writeln!(
        out,
        "@@ -{},{} +{},{} @@",
        start + 1,
        end_a - start,
        start + 1,
        end_b - start
    )?;
    for line in &a[start..prefix] {
        write!(out, " {line}")?;
    }
    for (sign, lines) in [
        ('-', &a[prefix..a.len() - suffix]),
        ('+', &b[prefix..b.len() - suffix]),
    ] {
        for line in lines {
            write!(out, "{sign}{line}")?;
            if !line.ends_with('\n') {
                writeln!(out, "\n\\ No newline at end of file")?;
            }
        }
    }
    for line in &a[a.len() - suffix..end_a] {
        write!(out, " {line}")?;
        if !line.ends_with('\n') {
            writeln!(out, "\n\\ No newline at end of file")?;
        }
    }
    Ok(())
}

fn write_file(path: &Path, old: &str, new: &str) -> Result<(), String> {
    let metadata = fs::symlink_metadata(path).map_err(|e| e.to_string())?;
    if !metadata.is_file() || fs::read(path).map_err(|e| e.to_string())? != old.as_bytes() {
        return Err(format!(
            "{}: changed since preflight; refused",
            path.display()
        ));
    }
    let temporary = path.with_file_name(format!(
        ".gpui-migrate-{}-{}",
        std::process::id(),
        path.file_name().unwrap().to_string_lossy()
    ));
    let mut file = fs::OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(&temporary)
        .map_err(|e| format!("{}: {e}", temporary.display()))?;
    let result = (|| -> io::Result<()> {
        file.write_all(new.as_bytes())?;
        file.set_permissions(metadata.permissions())?;
        file.sync_all()?;
        if fs::read(path)? != old.as_bytes() {
            return Err(io::Error::other("source changed during write; refused"));
        }
        fs::rename(&temporary, path)
    })();
    if result.is_err() {
        let _ = fs::remove_file(&temporary);
    }
    result.map_err(|e| format!("{}: {e}", path.display()))
}

fn run() -> Result<(), String> {
    let mut args = env::args_os().skip(1);
    let Some(command) = args.next() else {
        print!("{HELP}");
        return Ok(());
    };
    if command == "--help" || command == "-h" {
        print!("{HELP}");
        return Ok(());
    }
    if command != "migrate" {
        return Err("expected `gpui migrate`; use --help".into());
    }
    let mut apply = false;
    let mut literal_paths = false;
    let mut paths = Vec::new();
    for arg in args {
        if !literal_paths && arg == "--" {
            literal_paths = true;
        } else if !literal_paths && arg == "--apply" {
            apply = true;
        } else if !literal_paths && (arg == "--help" || arg == "-h") {
            print!("{HELP}");
            return Ok(());
        } else if !literal_paths && arg.to_string_lossy().starts_with('-') {
            return Err(format!("unknown option {}", arg.to_string_lossy()));
        } else {
            paths.push(PathBuf::from(arg));
        }
    }
    if paths.is_empty() {
        paths.push(PathBuf::from("."));
    }
    let mut found = BTreeSet::new();
    for path in paths {
        files(&path, &mut found)?;
    }
    let cwd = env::current_dir().map_err(|e| e.to_string())?;
    let mut changes = Vec::new();
    let mut failed = false;
    for path in found {
        let metadata = fs::metadata(&path).map_err(|e| e.to_string())?;
        if metadata.len() > 4 * 1024 * 1024 {
            return Err(format!("{}: exceeds 4 MiB parser limit", path.display()));
        }
        let old = fs::read_to_string(&path).map_err(|e| format!("{}: {e}", path.display()))?;
        let plan = match migrate::plan(&old) {
            Ok(p) => p,
            Err(e) => {
                eprintln!("{}:{e}", path.display());
                failed = true;
                continue;
            }
        };
        for diagnostic in &plan.diagnostics {
            eprintln!(
                "{}:{}:{}: manual: {}",
                path.display(),
                diagnostic.at.line,
                diagnostic.at.column + 1,
                diagnostic.message
            );
        }
        if !plan.edits.is_empty() {
            let new = migrate::apply(&old, &plan.edits);
            changes.push((path, old, new));
        }
    }
    if failed {
        return Err("parse/preflight errors; no files written".into());
    }
    let stdout = io::stdout();
    let mut out = stdout.lock();
    for (path, old, new) in &changes {
        diff(path.strip_prefix(&cwd).unwrap_or(path), old, new, &mut out)
            .map_err(|e| e.to_string())?;
    }
    out.flush().map_err(|e| e.to_string())?;
    if apply {
        // Whole-batch byte preflight precedes the first write. Per-file atomic
        // replacement is not a cross-file transaction or an editor file lock.
        for (path, old, _) in &changes {
            if fs::read(path).map_err(|e| e.to_string())? != old.as_bytes() {
                return Err(format!(
                    "{}: changed since preflight; no writes",
                    path.display()
                ));
            }
        }
        for (path, old, new) in &changes {
            write_file(path, old, new)?;
            eprintln!("applied {}", path.display());
        }
    }
    eprintln!(
        "{} file(s) with local edits; remaining diagnostics require review{}",
        changes.len(),
        if apply { "" } else { "; use --apply to write" }
    );
    Ok(())
}
fn main() {
    if let Err(error) = run() {
        eprintln!("gpui migrate: {error}");
        std::process::exit(2);
    }
}
