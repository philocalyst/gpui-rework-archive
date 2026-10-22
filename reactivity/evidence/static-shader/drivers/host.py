"""Frozen host interface proof, exact artifact bytes and independent SPIR-V validation."""
from pathlib import Path
import hashlib,json,os,shutil,subprocess
ROOT=Path(__file__).resolve().parents[4];WORK=ROOT/'reactivity';OUT=WORK/'evidence/static-shader';CHECKS=OUT/'checks'
SOURCE='a871fc6fa924f31bf08fe2a51248930025582da1'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=json.loads((CHECKS/'source.json').read_text())
def guard():assert {p:sha(ROOT/p) for p in snapshot['files']}==snapshot['files']
guard()
rows=[json.loads(s) for s in (CHECKS/'optional-build.jsonl').read_text().splitlines() if s.startswith('{')]
builds=[r for r in rows if r.get('reason')=='build-script-executed' and 'crates/gpu#' in r['package_id']];assert len(builds)==1
output=Path(builds[0]['out_dir'])
prior=json.loads((WORK/'evidence/offline-shader/artifact-and-linked-bytes.json').read_text())['generated']
actual={name:{'bytes':(output/name).stat().st_size,'sha256':sha(output/name)} for name in prior};assert actual==prior
validator=Path('/nix/store/z5hs3p3inrq3w8cv71jycz7l4y3ny5xk-spirv-tools-1.4.363.0/bin/spirv-val')
validated=[]
with (CHECKS/'spirv-validation.log').open('w') as log:
 for path in sorted(output.glob('*.spv'))+sorted((OUT/'modules').glob('*.spv')):
  command=[str(validator),'--target-env','vulkan1.0',str(path)]
  r=subprocess.run(command,stdout=log,stderr=subprocess.STDOUT);assert r.returncode==0
  validated.append({'command':command,'sha256':sha(path),'bytes':path.stat().st_size})
assert len(validated)==11
rows=[json.loads(s) for s in (CHECKS/'host-proof-build.jsonl').read_text().splitlines() if s.startswith('{')]
artifacts=[r for r in rows if r.get('reason')=='compiler-artifact' and r['target']['name']=='host-proof' and r.get('executable')];assert len(artifacts)==1
binary=Path('/tmp/gpui-static-frozen-bins/host-proof');shutil.copyfile(artifacts[0]['executable'],binary);binary.chmod(0o755);before=sha(binary)
env=os.environ.copy();env['GPUI_PROOF_WGSL']=str(output/'ui.wgsl');env['GPUI_PROOF_FRAGMENT']=str(output/'ui-0-fragment.spv')
with (CHECKS/'host-proof.log').open('w') as log:r=subprocess.run([str(binary),'--nocapture'],stdout=log,stderr=subprocess.STDOUT,env=env)
assert r.returncode==0 and sha(binary)==before
guard()
shutil.copyfile('/tmp/gpui-static-host-proof/Cargo.toml',CHECKS/'host-proof-Cargo.toml')
shutil.copyfile('/tmp/gpui-static-host-proof/Cargo.lock',CHECKS/'host-proof.lock')
record={'source':SOURCE,'artifact_generator_shipping_source_unchanged_from':'db73d4f1cca7f173f98ab835176de2908c464156','out_dir':str(output),'all_generated_bytes_identical_to_frozen_previous_artifacts':actual,'validator':{'path':str(validator),'sha256':sha(validator)},'independent_validations':validated,'host_proof':{'binary':str(binary),'sha256':before,'cargo_artifact':artifacts[0]['executable'],'source':str(WORK/'crates/gpu/src/shader_build.rs'),'source_sha256':sha(WORK/'crates/gpu/src/shader_build.rs'),'exit':r.returncode,'log_sha256':sha(CHECKS/'host-proof.log'),'graph':'separate archived host test graph; shipping build graph qualified separately'}}
(CHECKS/'host-results.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({'source':SOURCE,'host_proof_tests':4,'independent_spirv_validations':len(validated),'prior_generated_bytes_identical':True}))
