from pathlib import Path
r=Path(__file__).parent
old=Path('/home/user/gpui-patch-workspace-evidence')
s=(old/'matrix_runs.py').read_text()
a=s.index('def guard():');b=s.index('assert not guard();',a)
s=s[:a]+'from guard import guard, frozen\nfrozen()\n'+s[b:]
a=s.index(' sequences=[]');b=s.index(' random.Random',a)
s=s[:a]+''' groups=[]
 for c in cases:
  count=definition['pairs_by_case'][c]
  assert count%2==0
  for pair in range(count):
   order=variants if pair%2==0 else variants[::-1]
   groups.append([dict(case=c,pair=pair,variant=v,frames=definition['frames']) for v in order])
'''+s[b:]
s=s.replace("[('qualification',420),('allocations',140)]","[('qualification',168),('allocations',56)]").replace("['scroll_precise','candidate']","['baseline','candidate']")
s=s.replace("changes=guard();", "frozen(); changes=guard();")
(r/'matrix_runs.py').write_text(s)
(r/'analyze_matrix.py').write_text((old/'analyze_matrix.py').read_text().replace('seed20261106','seed20261110'))
for name in ['headers.py','driver_probe.py']:(r/name).write_bytes((old/name).read_bytes())
