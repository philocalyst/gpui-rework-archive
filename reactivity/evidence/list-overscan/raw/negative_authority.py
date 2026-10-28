from pathlib import Path
import subprocess,hashlib,json,re
root=Path(__file__).resolve().parent;prior=root/'negative';out=root/'negative-authority';out.mkdir(exist_ok=False);wt=Path('/home/user/gpui-list-overscan-negative-lab')
binary=Path(re.search(r'Running tests/lists.rs \(([^)]+)\)',(prior/'test.log').read_text()).group(1));digest=hashlib.sha256(binary.read_bytes()).hexdigest();before=json.loads((prior/'inputs.json').read_text())
def changes(): return [p for p,h in before.items() if not (wt/p).is_file() or hashlib.sha256((wt/p).read_bytes()).hexdigest()!=h]
assert not changes();(out/'artifact.json').write_text(json.dumps({'path':str(binary),'sha256':digest,'bytes':binary.stat().st_size}));(out/'source.txt').write_bytes((prior/'source.txt').read_bytes())
for name in ['overscan_preserves_buffered_identity_but_not_offscreen_authority_or_departed_keys','overscan_ranges_clamp_and_pixels_match_zero_buffer_at_fractional_offsets']:
 cmd=[str(binary),name,'--exact','--nocapture'];r=subprocess.run(cmd,capture_output=True,text=True);(out/(name+'.out')).write_text(r.stdout);(out/(name+'.log')).write_text(r.stderr);(out/(name+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));assert r.returncode==101 and '0 passed; 1 failed' in r.stdout;print(name,'fails as required',flush=True)
(out/'guard-after.json').write_text(json.dumps(changes()));assert not changes() and hashlib.sha256(binary.read_bytes()).hexdigest()==digest
