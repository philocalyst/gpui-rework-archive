"""Recreate source, linked-byte, host-cache and DHAT ledgers; never time code."""
import hashlib
import gzip
import importlib.util
import json
import shutil
import subprocess
import tempfile
from pathlib import Path

OUT = Path(__file__).resolve().parent
REPO = OUT.parents[2]
BASE = "6bbb661465"
FINAL = "0981fdccae"
TARGET = Path("/tmp/gpui-offline-shader-target")
CONTROL = Path("/tmp/gpui-offline-shader-controls")
HELPER = Path("/tmp/gpui-inventory-sol-target/release/inventory-rust")
TOKEI = Path("/nix/store/4m90mv0fyihsdrnidw8gkgmx6zvd5vqm-tokei-15.0.0/bin/tokei")
VAL = Path("/nix/store/z5hs3p3inrq3w8cv71jycz7l4y3ny5xk-spirv-tools-1.4.363.0/bin/spirv-val")


def save(name, value):
    (OUT / name).write_text(json.dumps(value, indent=2) + "\n")


def git(*args):
    return subprocess.check_output(["git", "-C", str(REPO), *args])


def digest(path):
    return {"bytes": path.stat().st_size, "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}


def source_lines():
    spec = importlib.util.spec_from_file_location("inventory", REPO / "reactivity/tools/inventory.py")
    inventory = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(inventory)
    spec = importlib.util.spec_from_file_location("core_lines", REPO / "reactivity/tools/core_lines.py")
    core = importlib.util.module_from_spec(spec)
    # core_lines imports inventory by its normal command-line name.
    import sys
    sys.modules["inventory"] = inventory
    spec.loader.exec_module(core)
    vendor = ["reactivity/vendor/wgpu/src/lib.rs", "reactivity/vendor/wgpu/src/shader_artifact.rs",
              "reactivity/vendor/wgpu-hal/src/vulkan/device.rs"]
    rows = {}
    for label, ref in (("baseline", BASE), ("final", FINAL)):
        paths = git("ls-tree", "-r", "--name-only", ref, "--", "reactivity/crates/gpu/src",
                    "reactivity/crates/gpu/build.rs", *vendor).decode().splitlines()
        sources = [(p, git("show", f"{ref}:{p}"), "Rust") for p in paths if p.endswith(".rs")]
        analysis = inventory.rust_analysis(sources, HELPER)
        per_file = {}
        with tempfile.TemporaryDirectory(prefix="offline-shader-lines-") as temporary:
            staging = Path(temporary)
            for path, data, _ in sources:
                dest = staging / path
                dest.parent.mkdir(parents=True, exist_ok=True)
                dest.write_text(core.without_tests(data.decode(), analysis[path]["test_ranges"]))
                per_file[path] = {"physical": len(data.splitlines()),
                                  "sha256": hashlib.sha256(data).hexdigest(),
                                  "unclassified": analysis[path]["unclassified"]}
            report = json.loads(subprocess.check_output(
                [str(TOKEI), "--no-ignore", "--files", "--output", "json", str(staging)]))
            for row in report["Rust"]["reports"]:
                path = Path(row["name"]).relative_to(staging).as_posix()
                per_file[path]["non_test_comment_free_code"] = row["stats"]["code"]
        rows[label] = {"ref": git("rev-parse", ref).decode().strip(), "files": per_file,
                       "gpu_src_and_build": sum(v["non_test_comment_free_code"] for p, v in per_file.items()
                                                if p.startswith("reactivity/crates/gpu/")),
                       "vendor_changed_files": sum(v["non_test_comment_free_code"] for p, v in per_file.items()
                                                   if p.startswith("reactivity/vendor/"))}
    rows["delta"] = {key: rows["final"][key] - rows["baseline"][key]
                     for key in ("gpu_src_and_build", "vendor_changed_files")}
    rows["tools"] = {"tokei": digest(TOKEI), "helper": digest(HELPER),
                     "scope": "GPU/src + GPU/build.rs; vendor authored deltas charged separately. "
                              "Known Syn test syntax/comments/blanks excluded; feature and host helper included."}
    save("source-lines.json", rows)


def host_cost():
    rows = {}
    for label in ("default", "artifact"):
        graph = json.loads(Path(f"/tmp/gpui-offline-{label}-unit-graph.json").read_text())
        messages = [json.loads(s) for s in Path(f"/tmp/gpui-offline-{label}-artifacts.jsonl").read_text().splitlines()]
        units = graph["units"]
        # run-custom-build units also have target metadata edges; they are not
        # host compiler dependencies. Start from executable compilation only.
        roots = [i for i, u in enumerate(units) if u["mode"] == "build"
                 and set(u["target"]["kind"]) & {"custom-build", "proc-macro"}]
        host = set()

        def walk(index):
            if index in host:
                return
            host.add(index)
            for dep in units[index]["dependencies"]:
                walk(dep["index"])

        for index in roots:
            walk(index)
        files = {}
        used = []
        for index in sorted(host):
            unit = units[index]
            if unit["mode"] != "build":
                continue
            matches = [m for m in messages if m["reason"] == "compiler-artifact"
                       and m["package_id"] == unit["pkg_id"]
                       and m["target"]["name"] == unit["target"]["name"]
                       and m["target"]["kind"] == unit["target"]["kind"]
                       and m["features"] == unit["features"]
                       and m["profile"]["opt_level"] == unit["profile"]["opt_level"]]
            assert len(matches) == 1, (unit, len(matches))
            for name in matches[0]["filenames"]:
                path = Path(name)
                files[str(path.relative_to(TARGET))] = digest(path)
            used.append({"package": unit["pkg_id"], "target": unit["target"]["name"],
                         "features": unit["features"], "files": matches[0]["filenames"]})
        rows[label] = {"units": used, "files": files,
                       "logical_file_bytes": sum(v["bytes"] for v in files.values())}
    before, after = rows["default"]["files"], rows["artifact"]["files"]
    rows["added_or_replaced_host_files"] = {p: v for p, v in after.items() if p not in before}
    rows["superseded_host_files"] = {p: v for p, v in before.items() if p not in after}
    rows["note"] = "Logical file sizes, including rlib/rmeta and host build executables; not physical disk/RSS. " \
                   "The feature closure includes all host ancestors, not just direct dependencies. " \
                   "Existing target artifacts and generated output are separate. No cold-build timing claim."
    save("host-cache.json", rows)


def dhat():
    rows = {}
    for path in sorted((OUT / "final/dhat").glob("*.json*")):
        data = json.loads(gzip.decompress(path.read_bytes()) if path.suffix == ".gz" else path.read_bytes())
        sums = lambda pp: {key: sum(p[key] for p in pp) for key in ("tb", "tbk", "gb", "gbk", "eb", "ebk")}
        total = sums(data["pps"])
        subsets = {}
        def constructor(fs):
            return any("gpui_gpu::renderer::GpuContext>::new" in f
                       or "gpui_gpu::renderer::Renderer>::new" in f for f in fs)
        for name, predicate in (
            ("constructor_frames", constructor),
            ("native_module", lambda fs: any("vk_common_CreateShaderModule" in f for f in fs)
             and constructor(fs)),
            ("constructor_naga", lambda fs: any("naga::" in f for f in fs)
             and constructor(fs)),
        ):
            selected = [p for p in data["pps"] if predicate([data["ftbl"][i] for i in p["fs"]])]
            subsets[name] = {"sites": len(selected), **sums(selected)}
        rows[path.name.removesuffix(".gz")] = {
            "command": data["cmd"], "whole_process": total, "subsets": subsets,
            "mesa_disk_shader_cache": "disabled" if "cache-disabled" in path.name else "inherited/uncontrolled",
            "exit_lifetime": "owners deliberately retained" if path.name.startswith("retained-") else "ordinary destructor teardown",
        }
    rows["note"] = "DHAT3.27.1 malloc/realloc heap: tb/tbk total bytes/blocks, gb/gbk live at process " \
                   "global peak, eb/ebk live at process exit. Subsets require matching stack frames, " \
                   "so truncated deep stacks can be omitted. Do not sum per-site individual maxima. " \
                   "first controls drop owners; driver-retained deliberately exits before destructors. " \
                   "Includes driver host heap, excludes GPU memory, mappings, RSS and device memory."
    save("dhat-summary.json", rows)


def artifacts():
    generated = TARGET / "release/build/gpui_gpu-5b1509640b905a8a/out"
    dest = OUT / "final/artifacts"
    dest.mkdir(exist_ok=True)
    manifest = json.loads((generated / "ui-artifacts.json").read_text())
    for a in manifest["artifacts"]:
        name = f"ui-{a['variant']}-{a['entry']}.spv"
        assert digest(generated / name) == {"bytes": a["bytes"], "sha256": a["sha256"]}
        shutil.copyfile(generated / name, dest / name)
        subprocess.run([str(VAL), "--target-env", "vulkan1.0", str(dest / name)], check=True)
    for name in ("ui-artifacts.json", "ui-artifacts.rs", "ui.wgsl"):
        shutil.copyfile(generated / name, dest / name)
    unique = {a["sha256"]: a["bytes"] for a in manifest["artifacts"]}
    names = [f"ui-{a['variant']}-{a['entry']}.spv" for a in manifest["artifacts"]]
    names += ["ui-artifacts.json", "ui-artifacts.rs", "ui.wgsl"]
    rows = {"generated": {name: digest(dest / name) for name in names},
            "eight_emitted_spv_bytes": sum(a["bytes"] for a in manifest["artifacts"]),
            "five_unique_compiled_word_arrays_bytes": sum(unique.values()),
            "generated_rust_physical_lines": len((dest / "ui-artifacts.rs").read_text().splitlines()),
            "validator": digest(VAL),
            "binaries": {str(p.relative_to(CONTROL)): digest(p) for p in sorted(CONTROL.glob("*/*"))
                         if p.is_file()}}
    save("artifact-and-linked-bytes.json", rows)


source_lines()
host_cost()
dhat()
artifacts()
