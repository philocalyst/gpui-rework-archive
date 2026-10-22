#!/usr/bin/env python3
"""Guarded public-owner and exact-table controls; never invokes a compiler."""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import subprocess
import time
HERE=Path(__file__).resolve().parent
PINS={
 'baseline':('/root/gpui-identity-index-base','59467a4136','base'),
 'packed':('/root/gpui-identity-index','8da013d5f8','index'),
 'runs':('/root/gpui-identity-runs','75544537f7','runs'),
}
CODE=['reactivity/crates/gpui/src','reactivity/crates/gpui/Cargo.toml','reactivity/crates/core','reactivity/crates/canvas','reactivity/Cargo.toml','reactivity/Cargo.lock']

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def command(args):return subprocess.check_output(args,text=True)
def source(tag):
 root,pin,_=PINS[tag]
 full=command(['git','-C',root,'rev-parse',pin]).strip()
 subprocess.run(['git','-C',root,'merge-base','--is-ancestor',full,'HEAD'],check=True)
 # Evidence descendants are permitted only when every relevant source bit still
 # equals this source pin. Untracked caller bytes are checked independently.
 assert not command(['git','-C',root,'diff',full,'--']+CODE).strip()
 paths=['reactivity/crates/gpui/src/runtime.rs','reactivity/crates/gpui/src/runtime/input.rs','reactivity/crates/gpui/src/runtime/metadata.rs','reactivity/crates/gpui/src/runtime/scroll.rs','reactivity/crates/gpui/src/runtime/turn.rs','reactivity/Cargo.lock']
 if tag!='baseline':paths.append('reactivity/crates/gpui/src/runtime/identity_index.rs')
 caller=Path(root)/'reactivity/crates/gpui/examples/identity_index_control.rs'
 assert sha(caller)==sha(HERE/'fixtures/owner.rs')
 return {'pin':full,'files':{p:sha(Path(root)/p) for p in paths},'caller':sha(caller)}

def artifacts(path):return [json.loads(line) for line in Path(path).read_text().splitlines() if line.startswith('{')]
def parse(path,kind,tag,capture):
 lines=Path(path).read_text().splitlines()
 if kind=='owner':
  assert f'pin,{tag},{PINS[tag][1]}' in lines
  expected_cost,expected_guards=36,40
 else:
  assert 'pin,8da013d5f8,75544537f7' in lines
  expected_cost,expected_guards=(168,21) if capture else (112,14)
 costs=[next(csv.reader([line])) for line in lines if line.startswith('cost,')]
 guards=[line for line in lines if line.startswith('guard,')]
 assert len(costs)==expected_cost,(path,len(costs))
 assert len(guards)==expected_guards,(path,len(guards))
 return sorted(guards)

def freeze():
 old=json.loads((HERE/'phase-one-frozen.json').read_text())
 for path,checksum in old['source_files'].items():assert sha(path)==checksum,path
 for artifact in old['artifacts'].values():
  for path,checksum in artifact['files'].items():assert sha(path)==checksum,path
 result={'runner':sha(__file__),'sources':{},'executables':{},'files':{},'fixtures':{p.name:sha(p) for p in (HERE/'fixtures').iterdir()}}
 oracles=[]
 for tag,(root,pin,prefix) in PINS.items():
  result['sources'][tag]=source(tag)
  build=Path(f'/tmp/gpui-identity-{prefix}-'+('release-build.jsonl' if tag=='runs' else 'final-build.jsonl'))
  producer=Path(f'/tmp/gpui-identity-{prefix}-release-build.jsonl')
  libs=[r for r in artifacts(producer) if r.get('reason')=='compiler-artifact' and r['target']['name']=='gpui' and r['target']['kind']==['lib']]
  assert len(libs)==1 and not libs[0]['fresh']
  callers=[r for r in artifacts(build) if r.get('reason')=='compiler-artifact' and r['target']['name']=='identity_index_control']
  assert len(callers)==1 and not callers[0]['fresh'] and callers[0]['profile']['opt_level']=='3'
  caller=callers[0]
  assert str(Path(root)/'reactivity/crates/gpui') in caller['package_id']
  binary=caller['executable'];result['executables'][tag]={'path':binary,'sha256':sha(binary)}
  for path in [build,producer,*libs[0]['filenames']]:result['files'][str(path)]=sha(path)
  oracles.append(parse(f'/tmp/gpui-identity-{prefix}-large-guard.log','owner',tag,False))
 assert oracles[0]==oracles[1]==oracles[2]
 build='/tmp/gpui-identity-tables-runs-build.jsonl'
 bins=[r for r in artifacts(build) if r.get('reason')=='compiler-artifact' and r['target']['name']=='identity_tables']
 assert len(bins)==1 and not bins[0]['fresh'] and bins[0]['profile']['opt_level']=='3'
 result['executables']['tables']={'path':bins[0]['executable'],'sha256':sha(bins[0]['executable'])}
 result['files'][build]=sha(build)
 for path in ['/tmp/gpui-identity-tables-runs/src/main.rs','/tmp/gpui-identity-tables-runs/Cargo.toml','/tmp/gpui-identity-tables-runs/Cargo.lock']:result['files'][path]=sha(path)
 assert sha('/tmp/gpui-identity-tables-runs/src/main.rs')==sha(HERE/'fixtures/tables_runs.rs')
 parse('/tmp/gpui-identity-tables-runs-guard.log','tables','tables',False)
 (HERE/'frozen.json').write_text(json.dumps(result,indent=2)+'\n')
 print('FROZEN')

def guard():
 frozen=json.loads((HERE/'frozen.json').read_text())
 assert frozen['runner']==sha(__file__)
 assert frozen['fixtures']=={p.name:sha(p) for p in (HERE/'fixtures').iterdir()}
 for tag in PINS:assert source(tag)==frozen['sources'][tag]
 for binary in frozen['executables'].values():assert sha(binary['path'])==binary['sha256']
 for path,checksum in frozen['files'].items():assert sha(path)==checksum,path
 return frozen

def environment():
 processes=command(['ps','-eo','pid,stat,pcpu,comm'])
 for line in processes.splitlines()[1:]:
  fields=line.split()
  if len(fields)==4 and not any(state in fields[1] for state in 'TZ'):
   assert not fields[3].startswith(('cargo','rustc','clippy','zig','rust-lld')),line
 return {'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'processes':processes,**{f'{kind}_pressure':Path(f'/proc/pressure/{kind}').read_text() for kind in ['cpu','io','memory']}}

def capture(output):
 assert os.environ.get('IDENTITY_INDEX_QUIET')=='approved','wait for coordinated START'
 frozen=guard();assert 2 in os.sched_getaffinity(0);os.sched_setaffinity(0,{2})
 output.mkdir(parents=True,exist_ok=False)
 (output/'frozen.json').write_text(json.dumps(frozen,indent=2)+'\n')
 (output/'before.json').write_text(json.dumps(environment(),indent=2)+'\n')
 end=time.monotonic()+180;elapsed=[]
 for kind,rounds in [('owner',3),('tables',4)]:
  for number in range(rounds):
   tags=list(PINS) if kind=='owner' else ['tables']
   tags=tags[number%len(tags):]+tags[:number%len(tags)]
   oracle=None
   for tag in tags:
    guard();start=time.monotonic();assert start<end
    print('START',kind,number+1,tag,flush=True)
    path=output/f'{kind}-{number+1}-{tag}.txt';env=dict(os.environ,TABLE_ROTATION=str(number))
    with path.open('w') as stream:
     result=subprocess.run([frozen['executables'][tag]['path'],'capture'],env=env,stdout=stream,stderr=subprocess.STDOUT,timeout=end-start)
    seconds=time.monotonic()-start;assert result.returncode==0,path
    guard();current=parse(path,kind,tag,True)
    if oracle is None:oracle=current
    assert current==oracle
    elapsed.append({'kind':kind,'round':number+1,'variant':tag,'wall_seconds':seconds})
    print('FINISHED',kind,number+1,tag,f'{seconds:.4f}',flush=True)
 (output/'elapsed.json').write_text(json.dumps(elapsed,indent=2)+'\n')
 (output/'after.json').write_text(json.dumps(environment(),indent=2)+'\n')
 print('ALL_POSTGUARDS_PASS',flush=True)

if __name__=='__main__':
 parser=argparse.ArgumentParser();parser.add_argument('mode',choices=['freeze','guard','capture']);parser.add_argument('--output',type=Path);args=parser.parse_args()
 if args.mode=='freeze':freeze()
 elif args.mode=='guard':guard();print('ALL_GUARDS_PASS')
 else:assert args.output is not None;capture(args.output)
