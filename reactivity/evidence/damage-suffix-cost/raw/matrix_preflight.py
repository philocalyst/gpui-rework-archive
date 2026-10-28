from pathlib import Path
import json,subprocess,shutil,os
from guard import sha,guard,frozen
r=Path(__file__).parent
assert not guard();frozen()
a=json.loads((r/'matrix-artifacts.json').read_text());spec=json.loads((r/'cost-definition.json').read_text());envs={}
for v,x in a.items():
 g=Path(x['gate']);env=json.loads((g/'environment.json').read_text());envs[v]={k:y for k,y in env.items() if k.startswith(('RUST','CARGO_PROFILE_','CARGO_ENCODED_RUSTFLAGS'))}
 for stage in ['build','test']:
  cmd=json.loads((g/(stage+'.status.json')).read_text())['command'];assert all(t in cmd for t in ['+nightly-2026-10-23','--release','--locked','--offline','checksum-freshness'])
assert envs['baseline']==envs['candidate']
for phase,count in [('qualification',168),('allocations',56)]:
 d=r/('matrix-'+phase);assert json.loads((d/'guard-after.json').read_text())==[] and not (d/'failure.txt').exists()
 assert json.loads((d/'artifacts.json').read_text())==a
 assert len(json.loads((d/'results.json').read_text()))==count
allocation=json.loads((r/'allocation-verdict.json').read_text());assert allocation['all_pass'] and allocation['source_sha256']==sha(r/'matrix-allocations/results.json')
headers=json.loads((r/'headers/summary.json').read_text())
for v in a:
 for k,n in spec['header_gates'].items():assert headers[v]['TextPatch' if k=='TextPatch_native' else k]==n
free=shutil.disk_usage('/home/user').free;assert free>8*1024**3
procs=subprocess.check_output(['ps','-eo','pid,etime,pcpu,comm'],text=True)
assert not any(x.split()[-1] in ['cargo','rustc','rust-lld','ld.lld','gcc','clang','cc1','clippy-driver'] for x in procs.splitlines()[1:])
receipt=dict(artifacts={k:{'compiled_source':v['source'],'current_source':v['current_source'],'sha256':v['sha256']} for k,v in a.items()},compiler_environment=envs,allocation_gate=allocation,headers=headers,free_bytes=free,processes=procs,runner=json.loads((r/'runner-receipt.json').read_text()),driver=json.loads((r/'driver.json').read_text()),cache_environment={k:os.environ.get(k) for k in ['MESA_SHADER_CACHE_DISABLE','MESA_SHADER_CACHE_DIR','XDG_CACHE_HOME']},limits='Complete owner through native bridge/GPU completion/ACK; fresh objects, warm disk shader cache. Invoking-thread allocations. Private X11/software Vulkan. No hardware/scanout/ZGX victory.')
assert not (r/'matrix-preflight.json').exists();(r/'matrix-preflight.json').write_text(json.dumps(receipt,indent=2));print('All fixed qualification/allocation/work/header/source/artifact gates ready for timing.')
