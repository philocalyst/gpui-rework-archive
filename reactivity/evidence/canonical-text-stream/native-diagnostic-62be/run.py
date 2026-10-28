from pathlib import Path
import hashlib,json,os,subprocess
base=Path(__file__).parent
reg=json.loads((base/'registration.json').read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert not (base/'results').exists()
for name,digest in reg['diagnostic_sources_sha256'].items():assert sha(base/name)==digest
for label,item in reg['binaries'].items():assert sha(Path(item['path']))==item['sha256']
assert sha(Path(reg['campaign_registration_path']))==reg['campaign_registration_sha256']
results=base/'results';results.mkdir()
with (results/'strace-tool-probe.log').open('w') as log:
    probe=subprocess.run([reg['strace'],'-o',str(results/'strace-probe.trace'),'/run/current-system/sw/bin/true'],stdout=log,stderr=subprocess.STDOUT)
# Availability choice is shared by both frozen commands, decided before either native invocation.
reg['strace_available_for_both']=probe.returncode==0
reg['tool_probe_exit']=probe.returncode
(base/'registration.json').write_text(json.dumps(reg,indent=2)+'\n')
# This resolved registration (including tool capability) is frozen before either native launch.
(results/'resolved-registration.json').write_bytes((base/'registration.json').read_bytes())
print('resolved diagnostic registration sha256',sha(base/'registration.json'),flush=True)
for label in ['baseline','candidate']:
    with (results/(label+'-runner.log')).open('w') as log:
        result=subprocess.run(reg['outer_commands'][label],stdout=log,stderr=subprocess.STDOUT,timeout=110)
    print(label,'wrapper exit',result.returncode,flush=True)
    assert sha(Path(reg['binaries'][label]['path']))==reg['binaries'][label]['sha256']
summary={'mode':'NON-TIMING diagnostic, never append to failed campaign','resolved_registration_sha256':sha(base/'registration.json'),'binaries_unchanged':True,'results':{label:json.loads((results/label/'metadata.json').read_text()) for label in ['baseline','candidate']}}
(results/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
