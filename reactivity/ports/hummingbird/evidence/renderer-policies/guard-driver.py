from pathlib import Path
import hashlib, json, os, shutil, subprocess
root=Path('/root/gpui-ce3'); cwd=root/'reactivity'; out=Path('/tmp/gpui-hummingbird-renderer-gates');out.mkdir(exist_ok=True)
hash_file=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
rows=[]
for line in Path('/tmp/gpui-hummingbird-renderer-native-build.jsonl').read_text().splitlines():
 if line.startswith('{'):rows.append(json.loads(line))
artifact=next(r for r in rows if r.get('reason')=='compiler-artifact' and r.get('executable') and r['target']['kind']==['bin'] and r['target']['name']=='hummingbird-gpui-port')
binary=out/'hummingbird-frozen';shutil.copyfile(artifact['executable'],binary);binary.chmod(0o755);binary_hash=hash_file(binary)
prefixes=[f'reactivity/crates/{n}' for n in ('canvas','core','gpu','gpui','host','state')]
files=subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),'ls-files',*prefixes,'reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/.cargo','reactivity/vendor','reactivity/ports/hummingbird'],text=True).splitlines()
def guard():return {name:hash_file(root/name) for name in files}
before=guard();(out/'source-guard.json').write_text(json.dumps(before,indent=2)+'\n');results=[]
head=subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),'rev-parse','HEAD'],text=True).strip()
metadata={'source_head':head,'artifact':artifact,'binary_sha256':binary_hash,'guard_driver_sha256':hash_file(Path(__file__)),'source_unchanged':None,'owned_displays_stopped':None,'limits':'Actual private X11/AT-SPI protocol plus SQLite/Nucleo public-owner transcript; llvmpipe execution is not hardware timing, startup, RSS, native HDR or foreign-platform runtime evidence.'}
(out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
def run(name,command,timeout,expected=0):
 assert guard()==before and hash_file(binary)==binary_hash
 with (out/f'{name}.log').open('w') as log:result=subprocess.run(command,cwd=cwd,stdout=log,stderr=subprocess.STDOUT,timeout=timeout)
 row={'case':name,'command':command,'exit':result.returncode,'expected_exit':expected,'log_sha256':hash_file(out/f'{name}.log')};results.append(row);(out/'results.json').write_text(json.dumps(results,indent=2)+'\n');print(json.dumps(row),flush=True)
 assert result.returncode==expected,row
 assert guard()==before and hash_file(binary)==binary_hash
run('headless',[str(binary),'--headless'],60)
python='/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3';driver=cwd/'ports/hummingbird/native-transcript.py'
displays=[]
for renderer in ('cpu','gpu','auto'):
 display=next(n for n in range(152,180) if not Path(f'/tmp/.X11-unix/X{n}').exists() and not Path(f'/tmp/.X{n}-lock').exists());displays.append(f':{display}')
 run(f'native-{renderer}',['dbus-run-session','--',python,str(driver),str(binary),'--xvfb','/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb','--xdotool','/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool','--atspi-launcher','/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher','--output',str(out/f'native-{renderer}.json'),'--display',f':{display}','--renderer',renderer],90)
 assert not Path(f'/tmp/.X11-unix/X{display}').exists()
run('application-tests',['cargo','test','--offline','--locked','--manifest-path','ports/hummingbird/Cargo.toml','--features','native'],360)
run('application-strict',['cargo','clippy','--offline','--locked','--manifest-path','ports/hummingbird/Cargo.toml','--features','native','--all-targets','--','-D','warnings'],360)
run('future-public',['cargo','test','--offline','--locked','-p','gpui','--no-default-features','--test','question_futures'],360)
metadata.update(source_unchanged=True,owned_displays_stopped=True,displays=displays)
(out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
