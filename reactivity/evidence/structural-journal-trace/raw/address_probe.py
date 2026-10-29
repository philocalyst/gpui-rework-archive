"""Diagnostic topology model on live trace output, not a production journal adapter.
Compare existing absolute preorder parents with relative parent displacements.
Charge the complete trace/reconstruction boundary separately; do not claim locality.
"""
from pathlib import Path
import json,sys
root=Path(__file__).parent/sys.argv[1];d=json.loads((root/'trace/trace.json').read_text());old={};results=[]
def records(nodes,relative):
 return {n['identity']:(n['identity'],None if n['parent'] is None else n['index']-n['parent'] if relative else n['parent'],n['kind']) for n in nodes}
for row in d['results']:
 case=row['case'];op=row['operation'];nodes=row['observation']['logical']
 if op=='failed-newer':continue
 if op=='initial':old[case]=nodes;continue
 before=old[case];old_index={n['identity']:n['index'] for n in before};absolute_old=records(before,False);relative_old=records(before,True);absolute_new=records(nodes,False);relative_new=records(nodes,True)
 changed_abs=[i for i,v in absolute_new.items() if absolute_old.get(i)!=v];changed_rel=[i for i,v in relative_new.items() if relative_old.get(i)!=v]
 runs=[]
 for i,n in enumerate(nodes):
  source=old_index.get(n['identity']);kind='old' if source is not None else 'new'
  if runs and runs[-1]['kind']==kind and (kind=='new' or source==runs[-1]['old_start']+runs[-1]['len']):runs[-1]['len']+=1
  else:runs.append(dict(kind=kind,new_start=i,old_start=source,len=1))
 # Independent reconstruction of identity/order, without treating correspondence
 # as a license to reuse paint, layout, resource bytes or old absolute links.
 replay=[]
 for run in runs:
  replay += ([n['identity'] for n in before[run['old_start']:run['old_start']+run['len']]] if run['kind']=='old' else [n['identity'] for n in nodes[run['new_start']:run['new_start']+run['len']]])
 assert replay==[n['identity'] for n in nodes]
 # Exact topology reconstruction from index-relative displacements.
 for n in nodes:
  rec=relative_new[n['identity']];parent=None if rec[1] is None else n['index']-rec[1];assert parent==n['parent']
 results.append(dict(case=case,operation=op,input_nodes_walked=len(before)+len(nodes),absolute_parent_record_changes=len(changed_abs),relative_parent_record_changes=len(changed_rel),identity_order_runs=runs,run_count=len(runs),scope='diagnostic identity/kind/parent topology only; does not cover full Node fields, layout, scene records, resources or GPU publication'))
 old[case]=nodes
(root/'address-probe.json').write_text(json.dumps(results,indent=2))
for r in results:print(r['case'],r['operation'],'absolute/relative changes',r['absolute_parent_record_changes'],r['relative_parent_record_changes'],'runs',r['run_count'],'diagnostic nodes walked',r['input_nodes_walked'])
