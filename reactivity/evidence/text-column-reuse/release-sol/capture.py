from pathlib import Path
import argparse,datetime,hashlib,json,os,statistics,subprocess,time
out=Path(__file__).parent
root=Path('/tmp/gpui-text-column-release-sol')
def digest(path):
 with path.open('rb') as stream:return hashlib.file_digest(stream,'sha256').hexdigest()
def git(*args):return subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),*args],text=True)
def source_hashes():
 names=git('ls-files','-z','--','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/crates','reactivity/vendor').split('\0')
 return {name:digest(root/name) for name in names if name and (root/name).is_file()}
parser=argparse.ArgumentParser();parser.add_argument('--guard-only',action='store_true');parser.add_argument('--quiet-go');args=parser.parse_args()
registration=json.loads((out/'registration.json').read_text());build=json.loads((out/'build-metadata.json').read_text())
def guards():
 assert build.get('preflight_equal')
 assert digest(out/'registration.json')==build['registration_sha256']
 assert git('rev-parse','HEAD').strip()==registration['baseline']
 assert not git('status','--porcelain')
 assert source_hashes()==build['variants']['normal-baseline']['files_before']==build['variants']['codegen-baseline']['files_before']
 assert build['variants']['normal-candidate']['files_before']==build['variants']['codegen-candidate']['files_before']
 for filename,h in build['fixture'].items():assert digest(Path(filename))==h
 for name,variant in build['variants'].items():
  assert variant['sources_unchanged'] and variant['fixture_unchanged'] and variant['binary_unchanged']
  assert digest(Path(variant['binary']['path']))==variant['binary']['sha256']
  expected=registration['rootflags']+(registration['codegen_appends'] if name.startswith('codegen') else [])
  assert variant['rustflags']==expected
 assert 0 in os.sched_getaffinity(0)
def competitors():
 rows=subprocess.check_output(['ps','-eo','pid=,comm=,args='],text=True).splitlines();bad=[]
 for row in rows:
  fields=row.strip().split(None,2)
  if len(fields)<2:continue
  if fields[1] in {'cargo','rustc','rust-lld','cc','clang','clang++','gcc','g++','ninja','make','cmake','perf','valgrind','gprof','nim','zig'}:bad.append(row.strip())
 return bad
guards()
expected={}
for case in registration['cases']:
 for lane in ['update','typed']:
  path=out/f'normal-baseline-{case["case"]}-{lane}-preflight.log';records=[json.loads(s) for s in path.read_text().splitlines()]
  final=next(x for x in records if x['stage']=='sample-final');expected[(case['case'],lane)]={k:final[k] for k in ['parts','texts','checksum']}
if args.guard_only:
 print(json.dumps({'ready':True,'normal_variants':{k:v['binary'] for k,v in build['variants'].items() if k.startswith('normal')},'pending_competitors':competitors(),'capture_cap_seconds':300},indent=2));raise SystemExit
assert args.quiet_go,'Explicit root quiet GO is required; guard-only never runs samples.'
assert not (out/'capture.json').exists(),'One capture only; never overwrite an existing campaign.'
assert not competitors(),competitors()
meta={'quiet_go':args.quiet_go,'started_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'registration_sha256':digest(out/'registration.json'),'build_metadata_sha256':digest(out/'build-metadata.json'),'capture_runner_sha256':digest(Path(__file__)),'rows':[],'pairs':[],'status':'running'}
path=out/'capture.json'
def save():path.write_text(json.dumps(meta,indent=2)+'\n')
save();start=time.monotonic();deadline=start+300
try:
 for pair in range(7):
  for case in registration['cases']:
   for lane in ['update','typed']:
    guards();assert not competitors(),competitors()
    order=['baseline','candidate'] if pair%2==0 else ['candidate','baseline'];measurements={}
    for label in order:
     remaining=deadline-time.monotonic();assert remaining>0,'hard 300s cap'
     binary=build['variants']['normal-'+label]['binary'];assert digest(Path(binary['path']))==binary['sha256']
     argv=['taskset','-c','0',binary['path'],'sample',case['case'],lane]
     run=subprocess.run(argv,cwd=root,env=os.environ,text=True,capture_output=True,timeout=remaining)
     name=f'pair{pair}-{case["case"]}-{lane}-{label}'
     (out/(name+'.stdout')).write_text(run.stdout);(out/(name+'.stderr')).write_text(run.stderr)
     assert run.returncode==0,(name,run.returncode)
     rows=[json.loads(s) for s in run.stdout.splitlines()];assert len(rows)==1;row=rows[0]
     assert row['case']==case['case'] and row['lane']==lane and row['cycles']==case['cycles_per_sample']
     assert {k:row[k] for k in expected[(case['case'],lane)]}==expected[(case['case'],lane)]
     updates=case['cycles_per_sample']*(2 if case['case']=='pending32k' else 1);warmup=2 if case['case']=='pending32k' else 1
     assert row['updates']==updates and row['source']==warmup+updates and row['presentation']==row['source'] and not row['prepared']
     if lane=='typed' and case['case']!='contract32k':assert row['descriptions']==0
     record={'pair':pair,'variant':label,'argv':argv,**row};meta['rows'].append(record);measurements[label]=row['nanoseconds'];save()
    guards();assert not competitors(),competitors()
    meta['pairs'].append({'pair':pair,'case':case['case'],'lane':lane,'candidate_over_baseline':measurements['candidate']/measurements['baseline']});save()
 summary=[]
 for case in registration['cases']:
  for lane in ['update','typed']:
   values=[x['candidate_over_baseline'] for x in meta['pairs'] if x['case']==case['case'] and x['lane']==lane];assert len(values)==7
   ratio=statistics.median(values);summary.append({'case':case['case'],'lane':lane,'paired_ratios':values,'median_candidate_over_baseline':ratio,'no_regression_pass':ratio<=1.03})
 meta['summary']=summary;meta['no_regression_pass']=all(x['no_regression_pass'] for x in summary);meta['speed_gate_pass']=meta['no_regression_pass'] and any(x['median_candidate_over_baseline']<=.95 for x in summary if x['case'] not in ['tiny1','small32']);meta['status']='complete';meta['sources_and_binaries_unchanged']=True;save()
 print(json.dumps({'status':'complete','no_regression_pass':meta['no_regression_pass'],'speed_gate_pass':meta['speed_gate_pass'],'summary':summary},indent=2))
except BaseException as error:
 meta['status']='incomplete';meta['failure']=repr(error);save();raise
