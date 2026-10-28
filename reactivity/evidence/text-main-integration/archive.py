from pathlib import Path
import gzip,hashlib,json,re,shutil
root=Path('/root/gpui-ce3');src=Path('/tmp/gpui-text-main-gates');dst=root/'reactivity/evidence/text-main-integration';dst.mkdir(exist_ok=True)
h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();m=json.loads((src/'metadata.json').read_text());guard=json.loads((src/'source-guard.json').read_text());assert m['source_unchanged'] and m['owned_display_stopped'];assert all(h(root/n)==v for n,v in guard.items());assert all(h(Path(n))==v for n,v in m['executables'].items());results=json.loads((src/'results.json').read_text());assert len(results)==14 and all(r['exit']==0 for r in results)
for p in sorted(src.iterdir()):
 if p.name.endswith('-frozen'):continue
 if p.suffix=='.log':(dst/(p.name+'.gz')).write_bytes(gzip.compress(p.read_bytes(),mtime=0))
 else:shutil.copyfile(p,dst/p.name)
shutil.copyfile('/tmp/gpui-text-main-gates.py',dst/'guard-driver.py');shutil.copyfile(__file__,dst/'archive.py')
r=re.findall(r'test result: ok\. (\d+) passed; \d+ failed; (\d+) ignored',(src/'gpui-full.log').read_text());n=sum(int(a) for a,b in r);ignored=sum(int(b) for a,b in r);assert(n,ignored)==(529,27)
policies={}
for name in ('cpu','gpu','auto'):
 data=json.loads((src/f'hummingbird-{name}.json').read_text());policies[name]={'frames':len(data['presented_frames']),'observed_renderers':sorted({f[0] for f in data['presented_frames']})}
(dst/'qualification.json').write_text(json.dumps({'source':m['source'],'gpui_passed':n,'gpui_ignored':ignored,'gpui_groups':len(r),'hummingbird_passed':9,'catalog_client_passed':5,'native_cases':['actual AT-SPI Registry Unicode extents/hit/edit/reactivation','late service/provider replacement/destroy','exact Future cancellation/result wake','blank resize/resume/no initialization then complex CPU-to-GPU handoff'],'hummingbird_policies':policies,'source_files_guarded':len(guard),'source_and_binaries_unchanged':True,'all_owned_displays_stopped':True,'limits':m['limits']},indent=2)+'\n')
print(json.dumps({'gpui_passed':n,'ignored':ignored,'policies':policies,'guarded_files':len(guard)}))
