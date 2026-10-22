from pathlib import Path
import hashlib, json, os, signal, subprocess, tempfile, time

root = Path('/root/gpui-ce3')
out = Path('/tmp/gpui-flat-native-gates')
out.mkdir(exist_ok=True)
messages = map(json.loads, Path('/tmp/gpui-flat-integrated-native-build.jsonl').read_text().splitlines())
artifacts = [item for item in messages if item.get('reason') == 'compiler-artifact'
             and item.get('target', {}).get('name') == 'gpui'
             and item.get('profile', {}).get('test') and item.get('executable')]
assert len(artifacts) == 1
binary = Path(artifacts[0]['executable'])
digest = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
binary_digest = digest(binary)
prefixes = [f'reactivity/crates/{name}/src' for name in ('canvas','core','gpu','gpui','host','state')]
files = subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),'ls-files',
                                *prefixes,'reactivity/Cargo.lock','reactivity/Cargo.toml',
                                'reactivity/crates/gpui/Cargo.toml','reactivity/crates/gpu/build.rs',
                                'reactivity/vendor/cephal/src','reactivity/vendor/accesskit_unix/src',
                                'reactivity/vendor/accesskit_atspi_common/src','reactivity/tools/test_atspi.sh'],text=True).splitlines()
def guard():
    return {name:digest(root/name) for name in files}
before = guard()
(out/'before-source.json').write_text(json.dumps(before,indent=2)+'\n')
xvfb_binary = '/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb'
launcher = '/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher'
display = next(n for n in range(151,180) if not Path(f'/tmp/.X11-unix/X{n}').exists()
               and not Path(f'/tmp/.X{n}-lock').exists())
results = []
with tempfile.TemporaryDirectory(prefix='gpui-flat-native-') as temporary:
    env = os.environ | {'DISPLAY':f':{display}','XDG_RUNTIME_DIR':temporary,
                        'XDG_DATA_DIRS':temporary,'GSETTINGS_BACKEND':'memory',
                        'GPUI_ATSPI_LAUNCHER':launcher}
    with (out/'xvfb.log').open('w') as log:
        xvfb = subprocess.Popen([xvfb_binary,env['DISPLAY'],'-screen','0','1280x1024x24',
                                 '-nolisten','tcp','-ac'],stdout=log,stderr=subprocess.STDOUT)
        try:
            for _ in range(200):
                assert xvfb.poll() is None
                if Path(f'/tmp/.X11-unix/X{display}').exists():
                    break
                time.sleep(.05)
            else:
                raise RuntimeError('owned Xvfb readiness timeout')
            cases = [
                ('todo',[str(binary),'native::tests::native_todo_port_presents_edits_pointer_actions_resize_and_inspection',
                         '--ignored','--exact','--nocapture','--test-threads=1'],{}),
                ('lifecycle',['dbus-run-session','--',str(binary),
                              'native::accessibility::linux_tests::native_atspi_late_service_owner_replacement_and_destroy',
                              '--ignored','--exact','--nocapture','--test-threads=1'],{}),
                ('real-registry',['bash',str(root/'reactivity/tools/test_atspi.sh'),launcher,str(binary)],{}),
                ('no-session',[str(binary),
                               'native::accessibility::linux_tests::native_accessible_profile_without_session_bus_still_presents',
                               '--ignored','--exact','--nocapture','--test-threads=1'],
                               {'DBUS_SESSION_BUS_ADDRESS':'unix:path=/tmp/gpui-no-session-bus'}),
            ]
            for name,command,extra in cases:
                assert guard() == before and digest(binary) == binary_digest
                with (out/f'{name}.log').open('w') as log:
                    process = subprocess.Popen(command,cwd=root,env=env|extra,stdout=log,
                                               stderr=subprocess.STDOUT,start_new_session=True)
                    try:
                        code = process.wait(timeout=90)
                    finally:
                        try:
                            os.killpg(process.pid,signal.SIGTERM)
                        except ProcessLookupError:
                            pass
                row = {'case':name,'command':command,'exit':code,'log_sha256':digest(out/f'{name}.log')}
                results.append(row)
                (out/'results.json').write_text(json.dumps(results,indent=2)+'\n')
                print(json.dumps(row),flush=True)
                assert code == 0
                assert '1 passed; 0 failed' in (out/f'{name}.log').read_text()
                assert guard() == before and digest(binary) == binary_digest
        finally:
            xvfb.terminate()
            try:
                xvfb.wait(timeout=5)
            except subprocess.TimeoutExpired:
                xvfb.kill()
                xvfb.wait()
    assert not Path(f'/tmp/.X11-unix/X{display}').exists()
assert guard() == before
(out/'metadata.json').write_text(json.dumps({
    'source_head':subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),'rev-parse','HEAD'],text=True).strip(),
    'artifact':artifacts[0], 'binary_sha256':binary_digest,'display':f':{display}',
    'source_unchanged':True,'owned_display_stopped':True,
    'limits':'Actual X11/Xvfb/llvmpipe/private-D-Bus protocol execution, not native Apple/Windows/Wayland, a screen-reader audit or hardware latency evidence.'},indent=2)+'\n')
