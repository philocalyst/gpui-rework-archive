import json
import pathlib

out = pathlib.Path(__file__).parent
graphs = {
    'constructor': ('static-constructor-baseline-v3', 'static-constructor-candidate-v3'),
    'native': ('static-native-baseline', 'static-native-candidate'),
}
result = {'scope': 'Whole normal release Cargo rlib ELF object sections and final executable sections, same physical source/build path and matched feature/profile/package identities. Archive sums include unused monomorphizations and are not mapped pages/RSS; aliases are never summed. Linked ELF reports are separate, not additive with archives.', 'graphs': {}}
for graph, (before, after) in graphs.items():
    old = {value['artifact']['target']: value for value in json.loads((out / before / 'bill.json').read_text()).values()}
    new = {value['artifact']['target']: value for value in json.loads((out / after / 'bill.json').read_text()).values()}
    assert old.keys() == new.keys()
    rows = {}
    for target in old:
        a, b = old[target], new[target]
        for field in ['features', 'profile', 'package', 'target']:
            assert a['artifact'][field] == b['artifact'][field], (graph, target, field)
        rows[target] = {
            'baseline': {key: a[key] for key in ['file_bytes', 'allocated_section_bytes', 'categories']},
            'candidate': {key: b[key] for key in ['file_bytes', 'allocated_section_bytes', 'categories']},
            'delta': {key: b[key] - a[key] for key in ['file_bytes', 'allocated_section_bytes']},
            'category_delta': {key: b['categories'][key] - a['categories'][key] for key in a['categories']},
            'sha256': {'baseline': a['artifact']['sha256'], 'candidate': b['artifact']['sha256']},
        }
    result['graphs'][graph] = rows
(out / 'whole-code-comparison.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({graph: {target: {'delta': row['delta'], 'category_delta': row['category_delta']} for target, row in rows.items()} for graph, rows in result['graphs'].items()}, indent=2))
