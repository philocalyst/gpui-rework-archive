"""B GPU jobs: original record encoding, index graph plus explicit visit audit."""
from pathlib import Path
import json,sys,tracemalloc
from radix_jobs import Series,admit
from radix import RadixPublication
from spatial import Spatial
from experiment import pack,raster,Tree
from chunks import verify
COUNT=0x80000000
class Indexed(RadixPublication):
    def __init__(self,lease=True):super().__init__();self.spatial=Spatial(self.heap);self.spatial_lease=lease;self.override=None
    def prepare(self,*args,**kwargs):
        return super().prepare(*args,**kwargs,spatial_root=self.spatial.root if self.override is None else self.override,spatial_lease=self.spatial_lease)
    def record(self):
        r=super().record();r['spatial_work']=self.spatial.counts();r['spatial']=self.spatial.ledger();return r
    def close(self):self.spatial.close();super().close()
class IndexedSeries(Series):
    def __init__(self,path,draws,mode,mutant=0,enabled=True):
        super().__init__(path,draws,mode);self.pub=Indexed(mutant!=14);self.index_mutant=mutant;self.enabled=enabled
        if enabled and len(draws)>32:self.pub.spatial.rebuild(self.store)
    def update_geometry(self,change,structural=False):
        index=self.pub.spatial
        if not self.enabled or len(self.store.index)<=32:index.close()
        elif structural or index.root is None:index.rebuild(self.store)
        else:index.bounds(self.store,change['journal'])
    def frame(self,*args,**kwargs):
        super().frame(*args,**kwargs);frame=self.frames[-1];index=self.pub.spatial;s=self.store
        frame['args'][5]=COUNT+(self.index_mutant if self.index_mutant in [10,11] else 0)
        capacity=s.next_page if index.root else 0;frame['args'].append(capacity)
        if capacity:
            audit=[]
            for entries in index.lists:audit += [len(entries)]+entries+[0]*(capacity-len(entries))
            path=self.path/frame['expected'];path.write_bytes(path.read_bytes()+pack(audit))
        l,t,r,b=frame['args'][1:5];visits=0
        if index.root:
            for tile,entries in enumerate(index.lists):
                x=tile%8*8;y=tile//8*8;area=max(0,min(r,x+8)-max(l,x))*max(0,min(b,y+8)-max(t,y))
                visits+=area*sum(s.pages[p].count for p in entries)
        else:visits=(r-l)*(b-t)*len(s.index)
        frame['expected_visits']=0 if frame['defer'] else visits
        if self.index_mutant==13 and frame['id']==2:frame['args'][1:5]=[32,0,64,16]
        self.records[-1]['expected_gpu_record_visits']=frame['expected_visits'];self.records[-1]['spatial_audit_words']=64*(capacity+1) if capacity else 0
    def finish(self):
        r=super().finish();r['mutant']=self.index_mutant;return r

def point(source,out,scene,n,mode,mutant=0,enabled=True):
    public,draws=admit(source/scene/str(n));series=IndexedSeries(out/(f'{scene}-{n}-{mode}-m{mutant}'+('' if enabled else '-full-control')),draws,mode,mutant,enabled);s=series.store
    for i,event in enumerate([None]+public['events']):
        series.before(i);pixels=(source/scene/str(n)/('initial.rgba' if event is None else event['pixels'])).read_bytes();tracemalloc.start()
        if event is None:change=dict(journal={p:r.data for p,r in s.pages.items()},deleted=(),counts=dict(initial_admission_nodes=n),damage=(0,0,64,64))
        else:s.set(public['target']['identity'],{9:event['color']},generation=1);change=s.commit()
        series.frame(i,change,pixels,initial=i==0,rejected=event is not None and event['rejected_invalid_request'])
        if i:assert series.records[-1]['publication']['spatial_work']=={}
    return series.finish()
def geometry(source,out,mutant=0):
    public,draws=admit(source/'geometry');series=IndexedSeries(out/f'geometry-m{mutant}',draws,'overlap-compressed',mutant);s=series.store;old_index=None
    for i,event in enumerate([None]+public['events']):
        series.before(i);pixels=(source/'geometry'/('initial.rgba' if event is None else event['pixels'])).read_bytes();tracemalloc.start()
        if event is None:change=dict(journal={p:r.data for p,r in s.pages.items()},deleted=(),counts=dict(initial_admission_nodes=len(draws)),damage=(0,0,64,64))
        else:
            fields={int(k):v for k,v in event['fields'].items()};s.set(public['target']['identity'],fields,generation=1);change=s.commit()
            if any(k in fields for k in range(5,9)):
                old_index=series.pub.spatial.root;series.update_geometry(change)
                if mutant==12 and i==2:series.pub.override=old_index
        series.frame(i,change,pixels,initial=i==0,rejected=event is not None and event['rejected_invalid_request']);series.pub.override=None
    return series.finish()
def structural(out):
    tree=Tree(1,False);group=tree.add(1,w=64,h=64,color=0,clip=True)
    for i in range(96):tree.add(group,x=i%16*4,y=i//16*4,color=0xff000000,w=3,h=3)
    tree.add(1,x=40,y=40,w=12,h=12,color=0xffff0000);tree.recompute(1)
    series=IndexedSeries(out/'structural-97',tree.draws(),'serial-uncompressed');s=series.store
    for i in range(4):
        series.before(i)
        if i==0:change=dict(journal={p:r.data for p,r in s.pages.items()},deleted=(),counts={},damage=(0,0,64,64))
        elif i==1:s.move(group,None,1);change=s.commit();tree.nodes[1].children.remove(group);tree.nodes[1].children.append(group);tree.recompute(1)
        elif i==2:
            s.remove(group);change=s.commit()
            for node in tree.subtree(group):del tree.nodes[node];del tree.cache[node]
            tree.nodes[1].children.remove(group);tree.recompute(1)
        else:
            before=tree.nodes[1].children[0];new=tree.add(1,at=0,x=2,y=2,w=8,h=8,color=0xff0000ff);tree.recompute(1);s.insert(before,new,1,tree.cache[new][3],0xff0000ff);change=s.commit()
        verify(s,tree.draws())
        if i:series.update_geometry(change,True)
        series.frame(i,change,pack(raster(tree.draws())),initial=i==0)
    return series.finish()
def main(source,out):
    out.mkdir();reports=[]
    for scene in ['sparse','overlap','staircase']:
        for n in [1,9,32,256,1024]:
            reports.append(point(source,out,scene,n,'overlap-raw' if n<=9 else 'overlap-compressed'))
    for n in [1,9,32,256,1024]:reports.append(point(source,out,'sparse',n,'serial-uncompressed',enabled=False))
    reports.append(point(source,out,'staircase',1024,'serial-uncompressed',enabled=False))
    reports.append(geometry(source,out));reports.append(structural(out))
    for mutant in [10,11]:reports.append(point(source,out,'staircase',1024,'overlap-compressed',mutant))
    for mutant in [12,13,14]:reports.append(geometry(source,out,mutant))
    (out/'summary.json').write_text(json.dumps(reports,indent=2));print(json.dumps(reports))
if __name__=='__main__':main(*map(Path,sys.argv[1:]))
