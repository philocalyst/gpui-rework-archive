from pathlib import Path
import os,subprocess,json,hashlib,shutil
root=Path('/tmp/gpui-intrinsic-width-sol');out=Path('/tmp/gpui-intrinsic-width-diagnostic');target=Path('/tmp/gpui-intrinsic-width-target');env=dict(os.environ);env.pop('RUSTFLAGS',None);env.pop('CARGO_ENCODED_RUSTFLAGS',None);env.update(CARGO_BUILD_JOBS='1',CARGO_TARGET_DIR=str(target));h=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest();meta={'head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip(),'commands':[],'timing_claim':False};meta['rustc']=subprocess.check_output(['rustc','-vV'],env=env,text=True)
names=subprocess.check_output(['git','ls-files','-z','--','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/crates','reactivity/vendor','reactivity/evidence/intrinsic-width'],cwd=root).decode().split('\0');before={n:h(root/n)for n in names if n and(root/n).is_file()};(out/'before.json').write_text(json.dumps(before,indent=2)+'\n')
def run(name,args):
 m={'name':name,'argv':args};meta['commands'].append(m)
 with(out/(name+'.log')).open('w') as f:code=subprocess.call(args,cwd=root,env=env,stdout=f,stderr=subprocess.STDOUT)
 m['exit']=code;(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n');print(name,code,flush=True);return code
code=run('build',['cargo','test','--manifest-path','reactivity/Cargo.toml','--locked','-p','gpui','--lib','--test','intrinsic_text','--no-run','--message-format=json-render-diagnostics']);assert code==0
es=[json.loads(s)for s in(out/'build.log').read_text().splitlines()if s.startswith('{')]
for label,name,flt,ignored in [('diagnostic','gpui','runtime::intrinsic_width_probe::intrinsic_content_width_round_trip',True),('todo','intrinsic_text','public_todo_intrinsic_add_remains_one_line',False),('explicit','intrinsic_text','explicit_ulp_adjacent_widths_keep_real_wrapping_constraints',False),('matrix','intrinsic_text','intrinsic_fractional_captions_preserve_single_line_across_padding_and_dpi',False)]:
 e=next(e for e in es if e.get('reason')=='compiler-artifact'and e['target']['name']==name and e.get('executable'));assert not e['fresh'];p=Path(e['executable']);fingerprint=target/'debug/.fingerprint'/('gpui-'+p.name.rsplit('-',1)[1])/('test-lib-gpui.json'if name=='gpui'else'test-integration-test-intrinsic_text.json');data=json.loads(fingerprint.read_text());assert data['rustflags']==['-C','symbol-mangling-version=v0','--cfg','tokio_unstable'];binary=out/(name+'-frozen')
 if not binary.exists():shutil.copyfile(p,binary);binary.chmod(0o555)
 meta[label]={'artifact':e,'binary_sha256':h(binary),'binary_bytes':binary.stat().st_size,'fingerprint':data};run(label,[str(binary),'--exact',flt,'--nocapture','--test-threads=1']+(['--ignored']if ignored else[]))
after={n:h(root/n)for n in before};assert after==before;(out/'after.json').write_text(json.dumps(after,indent=2)+'\n');meta['source_unchanged']=True;(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
