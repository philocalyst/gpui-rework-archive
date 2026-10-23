import csv
import hashlib
import json
import pathlib
import runpy

out = pathlib.Path(__file__).parent
root = out.parent
namespace = runpy.run_path(str(out / 'final_ledgers.py'))
parse = namespace['parse']
directory = out / 'known-attribution'
actual = parse(directory / 'runtime.log')
normal = json.loads((out / 'constructor-release-comparison.json').read_text())['candidate_rows']
assert actual == normal
before = json.loads((root / 'attribution-sites.json').read_text())
after = json.loads((directory / 'attribution-sites.json').read_text())
rows = {}
for cohort in actual:
    for phase in ['spawn', 'connected', 'mounted']:
        key = f"{cohort['cohort']}-{phase}"
        categories = after['phases'][key]['categories']
        expected = cohort[phase]
        assert sum(row['requests'] for row in categories.values()) == expected['count_total']
        assert sum(row['requested_bytes'] for row in categories.values()) == expected['bytes_total']
        assert sum(row['counter_retained_count'] for row in categories.values()) == expected['count_current']
        assert sum(row['counter_retained_bytes'] for row in categories.values()) == expected['bytes_current']
        old = before['phases'][key]['categories']
        rows[key] = {
            category: {field: categories.get(category, {}).get(field, 0) - old.get(category, {}).get(field, 0) for field in ['requests', 'requested_bytes', 'counter_retained_count', 'counter_retained_bytes', 'frees']}
            for category in old.keys() | categories.keys()
        }
symbols = json.loads((directory / 'symbols.json').read_text())
base = int((directory / 'raw/exe-base.txt').read_text(), 16)
reviews = []
for cohort, phase, pointer in after['unobserved_free_pointer_reuse']:
    events = []
    for current in ['spawn', 'connected', 'mounted']:
        with (directory / f'raw/{cohort}-{current}.csv').open() as source:
            for event in csv.DictReader(source):
                if int(event['pointer'], 16) != int(pointer, 16):
                    continue
                candidates = [pair for pc in event['pcs'].split(';') for pair in symbols.get(hex(int(pc, 16)-base-1), [])]
                origin = next((pair for pair in candidates if '/reactivity/' in pair[1]), None)
                events.append({'phase': current, 'kind': event['kind'], 'bytes': int(event['size']), 'first_core_site': origin})
    spawn = [event for event in events if event['phase'] == 'spawn']
    assert spawn[-1]['kind'] == 'alloc' and spawn[-1]['bytes'] == 24
    assert 'Worker>::new' in spawn[-1]['first_core_site'][0]
    reviews.append({'cohort': cohort, 'phase': phase, 'pointer': pointer, 'events': events, 'interpretation': 'Thread-name allocation was freed by worker outside calling-thread trace before its address was reused. Counter retained values are not all-thread live heap.'})
(directory / 'pointer-reuse-review.json').write_text(json.dumps(reviews, indent=2) + '\n')
binary = directory / 'browser-allocation-sites'
expected = json.loads((directory / 'binary.json').read_text())['sha256']
assert hashlib.file_digest(binary.open('rb'), 'sha256').hexdigest() == expected
report = {'scope': 'Calling-thread diagnostic backtrace attribution, accepted only after every phase/header/counter equals normal release constructor. Diagnostic build invocation differs in Cargo ancestor config and is not used for code-size or timing comparisons. Counter-retained categories are not all-thread heap; cross-thread thread-name address reuse is reviewed separately.', 'all_original_phase_counters_equal_normal': True, 'binary_sha256_unchanged': expected, 'category_deltas_from_dfc4': rows, 'cross_thread_pointer_reuse_records': len(reviews)}
(out / 'attribution-comparison.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps({key: value for key, value in report.items() if key != 'category_deltas_from_dfc4'}, indent=2))
