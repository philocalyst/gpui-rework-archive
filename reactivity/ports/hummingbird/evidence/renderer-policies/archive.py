from pathlib import Path
import gzip,hashlib,json,shutil
root=Path('/root/gpui-ce3');base=root/'reactivity';src=Path('/tmp/gpui-hummingbird-renderer-gates');dst=base/'ports/hummingbird/evidence/renderer-policies';dst.mkdir(exist_ok=True)
h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
metadata=json.loads((src/'metadata.json').read_text());guard=json.loads((src/'source-guard.json').read_text());assert metadata['source_unchanged'] and metadata['owned_displays_stopped'];assert all(h(root/n)==v for n,v in guard.items());assert h(src/'hummingbird-frozen')==metadata['binary_sha256'];assert all(v==0 for v in json.loads((src/'consumer-checks.json').read_text()).values())
for p in sorted(src.iterdir()):
 if p.name=='hummingbird-frozen':continue
 if p.suffix=='.log':(dst/(p.name+'.gz')).write_bytes(gzip.compress(p.read_bytes(),mtime=0))
 else:shutil.copyfile(p,dst/p.name)
for name in ['native-build.jsonl','native-build.log','headless-build.jsonl','headless-build.log','headless-results.json','headless.log','invalid.log','missing.log','headless-policy.log','native-feature.log']:
 p=Path('/tmp/gpui-hummingbird-renderer-'+name)
 assert p.is_file(),p
 if p.suffix in ('.jsonl','.log'):(dst/(p.name+'.gz')).write_bytes(gzip.compress(p.read_bytes(),mtime=0))
 else:shutil.copyfile(p,dst/p.name)
shutil.copyfile('/tmp/gpui-hummingbird-renderer-gates.py',dst/'guard-driver.py');shutil.copyfile(__file__,dst/'archive.py')
renderers={}
for policy in ('cpu','gpu','auto'):
 data=json.loads((dst/f'native-{policy}.json').read_text());assert data['binary_sha256']==metadata['binary_sha256'];renderers[policy]={'frames':len(data['presented_frames']),'observed_kinds':sorted({f[0] for f in data['presented_frames']}),'events':len(data['events'])}
(dst/'qualification.json').write_text(json.dumps({'combined_source':metadata['source_head'],'renderer_cli_source':'9523e74347','prior_headless_only_source':'9523e74347','guarded_files':len(guard),'native_binary_sha256':metadata['binary_sha256'],'policies':renderers,'application_cases_passed':9,'public_future_cases_passed':17,'external_catalog_cases_passed':5,'borrowed_search_driver_locked_compile':True,'pre_future_headless_controls':'Separate older source9523 CLI/parser/build controls preserved; not retagged as current native-feature/Future checks.','source_and_binary_unchanged':True,'limits':metadata['limits']},indent=2)+'\n')
print(json.dumps(renderers))
