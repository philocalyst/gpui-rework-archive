from pathlib import Path
import hashlib
import json
import struct
import subprocess

objdump = '/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin/objdump'
out = Path('/tmp/gpui-sibling-controls')
for label in ['baseline-release', 'candidate']:
    path = out / label
    data = path.read_bytes()
    assert data[:6] == b'\x7fELF\x02\x01'
    header = struct.unpack_from('<16sHHIQQQIHHHHHH', data)
    sections = [struct.unpack_from('<IIQQQQIIQQ', data, header[6] + index * header[11]) for index in range(header[12])]
    content = lambda section: data[section[4]:section[4] + section[5]]
    strings = content(sections[header[13]])
    string = lambda table, start: table[start:table.index(0, start)].decode()
    byname = {string(strings, section[0]): section for section in sections}
    symtab = byname['.symtab']
    names = content(sections[symtab[6]])
    selected = []
    for offset in range(symtab[4], symtab[4] + symtab[5], symtab[9]):
        name, info, other, index, value, size = struct.unpack_from('<IBBHQQ', data, offset)
        name = string(names, name)
        if info & 15 == 2 and index and value and ('describe_inner' in name or 'Siblings' in name):
            selected.append({'mangled': name, 'address': value, 'code_bytes': size})
            asm = subprocess.check_output([objdump, '-d', '--disassemble=' + name, str(path)])
            (out / (label + '-' + str(value) + '.asm')).write_bytes(asm)
    result = {'binary': str(path), 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest(),
              'sections': {name: section[5] for name, section in byname.items() if name in ['.text', '.rodata', '.data.rel.ro', '.eh_frame']},
              'selected': selected, 'limit': 'Actual linked ELF sizes; disassembly retained. No stack-size metadata or dynamic stack claim.'}
    (out / (label + '.elf.json')).write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result))
