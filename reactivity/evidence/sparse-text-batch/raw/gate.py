import pathlib,sys,subprocess,json,hashlib,os
wt=pathlib.Path(sys.argv[1]);out=pathlib.Path(sys.argv[2]);target=sys.argv[3];kind=sys.argv[4];out.mkdir(exist_ok=False,parents=True)
def guard():
 paths=subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=wt).decode().split('\0')
 return {p:hashlib.sha256((wt/p).read_bytes()).hexdigest() for p in paths if p and (wt/p).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt)
(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt));before=guard();(out/'inputs.json').write_text(json.dumps(before))
env={**os.environ,'CARGO_TARGET_DIR':target};base=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"']
if kind=='full-clippy':cmds=[('clippy',base+['clippy','--locked','--offline','--release','-p','gpui','-p','gpui_canvas','--all-targets','--','-D','warnings'])]
elif kind=='first':cmds=[('canvas',base+['test','--locked','--offline','--release','-p','gpui_canvas','--test','text_batch']),('sparse-path',base+['test','--locked','--offline','--release','-p','gpui','--lib','batched_text_prepares_sparse_rows_before_acknowledgement']),('public',base+['test','--locked','--offline','--release','-p','gpui','--test','sparse_text_batch','--test','source_batch','--test','sparse_text','--test','text_geometry']),('clippy',base+['clippy','--locked','--offline','--release','-p','gpui','-p','gpui_canvas','--lib','--tests','--','-D','warnings'])]
elif kind=='full':cmds=[('build',base+['build','--locked','--offline','--release','-p','gpui','--example','source_batch_cost','--example','source_batch_allocations','--message-format=json']),('test',base+['test','--locked','--offline','--release','-p','gpui','-p','gpui_canvas']),('layout',base+['test','--locked','--offline','--release','-p','gpui','--lib','sparse_batch_layout_ledger','--','--nocapture']),('clippy',base+['clippy','--locked','--offline','--release','-p','gpui','-p','gpui_canvas','--all-targets','--','-D','warnings'])]
elif kind=='fixture': cmds=[('build',base+['build','--locked','--offline','--release','-p','gpui','--example','source_batch_cost','--message-format=json']),('test',base+['test','--locked','--offline','--release','-p','gpui','--lib','--tests']),('clippy',base+['clippy','--locked','--offline','--release','-p','gpui','--lib','--tests','--example','source_batch_cost','--','-D','warnings'])]
elif kind=='allocation':cmds=[('build',base+['build','--locked','--offline','--release','-p','gpui','--example','source_batch_allocations','--message-format=json']),('clippy',base+['clippy','--locked','--offline','--release','-p','gpui','--example','source_batch_allocations','--','-D','warnings'])]
elif kind=='composed-docs':cmds=[('test',base+['test','--locked','--offline','--release','-p','gpui','--features','x11','--doc'])]
elif kind=='docs':cmds=[('test',base+['test','--locked','--offline','--release','-p','gpui','--doc'])]
elif kind=='certificate':cmds=[('test',base+['test','--locked','--offline','--release','-p','gpui','--test','question_source_set']),('clippy',base+['clippy','--locked','--offline','--release','-p','gpui','--test','question_source_set','--','-D','warnings'])]
elif kind=='control':cmds=[('build',base+['build','--locked','--offline','--release','-p','gpui','--example','source_batch_cost','--message-format=json'])]
elif kind=='negative':cmds=[('test',base+['test','--locked','--offline','--release','-p','gpui_canvas','--test','text_batch','a_rejected_second_run_preserves_the_first_run_and_its_pixels','--','--exact'])]
elif kind=='composed':cmds=[('test',base+['test','--locked','--offline','--release','-p','gpui','-p','gpui_canvas','--features','gpui/x11']),('clippy',base+['clippy','--locked','--offline','--release','-p','gpui','-p','gpui_canvas','--features','gpui/x11','--lib','--tests','--','-D','warnings'])]
failed=False
for name,cmd in cmds:
 with (out/(name+'.out')).open('w') as a,(out/(name+'.log')).open('w') as b: r=subprocess.run(cmd,cwd=wt/'reactivity',env=env,stdout=a,stderr=b)
 (out/(name+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));print(name,r.returncode,flush=True)
 if r.returncode!=(101 if kind=='negative' else 0):failed=True;break
after=guard();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes
if kind in ['fixture','control','full'] and not failed:
 binary=pathlib.Path(target)/'release/examples/source_batch_cost';(out/'artifact.json').write_text(json.dumps({'path':str(binary),'sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),'bytes':binary.stat().st_size}))
assert not failed
