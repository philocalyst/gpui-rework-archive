#!/usr/bin/env python3
"""Serial, frozen-input five-app Todo campaign. No compilation is performed."""
from __future__ import annotations
import argparse
import ctypes
import ctypes.util
import datetime
import fcntl
import hashlib
import json
import os
from pathlib import Path
import signal
import statistics
import subprocess
import time
import traceback
import todo_core as core

APPS = ("gpui", "zeronsh-zgui", "zortax-zgui", "nanoui", "mygo")
MODES = ("idle", "busy", "heavy", "animation", "startup")
HISTORICAL_RESULTS_SHA256 = "bc7f5d08992cbe4a58e08ed970d8bc1785724453c93151c37aa0a6a6edb7dfa2"


def mandatory_historical_audit(path):
    if core.file_sha256(path)!=HISTORICAL_RESULTS_SHA256:
        raise RuntimeError("historical archive SHA256 differs from the immutable 2026-10-23 capture")
    rows=[json.loads(line) for line in path.read_text().splitlines() if line.strip()]
    result=core.audit_campaign(rows,3,3)
    failures={(r["mode"],r["variant"],r["repeat"]) for r in result["workload_contract_failures"]}
    expected={(mode,"gpui",repeat) for mode in ("heavy","animation") for repeat in (1,2,3)}
    if not result["capture_complete"] or result["workload_contract_pass"] or failures!=expected:
        raise RuntimeError("historical audit did not preserve the six known failing cells")
    return {"sha256":HISTORICAL_RESULTS_SHA256,"immutable_capture_complete":True,"known_failing_cells":sorted(failures),"current_performance_data_reused":False}


def canonical_model_digest(state):
    return hashlib.sha256(json.dumps(state,sort_keys=True,separators=(",",":"),ensure_ascii=False).encode()).hexdigest()


def expected_state(mode,duration):
    count=10000 if mode=="heavy" else 1000 if mode=="animation" else 0
    rows=[{"id":i,"title":f"Task {i+1:04d}","done":i%3==1} for i in range(count)]
    state={"rows":rows,"filter":"all","next_id":count,"draft":"","deleted":None}
    actions=[];deleted=None
    if mode in ("busy","heavy"):
        for slot in range(int(duration/core.BUSY_SLOT_SECONDS)):
            kind=core.BUSY_MACRO[slot%len(core.BUSY_MACRO)]
            if kind=="type":state["draft"]=f"bench-{slot//len(core.BUSY_MACRO):03d}"
            elif kind=="add":
                title=state["draft"].strip()
                if title:rows.append({"id":state["next_id"],"title":title,"done":False});state["next_id"]+=1;state["draft"]="";actions.append(kind)
            elif kind=="complete":
                if rows:rows[0]["done"]=not rows[0]["done"];actions.append(kind)
            elif kind in ("all","active","done"):state["filter"]=kind;actions.append(kind)
            elif kind=="delete":
                if rows:deleted=rows.pop(0);state["deleted"]=deleted["id"];actions.append(kind)
            elif kind=="undo" and deleted is not None:rows.insert(0,deleted);deleted=None;state["deleted"]=None;actions.append(kind)
    return state,actions


def semantic_receipts(log_path,mode,duration):
    states=[];actions=[];summary=None
    for line in Path(log_path).read_text().splitlines():
        for prefix,target in (("TODO_STATE,",states),("TODO_ACTION,",actions)):
            if line.startswith(prefix):target.append(json.loads(line[len(prefix):]))
        if line.startswith("TODO_MODEL,"):summary=json.loads(line[len("TODO_MODEL,"):])
    expected,expected_actions=expected_state(mode,duration)
    actual=states[0] if len(states)==1 else None
    observed_actions=[a.get("action") for a in actions]
    summary_actions=summary.get("actions") if summary else None
    return {"full_model_state":actual,"full_model_expected_sha256":canonical_model_digest(expected),"full_model_observed_sha256":canonical_model_digest(actual) if actual is not None else None,"full_model_matched":actual==expected,"ordered_callback_receipts":actions,"ordered_callbacks_expected":expected_actions,"ordered_callbacks_matched":observed_actions==expected_actions and summary_actions==expected_actions and [a.get("callbacks") for a in actions]==list(range(1,len(expected_actions)+1))}


def active_builds():
    names = {"cargo", "rustc", "rustc-real", "zig", "go", "compile", "link", "cc1", "cc1plus", "clang", "clang++", "gcc", "g++", "ld.lld", "nix-build"}
    found = []
    for entry in Path("/proc").iterdir():
        if not entry.name.isdigit():
            continue
        try:
            name = (entry / "comm").read_text().strip()
            if name in names:
                found.append({"pid": int(entry.name), "name": name})
        except (OSError, ValueError):
            pass
    return found


class XImage(ctypes.Structure):
    _fields_ = [("width",ctypes.c_int),("height",ctypes.c_int),("xoffset",ctypes.c_int),("format",ctypes.c_int),("data",ctypes.c_void_p),("byte_order",ctypes.c_int),("bitmap_unit",ctypes.c_int),("bitmap_bit_order",ctypes.c_int),("bitmap_pad",ctypes.c_int),("depth",ctypes.c_int),("bytes_per_line",ctypes.c_int),("bits_per_pixel",ctypes.c_int)]


class Drawable:
    """Independent X11 drawable readback, not a swapchain callback."""
    def __init__(self):
        self.x = ctypes.CDLL(os.environ.get("TODO_X11_LIBRARY") or ctypes.util.find_library("X11") or "libX11.so.6")
        self.x.XOpenDisplay.argtypes=[ctypes.c_char_p];self.x.XOpenDisplay.restype=ctypes.c_void_p
        self.x.XGetImage.argtypes=[ctypes.c_void_p,ctypes.c_ulong,ctypes.c_int,ctypes.c_int,ctypes.c_uint,ctypes.c_uint,ctypes.c_ulong,ctypes.c_int]
        self.x.XGetImage.restype=ctypes.POINTER(XImage)
        self.x.XDestroyImage.argtypes=[ctypes.POINTER(XImage)]
        self.x.XCloseDisplay.argtypes=[ctypes.c_void_p]
        self.display=self.x.XOpenDisplay(None)
        if not self.display: raise RuntimeError("no X11 display for drawable readback")
    def digest(self, window, region=(0,0,540,620)):
        x,y,w,h=region
        im=self.x.XGetImage(self.display,window,x,y,w,h,ctypes.c_ulong(-1).value,2)
        if not im: raise RuntimeError("XGetImage failed")
        try:
            n=im.contents.bytes_per_line*im.contents.height
            if n<=0 or n>16_000_000: raise RuntimeError("unexpected XImage size")
            return hashlib.sha256(ctypes.string_at(im.contents.data,n)).hexdigest()
        finally: self.x.XDestroyImage(im)
    def save(self,window,path):
        im=self.x.XGetImage(self.display,window,0,0,540,620,ctypes.c_ulong(-1).value,2)
        if not im: raise RuntimeError("screenshot XGetImage failed")
        try:
            a=im.contents
            if a.bits_per_pixel!=32 or a.byte_order!=0: raise RuntimeError("screenshot requires pinned little-endian 32bpp Xvfb format")
            raw=ctypes.string_at(a.data,a.bytes_per_line*a.height)
            rgb=bytearray()
            for y in range(a.height):
                row=raw[y*a.bytes_per_line:y*a.bytes_per_line+a.width*4]
                out=bytearray(a.width*3);out[0::3]=row[2::4];out[1::3]=row[1::4];out[2::3]=row[0::4];rgb.extend(out)
            path.parent.mkdir(parents=True,exist_ok=True)
            path.write_bytes(f"P6\n{a.width} {a.height}\n255\n".encode()+rgb)
            return {"path":str(path),"sha256":core.file_sha256(path),"distinct_rgb_bytes":len(set(rgb))}
        finally:self.x.XDestroyImage(im)
    def marker(self,window):
        im=self.x.XGetImage(self.display,window,476,18,56,28,ctypes.c_ulong(-1).value,2)
        if not im:return {"valid":False,"reason":"XGetImage marker failed"}
        try:
            a=im.contents
            if a.bits_per_pixel!=32 or a.byte_order!=0:return {"valid":False,"reason":"unexpected marker pixel format"}
            raw=ctypes.string_at(a.data,a.bytes_per_line*a.height);encoded=0
            for bit in range(32):
                x=bit%8*7+2;y=bit//8*7+2;pixel=raw[y*a.bytes_per_line+x*4:y*a.bytes_per_line+x*4+3]
                if all(v>=224 for v in pixel):encoded|=1<<bit
                elif not all(v<=31 for v in pixel):return {"valid":False,"reason":f"ambiguous marker cell {bit}","rgb":list(pixel)}
            return {"valid":encoded.bit_count()%2==0,"encoded":encoded,"revision":encoded&0x7fffffff,"parity":"even"}
        finally:self.x.XDestroyImage(im)
    def close(self):
        if self.display: self.x.XCloseDisplay(self.display);self.display=None


def fingerprint(manifest):
    return {name:{"source":core.source_fingerprint(Path(app["source"])),"binary":core.file_sha256(Path(app["binary"])),"external_assets":[{"path":str(Path(asset)),"sha256":core.file_sha256(Path(asset)),"bytes":Path(asset).stat().st_size} for asset in app.get("external_assets",[])]} for name,app in manifest["apps"].items() if "binary" in app}


def run_cell(name, app, mode, repeat, output, duration, warmup):
    draw=Drawable();pixels=[];acks=[];screenshots=[];initial_markers=[];last_capture=0
    original_action=core.busy_action;original_sample=core.proc_sample
    original_window=core.wait_window;original_close=core.send_wm_delete
    original_environment=core.comparison_environment
    def environment():
        env=original_environment();env.update(app.get("environment",{}));return env
    def window(*args,**kwargs):
        result=original_window(*args,**kwargs)
        screenshots.append(draw.save(result[0],output/"screenshots"/f"{name}-{mode}-r{repeat}-initial.ppm"))
        initial_markers.append(draw.marker(result[0]))
        return result
    def close(window):
        try:screenshots.append(draw.save(window,output/"screenshots"/f"{name}-{mode}-r{repeat}-final.ppm"))
        except Exception as error:screenshots.append({"error":repr(error)})
        return original_close(window)
    def action(window,kind,cycle,targets):
        point=targets["input" if kind=="type" else kind]
        moved=subprocess.run([core.XDOTOOL,"mousemove","--sync","--window",str(window),str(point[0]),str(point[1])],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL).returncode==0
        # Move and settle before taking the baseline: hover is not an action ack.
        time.sleep(0.030)
        if kind=="type":
            subprocess.run([core.XDOTOOL,"click","1"],check=False,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL);time.sleep(0.030)
        # Exclude the revision marker itself from the application-content ack.
        # These two filter transitions can leave the visible rows identical in
        # the empty-seeded Busy macro; their selected filter button must paint.
        unchanged_filter_rows=(mode=="busy" and ((kind=="active" and cycle%2==1) or (kind=="all" and cycle==0)))
        region=(24,82,280,42) if kind in ("type","add") else (24,500,320,38) if unchanged_filter_rows else (24,128,492,360)
        before=draw.digest(window,region);before_marker=draw.marker(window);started=time.monotonic_ns()
        if kind=="type":
            injected=moved and subprocess.run([core.XDOTOOL,"type","--clearmodifiers","--delay","1",f"bench-{cycle:03d}"],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL).returncode==0
        else:injected=moved and subprocess.run([core.XDOTOOL,"click","1"],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL).returncode==0
        deadline=time.monotonic()+0.120;after=draw.digest(window,region);after_marker=draw.marker(window)
        def revision_matches():
            return before_marker.get("valid") and after_marker.get("valid") and after_marker["revision"]==((before_marker["revision"]+(0 if kind=="type" else 1))&0x7fffffff)
        while (after==before or not revision_matches()) and time.monotonic()<deadline:
            time.sleep(0.005);after=draw.digest(window,region);after_marker=draw.marker(window)
        acks.append({"action":kind,"cycle":cycle,"injector_success":injected,"region":region,"before_sha256":before,"after_sha256":after,"drawable_changed":before!=after,"marker_before":before_marker,"marker_after":after_marker,"revision_matches_expected_action":bool(revision_matches()),"readback_elapsed_ns":time.monotonic_ns()-started})
        return injected
    def sample(pid):
        nonlocal last_capture
        result=original_sample(pid)
        now=time.monotonic_ns()
        if mode=="animation" and now-last_capture>=117_000_000:
            for child in core.ACTIVE_CHILDREN:
                if child.proc.pid==pid and child.window_id is not None:
                    pixels.append({"monotonic_ns":now,"viewport_sha256":draw.digest(child.window_id,(24,128,492,360)),"marker":draw.marker(child.window_id)});last_capture=now
        return result
    core.busy_action=action;core.proc_sample=sample;core.wait_window=window;core.send_wm_delete=close;core.comparison_environment=environment
    try:
        if mode=="startup": row=core.startup_sample(name,Path(app["binary"]),repeat,output)
        else: row=core.run_sample(name,Path(app["binary"]),mode,repeat,output,duration,warmup,trace=mode!="idle",controls=app["controls"])
        row["drawable_input_acknowledgments"]=acks
        row["screenshots"]=screenshots
        row["initial_markers"]=initial_markers
        row["adapter_environment"]=app.get("environment",{})
        row.update(semantic_receipts(row["log_path"],mode,duration))
        row["drawable_animation_samples"]=pixels
        row["drawable_unique_animation_samples"]=len({p["viewport_sha256"] for p in pixels})
        row["drawable_unique_animation_revisions"]=len({p["marker"]["revision"] for p in pixels if p["marker"].get("valid")})
        row["drawable_work_acknowledged"]=(bool(acks) and all(a["drawable_changed"] and a["revision_matches_expected_action"] for a in acks)) if mode in ("busy","heavy") else row["drawable_unique_animation_samples"]>=3 and row["drawable_unique_animation_revisions"]>=3 and all(p["marker"].get("valid") for p in pixels) if mode=="animation" else bool(initial_markers) and all(m.get("valid") and m.get("revision")==0 for m in initial_markers)
        return row
    finally:
        core.close_active_children()
        core.busy_action=original_action;core.proc_sample=original_sample;core.wait_window=original_window;core.send_wm_delete=original_close;core.comparison_environment=original_environment
        draw.close()


def accepted(row):
    return (row["mode"]=="startup" or row.get("present_observer_overflow")==0) and core._workload_contract_passes(row,row["mode"]) and row.get("drawable_work_acknowledged") is True and row.get("full_model_matched") is True and row.get("ordered_callbacks_matched") is True


def write_report(output, rows, manifest):
    lines=["# Five native Todo applications", "", "All values belong to the frozen adapters and rendering paths in manifest.json. Failed work remains raw overload evidence; it is excluded from passing medians. CPU includes software renderer workers and excludes Xvfb and the observer. 100% means one occupied logical core. Readback overhead is recorded per input action.", "", "Startup is warm page cache, external spawn to the first host drawing/submission receipt. Internal boundaries differ by backend and are recorded. No cache drop or true cold-start claim is made.", "", "| Application | Mode | Passing / captured | CPU % | Peak PSS KiB | Host interval p95 µs |", "| --- | --- | ---: | ---: | ---: | ---: |"]
    def med(rs,key,sub=None):
        vals=[(r.get(sub) or {}).get(key) if sub else r.get(key) for r in rs]
        vals=[x for x in vals if x is not None]
        return f"{statistics.median(vals):.2f}" if vals else "unavailable"
    for name in APPS:
        for mode in MODES:
            captured=[r for r in rows if r["variant"]==name and r["mode"]==mode]
            valid=[r for r in captured if accepted(r)]
            lines.append(f"| {name} | {mode} | {len(valid)} / {len(captured)} | {med(valid,'process_cpu_percent_one_core_100','process_metrics')} | {med(valid,'pss_kb_peak','process_metrics')} | {med(valid,'present_interval_p95_us')} |")
    lines.extend(["", "Hardware GPU utilization and physical display smoothness are unsupported unless separately demonstrated by hardware identity, an appropriate hardware counter and a real display. Software GL/Vulkan activity is not hardware GPU utilization.", "", "Failure and unsupported reasons:", ""])
    for r in rows:
        if not accepted(r): lines.append(f"- {r['variant']}/{r['mode']}/r{r['repeat']}: {r.get('unsupported_reason') or r.get('error') or core._cell_failure_reason(r,r['mode'])}; drawable acknowledged={r.get('drawable_work_acknowledged')}.")
    (output/"report.md").write_text("\n".join(lines)+"\n")


def fifteen_metrics(rows,sizes,manifest):
    metrics={name:{} for name in APPS}
    for name in APPS:
        valid={mode:[r for r in rows if r["variant"]==name and r["mode"]==mode and accepted(r)] for mode in MODES}
        def numeric(mode,key,sub=None):
            values=[(r.get(sub) or {}).get(key) if sub else r.get(key) for r in valid[mode]]
            values=[v for v in values if v is not None]
            return {"status":"measured" if values else "no-passing-workload", "valid_repeats":len(values),"median":statistics.median(values) if values else None,"minimum":min(values) if values else None,"maximum":max(values) if values else None}
        for mode in ("idle","busy","heavy","animation"):
            metrics[name][f"cpu-{mode}"]={**numeric(mode,"process_cpu_percent_one_core_100","process_metrics"),"unit":"percent-one-core-100"}
        for mode in ("busy","heavy","animation"):
            metrics[name][f"gpu-{mode}"]={"status":"unsupported","reason":manifest.get("hardware",{}).get("gpu_unsupported_reason","No qualified physical-GPU counter capture is available. Software driver activity is not physical GPU utilization."),"value":None}
        for mode in ("idle","heavy","animation"):
            metrics[name][f"memory-{mode}"]={**numeric(mode,"pss_kb_peak","process_metrics"),"unit":"KiB-peak-PSS","rss":numeric(mode,"rss_kb_peak","process_metrics"),"private":numeric(mode,"private_kb_peak","process_metrics")}
        for mode in ("busy","heavy","animation"):
            metrics[name][f"smoothness-{mode}"]={"status":"unsupported-physical-display","reason":"Headless host drawing/submission receipts do not measure scanout or perceived smoothness.","diagnostic_host_interval_p95_us":numeric(mode,"present_interval_p95_us"),"diagnostic_frames":numeric(mode,"present_frame_count")}
        metrics[name]["startup-work"]={**numeric("startup","warm_page_cache_exec_to_first_present_s"),"unit":"seconds-external-spawn-to-host-receipt","cache":"warm-page-cache","raw_work":[r.get("warm_page_cache_cpu_faults_to_first_present") for r in valid["startup"]]}
        metrics[name]["app-size"]={"status":"measured" if name in sizes else "unsupported","unit":"bytes","as_built_bytes":sizes.get(name,{}).get("as_built_bytes"),"stripped_copy":sizes.get(name,{}).get("stripped_copy"),"external_assets":sizes.get(name,{}).get("external_assets"),"elf_dependencies":sizes.get(name,{}).get("elf_dependencies")}
    return metrics


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest",required=True,type=Path)
    parser.add_argument("--output",required=True,type=Path)
    parser.add_argument("--lease",required=True,type=Path)
    parser.add_argument("--historical-archive",required=True,type=Path,help="immutable archived results; missing archive is a hard preflight failure")
    parser.add_argument("--repeats",type=int,default=3)
    parser.add_argument("--startup-repeats",type=int,default=3)
    parser.add_argument("--duration",type=float,default=30)
    parser.add_argument("--warmup",type=float,default=5)
    parser.add_argument("--preflight-only",action="store_true")
    parser.add_argument("--qualification",type=Path,help="reviewed visual/input qualification sealed to this campaign's binary and source hashes")
    args=parser.parse_args()
    if not args.preflight_only and (args.duration!=30 or args.warmup!=5): parser.error("registered primary campaign requires 30s duration and 5s settling; use --preflight-only for functional probes")
    if args.output.exists() and any(args.output.iterdir()): parser.error("output directory must be empty")
    manifest=json.loads(args.manifest.read_text())
    historical_audit=mandatory_historical_audit(args.historical_archive)
    if set(manifest["apps"])!=set(APPS): parser.error("manifest must declare all five applications, with a binary or explicit unsupported_reason")
    args.lease.parent.mkdir(parents=True,exist_ok=True)
    with args.lease.open("a+") as lease:
        fcntl.flock(lease,fcntl.LOCK_EX|fcntl.LOCK_NB)
        builds=active_builds()
        if builds: raise RuntimeError(f"measurement lease refused while build processes exist: {builds}")
        args.output.mkdir(parents=True,exist_ok=True)
        (args.output/"manifest.json").write_text(json.dumps(manifest,indent=2)+"\n")
        (args.output/"historical-audit.json").write_text(json.dumps(historical_audit,indent=2)+"\n")
        core.XDOTOOL=manifest.get("xdotool") or core.shutil.which("xdotool") or core.XDOTOOL
        core.BINUTILS_DIR=Path(manifest.get("binutils_dir",str(core.BINUTILS_DIR)))
        core.DBUS_LIBDIR=manifest.get("dbus_libdir",core.DBUS_LIBDIR)
        core.EXPECTED_WINDOW_TITLES.update({name:app.get("title",name) for name,app in manifest["apps"].items()})
        frozen=fingerprint(manifest)
        for name,app in manifest["apps"].items():
            if "binary" not in app:continue
            if not app.get("build_receipt"):raise RuntimeError(f"{name}: a successful source/binary build receipt is required")
            receipt=json.loads(Path(app["build_receipt"]).read_text())
            if receipt.get("successful") is not True or receipt.get("source_after")!=frozen[name]["source"] or receipt.get("binary_sha256")!=frozen[name]["binary"]:
                raise RuntimeError(f"{name}: missing/stale source/binary build receipt")
        if not args.preflight_only:
            if args.qualification is None:raise RuntimeError("primary capture requires reviewed visual/input qualification; run --preflight-only first")
            qualification=json.loads(args.qualification.read_text())
            for name,app in manifest["apps"].items():
                if "binary" not in app:continue
                q=qualification.get(name,{})
                if q.get("approved") is not True or q.get("frozen_input")!=frozen[name] or not q.get("screenshots") or q.get("input_macro_pass") is not True:
                    raise RuntimeError(f"{name}: missing/stale visual and input qualification")
            (args.output/"qualification.json").write_text(json.dumps(qualification,indent=2)+"\n")
        (args.output/"freeze.json").write_text(json.dumps(frozen,indent=2)+"\n")
        metadata={"utc":datetime.datetime.now(datetime.timezone.utc).isoformat(),"pid":os.getpid(),"lease":str(args.lease),"source_manifest_sha256":core.file_sha256(args.manifest),"runner_sha256":core.file_sha256(Path(__file__)),"core_sha256":core.file_sha256(Path(core.__file__)),"preflight_only":args.preflight_only,"hardware":manifest.get("hardware"),"cache":"warm-page-cache","clock_ticks_per_second":os.sysconf("SC_CLK_TCK"),"environment":{k:os.environ.get(k) for k in ("DISPLAY","GDK_BACKEND","VK_DRIVER_FILES","LIBGL_ALWAYS_SOFTWARE","LP_NUM_THREADS","GSK_RENDERER","NANOUI_GTK","NANOUI_RENDERER","MYGO_GPU")}}
        (args.output/"metadata.json").write_text(json.dumps(metadata,indent=2)+"\n")
        rows=[]
        modes=("idle","busy","heavy","animation","startup")
        for mode in modes:
            repeats=1 if args.preflight_only else args.startup_repeats if mode=="startup" else args.repeats
            for repeat in range(1,repeats+1):
                rotated=list(APPS[(repeat-1)%len(APPS):]+APPS[:(repeat-1)%len(APPS)])
                if repeat%2==0:rotated.reverse()
                for name in rotated:
                    app=manifest["apps"][name];base={"variant":name,"mode":mode,"repeat":repeat}
                    print(f"RUN {name} {mode} r{repeat}",flush=True)
                    before=fingerprint(manifest)
                    if "binary" not in app: row={**base,"unsupported_reason":app["unsupported_reason"]}
                    elif before!=frozen: row={**base,"error":"frozen source or binary changed"}
                    else:
                        try:
                            row=run_cell(name,app,mode,repeat,args.output,2 if args.preflight_only else args.duration,0 if args.preflight_only else args.warmup)
                            row.update(base)
                        except Exception as error:
                            row={**base,"error":repr(error),"traceback":traceback.format_exc()}
                    after=fingerprint(manifest)
                    row.update(source_and_binary_unchanged=before==after==frozen,fingerprint_before=before,fingerprint_after=after)
                    rows.append(row)
                    with (args.output/"results.jsonl").open("a") as raw:raw.write(json.dumps(row)+"\n")
        sizes={}
        for name,app in manifest["apps"].items():
            if "binary" in app:
                binary=Path(app["binary"])
                sizes[name]={"as_built_bytes":binary.stat().st_size,"sha256":core.file_sha256(binary),"stripped_copy":core.stripped_size(binary,name,args.output),"elf_dependencies":core.elf_dependencies(binary,app.get("environment",{})),"external_assets":[{"path":str(Path(asset)),"bytes":Path(asset).stat().st_size,"sha256":core.file_sha256(Path(asset))} for asset in app.get("external_assets",[])]}
        (args.output/"sizes.json").write_text(json.dumps(sizes,indent=2)+"\n")
        (args.output/"fifteen-metrics.json").write_text(json.dumps(fifteen_metrics(rows,sizes,manifest),indent=2)+"\n")
        expected=sum((1 if args.preflight_only else args.startup_repeats if mode=="startup" else args.repeats)*len(APPS) for mode in modes)
        status={"capture_complete":len(rows)==expected,"expected_cells":expected,"captured_cells":len(rows),"passing_cells":sum(accepted(r) for r in rows),"unsupported_cells":sum("unsupported_reason" in r for r in rows),"all_workload_contracts_pass":all(accepted(r) for r in rows),"historical_evidence_reused":False}
        (args.output/"campaign-status.json").write_text(json.dumps(status,indent=2)+"\n")
        write_report(args.output,rows,manifest)
        return 0 if status["capture_complete"] and status["all_workload_contracts_pass"] else 1


if __name__=="__main__":raise SystemExit(main())
