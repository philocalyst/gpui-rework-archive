from pathlib import Path
import hashlib, json, os, re, select, shutil, signal, subprocess, sys, tempfile
root=Path('/tmp/gpui-clips-gradient-root-wire')
root.mkdir(exist_ok=False)
build=Path('/tmp/gpui-clips-gradient-root-native-build')
assert json.loads((build/'result.json').read_text())['exit']==0
out=root/'native-execute'
out.mkdir(exist_ok=False)
rows=[json.loads(line) for line in (build/'stdout.log').read_text().splitlines()]
assert any(row.get('reason')=='build-finished' and row.get('success') for row in rows)
artifacts=[row for row in rows if row.get('reason')=='compiler-artifact' and row.get('executable') and row['profile']['test'] and row['target']['name']=='gpui']
assert len(artifacts)==1
row=artifacts[0]
original=Path(row['executable'])
binary=out/'gpui-native-tests'
shutil.copyfile(original,binary)
binary.chmod(0o555)
digest=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
identity={'source':json.loads((build/'result.json').read_text())['source'],'original':str(original),'sha256':digest(binary),'bytes':binary.stat().st_size,'fresh':row['fresh'],'features':row['features'],'profile':row['profile'],'target':row['target']}
(out/'binary.json').write_text(json.dumps(identity,indent=2)+'\n')
listing=subprocess.check_output([str(binary),'--list'],text=True)
(out/'list.txt').write_text(listing)
results=[]
active=[]
def stop(child):
    if child.poll() is None:
        os.killpg(child.pid,signal.SIGTERM)
        try: child.wait(timeout=5)
        except subprocess.TimeoutExpired:
            os.killpg(child.pid,signal.SIGKILL)
            child.wait()
def interrupted(signum,frame):
    for child in reversed(active): stop(child)
    raise SystemExit(128+signum)
signal.signal(signal.SIGTERM,interrupted)
signal.signal(signal.SIGINT,interrupted)
def run(label,argv,env,timeout):
    directory=out/label
    directory.mkdir()
    (directory/'command.json').write_text(json.dumps({'argv':argv,'timeout_seconds':timeout,'scope':'Functional actual ELF execution; no timing inference.'},indent=2)+'\n')
    with (directory/'stdout.log').open('w') as stdout,(directory/'stderr.log').open('w') as stderr:
        child=subprocess.Popen(argv,env=env,stdout=stdout,stderr=stderr,start_new_session=True)
        active.append(child)
        try: status=child.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            stop(child)
            status=124
    counts=re.findall(r'test result: (?:ok|FAILED)\. (\d+) passed; (\d+) failed; (\d+) ignored;',(directory/'stdout.log').read_text())
    result={'name':label,'exit':status,'passed':sum(int(c[0]) for c in counts),'failed':sum(int(c[1]) for c in counts),'ignored':sum(int(c[2]) for c in counts),'binary_sha256_matches':digest(binary)==identity['sha256']}
    assert result['binary_sha256_matches']
    (directory/'result.json').write_text(json.dumps(result,indent=2)+'\n')
    results.append(result)
    print(json.dumps(result),flush=True)
    if status: raise SystemExit(status)

with tempfile.TemporaryDirectory(prefix='gpui-mapped-native-display-') as temporary:
    runtime=Path(temporary)
    runtime.chmod(0o700)
    rfd,wfd=os.pipe()
    xvfb='/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb'
    with (out/'xvfb.log').open('w') as log:
        display=subprocess.Popen([xvfb,'-displayfd',str(wfd),'-screen','0','1024x768x24','-nolisten','tcp','-noreset'],pass_fds=(wfd,),stdout=log,stderr=log,start_new_session=True)
        active.append(display)
        os.close(wfd)
        try:
            assert select.select([rfd],[],[],10)[0],'Xvfb readiness deadline'
            number=os.read(rfd,32).decode().strip()
            assert number.isdigit(),number
            env=os.environ.copy()
            env.update(DISPLAY=':'+number,XDG_RUNTIME_DIR=str(runtime))
            for key in ['WAYLAND_DISPLAY','AT_SPI_BUS_ADDRESS','NO_AT_BRIDGE']:
                env.pop(key,None)
            dbus='/nix/store/8snmq54bp5d5vp5dihgn7xr53hayx629-dbus-1.16.2/bin/dbus-run-session'
            for label,suffix in [('native-gpu-paint','native_todo_port_presents_edits_pointer_actions_resize_and_inspection'), ('native-atspi-clips','native_atspi_rounded_clip_point_queries_pointer_and_ack')]:
                matches=[line.removesuffix(': test') for line in listing.splitlines() if line.endswith('::'+suffix+': test')]
                assert len(matches)==1,matches
                if label == 'native-atspi-clips': env['WINIT_X11_SCALE_FACTOR']='1.25'
                else: env.pop('WINIT_X11_SCALE_FACTOR',None)
                run(label,[dbus,'--',str(binary),matches[0],'--exact','--ignored','--nocapture','--test-threads=1'],env,180)
        finally:
            os.close(rfd)
            stop(display)
report={'source':identity['source'],'binary_sha256':identity['sha256'],'all_exit_zero':all(row['exit']==0 for row in results),'passed':sum(row['passed'] for row in results),'failed':sum(row['failed'] for row in results),'ignored':sum(row['ignored'] for row in results),'results':results,'scope':'Actual private-X11 renderer/paint/inspector bridge and AT-SPI rounded-clip pointer/ACK wire test at1.25 scale and negative screen origin; no hardware, latency or RSS claim.'}
(out/'result.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report),flush=True)
