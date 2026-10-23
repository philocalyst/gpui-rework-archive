from pathlib import Path
import gzip,hashlib,json,re,shutil,subprocess
source=Path('/tmp/gpui-delivery-integration-captures');root=Path('/tmp/gpui-delivery-integration-sol');dest=root/'reactivity/evidence/delivery-integration'
dest.mkdir(parents=True,exist_ok=True)
rootfail=Path('/tmp/gpui-source-value-integration-evidence');neg=source/'initial-d86';neg.mkdir(exist_ok=True)
for f in rootfail.iterdir():
 if f.is_file():shutil.copyfile(f,neg/f.name)
# Exact source and support deltas remain distinct from generated artifacts.
for name,a,b,paths in [('main-to-e31.patch','602a887bbb','e31ffdbc15c8e786e822715c7c0d00d95629f97c',[]),('d86-to-e31.patch','d86ca9895dceebeafd8d527cd1d5b7810ea6d2f5','e31ffdbc15c8e786e822715c7c0d00d95629f97c',[]),('compatibility-source.patch','602a887bbb','75de7f0090',[]),('compatibility-fixtures.patch','75de7f0090','22cd93e21d',[]),('typed-fixture.patch','b886ed5c3c','64443ce307',[])]:
 repo='/tmp/gpui-delivery-cost-sol' if 'compatibility' in name or name=='typed-fixture.patch' else str(root)
 (source/name).write_bytes(subprocess.check_output(['git','-C',repo,'diff','--binary',a,b,'--',*paths]))
# Save complete bodies for every function in the selected gpui/transport call index.
for asm in sorted(source.glob('cost-*.asm')):
 if '.selected.asm' in asm.name:continue
 stem=asm.name.removesuffix('.asm');analysis=json.loads((source/(stem+'-analysis.json')).read_text())['functions'];text=asm.read_text();starts=list(re.finditer(r'^([0-9a-f]+) <(.+)>:\n',text,re.M));parts=[]
 for i,m in enumerate(starts):
  if m[2] in analysis:parts.append(text[m.start():starts[i+1].start() if i+1<len(starts) else len(text)])
 (source/(stem+'.selected.asm')).write_text(''.join(parts))
external=[];copied=[]
for f in sorted(source.rglob('*')):
 if not f.is_file():continue
 rel=f.relative_to(source)
 if f.is_symlink():
  external.append({'path':str(f),'symlink_to':str(f.resolve()),'note':'native executable hash is in native-three-results and registry/result'});continue
 if f.suffix=='.elf' or (f.suffix=='.asm' and '.selected.asm' not in f.name):
  external.append({'path':str(f),'bytes':f.stat().st_size,'sha256':hashlib.sha256(f.read_bytes()).hexdigest()});continue
 if f.name=='README-draft.md':continue
 target=dest/'raw'/rel;target.parent.mkdir(parents=True,exist_ok=True)
 data=f.read_bytes()
 if len(data)>24000:
  target=target.with_name(target.name+'.gz');target.write_bytes(gzip.compress(data,compresslevel=1,mtime=0))
 else:target.write_bytes(data)
 copied.append({'source':str(f),'archive':str(target.relative_to(dest)),'original_bytes':len(data),'original_sha256':hashlib.sha256(data).hexdigest(),'archive_sha256':hashlib.sha256(target.read_bytes()).hexdigest()})
(dest/'README.md').write_text((source/'README-draft.md').read_text()+'''\nThe sealed `raw/` files larger than24KB use deterministic gzip; `file-index.json` records original and compressed SHA256. `external-artifacts.json` identifies full frozen ELFs/raw disassemblies left outside Git. Complete selected GPUI/channel function bodies are archived as `.selected.asm.gz`; the external full disassembly also includes all linked allocator/platform/font/helper bodies. `main-to-e31.patch` is a52-file source/docs/toolchain delta (1838 inserted/253 removed raw lines); test/support lines are charged separately from the machine core counter. Three nonshipping fixture variants total180 raw Rust lines; observer/parser scripts remain under `raw/`. No benchmark or production profiling hooks are added.\n''')
(dest/'file-index.json').write_text(json.dumps(copied,indent=2)+'\n');(dest/'external-artifacts.json').write_text(json.dumps(external,indent=2)+'\n')
print(json.dumps({'files':len(copied),'archive_bytes':sum(f.stat().st_size for f in dest.rglob('*') if f.is_file()),'external':len(external)}),flush=True)
