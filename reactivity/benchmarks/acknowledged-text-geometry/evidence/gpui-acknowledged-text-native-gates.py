from pathlib import Path
import hashlib, json, os, re, shutil, signal, subprocess, tempfile, time

root = Path('/root/gpui-acknowledged-text-geometry')
out = Path('/tmp/gpui-acknowledged-text-evidence/final-native')
out.mkdir(exist_ok=True)
source = 'eace5a4a6db805d6ccdf1aacd5b848a5215bb2f5'
git = ['git', '-c', f'safe.directory={root}', '-C', str(root)]
def clean():
    assert subprocess.check_output(git+['rev-parse','HEAD'], text=True).strip() == source
    assert not subprocess.check_output(git+['status','--porcelain','--untracked-files=no'], text=True)
clean()
log = (out.parent/'final-gpui-full-map-contract.log').read_text()
match = re.search(r'Running unittests src/lib.rs \(([^)]+/gpui-[0-9a-f]+)\)', log)
original = Path(match[1]) if match else Path(os.environ['GPUI_TEXT_TEST_BINARY'])
listing = subprocess.check_output([str(original),'--list'],text=True)
assert 'runtime::editing::tests::all_presented_inputs_retain_stable_geometry_and_share_one_cold_editor: test' in listing
assert original.stat().st_mtime > 1792671006
binary = out/'gpui'
shutil.copyfile(original, binary)
binary.chmod(0o555)
def digest(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
exe_hash = digest(binary)
results = []
provenance = {'source':source, 'shipping_base':'6d77c71c1227bd2609518cc5f3a49e37fc176f82', 'features':'desktop,x11,wayland,gpui_canvas/parallel,cephal/verify-cache', 'profile':'test/unoptimized+debuginfo', 'artifact_selection':'Cargo test-lib artifact; compiled after pinned commit; eace-only test name checked; full integration compilation may still be running', 'executable':str(binary), 'original':str(original), 'executable_sha256':exe_hash, 'full_test_log_sha256':digest(out.parent/'final-gpui-full-map-contract.log'), 'rustc':subprocess.check_output(['rustc','-vV'],text=True), 'cases':results}
(out/'results.json').write_text(json.dumps(provenance,indent=2)+'\n')
def case(name, command, env):
    clean(); assert digest(binary) == exe_hash
    with (out/f'{name}.log').open('w') as log:
        process = subprocess.Popen(command, cwd=root/'reactivity', env=env, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
        try: code = process.wait(timeout=90)
        finally:
            try: os.killpg(process.pid, signal.SIGTERM)
            except ProcessLookupError: pass
    row = {'name':name, 'command':command, 'exit':code, 'log_sha256':digest(out/f'{name}.log')}
    results.append(row)
    (out/'results.json').write_text(json.dumps(provenance,indent=2)+'\n')
    print(json.dumps(row), flush=True)
    assert code == 0
    assert '1 passed; 0 failed' in (out/f'{name}.log').read_text()
    clean(); assert digest(binary) == exe_hash
for name, test in [
    ('headers','runtime::parent_tests::compact_parent_covers_the_admitted_index_domain'),
    ('plain','runtime::inspector::tests::plain_window_has_no_tool_allocation_and_inspector_uses_only_cold_storage'),
    ('epochs','runtime::text_geometry::tests::acknowledged_geometry_owner_epoch_and_allocation_ledger'),
    ('native-allocations','native::accessibility::geometry_tests::native_geometry_projection_allocation_ledger'),
    ('cohort-header','native::accessibility::text::native_input_authority_memory_budget'),
]:
    case(name,[str(binary),test,'--exact','--nocapture','--test-threads=1'],os.environ)
xvfb_binary = '/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb'
launcher = '/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher'
display = next(n for n in range(181,199) if not Path(f'/tmp/.X11-unix/X{n}').exists() and not Path(f'/tmp/.X{n}-lock').exists())
with tempfile.TemporaryDirectory(prefix='gpui-text-geometry-native-') as temporary:
    env = os.environ | {'DISPLAY':f':{display}', 'XDG_RUNTIME_DIR':temporary, 'XDG_DATA_DIRS':temporary, 'GSETTINGS_BACKEND':'memory', 'GPUI_ATSPI_LAUNCHER':launcher}
    with (out/'xvfb.log').open('w') as log:
        xvfb = subprocess.Popen([xvfb_binary,env['DISPLAY'],'-screen','0','1280x1024x24','-nolisten','tcp','-ac'],stdout=log,stderr=subprocess.STDOUT)
        try:
            for _ in range(200):
                assert xvfb.poll() is None
                if Path(f'/tmp/.X11-unix/X{display}').exists(): break
                time.sleep(.05)
            else: raise RuntimeError('owned Xvfb readiness timeout')
            case('actual-registry',['bash',str(root/'reactivity/tools/test_atspi.sh'),launcher,str(binary)],env)
            case('late-service-owner-replacement',['dbus-run-session','--',str(binary),'native::accessibility::linux_tests::native_atspi_late_service_owner_replacement_and_destroy','--ignored','--exact','--nocapture','--test-threads=1'],env)
        finally:
            xvfb.terminate()
            try: xvfb.wait(timeout=5)
            except subprocess.TimeoutExpired: xvfb.kill(); xvfb.wait()
