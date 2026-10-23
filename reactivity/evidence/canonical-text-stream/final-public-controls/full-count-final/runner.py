from pathlib import Path
import hashlib, json, os, subprocess, time

base = Path(__file__).parent
out = base / 'full-count-final'
out.mkdir(exist_ok=False)
builds = base / 'matched-release-codegen-final'
meta = json.loads((builds / 'metadata.json').read_text())
registration_path = base / 'timing-fixed-work-registration.json'
registration = json.loads(registration_path.read_text())
root = Path(meta['source_path'])
fixture = Path(meta['fixture_path'])
dbus = '/nix/store/8snmq54bp5d5vp5dihgn7xr53hayx629-dbus-1.16.2/bin/dbus-run-session'
xvfb = '/nix/store/dsmjn4c7f9grzihzwf605yhmp8gsbjdz-xvfb-21.1.23/bin/Xvfb'

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
def git(*args):
    return subprocess.check_output(['git', '-c', f'safe.directory={root}', '-C', str(root), *args], text=True)
def snapshot():
    source = meta['variants']['candidate']['source_files']
    assert {name: sha(root / name) for name in source} == source
    assert git('rev-parse', 'HEAD').strip() == meta['source_pins']['candidate']
    assert not git('status', '--porcelain')
    assert {str(p.relative_to(fixture)): sha(p) for p in fixture.rglob('*') if p.is_file()} == meta['fixture_sha256']
    binaries = {label: meta['variants'][label]['builds']['normal']['binaries'] for label in ['baseline', 'candidate']}
    for lane in binaries.values():
        for item in lane.values():
            assert sha(Path(item['path'])) == item['sha256']
    assert sha(registration_path) == state['registration_sha256']
    return {'source_files': len(source), 'source_pin': git('rev-parse', 'HEAD').strip(), 'fixture': meta['fixture_sha256'], 'binaries': binaries}

env = dict(os.environ)
for key in ['RUSTFLAGS', 'CARGO_ENCODED_RUSTFLAGS', 'RUSTC_BOOTSTRAP']:
    env.pop(key, None)
env['DISPLAY'] = ':115'
state = {'status': 'running no-clock correctness; NO timing', 'registration_sha256': sha(registration_path),
         'registration': registration, 'runner_sha256': sha(Path(__file__)), 'results': []}
(out / 'runner.py').write_bytes(Path(__file__).read_bytes())
def save():
    (out / 'metadata.json').write_text(json.dumps(state, indent=2) + '\n')

def normalized(value, cell):
    assert value['count'] == cell['count']
    if cell['kind'] == 'ordinary':
        assert value['case'] == cell['case'] and value['operation'] == cell['operation']
        assert value['elapsed_ns'] == 0
    else:
        assert value['elapsed_ns'] == [] and value['host_ack_elapsed_ns'] == []
        assert value['failed_prepare_old_p_checked'] and value['provider_completed_cycles'] == cell['count']
        assert value['busy'] == (cell['operation'] == 'busy')
        value = dict(value)
        value['ack_epochs'] = [list(epoch) for epoch in dict.fromkeys(map(tuple, value['ack_epochs']))]
        epochs = 2 * cell['count'] if value['busy'] else cell['count']
        assert value['ack_epochs'] == [[i, i] for i in range(epochs + 1)] + [[epochs + 2, epochs + 2]]
        assert value['source_epoch_before_close'] == epochs + 2
    return value

assert meta['status'].startswith('complete;') and meta['restored_candidate']
state['before_guard'] = snapshot()
save()
server = None
try:
    assert not Path('/tmp/.X11-unix/X115').exists(), 'private display still occupied'
    with (out / 'xvfb.log').open('w') as log:
        server = subprocess.Popen([xvfb, ':115', '-screen', '0', '800x600x24', '-nolisten', 'tcp'], stdout=log, stderr=subprocess.STDOUT)
    for _ in range(100):
        assert server.poll() is None
        if Path('/tmp/.X11-unix/X115').exists():
            break
        time.sleep(.01)
    assert Path('/tmp/.X11-unix/X115').exists()
    for cell in registration['cells']:
        expected = None
        for label in ['baseline', 'candidate']:
            binaries = meta['variants'][label]['builds']['normal']['binaries']
            name = 'canonical-text-public-control' if cell['kind'] == 'ordinary' else 'canonical-text-native-control'
            command = [binaries[name]['path'], 'verify' if cell['kind'] == 'ordinary' else 'oracle',
                       cell['case'], cell['operation'], str(cell['count'])]
            if cell['kind'] == 'native':
                command = [dbus, '--', *command]
            logpath = out / f"{cell['id']:02d}-{label}-{cell['case']}-{cell['operation']}.log"
            record = {'cell': cell, 'label': label, 'argv': command, 'log': str(logpath)}
            state['results'].append(record)
            save()
            with logpath.open('w') as log:
                result = subprocess.run(command, cwd=root, env=env, stdout=log, stderr=subprocess.STDOUT, timeout=900)
            record['exit'] = result.returncode
            save()
            assert result.returncode == 0, record
            values = [json.loads(line) for line in logpath.read_text().splitlines() if line.startswith('{')]
            assert len(values) == 1
            record['raw_output'] = values[0]
            record['normalized_output'] = normalized(values[0], cell)
            record['log_sha256'] = sha(logpath)
            if expected is None:
                expected = record['normalized_output']
            else:
                assert record['normalized_output'] == expected, (cell, 'baseline/candidate mismatch')
            save()
            print(cell['id'], label, cell['case'], cell['operation'], 'PASS', flush=True)
    state['after_guard'] = snapshot()
    state['status'] = 'complete; 140 full-count executions/70 cells exact PASS; clocks disabled; NO timing'
except BaseException as error:
    state['status'] = 'FAILED; preserve partial; NO timing'
    state['failure'] = repr(error)
    raise
finally:
    if server is not None:
        server.terminate()
        try:
            server.wait(timeout=10)
        except subprocess.TimeoutExpired:
            server.kill()
            server.wait()
        state['xvfb_exit'] = server.returncode
    save()
