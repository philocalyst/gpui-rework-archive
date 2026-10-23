import ast
import hashlib
import json
import pathlib
import re

out = pathlib.Path(__file__).parent
result = {'scope': 'Optimized standalone callers linked to actual frozen normal release rlibs. Same fixture source and flags for each old/new pair. These are not full application code/performance or all-thread resource claims.', 'fixtures': {}}
for fixture in ['mixed-caller-v2', 'public-geometry-cost-v2']:
    rows = {}
    for variant in ['baseline', 'candidate']:
        directory = out / fixture / variant
        capture = json.loads((directory / 'capture.json').read_text())
        binary = directory / fixture
        assert capture['runtime_exit'] == 0
        assert hashlib.file_digest(binary.open('rb'), 'sha256').hexdigest() == capture['binary_sha256']
        directory.with_suffix('.json').write_text(json.dumps({fixture: {'original': str(binary), 'sha256': capture['binary_sha256'], 'features': [variant], 'profile': {'opt_level': '3', 'debuginfo': 0}, 'package': 'standalone-public-control', 'target': fixture}}, indent=2) + '\n')
        text = (directory / 'runtime.log').read_text()
        if fixture == 'mixed-caller-v2':
            lines = text.splitlines()
            assert len(lines) % 3 == 0
            rows[variant] = [{'width': float(lines[index]), 'full_height_aware': ast.literal_eval(lines[index+1]), 'width_service': ast.literal_eval(lines[index+2])} for index in range(0, len(lines), 3)]
        else:
            parsed = {'shape': [], 'owner': [], 'headers': {}}
            for line in text.splitlines():
                if line.startswith('HEADERS '):
                    parsed['headers'] = {key: int(value) for key, value in re.findall(r'(\w+)=(\d+)', line)}
                elif line.startswith(('SHAPE ', 'OWNER ')):
                    left, body = line.split(' cost=AllocationInfo { ', 1)
                    cost = {key: int(value) for key, value in re.findall(r'(\w+): (-?\d+)', body)}
                    name = re.search(r'case=(\S+)', left)[1]
                    if left.startswith('SHAPE'):
                        parsed['shape'].append({'case': name, 'interactive': 'interactive=true' in left, 'glyphs': int(re.search(r'glyphs=(\d+)', left)[1]), 'metrics': ast.literal_eval(left.split('metrics=')[1]), 'cost': cost})
                    else:
                        parsed['owner'].append({'case': name, 'cost': cost})
            assert len(parsed['shape']) == 10 and len(parsed['owner']) == 4
            rows[variant] = parsed
    if fixture == 'mixed-caller-v2':
        assert rows['baseline'] == rows['candidate']
        result['fixtures'][fixture] = {'rows': rows, 'all_layout_bits_equal': True}
    else:
        assert rows['baseline']['headers'] == rows['candidate']['headers']
        assert rows['baseline']['shape'] == rows['candidate']['shape']
        deltas = []
        for before, after in zip(rows['baseline']['owner'], rows['candidate']['owner']):
            assert before['case'] == after['case']
            deltas.append({'case': before['case'], 'cost': {key: after['cost'][key]-before['cost'][key] for key in before['cost']}})
        result['fixtures'][fixture] = {'rows': rows, 'all_direct_shape_outputs_and_costs_equal': True, 'public_p_old_c_failed_l_geometry_assertions_passed': True, 'owner_cost_deltas': deltas}
(out / 'optimized-public-controls.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({key: {field: value for field, value in item.items() if field != 'rows'} for key, item in result['fixtures'].items()}, indent=2))
