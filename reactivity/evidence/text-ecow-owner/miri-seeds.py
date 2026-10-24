import pathlib,subprocess,json,os,sys,hashlib
source=pathlib.Path('/tmp/gpui-ecow-miri-sol'); out=pathlib.Path('/tmp/gpui-ecow-miri-seeds'); out.mkdir(exist_ok=False)
pin=subprocess.check_output(['git','-C',str(source),'rev-parse','HEAD'],text=True).strip(); rows=[]
for model,extra in [('stacked',''),('tree',' -Zmiri-tree-borrows')]:
 for seed in range(8):
  name=f'{model}-{seed}'; env=dict(os.environ,MIRIFLAGS=f'-Zmiri-strict-provenance -Zmiri-seed={seed}{extra}')
  result=subprocess.run([sys.executable,'/tmp/gpui-run-frozen-gate-root.py','--source',str(source),'--pin',pin,'--out',str(out/name),'--timeout','120','--','cargo','miri','test','--offline','--locked','--','--test-threads=1','--skip','empty_spare_capacity_and_full_buffers_keep_exact_allocation_and_bits'],env=env)
  data=json.loads((out/name/'result.json').read_text()); rows.append({'name':name,'exit':result.returncode,'result':data}); (out/'results.json').write_text(json.dumps(rows,indent=2)+'\n')
  assert result.returncode==0 and data['passed']==3 and data['failed']==0 and data['guards_match'], rows[-1]
print(json.dumps({'invocations':len(rows),'tests_passed':sum(r['result']['passed'] for r in rows),'strict_provenance':True,'models':['stacked','tree']}))
