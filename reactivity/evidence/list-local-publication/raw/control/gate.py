from pathlib import Path
import os,json,subprocess,hashlib,sys,shutil
root=Path(__file__).resolve().parent;wt=Path('/home/user/gpui-local-publication-control-lab');target=Path('/home/user/gpui-local-publication-control-target');out=root/sys.argv[1];out.mkdir(exist_ok=False)
def inputs():
 paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=wt).decode().split('\0')
 return {p:hashlib.sha256((wt/p).read_bytes()).hexdigest() for p in paths if p and (wt/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip();before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt))
base=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release','-p','gpui','-p','gpui_canvas']
mode=sys.argv[2]
if mode=='clip-only':cmds=[('test',base+['test']+common+['--test','local_publication','--','--nocapture','--skip','image_clip_and_scroller_preserve_older_candidate_after_newer_failure']),('clippy',base+['clippy']+common+['--test','local_publication','--','-D','warnings'])]
elif mode=='local':cmds=[('test',base+['test']+common+['--test','local_publication','--','--nocapture']),('unit',base+['test']+common+['--lib','runtime::sparse_text::tests','--','--nocapture']),('clippy',base+['clippy']+common+['--test','local_publication','--','-D','warnings'])]
elif mode=='admission':cmds=[('test',base+['test']+common+['--features','gpui/x11','--lib','runtime::sparse_text::tests::representative_workload_local_publication_admission','--','--exact','--nocapture'])]
elif mode=='epoch':cmds=[('test',base+['test']+common+['--features','gpui/x11','--lib','runtime::list::controlled_epoch_tests::exhausted_distant_key_preserves_current_cohort_without_description','--','--exact','--nocapture'])]
elif mode=='focused':cmds=[('test',base+['test']+common+['--test','list_source','--','--nocapture'])]
elif mode=='focused-native':cmds=[('test',base+['test']+common+['--features','gpui/x11','--test','list_source','--','--nocapture']),('clippy',base+['clippy']+common+['--features','gpui/x11','--test','list_source','--','-D','warnings'])]
elif mode=='native-units':cmds=[('unit-build',base+['test']+common+['--features','gpui/x11','--lib','--no-run']),('clippy',base+['clippy']+common+['--features','gpui/x11','--all-targets','--','-D','warnings'])]
elif mode=='ledger':cmds=[('test',base+['test','--locked','--offline','--release','-p','gpui','--features','x11','--lib','runtime::semantic_storage_ledger::sparse_metadata_storage_and_cold_allocation_ledger','--','--exact','--nocapture']),('clippy',base+['clippy','--locked','--offline','--release','-p','gpui','--features','x11','--lib','--','-D','warnings'])]
elif mode=='clippy':cmds=[('clippy',base+['clippy']+common+['--all-targets','--','-D','warnings'])]
elif mode=='full':cmds=[('test',base+['test']+common),('clippy',base+['clippy']+common+['--all-targets','--','-D','warnings'])]
elif mode=='native':cmds=[('build',base+['build','--locked','--offline','--release','-p','gpui','--features','x11','--example','zgx_native_lab','--message-format=json']),('test',base+['test']+common+['--features','gpui/x11']),('port',base+['test','--locked','--offline','--release','-p','gpui','--features','x11','--example','zgx_native_lab']),('clippy',base+['clippy']+common+['--features','gpui/x11','--all-targets','--','-D','warnings'])]
else:raise ValueError(mode)
failed=False
for name,cmd in cmds:
 assert shutil.disk_usage('/home/user').free>8*1024**3
 with (out/(name+'.out')).open('w') as a,(out/(name+'.log')).open('w') as b:r=subprocess.run(cmd,cwd=wt/'reactivity',env={**os.environ,'CARGO_TARGET_DIR':str(target),'CARGO_BUILD_JOBS':'2'},stdout=a,stderr=b)
 (out/(name+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));print(name,r.returncode,flush=True)
 if r.returncode:failed=True;break
 if name=='build':
  p=target/'release/examples/zgx_native_lab';digest=hashlib.sha256(p.read_bytes()).hexdigest();matches=[p2 for p2 in (target/'release/build/gpui').glob('*/out/zgx_native_lab') if p2.stat().st_size==p.stat().st_size and hashlib.sha256(p2.read_bytes()).hexdigest()==digest];assert len(matches)==1
  fp=json.loads((matches[0].parent.parent/'fingerprint/example-zgx_native_lab.json').read_text());assert 'x11' in json.loads(fp['features'])
  preserved=Path('/home/user/gpui-preserved-test-binaries')/digest
  if not preserved.exists():shutil.copy2(matches[0],preserved)
  assert hashlib.sha256(preserved.read_bytes()).hexdigest()==digest
  (out/'artifact.json').write_text(json.dumps({'path':str(matches[0]),'sha256':digest,'preserved':str(preserved),'bytes':p.stat().st_size,'fingerprint':fp},indent=2))
after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes and not failed
