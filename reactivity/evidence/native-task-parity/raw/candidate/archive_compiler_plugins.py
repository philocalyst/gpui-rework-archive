from pathlib import Path
import json,subprocess,hashlib,gzip,shutil
r=Path(__file__).parent;archive=Path('/home/user/gpui-completed-test-binaries-archive');archive.mkdir(exist_ok=True)
prefixes=['gpui-list-source','gpui-text-session','gpui-sparse-text','gpui-cold-trim','gpui-tree-admitted','gpui-question-source-set','gpui-gpu-text-gated','gpui-gpu-text-tiles','gpui-gpu-text-packet','gpui-scroll-output','gpui-list-overscan','gpui-line-height','gpui-sparse-batch','gpui-sparse-outline','gpui-glyph-damage','gpui-glyph-damage-control','gpui-glyph-damage-predecessor','gpui-glyph-damage-bounds','gpui-glyph-damage-negative']
ps=subprocess.check_output(['ps','-eo','comm=,args='],text=True);record=dict(reason='Archive regenerable Rust compiler plugin shared objects from completed inactive experiments, identified by exported __rustc_proc_macro_decls. These are not runtime application libraries. Verify decompressed SHA256 and journal preservation before removing each cache path; preserve all source, evidence, runtime/measured executables and generated shaders.',free_before=shutil.disk_usage('/home/user').free,sources={},files=[])
for prefix in prefixes:
 w=Path('/home/user/'+prefix+'-lab');t=Path('/home/user/'+prefix+'-target')
 if not w.exists() or not t.exists():continue
 assert not any(l.strip().split()[0] in ['cargo','rustc','clippy-driver'] and str(t) in l for l in ps.splitlines())
 assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();record['sources'][str(w)]=subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()
 for p in t.rglob('*.so'):
  if '__rustc_proc_macro_decls' not in subprocess.check_output(['nm','-D',str(p)],text=True,stderr=subprocess.DEVNULL):continue
  data=p.read_bytes();h=hashlib.sha256(data).hexdigest();saved=archive/(h+'.gz')
  if not saved.exists():
   tmp=saved.with_suffix('.gz.partial');tmp.write_bytes(gzip.compress(data,compresslevel=3,mtime=0));assert hashlib.sha256(gzip.decompress(tmp.read_bytes())).hexdigest()==h;tmp.rename(saved)
  assert hashlib.sha256(gzip.decompress(saved.read_bytes())).hexdigest()==h
  row=dict(path=str(p),sha256=h,preserved=str(saved),compression='gzip',bytes=len(data),compressed_bytes=saved.stat().st_size)
  with (r/'compiler-plugin-archive.jsonl').open('a') as f:f.write(json.dumps(row)+'\n')
  p.unlink();record['files'].append(row)
record['free_after']=shutil.disk_usage('/home/user').free;(r/'compiler-plugin-archive.json').write_text(json.dumps(record,indent=2));print('archived',len(record['files']),'compiler modules; free',record['free_after']);assert record['free_after']>12*1024**3
