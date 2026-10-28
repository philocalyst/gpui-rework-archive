from pathlib import Path
import json,subprocess,hashlib,shutil
r=Path(__file__).parent;artifacts=json.loads((r/'matrix-artifacts.json').read_text());receipt={'variant_sources':{k:a['source'] for k,a in artifacts.items()},'gates':{},'limits':(r/'matrix-method-notes.txt').read_text()}
def completed(d,stages):
 assert json.loads((d/'guard-after.json').read_text())==[],str(d)
 for s in stages:assert json.loads((d/(s+'.status.json')).read_text())['exit']==0,(d,s)
 return {s:json.loads((d/(s+'.status.json')).read_text()) for s in stages}
for name,stages in [('full-native',['build','test','port','clippy']),('gpu-full',['test','clippy']),('minimal-library',['unit-build','clippy'])]:receipt['gates']['candidate/'+name]=completed(r/name,stages)
old=Path('/home/user/gpui-glyph-damage-evidence')
receipt['inherited_source_equality']=json.loads((r/'inherited-source-equality.json').read_text())
receipt['gates']['inherited-default']=completed(old/'full-default',['test','clippy'])
for label,d in [('candidate',r),('control',Path('/home/user/gpui-glyph-damage-control-evidence')),('predecessor',old),('bounds',Path('/home/user/gpui-glyph-damage-bounds-evidence'))]:
 receipt['gates'][label+'/full-native']=completed(d/'full-native',['build','test','port','clippy'])
 p=d/'native-checks';states=list(p.glob('*.status.json'));assert len(states)==11
 receipt['gates'][label+'/native-checks']=completed(p,[q.name.removesuffix('.status.json') for q in states])
p=r/'minimal-native-checks';states=list(p.glob('*.status.json'));assert len(states)==4;receipt['gates']['candidate/minimal-native-checks']=completed(p,[q.name.removesuffix('.status.json') for q in states])
for name,a in artifacts.items():
 receipt['gates'][name+'/cost-fixture']=completed(Path(a['gate']),['test','clippy','gpu-headers','gpu-clippy'])
 w=Path(a['worktree']);assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==a['source']
 before=json.loads(Path(a['inputs']).read_text());paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=w).decode().split('\0');after={p:hashlib.sha256((w/p).read_bytes()).hexdigest() for p in paths if p and (w/p).is_file()};assert before==after
 assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['sha256']
for phase,count in [('qualification',336),('allocations',112)]:
 p=r/('matrix-'+phase);assert json.loads((p/'guard-after.json').read_text())==[] and not (p/'failure.txt').exists();assert json.loads((p/'artifacts.json').read_text())==artifacts
 assert len(json.loads((p/'results.json').read_text()))==count;receipt[phase+'_processes']=count
for n in artifacts:assert json.loads((r/'matrix-shaders'/(n+'.status.json')).read_text())['exit']==0
for n,p,marker in [('omit-region',Path('/home/user/gpui-glyph-submit-negative-evidence/omit-region'),'assertion `left == right` failed: Rgba8UnormSrgb'),('wrong-sequence-inherited',Path('/home/user/gpui-glyph-damage-negative-evidence/wrong-sequence'),'native sparse text differs from full GPU after publication transition')]:
 assert json.loads((p/'guard-after.json').read_text())==[]
 assert marker in (p/'test.log').read_text();states=list(p.glob('*.status.json'));assert any(json.loads(s.read_text())['exit']!=0 for s in states);receipt['gates']['negative/'+n]=[json.loads(s.read_text()) for s in states]
receipt['runner']=json.loads((r/'runner-receipt.json').read_text());assert hashlib.sha256((r/'matrix_runs.py').read_bytes()).hexdigest()==receipt['runner']['timing_sha256']
receipt['free_bytes']=shutil.disk_usage('/home/user').free;assert receipt['free_bytes']>8*1024**3
receipt['processes']=subprocess.check_output(['ps','-eo','pid,etime,pcpu,comm'],text=True)
for row in receipt['processes'].splitlines()[1:]:assert row.split()[-1] not in ['cargo','rustc','rust-lld','ld.lld','gcc','clang','cc1','clippy-driver'],'compiler overlaps timing'
receipt['note']='No source edits, other tests, allocation probes, builds or cache cleanup may overlap timing. Normal private X11 software Vulkan environment; physical GPU and ZGX parity gates remain open.'
(r/'matrix-preflight.json').write_text(json.dumps(receipt,indent=2));print('all preregistered correctness and environment gates ready for timing')
