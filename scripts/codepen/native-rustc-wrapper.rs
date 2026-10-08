//! Keep the private interpreter alias confined to the Miri library.
use std::{env, ffi::OsString, process::{Command, exit}};

fn main() {
    let mut args = env::args_os().skip(1);
    let compiler = args.next().expect("Cargo must supply the compiler");
    let args: Vec<OsString> = args.collect();
    let mut command = Command::new(compiler);
    command.args(&args);
    let is_miri = args.windows(2).any(|pair| pair[0] == "--crate-name" && pair[1] == "miri");
    if is_miri {
        // The binary also needs this search path to resolve the library's
        // separately identified const-eval dependency.
        command.arg("-L").arg(env::var_os("CODEPEN_INTERPRETER_SEARCH").unwrap());
        let is_library = args.windows(2).any(|pair| pair[0] == "--crate-type" && (pair[1] == "lib" || pair[1] == "rlib"));
        if is_library {
            command.arg("--extern").arg(env::var_os("CODEPEN_INTERPRETER_EXTERN").unwrap());
            command.arg("--extern").arg(env::var_os("CODEPEN_DRIVER_CONST_EVAL_EXTERN").unwrap());
            command.args(["--cfg", "codepen_native_interpreter", "--check-cfg", "cfg(codepen_native_interpreter)"]);
        }
    }
    exit(command.status().expect("could not run the pinned compiler").code().unwrap_or(1));
}
