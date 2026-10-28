"""B CPU model: immutable index graph, full-render oracle, charged maintenance."""
from pathlib import Path
import json,struct,sys,copy
from chunks import Chunks,verify
from radix import RadixPublication,lookup
from spatial import Spatial,entries
from experiment import decode,pack,raster,Tree

def rows(heap,descriptor,page):
    if descriptor[5]:
        if page!=descriptor[4]//32:return []
        offset,count=descriptor[0],descriptor[9]
    else:offset,count=lookup(heap,(descriptor[0],heap.live[descriptor[0]].generation),page)
    if not offset:return []
    data=heap.live[offset].data;wire=struct.unpack('<'+'I'*(len(data)//4),data)
    return [[decode(wire,i,c) for c in range(12)] for i in range(count)]
def render(pub,version,old,damage,index_override=None,reverse=False,drop=None):
    h=pub.heap;desc=struct.unpack('<16I',h.get(version.root).data);image=old.copy();visits=0;l,t,r,b=damage;pointer=desc[13] if index_override is None else index_override
    for y in range(t,b):image[y*64+l:y*64+r]=[desc[8]]*(r-l)
    def paint(row,clip):
        if row[10]==0 or row[9]>>24!=255:return
        x0,y0,x1,y1=clip;x0=max(x0,row[5]);y0=max(y0,row[6]);x1=min(x1,row[7]);y1=min(y1,row[8])
        if x0<x1 and y0<y1:
            for y in range(y0,y1):image[y*64+x0:y*64+x1]=[row[9]]*(x1-x0)
    if pointer:
        root=(pointer,h.live[pointer].generation)
        for tile in range(64):
            tx=tile%8*8;ty=tile//8*8;clip=(max(l,tx),max(t,ty),min(r,tx+8),min(b,ty+8));x0,y0,x1,y1=clip
            if x0>=x1 or y0>=y1:continue
            pages=entries(h,root,tile)
            if reverse:pages.reverse()
            for page in pages:
                if page==drop:continue
                values=rows(h,desc,page);visits+=(x1-x0)*(y1-y0)*len(values)
                for row in values:paint(row,clip)
    else:
        slot=desc[4]
        for _ in range(desc[2]):
            row=rows(h,desc,slot//32)[slot%32];paint(row,damage);slot=row[3]
        visits=(r-l)*(b-t)*desc[2]
    return image,visits
class Model:
    def __init__(self,draws):
        self.store=Chunks(draws,small_raw=len(draws)<=9);self.pub=RadixPublication();self.index=Spatial(self.pub.heap);self.store.acknowledge()
        if len(draws)>32:self.index.rebuild(self.store)
    def prepare(self,change):
        s=self.store;return self.pub.prepare({p:(data,s.pages[p].count) for p,data in change['journal'].items()},change['deleted'],count=len(s.index),slots=s.next_page*32,first=s.first*32,raw=s.small_raw and len(s.pages)==1,spatial_root=self.index.root)
    def initial(self):return self.prepare(dict(journal={p:r.data for p,r in self.store.pages.items()},deleted=()))
    def finish(self,v):self.pub.signal(v.sequence);assert self.pub.present(v);self.store.acknowledge()
    def close(self):self.index.close();self.pub.close()

def fixture(n,scene):
    if scene=='staircase':
        draws=[(1,1,None,(0,0,64,64),0xff000000,0)]
        for j in range(n-1):draws.append((j+2,1,1,(j%64,j//64,64,j//64+1),0xff000000 if j%2==0 else 0xffffffff,0))
        # Every sibling retains visible pixels; this is not merely possible
        # overlap below an opaque edited target drawn last.
        owner=[1]*4096
        for identity,_,_,(l,t,r,b),_,_ in draws[1:]:
            for y in range(t,b):owner[y*64+l:y*64+r]=[identity]*(r-l)
        assert set(owner)=={d[0] for d in draws}
        return draws,1
    if n==1:return [(1,1,None,(0,0,32,16),0xff000000,0)],1
    draws=[(1,1,None,(0,0,64,64),0xffffffff,0)]
    for j in range(n-2):
        x=40 if scene=='sparse' else 8 if j%2==0 else 48;y=40 if scene=='sparse' else 8
        draws.append((j+2,1,1,(x,y,min(64,x+32),y+16),0xff000000 if j%2==0 else 0xffffffff,0))
    draws.append((n,1,1,(0,0,32,16),0xff000000,0));return draws,n

def main(out):
    out.mkdir();reports=[];tests=0;sparse_visits={};mutants={}
    for scene in ['sparse','overlap','staircase']:
        for n in [1,9,32,256,1024]:
            draws,target=fixture(n,scene);m=Model(draws);v=m.initial();m.pub.heap.drain_writes();assert m.pub.submit(v)
            image,visits=render(m.pub,v,[0]*4096,(0,0,64,64));assert image==raster(draws);m.finish(v);tests+=1
            reports.append(dict(scene=scene,n=n,operation='initial',visits=visits,index_work=m.index.counts(),index=m.index.ledger(),publication=m.pub.record()))
            for i,color in enumerate([0xffffffff,0xff0000ff,0xffff0000,0xff000000]):
                m.store.set(target,{9:color});change=m.store.commit();before=m.index.root;v=m.prepare(change);m.pub.heap.drain_writes();m.pub.submit(v)
                draws=[(identity,g,parent,rect,color if identity==target else paint,res) for identity,g,parent,rect,paint,res in draws]
                actual,visits=render(m.pub,v,image,change['damage']);assert actual==raster(draws);image=actual;assert m.index.root==before;assert m.index.counts()=={};tests+=1
                if scene=='sparse':sparse_visits[n]=visits
                if i==0:reports.append(dict(scene=scene,n=n,operation='paint',visits=visits,full_scan_visits=(change['damage'][2]-change['damage'][0])*(change['damage'][3]-change['damage'][1])*n,source_work=change['counts'],index_work={},index=m.index.ledger(),publication=m.pub.record()))
                m.finish(v)
            if scene=='staircase' and n==1024:
                wrong,_=render(m.pub,v,[0]*4096,(0,0,64,64),reverse=True);assert wrong!=image;mutants['reverse_painter_pages']=sum(a!=b for a,b in zip(wrong,image))
                wrong,_=render(m.pub,v,[0]*4096,(0,0,64,64),drop=m.index.order[1]);assert wrong!=image;mutants['omit_visible_siblings']=sum(a!=b for a,b in zip(wrong,image))
            m.close()
    assert sparse_visits[256]==sparse_visits[1024]==32768
    # Real old/new support moves across indexed tiles. Keep the original root
    # leased while a newer directory/index pair is prepared and consumed.
    draws,target=fixture(64,'sparse');m=Model(draws);old=m.initial();m.pub.heap.drain_writes();m.pub.submit(old)
    image,_=render(m.pub,old,[0]*4096,(0,0,64,64));old_index=m.index.root
    m.store.set(target,{5:32,7:64});change=m.store.commit();m.index.bounds(m.store,change['journal']);new=m.prepare(change);m.pub.heap.drain_writes();m.pub.submit(new)
    draws=[(i,g,p,(32,0,64,16) if i==target else rect,c,r) for i,g,p,rect,c,r in draws]
    expected=raster(draws);actual,visits=render(m.pub,new,image,change['damage']);assert actual==expected
    wrong,_=render(m.pub,new,image,change['damage'],index_override=old_index[0]);assert wrong!=expected;mutants['stale_spatial_new_nodes']=sum(a!=b for a,b in zip(wrong,expected))
    wrong,_=render(m.pub,new,image,(32,0,64,16));assert wrong!=expected;mutants['omit_old_support']=sum(a!=b for a,b in zip(wrong,expected))
    original,_=render(m.pub,old,[0]*4096,(0,0,64,64));assert original==image
    reports.append(dict(n=64,operation='bounds-move',visits=visits,source_work=change['counts'],index_work=m.index.counts(),index=m.index.ledger(),publication=m.pub.record()))
    m.finish(new);m.pub.signal(old.sequence);assert not m.pub.present(old);m.close();tests+=4
    #97-node subtree move/remove/insert: rebuild explicitly visits the full tree.
    tree=Tree(1,False);group=tree.add(1,w=64,h=64,color=0,clip=True)
    for i in range(96):tree.add(group,x=i%16*4,y=i//16*4,color=0xff000000,w=3,h=3)
    tree.add(1,x=40,y=40,w=12,h=12,color=0xffff0000);tree.recompute(1);m=Model(tree.draws());v=m.initial();m.pub.heap.drain_writes();m.pub.submit(v);image,_=render(m.pub,v,[0]*4096,(0,0,64,64));m.finish(v);m.index.counts()
    for operation in ['move-97','remove-97','insert']:
        if operation=='move-97':m.store.move(group,None,1);tree.nodes[1].children.remove(group);tree.nodes[1].children.append(group);tree.recompute(1)
        elif operation=='remove-97':
            m.store.remove(group)
            for i in tree.subtree(group):del tree.nodes[i];del tree.cache[i]
            tree.nodes[1].children.remove(group);tree.recompute(1)
        else:
            before=tree.nodes[1].children[0];new=tree.add(1,at=0,x=2,y=2,w=8,h=8,color=0xff0000ff);tree.recompute(1);m.store.insert(before,new,1,tree.cache[new][3],0xff0000ff)
        change=m.store.commit();verify(m.store,tree.draws())
        if len(m.store.index)>32:m.index.rebuild(m.store)
        else:m.index.close()
        v=m.prepare(change);m.pub.heap.drain_writes();m.pub.submit(v);image,visits=render(m.pub,v,image,change['damage']);assert image==raster(tree.draws());m.finish(v);tests+=1
        reports.append(dict(n=len(m.store.index),operation=operation,visits=visits,source_work=change['counts'],index_work=m.index.counts(),index=m.index.ledger(),publication=m.pub.record()))
    m.close();(out/'checks.json').write_text(json.dumps(dict(tests=tests,rows=reports,sparse_visits=sparse_visits,mutant_wrong_pixels=mutants,scope='CPU graph/pixel/count model only; GPU and timing pending'),indent=2));print(tests,sparse_visits,mutants)
if __name__=='__main__':main(Path(sys.argv[1]))
