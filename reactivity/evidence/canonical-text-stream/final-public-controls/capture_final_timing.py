from pathlib import Path
import datetime, hashlib, json, os, signal, subprocess, sys, time

base = Path(__file__).parent
registration_path = base / 'timing-final-registration.json'
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    registration_sha = sha(registration_path)
    assert sys.argv[1:] == ['--quiet-go', registration_sha], 'explicit root quiet GO and exact registration SHA required'
    reg = json.loads(registration_path.read_text())
    assert sha(Path(__file__)) == reg['capture_runner_sha256']
    out = base / 'timing-final-capture'
    out.mkdir(exist_ok=False)
    state = {'status': 'running EXACT preregistered capture', 'registration_sha256': registration_sha,
             'started_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(), 'observations': []}
    (out / 'registration.json').write_bytes(registration_path.read_bytes())
    (out / 'runner.py').write_bytes(Path(__file__).read_bytes())
    def save():
        (out / 'metadata.json').write_text(json.dumps(state, indent=2) + '\n')
    start = time.monotonic()
    deadline = start + reg['hard_capture_cap_seconds']
    def remaining():
        value = deadline - time.monotonic()
        assert value > 0, 'preregistered hard capture cap expired'
        return value
    env = dict(os.environ)
    env['DISPLAY'] = ':115'
    root = Path(reg['source_path'])
    fixture = Path(reg['fixture_path'])
    def git(*args):
        return subprocess.check_output(['git', '-c', f'safe.directory={root}', '-C', str(root), *args], text=True)
    def guard():
        assert sha(registration_path) == registration_sha
        for name, expected in reg['frozen_evidence_sha256'].items():
            assert sha(Path(name)) == expected, name
        assert git('rev-parse', 'HEAD').strip() == reg['source_pins']['candidate']
        assert not git('status', '--porcelain')
        assert {name: sha(root / name) for name in reg['candidate_source_files']} == reg['candidate_source_files']
        assert {str(p.relative_to(fixture)): sha(p) for p in fixture.rglob('*') if p.is_file()} == reg['fixture_sha256']
        for lane in reg['binaries'].values():
            for mode in lane.values():
                for binary in mode.values():
                    assert sha(Path(binary['path'])) == binary['sha256']
        processes = subprocess.check_output(['ps', '-eo', 'pid,ppid,comm'], text=True)
        blocked = []
        for line in processes.splitlines()[1:]:
            fields = line.split()
            if len(fields) == 3 and (fields[2] in ['cargo', 'rustc', 'rustdoc', 'Xvfb'] or fields[2].startswith('canonical-text-')):
                blocked.append(line)
        assert not blocked, ('quiet process guard', blocked)
        return {'candidate_source_count': len(reg['candidate_source_files']), 'head': git('rev-parse', 'HEAD').strip(),
                'process_snapshot': processes, 'affinity': sorted(os.sched_getaffinity(0))}
    server = None
    child = None
    try:
        assert not any(k in env for k in ['RUSTFLAGS', 'CARGO_ENCODED_RUSTFLAGS', 'RUSTC_BOOTSTRAP'])
        assert not [key for key in env if key.startswith('CARGO_PROFILE_')]
        os.sched_setaffinity(0, {reg['cpu']})
        assert os.sched_getaffinity(0) == {reg['cpu']}
        state['before_guard'] = guard()
        save()
        assert not Path('/tmp/.X11-unix/X115').exists()
        with (out / 'xvfb.log').open('w') as log:
            server = subprocess.Popen([reg['xvfb'], ':115', '-screen', '0', '800x600x24', '-nolisten', 'tcp'],
                                      stdout=log, stderr=subprocess.STDOUT, start_new_session=True, env=env)
        for _ in range(100):
            remaining()
            assert server.poll() is None
            if Path('/tmp/.X11-unix/X115').exists():
                break
            time.sleep(.01)
        assert Path('/tmp/.X11-unix/X115').exists()
        for pair in range(reg['pairs']):
            cells = reg['cells'] if pair % 2 == 0 else list(reversed(reg['cells']))
            for cell in cells:
                labels = ['baseline', 'candidate'] if (pair + cell['id']) % 2 == 0 else ['candidate', 'baseline']
                for label in labels:
                    binary = 'canonical-text-public-control' if cell['kind'] == 'ordinary' else 'canonical-text-native-control'
                    argv = [reg['binaries'][label]['normal'][binary]['path'], 'measure', cell['case'], cell['operation'], str(cell['count'])]
                    if cell['kind'] == 'native':
                        argv = [reg['dbus'], '--', *argv]
                    path = out / f"{pair:02d}-{cell['id']:02d}-{label}.log"
                    record = {'pair': pair, 'cell_id': cell['id'], 'label': label, 'argv': argv, 'log': str(path)}
                    state['observations'].append(record)
                    save()
                    with path.open('w') as log:
                        child = subprocess.Popen(argv, cwd=root, env=env, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
                        try:
                            record['exit'] = child.wait(timeout=remaining())
                        except BaseException:
                            os.killpg(child.pid, signal.SIGKILL)
                            child.wait()
                            raise
                    child = None
                    record['log_sha256'] = sha(path)
                    assert record['exit'] == 0, record
                    values = [json.loads(line) for line in path.read_text().splitlines() if line.startswith('{')]
                    assert len(values) == 1
                    value = values[0]
                    record['raw_output'] = value
                    observed = dict(value)
                    if cell['kind'] == 'ordinary':
                        assert value['elapsed_ns'] > 0
                        observed['elapsed_ns'] = 0
                    else:
                        assert len(value['elapsed_ns']) == cell['count'] and all(n > 0 for n in value['elapsed_ns'])
                        assert len(value['host_ack_elapsed_ns']) == cell['count'] and all(n > 0 for n in value['host_ack_elapsed_ns'])
                        observed['elapsed_ns'] = []
                        observed['host_ack_elapsed_ns'] = []
                        observed['provider_60hz_budget_exceeded'] = 0
                        observed['host_ack_60hz_budget_exceeded'] = 0
                        observed['ack_epochs'] = [list(epoch) for epoch in dict.fromkeys(map(tuple, observed['ack_epochs']))]
                    assert observed == reg['expected_outputs'][str(cell['id'])], (pair, cell['id'], label, 'frozen observable output mismatch')
                    record['observable_guard'] = 'PASS'
                    save()
                    print(pair, cell['id'], label, 'PASS', flush=True)
        assert len(state['observations']) == reg['observations']
        server.terminate()
        server.wait(timeout=min(10, remaining()))
        state['xvfb_exit'] = server.returncode
        server = None
        state['after_guard'] = guard()
        state['status'] = 'complete; exact preregistered capture; gates pending analysis'
    except BaseException as error:
        state['status'] = 'FAILED/PARTIAL; preserve; no retry/resample/adaptation'
        state['failure'] = repr(error)
        raise
    finally:
        if child is not None and child.poll() is None:
            os.killpg(child.pid, signal.SIGKILL)
            child.wait()
        if server is not None:
            server.terminate()
            try:
                server.wait(timeout=5)
            except subprocess.TimeoutExpired:
                server.kill()
                server.wait()
            state['xvfb_exit'] = server.returncode
        state['capture_wall_seconds'] = time.monotonic() - start
        state['ended_utc'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
        save()

if __name__ == '__main__':
    main()
