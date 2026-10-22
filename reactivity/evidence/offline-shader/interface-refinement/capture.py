"""Charge the host-proof refinement without overwriting frozen bea evidence."""
import importlib.util
import json
import sys
from pathlib import Path

out = Path(__file__).resolve().parent
sys.dont_write_bytecode = True
prior = out.parent
spec = importlib.util.spec_from_file_location("capture", prior / "capture-evidence.py")
capture = importlib.util.module_from_spec(spec)
spec.loader.exec_module(capture)
capture.OUT = out
capture.BASE = "bea848dbe4"
capture.FINAL = "db73d4f1cc"
capture.source_lines()
capture.host_cost({"artifact": "/tmp/gpui-offline-interface-artifacts.jsonl"})
old = json.loads((prior / "artifact-and-linked-bytes.json").read_text())
generated = capture.TARGET / "release/build/gpui_gpu-5b1509640b905a8a/out"
artifacts = {name: capture.digest(generated / name) for name in old["generated"]}
assert artifacts == old["generated"], "Proof refinement must preserve every artifact/interface byte"
binary = capture.CONTROL / "interface-final/first"
first = capture.digest(binary)
assert first == old["binaries"]["bea848dbe4/first"], "Target executable must remain identical"
capture.save("identities.json", {
    "source": capture.git("rev-parse", capture.FINAL).decode().strip(),
    "all_eight_spv_and_generated_rust_manifest_wgsl_identical_to_bea": artifacts,
    "linked_first_fixture_identical_to_bea": first,
    "host_build_executable": capture.digest(capture.CONTROL / "interface-final/host-build-script"),
    "prior_host_build_executable": capture.digest(capture.CONTROL / "bea848dbe4/host-build-script"),
})
