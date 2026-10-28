from pathlib import Path
import json
base=Path(__file__).parent/'matched-release-codegen-final'
ledger={}
for binary in ['canonical-text-public-control','canonical-text-native-control']:
    sides={}
    for side in ['baseline','candidate']:
        value=json.loads((base/(side+'-'+binary+'-elf.json')).read_text())
        groups={}
        for item in value['selected_frames']:
            bodies=groups.setdefault(item['normalized_name'],{})
            body=bodies.setdefault(str(item['address']),{'address':item['address'],'code_bytes':item['code_bytes'],
                                                       'frame_bytes':item['stack_bytes'],'mangled_aliases':[]})
            assert (body['code_bytes'],body['frame_bytes'])==(item['code_bytes'],item['stack_bytes'])
            if item['mangled'] not in body['mangled_aliases']:
                body['mangled_aliases'].append(item['mangled'])
        sides[side]={name:list(bodies.values()) for name,bodies in groups.items()}
    entries=[]
    for name in sorted(sides['baseline'].keys()|sides['candidate'].keys()):
        old=sides['baseline'].get(name,[]);new=sides['candidate'].get(name,[])
        entries.append({'normalized_name':name,'baseline_bodies':old,'candidate_bodies':new,
                        'pairing':'unique symbol on each side' if len(old)==len(new)==1 else 'all bodies retained; do not infer individual pairing',
                        'code_delta_within_this_name':sum(x['code_bytes'] for x in new)-sum(x['code_bytes'] for x in old)})
    ledger[binary]={'entries':entries,'limits':'All selected aliases and distinct physical bodies preserved. Normalized names can collide; no dict-overwrite comparison for those bodies. Do not sum frames or infer dynamic call depth. Physical alias dedup totals are in ELF summary, not sums of name groups.'}
(base/'all-bodies-ledger.json').write_text(json.dumps(ledger,indent=2)+'\n')
