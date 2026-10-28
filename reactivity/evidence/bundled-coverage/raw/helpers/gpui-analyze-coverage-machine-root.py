"""Retain inclusive caller/helper costs; never equate static frames with stack peak."""
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys

root = Path('/tmp/gpui-coverage-integration-evidence')
variants = sys.argv[1:] or ['baseline', 'candidate']
records = {}
for variant in variants:
    identity = json.loads((root / (variant + '-binary.json')).read_text())
    binary = Path(identity['frozen_path'])
    assert hashlib.sha256(binary.read_bytes()).hexdigest() == identity['sha256']
    directory = root / (variant + '-machine')
    directory.mkdir(exist_ok=True)
    for name, argv in [('sections', ['readelf', '-SW']), ('symbols', ['nm', '-S', '-C', '--size-sort']),
                       ('disassembly', ['objdump', '-d', '-C']), ('frames', ['objdump', '--dwarf=frames-interp'])]:
        path = directory / (name + '.txt')
        if not path.exists():
            with path.open('w') as output, (directory / (name + '.stderr')).open('w') as errors:
                subprocess.run(argv + [str(binary)], stdout=output, stderr=errors, check=True)
    sections = {}
    for line in (directory / 'sections.txt').read_text().splitlines():
        match = re.match(r'\s*\[\s*\d+\]\s+(\.\S+)\s+(.+)', line)
        if match:
            fields = match[2].split()
            sections[match[1]] = {'bytes': int(fields[3], 16), 'flags': fields[5]}
    functions = []
    for line in (directory / 'symbols.txt').read_text().splitlines():
        match = re.match(r'([0-9a-f]+) ([0-9a-f]+) ([tT]) (.*)', line)
        if not match:
            continue
        name = match[4]
        selected = (name == '<gpui_canvas::text::planner::Planner>::shape'
                    or 'gpui_canvas::text::coverage::' in name
                    or name == 'browser_text_oracle::main'
                    or ('Planner>::shape_inner::{closure#5}' in name and 'map_fold' in name))
        if selected:
            functions.append({'address': int(match[1], 16), 'bytes': int(match[2], 16), 'name': name})
    fdes = []
    for line in (directory / 'frames.txt').read_text().splitlines():
        match = re.search(r'FDE .*pc=([0-9a-f]+)\.\.([0-9a-f]+)', line)
        if match:
            fdes.append({'start': int(match[1], 16), 'end': int(match[2], 16), 'rsp_cfa_offsets': []})
        elif fdes:
            fdes[-1]['rsp_cfa_offsets'] += [int(value) for value in re.findall(r'\brsp\+(\d+)\b', line)]
    for function in functions:
        ranges = [fde for fde in fdes if function['address'] <= fde['start'] < function['address'] + function['bytes']]
        function['fde_ranges'] = ranges
        function['max_observed_rsp_cfa'] = max((value for fde in ranges for value in fde['rsp_cfa_offsets']), default=None)
    # Select by address rather than substring: nested Rust generic symbol names
    # contain unrelated function names and can otherwise double-count bodies.
    selected_asm = []
    for line in (directory / 'disassembly.txt').read_text().splitlines(keepends=True):
        match = re.match(r'\s*([0-9a-f]+)(?::| <)', line)
        if match and any(function['address'] <= int(match[1], 16) < function['address'] + function['bytes'] for function in functions):
            selected_asm.append(line)
    (directory / 'selected-code.txt').write_text(''.join(selected_asm))
    files = {path.name: {'bytes': path.stat().st_size, 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
             for path in directory.iterdir() if path.is_file() and path.name != 'identity.json'}
    record = {'identity': identity, 'sections': sections,
              'allocated_sections': sum(section['bytes'] for section in sections.values() if 'A' in section['flags']),
              'selected_functions': functions, 'files': files}
    (directory / 'identity.json').write_text(json.dumps(record, indent=2) + '\n')
    records[variant] = record
old = records[variants[0]]
differences = {}
for variant in variants[1:]:
    new = records[variant]
    differences[variant] = {
        'section_bytes': {name: new['sections'].get(name, {}).get('bytes', 0) - old['sections'].get(name, {}).get('bytes', 0)
                          for name in new['sections'].keys() | old['sections'].keys()},
        'allocated_section_bytes': new['allocated_sections'] - old['allocated_sections'],
    }
report = {'variants': records, 'differences_from_' + variants[0]: differences,
          'scope': 'Same-path public oracle release ELFs. Exact sections, selected linked bodies and function-local unwind observations; no timing, allocation, RSS or aggregate stack-peak inference.'}
(root / ('machine-analysis-' + '-'.join(variants) + '.json')).write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps({'differences': differences, 'functions': {
    variant: [{key: value for key, value in function.items() if key != 'fde_ranges'} for function in record['selected_functions']]
    for variant, record in records.items()}}, indent=2), flush=True)
