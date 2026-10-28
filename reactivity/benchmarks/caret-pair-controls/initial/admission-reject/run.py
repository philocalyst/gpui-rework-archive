from pathlib import Path
import hashlib
import json
import os
import re
import statistics
import subprocess
import time

directory = Path(__file__).parent
metadata = json.loads((directory / 'metadata.json').read_text())
variants = metadata['variants']
digest = lambda path: hashlib.sha256(path.read_bytes()).hexdigest()
cpu = min(os.sched_getaffinity(0))
rows = []

def idle():
    result = subprocess.run(['ps', '-C', 'cargo', '-C', 'rustc', '-C', 'clippy-driver',
                             '-o', 'pid=,comm='], text=True, capture_output=True)
    assert not result.stdout.strip(), 'Build overlap: ' + result.stdout

def guard():
    for variant in variants.values():
        assert digest(Path(variant['binary'])) == variant['sha256']
        root = Path(variant['worktree'])
        assert all(digest(root / name) == value for name, value in variant['guard'].items())

def invoke(name, case, scope, mode, rounds, pair):
    idle()
    result = subprocess.run([variants[name]['binary'], case, scope, mode, str(rounds)],
                            text=True, capture_output=True, timeout=60,
                            preexec_fn=lambda: os.sched_setaffinity(0, {cpu}))
    row = {'variant': name, 'case': case, 'scope': scope, 'mode': mode,
           'rounds': rounds, 'pair': pair, 'exit': result.returncode,
           'stdout': result.stdout, 'stderr': result.stderr}
    rows.append(row)
    (directory / 'runs.json').write_text(json.dumps(rows, indent=2) + '\n')
    assert result.returncode == 0, row
    values = dict(re.findall(r'(\w+)=([0-9a-f]+)', result.stdout))
    assert 'checksum' in values, row
    return values

guard()
idle()
started = time.time()
summary = {'cpu': cpu, 'source': {name: value['source'] for name, value in variants.items()},
           'pairs': 7, 'cases': [], 'limits': 'Primed global fonts; isolated shaping, not UI click/startup/RSS or complete frame latency. Fixed CPU, guarded independent executables, no Cargo/rustc/Clippy overlap. Background host activity is uncontrolled.'}
for case, rounds in [('tiny', 1000), ('label', 500), ('latin', 8), ('rtl', 8),
                     ('mixed', 8), ('paragraphs', 8), ('one-grapheme', 8)]:
    for scope in ('cold', 'warm'):
        allocation = [invoke(name, case, scope, 'alloc', 1, -1) for name in variants]
        assert allocation[0] == allocation[1], (case, scope, allocation)
        samples = {name: [] for name in variants}
        checksums = set()
        for pair in range(7):
            order = list(variants)
            if pair % 2:
                order.reverse()
            for name in order:
                result = invoke(name, case, scope, 'time', rounds, pair)
                samples[name].append(int(result['ns']) / rounds)
                checksums.add(result['checksum'])
            guard()
        assert checksums == {allocation[0]['checksum']}, (case, scope, checksums)
        medians = {name: statistics.median(values) for name, values in samples.items()}
        row = {'case': case, 'scope': scope, 'rounds': rounds, 'allocation': allocation[0],
               'samples_ns': samples, 'median_ns': medians,
               'candidate_vs_baseline': medians['candidate'] / medians['baseline'] - 1}
        summary['cases'].append(row)
        (directory / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
        print(json.dumps({key: row[key] for key in ('case', 'scope', 'median_ns', 'candidate_vs_baseline')}), flush=True)
guard()
idle()
summary.update(wall_seconds=time.time() - started, source_and_binaries_unchanged=True)
(directory / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
