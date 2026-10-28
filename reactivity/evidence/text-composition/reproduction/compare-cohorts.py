from pathlib import Path
import argparse,json,re
p=argparse.ArgumentParser();p.add_argument('--artifacts',type=Path,required=True);p.add_argument('--out',type=Path,required=True);a=p.parse_args()
control=Path('/tmp/gpui-text-metric-scale-sol/reactivity/evidence/text-metric-scale')
def parse(path,tag):
 out={}
 for line in path.read_text().splitlines():
  if tag not in line:continue
  words=dict(word.split('=',1) for word in line[line.index(tag)+len(tag):].split() if '=' in word)
  key=(words.get('case'),words.get('scale'))
  out[key]={k:v for k,v in words.items() if k not in ['case','scale','prepare_ns','render_ns','expansion_ns']}
 return out
candidate_logs=list(a.artifacts.glob('*text_metric_scale_probe/stdout.log'));assert len(candidate_logs)==1
old=parse(control/'cohorts-candidate.log','METRIC_RUN ');new=parse(candidate_logs[0],'METRIC_RUN ')
assert len(old)==48 and len(new)==48,(len(old),len(new))
differences=[];checks=0
for k in old:
 if k not in new:differences.append({'case':k,'missing':True});continue
 for field in old[k].keys()|new[k].keys():
  checks+=1
  if old[k].get(field)!=new[k].get(field):differences.append({'case':k,'field':field,'old':old[k].get(field),'new':new[k].get(field)})
oldgpu=json.loads((control/'gpu-equality.json').read_text())['cases']
newgpu=[]
for log in a.artifacts.glob('*render/stdout.log'):
 for line in log.read_text().splitlines():
  if 'TEXT_PACKET ' in line:newgpu.append(line.split('TEXT_PACKET ',1)[1])
report={'reference_source':'7c9fc3cf775544d4082fe7c6ce3e0bb8a3a0a407','cohort_cases':len(new),'non_timing_fields_compared':checks,'cohort_differences':differences,'GPU_packet_readback_cases':len(newgpu),'GPU_packet_readback_exact_match':newgpu==oldgpu,'GPU_control':oldgpu,'GPU_candidate':newgpu,'no_latency_inference':True}
a.out.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k not in ['GPU_control','GPU_candidate']}))
