from pathlib import Path
import gzip,hashlib,json
base=Path('/tmp/gpui-text-selection-foundation-evidence/native-diagnostic-frozen')
out=Path('/tmp/gpui-text-selection-foundation-sol/reactivity/evidence/canonical-text-stream/native-diagnostic-62be')
out.mkdir(exist_ok=False)
ledger={}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for path in sorted(base.rglob('*')):
    if not path.is_file() or '__pycache__' in path.parts:continue
    target=out/path.relative_to(base);target.parent.mkdir(parents=True,exist_ok=True)
    raw=path.read_bytes()
    if len(raw)>65536:
        target=target.with_name(target.name+'.gz');target.write_bytes(gzip.compress(raw,mtime=0));assert gzip.decompress(target.read_bytes())==raw
        encoding='gzip mtime0'
    else:target.write_bytes(raw);encoding='identity'
    ledger[str(target.relative_to(out))]={'original_path':str(path),'original_sha256':sha(path),'stored_sha256':sha(target),'encoding':encoding}
(out/'archive-ledger.json').write_text(json.dumps(ledger,indent=2)+'\n')
print(len(ledger),'diagnostic original files archived/decompressed-hash PASS')
