#!/usr/bin/env python3
"""Frozen direct-executable controls. No compiler is invoked during capture."""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import time

HERE = Path(__file__).resolve().parent
SCRATCH = Path('/tmp/gpui-style-controls')
MANIFEST = HERE / 'frozen.json'
HOOK = '\n#[path = "../../../../evidence/style-batch/fixtures/phase.rs"]\nmod batch_phase;\n'
LEDGER = 'reactivity/crates/gpui/src/runtime/style_ledger.rs'
TEST = 'runtime::style_ledger::batch_phase::source_fanout_phase_control'
PINS = {
    'f019': ('/root/gpui-style-startup-base', 'f01947e679d9dd2ca7ef149b70dccff92dad67dc'),
    'compact': ('/root/gpui-style-startup-current', 'b6f71b4a3a0940f0159fcd1769f5006708d743cd'),
    'counted': ('/root/gpui-style-batch-counted', '642aa715ecd0428420f7cb77fa9752d2418ef301'),
    'batch': ('/root/gpui-style-batch', '1ff60868df690a566406637e0f936943a587143a'),
}


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def command(args, **kwargs):
    return subprocess.check_output(args, text=True, **kwargs)


def source_guard(tag):
    root, pin = PINS[tag]
    assert command(['git', '-C', root, 'rev-parse', 'HEAD']).strip() == pin
    changed = command(['git', '-C', root, 'diff', '--name-only']).splitlines()
    expected = [] if tag == 'f019' else [LEDGER]
    assert changed == expected, (tag, changed)
    if expected:
        original = subprocess.check_output(['git', '-C', root, 'show', f'HEAD:{LEDGER}'])
        assert (Path(root) / LEDGER).read_bytes() == original + HOOK.encode()
    files = {
        'styles': Path(root) / 'reactivity/crates/gpui/src/runtime/styles.rs',
        'property': Path(root) / 'reactivity/crates/gpui/src/property.rs',
        'runtime': Path(root) / 'reactivity/crates/gpui/src/runtime.rs',
        'lock': Path(root) / 'reactivity/Cargo.lock',
    }
    if tag in ['f019', 'compact']:
        files['literal_caller'] = Path(root) / 'reactivity/crates/gpui/examples/literal_startup.rs'
        assert sha(files['literal_caller']) == sha(HERE / 'fixtures/literal_startup.rs')
    if tag != 'f019':
        files['phase_caller'] = Path(root) / 'reactivity/evidence/style-batch/fixtures/phase.rs'
        assert sha(files['phase_caller']) == sha(HERE / 'fixtures/phase.rs')
    return {name: {'path': str(path), 'sha256': sha(path)} for name, path in files.items()}


def artifacts(path):
    return [json.loads(line) for line in Path(path).read_text().splitlines() if line.startswith('{')]


def parsed_phase(path, tag, counts):
    text = Path(path).read_text()
    assert f'pin,{tag},{PINS[tag][1]}' in text, path
    assert '1 passed; 0 failed' in text, path
    rows, after, pixels, reads = {}, {}, {}, {}
    for line in text.splitlines():
        fields = next(csv.reader([line]))
        if not fields:
            continue
        if fields[0] == 'phase':
            key = tuple(fields[1:5])
            assert key not in rows
            rows[key] = fields[5:]
        elif fields[0] == 'after':
            key = tuple(fields[1:4])
            assert key not in after
            after[key] = fields[8:]  # exact output + source/counter/header oracle
        elif fields[0] == 'pixel-digest':
            pixels[fields[1]] = fields[2]
        elif fields[0] == 'read-digest':
            reads[tuple(fields[1:3])] = fields[3]
    assert len(rows) == 6 * len(counts) * 7, (path, len(rows))
    assert {key[2] for key in rows} == {str(count) for count in counts}
    assert len(after) == 6 * len(counts) * 6
    assert len(pixels) == 6
    assert len(reads) == 6 * len(counts)
    return rows, (after, pixels, reads)


def parsed_literal(path, tag, capture):
    text = Path(path).read_text()
    assert f'pin,{tag},{PINS[tag][1]}' in text, path
    guards = [line for line in text.splitlines() if line.startswith('guard,')]
    assert len(guards) == (7 if capture else 6), guards
    costs = [next(csv.reader([line])) for line in text.splitlines() if line.startswith('cost,')]
    assert len(costs) == (12 if capture else 0)
    return guards


def freeze():
    manifest = {'runner_sha256': sha(__file__), 'sources': {}, 'executables': {}, 'build_logs': {}}
    for tag in PINS:
        manifest['sources'][tag] = source_guard(tag)
    for tag in ['f019', 'compact']:
        label = 'base' if tag == 'f019' else 'current'
        build = Path(f'/tmp/gpui-style-startup-{label}-build.jsonl')
        roots = [row for row in artifacts(build) if row.get('reason') == 'compiler-artifact' and row['target']['name'] == 'literal_startup']
        assert len(roots) == 1 and roots[0]['executable'] and not roots[0]['fresh']
        assert roots[0]['profile']['opt_level'] == '3'
        assert str(Path(PINS[tag][0]) / 'reactivity/crates/gpui') in roots[0]['package_id']
        binary = roots[0]['executable']
        manifest['executables'][f'literal-{tag}'] = {'path': binary, 'sha256': sha(binary)}
        manifest['build_logs'][str(build)] = sha(build)
    common = None
    for tag in ['compact', 'counted', 'batch']:
        build = Path(f'/tmp/gpui-style-{tag}-release-build.jsonl')
        roots = [row for row in artifacts(build) if row.get('reason') == 'compiler-artifact' and row['target']['name'] == 'gpui' and row['profile']['test'] and row.get('executable')]
        assert len(roots) == 1 and not roots[0]['fresh']
        assert roots[0]['profile']['opt_level'] == '3'
        assert str(Path(PINS[tag][0]) / 'reactivity/crates/gpui') in roots[0]['package_id']
        binary = roots[0]['executable']
        manifest['executables'][f'phase-{tag}'] = {'path': binary, 'sha256': sha(binary)}
        manifest['build_logs'][str(build)] = sha(build)
        _, oracle = parsed_phase(SCRATCH / f'phase-{tag}-guard.txt', tag, [60, 139])
        if common is None:
            common = oracle
        else:
            assert common == oracle, tag
    assert parsed_literal('/tmp/gpui-style-startup-base-guard.log', 'f019', False) == parsed_literal('/tmp/gpui-style-startup-current-guard.log', 'compact', False)
    manifest['fixtures'] = {path.name: sha(path) for path in (HERE / 'fixtures').iterdir()}
    MANIFEST.write_text(json.dumps(manifest, indent=2) + '\n')
    print(MANIFEST, flush=True)


def guard():
    frozen = json.loads(MANIFEST.read_text())
    assert frozen['runner_sha256'] == sha(__file__)
    for tag in PINS:
        assert source_guard(tag) == frozen['sources'][tag], tag
    for binary in frozen['executables'].values():
        assert sha(binary['path']) == binary['sha256'], binary
    for path, checksum in frozen['build_logs'].items():
        assert sha(path) == checksum, path
    for path in (HERE / 'fixtures').iterdir():
        assert sha(path) == frozen['fixtures'][path.name]
    return frozen


def environment():
    processes = command(['ps', '-eo', 'pid,stat,pcpu,comm'])
    for line in processes.splitlines()[1:]:
        fields = line.split()
        if len(fields) == 4 and not any(state in fields[1] for state in 'TZ'):
            assert not fields[3].startswith(('cargo', 'rustc', 'clippy', 'zig', 'rust-lld')), line
    return {
        'time_utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
        'processes': processes,
        'cpu_pressure': Path('/proc/pressure/cpu').read_text(),
        'io_pressure': Path('/proc/pressure/io').read_text(),
        'memory_pressure': Path('/proc/pressure/memory').read_text(),
    }


def capture(kind, rounds, output, budget):
    assert os.environ.get('STYLE_CONTROLS_QUIET') == 'approved', 'wait for root START'
    frozen = guard()
    assert 2 in os.sched_getaffinity(0)
    os.sched_setaffinity(0, {2})
    output.mkdir(parents=True, exist_ok=False)
    (output / 'manifest.json').write_text(json.dumps(frozen, indent=2) + '\n')
    (output / 'environment-before.json').write_text(json.dumps(environment(), indent=2) + '\n')
    deadline = time.monotonic() + budget
    for round_number in range(rounds):
        variants = ['f019', 'compact'] if kind == 'literal' else ['compact', 'counted', 'batch']
        if kind == 'literal' and round_number % 2:
            variants.reverse()
        elif kind == 'phase':
            variants = variants[round_number % 3:] + variants[:round_number % 3]
        common = None
        for tag in variants:
            guard()
            prefix = f'{kind}-{tag}'
            binary = frozen['executables'][prefix]['path']
            env = os.environ.copy()
            if kind == 'literal':
                args = [binary, 'capture']
                env['STYLE_STARTUP_CAPTURE'] = 'approved'
                env['STYLE_STARTUP_COLD_COUNT'] = '139'
            else:
                args = [binary, TEST, '--ignored', '--exact', '--nocapture', '--test-threads=1']
                env['STYLE_BATCH_MODE'] = 'capture'
                env['STYLE_BATCH_QUIET'] = 'approved'
            path = output / f'round-{round_number + 1}-{tag}.txt'
            print('START', kind, round_number + 1, tag, flush=True)
            start = time.monotonic()
            assert start < deadline, 'whole-campaign deadline'
            with path.open('w') as stream:
                run = subprocess.run(args, env=env, stdout=stream, stderr=subprocess.STDOUT, timeout=deadline-start)
            elapsed = time.monotonic() - start
            assert run.returncode == 0, path
            guard()
            oracle = parsed_literal(path, tag, True) if kind == 'literal' else parsed_phase(path, tag, [60, 139, 4096, 65536])[1]
            if common is None:
                common = oracle
            else:
                assert common == oracle, (round_number, tag, 'output/counter/header mismatch')
            print('FINISHED', kind, round_number + 1, tag, f'wall_seconds={elapsed:.3f}', flush=True)
    (output / 'environment-after.json').write_text(json.dumps(environment(), indent=2) + '\n')
    print('ALL_POSTGUARDS_PASS', flush=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('mode', choices=['freeze', 'guard', 'literal', 'phase'])
    parser.add_argument('--rounds', type=int, default=3)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--deadline', type=float, default=180)
    args = parser.parse_args()
    if args.mode == 'freeze':
        freeze()
    elif args.mode == 'guard':
        guard()
        print('ALL_FROZEN_GUARDS_PASS')
    else:
        assert args.output is not None and args.rounds > 0
        capture(args.mode, args.rounds, args.output, args.deadline)


if __name__ == '__main__':
    main()
