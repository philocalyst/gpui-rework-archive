from pathlib import Path
r=Path(__file__).parent;s=Path('/home/user/gpui-native-workspace-evidence/native.py').read_text().replace("NAMES=['control','sparse','candidate','zgx']","NAMES=['baseline','candidate']")
s=s.replace('capture=False,timed=False):','capture=False,timed=False,route=\'exact\'):')
s=s.replace("env.pop('WAYLAND_DISPLAY',None)","env.pop('WAYLAND_DISPLAY',None)\n env['GPUI_LAB_TRACE']='1'\n if route=='owner':env['GPUI_LAB_INGRESS']='owner'")
s=s.replace("'name':name,'mode':mode,'ticks':ticks,","'name':name,'mode':mode,'route':route,'initial':initial,'ticks':ticks,")
s=s.replace("   (out/'summary.json').write_text", """   acks=[{'source_epoch':int(a),'presentation_epoch':int(b),'at_ns':int(c)} for a,b,c in re.findall(r'^GPUI_ACK,(\\d+),(\\d+),(\\d+)$',err,re.M)]
   assert len(acks)==native_acks and acks
   assert all(b['at_ns']>=a['at_ns'] for a,b in zip(acks,acks[1:]))
   gaps=[(b['at_ns']/1e9,(b['at_ns']-a['at_ns'])/1e6) for a,b in zip(acks,acks[1:])]
   first=sum(t<1 and gap>25 for t,gap in gaps)
   summary.update({'cadence_pass':58*seconds<=ticks<=61*seconds,'first_second_gaps_over25ms':first,'gap_gate_pass':first<=2,'total_gaps_over25ms':sum(gap>25 for _,gap in gaps)})
   (out/'acks.json').write_text(json.dumps(acks))
   (out/'summary.json').write_text""")
s=s.replace("if timed and mode!='idle':assert", "if timed and name=='candidate' and mode!='idle':assert")
s=s.replace("   if timed and mode=='idle' and name=='candidate':assert summary['cpu_cores']<=.01,('idle CPU gate',summary['cpu_cores'])", "   if timed and name=='candidate':assert first<=2,('first-second ACK gap gate',first)")
s=s[:s.index("if __name__=='__main__':")]+'''if __name__=='__main__':
 stage=sys.argv[1]
 if stage=='preflight':
  for n in NAMES:
   run(n,'idle',4,R/'preflight'/n/'capture',initial=190,capture=True)
   for route in ['exact','owner']:run(n,'stream',3,R/'preflight'/n/route,route=route)
 elif stage=='timing':
  from guard import check
  check('guard-before-timing.json')
  orders=json.loads((R/'PROCESS_ORDER.json').read_text());assert len(orders)==16;(R/'timing').mkdir(exist_ok=False)
  try:
   for group in orders:
    for n in group['order']:
     assert not any(p.strip() in ['cargo','rustc','rust-lld','ld.lld','gcc','clang','cc1','clippy-driver'] for p in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines())
     try:run(n,'stream',8,R/'timing'/group['route']/str(group['group'])/n,timed=True,route=group['route'])
     except Exception as e:print('FAILED observation',group['route'],group['group'],n,repr(e),flush=True)
  finally:check('guard-after-timing.json')
 else:raise ValueError(stage)
'''
(r/'native.py').write_text(s)
