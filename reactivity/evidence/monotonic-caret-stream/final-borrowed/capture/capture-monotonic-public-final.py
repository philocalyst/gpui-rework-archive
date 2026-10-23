from pathlib import Path
import hashlib,json,shutil,subprocess
root=Path('/root/gpui-monotonic-caret-borrowed');fixture=Path('/tmp/gpui-monotonic-public-borrowed')
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
old=json.loads(Path('/tmp/gpui-monotonic-public-borrowed-run.json').read_text())
guard={n:sha(root/n) for n in old['source_guard']};inputs={n:sha(fixture/n) for n in old['input_guard']}
metadata=json.loads(Path('/tmp/gpui-monotonic-final-release-metadata.json').read_text())
assert all(sha(root/n)==h for n,h in metadata['guard'].items())
artifacts=[json.loads(s) for s in Path('/tmp/gpui-monotonic-public-final-build.json').read_text().splitlines() if s.startswith('{')]
rows=[]
def check():
 assert all(sha(root/n)==h for n,h in guard.items());assert all(sha(fixture/n)==h for n,h in inputs.items())
for name in ['ack-query-control','owner']:
 check();a=next(a for a in artifacts if a.get('reason')=='compiler-artifact' and a['target']['name']==name)
 bin=Path('/tmp/gpui-monotonic-control-bin/public-final-'+name);assert not bin.exists();shutil.copy2(a['executable'],bin);digest=sha(bin)
 command=[str(bin)]+(['/tmp/gpui-monotonic-public-final.bin'] if name=='ack-query-control' else [])
 p=subprocess.run(command,text=True,capture_output=True);assert p.returncode==0,p.stderr
 check();assert sha(bin)==digest
 row=dict(name=name,artifact=a,binary=str(bin),sha256=digest,exit=p.returncode,stdout=p.stdout,stderr=p.stderr)
 oldrow=next(r for r in old['rows'] if r['name']==name);assert p.stdout==oldrow['stdout'] and p.stderr==oldrow['stderr']
 rows.append(row)
out=Path('/tmp/gpui-monotonic-public-final.bin');assert sha(out)==old['transcript_sha256'];assert out.stat().st_size==old['transcript_bytes']
result=dict(source=metadata['source'],rows=rows,input_guard=inputs,source_guard=guard,guards_passed=True,transcript_sha256=sha(out),transcript_bytes=out.stat().st_size,scope=old['scope'])
Path('/tmp/gpui-monotonic-public-final-run.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(dict(source=result['source'],transcript_sha256=sha(out),transcript_bytes=out.stat().st_size,owner=rows[1]['stdout'])))
