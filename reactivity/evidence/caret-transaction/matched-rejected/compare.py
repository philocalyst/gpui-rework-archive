"""Compare frozen matched allocation rows and optimized linked code; never time."""
from pathlib import Path
import hashlib, json, re, subprocess
out = Path(__file__).resolve().parent
control = json.loads((out / 'control-results.json').read_text())
candidate = json.loads((out / 'candidate-results.json').read_text())
assert control['input_guard'] == candidate['input_guard']
assert control['compiler'] == candidate['compiler']
assert control['config_sha256'] == candidate['config_sha256']
sha = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()
def alloc(row):
    fields = row['stdout'].strip().split(',')
    result = dict(x.split('=', 1) for x in fields[3:])
    return {k: (v if k == 'checksum' else int(v)) for k, v in result.items()}
rows = []
for a, b in zip(control['allocator_rows'], candidate['allocator_rows']):
    assert (a['case'], a['scope']) == (b['case'], b['scope'])
    old, new = alloc(a), alloc(b)
    assert old['checksum'] == new['checksum']
    assert old['retained'] == new['retained']
    rows.append(dict(case=a['case'], scope=a['scope'], indexed=old, partial=new,
                     delta={k: new[k] - old[k] for k in old if k != 'checksum'}))
base = '/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin/'
assembly = {}
for label, meta in [('indexed', control), ('partial', candidate)]:
    assembly[label] = {}
    for scope, name in [('shaper', 'caret_pair_measure'), ('owner', 'owner')]:
        binary = meta['binaries'][name]
        assert sha(binary['path']) == binary['sha256']
        nm = subprocess.check_output([base+'nm', '--print-size', '--size-sort', '--demangle', binary['path']], text=True)
        (out / (label+'-'+scope+'-symbols.txt')).write_text(nm)
        sections = subprocess.check_output([base+'objdump', '-h', binary['path']], text=True)
        (out / (label+'-'+scope+'-sections.txt')).write_text(sections)
        selected = {}
        for line in nm.splitlines():
            fields = line.split(maxsplit=3)
            if len(fields) != 4:
                continue
            symbol = fields[3]
            wanted = (symbol.endswith('<gpui_canvas::text::planner::Planner>::shape')
                      or 'gpui_canvas::text::planner::append_caret' == symbol
                      or symbol == 'parley::layout::run::count_graphemes'
                      or ('parley::editing::geometry::CursorGeometry<()>' in symbol and ('::new' in symbol or '::try_for_each_pair_partial' in symbol or '::geometries_at' in symbol))
                      or 'try_for_each_cluster::<' in symbol
                      or symbol.endswith('<parley::layout::run::Clusters<()>>::new')
                      or symbol.endswith('<parley::layout::run::Clusters<()>>::advance_cursor')
                      or symbol == 'parley::editing::geometry::pair_from_entries::<()>')
            if wanted:
                address, size = int(fields[0], 16), int(fields[1], 16)
                data = subprocess.check_output([base+'objdump', '-d', '--demangle', f'--start-address={address}', f'--stop-address={address+size}', binary['path']], text=True)
                filename = f'{label}-{scope}-{address:x}.asm'
                (out / filename).write_text(data)
                selected[symbol] = dict(bytes=size, assembly=filename,
                    stack_subtractions=re.findall(r'sub\s+\$0x([0-9a-f]+),%rsp', data),
                    memcpy=[line.strip() for line in data.splitlines() if 'memcpy' in line])
        text = next(line for line in sections.splitlines() if re.search(r'\s\.text\s', line))
        assembly[label][scope] = dict(text_section=text.strip(), text_bytes=int(text.split()[2],16), symbols=selected)
comparison = dict(allocator_rows=rows, assembly=assembly, text_deltas={scope:assembly['partial'][scope]['text_bytes']-assembly['indexed'][scope]['text_bytes'] for scope in ['shaper','owner']}, scope='matched current root flags, compiler, fixture paths, locked versions and source closure; only four shipping text modules differ; no timing')
(out/'comparison.json').write_text(json.dumps(comparison, indent=2)+'\n')
for row in rows:
    print(row['case'], row['scope'], row['delta'])
print('matched.text deltas', comparison['text_deltas'])
