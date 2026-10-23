from pathlib import Path
import hashlib,json,shutil,subprocess
root=Path('/root/gpui-monotonic-caret-borrowed')
git=['git','-c',f'safe.directory={root}','-C',str(root)]
pin=subprocess.check_output(git+['rev-parse','81bd9e53b7'],text=True).strip()
sha=lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()
old=json.loads(Path('/tmp/gpui-monotonic-borrowed-release-metadata.json').read_text())
closure=json.loads(Path('/tmp/gpui-monotonic-shipping-input-closure.json').read_text())
keys=set(old['guard'])|{r['path'] for r in closure['local_inputs']}
guard={n:sha(root/n) for n in sorted(keys)}
assert not subprocess.check_output(git+['diff',pin,'--','reactivity/crates','reactivity/vendor','reactivity/Cargo.toml','reactivity/Cargo.lock'])
art=[json.loads(s) for s in Path('/tmp/gpui-monotonic-final-release.json').read_text().splitlines() if s.startswith('{')]
a=next(a for a in art if a.get('reason')=='compiler-artifact' and a['target']['name']=='caret_pair_measure')
bin=Path('/tmp/gpui-monotonic-control-bin/stream-final'); assert not bin.exists();shutil.copy2(a['executable'],bin)
m=dict(source=pin,worktree=str(root),guard=guard,target='/tmp/gpui-monotonic-borrowed-release-target',binary=str(bin),sha256=sha(bin),artifact=a,rustflags='',jobs=2)
Path('/tmp/gpui-monotonic-final-release-metadata.json').write_text(json.dumps(m,indent=2)+'\n')
base=json.loads(Path('/tmp/gpui-monotonic-baseline-release-metadata.json').read_text())
br=Path(base['worktree']); base['guard']={n:sha(br/n) for n in sorted(set(base['guard'])|{r['path'] for r in closure['local_inputs']})}
assert sha(base['binary'])==base['sha256']
Path('/tmp/gpui-monotonic-final-pair-metadata.json').write_text(json.dumps(dict(baseline=base,final=m),indent=2)+'\n')
print(json.dumps(dict(source=pin,binary=m['binary'],sha256=m['sha256'],guards=len(guard))))
rows=[]
for case in ['tiny','label','latin','rtl','mixed','paragraphs','one-grapheme']:
 for scope in ['cold','warm']:
  p=subprocess.run([str(bin),case,scope,'alloc','1'],capture_output=True,text=True);assert p.returncode==0,p.stderr
  rows.append(dict(case=case,scope=scope,exit=p.returncode,stdout=p.stdout,stderr=p.stderr))
assert all(sha(root/n)==h for n,h in guard.items());assert sha(bin)==m['sha256']
Path('/tmp/gpui-monotonic-final-allocation.json').write_text(json.dumps(rows,indent=2)+'\n')
print('14 final allocation rows captured; source/binary guards passed')
