from pathlib import Path
import json,hashlib,subprocess,shutil,os
r=Path(__file__).parent;a=json.loads((r/'matrix-artifacts.json').read_text());receipt={'artifacts':{k:{'source':v['source'],'sha256':v['sha256']} for k,v in a.items()},'candidate_qualification':json.loads((r/'qualification-progress.json').read_text()),'inherited_controls':json.loads((r/'control-inherited-qualification.json').read_text())}
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
for n,v in a.items():
 w=Path(v['worktree']);assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==v['source'];assert sha(Path(v['preserved']))==v['sha256'];before=json.loads(Path(v['inputs']).read_text());after={p:sha(w/p) for p in subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=w).decode().split('\0') if p and (w/p).is_file()};assert before==after
for phase,count in [('qualification',336),('allocations',112)]:
 d=r/('matrix-'+phase);assert json.loads((d/'guard-after.json').read_text())==[];assert not (d/'failure.txt').exists();assert json.loads((d/'artifacts.json').read_text())==a;assert len(json.loads((d/'results.json').read_text()))==count;receipt[phase+'_processes']=count
runner=json.loads((r/'runner-receipt.json').read_text());assert sha(r/'matrix_runs.py')==runner['timing_sha256'];assert sha(r/'analyze_matrix.py')==runner['analysis_sha256'];assert sha(r/'process-order.json')==runner['process_manifest_sha256'];receipt['runner']=runner
receipt['free_bytes']=shutil.disk_usage('/home/user').free;assert receipt['free_bytes']>8*1024**3
receipt['processes']=subprocess.check_output(['ps','-eo','pid,etime,pcpu,comm'],text=True)
for row in receipt['processes'].splitlines()[1:]:assert row.split()[-1] not in ['cargo','rustc','rust-lld','ld.lld','gcc','clang','cc1','clippy-driver'],'compiler overlaps timing'
receipt['driver']=json.loads((r/'driver.json').read_text());receipt['cache_environment']={k:os.environ.get(k) for k in ['MESA_SHADER_CACHE_DISABLE','MESA_SHADER_CACHE_DIR','XDG_CACHE_HOME']}
receipt['limits']='Owner operation through native bridge GPU completion and ACK; fresh process/object cold observations are not a cold shader-disk-cache measurement. Same retained image/full copy/work gates. No compilation, other tests, analysis, source changes or cleanup during timing. Software Vulkan/private X11; no physical GPU, scanout, quality parity or ZGX victory.'
(r/'matrix-preflight.json').write_text(json.dumps(receipt,indent=2));print('all fixed gates and execution identities ready for timing')
