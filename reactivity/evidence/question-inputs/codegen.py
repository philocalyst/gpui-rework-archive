#!/usr/bin/env python3
"""Inspect linked ordinary-consumer monomorphs, not synthetic isolated helpers."""
from pathlib import Path
import json
import re
import subprocess
from capture import VARIANTS
HERE=Path(__file__).resolve().parent
BIN=Path('/nix/store/7j0657srv7dbdmmhj4iicf2mgis2cxp4-binutils-wrapper-2.46/bin')
report={}
for label,(_,_,binary) in VARIANTS.items():
    symbols=subprocess.check_output([str(BIN/'nm'),'-S','-C',str(binary)],text=True)
    selected=[]
    for line in symbols.splitlines():
        m=re.match(r'([0-9a-f]+) ([0-9a-f]+) [tT] (.*)',line)
        if not m: continue
        address,size,name=int(m[1],16),int(m[2],16),m[3]
        if 'question_input_cost' not in name: continue
        suffix=next((s for s in ('start_pending','apply_questions','refresh','set::<u64>','deliver_ready','borrow_registered','resolve::<()>','one_source_operation_cost::{closure#0} as core::ops::function::FnOnce<()>>::call_once') if name.endswith('::'+s)),None)
        if suffix: selected.append((address,size,name,suffix))
    bodies=[]
    for address,size,name,suffix in selected:
        bodies.append(subprocess.check_output([str(BIN/'objdump'),'-d','-C','--no-show-raw-insn',f'--start-address={address}',f'--stop-address={address+size}',str(binary)],text=True))
    (HERE/f'{label}-assembly.txt').write_text('\n'.join(bodies))
    sections=subprocess.check_output([str(BIN/'size'),'-A',str(binary)],text=True)
    text_bytes=int(re.search(r'^\.text\s+(\d+)',sections,re.M)[1])
    report[label]={'text_bytes':text_bytes,'symbols':[{'address':hex(a),'bytes':s,'name':n,'operation':op} for a,s,n,op in selected]}
(HERE/'codegen.json').write_text(json.dumps(report,indent=2)+'\n')
for label,values in report.items():
    print(label,values['text_bytes'],[(s['operation'],s['bytes']) for s in values['symbols']])
