from pathlib import Path
import hashlib,json,subprocess,os,shutil
root=Path('/tmp/gpui-inspector-pointer-sol');control=Path('/tmp/gpui-inspector-pointer-code-control');out=Path('/tmp/gpui-inspector-pointer-codegen');target=Path('/tmp/gpui-inspector-pointer-release-target')
base='6021d0009db4069e5c7f96400890baa75630f047';candidate='945719383465a41445f84534bfcca179ef665617'
env=dict(os.environ);env.pop('RUSTFLAGS',None);env.pop('CARGO_ENCODED_RUSTFLAGS',None);env.update(CARGO_TARGET_DIR=str(target),CARGO_BUILD_JOBS='2',RUSTC_BOOTSTRAP='1')
h=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
config=['--config','build.rustflags=["-Zemit-stack-sizes"]'];manifest=['--manifest-path',str(control/'Cargo.toml'),'--locked']
meta={'profile':'opt3 codegen-units1 noLTO debug0 stripnone; GPUI default features disabled; stack metadata enabled for all crates','target_dir':str(target),'commands':[],'variants':{},'timings_claimed':False}
def command(name,args):
 record={'name':name,'argv':args};meta['commands'].append(record)
 with (out/(name+'.stdout')).open('w') as stdout,(out/(name+'.stderr')).open('w') as stderr:result=subprocess.call(args,cwd=root,env=env,stdout=stdout,stderr=stderr)
 record['exit']=result;(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n');assert result==0,(name,result)
def snapshot():
 names=subprocess.check_output(['git','ls-files','-z','--','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/crates','reactivity/vendor'],cwd=root).decode().split('\0')
 r={n:h(root/n) for n in names if n and (root/n).is_file()}
 for p in (control/'Cargo.toml',control/'Cargo.lock',control/'src/main.rs'):r[str(p)]=h(p)
 assert subprocess.check_output(['git','status','--porcelain'],cwd=root,text=True)==''
 return r
try:
 for label,pin in [('baseline',base),('candidate',candidate)]:
  subprocess.check_call(['git','switch','--detach',pin],cwd=root)
  before=snapshot();(out/(label+'-before.json')).write_text(json.dumps(before,indent=2)+'\n')
  if label=='candidate':
   command(label+'-clean',['cargo']+config+['clean']+manifest+['--release','-p','gpui','-p','inspector-pointer-control'])
  command(label+'-build',['cargo']+config+['build']+manifest+['--release','--message-format=json-render-diagnostics','-vv'])
  artifacts=[json.loads(line) for line in (out/(label+'-build.stdout')).read_text().splitlines() if line.startswith('{')]
  relevant=[a for a in artifacts if a.get('reason')=='compiler-artifact' and a['target']['name'] in ('gpui','inspector-pointer-control')]
  assert len(relevant)==2 and all(a['fresh'] is False for a in relevant),[(a['target']['name'],a.get('fresh')) for a in relevant]
  binary=out/(label+'-frozen');shutil.copyfile(target/'release/inspector-pointer-control',binary);binary.chmod(0o555)
  command(label+'-oracle',[str(binary)])
  after=snapshot();assert before==after
  (out/(label+'-after.json')).write_text(json.dumps(after,indent=2)+'\n')
  fingerprints=[]
  for p in list((target/'release/.fingerprint').glob('gpui-*/lib-gpui.json'))+list((target/'release/.fingerprint').glob('inspector-pointer-control-*/bin-inspector-pointer-control.json')):
   d=json.loads(p.read_text());assert d['rustflags']==['-C','symbol-mangling-version=v0','--cfg','tokio_unstable','-Zemit-stack-sizes']
   fingerprints.append({'path':str(p.relative_to(target)),'data':d,'sha256':h(p)})
  assert len(fingerprints)==2
  meta['variants'][label]={'head':pin,'shipping_source':base if label=='baseline' else 'a2e03de3a0fd831f5c9e8404d6d8ebc1815465b8','guarded_files':len(before),'unchanged':True,'artifacts':relevant,'fingerprints':fingerprints,'binary_sha256':h(binary),'binary_bytes':binary.stat().st_size}
  (out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
 a=json.loads((out/'baseline-before.json').read_text());b=json.loads((out/'candidate-before.json').read_text());diff={p for p in a.keys()|b.keys() if a.get(p)!=b.get(p)}
 expected=set(subprocess.check_output(['git','diff','--name-only',base,'a2e03de3a0'],cwd=root,text=True).splitlines());assert diff==expected,(diff,expected)
 assert (out/'baseline-oracle.stdout').read_bytes()==(out/'candidate-oracle.stdout').read_bytes()
 meta['changed_graph_files']=sorted(diff);meta['oracle_equal']=True;(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n');print('matched source/flags/freshness/layout/behavior guards PASS')
finally:
 subprocess.check_call(['git','switch','inspector-pointer-sol'],cwd=root)
