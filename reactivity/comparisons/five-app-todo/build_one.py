#!/usr/bin/env python3
"""Build one adapter under the host operation lock and write a sealed receipt."""
import argparse
import fcntl
import json
import os
from pathlib import Path
import signal
import shutil
import subprocess
import time
import todo_core as core


def main():
    p=argparse.ArgumentParser(description=__doc__)
    for name in ("source","binary","lease","receipt","log","command-json"):p.add_argument("--"+name,required=True,type=Path)
    p.add_argument("--timeout",type=float,default=2700)
    p.add_argument("--compiler-version-json",type=Path)
    p.add_argument("--disk-floor-gib",type=float,default=8)
    args=p.parse_args()
    command=json.loads(args.command_json.read_text())
    if not isinstance(command,list) or not command or not all(isinstance(v,str) for v in command):p.error("command-json must contain an argv array")
    args.lease.parent.mkdir(parents=True,exist_ok=True);args.log.parent.mkdir(parents=True,exist_ok=True);args.receipt.parent.mkdir(parents=True,exist_ok=True)
    with args.lease.open("a+") as lease:
        fcntl.flock(lease,fcntl.LOCK_SH|fcntl.LOCK_NB)
        before=core.source_fingerprint(args.source)
        previous_binary=None
        if args.binary.exists():
            previous_binary={"sha256":core.file_sha256(args.binary),"bytes":args.binary.stat().st_size}
            quarantined=args.log.with_name(args.log.name+".previous-binary")
            if quarantined.exists():raise RuntimeError("previous binary quarantine already exists; use a fresh build log/receipt path")
            args.binary.replace(quarantined)
            previous_binary["preserved_path"]=str(quarantined)
        started=time.monotonic_ns();timed_out=False
        with args.log.open("wb") as log:
            child=subprocess.Popen(command,cwd=args.source,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
            failure=None;deadline=time.monotonic()+args.timeout
            while child.poll() is None:
                if shutil.disk_usage(args.source).free<args.disk_floor_gib*1024**3:failure="host disk floor breached";break
                if time.monotonic()>deadline:timed_out=True;failure="build timeout";break
                time.sleep(0.5)
            if failure:
                os.killpg(child.pid,signal.SIGTERM)
                try:child.wait(timeout=10)
                except subprocess.TimeoutExpired:os.killpg(child.pid,signal.SIGKILL);child.wait()
            returncode=child.returncode
        after=core.source_fingerprint(args.source)
        receipt={"previous_binary":previous_binary,"command":command,"source_path":str(args.source),"source_before":before,"source_after":after,"source_unchanged":before==after,"binary":str(args.binary),"binary_sha256":core.file_sha256(args.binary) if args.binary.is_file() else None,"binary_bytes":args.binary.stat().st_size if args.binary.is_file() else None,"exit_code":returncode,"timed_out":timed_out,"failure":failure,"elapsed_seconds":(time.monotonic_ns()-started)/1e9,"log":str(args.log),"log_sha256":core.file_sha256(args.log),"environment":{key:os.environ.get(key) for key in ("CARGO_BUILD_JOBS","CARGO_TARGET_DIR","CARGO_INCREMENTAL","CARGO_PROFILE_RELEASE_DEBUG","CARGO_PROFILE_RELEASE_LTO","CARGO_PROFILE_RELEASE_CODEGEN_UNITS","CARGO_PROFILE_DIST_DEBUG","CARGO_PROFILE_DIST_LTO","RUSTFLAGS","RUSTUP_TOOLCHAIN","GOCACHE","GOMODCACHE","GOMAXPROCS","ZIG_GLOBAL_CACHE_DIR","ZIG_LOCAL_CACHE_DIR")}}
        if args.compiler_version_json:receipt["compiler_versions"]=json.loads(args.compiler_version_json.read_text())
        receipt["successful"]=failure is None and returncode==0 and before==after and receipt["binary_sha256"] is not None
        args.receipt.write_text(json.dumps(receipt,indent=2)+"\n")
        return 0 if receipt["successful"] else 1


if __name__=="__main__":raise SystemExit(main())
