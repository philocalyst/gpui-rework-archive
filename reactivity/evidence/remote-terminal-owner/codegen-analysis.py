from pathlib import Path
import struct, hashlib, subprocess, json
base=Path('/tmp/gpui-intent-transport-codegen')
binutils=Path('/nix/store/7j0657srv7dbdmmhj4iicf2mgis2cxp4-binutils-wrapper-2.46/bin')
names=['control-headless','candidate-headless','control-native','candidate-native']
def cstring(blob,start):return blob[start:blob.index(b'\0',start)].decode()
def inspect(path):
 blob=path.read_bytes();assert blob[:5]==b'\x7fELF\x02' and blob[5]==1
 offset=struct.unpack_from('<Q',blob,40)[0];size,count,strings=struct.unpack_from('<HHH',blob,58)
 sections=[struct.unpack_from('<IIQQQQIIQQ',blob,offset+i*size) for i in range(count)]
 strings=sections[strings];section_names=blob[strings[4]:strings[4]+strings[5]]
 headers=[{'index':i,'name':cstring(section_names,s[0]),'size':s[5],'offset':s[4],'flags':s[2]} for i,s in enumerate(sections)]
 functions=[]
 for section in sections:
  if section[1]!=2:continue
  strings=sections[section[6]];strings=blob[strings[4]:strings[4]+strings[5]]
  for offset in range(section[4],section[4]+section[5],section[9]):
   name,info,other,index,value,size=struct.unpack_from('<IBBHQQ',blob,offset)
   if info&15!=2 or index==0:continue
   h=headers[index];code=blob[h['offset']+value:h['offset']+value+size]
   functions.append({'symbol':cstring(strings,name),'section':h['name'],'size':size,'value':value,'sha256':hashlib.sha256(code).hexdigest()})
 demangled=subprocess.check_output([str(binutils/'c++filt')],input='\n'.join(f['symbol'] for f in functions)+'\n',text=True).splitlines()
 for f,d in zip(functions,demangled):f['demangled']=d
 groups={}
 for f in functions:groups.setdefault((f['section'],f['value']),[]).append(f['symbol'])
 aliases=[g for g in groups.values() if len(g)>1]
 text=[h for h in headers if h['flags']&4]
 return {'object_bytes':len(blob),'object_sha256':hashlib.sha256(blob).hexdigest(),'text_bytes':sum(h['size'] for h in text),'text_sections':text,'function_alias_groups':aliases,'functions':functions}
results={name:inspect(base/name/'remote_probe.o') for name in names}
for name,r in results.items():
 entries={f['symbol']:f for f in r['functions'] if f['symbol'] in ['remote_clone','remote_send','remote_drop','ordinary_delivery']}
 r['entry_points']=entries
 for symbol,e in entries.items():
  assembly=subprocess.check_output([str(binutils/'objdump'),'-dr','-j',e['section'],str(base/name/'remote_probe.o')],text=True)
  (base/name/(symbol+'.dis')).write_text(assembly)
  e['explicit_stack_subtractions']=[int(x.split(',')[0],16) for x in __import__('re').findall(r'sub\s+\$0x([a-f0-9]+),%rsp',assembly)]
  e['lock_instruction_count']=assembly.count('lock ')
 print(name,'text',r['text_bytes'],'object',r['object_bytes'],'entries',[(s,e['size']) for s,e in entries.items()],'aliases',r['function_alias_groups'])
(base/'analysis.json').write_text(json.dumps(results,indent=2)+'\n')
headless={s:{'same_size':results['control-headless']['entry_points'][s]['size']==results['candidate-headless']['entry_points'][s]['size'],'same_raw_text_bytes':results['control-headless']['entry_points'][s]['sha256']==results['candidate-headless']['entry_points'][s]['sha256']} for s in results['control-headless']['entry_points']}
(base/'headless-entry-comparison.json').write_text(json.dumps(headless,indent=2)+'\n')
print('headless entry comparison',headless)
