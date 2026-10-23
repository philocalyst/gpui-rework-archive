from pathlib import Path
import gzip,hashlib,json,shutil
base=Path(__file__).parent
root=Path('/tmp/gpui-text-selection-foundation-sol')
out=root/'reactivity/evidence/canonical-text-stream/final-public-controls'
out.mkdir(exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
archives={}
for name in ['matched-release-codegen','matched-release-codegen-terminal','matched-release-codegen-final','full-count-final']:
    destination=out/name;destination.mkdir()
    for path in sorted((base/name).iterdir()):
        if not path.is_file() or path.name.endswith(('-canonical-text-public-control','-canonical-text-native-control')):
            continue
        target=destination/path.name
        raw=path.read_bytes()
        if path.suffix in ['.asm','.log'] and len(raw)>65536:
            target=target.with_name(target.name+'.gz')
            target.write_bytes(gzip.compress(raw,mtime=0))
            assert gzip.decompress(target.read_bytes())==raw
            archives[str(target.relative_to(out))]={'original_path':str(path),'original_sha256':sha(path),'encoding':'gzip mtime0','archive_sha256':sha(target)}
        else:
            target.write_bytes(raw)
            archives[str(target.relative_to(out))]={'original_path':str(path),'original_sha256':sha(path),'encoding':'identity','archive_sha256':sha(target)}
for name in ['build_frozen_controls.py','build_terminal_controls.py','build_final_controls.py','analyze_frozen_codegen.py','analyze_final_codegen.py','verify_final_full_counts.py','capture_final_timing.py','analyze_final_timing.py','check_timing_analyzer.py','codegen_bodies_ledger.py','timing-analyzer-selfcheck.json','public-preflight-freeze.json','public-terminal-freeze.json','public-final-freeze.json','timing-fixed-work-registration.json','timing-final-registration.json','matched-release-codegen-runner.log','matched-terminal-runner.log','matched-final-runner.log','full-count-final-runner.log','analyze-final-codegen.log']:
    path=base/name
    if path.exists():
        shutil.copyfile(path,out/name)
        archives[name]={'original_path':str(path),'original_sha256':sha(path),'encoding':'identity','archive_sha256':sha(out/name)}
fixture=Path('/tmp/gpui-canonical-text-public-control')
for version in ['final','terminal']:
    freeze=json.loads((base/('public-'+version+'-freeze.json')).read_text())
    for name,digest in freeze['fixture_sha256'].items():
        raw=(fixture/name).read_bytes()
        if version=='terminal' and name=='src/main.rs':
            raw=raw.replace(b'Some("measure" | "verify")',b'Some("measure")').replace(b'count, args[0] == "measure")',b'count, true)').replace(b'expected oracle | verify|measure CASE OPERATION COUNT',b'expected oracle | measure CASE OPERATION COUNT')
        assert hashlib.sha256(raw).hexdigest()==digest,(version,name)
        target=out/('fixture-'+version)/name;target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(raw)
(out/'archive-ledger.json').write_text(json.dumps(archives,indent=2)+'\n')
print(out,len(archives),'archived files; exact decompression SHA checked')
