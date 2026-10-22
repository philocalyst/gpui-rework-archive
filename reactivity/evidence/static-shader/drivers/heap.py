"""Matched live-owner DHAT captures. No explicit layer and no timing claims."""
from pathlib import Path
import hashlib,json,os,shlex,subprocess,sys
ROOT=Path(__file__).resolve().parents[4];WORK=ROOT/'reactivity';OUT=WORK/'evidence/static-shader';CHECKS=OUT/'checks';DHAT=OUT/'dhat'
SOURCE='a871fc6fa924f31bf08fe2a51248930025582da1'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=json.loads((CHECKS/'source.json').read_text())
def guard():assert {p:sha(ROOT/p) for p in snapshot['files']}==snapshot['files']
guard();case=sys.argv[1]
if case=='raw':
 binary=Path('/tmp/gpui-offline-shader-controls/bea848dbe4/driver-retained-artifact')
 prior=json.loads((WORK/'evidence/offline-shader/artifact-and-linked-bytes.json').read_text())['binaries']['bea848dbe4/driver-retained-artifact']
 assert sha(binary)==prior['sha256']
 provenance={'runtime_source':'bea848dbe4cf9901fa7469eca836f92fe267af0b','qualification_source':'0981fdccae9ddb015a678195770e28085ed9182f','archive':'reactivity/evidence/offline-shader/artifact-and-linked-bytes.json'}
else:
 mode='owners-optional' if case=='static' else 'owners-default'
 info=json.loads((CHECKS/(mode+'-executables.json')).read_text())['driver-retained'];binary=Path(info['copy']);assert sha(binary)==info['sha256']
 provenance={'source':SOURCE,'build_record':str(CHECKS/(mode+'-build.jsonl'))}
val=Path('/nix/store/px7wv2vfgzjagdqx2709qx5v9167gyj1-valgrind-3.27.1/bin/valgrind')
profile=DHAT/(case+'.json');stdout=DHAT/(case+'.stdout');stderr=DHAT/(case+'.stderr')
command=[str(val),'--tool=dhat','--num-callers=60','--dhat-out-file='+str(profile),str(binary)]
shell='source /tmp/gpui-native-env.sh\nunset VK_INSTANCE_LAYERS VK_LAYER_PATH GPUI_STATIC_PROBE_LAYER GPUI_STATIC_TRACE\nexport MESA_SHADER_CACHE_DISABLE=true\nexec '+shlex.join(command)
before=sha(binary)
with stdout.open('w') as out,stderr.open('w') as err:r=subprocess.run(['bash','-c',shell],cwd=WORK,stdout=out,stderr=err)
assert r.returncode==0 and sha(binary)==before
guard()
data=json.loads(profile.read_text())
keys=['tb','tbk','gb','gbk','eb','ebk']
def sums(points):return {key:sum(point[key] for point in points) for key in keys}
def constructor(frames):return any('gpui_gpu::renderer::GpuContext' in f and 'new' in f or 'gpui_gpu::renderer::Renderer' in f and 'new' in f for f in frames)
subsets={}
for name,predicate in [
 ('constructor',constructor),
 ('native_module',lambda fs:constructor(fs) and any('vk_common_CreateShaderModule' in f for f in fs)),
 ('constructor_naga',lambda fs:constructor(fs) and any('naga::' in f for f in fs)),
]:
 selected=[p for p in data['pps'] if predicate([data['ftbl'][i] for i in p['fs']])]
 subsets[name]={'sites':len(selected),**sums(selected)}
assert not any('gpui-static-final-layer' in f or 'gpui-static-probe-layer' in f for f in data['ftbl'])
record={'case':case,'provenance':provenance,'binary':{'path':str(binary),'bytes':binary.stat().st_size,'sha256':before},'command':command,'tool_sha256':sha(val),'exit':r.returncode,'mesa_disk_shader_cache':'disabled','explicit_native_test_layer':'disabled and absent from profile frames','lifetime':'Renderer/Device/Queue/Adapter/Instance remain alive at deliberate process exit','whole_process':sums(data['pps']),'subsets':subsets,'profile_sha256':sha(profile),'profile_bytes':profile.stat().st_size,'stdout_sha256':sha(stdout),'stderr_sha256':sha(stderr),'note':'DHAT malloc/realloc host heap, no mappings/RSS/GPU/device memory. gb at whole-process global peak; never sum individual-site maxima. Deep truncated stacks may omit subset allocations. Not a leak test; ordinary destructor fixture is separate.'}
(DHAT/(case+'-summary.json')).write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({'case':case,'whole_process':record['whole_process'],'native_module':subsets['native_module']}))
