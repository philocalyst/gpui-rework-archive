from pathlib import Path
import gzip,hashlib,json,shutil
base=Path(__file__).parent
out=Path('/tmp/gpui-text-selection-foundation-sol/reactivity/evidence/canonical-text-stream/failed-capture-62be')
out.mkdir(exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
ledger={}
for path in sorted((base/'timing-final-capture').iterdir()):
    if not path.is_file():continue
    target=out/'raw'/path.name;target.parent.mkdir(exist_ok=True)
    raw=path.read_bytes()
    if len(raw)>65536:
        target=target.with_name(target.name+'.gz');target.write_bytes(gzip.compress(raw,mtime=0));assert gzip.decompress(target.read_bytes())==raw
        encoding='gzip mtime0'
    else:target.write_bytes(raw);encoding='identity'
    ledger[str(target.relative_to(out))]={'original_path':str(path),'original_sha256':sha(path),'stored_sha256':sha(target),'encoding':encoding}
for name in ['timing-final-capture-runner.log','timing-final-analysis.log','timing-final-afterguards.json']:
    path=base/name;shutil.copyfile(path,out/name)
    ledger[name]={'original_path':str(path),'original_sha256':sha(path),'stored_sha256':sha(out/name),'encoding':'identity'}
(out/'archive-ledger.json').write_text(json.dumps(ledger,indent=2)+'\n')
print(out,len(ledger),'originals preserved and verified')
