#!/usr/bin/env python3
"""Compare frozen old full-layout output and new full-layout/metrics output."""
import hashlib
import json
import pathlib
import sys

old_output, new_output, new_stderr, report = map(pathlib.Path, sys.argv[1:])
def digest(path):
    with path.open('rb') as handle:
        return hashlib.file_digest(handle, 'sha256').hexdigest()
expected = {}
with old_output.open() as handle:
    for line in handle:
        if line.startswith('METRIC '):
            _, case, interactive, value = line.rstrip().split(' ', 3)
            if interactive == 'false':
                assert int(case) not in expected
                expected[int(case)] = value
actual = {}
for line in new_stderr.read_text().splitlines():
    if line.startswith('MEASURE '):
        _, case, value = line.split(' ', 2)
        assert int(case) not in actual
        actual[int(case)] = value
old_hash, new_hash = digest(old_output), digest(new_output)
mismatches = {case: {'old': value, 'new': actual.get(case)}
              for case, value in expected.items() if actual.get(case) != value}
result = {'old_stdout_sha256': old_hash, 'new_stdout_sha256': new_hash,
          'stdout_byte_equal': old_hash == new_hash,
          'old_cases': len(expected), 'new_measure_cases': len(actual),
          'measure_mismatches': mismatches}
report.write_text(json.dumps(result, indent=2) + '\n')
assert old_hash == new_hash
assert len(expected) == len(actual) == 1120
assert not mismatches
print(json.dumps(result))
