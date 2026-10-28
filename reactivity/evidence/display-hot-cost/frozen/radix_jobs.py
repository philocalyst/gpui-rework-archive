"""Executable delta-to-pixels model. Oracle expansions never feed mutations.
Public fixture admission is restricted. Diagnostic capture costs are separate.
"""
from pathlib import Path
from collections import Counter
import json,struct,sys,copy,tracemalloc,random
from chunks import Chunks,verify
from experiment import pack,decode,ZERO,NIL,raster,Tree,damage_union
from radix import RadixPublication,lookup
class Uncompressed(Chunks):
    def raw_mode(self,rows):return True

def deep_size(*roots):
    seen=set()
    def visit(x):
        if id(x) in seen:return 0
        seen.add(id(x));size=sys.getsizeof(x)
        if isinstance(x,dict):return size+sum(visit(k)+visit(v) for k,v in x.items())
        if isinstance(x,(list,tuple,set)):return size+sum(map(visit,x))
        if hasattr(x,'__dict__'):return size+visit(x.__dict__)
        return size
    return sum(map(visit,roots))
def words(data):return list(struct.unpack('<'+'I'*(len(data)//4),data))
def canonical_slots(store):
    # Independent diagnostic walk, no retained expansion in the candidate.
    result=[ZERO]*(store.next_page*32)
    for page,p in store.pages.items():
        wire=words(p.data)
        for row in range(p.count):result[page*32+row]=tuple(decode(wire,row,c) for c in range(12))
    return pack([v for r in result for v in r])
def journal(store,changed):return {p:(data,store.pages[p].count) for p,data in changed.items()}
def admit(source):
    data=json.loads((source/'public.json').read_text());nodes=data['initial_snapshot']['nodes'];assert len(nodes)==len(data['initial_draws'])
    draws=[]
    for node,draw in zip(nodes,data['initial_draws'],strict=True):
        rect=tuple(map(int,draw['rect']));assert list(rect)==draw['rect'];x,y,w,h=node['bounds'];assert x<=rect[0] and y<=rect[1] and x+w>=rect[2] and y+h>=rect[3]
        assert node['transform'][:4]==[1.,0.,0.,1.]
        color=int.from_bytes(bytes(int(c*255) for c in draw['color']),'little')
        draws.append((node['identity'],1,nodes[node['parent']]['identity'] if node['parent'] is not None else None,rect,color,0))
    assert pack(raster(draws))==(source/'initial.rgba').read_bytes()
    return data,draws
class Series:
    def __init__(self,path,draws,mode,mutant=0):
        path.mkdir();self.path=path;self.mode=mode;self.mutant=mutant
        self.store=(Uncompressed if mode=='serial-uncompressed' else Chunks)(draws,small_raw=mode=='overlap-raw')
        self.pub=RadixPublication(resource_leases=mutant!=5);self.frames=[];self.records=[];self.live={};self.completions=[];self.deferred=None;self.resources={};self.audit_count=0
        self.store.acknowledge();self.memory=[];self.previous=Counter();self.pending_waits=[]
    def wait(self,order):
        for i in order:
            v=self.live.pop(i);self.pub.signal(v.sequence);ok=self.pub.present(v);self.completions.append(dict(fence=i,presented=ok));self.pending_waits.append(i)
            if ok:self.store.acknowledge()
    def before(self,i):
        if self.mode=='serial-uncompressed' or i==1 or (i>1 and (i-1)%3==0):self.wait(list(reversed(self.live)))
    def frame(self,i,change,pixels,resource_delta=None,initial=False,rejected=False):
        s=self.store;p=self.pub;resources={} if resource_delta is None else resource_delta
        self.resources.update(resources)
        raw=(self.mode in ['overlap-raw','serial-uncompressed']) and len(s.pages)==1
        slots=s.next_page*32 # maintained address high-water, no page-directory scan.
        v=p.prepare(journal(s,change['journal']),change['deleted'],resources,count=len(s.index),slots=slots,first=s.first*32,raw=raw)
        assert p.submit(v);self.live[i]=v
        if self.mutant==6 and i>0 and (i-1)%3==0:p.heap.release(v.root) # omitted GPU fence ownership; later reuse is intentional mutant.
        if rejected:assert p.failed_request()==v and not p.present(v)
        damage=(0,0,64,64) if initial else change['damage']
        if self.mutant==4 and i==1:damage=(40,40,48,48) # omit old support in the explicit translation fixture.
        writes=[]
        for offset,data in p.heap.drain_writes():
            padded=data+bytes((-len(data))%4);writes.append(dict(offset=offset,words=words(padded),payload_bytes=len(data)))
        candidate_mem=tracemalloc.get_traced_memory() if tracemalloc.is_tracing() else (0,0)
        if tracemalloc.is_tracing():tracemalloc.stop()
        # Every operation above is candidate work. Below are independent audit,
        # evidence and storage walks; they do not discover any update destination.
        arg=[v.root[0],*damage,self.mutant if self.mutant in [1,2,3] else 0,len(self.resources)]
        audit=canonical_slots(s)
        for key,data in sorted(self.resources.items()):arg.extend([key,len(data)]);audit+=pack(data)
        audit_name=f'expected-{i}.bin';(self.path/audit_name).write_bytes(audit)
        pixel_name=f'pixels-{i}.rgba';(self.path/pixel_name).write_bytes(pixels)
        deferred=self.mode!='serial-uncompressed' and i>0 and (i-1)%3==0
        if deferred:self.deferred=i
        submit=[]
        if self.deferred is not None and i>0 and (i-1)%3==2:
            submit=[self.deferred]
            # The deferred old renderer must leave the newest pixels untouched.
            (self.path/f'pixels-{self.deferred}.rgba').write_bytes(pixels)
            self.deferred=None
        self.frames.append(dict(id=i,wait_before=self.pending_waits,writes=writes,root=v.root[0],authority=[v.sequence,v.namespace],args=arg,expected=audit_name,pixels=pixel_name,defer=deferred,submit_deferred=submit))
        self.pending_waits=[]
        publication=p.record();hc=Counter(p.heap.c);delta=dict(hc-self.previous);self.previous=hc
        self.records.append(dict(frame=i,change=change['counts'],damage=list(damage),publication=publication,heap_work=delta,store=s.ledger(),candidate_python_trace_current=candidate_mem[0],candidate_python_trace_peak=candidate_mem[1],candidate_python_reachable_bytes=deep_size(s,p),cpu_update_mirror_bytes=0,upload_requested=sum(w['payload_bytes'] for w in writes),upload_padded=sum(len(w['words'])*4 for w in writes),production_parameters_bytes=24,authority_upload_bytes=8,diagnostic_audit_parameters_bytes=len(arg)*4-24,diagnostic_audit_output_bytes=len(audit),pending_frames=len(self.live),resource_audit_entries=len(self.resources),gpu_pixel_record_visits=(damage[2]-damage[0])*(damage[3]-damage[1])*len(s.index),rejected_new_request_preserves_eligible=rejected))
    def finish(self):
        assert self.deferred is None
        end=list(reversed(self.live));self.wait(end);high=self.pub.heap.end
        if self.mutant!=6:self.pub.close()
        script=dict(arena_bytes=high,frames=self.frames,end_waits=end)
        (self.path/'jobs.json').write_text(json.dumps(script,separators=(',',':')))
        (self.path/'ledger.json').write_text(json.dumps(dict(mode=self.mode,mutant=self.mutant,frames=self.records,completion=self.completions,all_released=not self.pub.heap.live,scope='restricted registered fixture binding, staged writes, opaque integer renderer; no generic runtime journal, coherent host memory, timing or ZGX inference'),indent=2))
        return dict(name=self.path.name,frames=len(self.frames),arena_bytes=high,mutant=self.mutant)

def point(source,out,n,mode,mutant=0):
    public,draws=admit(source/str(n));series=Series(out/f'point-{n}-{mode}-m{mutant}',draws,mode,mutant);s=series.store
    for i,event in enumerate([None]+public['events']):
        series.before(i)
        pixels=(source/str(n)/('initial.rgba' if event is None else event['pixels'])).read_bytes();tracemalloc.start()
        if event is None:change=dict(journal={p:r.data for p,r in s.pages.items()},deleted=(),counts=dict(initial_admission_nodes=n),damage=(0,0,64,64))
        else:
            assert event['candidate_snapshot_reads']==event['candidate_draw_enumerations']==0
            s.set(public['target']['identity'],{9:event['color']},generation=1);change=s.commit()
            assert change['counts']['identity_lookups']==1 and change['counts']['dirty_pages']==1
        series.frame(i,change,pixels,initial=i==0,rejected=event is not None and event['rejected_invalid_request'])
    return series.finish()

def resource(source,glyphs,out,mode,mutant=0):
    cases=json.loads((source/'images/images.json').read_text());draws=[]
    for i,d in enumerate(cases[0]['draws']):
        rect=tuple(map(int,d['rect']));color=int.from_bytes(bytes(round(c*255) for c in d['color']),'little');draws.append((i+1,1,None if i==0 else 1,rect,color,3 if d['image'] else 0))
    series=Series(out/f'resource-{mode}-m{mutant}',draws,mode,mutant);s=series.store
    image_id=next(i+1 for i,d in enumerate(cases[0]['draws']) if d['image']);s.set(image_id,{10:3});s.commit();s.acknowledge()
    glyph_cases=json.loads((glyphs/'assets.json').read_text())['cases']
    for i in range(13):
        series.before(i);case=cases[i%4];glyph_case=glyph_cases[i%3];mask=next(r for r in glyph_case['resources'] if r['kind']=='text-mask');glyph=(glyphs/mask['file']).read_bytes()
        pixels=(source/'images'/case['pixels']).read_bytes()
        bitmap=(source/'images'/case['resource']).read_bytes();assert all(b in (0,255) for b in bitmap) and all(b==255 for b in bitmap[3::4]);delta={3:pack([8,8])+bitmap,7:glyph};tracemalloc.start()
        if i==0:change=dict(journal={p:r.data for p,r in s.pages.items()},deleted=(),counts=dict(initial_admission_nodes=len(draws)),damage=(0,0,64,64))
        else:
            # Registered resource->support binding; neither resource nor node
            # table is scanned. General atlas/glyph dependency integration absent.
            row=s.read(image_id);s.damage(row,row);change=s.commit()
        series.frame(i,change,pixels,delta,initial=i==0)
    return series.finish()

def geometry(out,mutant=0):
    draws=[(1,1,None,(0,0,64,64),0xffffffff,0),(2,1,1,(8,8,16,16),0xff000000,0)]
    series=Series(out/f'geometry-m{mutant}',draws,'serial-uncompressed',mutant);s=series.store
    for i,rect in enumerate([(8,8,16,16),(40,40,48,48),(0,0,8,8)]):
        series.before(i);tracemalloc.start()
        if i==0:change=dict(journal={p:r.data for p,r in s.pages.items()},deleted=(),counts={},damage=(0,0,64,64))
        else:s.set(2,dict(zip(range(5,9),rect)));change=s.commit()
        expected=[draws[0],(2,1,1,rect,0xff000000,0)];series.frame(i,change,pack(raster(expected)),initial=i==0)
    return series.finish()

def structural(out):
    tree=Tree(1,False);group=tree.add(1,w=64,h=64,color=0,clip=True)
    for i in range(96):tree.add(group,x=i%16*4,y=i//16*4,color=0xff000000,w=3,h=3)
    tree.add(1,x=40,y=40,w=12,h=12,color=0xffff0000);tree.recompute(1)
    series=Series(out/'structural-97',tree.draws(),'serial-uncompressed');s=series.store
    for i in range(4):
        series.before(i);tracemalloc.start()
        if i==0:change=dict(journal={p:r.data for p,r in s.pages.items()},deleted=(),counts={},damage=(0,0,64,64))
        elif i==1:
            s.move(group,None,1);change=s.commit();tree.nodes[1].children.remove(group);tree.nodes[1].children.append(group);tree.recompute(1)
            assert change['counts']['extent_records']==194
        elif i==2:
            s.remove(group);change=s.commit()
            for node in tree.subtree(group):del tree.nodes[node];del tree.cache[node]
            tree.nodes[1].children.remove(group);tree.recompute(1)
        else:
            new=tree.add(1,at=0,x=2,y=2,w=8,h=8,color=0xff0000ff);tree.recompute(1)
            s.insert(tree.nodes[1].children[1],new,1,tree.cache[new][3],0xff0000ff);change=s.commit()
        if tracemalloc.is_tracing():tracemalloc.stop()
        verify(s,tree.draws());series.frame(i,change,pack(raster(tree.draws())),initial=i==0)
    return series.finish()

def main(source,glyphs,out):
    out.mkdir();reports=[]
    for n in [1,9,32,256,1024]:
        for mode in ['overlap-compressed','overlap-raw','serial-uncompressed']:reports.append(point(source,out,n,mode))
    for mode in ['overlap-compressed','overlap-raw','serial-uncompressed']:reports.append(resource(source,glyphs,out,mode))
    reports.append(geometry(out));reports.append(structural(out))
    for mutant in [1,2,3]:reports.append(point(source,out,256,'overlap-compressed',mutant))
    reports.append(geometry(out,4));reports.append(resource(source,glyphs,out,'overlap-compressed',5))
    # Premature submitted-root release may fail in CPU graph operations before
    # GPU execution; capture that independent lease oracle explicitly.
    try:point(source,out,9,'overlap-compressed',6)
    except (KeyError,AssertionError) as e:(out/'premature-reuse.json').write_text(json.dumps(dict(rejected=True,error=repr(e))))
    else:raise AssertionError('premature reuse mutant survived')
    (out/'summary.json').write_text(json.dumps(reports,indent=2));print(json.dumps(reports))
if __name__=='__main__':main(*map(Path,sys.argv[1:]))
