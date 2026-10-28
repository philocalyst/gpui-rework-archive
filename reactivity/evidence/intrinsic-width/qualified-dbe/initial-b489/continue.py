from pathlib import Path
import os,subprocess,json,hashlib,shutil
root=Path('/tmp/gpui-intrinsic-width-sol');out=Path('/tmp/gpui-intrinsic-width-diagnostic');target=Path('/tmp/gpui-intrinsic-width-target');h=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest();before=json.loads((out/'before.json').read_text());assert {n:h(root/n)for n in before}==before
meta=json.loads((out/'metadata.json').read_text());meta['runner_failure']='Initial runner used integration executable name instead of package prefix for fingerprint directory; build and private diagnostic succeeded. Continued from exact fresh:false artifact after revalidating source guard.'
es=[json.loads(s)for s in(out/'build.log').read_text().splitlines()if s.startswith('{')];e=next(e for e in es if e.get('reason')=='compiler-artifact'and e['target']['name']=='intrinsic_text'and e.get('executable'));assert not e['fresh'];p=Path(e['executable']);fp=target/'debug/.fingerprint'/('gpui-'+p.name.rsplit('-',1)[1])/'test-integration-test-intrinsic_text.json';data=json.loads(fp.read_text());assert data['rustflags']==['-C','symbol-mangling-version=v0','--cfg','tokio_unstable'];binary=out/'intrinsic_text-frozen';shutil.copyfile(p,binary);binary.chmod(0o555)
for name,flt in [('todo','public_todo_intrinsic_add_remains_one_line'),('explicit','explicit_ulp_adjacent_widths_keep_real_wrapping_constraints'),('matrix','intrinsic_fractional_captions_preserve_single_line_across_padding_and_dpi')]:
 args=[str(binary),'--exact',flt,'--nocapture','--test-threads=1']
 with(out/(name+'.log')).open('w')as f:code=subprocess.call(args,cwd=root,stdout=f,stderr=subprocess.STDOUT)
 meta[name]={'argv':args,'exit':code,'artifact':e,'binary_sha256':h(binary),'fingerprint':data};print(name,code,flush=True)
after={n:h(root/n)for n in before};assert after==before;(out/'after.json').write_text(json.dumps(after,indent=2)+'\n');meta['source_unchanged']=True;(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
