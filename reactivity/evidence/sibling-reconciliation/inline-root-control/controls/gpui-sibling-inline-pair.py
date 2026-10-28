from pathlib import Path
import datetime
import hashlib
import json
import os
import re
import statistics
import subprocess
import time

out = Path('/tmp/gpui-sibling-inline-pair')
out.mkdir(exist_ok=False)
bins = {'baseline': Path('/tmp/gpui-sibling-controls/candidate'),
        'candidate': Path('/tmp/gpui-sibling-controls/inline-root')}
digest = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
hashes = {name: digest(path) for name, path in bins.items()}
assert hashes == {'baseline': '3167f4aa76af6d89c02d5a9da99924a5e88ec0331a1d68501b65b51485ef1e07', 'candidate': 'ed948ea1e0ccddaad1104b2e89f19cdd20eff6a02c76a9d2cd924367d51f7e2d'}
assert 0 in os.sched_getaffinity(0)
rows = []
audits = []
start = time.monotonic()
utc = lambda: datetime.datetime.now(datetime.timezone.utc).isoformat()
metadata = {'baseline_source': 'eb2a286f950212014b0da01ea071763a4efe5593', 'candidate_source': '926105a025dcae6b543bef9d56ee958f8504e244', 'started': utc(), 'binary_sha256': hashes, 'cpu': 0,
            'quiet_cooperators': ['static_shader_sol', 'text_selection_sol', 'route_columns_sol'],
            'scope': '7 alternating pairs, ordinary unchanged-tree redescription; setup/priming excluded; whole update included; no frame/startup/RSS claim; unrelated host activity uncontrolled'}
(out / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
for cohort in ['tiny', 'flat1k', 'nested1k', 'flat16k']:
    for pair in range(7):
        assert time.monotonic() - start < 40, 'quiet campaign budget exceeded'
        audit = subprocess.run(['ps', '-C', 'cargo,rustc,clippy-driver,valgrind', '-o', 'pid=,stat=,comm='], capture_output=True, text=True)
        audits.append({'cohort': cohort, 'pair': pair, 'output': audit.stdout, 'exit': audit.returncode})
        assert not audit.stdout.strip(), audit.stdout
        assert {name: digest(path) for name, path in bins.items()} == hashes
        order = ['baseline', 'candidate'] if pair % 2 == 0 else ['candidate', 'baseline']
        for name in order:
            command = [str(bins[name]), '--exact', 'ordinary_redescription_release_samples', '--ignored', '--nocapture', '--test-threads=1']
            result = subprocess.run(command, env=os.environ | {'SIBLING_COHORT': cohort}, capture_output=True, text=True, timeout=20,
                                    preexec_fn=lambda: os.sched_setaffinity(0, {0}))
            output = result.stdout + result.stderr
            (out / f'{cohort}-{pair}-{name}.log').write_text(output)
            assert result.returncode == 0, output
            match = re.search(r'SIBLING_TIME cohort=(\w+) iterations=(\d+) elapsed_ns=(\d+)', output)
            assert match and match[1] == cohort, output
            rows.append({'cohort': cohort, 'pair': pair, 'variant': name, 'iterations': int(match[2]), 'elapsed_ns': int(match[3]), 'command': command})
            (out / 'runs.json').write_text(json.dumps(rows, indent=2) + '\n')
        assert {name: digest(path) for name, path in bins.items()} == hashes
    a = [row['elapsed_ns'] for row in rows if row['cohort'] == cohort and row['variant'] == 'baseline']
    b = [row['elapsed_ns'] for row in rows if row['cohort'] == cohort and row['variant'] == 'candidate']
    print(json.dumps({'cohort': cohort, 'baseline_median_ns': statistics.median(a), 'candidate_median_ns': statistics.median(b), 'change_percent': (statistics.median(b) / statistics.median(a) - 1) * 100}), flush=True)
metadata.update({'finished': utc(), 'wall_seconds': time.monotonic() - start, 'complete': True})
(out / 'metadata.json').write_text(json.dumps(metadata, indent=2) + '\n')
(out / 'process-audits.json').write_text(json.dumps(audits, indent=2) + '\n')
