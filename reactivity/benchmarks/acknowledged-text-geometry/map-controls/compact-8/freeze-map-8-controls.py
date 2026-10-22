from pathlib import Path
import subprocess,hashlib,json,re,shutil
out=Path('/tmp/gpui-text-map-8-controls');out.mkdir(exist_ok=True)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
manifest={}
for name,tree,source,prefix in [('converted','/root/gpui-text-map-8','068497ed7e17cde8ced7c5c85d81bb8146b2daa1','gpui-text-map-8'),('direct','/root/gpui-text-map-8-direct','f515b1dcfc6a229aa994526c07a5de98bd8afcf8','gpui-text-map-8-direct')]:
 assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=tree,text=True).strip()==source
 subprocess.run(['git','diff','--exit-code','HEAD','--','reactivity/crates/canvas/src'],cwd=tree,check=True)
 directory=out/name;directory.mkdir(exist_ok=True);item={'source':source,'configuration':'cwd /root, no rustflags, default simd, test profile','executables':{}}
 for package,label,case in [('gpui','owner','runtime::text_geometry::tests::acknowledged_geometry_owner_epoch_and_allocation_ledger'),('gpui_canvas','canvas','text::geometry_ledger::scoped_geometry_allocation_and_payload_ledger')]:
  log=Path('/tmp')/f'{prefix}-{label}-ledger.log';shutil.copy2(log,directory/log.name);binary=Path(re.search(r'Running unittests [^\n]+\(([^)]+)\)',log.read_text())[1]);frozen=directory/package;shutil.copy2(binary,frozen);digest=sha(frozen)
  cfg=json.loads((binary.parent.parent/'.fingerprint'/binary.name/f'test-lib-{package}.json').read_text());assert cfg['rustflags']==[],cfg['rustflags']
  args=[str(frozen),'--exact',case,'--nocapture','--test-threads=1'];final=directory/f'{package}-final.log';final.write_bytes(subprocess.check_output(args,stderr=subprocess.STDOUT));assert sha(binary)==digest and sha(frozen)==digest
  item['executables'][package]={'path':str(frozen),'sha256':digest,'command':args,'fingerprint':cfg,'log':final.name,'log_sha256':sha(final)}
 item['source_files_sha256']={p:sha(Path(tree)/p) for p in ['reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/crates/canvas/src/text/layout.rs','reactivity/crates/canvas/src/text/layout/carets.rs','reactivity/crates/canvas/src/text/layout/interaction.rs','reactivity/crates/canvas/src/text/planner.rs']};manifest[name]=item
(out/'results.json').write_text(json.dumps(manifest,indent=2)+'\n');print('Frozen converted/direct8B losing controls; exact binary/source/rustflags guards pass')
