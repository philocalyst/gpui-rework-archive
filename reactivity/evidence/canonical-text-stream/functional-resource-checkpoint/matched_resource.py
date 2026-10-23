from pathlib import Path
import hashlib,json,os,shutil,subprocess
root=Path('/tmp/gpui-text-selection-foundation-sol');out=Path(__file__).parent;target=Path('/tmp/gpui-canonical-text-target')
baseline='51f38a3a9b7f62e6f45fbfcd9c95292eb98cb0df';candidate='c6d73132a0'
fixture_name='reactivity/crates/gpui/src/native/accessibility/text/canonical_stream_tests.rs'
parent_name='reactivity/crates/gpui/src/native/accessibility/text.rs'
flags=['-C','symbol-mangling-version=v0','--cfg','tokio_unstable'];cases=['empty','tiny','label','wrapped32k','mixed','long-grapheme']
marker=target/'.canonical-text-owner';assert marker.read_text()=='visual_column_reuse_sol\n'
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def git(*a):return subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),*a],text=True)
def mutate(*a):return subprocess.run(['git','-c',f'safe.directory={root}','-C',str(root),*a],check=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True).stdout
candidate=git('rev-parse',candidate).strip();assert git('rev-parse','HEAD').strip()==candidate and not git('status','--porcelain')
fixture=(root/fixture_name).read_bytes();(out/'matched-resource-fixture.rs').write_bytes(fixture)
env=dict(os.environ)
for key in ['RUSTFLAGS','CARGO_ENCODED_RUSTFLAGS','RUSTC_BOOTSTRAP']:env.pop(key,None)
env['CARGO_TARGET_DIR']=str(target);env['CARGO_BUILD_JOBS']='1'
meta={'baseline':baseline,'candidate':candidate,'physical_source':str(root),'physical_fixture':str(root/fixture_name),'fixture_sha256':digest(root/fixture_name),'root_flags':flags,'cases':cases,'variants':{},'rustc':subprocess.check_output(['rustc','-vV'],env=env,text=True),'cargo':subprocess.check_output(['cargo','-vV'],env=env,text=True),'status':'building; no timing'}
path=out/'matched-resource.json'
def save():path.write_text(json.dumps(meta,indent=2)+'\n')
def files():
 names=git('ls-files','-z','--','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/crates','reactivity/vendor').split('\0')
 return {n:digest(root/n) for n in names if n and (root/n).is_file()}
def run(name,argv,runenv=env):
 with (out/(name+'.log')).open('w') as log:code=subprocess.call(argv,cwd=root/'reactivity',env=runenv,stdout=log,stderr=subprocess.STDOUT)
 print(name,code,flush=True);assert code==0,(name,code)
try:
 for label in ['candidate','baseline']:
  if label=='baseline':
   assert not git('status','--porcelain');mutate('checkout','--detach',baseline)
   file=root/fixture_name;file.parent.mkdir(parents=True,exist_ok=True);file.write_bytes(fixture)
   parent=root/parent_name;s=parent.read_text();assert 'mod canonical_stream_tests' not in s;parent.write_text(s+'\n#[cfg(test)]\nmod canonical_stream_tests;\n')
   mutate('add',fixture_name,parent_name);mutate('-c','user.name=Codex','-c','user.email=codex@openai.com','commit','-m','test(text): freeze matched public native owner control on main')
   assert set(git('diff','--name-only',baseline,'HEAD').splitlines())=={fixture_name,parent_name}
  before=files();variant={'head':git('rev-parse','HEAD').strip(),'files_before':before};meta['variants'][label]=variant;save()
  assert digest(root/fixture_name)==meta['fixture_sha256']
  run(label+'-resource-clean',['cargo','clean','-p','gpui','-p','gpui_canvas'])
  run(label+'-resource-build',['cargo','test','--offline','--locked','-p','gpui','--no-default-features','--features','x11','--lib','--no-run','--message-format=json-render-diagnostics','-vv'])
  events=[]
  for line in (out/(label+'-resource-build.log')).read_text().splitlines():
   if line.startswith('{'):
    try:events.append(json.loads(line))
    except ValueError:pass
  artifacts=[e for e in events if e.get('reason')=='compiler-artifact' and e['target']['name'] in ['gpui','gpui_canvas']]
  assert {e['target']['name'] for e in artifacts}=={'gpui','gpui_canvas'} and all(not e['fresh'] for e in artifacts)
  variant['artifacts']=artifacts
  fingerprints=[]
  for package,name in [('gpui','test-lib-gpui.json'),('gpui_canvas','lib-gpui_canvas.json')]:
   matches=[]
   for f in (target/'debug/.fingerprint').glob(package+'-*/'+name):
    data=json.loads(f.read_text())
    if data['rustflags']==flags:matches.append({'path':str(f),'sha256':digest(f),'data':data})
   assert matches,(label,package,'missing expected root flags');fingerprints.extend(matches)
  variant['fingerprints']=fingerprints
  original=next(Path(e['executable']) for e in artifacts if e.get('executable'));binary=out/(label+'-resource-frozen');shutil.copyfile(original,binary);binary.chmod(0o555)
  variant['binary']={'path':str(binary),'sha256':digest(binary),'bytes':binary.stat().st_size};save()
  for case in cases:run(label+'-resource-'+case,[str(binary),'--exact','native::accessibility::text::canonical_stream_tests::public_owner_and_native_projection_resource_control','--ignored','--nocapture','--test-threads=1'],{**env,'GPUI_CANONICAL_RESOURCE_CASE':case})
  assert files()==before and digest(root/fixture_name)==meta['fixture_sha256'] and digest(binary)==variant['binary']['sha256'];assert not git('status','--porcelain')
  variant['sources_fixture_binary_unchanged']=True;save()
 meta['status']='complete; no timing';save()
except BaseException as error:
 meta['status']='failed';meta['failure']=repr(error);save();raise
finally:
 mutate('checkout','--detach',candidate);meta['restored_candidate']=git('rev-parse','HEAD').strip()==candidate and not git('status','--porcelain');save()
 assert meta['restored_candidate']
