//! Build-time extraction of native proc-macro metadata. Browser execution uses
//! the original Rust compiler metadata and statically linked macro clients;
//! native object code is never executed by the browser.
#![feature(rustc_private)]
extern crate rustc_codegen_ssa;
extern crate rustc_driver;
extern crate rustc_metadata;
extern crate rustc_span;
extern crate rustc_target;

use rustc_codegen_ssa::back::metadata::DefaultMetadataLoader;
use rustc_metadata::creader::MetadataLoader;
use rustc_target::spec::{Target, TargetTuple};
use std::{env, fs, path::Path};

fn main() {
    rustc_span::create_default_session_globals_then(extract);
}

fn extract() {
    let args: Vec<_> = env::args().collect();
    assert_eq!(args.len(), 4, "extract_metadata TARGET INPUT OUTPUT");
    let (target, _) =
        Target::search(&TargetTuple::from_tuple(&args[1]), Path::new("."), false).unwrap();
    let metadata = DefaultMetadataLoader
        .get_dylib_metadata(&target, Path::new(&args[2]))
        .unwrap();
    // Dylib sections wrap an ordinary rmeta stream with a version header and
    // little-endian u64 length. Strip only that object-section envelope.
    let header = rustc_metadata::METADATA_HEADER.len();
    assert_eq!(&metadata[..header], rustc_metadata::METADATA_HEADER);
    let start = header + 8;
    let length = u64::from_le_bytes(metadata[header..start].try_into().unwrap()) as usize;
    fs::write(&args[3], &metadata[start..start + length]).unwrap();
    let macros = rustc_metadata::locator::get_proc_macros(
        Path::new(&args[2]),
        &DefaultMetadataLoader,
        "1.101.0-nightly (5c543b0b8 2026-09-29)",
    )
    .unwrap();
    for (_, kind) in macros {
        match kind {
            rustc_metadata::ProcMacroKind::CustomDerive {
                trait_name,
                attributes,
            } => {
                println!("derive\t{trait_name}\t{}", attributes.join(","));
            }
            rustc_metadata::ProcMacroKind::Attr { name } => println!("attr\t{name}\t"),
            rustc_metadata::ProcMacroKind::Bang { name } => println!("bang\t{name}\t"),
        }
    }
}
