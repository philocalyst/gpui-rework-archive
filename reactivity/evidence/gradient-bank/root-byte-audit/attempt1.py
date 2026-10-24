from pathlib import Path, PurePosixPath
import hashlib,json,tarfile
root=Path('/tmp/gpui-gradient-bank-sol-evidence')
out=Path('/tmp/gpui-gradient-bank-root-audit')
out.mkdir(exist_ok=False)
archive=root/'REVIEW-BUNDLE.tar.gz'
sha=lambda b:hashlib.sha256(b).hexdigest()
expected='8ee5c9d221cfce6e70abb754e938066ad46f25c3752b895af79c1ef18be84c8f'
assert sha(archive.read_bytes())==expected
rows=[]
with tarfile.open(archive,'r:gz') as tar:
    members=tar.getmembers()
    assert len({m.name for m in members})==len(members)
    files={}
    for member in members:
        p=PurePosixPath(member.name)
        assert not p.is_absolute() and '..' not in p.parts
        assert member.isfile() or member.isdir(),(member.name,member.type)
        if member.isfile():files[member.name]=sha(tar.extractfile(member).read())
    for line in (root/'SHA256SUMS').read_text().splitlines():
        digest,name=line.split('  ',1)
        candidates=[key for key in files if key==name or key.endswith('/'+name)]
        assert len(candidates)==1,(name,candidates)
        assert files[candidates[0]]==digest,name
        assert sha((root/name).read_bytes())==digest,name
        rows.append({'name':name,'sha256':digest,'bundle_member':candidates[0]})
    report={'archive':str(archive),'bytes':archive.stat().st_size,'sha256':expected,'members':len(members),'regular_files':len(files),'manifest_verified_files':len(rows),'all_member_kinds_safe':True,'selected_pin':'a2dd48e908d6bb5e999f5b613af3a82407353ee5','scope':'Independent byte/member and manifest verification; not test execution.'}
(out/'verified-files.json').write_text(json.dumps(rows,indent=2)+'\n')
(out/'result.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report))
