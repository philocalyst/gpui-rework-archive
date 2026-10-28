from pathlib import Path
import subprocess,json,hashlib,re
r=Path(__file__).parent;w=Path('/home/user/gpui-region-batch-lab');source='1f16b73c56f10044a4186c90fb69ffe3d4047ac6';assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==source;assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
receipts={}
for name,stages in [('boundary-admission',['test','clippy']),('offline-cached',['test','clippy']),('full-native',['build','test','port','clippy']),('minimal-library',['unit-build','port','clippy']),('native-checks',[f'native-{i}' for i in range(6)]+['native-list-default','native-overscan','native-list-controlled','native_atspi_ime_cjk_preview_old_candidate_ack_and_commit','native_atspi_ime_explicit_line_height_preview_ack_and_commit']),('minimal-native-checks',['native-todo','native-list-default','native-overscan','native-list-controlled'])]:
 d=r/name;assert json.loads((d/'guard-after.json').read_text())==[];part={}
 for stage in stages:
  q=json.loads((d/(stage+'.status.json')).read_text());assert q['exit']==0;out=(d/(stage+'.out')).read_text();totals=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',out);part[stage]={'status':q,'passed':sum(int(x[0]) for x in totals),'ignored':sum(int(x[2]) for x in totals)}
 receipts[name]=part
 if (d/'inputs.json').exists():
  for path,digest in json.loads((d/'inputs.json').read_text()).items():assert hashlib.sha256((w/path).read_bytes()).hexdigest()==digest
for f in ['reactivity/crates/gpu/src/shader.rs','reactivity/crates/gpui/src/native/gpu.rs']:
 a=subprocess.check_output(['git','show','c965a893364b46f965c83d10e2cf94a46dac1304:'+f],cwd=w);b=(w/f).read_bytes();assert a==b,f
receipts['inherited']=json.loads((r/'inherited-source-equality.json').read_text());receipts['shader_receipt']='generated-shaders/receipt.json';receipts['source']=source
receipts['negative_pending']=not (r/'omit-instance/guard-after.json').exists()
receipts['limits']='Software Vulkan/private X11 correctness only. No timing, hardware, presentation scanout or ZGX win. Full owner/GPU cost matrix and incomplete-coverage mutant still required before performance judgment.'
(r/'qualification-progress.json').write_text(json.dumps(receipts,indent=2));print({k:{s:v['passed'] for s,v in d.items()} for k,d in receipts.items() if k in ['boundary-admission','offline-cached','full-native','minimal-library','native-checks','minimal-native-checks']})
