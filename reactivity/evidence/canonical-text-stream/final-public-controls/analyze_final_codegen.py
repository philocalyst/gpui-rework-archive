from pathlib import Path
import json, subprocess

out = Path(__file__).parent / 'matched-release-codegen-final'
binutils = '/nix/store/7j0657srv7dbdmmhj4iicf2mgis2cxp4-binutils-wrapper-2.46/bin/'
source = Path('/tmp/gpui-inspector-pointer-codegen/elf.py').read_text()
source = source.replace("['c++filt',", "[" + repr(binutils + 'c++filt') + ",")
start = source.index('    selected=')
end = source.index('\n    return ', start)
source = source[:start] + '''    selected=[f for f in frames if
        f['normalized_name'].startswith(('canonical_text_public_control::', 'canonical_text_native_control::'))
        or 'gpui_canvas::text::layout::' in f['normalized_name']
        or 'gpui::native::accessibility::text::' in f['normalized_name']
        or ('gpui::runtime' in f['normalized_name'] and any(name in f['normalized_name'] for name in
            ('::shape_for', '::interaction_layout', '::pointer_event', '::replace_input',
             '::present_inner', '::acknowledge', '::key', '::visit', '::TextSite::')))
        or ('gpui::native::accessibility::' in f['normalized_name'] and any(name in f['normalized_name'] for name in
            ('::project', '::sync', '::refresh')))]''' + source[end:]
scope = {'__name__': 'frozen_codegen_reader'}
exec(compile(source, 'elf_reader.py', 'exec'), scope)
(out / 'elf_reader.py').write_text(source)
summary = {}
for label in ['baseline', 'candidate']:
    summary[label] = {}
    for name in ['canonical-text-public-control', 'canonical-text-native-control']:
        path = out / (label + '-codegen-' + name)
        result = scope['inspect'](path)
        unique = {frame['address']: frame['code_bytes'] for frame in result['selected_frames']}
        result['selected_unique_code_bytes'] = sum(unique.values())
        result['selected_unique_bodies'] = len(unique)
        summary[label][name] = result
        (out / (label + '-' + name + '-elf.json')).write_text(json.dumps(result, indent=2) + '\n')
        with (out / (label + '-' + name + '-selected.asm')).open('w') as assembly:
            seen = set()
            for frame in result['selected_frames']:
                if frame['address'] in seen:
                    continue
                seen.add(frame['address'])
                assembly.write('\n' + frame['normalized_name'] +
                               f" bytes={frame['code_bytes']} frame={frame['stack_bytes']}\n")
                assembly.flush()
                subprocess.run([binutils + 'objdump', '-d', '--no-show-raw-insn',
                    '--start-address=' + str(frame['address']),
                    '--stop-address=' + str(frame['address'] + frame['code_bytes']), str(path)],
                    stdout=assembly, check=True)
        print(label, name, result['sections'], 'selected unique', sum(unique.values()), flush=True)
for name in ['canonical-text-public-control', 'canonical-text-native-control']:
    before = {item['normalized_name']: item for item in summary['baseline'][name]['selected_frames']}
    after = {item['normalized_name']: item for item in summary['candidate'][name]['selected_frames']}
    changes = []
    for symbol in sorted(before.keys() | after.keys()):
        old, new = before.get(symbol), after.get(symbol)
        if old is None or new is None or (old['code_bytes'], old['stack_bytes']) != (new['code_bytes'], new['stack_bytes']):
            changes.append({'name': symbol,
                'baseline': None if old is None else {'code_bytes': old['code_bytes'], 'frame_bytes': old['stack_bytes']},
                'candidate': None if new is None else {'code_bytes': new['code_bytes'], 'frame_bytes': new['stack_bytes']}})
    (out / (name + '-frame-delta.json')).write_text(json.dumps(changes, indent=2) + '\n')
(out / 'codegen-summary.json').write_text(json.dumps(summary, indent=2) + '\n')
