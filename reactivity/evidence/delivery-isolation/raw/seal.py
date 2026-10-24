from pathlib import Path
import gzip,hashlib,json,re,subprocess
source=Path('/tmp/gpui-delivery-isolation-captures');root=Path('/tmp/gpui-delivery-isolation-sol');control=Path('/tmp/gpui-delivery-isolation-cost-sol');dest=root/'reactivity/evidence/delivery-isolation'
assert not dest.exists()
def git(repo,*args):
 return subprocess.check_output(['git','-c','safe.directory='+str(repo),'-C',str(repo),*args])
assert git(root,'rev-parse','HEAD').decode().strip()=='22541342e3c10a962bc61f76088c7bfdb1b21bbd'
assert not git(root,'status','--porcelain') and not git(control,'status','--porcelain')
scopes=['.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','reactivity/crates','reactivity/vendor','reactivity/ports/hummingbird']
for name,repo,a,b,paths in [
 ('e31-to-isolation.patch',root,'e31ffdbc15c8e786e822715c7c0d00d95629f97c','22541342e3',scopes),
 ('main-to-isolation.patch',root,'602a887bbb','22541342e3',scopes),
 ('compatibility-control.patch',control,'602a887bbb','22cd93e21d',scopes),
 ('composite-control.patch',control,'22cd93e21d','98450106fc',scopes),
 ('typed-fixture.patch',control,'98450106fc','103055929d',['reactivity/crates/gpui/examples/field_control.rs']),
 ('test-observer-migration.patch',root,'df57f1c38b','3ae5b7c0',['reactivity/crates/gpui/tests/runtime.rs']),
 ('standalone-hb-lock.patch',root,'3ae5b7c0','22541342e3',['reactivity/ports/hummingbird/Cargo.lock'])]:
 (source/name).write_bytes(git(repo,'diff','--binary',a,b,'--',*paths))
for name,ref in [('ordinary_control.rs','98450106fc'),('field_coarse_control.rs','98450106fc'),('field_control.rs','103055929d')]:
 filename='ordinary_control.rs' if name=='ordinary_control.rs' else 'field_control.rs'
 (source/name).write_bytes(git(control,'show',ref+':reactivity/crates/gpui/examples/'+filename))
for asm in sorted(source.glob('cost-*.asm')):
 if '.selected.asm' in asm.name:continue
 stem=asm.name.removesuffix('.asm');analysis=json.loads((source/(stem+'-analysis.json')).read_text())['functions'];body=asm.read_text();starts=list(re.finditer(r'^([0-9a-f]+) <(.+)>:\n',body,re.M));parts=[]
 for i,m in enumerate(starts):
  if m[2] in analysis:parts.append(body[m.start():starts[i+1].start() if i+1<len(starts) else len(body)])
 (source/(stem+'.selected.asm')).write_text(''.join(parts))
def digest(path):
 h=hashlib.sha256()
 with path.open('rb') as stream:
  while block:=stream.read(1024*1024):h.update(block)
 return h.hexdigest()
dest.mkdir(parents=True);external=[];copied=[]
for f in sorted(source.rglob('*')):
 if not f.is_file():continue
 rel=f.relative_to(source)
 if f.is_symlink() or f.suffix=='.elf' or (f.suffix=='.asm' and '.selected.asm' not in f.name):
  row={'path':str(f),'bytes':f.stat().st_size,'sha256':digest(f)}
  if f.is_symlink():row['symlink_to']=str(f.resolve())
  external.append(row);continue
 if f.name=='README-draft.md':continue
 target=dest/'raw'/rel;target.parent.mkdir(parents=True,exist_ok=True);data=f.read_bytes()
 if len(data)>24000:target=target.with_name(target.name+'.gz');target.write_bytes(gzip.compress(data,compresslevel=1,mtime=0))
 else:target.write_bytes(data)
 copied.append({'source':str(f),'archive':str(target.relative_to(dest)),'original_bytes':len(data),'original_sha256':hashlib.sha256(data).hexdigest(),'archive_sha256':digest(target)})
(dest/'README.md').write_text((source/'README-draft.md').read_text()+'\nSealed raw payloads over24KB use deterministic gzip. `file-index.json` records original and stored hashes/sizes; `external-artifacts.json` records the five frozen release ELFs, five full raw disassemblies and the actual native ELF symlink including its resolved hash. Complete selected GPUI/transport/Mutex/Arc function bodies are inside the archive. The full external disassemblies retain all linked allocator/platform/font bodies. Raw support is distinct from shipping source. No timing, native profiling hooks or Main mutation occurred.\n')
(dest/'file-index.json').write_text(json.dumps(copied,indent=2)+'\n');(dest/'external-artifacts.json').write_text(json.dumps(external,indent=2)+'\n')
print(json.dumps({'files':len(copied),'archive_bytes':sum(f.stat().st_size for f in dest.rglob('*') if f.is_file()),'original_bytes':sum(r['original_bytes'] for r in copied),'external':len(external)}),flush=True)
