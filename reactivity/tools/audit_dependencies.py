#!/usr/bin/env python3
"""Audit resolved normal/build dependencies against primary crates.io metadata.

Run after Cargo.lock updates. All workspace features and target cfgs are kept;
this is a dependency graph audit, not proof that every platform was executed.
"""
import argparse
import concurrent.futures
import datetime
import hashlib
import json
import pathlib
import subprocess
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parents[1]
REPO = ROOT.parent


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git(*args):
    return subprocess.check_output(["git", "-c", f"safe.directory={REPO}", "-C", str(REPO), *args], text=True)


def version_key(version):
    # Build metadata is not a prerelease or part of SemVer ordering.
    return tuple(map(int, version.split("+", 1)[0].split("-", 1)[0].split(".")))


def release_key(version):
    core, separator, prerelease = version.split("+", 1)[0].partition("-")
    identifiers = tuple((0, int(part)) if part.isdigit() else (1, part)
                        for part in prerelease.split(".")) if separator else ()
    return version_key(core), not separator, identifiers


def comparison(resolved, evidence):
    if "error" in evidence:
        return "lookup_error"
    stable = evidence.get("latest_stable")
    target = stable or evidence["latest_release"]
    suffix = "stable" if stable else "prerelease_only"
    return ("behind_latest_" if release_key(resolved) < release_key(target) else
            "at_latest_" if release_key(resolved) == release_key(target) else
            "ahead_of_latest_") + suffix


def latest(name):
    url = "https://crates.io/api/v1/crates/" + name
    request = urllib.request.Request(url, headers={"User-Agent": "gpui-dependency-audit/1.0"})
    try:
        with urllib.request.urlopen(request, timeout=60) as response:
            data = json.load(response)
        releases = [v for v in data["versions"] if not v["yanked"]]
        stable = [v for v in releases if "-" not in v["num"].split("+", 1)[0]]
        newest = max(releases, key=lambda v: release_key(v["num"]))
        selected = max(stable, key=lambda v: version_key(v["num"])) if stable else newest
        return name, {"latest_stable": selected["num"] if stable else None,
                      "latest_release": newest["num"], "registry_newest_version": data["crate"]["newest_version"],
                      "rust_version": selected.get("rust_version"), "checksum": selected["checksum"], "url": url}
    except Exception as error:
        return name, {"error": str(error), "url": url}


def normal_edges(node):
    return [dep for dep in node["deps"] if any(k["kind"] in (None, "build") for k in dep["dep_kinds"])]


def audit(metadata, cache, cache_path):
    packages = {p["id"]: p for p in metadata["packages"]}
    nodes = {n["id"]: n for n in metadata["resolve"]["nodes"]}
    active, pending = set(), list(metadata["workspace_members"])
    while pending:
        key = pending.pop()
        if key not in active:
            active.add(key)
            pending.extend(dep["pkg"] for dep in normal_edges(nodes[key]))
    registry = {packages[key]["name"] for key in active if (packages[key].get("source") or "").startswith("registry+")}
    vendored = [packages[key] for key in active if packages[key].get("source") is None
                and "/vendor/" in packages[key]["manifest_path"]]
    lookup_names = registry | {package["name"] for package in vendored}
    missing = sorted(name for name in lookup_names if name not in cache or "error" in cache[name])
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor:
        cache.update(executor.map(latest, missing))
    incoming = {key: [] for key in active}
    for parent in sorted(active):
        package = packages[parent]
        for dep in normal_edges(nodes[parent]):
            if dep["pkg"] not in active:
                continue
            child = packages[dep["pkg"]]
            declarations = [{"requirement": d["req"], "kind": d["kind"], "target": d.get("target"),
                             "optional": d["optional"]} for d in package["dependencies"]
                            if d["name"] == child["name"] and d["kind"] in (None, "build")]
            incoming[dep["pkg"]].append({"package": package["name"], "version": package["version"],
                                         "workspace_direct": parent in metadata["workspace_members"],
                                         "declarations": declarations})
    rows = []
    for key in sorted(active, key=lambda k: (packages[k]["name"], version_key(packages[k]["version"]))):
        p = packages[key]
        if p["name"] not in registry or not (p.get("source") or "").startswith("registry+"):
            continue
        evidence = cache[p["name"]]
        rows.append({"name": p["name"], "resolved": p["version"], "resolved_rust_version": p.get("rust_version"),
                     "comparison": comparison(p["version"], evidence), "latest": evidence, "parents": incoming[key]})
    local = {}
    for key in sorted(active):
        p = packages[key]
        if p.get("source") is None:
            manifest = pathlib.Path(p["manifest_path"])
            local[str(manifest.relative_to(REPO))] = sha256(manifest)
    locks = []
    for path in git("ls-files").splitlines():
        if path.startswith("reactivity/") and path.endswith("Cargo.lock"):
            disk = REPO / path
            scope = ("active workspace" if disk == ROOT / "Cargo.lock" else
                     "independent analysis tool workspace; outside production graph" if "/tools/" in path else
                     "independent application workspace; outside UI-core graph" if "/ports/" in path else
                     "upstream development lock; root path patch uses workspace lock" if "/vendor/" in path else
                     "frozen evidence/benchmark lock; outside production graph")
            locks.append({"path": path, "sha256": sha256(disk), "scope": scope})
    return {"captured_at_utc": datetime.datetime.now(datetime.UTC).isoformat(),
            "source_head": git("rev-parse", "HEAD").strip(),
            "working_status_porcelain": git("status", "--porcelain=v1").splitlines(),
            "workspace_lock_sha256": sha256(ROOT / "Cargo.lock"), "local_manifests_sha256": local,
            "registry_cache_sha256": sha256(cache_path) if cache_path else None,
            "method": "Cargo metadata --locked --all-features; workspace normal/build closure, all target cfgs retained; dev-only edges excluded; primary crates.io non-yanked stable SemVer maximum",
            "qualification": "Latest direct crates do not make all constrained transitive majors latest. Parent requirements and target cfgs are listed. Other lock scopes are disclosed separately, without rewriting historical benchmark pins.",
            "commands": ["cargo metadata --locked --all-features --format-version 1 --manifest-path reactivity/Cargo.toml",
                         "python3 reactivity/tools/audit_dependencies.py --metadata /tmp/metadata.json --cache /tmp/registry-cache.json"],
            "active_packages": len(active), "registry_names": len(registry), "other_lock_scopes": locks,
            "vendored_packages": [{"name": p["name"], "resolved": p["version"], "resolved_rust_version": p.get("rust_version"),
                                   "manifest": str(pathlib.Path(p["manifest_path"]).relative_to(REPO)),
                                   "comparison": comparison(p["version"], cache[p["name"]]),
                                   "latest": cache[p["name"]]} for p in sorted(vendored, key=lambda p: p["name"])],
            "audit_tool_sha256": sha256(pathlib.Path(__file__)),
            "packages": rows}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--metadata", type=pathlib.Path, help="saved Cargo metadata; otherwise collect current locked metadata")
    parser.add_argument("--cache", type=pathlib.Path, help="reuse frozen primary registry evidence; missing names still fetched")
    parser.add_argument("--output", type=pathlib.Path)
    args = parser.parse_args()
    metadata = json.loads(args.metadata.read_text()) if args.metadata else json.loads(subprocess.check_output(
        ["cargo", "metadata", "--locked", "--all-features", "--format-version", "1", "--manifest-path", str(ROOT / "Cargo.toml")], text=True))
    cache = json.loads(args.cache.read_text()) if args.cache else {}
    result = audit(metadata, cache, args.cache)
    result["cargo_metadata_sha256"] = (sha256(args.metadata) if args.metadata else
                                        hashlib.sha256(json.dumps(metadata, sort_keys=True).encode()).hexdigest())
    result["metadata_input"] = str(args.metadata) if args.metadata else "collected from current locked workspace"
    result["registry_evidence"] = "supplied frozen cache plus live lookups for missing names" if args.cache else "live primary registry lookups"
    output = json.dumps(result, indent=2) + "\n"
    if args.output:
        args.output.write_text(output)
    else:
        print(output, end="")
    if any(row["comparison"] == "lookup_error" for row in result["packages"] + result["vendored_packages"]):
        raise SystemExit("one or more registry lookups failed; see the emitted audit")


if __name__ == "__main__":
    main()
