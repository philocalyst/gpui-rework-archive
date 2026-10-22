"""Actual Vulkan dispatch ownership and injected failure probes; no heap captures."""
from pathlib import Path
import hashlib,json,os,re,shlex,shutil,subprocess
ROOT=Path(__file__).resolve().parents[4];WORK=ROOT/'reactivity';OUT=WORK/'evidence/static-shader';CHECKS=OUT/'checks'
SOURCE='a871fc6fa924f31bf08fe2a51248930025582da1'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=json.loads((CHECKS/'source.json').read_text());assert snapshot['source']==SOURCE
def guard():assert {p:sha(ROOT/p) for p in snapshot['files']}==snapshot['files']
guard()
rows=[json.loads(s) for s in (CHECKS/'fixture-build.jsonl').read_text().splitlines() if s.startswith('{')]
artifacts=[r for r in rows if r.get('reason')=='compiler-artifact' and r['target']['name']=='static-lifetime' and r.get('executable')];assert len(artifacts)==1
BIN=Path('/tmp/gpui-static-frozen-bins/static-lifetime');shutil.copyfile(artifacts[0]['executable'],BIN);BIN.chmod(0o755)
lib=Path('/tmp/gpui-static-final-layer.so');layer_dir=Path('/tmp/gpui-static-final-layer');layer_dir.mkdir(exist_ok=True)
header=Path('/nix/store/y5cj46l7dvhhz63rwgqd71h723i3q8c0-vulkan-headers-1.4.341.0/include')
args=['clang','-std=c11','-Wall','-Wextra','-Werror','-shared','-fPIC','-pthread','-I'+str(header),str(OUT/'drivers/layer.c'),'-o',str(lib)]
shell='source /tmp/gpui-native-env.sh\nexec '+shlex.join(args)
with (CHECKS/'native-layer-build.log').open('w') as log:r=subprocess.run(['bash','-c',shell],stdout=log,stderr=subprocess.STDOUT,cwd=WORK)
assert r.returncode==0
manifest={'file_format_version':'1.2.0','layer':{'name':'VK_LAYER_GPUI_static_probe','type':'GLOBAL','library_path':str(lib),'api_version':'1.4.341','implementation_version':'1','description':'Test-only native static SPIR-V ownership observer and failure injector'}}
(layer_dir/'VkLayer_GPUI_static_probe.json').write_text(json.dumps(manifest,indent=2)+'\n')
expected={
 'static-create':(0,0,0,0,0,0,0),
 'static-render-first':(2,2,2,1,0,0,0),
 'static-render-repeat':(2,2,2,1,0,0,0),
 'static-concurrent':(8,8,8,4,0,0,0),
 'static-compute-repeat':(3,3,3,0,3,0,0),
 'static-public-shaders-drop':(0,0,0,0,0,0,0),
 'static-pipelines-drop':(0,0,0,0,0,0,0),
 'raw-create':(3,0,3,0,0,0,3),
 'raw-render-repeat':(0,0,0,2,0,0,3),
 'raw-concurrent':(0,0,0,4,0,0,3),
 'raw-compute-repeat':(0,0,0,0,3,0,3),
 'raw-public-shaders-drop':(0,0,0,0,0,0,3),
 'raw-pipelines-drop':(0,3,0,0,0,0,0),
 'missing-feature':(0,0,0,0,0,0,0),
 'unsupported-backend':(0,0,0,0,0,0,0),
 'static-module-first-failure':(0,0,1,0,0,0,0),
 'static-module-second-failure':(1,1,2,0,0,0,0),
 'static-pipeline-failure':(2,2,2,1,0,0,0),
 'static-compute-module-failure':(0,0,1,0,0,0,0),
 'static-compute-pipeline-failure':(1,1,1,0,1,0,0),
 'raw-pipeline-failure':(0,0,0,1,0,0,2),
}
keys=['created','destroyed','calls','graphics','compute','ray','live']
record={'source':SOURCE,'binary':{'cargo_artifact':artifacts[0]['executable'],'copy':str(BIN),'sha256':sha(BIN)},'layer':{'sha256':sha(lib),'source_sha256':sha(OUT/'drivers/layer.c'),'build':args,'manifest':manifest,'headers':{name:sha(header/'vulkan'/name) for name in ['vk_layer.h','vulkan_core.h','vk_platform.h']}},'cases':{}}
for case in ['success','missing-feature','unsupported-backend','static-module-first-failure','static-module-second-failure','static-pipeline-failure','static-compute-module-failure','static-compute-pipeline-failure','raw-pipeline-failure']:
 guard();assert sha(BIN)==record['binary']['sha256'] and sha(lib)==record['layer']['sha256']
 trace=Path('/tmp/gpui-static-final-trace')
 extra={'VK_LAYER_PATH':str(layer_dir),'VK_INSTANCE_LAYERS':'VK_LAYER_GPUI_static_probe','GPUI_STATIC_PROBE_LAYER':str(lib),'MESA_SHADER_CACHE_DISABLE':'true'}
 if case=='success':
  trace.mkdir(exist_ok=False);extra['GPUI_STATIC_TRACE']=str(trace)
 exports='\n'.join('export '+key+'='+shlex.quote(value) for key,value in extra.items())
 shell='source /tmp/gpui-native-env.sh\n'+exports+'\nexec '+shlex.join([str(BIN),case])
 path=CHECKS/('native-'+case+'.log')
 with path.open('w') as log:r=subprocess.run(['bash','-c',shell],stdout=log,stderr=subprocess.STDOUT,cwd=WORK)
 assert r.returncode==0,(case,path.read_text())
 phases={};phase='initial-device';live=set()
 for line in path.read_text().splitlines():
  if line.startswith('PROBE_MODULE') and 'result=0 ' in line:
   handle=re.search(r'handle=(\S+)',line)[1];assert handle not in live;live.add(handle)
  elif line.startswith('PROBE_DESTROY'):
   handle=re.search(r'handle=(\S+)',line)[1];assert handle in live;live.remove(handle)
  elif line.startswith('PROBE_BEGIN'): phase=line.split()[1]
  elif line.startswith('PROBE_END'):
   values=dict((k,int(v)) for k,v in re.findall(r'(\w+)=(\d+)',line));assert values['live']==len(live)
   phases[phase]=values
   if phase in expected:
    required=expected[phase]
    if phase=='raw-create' and case=='raw-pipeline-failure':required=(2,0,2,0,0,0,2)
    assert tuple(values[k] for k in keys)==required,(case,phase,values,required)
 assert not live
 if case not in ['success']:assert 'PROBE_ERRORS' in path.read_text()
 record['cases'][case]={'exit':r.returncode,'log_sha256':sha(path),'phases':phases}
 guard()
trace_files={p.name:{'bytes':p.stat().st_size,'sha256':sha(p)} for p in sorted(trace.iterdir())}
assert (trace/'trace.ron').read_text().count('CreateShaderModulePassthrough(')==6
for name in ['vertex','fragment','compute']:
 expected_hash=sha(OUT/'modules'/(name+'.spv'))
 assert sum(row['sha256']==expected_hash for key,row in trace_files.items() if key.endswith('.spv'))==2
record['trace']={'files':trace_files,'passthrough_actions':6,'static_and_raw_capture_same_exact_words':True,'replay':'Existing passthrough action contains source bytes and no static provenance. Ordinary replay cannot infer static lifetime and uses Raw ownership. Replay execution was not tested.'}
shutil.copytree(trace,OUT/'trace')
(CHECKS/'native-results.json').write_text(json.dumps(record,indent=2)+'\n')
guard();print(json.dumps({'source':SOURCE,'native_cases':len(record['cases']),'trace_actions':6,'all_expected_counts_and_exact_handle_destruction':True}))
