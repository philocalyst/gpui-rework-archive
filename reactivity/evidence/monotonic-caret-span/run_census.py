from pathlib import Path
from collections import Counter
import gzip,hashlib,json,subprocess,sys
name=sys.argv[1]; base=Path('/tmp/gpui-monotonic-census-'+name)
normal=json.loads(Path('/tmp/gpui-monotonic-'+name+'-release-metadata.json').read_text())
expected=json.loads(Path('/tmp/gpui-monotonic-'+name+'-shaper-allocations.json').read_text())['rows']
root=Path(normal['worktree']); target=Path('/tmp/gpui-monotonic-census-'+name+'-target')
artifacts=[json.loads(line) for line in Path(str(base)+'-build.json').read_text().splitlines() if line.startswith('{')]
artifact=next(a for a in artifacts if a.get('reason')=='compiler-artifact' and a.get('target',{}).get('name')=='monotonic-caret-census')
binary=Path(artifact['executable']); sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
inputs=[p for p in base.rglob('*') if p.is_file()]
guard={str(p.relative_to(base)):sha(p) for p in inputs}
binary_hash=sha(binary)
def check():
    assert sha(binary)==binary_hash
    assert all(sha(base/n)==h for n,h in guard.items())
    assert all(sha(root/n)==h for n,h in normal['guard'].items())
rows=[]; check()
for expected_row in expected:
    check(); case=expected_row['case']; scope=expected_row['scope']
    p=subprocess.run([str(binary),case,scope,'alloc','1'],capture_output=True,text=True,check=True,timeout=90)
    assert p.stdout.split('checksum=')[1]==expected_row['stdout'].split('checksum=')[1]
    inside=None; blocks=[]; outside=Counter()
    for line in p.stderr.splitlines():
        if line.startswith('CENSUS_STREAM_BEGIN'):
            assert inside is None; inside=Counter()
        elif line=='CENSUS_STREAM_END':
            assert inside is not None; blocks.append(dict(inside));inside=None
        elif line.startswith('CENSUS_'):
            (outside if inside is None else inside)[line]+=1
        else:
            raise AssertionError(line)
    assert inside is None
    check()
    raw=Path(str(base)+f'-{case}-{scope}.stderr.gz')
    with gzip.GzipFile(filename=str(raw),mode='wb',mtime=0) as out: out.write(p.stderr.encode())
    rows.append(dict(case=case,scope=scope,stdout=p.stdout,stream_blocks=blocks,outside=dict(outside),raw_stderr=str(raw),raw_sha256=sha(raw)))
    print(name,case,scope,blocks[-1:] or dict(outside),flush=True)
check()
Path(str(base)+'-results.json').write_text(json.dumps(dict(normal_source=normal['source'],artifact=artifact,binary_sha256=binary_hash,input_guard=guard,normal_guard=normal['guard'],rows=rows,guards_passed=True,limits='Markers perturb allocation and execution. Count/checksum only; alloc stdout is unqualified. Stream blocks delimit bulk visitor calls; outside includes unchanged direct tiny path. Each process primes fonts; cold shapes twice, warm three times.'),indent=2)+'\n')
