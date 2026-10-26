"""Alternate matched ordinary-query controls with source and executable guards."""
import argparse, csv, hashlib, os, pathlib, subprocess, time

parser = argparse.ArgumentParser(description=__doc__)
for name in ['baseline-root', 'candidate-root', 'baseline-bin', 'candidate-bin', 'output-dir']:
    parser.add_argument('--' + name, type=pathlib.Path, required=True)
args = parser.parse_args()
root = args.output_dir
root.mkdir(parents=True, exist_ok=True)
executables = {'baseline': args.baseline_bin.resolve(), 'candidate': args.candidate_bin.resolve()}
trees = {'baseline': args.baseline_root.resolve(), 'candidate': args.candidate_root.resolve()}
sources = {variant: tree / 'reactivity/crates/canvas/src/text/layout/interaction.rs' for variant, tree in trees.items()}
drivers = [tree / 'reactivity/crates/canvas/examples/selection_queries.rs' for tree in trees.values()]
def digest(path): return hashlib.sha256(path.read_bytes()).hexdigest()
def identities(): return {str(path): digest(path) for path in [*executables.values(), *sources.values(), *drivers]}
initial = identities()
assert digest(executables['baseline']) != digest(executables['candidate'])
assert digest(sources['baseline']) != digest(sources['candidate'])
assert digest(drivers[0]) == digest(drivers[1])
cpu = 2 if 2 in os.sched_getaffinity(0) else min(os.sched_getaffinity(0))
rows = []
started = time.monotonic()
for paragraphs, iterations in [(1, 30000), (1800, 300)]:
    for pair in range(7):
        outputs = {}
        order = ['baseline', 'candidate'] if pair % 2 == 0 else ['candidate', 'baseline']
        for variant in order:
            assert identities() == initial
            output = subprocess.check_output(['taskset', '-c', str(cpu), str(executables[variant]), str(iterations), str(paragraphs)], text=True)
            parsed = list(csv.DictReader(output.splitlines()))
            outputs[variant] = {row['case']: tuple(row[k] for k in ['bytes', 'lines', 'rounds', 'signature']) for row in parsed}
            for row in parsed:
                rows.append({'variant': variant, 'pair': pair, 'paragraphs': paragraphs, 'cpu': cpu, **row})
        assert outputs['baseline'] == outputs['candidate'], outputs
assert identities() == initial
with (root / 'text-selection-cut.csv').open('w') as file:
    writer = csv.DictWriter(file, fieldnames=list(rows[0]), lineterminator='\n'); writer.writeheader(); writer.writerows(rows)
with (root / 'text-selection-cut-identities.csv').open('w') as file:
    writer = csv.writer(file, lineterminator='\n'); writer.writerow(['path','sha256']); writer.writerows(initial.items())
print(f'END {len(rows)} rows, CPU {cpu}, {time.monotonic()-started:.3f}s, all per-pair identities/signatures equal')
