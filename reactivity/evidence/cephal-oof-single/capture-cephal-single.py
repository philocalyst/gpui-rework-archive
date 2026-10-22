from pathlib import Path
import hashlib,json,os,subprocess,csv
root=Path('/root/gpui-cephal-flat-oof'); cap=Path('/tmp/gpui-cephal-single-captures'); cap.mkdir(exist_ok=True)
old=Path('/tmp/gpui-cephal-oof-captures')
h=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
files=[root/'reactivity/crates/core/src/layout.rs',root/'reactivity/crates/core/tests/layout/oof.rs',root/'reactivity/Cargo.lock',Path('/tmp/gpui-cephal-oof-public/src/main.rs'),Path('/tmp/gpui-cephal-oof-driver/src/main.rs'),Path(__file__)]
files += [cap/x for x in ['public-single-owner','single-owner','single-core-driver']]
files += [old/x for x in ['public-oof-owner','public-flat-owner','oof-owner','core-driver']]
expected=json.loads((old/'results.json').read_text())['executable_sha256']
for name,v in expected.items():assert h(old/name)==v
for name,v in json.loads((old/'public-results.json').read_text())['executables'].items():assert h(old/f'public-{name}-owner')==v
pins={str(p):h(p) for p in files}
for p in (root/'reactivity/crates/core/src/layout.rs', root/'reactivity/crates/core/tests/layout/oof.rs'):
 assert h(p)==hashlib.sha256(subprocess.check_output(['git','show',f'd0608d5fd6:{p.relative_to(root)}'],cwd=root)).hexdigest()
def guard():
 for p,v in pins.items():assert h(p)==v,p
def run(exe,args,prefix,envkey=None):
 guard(); env=os.environ.copy()
 if envkey:env[envkey]=str(prefix)
 with prefix.with_suffix('.csv').open('wb') as out,prefix.with_suffix('.stderr').open('wb') as err:
  subprocess.run([str(exe),*args],stdout=out,stderr=err,env=env,check=True)
 guard()
 return list(csv.DictReader(prefix.with_suffix('.csv').open()))
rows=[];pixels=[]
for rep in range(3):
 for variant in (['oof','single'] if rep%2==0 else ['single','oof']):
  exe=old/'public-oof-owner' if variant=='oof' else cap/'public-single-owner'
  prefix=cap/f'public-{rep}-{variant}'
  rr=run(exe,[],prefix,'GPUI_OOF_PIXELS')
  for r in rr:rows.append(dict(rep=rep,fixture='public',variant=variant,**r))
  for stage in ['mount','scroll','text','style','return']:
   p=Path(str(prefix)+f'.{stage}.bgrx'); expected=old/f'public-0-oof.{stage}.bgrx'
   assert h(p)==h(expected),(variant,stage)
   pixels.append(dict(path=str(p),sha256=h(p),reference=str(expected)))
 for mode in ['plain','oof']:
  for variant in ['oof','single']:
   exe=old/'core-driver' if variant=='oof' else cap/'single-core-driver'
   rr=run(exe,[mode],cap/f'core-{rep}-{mode}-{variant}')
   for r in rr:rows.append(dict(rep=rep,fixture='core',mode=mode,variant=variant,**r))
 for count in [0,1,1000]:
  prefix=cap/f'owner-{rep}-{count}-single'
  rr=run(cap/'single-owner',[str(count)],prefix,'GPUI_TEXT_PIXELS')
  for r in rr:rows.append(dict(rep=rep,fixture='owner',variant='single',**r))
  for stage in ['initial','edited']:
   p=Path(str(prefix)+f'.{stage}.bgrx'); expected=old/f'owner-0-{count}.{stage}.bgrx'
   assert h(p)==h(expected),(count,stage)
   pixels.append(dict(path=str(p),sha256=h(p),reference=str(expected)))
# Work equations remain unchanged, including cache replay counts.
for fixture in ['public','core']:
 for a in [r for r in rows if r['fixture']==fixture and r['variant']=='single']:
  b=next(b for b in rows if b['fixture']==fixture and b['variant']=='oof' and b['rep']==a['rep'] and b['stage']==a['stage'] and b.get('mode')==a.get('mode'))
  for k in (['measured','layouts','sources'] if fixture=='public' else ['measured','computed','cached','changed','contexts','cache_heap']):assert a[k]==b[k],(a,b,k)
guard()
(cap/'results.json').write_text(json.dumps(dict(source_commit='d0608d5fd6',guards=pins,rows=rows,pixels=pixels,guards_passed=True,work_equal=True),indent=2)+'\n')
print('capture guards, pixel oracles and old/new work equality passed; rows=',len(rows))
for r in rows:
 if r['rep']==0:print(r)
