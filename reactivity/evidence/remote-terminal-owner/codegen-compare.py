from pathlib import Path
import json,subprocess,re
base=Path('/tmp/gpui-intent-transport-codegen'); j=json.loads((base/'analysis.json').read_text()); tool='/nix/store/7j0657srv7dbdmmhj4iicf2mgis2cxp4-binutils-wrapper-2.46/bin/objdump'
for name in ['control-native','candidate-native']:
 assembly=subprocess.check_output([tool,'-d',str(base/name/'remote_probe.o')],text=True)
 (base/name/'all.dis').write_text(assembly)
 functions={}
 for block in re.split(r'\n(?=[0-9a-f]+ <)',assembly):
  match=re.match(r'[0-9a-f]+ <([^>]+)>:',block)
  if match:
   values=[int(x,16) for x in re.findall(r'sub\s+\$0x([a-f0-9]+),%rsp',block)]
   functions[match[1]]={'explicit_stack_subtractions':values,'push_count':len(re.findall(r'\bpush\s',block))}
 for function in j[name]['functions']:function.update(functions.get(function['symbol'],{}))
a={f['demangled']:f for f in j['control-native']['functions']};b={f['demangled']:f for f in j['candidate-native']['functions']}
changes=[]
for name in sorted(set(a)|set(b)):
 old=a.get(name);new=b.get(name)
 if old and new and old['sha256']==new['sha256']:continue
 changes.append({'name':name,'old':old,'new':new,'size_delta':(new['size'] if new else 0)-(old['size'] if old else 0)})
(base/'native-function-changes.json').write_text(json.dumps(changes,indent=2)+'\n')
print('changed/add/remove function names',len(changes))
for c in sorted(changes,key=lambda c:c['size_delta'],reverse=True)[:15]:print(c['size_delta'],c['name'][:180], 'frames', c['old'].get('explicit_stack_subtractions') if c['old'] else None,c['new'].get('explicit_stack_subtractions') if c['new'] else None)
