"""Executable storage/publication alternatives. No Python timing or allocation claims.
CPU language-object overhead is deliberately separate from wire-format ledgers.
"""
from dataclasses import dataclass, field
from pathlib import Path
import copy, hashlib, json, random, struct, sys
NIL=0xffffffff
WIDTH=64
COLS=12
PAGE=32
ZERO=(0,)*COLS

def pack(words): return struct.pack('<'+'I'*len(words),*words)
def encode(rows):
    assert len(rows)==32 and all(len(r)==12 for r in rows)
    raw=[0]+[v for row in rows for v in row]
    out=[1]+[0]*36
    for c in range(12):
        values=[r[c] for r in rows];base=min(values);bits=(max(values)-base).bit_length()
        at=len(out);out[1+c*3:4+c*3]=[base,bits,at]
        if bits:
            out += [0]*bits # 32 records * bits / 32
            for i,v in enumerate(values):
                bit=i*bits;w=at+bit//32;s=bit%32;delta=v-base
                out[w] |= (delta<<s)&NIL
                if s+bits>32:out[w+1] |= delta>>(32-s)
    return out if len(out)<len(raw) else raw

def decode(block,i,c):
    if block[0]==0:return block[1+i*12+c]
    base,bits,at=block[1+c*3:4+c*3]
    if not bits:return base
    bit=i*bits;w=at+bit//32;s=bit%32;v=block[w]>>s
    if s+bits>32:v |= block[w+1]<<(32-s)
    return base+(v&((1<<bits)-1))

def bound(rect):
    l,t,r,b=rect;return (max(0,min(64,l)),max(0,min(64,t)),max(0,min(64,r)),max(0,min(64,b)))
def intersect(a,b):return (max(a[0],b[0]),max(a[1],b[1]),min(a[2],b[2]),min(a[3],b[3]))
def damage_union(rects):
    rects=[r for r in rects if r[2]>r[0] and r[3]>r[1]]
    return (min(r[0] for r in rects),min(r[1] for r in rects),max(r[2] for r in rects),max(r[3] for r in rects)) if rects else (0,0,0,0)

def raster(draws,clear=0xffffffff):
    # Independent full painter, with no compressed addressing or damage use.
    p=[clear]*4096
    for _,_,_,rect,color,_ in draws:
        if color>>24!=255:continue
        l,t,r,b=bound(rect)
        for y in range(t,b):
            for x in range(l,r):p[y*64+x]=color
    return p

@dataclass
class Node:
    id:int
    parent:int|None
    x:int=0
    y:int=0
    w:int=4
    h:int=4
    color:int=0xff000000
    clip:bool=False
    flow:bool=False
    generation:int=1
    resource:int=0
    children:list=field(default_factory=list)

class Tree:
    def __init__(self,n,unique):
        self.nodes={1:Node(1,None,w=64,h=64,color=0xffffffff)};self.next_id=2
        rng=random.Random(20261028+n)
        while len(self.nodes)<n:
            group=self.add(1,x=(len(self.nodes)//17%8)*8,y=(len(self.nodes)//137%8)*8,w=8,h=8,color=0,clip=True)
            for i in range(min(15,n-len(self.nodes))):
                self.add(group,x=i%2*4,y=(i//2)*2,w=4,h=2,color=(0xff000000|rng.getrandbits(24)) if unique else 0xff000000)
        self.cache={};self.recompute(1)
    def add(self,parent,at=None,**kw):
        i=self.next_id;self.next_id+=1;self.nodes[i]=Node(i,parent,**kw)
        cs=self.nodes[parent].children;cs.insert(len(cs) if at is None else at,i);return i
    def subtree(self,i):
        out=[];stack=[i]
        while stack:
            a=stack.pop();out.append(a);stack.extend(reversed(self.nodes[a].children))
        return out
    def context(self,i):
        p=self.nodes[i].parent
        if p is None:return (0,0,(0,0,64,64),0)
        px,py,clip,_,_=self.cache[p];par=self.nodes[p]
        shift=sum(self.nodes[c].h for c in par.children[:par.children.index(i)]) if par.flow else 0
        return px,py,clip,shift
    def recompute(self,i):
        px,py,clip,shift=self.context(i);visited=[]
        stack=[(i,px,py,clip,shift)]
        while stack:
            j,px,py,clip,shift=stack.pop();n=self.nodes[j];x=px+n.x;y=py+n.y+shift
            own=intersect((x,y,x+n.w,y+n.h),clip);childclip=intersect(clip,(x,y,x+n.w,y+n.h)) if n.clip else clip
            self.cache[j]=(x,y,childclip,bound(own),n.color);visited.append(j)
            off=0;tasks=[]
            for c in n.children:
                tasks.append((c,x,y,childclip,off));off += self.nodes[c].h if n.flow else 0
            stack.extend(reversed(tasks))
        return visited
    def oracle(self):
        # Full independent recursive traversal. Small fixture depths, no cache.
        out=[]
        def go(i,px,py,clip):
            n=self.nodes[i];x=px+n.x;y=py+n.y;rect=bound(intersect((x,y,x+n.w,y+n.h),clip));at=len(out)
            out.append([i,n.generation,n.parent,rect,n.color,n.resource]);off=0
            cc=intersect(clip,(x,y,x+n.w,y+n.h)) if n.clip else clip
            for c in n.children:
                go(c,x,y+off,cc);off+=self.nodes[c].h if n.flow else 0
        go(1,0,0,(0,0,64,64));return out
    def draws(self):
        order=self.subtree(1)
        return [(i,self.nodes[i].generation,self.nodes[i].parent,self.cache[i][3],self.nodes[i].color,self.nodes[i].resource) for i in order]
    def change(self,op):
        kind=op[0];i=op[1];removed=[];lookup=1;ancestors=0
        if kind=='paint':self.nodes[i].color=op[2];self.cache[i]=(*self.cache[i][:4],op[2]);visited=[i]
        elif kind in ('translate','clip','flow','height'):
            n=self.nodes[i]
            if kind=='translate':n.x+=op[2]
            elif kind=='clip':n.w=op[2];n.clip=True
            elif kind=='flow':n.flow=True
            else:n.h=op[2]
            root=n.parent if kind=='height' and n.parent and self.nodes[n.parent].flow else i
            visited=self.recompute(root)
        elif kind=='insert':
            self.add(i,at=op[2],color=0xffff0000,w=3,h=3);visited=self.recompute(i)
        elif kind=='remove':
            parent=self.nodes[i].parent;removed=self.subtree(i);self.nodes[parent].children.remove(i)
            for j in removed:del self.nodes[j];del self.cache[j]
            visited=self.recompute(parent)
        elif kind=='move':
            parent=self.nodes[i].parent;dest=op[2];assert dest not in self.subtree(i)
            self.nodes[parent].children.remove(i);self.nodes[dest].children.insert(0,i);self.nodes[i].parent=dest
            visited=list(dict.fromkeys(self.recompute(parent)+self.recompute(dest)))
        elif kind=='reuse':
            # Explicit slot-generation reuse; no stale id alone is actionable.
            parent=self.nodes[i].parent;old=self.nodes[i];assert not old.children
            self.nodes[i]=Node(i,parent,x=old.x,y=old.y,w=old.w,h=old.h,color=op[2],generation=old.generation+1)
            visited=self.recompute(i)
        else:raise AssertionError(kind)
        node=i if i in self.nodes else parent
        while self.nodes[node].parent is not None:ancestors+=1;node=self.nodes[node].parent
        draws=self.draws();oracle=self.oracle();assert draws==[tuple(x) for x in oracle]
        return draws,dict(identity_lookup=lookup,dependency_nodes=len(visited),removed_nodes=len(removed),ancestor_visits=ancestors,producer_order_scan_nodes=len(draws),oracle_nodes=len(oracle))

class Arena:
    """Immutable append-only pages: no overwrite before completion, no free claim.
    Every version's referenced bytes and resources survive until experiment end.
    Directory depth 2 covers <=32768 slots. A growing unbounded log is a known
    counterexample; a production design needs fenced reclamation/compaction.
    """
    def __init__(self):self.words=[0];self.blocks={};self.leaves={};self.root=[0]*32;self.root_at=0;self.versions=[]
    def alloc(self,data,writes):
        off=len(self.words);self.words.extend(data);writes.append(dict(offset=off,words=data));return off
    def publish(self,blocks):
        writes=[];dirty={};encoded=0;reencoded=0
        for b,rows in blocks.items():
            data=encode(rows);reencoded+=32
            if b in self.blocks and self.blocks[b][1]==data:continue
            at=self.alloc(data,writes);self.blocks[b]=(at,data);encoded+=len(data)*4
            leaf=b//32
            if leaf not in dirty:dirty[leaf]=self.leaves.get(leaf,[0]*32).copy()
            dirty[leaf][b%32]=at
        for l,data in dirty.items():self.root[l]=self.alloc(data,writes);self.leaves[l]=data
        if dirty or not self.root_at:self.root_at=self.alloc(self.root.copy(),writes)
        self.versions.append(self.root_at)
        live=sum(len(v[1])*4 for v in self.blocks.values())+128*(len(self.leaves)+1)
        return writes,dict(encoded_payload_bytes=encoded,directory_bytes=128*(len(dirty)+(bool(dirty) or len(self.versions)==1)),codec_rows_reencoded=reencoded,live_compressed_and_directory_bytes=live,retained_arena_bytes=len(self.words)*4)
    def read(self,root,slot,col):
        b=slot//32;leaf=self.words[root+b//32];at=self.words[leaf+b%32]
        # Block decoding has known bounded size; slicing is reference-only.
        return decode(self.words[at:at+385],slot%32,col)

class Layout:
    def __init__(self,kind):
        self.kind=kind;self.rows=[];self.loc={};self.arena=Arena();self.presented=[];self.pixels=[0xffffffff]*4096;self.jobs=[];self.metrics=[];self.root=0;self.sequence=0
    def update(self,name,draws,producer,accepted=True,mutant=None):
        ids=[d[0] for d in draws];assert len(ids)==len(set(ids));oldloc=self.loc.copy();oldrows=self.rows
        if self.kind=='packed':loc={i:j for j,i in enumerate(ids)};slots=len(ids)
        else:loc={i:i-1 for i in ids};slots=max([len(oldrows),*(x+1 for x in loc.values())])
        assert slots<=32768
        rows=[ZERO]*slots;spans={i:1 for i in ids};parents={d[0]:d[2] for d in draws}
        for i in reversed(ids):
            if parents[i] is not None:spans[parents[i]]+=spans[i]
        for k,(i,g,parent,rect,color,resource) in enumerate(draws):
            nxt=loc[ids[k+1]] if k+1<len(ids) else NIL
            rows[loc[i]]=(i,g,loc[parent] if parent is not None else NIL,nxt,spans[i],*rect,color,1,resource)
        touched=[j for j,row in enumerate(rows) if j>=len(oldrows) or oldrows[j]!=row]
        # Removed trailing packed records require no payload access under new count.
        blocks={b:[rows[j] if j<len(rows) else ZERO for j in range(b*32,(b+1)*32)] for b in sorted({j//32 for j in touched})}
        writes,cost=self.arena.publish(blocks);root=self.arena.root_at
        decoded_rows=[tuple(self.arena.read(root,j,c) for c in range(12)) for j in range(len(rows))]
        assert decoded_rows==rows
        # Stable handles carry generation; rank is never exposed as identity.
        for i,old in oldloc.items():
            if i in loc and self.kind=='paged':assert old==loc[i]
        new_by={d[0]:d for d in draws};old_by={d[0]:d for d in self.presented}
        changed={i for i in new_by.keys()|old_by.keys() if new_by.get(i)!=old_by.get(i)}
        if [d[0] for d in draws]!=[d[0] for d in self.presented]:
            # Conservative reorder closure: all surviving paint support, charged.
            changed.update(new_by);changed.update(old_by)
        rects=[d[3] for i in changed for d in ([new_by[i]] if i in new_by else [])]
        if mutant!='old-damage':rects += [old_by[i][3] for i in changed if i in old_by]
        damage=damage_union(rects)
        if not self.presented:damage=(0,0,64,64)
        if mutant=='span' and len(rows)>1:count=len(draws)-1
        else:count=len(draws)
        self.sequence+=1;epoch=self.sequence;current=epoch if accepted else epoch+1
        if mutant=='stale':current=epoch
        desc=[root,loc[ids[0]],count,0 if self.kind=='packed' else 1,slots,epoch,current,0,*damage,0xffffffff,0,0,0]
        candidate=self.pixels.copy();l,t,r,b=damage
        if epoch==current:
            for y in range(t,b):
                for x in range(l,r):
                    color=0xffffffff;slot=desc[1]
                    for _ in range(count):
                        row=decoded_rows[slot]
                        if row[10] and row[5]<=x<row[7] and row[6]<=y<row[8] and row[9]>>24==255:color=row[9]
                        slot=slot+1 if self.kind=='packed' else row[3]
                    candidate[y*64+x]=color
        expected=raster(draws) if accepted else self.pixels
        assert candidate==expected,(self.kind,name,'pixel mismatch')
        previous_roots=self.arena.versions[:-1]
        # Root directory snapshots are immutable even after newer uploads.
        assert all(self.arena.words[r:r+32] for r in previous_roots)
        if accepted:self.presented=copy.deepcopy(draws);self.pixels=candidate
        relocated=sum(i in oldloc and oldloc[i]!=p for i,p in loc.items())
        metric=dict(name=name,layout=self.kind,nodes=len(draws),slots=slots,accepted=accepted,**producer,**cost,
            layout_index_scan_nodes=len(draws)*2,damage_compare_nodes=len(draws)+len(old_by),
            logical_rows_rewritten=len(touched),logical_bytes_rewritten=len(touched)*48,
            relocated_records=relocated,logical_bytes_moved=relocated*48,
            identity_index_entries_rewritten=sum(oldloc.get(i)!=p for i,p in loc.items())+len(oldloc.keys()-loc.keys()),
            identity_directory_wire_bytes=len(loc)*12,canonical_wire_bytes=slots*48,
            cpu_canonical_mirror_bytes=slots*48,damage=list(damage),damage_pixels=max(0,r-l)*max(0,b-t),
            descriptor_bytes=64,uploaded_bytes=sum(len(w['words'])*4 for w in writes)+64,
            queue_writes=len(writes)+1,render_record_visits=max(0,r-l)*max(0,b-t)*count if accepted else 0,
            retained_version_count=len(self.arena.versions),resource_tokens_retained=len({d[5] for d in draws if d[5]}),
            subtree_lookup_loads=1,contiguous_subtree=self.kind=='packed',decode_max_payload_loads_per_field=2)
        self.rows=rows;self.loc=loc;self.root=root;self.metrics.append(metric)
        self.jobs.append(dict(name=name,writes=writes,descriptor=desc,canonical=[v for row in rows for v in row],expected=expected))
    def series(self,name,out):
        jobs=[]
        for j,job in enumerate(self.jobs):
            job=job.copy();p=f'{name}-{j}.rgba';(out/p).write_bytes(pack(job.pop('expected')));job['pixels']=p;jobs.append(job)
        return dict(name=name,arena_words=len(self.arena.words),slots=max(j['descriptor'][4] for j in jobs),jobs=jobs)

def codec_adversaries():
    rng=random.Random(20261028);tests=0;escapes=0
    for bits in range(33):
        for offset in [0,1,0x80000000,0xffffffff]:
            rows=[tuple((offset+rng.getrandbits(bits))&NIL for _ in range(12)) for _ in range(32)]
            data=encode(rows);assert [[decode(data,i,c) for c in range(12)] for i in range(32)]==[list(r) for r in rows];tests+=1;escapes+=data[0]==0
    # Wrong-width mutant must be witnessed using the same decoder.
    rows=[tuple(i for _ in range(12)) for i in range(32)];data=encode(rows);data[2]-=1
    assert any(decode(data,i,c)!=rows[i][c] for i in range(32) for c in range(12))
    return dict(roundtrips=tests,raw_escapes=escapes,width_mutant_rejected=True)

def run_models(out):
    series=[];metrics=[];negative=[]
    for n in [32,256,1024]:
        for unique in [False,True]:
            tree=Tree(n,unique);layouts=[Layout('packed'),Layout('paged')]
            initial=tree.draws();producer=dict(identity_lookup=0,dependency_nodes=n,removed_nodes=0,ancestor_visits=0,producer_order_scan_nodes=n,oracle_nodes=n)
            for l in layouts:l.update('initial',initial,producer)
            leaf=3;group=2;other=18
            ops=[('paint',leaf,0xff00ff00),('translate',group,2),('clip',group,5),('flow',group),('height',leaf,5),('insert',group,0),('remove',4),('insert',group,1),('move',leaf,other),('reuse',5,0xffff00ff),('paint',5,0xff123456),('paint',5,0xff654321)]
            for j,op in enumerate(ops):
                draws,producer=tree.change(op)
                accepted=j!=10
                for l in layouts:l.update(f'{j}-{op[0]}',draws,producer,accepted)
            for l in layouts:
                name=f'{n}-'+('unique' if unique else 'repeated')+'-'+l.kind
                series.append(l.series(name,out));metrics.extend(dict(series=name,**m) for m in l.metrics)
    # Isolated, small certificates deliberately falsified; no retries/relaxations.
    for mutant in ['span','old-damage','stale']:
        tree=Tree(32,False);l=Layout('packed');l.update('initial',tree.draws(),{})
        if mutant=='span':
            # Last visible leaf has unique paint so omitting it changes pixels.
            last=tree.subtree(1)[-1];tree.nodes[last].y=0;tree.nodes[last].color=0xffff0000;tree.recompute(1);draws=tree.draws();accepted=True
        elif mutant=='old-damage':draws,_=tree.change(('translate',2,32));accepted=True
        else:draws,_=tree.change(('paint',3,0xffff0000));accepted=False
        try:l.update('mutant',draws,{},accepted,mutant)
        except AssertionError as error:negative.append(dict(mutant=mutant,rejected=True,error=str(error)))
        else:raise AssertionError('surviving mutant '+mutant)
    return series,metrics,negative

def public_models(path,out):
    report=json.loads(path.read_text());series=[];metrics=[]
    for kind in ['packed','paged']:
        layout=Layout(kind);identities={};nextid=1
        for frame in report['frames']:
            snapshot=frame['snapshot']['nodes'];draws=[];used=set()
            # Fixture contract: one opaque rectangular paint per snapshot node,
            # same preorder; semantic bounds are outward conservative, not pixels.
            assert len(frame['draws'])==len(snapshot)
            for d,node in zip(frame['draws'],snapshot,strict=True):
                rect=tuple(int(x) for x in d['rect']);assert list(rect)==d['rect']
                x,y,w,h=node['bounds']
                assert x<=rect[0] and y<=rect[1] and x+w>=rect[2] and y+h>=rect[3]
                assert node['transform']==[1.,0.,0.,1.,float(rect[0]),float(rect[1])]
                identity=node['identity'];assert identity not in used;used.add(identity)
                if identity not in identities:identities[identity]=nextid;nextid+=1
                channels=[int(x*255) for x in d['color']];color=int.from_bytes(bytes(channels),'little')
                parent=None if node['parent'] is None else identities[snapshot[node['parent']]['identity']]
                draws.append((identities[identity],1,parent,rect,color,0))
            actual=list(struct.unpack('<4096I',(path.parent/frame['pixels']).read_bytes()))
            assert raster(draws)==actual,('public full renderer',frame['name'])
            producer=dict(identity_lookup=1,dependency_nodes=None,removed_nodes=None,ancestor_visits=None,producer_order_scan_nodes=len(draws),oracle_nodes=len(draws),adapter_snapshot_nodes=frame['adapter_snapshot_nodes'],gpui_counters=frame['counters'])
            layout.update(frame['name'],draws,producer,frame['accepted'])
        name='public-'+kind;series.append(layout.series(name,out));metrics.extend(dict(series=name,**m) for m in layout.metrics)
    return series,metrics

def main():
    out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
    codec=codec_adversaries();series,metrics,negative=run_models(out)
    if len(sys.argv)>2:
        public,rows=public_models(Path(sys.argv[2]),out);series+=public;metrics+=rows
    (out/'jobs.json').write_text(json.dumps(series,separators=(',',':')))
    (out/'metrics.json').write_text(json.dumps(metrics,indent=2))
    (out/'checks.json').write_text(json.dumps(dict(codec=codec,mutants=negative,frames=len(metrics),seed=20261028,scope='representation model, no production integration or performance verdict'),indent=2))
    print(json.dumps(dict(series=len(series),frames=len(metrics),codec=codec,mutants=negative)))
if __name__=='__main__':main()
