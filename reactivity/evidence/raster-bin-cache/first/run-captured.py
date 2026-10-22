from pathlib import Path
import subprocess,json,hashlib,datetime,re,os,sys
P=Path('/root/gpui-bin-phase-parent');C=Path('/root/gpui-lazy-raster-bins');OUT=Path('/tmp/gpui-bin-phase-results')
config=[('parent',P,'b1fc101435ad62b4ffb6718970846ff7ff154333','/tmp/gpui-bin-phase-parent-build.jsonl'),('candidate',C,'3724ece72f','/tmp/gpui-bin-phase-candidate-build.jsonl')]
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def git(root,*args):return subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),*args],text=True).strip()
def guard(name,root,rev,build):
    head=git(root,'rev-parse','HEAD');assert head==git(root,'rev-parse',rev),(name,head)
    assert git(root,'status','--porcelain')=='?? reactivity/crates/canvas/tests/bin_phase.rs',name
    probe=root/'reactivity/crates/canvas/tests/bin_phase.rs';assert sha(probe)==sha('/tmp/gpui-bin-phase.rs'),name
    candidates=[]
    for line in Path(build).read_text().splitlines():
        row=json.loads(line)
        if row.get('reason')=='compiler-artifact' and row['target']['name']=='bin_phase' and row.get('executable'):candidates.append(row['executable'])
    assert len(set(candidates))==1,(name,candidates)
    binary=Path(candidates[-1]);assert binary.exists()
    return dict(source_commit=head,probe_sha256=sha(probe),binary=str(binary),binary_sha256=sha(binary),build_json_sha256=sha(build))
def envelope():
    rows=subprocess.check_output(['ps','-eo','pid,ppid,stat,comm,args'],text=True).splitlines()
    selected=[];runnable=[]
    for row in rows[1:]:
        cols=row.split(None,4)
        if len(cols)<4:continue
        if cols[3] in ('cargo','rustc','rust-lld','ld.lld','zig','bin_phase') or cols[3].startswith('bin_phase-'):
            selected.append(row)
            if not cols[2].startswith(('T','Z')):runnable.append(row)
    return dict(utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),cpu_pressure=Path('/proc/pressure/cpu').read_text(),io_pressure=Path('/proc/pressure/io').read_text(),processes=selected,runnable=runnable)
manifest={name:guard(name,root,rev,build)for name,root,rev,build in config}
print(json.dumps(dict(inputs=manifest,envelope=envelope()),indent=2),flush=True)
if sys.argv[1:]!=['--capture']:raise SystemExit(0)
assert not OUT.exists(),'fresh output directory required'
OUT.mkdir();before=envelope();assert not before['runnable'],before['runnable']
(OUT/'before.json').write_text(json.dumps(before,indent=2)+'\n')
(OUT/'inputs.json').write_text(json.dumps(manifest,indent=2)+'\n')
results=[]
for i,order in enumerate([('parent','candidate'),('candidate','parent'),('parent','candidate')],1):
    pair=[]
    for name in order:
        binary=manifest[name]['binary'];assert sha(binary)==manifest[name]['binary_sha256']
        cmd=[binary,'bin_phase_probe','--ignored','--exact','--nocapture','--test-threads=1']
        started=datetime.datetime.now(datetime.timezone.utc).isoformat()
        r=subprocess.run(cmd,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=90)
        file=f'{name}-{i}.log';(OUT/file).write_bytes(r.stdout);assert r.returncode==0,(name,r.stdout.decode())
        output=r.stdout.decode();assert '1 passed; 0 failed;'in output
        assert len(re.findall(r'^phase,',output,re.M))==7
        digests=re.findall(r'^digest,[^\n]+',output,re.M);assert len(digests)==6
        pair.append(digests)
        results.append(dict(variant=name,round=i,started=started,finished=datetime.datetime.now(datetime.timezone.utc).isoformat(),command=cmd,log=file,log_sha256=hashlib.sha256(r.stdout).hexdigest(),exit_code=r.returncode))
        print(json.dumps(dict(round=i,variant=name,exit_code=r.returncode)),flush=True)
    assert pair[0]==pair[1],('digest mismatch',pair)
for name,root,rev,build in config:assert guard(name,root,rev,build)==manifest[name]
after=envelope();(OUT/'after.json').write_text(json.dumps(after,indent=2)+'\n');assert not after['runnable'],after['runnable']
(OUT/'runs.json').write_text(json.dumps(results,indent=2)+'\n')
print('Completed six direct probes; all digest/source/binary/post guards pass',flush=True)
