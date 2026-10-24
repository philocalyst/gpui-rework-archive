from pathlib import Path
import json,re
p=Path('/tmp/gpui-delivery-isolation-captures');reports={}
for label,fixture in [('cost-a2','ordinary_control'),('cost-b','ordinary_control'),('cost-a2','field_control'),('cost-b','field_control'),('cost-c','field_control')]:
 stem=label+'-'+fixture;a=json.loads((p/(stem+'-analysis.json')).read_text());raw=(p/(stem+'.asm')).read_text();report={}
 starts=list(re.finditer(r'^([0-9a-f]+) <(.+)>:\n',raw,re.M))
 for idx,m in enumerate(starts):
  name=m[2]
  if name not in a['functions']:continue
  v=a['functions'][name]
  if not v['symbol']:continue
  body=raw[m.end():starts[idx+1].start() if idx+1<len(starts) else len(raw)]
  ins={}
  for line in body.splitlines():
   z=re.match(r'\s*([0-9a-f]+):\s+(?:[0-9a-f]{2} )+\s*\t([a-z][a-z0-9]*)\s*(.*)',line)
   if z:ins[int(z[1],16)]=(z[2],z[3])
  if not ins:continue
  keys=sorted(ins);following=dict(zip(keys,keys[1:]));pending=[(keys[0],0)];seen=set();peak=0;unknown=[]
  while pending:
   addr,depth=pending.pop()
   if (addr,depth) in seen:continue
   seen.add((addr,depth))
   if len(seen)>len(ins)*8:unknown.append('multiple/dynamic stack states');break
   op,args=ins[addr]
   if op.startswith('push'):depth+=8
   elif op.startswith('pop'):depth-=8
   elif op in ['sub','add'] and args.endswith(',%rsp'):
    z=re.match(r'\$0x([0-9a-f]+),%rsp',args)
    if z:depth+=(1 if op=='sub' else -1)*int(z[1],16)
    else:unknown.append(args)
   elif '%rsp' in args and args.endswith(',%rsp') and op not in ['cmp','test']:
    unknown.append(op+' '+args)
   peak=max(peak,depth)
   if op.startswith('ret') or op in ['ud2','hlt']:continue
   if op.startswith('j'):
    z=re.match(r'([0-9a-f]+) ',args);target=int(z[1],16) if z else None
    if target in ins:pending.append((target,depth))
    if op=='jmp':continue
   if addr in following:pending.append((following[addr],depth))
  report[name]={'code_bytes':v['symbol']['bytes'],'reachable_own_stack_bytes_excluding_return_address':peak,'unknown_stack_instructions':sorted(set(unknown)),'direct_calls':[x for x in v['calls'] if '\tcall' in x]}
 (p/(stem+'-frames.json')).write_text(json.dumps(report,indent=2)+'\n');reports[stem]=report
# Intentionally a compact boundary table; full per-function and call evidence remain separate.
for stem,report in reports.items():
 print(stem)
 for name,v in report.items():
  selected=(('>>::deliver_ready' in name) or name in ['ordinary_control::ordinary','ordinary_control::deliver','ordinary_control::clone_drop','ordinary_control::send','ordinary_control::transport'] or ('ordinary_control' in name and '>>::update::' in name) or (name.startswith('field_control::deliver') or name=='field_control::bind') or ('LaneSet<ordinary_control::Page>' in name and any(name.endswith('::'+s) for s in ['apply','stage','close'])) or ('Remote<u64>' in name and any(name.endswith('::'+s) for s in ['bounded','try_send','clone','drop'])))
  if selected:print(name[:125],v['code_bytes'],v['reachable_own_stack_bytes_excluding_return_address'],v['unknown_stack_instructions'])
