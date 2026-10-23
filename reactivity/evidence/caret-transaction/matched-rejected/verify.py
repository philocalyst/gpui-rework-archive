"""Verify sealed evidence offline; never build or execute a measurement client."""
from pathlib import Path
import gzip
import hashlib
import json
import math
import statistics
import subprocess
import tarfile
import tempfile


BASE = Path(__file__).resolve().parent


def read(name):
    return json.loads((BASE / name).read_text())


def sha(data):
    return hashlib.sha256(data).hexdigest()


def check_sources(candidate, control):
    with tarfile.open(BASE / 'candidate-source-closure.tar.gz') as archive:
        source = {member.name: archive.extractfile(member).read() for member in archive}
    assert {name: sha(data) for name, data in source.items()} == candidate['source_guard']
    with tarfile.open(BASE / 'indexed-four-modules.tar.gz') as archive:
        indexed = {member.name: archive.extractfile(member).read() for member in archive}
    assert set(indexed) == set(control['changed_files'])
    assert {name: sha(indexed.get(name, data)) for name, data in source.items()} == control['source_guard']
    assert candidate['input_guard'] == control['input_guard']
    for name, expected in candidate['input_guard'].items():
        assert sha((BASE / 'public-fixture' / name).read_bytes()) == expected
    assert sha((BASE / 'root-cargo-config.toml').read_bytes()) == candidate['config_sha256'] == control['config_sha256']
    # Apply and reverse the exact standalone patch without changing any checkout.
    with tempfile.TemporaryDirectory(prefix='gpui-text-evidence-') as directory:
        folder = Path(directory)
        for name in indexed:
            path = folder / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(source[name])
        patch = BASE / 'indexed-from-candidate-b5.patch'
        subprocess.run(['git', 'apply', str(patch)], cwd=folder, check=True)
        assert all((folder / name).read_bytes() == data for name, data in indexed.items())
        subprocess.run(['git', 'apply', '--reverse', str(patch)], cwd=folder, check=True)
        assert all((folder / name).read_bytes() == source[name] for name in indexed)
        subprocess.run(['git', 'apply', '--reverse', str(BASE / 'candidate-from-main8c17.patch')], cwd=folder, check=True)
        assert all((folder / name).read_bytes() == data for name, data in indexed.items())
        subprocess.run(['git', 'apply', str(BASE / 'candidate-from-main8c17.patch')], cwd=folder, check=True)
        assert all((folder / name).read_bytes() == source[name] for name in indexed)


def verify():
    manifest = BASE / 'archive-sha256.json'
    if manifest.exists():
        for name, expected in read('archive-sha256.json').items():
            assert sha((BASE / name).read_bytes()) == expected, name
    candidate, control = read('candidate-results.json'), read('control-results.json')
    config, original = read('pair.json'), read('timing-196-root/summary.json')
    for name, expected in config['artifacts'].items():
        assert sha((BASE / name).read_bytes()) == expected, name
    for item in read('compression.json'):
        data = gzip.decompress((BASE / item['path']).read_bytes())
        assert len(data) == item['uncompressed_bytes'] and sha(data) == item['uncompressed_sha256']
    check_sources(candidate, control)
    fingerprints = read('required-fingerprint-comparison.json')
    for pair in fingerprints.values():
        indexed, partial = pair['indexed']['fingerprint'], pair['partial']['fingerprint']
        for field in ('rustc', 'features', 'declared_features', 'target', 'profile', 'path', 'rustflags', 'config', 'compile_kind'):
            assert indexed[field] == partial[field]
        assert indexed['rustflags'] == ['-C', 'symbol-mangling-version=v0', '--cfg', 'tokio_unstable']
    for role in (candidate, control):
        assert role['all_guards_passed']
        assert all(not artifact['fresh'] for artifact in role['required_artifacts'].values())
        assert all(not binary['artifact']['fresh'] for binary in role['binaries'].values())
    assert candidate['compiler'] == control['compiler']
    assert candidate['transcript_bytes'] == control['transcript_bytes'] == 2678729
    assert candidate['transcript_sha256'] == control['transcript_sha256']
    assert read('whole-tree-patch-verification.json')['verified']
    comparison = read('comparison.json')
    for row in comparison['allocator_rows']:
        assert row['indexed']['checksum'] == row['partial']['checksum']
        assert row['indexed']['retained'] == row['partial']['retained']
        for role, evidence in (('indexed', control), ('partial', candidate)):
            capture = next(item for item in evidence['allocator_rows'] if (item['case'], item['scope']) == (row['case'], row['scope']))
            values = dict(field.split('=', 1) for field in capture['stdout'].strip().split(',')[3:])
            assert capture['exit'] == 0
            assert {key: int(value) if key != 'checksum' else value for key, value in values.items()} == row[role]
    rows = [json.loads(line) for line in (BASE / 'timing-196-root/raw.jsonl').read_text().splitlines()]
    assert len(rows) == config['observations'] == 196
    expected = [(pair, case, scope, role) for pair in range(config['pairs'])
                for case in config['cases'] for scope in config['scopes']
                for role in (['indexed', 'partial'] if pair % 2 == 0 else ['partial', 'indexed'])]
    samples = {}
    for row, key in zip(rows, expected):
        assert (row['pair'], row['case'], row['scope'], row['role']) == key
        assert row['exit'] == 0
        fields = row['stdout'].strip().split(',')
        assert fields[:3] == ['time', row['case'], row['scope']]
        values = dict(field.split('=', 1) for field in fields[3:])
        rounds = config['rounds']['short' if row['case'] in ('tiny', 'label') else 'bulk'][row['scope']]
        assert int(values['rounds']) == row['rounds'] == rounds
        assert values['checksum'] == config['checksums'][row['case']]
        samples[key] = int(values['ns']) / rounds
    cells = []
    for case in config['cases']:
        for scope in config['scopes']:
            indexed = [samples[pair, case, scope, 'indexed'] for pair in range(config['pairs'])]
            partial = [samples[pair, case, scope, 'partial'] for pair in range(config['pairs'])]
            ratios = [b / a for a, b in zip(indexed, partial)]
            old = next(cell for cell in original['cells'] if (cell['case'], cell['scope']) == (case, scope))
            assert ratios == old['paired_ratios']
            assert statistics.median(ratios) == old['median_paired_ratio']
            cells.append(dict(case=case, scope=scope, indexed_ns=indexed, partial_ns=partial,
                              paired_ratios=ratios, median_paired_ratio=statistics.median(ratios),
                              ratio_of_medians=statistics.median(partial) / statistics.median(indexed),
                              indexed_median_ns=statistics.median(indexed), partial_median_ns=statistics.median(partial),
                              minimum=min(ratios), maximum=max(ratios)))
    bulk = [cell['median_paired_ratio'] for cell in cells if cell['case'] in config['gate']['bulk_cases']]
    aggregate = math.exp(sum(map(math.log, bulk)) / len(bulk))
    assert aggregate == original['bulk_geometric_ratio']
    gate = all(cell['median_paired_ratio'] <= config['gate']['max_cell_ratio'] for cell in cells) and aggregate <= config['gate']['max_bulk_geometric_ratio']
    assert gate == original['gate_passed'] is False
    assert read('timing-196-root/start.json')['guard_before'] == original['guard_after'] == {'count': 868, 'all_passed': True}
    return dict(verified=True, observations=len(rows), cells=cells, bulk_geometric_ratio=aggregate,
                gate_passed=gate, decision='REJECTED; no resampling or threshold change',
                source_files=len(candidate['source_guard']), fingerprint_pairs=len(fingerprints))


if __name__ == '__main__':
    result = verify()
    (BASE / 'verification.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({key: value for key, value in result.items() if key != 'cells'}, indent=2))
