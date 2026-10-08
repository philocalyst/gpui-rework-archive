#!/usr/bin/env python3
"""Exercise upstream CTFE, patched Miri execution and the driver's Ctrl-C flag."""
import argparse
import os
from pathlib import Path
import queue
import re
import signal
import subprocess
import sys
import tempfile
import threading
import time

ROOT = Path(__file__).resolve().parents[2]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--driver", type=Path, default=ROOT / ("vendor/miri/target/release/miri" + (".exe" if os.name == "nt" else "")))
    parser.add_argument("--sysroot", type=Path, default=ROOT / "target/codepen-sysroot/mir-2")
    args = parser.parse_args()
    toolchain = Path(subprocess.check_output(
        ["rustup", "run", "nightly-2026-09-30", "rustc", "--print", "sysroot"], text=True).strip())
    env = os.environ.copy()
    env["PATH"] = os.pathsep.join([str(toolchain / "lib"), env["PATH"]])
    if os.name != "nt":
        variable = "DYLD_LIBRARY_PATH" if sys.platform == "darwin" else "LD_LIBRARY_PATH"
        env[variable] = os.pathsep.join([str(toolchain / "lib"), env.get(variable, "")])
    with tempfile.TemporaryDirectory(prefix="codepen-native-interpreter-") as temporary:
        source = Path(temporary) / "main.rs"
        source.write_text('''const N: usize = {
    let mut n = 0; let mut i = 0;
    while i < 8 { n += i; i += 1; }
    n
};
fn main() {
    let values: Vec<_> = (0..8).collect();
    assert_eq!(values.iter().sum::<usize>(), N);
    println!("PASS installed CTFE with patched Miri execution");
}
''')
        command = [str(args.driver.resolve()), "--edition=2024", "--sysroot", str(args.sysroot.resolve()),
                   str(source), "-Zmiri-disable-isolation", "-Zmiri-disable-validation",
                   "-Zmiri-disable-stacked-borrows", "-Zmiri-disable-data-race-detector",
                   "-Zmiri-disable-alignment-check"]
        result = subprocess.run(command, env=env, text=True, capture_output=True, timeout=30)
        assert result.returncode == 0, result.stdout + result.stderr
        assert "PASS installed CTFE with patched Miri execution" in result.stdout
        print(result.stdout.strip())
        if os.name == "nt":
            print("SKIP Unix SIGINT regression on Windows")
            return
        source.write_text('''fn main() {
    println!("READY");
    loop {
        std::hint::black_box(123usize);
    }
}
''')
        child = subprocess.Popen(command, env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        ready = queue.Queue()
        reader = threading.Thread(target=lambda: ready.put(child.stdout.readline()), daemon=True)
        reader.start()
        try:
            assert ready.get(timeout=30).strip() == "READY", "Miri did not enter the guest program"
            reader.join(timeout=1)
            # Leave the stdout shim before interrupting the actual infinite loop.
            time.sleep(0.15)
            started = time.monotonic()
            child.send_signal(signal.SIGINT)
            stdout, stderr = child.communicate(timeout=5)
            assert child.returncode != 0, stdout + stderr
            assert "interpretation was interrupted" in stderr, stderr
            # The terminator uses the loop span; the call uses its own span.
            assert re.search(r"main\.rs:(?:3|4):", stderr), "The interruption must occur in the running loop: " + stderr
            print(f"PASS running Miri loop observes driver Ctrl-C in {time.monotonic() - started:.3f}s")
        finally:
            if child.poll() is None:
                child.kill()
                child.communicate(timeout=5)


if __name__ == "__main__":
    main()
