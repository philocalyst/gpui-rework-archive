from pathlib import Path
r=Path(__file__).parent
s=Path('/home/user/gpui-damage-suffix-native-evidence/native.py').read_text()
s=s.replace("   if mode=='idle':assert ticks==0\n",'')
s=s.replace("   first=sum(t<1 and gap>25 for t,gap in gaps)","   first=sum(t<1 and gap>25 for t,gap in gaps)\n   later=sum(t>=1 and gap>25 for t,gap in gaps)")
s=s.replace("'cadence_pass':58*seconds<=ticks<=61*seconds", "'cadence_pass':(ticks==0 if mode=='idle' else 58*seconds<=ticks<=61*seconds)")
s=s.replace("'gap_gate_pass':first<=2", "'gap_gate_pass':first<=2 and later==0,'later_gaps_over25ms':later")
s=s.replace("   if timed and name=='candidate' and mode!='idle':assert 58*seconds<=ticks<=61*seconds,('unequal/insufficient admitted work',ticks)\n",'')
s=s.replace("   if timed and name=='candidate':assert first<=2,('first-second ACK gap gate',first)\n",'')
s=s.replace("print(out.relative_to(R),'pass',flush=True)","print(out.relative_to(R),'recorded',flush=True)")
s=s[:s.index("if __name__=='__main__':")]+'''if __name__=='__main__':
 stage=sys.argv[1]
 if stage=='preflight':
  for n in NAMES:
   for initial in [0,190]:run(n,'idle',4,R/'preflight'/n/('capture-'+str(initial)),initial=initial,capture=True)
   for mode in ['stream','scroll','both']:run(n,mode,3,R/'preflight'/n/mode)
 elif stage=='timing':
  from guard import check
  check('guard-before-timing.json')
  orders=json.loads((R/'PROCESS_ORDER.json').read_text());assert len(orders)==32
  (R/'timing').mkdir(exist_ok=False)
  try:
   for group in orders:
    for n in group['order']:
     import shutil
     assert shutil.disk_usage('/home/user').free>8*1024**3
     assert not any(p.strip() in ['cargo','rustc','rust-lld','ld.lld','gcc','clang','cc1','clippy-driver'] for p in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines())
     try:run(n,group['mode'],8,R/'timing'/group['mode']/str(group['group'])/n,timed=True)
     except Exception as e:print('FAILED execution',group['mode'],group['group'],n,repr(e),flush=True)
  finally:check('guard-after-timing.json')
 else:raise ValueError(stage)
'''
(r/'native.py').write_text(s)
