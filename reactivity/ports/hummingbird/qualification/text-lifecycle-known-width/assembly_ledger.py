import json
import pathlib
import re

out = pathlib.Path(__file__).parent
result = {'scope': 'Actual objdump functions and emitted direct/indirect call sites; static call sites are not execution counts. Inlined const planners are represented by Planner::shape (materialized) and Planner::measure (metrics), plus all emitted named closure aliases. Unwind CFA observations are separate, not total stack bounds.', 'artifacts': {}}
for directory in ['static-constructor-baseline-v3', 'static-constructor-candidate-v3', 'static-native-baseline', 'static-native-candidate']:
    for file in (out / directory).glob('*.selected.asm'):
        functions = []
        current = None
        for line in file.read_text().splitlines():
            header = re.match(r'^([0-9a-f]+) <(.+)>:$', line)
            if header:
                current = {'name': header[2], 'offset': int(header[1], 16), 'instruction_count': 0, 'call_sites': [], 'branch_sites': [], 'relocations': []}
                functions.append(current)
            elif current is not None:
                instruction = re.match(r'^\s*([0-9a-f]+):\s+([a-z][a-z0-9]*)\s*(.*)$', line)
                if instruction:
                    current['instruction_count'] += 1
                    offset, opcode, operand = int(instruction[1], 16), instruction[2], instruction[3]
                    if opcode.startswith('call'):
                        current['call_sites'].append({'offset': offset, 'opcode': opcode, 'operand': operand, 'indirect': operand.startswith('*')})
                    elif opcode.startswith('j'):
                        current['branch_sites'].append({'offset': offset, 'opcode': opcode, 'operand': operand})
                elif 'R_X86_64_' in line:
                    current['relocations'].append(line.strip())
        result['artifacts'][str(file.relative_to(out))] = functions
frames = {}
for directory in ['static-native-baseline', 'static-native-candidate']:
    frames[directory] = json.loads((out / directory / 'native_service.frames.json').read_text())
result['linked_native_frame_observations'] = frames
control_bills = {}
for fixture in ['mixed-caller-v2', 'public-geometry-cost-v2']:
    rows = {}
    for variant in ['baseline', 'candidate']:
        bill = json.loads((out / f'static-{fixture}-{variant}' / 'bill.json').read_text())[fixture]
        rows[variant] = {key: bill[key] for key in ['file_bytes', 'allocated_section_bytes', 'categories']}
    rows['delta'] = {key: rows['candidate'][key]-rows['baseline'][key] for key in ['file_bytes', 'allocated_section_bytes']}
    rows['category_delta'] = {key: rows['candidate']['categories'][key]-rows['baseline']['categories'][key] for key in rows['baseline']['categories']}
    control_bills[fixture] = rows
result['standalone_linked_controls'] = control_bills
(out / 'assembly-ledger.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps(control_bills, indent=2))
