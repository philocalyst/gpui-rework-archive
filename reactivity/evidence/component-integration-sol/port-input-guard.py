from pathlib import Path
import hashlib,json,subprocess,sys
root=Path('/root/gpui-component-review-sol-20261024')
paths=[]
for name in ('.cargo','clippy.toml','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','rust-toolchain.toml','reactivity/crates','reactivity/vendor','reactivity/ports/hummingbird/Cargo.toml','reactivity/ports/hummingbird/Cargo.lock','reactivity/ports/hummingbird/build.rs','reactivity/ports/hummingbird/src','reactivity/ports/hummingbird/examples','reactivity/ports/hummingbird/tests'):
 p=root/name
 if p.is_file(): paths.append(p)
 elif p.is_dir(): paths.extend(f for f in p.rglob('*') if f.is_file() and 'target' not in f.parts)
rows={str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(set(paths))}
result={'commit':subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),'rev-parse','HEAD'],text=True).strip(),'aggregate':hashlib.sha256(json.dumps(rows,sort_keys=True).encode()).hexdigest(),'files':rows}
Path(sys.argv[1]).write_text(json.dumps(result,indent=2)+'\n')
print(result['commit'],result['aggregate'],len(rows))
