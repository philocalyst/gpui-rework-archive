from pathlib import Path
import hashlib,json,os,shutil,signal,subprocess
root=Path('/root/gpui-ce3');gates=Path('/tmp/gpui-selection-main-gates');out=Path('/tmp/gpui-selection-main-public');out.mkdir(exist_ok=False)
h=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
guards=json.loads((gates/'source-guard.json').read_text())
def check():
 assert all(h(root/name)==value for name,value in guards.items())
check()
artifacts=[]
for line in (gates/'gpui-full.log').read_text().splitlines():
 try:r=json.loads(line)
 except ValueError:continue
 if r.get('reason')=='compiler-artifact' and r['target']['name']=='property_editor' and r.get('executable'):artifacts.append(r)
assert len(artifacts)==1
artifact=artifacts[0];source=Path(artifact['executable']);binary=out/'property-editor-frozen'
shutil.copyfile(source,binary);binary.chmod(0o555);frozen=h(binary);assert h(source)==frozen
shutil.copyfile('/tmp/gpui-selection-public-client.py',out/'client.py');client_hash=h(out/'client.py')
(out/'artifact.json').write_text(json.dumps(artifact,indent=2)+'\n')
display=next(n for n in range(202,220) if not Path(f'/tmp/.X11-unix/X{n}').exists() and not Path(f'/tmp/.X{n}-lock').exists())
command=['dbus-run-session','--','/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3',str(out/'client.py'),str(binary),'--xvfb','/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb','--launcher','/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher','--output',str(out/'result.json'),'--display',f':{display}']
metadata={'source':json.loads((gates/'metadata.json').read_text())['source'],'binary_sha256':frozen,'binary_bytes':binary.stat().st_size,'client_sha256':client_hash,'client_source_commit':'bdb383b4cd0df93f73a364ee44a7049c1fd80bc7','guarded_files':len(guards),'command':command,'limitation':'Functional native CPU/actual Registry proof, no timings or RSS.'}
(out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
with (out/'client.log').open('w') as log:
 p=subprocess.Popen(command,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
 try:code=p.wait(timeout=100)
 finally:
  try:os.killpg(p.pid,signal.SIGTERM)
  except ProcessLookupError:pass
assert code==0
result=json.loads((out/'result.json').read_text());assert result['passed'] is True
assert result['binary_sha256']==frozen==h(binary)
check();assert not Path(f'/tmp/.X11-unix/X{display}').exists()
metadata.update(exit=code,source_unchanged=True,binary_unchanged=True,owned_display_stopped=True)
(out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
print(json.dumps(metadata),flush=True)
