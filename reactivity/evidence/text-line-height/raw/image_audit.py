from pathlib import Path
import subprocess,json
root=Path(__file__).resolve().parent;rows={}
for name,path in [('reference',root/'reference-snapshot-mapped/reference.png'),('candidate',root/'candidate-snapshot-mapped/candidate.png')]:
 raw=subprocess.check_output(['convert',str(path),'-depth','8','rgb:-']);assert len(raw)==960*720*3
 regions={}
 for region,(x0,y0,x1,y1,bg) in {'stream':(28,118,932,262,(25,34,48)),'title':(20,20,940,48,(16,20,28))}.items():
  spans=[];active=[]
  for y in range(y0,y1):
   count=sum(any(raw[(y*960+x)*3+c]>bg[c]+4 for c in range(3)) for x in range(x0,x1))
   if count>=5:active.append(y)
  for y in active:
   if spans and spans[-1][1]==y:spans[-1][1]=y+1
   else:spans.append([y,y+1])
  regions[region]={'ink_row_spans_threshold_background_plus4':spans,'span_start_deltas':[b[0]-a[0] for a,b in zip(spans,spans[1:])]}
 rows[name]=regions
assert len(rows['reference']['stream']['ink_row_spans_threshold_background_plus4'])==7
assert len(rows['candidate']['stream']['ink_row_spans_threshold_background_plus4'])==7
assert rows['reference']['stream']['span_start_deltas']==[20]*6
assert rows['candidate']['stream']['span_start_deltas']==[20]*6
(root/'image-audit.json').write_text(json.dumps({'method':'diagnostic ink rows above background+4 in at least5 pixels; not cross-framework pixel/quality equivalence','rows':rows},indent=2));print(json.dumps(rows,indent=2))
