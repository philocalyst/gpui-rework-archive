#!/usr/bin/env python3
"""Run frozen binaries only after arranging a quiet CPU window."""
import argparse
import csv
import hashlib
import json
from pathlib import Path
import subprocess
import time

parser = argparse.ArgumentParser()
parser.add_argument('--inline', type=Path, required=True)
parser.add_argument('--candidate', type=Path, required=True)
parser.add_argument('--output', type=Path, required=True)
parser.add_argument('--pairs', type=int, default=5)
parser.add_argument('--cpu', type=int, default=2)
args = parser.parse_args()
programs = {'inline': args.inline.resolve(), 'candidate': args.candidate.resolve()}
hashes = {name: hashlib.sha256(path.read_bytes()).hexdigest() for name, path in programs.items()}
rows = []
started = time.monotonic()
for pair in range(args.pairs):
    order = ['inline', 'candidate'] if pair % 2 == 0 else ['candidate', 'inline']
    for position, variant in enumerate(order):
        result = subprocess.run(['taskset', '-c', str(args.cpu), str(programs[variant]),
            '--exact', 'runtime::space_ledger::presented_space_cost', '--ignored',
            '--nocapture', '--test-threads=1'], check=True, text=True, capture_output=True)
        args.output.with_name(f'{args.output.stem}-{pair}-{variant}.log').write_text(result.stdout + result.stderr)
        rounds = {}
        count = 0
        for line in result.stdout.splitlines():
            offset = line.find('cost,')
            if offset < 0:
                continue
            _, label, operations, elapsed = line[offset:].split(',')
            round_number = rounds.get(label, 0)
            rounds[label] = round_number + 1
            rows.append([pair, position, variant, round_number, label, int(operations), int(elapsed)])
            count += 1
        if count != 147 or set(rounds.values()) != {3}:
            raise RuntimeError(f'unexpected fixture shape: {variant}: {count}, {rounds}')
with args.output.open('w', newline='') as stream:
    writer = csv.writer(stream)
    writer.writerow(['pair', 'position', 'variant', 'round', 'label', 'operations', 'ns'])
    writer.writerows(rows)
summary = {'elapsed_s': time.monotonic() - started, 'rows': len(rows), 'pairs': args.pairs,
    'cpu': args.cpu, 'executables': {name: {'path': str(path), 'sha256': hashes[name]}
        for name, path in programs.items()}}
for name, path in programs.items():
    if hashlib.sha256(path.read_bytes()).hexdigest() != hashes[name]:
        raise RuntimeError(f'executable changed during capture: {path}')
args.output.with_suffix('.json').write_text(json.dumps(summary, indent=2) + '\n')
print(json.dumps(summary))
