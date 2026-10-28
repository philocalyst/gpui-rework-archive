#!/usr/bin/env python3
"""Export every tracked/untracked-not-ignored control source, without Git internals."""

import argparse, hashlib, json, os, shutil, subprocess
from pathlib import Path

p = argparse.ArgumentParser()
p.add_argument("checkout", type=Path)
p.add_argument("output", type=Path)
p.add_argument("manifest", type=Path)
a = p.parse_args()
a.output.mkdir(exist_ok=False)


def git(*args):
    return subprocess.check_output(
        ["git", "-c", f"safe.directory={a.checkout}", "-C", str(a.checkout), *args]
    )


pin = git("rev-parse", "HEAD").decode().strip()
raw = git("cat-file", "commit", pin)
assert (
    hashlib.sha1(b"commit " + str(len(raw)).encode() + b"\0" + raw).hexdigest() == pin
)
tracked = set(n for n in git("ls-files", "-z", "--cached").split(b"\0") if n)
names = tracked | set(
    n for n in git("ls-files", "-z", "--others", "--exclude-standard").split(b"\0") if n
)
records = {}
assert not [
    e for e in git("ls-files", "--stage", "-z").split(b"\0") if e.startswith(b"160000")
]
for encoded in sorted(names):
    name = os.fsdecode(encoded)
    source = a.checkout / name
    target = a.output / name
    target.parent.mkdir(parents=True, exist_ok=True)
    assert ".git" not in Path(name).parts
    if source.is_symlink():
        target.symlink_to(os.readlink(source))
        data = os.readlink(source).encode()
    else:
        shutil.copy2(source, target)
        data = source.read_bytes()
    records[name] = {
        "sha256": hashlib.sha256(data).hexdigest(),
        "bytes": len(data),
        "mode": oct(source.lstat().st_mode & 0o777),
        "symlink": source.is_symlink(),
        "tracked": encoded in tracked,
    }
actual = {
    str(f.relative_to(a.output))
    for f in a.output.rglob("*")
    if f.is_file() or f.is_symlink()
}
assert actual == set(records)
for name, rec in records.items():
    file = a.output / name
    data = os.readlink(file).encode() if file.is_symlink() else file.read_bytes()
    assert (
        hashlib.sha256(data).hexdigest() == rec["sha256"]
        and oct(file.lstat().st_mode & 0o777) == rec["mode"]
    )
upstream = {}
for item in git("ls-tree", "-rz", "HEAD").split(b"\0"):
    if not item:
        continue
    header, name = item.split(b"\t", 1)
    mode, kind, oid = header.decode().split()
    assert kind == "blob"
    upstream[name.decode()] = {"mode": mode, "git_blob": oid}
changed = set(git("diff", "--name-only", "HEAD").decode().splitlines())
assert changed == {
    "crates/zgui-desktop/examples/benchmark_todo.rs",
    "crates/zgui-desktop/src/application.rs",
    "crates/zgui-desktop/src/lib.rs",
    "crates/zgui-desktop/src/todo_bench.rs",
}
assert set(records) == set(upstream) | changed
for name, rec in upstream.items():
    if name in changed:
        continue
    file = a.checkout / name
    data = os.readlink(file).encode() if file.is_symlink() else file.read_bytes()
    assert (
        hashlib.sha1(b"blob " + str(len(data)).encode() + b"\0" + data).hexdigest()
        == rec["git_blob"]
    )
a.manifest.with_suffix(".patch").write_bytes(git("diff", "HEAD", "--binary"))
a.manifest.write_text(
    json.dumps(
        {
            "pin": pin,
            "raw_commit": raw.decode(),
            "base_tree": git("rev-parse", pin + "^{tree}").decode().strip(),
            "status": git("status", "--porcelain=v1").decode(),
            "diff_HEAD_sha256": hashlib.sha256(
                git("diff", "HEAD", "--binary")
            ).hexdigest(),
            "final_files": records,
            "upstream_files": upstream,
            "allowed_adapter_paths": sorted(changed),
            "all_other_files_equal_upstream_blobs": True,
            "coverage": "all Git cached paths plus every untracked-not-ignored source; exact set and every byte/mode verified, no .git or build cache",
            "exact_set_verified": True,
        },
        indent=2,
    )
    + "\n"
)
print(
    json.dumps(
        {
            "files": len(records),
            "bytes": sum(r["bytes"] for r in records.values()),
            "pin": pin,
        }
    )
)
