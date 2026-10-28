from pathlib import Path
import json,re,sys
p=Path('/tmp/gpui-delivery-integration-captures');label=sys.argv[1]
for fixture in ['ordinary_control','field_control']:
 stem=label+'-'+fixture;symbols={}
 if not (p/(stem+'.symbols')).exists():continue
 for line in (p/(stem+'.symbols')).read_text().splitlines():
  m=re.match(r'([0-9a-f]+) ([0-9a-f]+) ([tTwW]) (.+)',line)
  if m:symbols[m[4]]={'address':m[1],'bytes':int(m[2],16)}
 asm=(p/(stem+'.asm')).read_text();selected={}
 functions=list(re.finditer(r'^([0-9a-f]+) <(.+)>:\n',asm,re.M))
 for i,m in enumerate(functions):
  name=m[2]
  if not any(t in name for t in ['gpui::','ordinary_control::','field_control::','std::sync::mpmc','std::sync::mpsc']):continue
  body=asm[m.end():functions[i+1].start() if i+1<len(functions) else len(asm)]
  changes=[s.strip() for s in body.splitlines() if re.search(r'\b(push|pop|sub|add|and|lea)[a-z]*\b.*%rsp|\b(push|pop)[a-z]*\b',s)]
  calls=[s.strip() for s in body.splitlines() if re.search(r'\b(call|jmp)[a-z]*\b',s)]
  selected[name]={'symbol':symbols.get(name),'stack_instructions':changes,'calls':calls,'first_lines':body.splitlines()[:18]}
 sections={}
 for line in (p/(stem+'.sections')).read_text().splitlines():
  v=line.split()
  if len(v)==3 and v[0].startswith('.'):sections[v[0]]=int(v[1])
 (p/(stem+'-analysis.json')).write_text(json.dumps({'sections':sections,'functions':selected},indent=2)+'\n')
 print(stem,{k:sections.get(k) for k in ['.text','.rodata','.data.rel.ro']},'functions',len(selected))
