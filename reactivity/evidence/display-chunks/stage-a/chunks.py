"""Incremental authoritative compressed pages; oracle materialization is separate.
All accounting here is deterministic algorithm work, not timing or Rust ABI size.
"""
from collections import Counter
from dataclasses import dataclass
import copy, json, struct, sys
from pathlib import Path
from experiment import encode, decode, pack, ZERO, NIL, damage_union, Tree, raster

@dataclass
class Page:
    data:bytes
    count:int
    prev:int|None
    next:int|None

class Chunks:
    def __init__(self,draws,ordered=True,small_raw=False):
        self.ordered=ordered;self.small_raw=small_raw;self.pages={};self.index={};self.next_page=0
        self.free_pages=[];self.first=None;self.last=None;self.pending_damage=(0,0,0,0)
        self.c=Counter();self.dirty={};self.changed=set();self.deleted=set();self.events=[]
        parents={d[0]:d[2] for d in draws};spans={d[0]:1 for d in draws}
        for d in reversed(draws):
            if d[2] is not None:spans[d[2]]+=spans[d[0]]
        rows=[[i,g,parent if parent is not None else NIL,NIL,spans[i],*rect,color,1,res] for i,g,parent,rect,color,res in draws]
        for start in range(0,len(rows),32):
            page=self.new_page(self.last,None);part=rows[start:start+32]
            self.dirty[page]=part
            if self.last is not None:self.pages[self.last].next=page
            else:self.first=page
            self.last=page;self.reindex(page)
        for page in list(self.pages):self.link(page)
        self.commit();self.c.clear()
    def new_page(self,prev,next):
        page=self.free_pages.pop() if self.free_pages else self.next_page
        if page==self.next_page:self.next_page+=1
        self.pages[page]=Page(b'',0,prev,next);self.c['page_headers_written']+=1
        self.changed.add(page);return page
    def raw_mode(self,rows):return self.small_raw and len(self.pages)==1 and len(rows)<=32
    def words(self,page):
        data=self.pages[page].data;self.c['encoded_words_copied']+=len(data)//4
        return list(struct.unpack('<'+'I'*(len(data)//4),data))
    def field(self,page,slot,col):
        data=self.pages[page].data
        def word(at):
            self.c['random_field_word_loads']+=1
            return struct.unpack_from('<I',data,at*4)[0]
        if word(0)==0:return word(1+slot*12+col)
        base=word(1+col*3);bits=word(2+col*3)
        if not bits:return base
        offset=word(3+col*3);bit=slot*bits;at=offset+bit//32;shift=bit%32
        value=word(at)>>shift
        if shift+bits>32:value |= word(at+1)<<(32-shift)
        return base+(value&((1<<bits)-1))
    def load(self,page):
        if page not in self.dirty:
            p=self.pages[page];words=self.words(page)
            self.dirty[page]=[[decode(words,i,c) for c in range(12)] for i in range(p.count)]
            self.c['page_decodes']+=1;self.c['rows_decoded']+=p.count
        self.c['decode_scratch_rows_peak']=max(self.c['decode_scratch_rows_peak'],sum(len(v) for v in self.dirty.values()))
        return self.dirty[page]
    def address(self,identity,generation=None):
        self.c['identity_lookups']+=1
        hit=self.index.get(identity)
        if hit is None or generation is not None and hit[2]!=generation:raise KeyError((identity,generation))
        return hit[:2]
    def read(self,identity,generation=None):
        page,slot=self.address(identity,generation)
        if page in self.dirty:return self.dirty[page][slot].copy()
        self.c['random_record_decodes']+=1
        return [self.field(page,slot,c) for c in range(12)]
    def damage(self,old,new):
        self.c['damage_records']+=int(old is not None)+int(new is not None)
        self.pending_damage=damage_union([self.pending_damage]+([tuple(old[5:9])] if old is not None else [])+([tuple(new[5:9])] if new is not None else []))
    def set(self,identity,fields,generation=None):
        page,slot=self.address(identity,generation)
        for value in fields.values():assert 0<=value<=NIL
        same=all((self.dirty[page][slot][c] if page in self.dirty else self.field(page,slot,c))==v for c,v in fields.items())
        if same:return
        rows=self.load(page);old=rows[slot].copy()
        for col,value in fields.items():assert 0<=value<=NIL;rows[slot][col]=value
        if rows[slot]!=old:
            self.changed.add(page);self.c['records_changed']+=1
            if any(c in fields for c in range(5,12)):self.damage(old,rows[slot])
    def reindex(self,page):
        for slot,row in enumerate(self.dirty[page]):
            old=self.index.get(row[0]);new=(page,slot,row[1]);self.index[row[0]]=new
            self.c['identity_entries_examined']+=1
            if old!=new:
                self.c['identity_entries_written']+=1
                if old is not None:self.c['records_relocated']+=1
        self.pages[page].count=len(self.dirty[page]);self.changed.add(page)
    def link(self,page):
        rows=self.load(page);nxt=self.pages[page].next
        # Local row addresses only; parent fields are stable identities.
        for slot,row in enumerate(rows):
            value=page*32+slot+1 if slot+1<len(rows) else (nxt*32 if nxt is not None else NIL)
            if row[3]!=value:row[3]=value;self.c['next_links_written']+=1;self.changed.add(page)
    def ancestors(self,parent,delta):
        seen=set()
        while parent!=NIL:
            assert parent not in seen;seen.add(parent);self.c['ancestor_visits']+=1
            row=self.read(parent);self.set(parent,{4:row[4]+delta});parent=row[2]
    def insert_rows(self,before,rows):
        if before is None:page=self.last;slot=self.pages[page].count
        else:page,slot=self.address(before)
        if not self.ordered:
            # Stable slots comparison uses append-only page positions; painter
            # chain indirection is maintained separately, not ordered chunks.
            raise NotImplementedError('stable baseline is preserved first-pair implementation')
        # Every loop inserts at most a page, charging local movement and splits.
        for row in rows:
            data=self.load(page);data.insert(slot,row.copy());self.damage(None,row)
            if len(data)>32:
                following=self.pages[page].next;new=self.new_page(page,following)
                if following is None:self.last=new
                else:self.pages[following].prev=new;self.c['page_headers_written']+=1
                self.pages[page].next=new;self.c['page_headers_written']+=1
                self.dirty[new]=data[16:];del data[16:]
                self.reindex(page);self.reindex(new);self.link(page);self.link(new);self.c['splits']+=1
                if slot>=16:page=new;slot-=16
            else:self.reindex(page);self.link(page)
            slot+=1
    def insert(self,before,identity,parent,rect,color,generation=1,resource=0):
        assert identity not in self.index
        if parent!=NIL:self.address(parent)
        self.insert_rows(before,[[identity,generation,parent,NIL,1,*rect,color,1,resource]])
        self.ancestors(parent,1)
    def extent(self,identity):
        first=self.read(identity);page,slot=self.address(identity);remaining=first[4];result=[];chunks=0
        while remaining:
            p=self.pages[page];chunks+=1;self.c['extent_pages']+=1
            words=None if page in self.dirty else self.words(page)
            for at in range(slot,min(p.count,slot+remaining)):
                row=self.dirty[page][at].copy() if words is None else [decode(words,at,c) for c in range(12)]
                result.append(row);self.c['extent_records']+=1
            used=min(p.count-slot,remaining);remaining-=used
            if remaining:assert p.next is not None;page=p.next;slot=0
        return result
    def unlink(self,page):
        p=self.pages[page]
        if p.prev is None:self.first=p.next
        else:self.pages[p.prev].next=p.next;self.link(p.prev)
        if p.next is None:self.last=p.prev
        else:self.pages[p.next].prev=p.prev
        del self.pages[page];self.dirty.pop(page,None);self.changed.discard(page);self.deleted.add(page);self.free_pages.append(page)
        self.c['page_headers_written']+=2
    def maybe_merge(self,page):
        if page not in self.pages:return
        p=self.pages[page];nxt=p.next
        if nxt is not None and p.count+self.pages[nxt].count<=32:
            data=self.load(page);data.extend(self.load(nxt));self.unlink(nxt)
            self.reindex(page);self.link(page);self.c['merges']+=1
    def detach(self,identity):
        records=self.extent(identity);parent=records[0][2];self.ancestors(parent,-len(records))
        by_page={}
        for row in records:
            page,slot=self.address(row[0]);by_page.setdefault(page,[]).append(slot);self.damage(row,None)
        for page,slots in by_page.items():
            data=self.load(page)
            for slot in sorted(slots,reverse=True):del self.index[data[slot][0]];del data[slot];self.c['identity_entries_deleted']+=1
            if data:self.reindex(page);self.link(page)
            else:self.unlink(page)
        for page in list(by_page):self.maybe_merge(page)
        return records
    def remove(self,identity):
        assert identity!=1;return self.detach(identity)
    def move(self,identity,before,parent):
        rows=self.extent(identity);members={r[0] for r in rows};assert before not in members and parent not in members
        self.detach(identity);rows[0][2]=parent;self.insert_rows(before,rows);self.ancestors(parent,len(rows))
    def commit(self):
        journal={}
        # This iterates touched pages, never the complete page collection.
        for page,rows in self.dirty.items():
            if page not in self.pages:continue
            self.c['codec_rows']+=len(rows)
            words=([0]+[v for row in rows for v in row]) if self.raw_mode(rows) else encode([tuple(r) for r in rows]+[ZERO]*(32-len(rows)))
            data=pack(words)
            if data!=self.pages[page].data:
                self.pages[page].data=data;journal[page]=data;self.c['encoded_bytes_written']+=len(data)
        self.c['dirty_pages']=len(journal);self.c['deleted_pages']=len(self.deleted)
        result=dict(counts=dict(self.c),journal=journal,deleted=set(self.deleted),damage=self.pending_damage)
        self.dirty={};self.changed=set();self.deleted=set();self.c=Counter();return result
    def acknowledge(self):self.pending_damage=(0,0,0,0)
    def inspect(self):
        # Oracle-only expansion, deliberately not called by mutation methods.
        rows=[];page=self.first;seen=set()
        while page is not None:
            assert page not in seen;seen.add(page);p=self.pages[page];words=self.words(page)
            for slot in range(p.count):rows.append([decode(words,slot,c) for c in range(12)])
            page=p.next
        assert len(seen)==len(self.pages)
        return rows
    def ledger(self):
        # Diagnostic walk, not candidate update work. Python sizes below are
        # representation prototypes, not projected Rust allocator/ABI costs.
        payload=sum(len(p.data) for p in self.pages.values())
        return dict(payload_bytes=payload,page_header_wire_bytes=len(self.pages)*16,identity_wire_bytes=len(self.index)*12,
            page_count=len(self.pages),live_nodes=len(self.index),unused_slots=sum(32-p.count for p in self.pages.values()),
            python_page_bytes=sum(sys.getsizeof(p)+sys.getsizeof(p.__dict__)+sys.getsizeof(p.data) for p in self.pages.values()),
            python_index_bytes=sys.getsizeof(self.index)+sum(sys.getsizeof(k)+sys.getsizeof(v) for k,v in self.index.items()))

def canonical(draws):
    spans={d[0]:1 for d in draws}
    for d in reversed(draws):
        if d[2] is not None:spans[d[2]]+=spans[d[0]]
    return [[i,g,parent if parent is not None else NIL,spans[i],*rect,color,1,res] for i,g,parent,rect,color,res in draws]
def verify(store,draws):
    actual=store.inspect();assert [r[:3]+r[4:] for r in actual]==canonical(draws)
    for j,r in enumerate(actual):
        p,s,g=store.index[r[0]];assert g==r[1]
        nxt=actual[j+1][0] if j+1<len(actual) else None
        assert r[3]==(store.index[nxt][0]*32+store.index[nxt][1] if nxt else NIL)
        assert store.read(r[0],g)==r
        try:store.address(r[0],g+1)
        except KeyError:pass
        else:raise AssertionError('stale handle admitted')
    store.c.clear()

# Fenced immutable allocations: all graph edges have counted ownership.
@dataclass
class Allocation:
    generation:int
    size:int
    data:bytes
    children:tuple
    refs:int=1
class Heap:
    def __init__(self):self.end=0;self.live={};self.free={};self.generations={};self.writes=[];self.c=Counter()
    def alloc(self,data,children=()):
        size=1<<max(4,(len(data)-1).bit_length());bin=self.free.setdefault(size,[])
        if bin:offset=bin.pop();self.c['reused_allocations']+=1
        else:offset=self.end;self.end+=size
        generation=self.generations.get(offset,0)+1;self.generations[offset]=generation;handle=(offset,generation)
        for child in children:self.retain(child)
        self.live[offset]=Allocation(generation,size,data,tuple(children));self.writes.append((offset,data));self.c['uploaded_bytes']+=len(data)
        return handle
    def get(self,h):
        a=self.live[h[0]];assert a.generation==h[1];return a
    def retain(self,h):self.get(h).refs+=1;self.c['ref_increments']+=1
    def release(self,h):
        stack=[h]
        while stack:
            key=stack.pop();a=self.get(key);a.refs-=1;self.c['ref_decrements']+=1;assert a.refs>=0
            if a.refs==0:
                stack.extend(a.children);del self.live[key[0]];self.free.setdefault(a.size,[]).append(key[0])
    def drain_writes(self):
        result=self.writes;self.writes=[];return result
    def ledger(self):
        return dict(pending_upload_bytes=sum(len(data) for _,data in self.writes),heap_bookkeeping_entries=len(self.live),heap_child_edges=sum(len(a.children) for a in self.live.values()),slot_generation_entries=len(self.generations),free_bin_entries=sum(len(v) for v in self.free.values()),arena_high_water=self.end,live_payload=sum(len(a.data) for a in self.live.values()),live_allocated=sum(a.size for a in self.live.values()),fragmentation=sum(a.size-len(a.data) for a in self.live.values()),free_bytes=sum(size*len(slots) for size,slots in self.free.items()),live_allocations=len(self.live),**dict(self.c))

@dataclass(frozen=True)
class Version:
    namespace:int
    sequence:int
    root:tuple
    def __iter__(self):return iter((self.sequence,self.root))
    def __getitem__(self,index):return (self.sequence,self.root)[index]

class Publication:
    next_namespace=1
    def __init__(self):
        self.namespace=Publication.next_namespace;Publication.next_namespace+=1
        self.heap=Heap();self.eligible=None;self.visible=None;self.submitted={};self.sequence=0;self.current_pages={};self.current_resources={};self.eligible_complete=False
    def prepare(self,journal,deleted=(),resources=None):
        if self.sequence==NIL:raise OverflowError('publication sequence exhausted')
        h=self.heap;changed=[]
        for page in deleted:
            if page in self.current_pages:h.release(self.current_pages.pop(page))
        for page,data in journal.items():
            new=h.alloc(data);old=self.current_pages.get(page);self.current_pages[page]=new
            if old is not None:h.release(old)
            changed.append(page)
        if resources is not None:
            # Whole resource table replacement is explicit and charged. Not a
            # solved incremental text/image atlas; actual bytes tested in Stage B.
            for key in list(self.current_resources):
                if key not in resources:h.release(self.current_resources.pop(key))
            for key,data in resources.items():
                old=self.current_resources.get(key)
                if old is not None and h.get(old).data==data:continue
                self.current_resources[key]=h.alloc(data)
                if old is not None:h.release(old)
        # Deliberate first lifetime model baseline: flat directory rebuild.
        # Charged O(page count + resources); bounded COW radix follows in Stage B.
        children=tuple(self.current_pages.values())+tuple(self.current_resources.values())
        descriptor=pack([len(self.current_pages),len(self.current_resources)]+[x[0] for x in children])
        root=h.alloc(descriptor,children);self.sequence+=1
        if self.eligible is not None:h.release(self.eligible[1])
        self.eligible=Version(self.namespace,self.sequence,root);self.eligible_complete=False
        return self.eligible
    def submit(self,version):
        assert version.namespace==self.namespace
        sequence,root=version;assert sequence not in self.submitted
        if len(self.submitted)>=3:return False
        self.heap.retain(root);self.submitted[sequence]=root;return True
    def signal(self,sequence):
        root=self.submitted.pop(sequence);self.heap.release(root)
        if self.eligible is not None and sequence==self.eligible.sequence:self.eligible_complete=True
    def present(self,version):
        if version!=self.eligible or not self.eligible_complete:return False
        if self.visible is not None:self.heap.release(self.visible[1])
        self.visible=version;self.heap.retain(version[1]);return True
    def failed_request(self):return self.eligible
    def close(self):
        assert not self.submitted
        if self.visible:self.heap.release(self.visible[1]);self.visible=None
        if self.eligible:self.heap.release(self.eligible[1]);self.eligible=None
        for h in self.current_pages.values():self.heap.release(h)
        for h in self.current_resources.values():self.heap.release(h)
        self.current_pages={};self.current_resources={};assert not self.heap.live


def main(out):
    out.mkdir(exist_ok=True,parents=True);reports=[];tests=0
    for n in [1,9,32,256,1024]:
        for unique in [False,True]:
            tree=Tree(n,unique);draws=tree.draws()
            for fallback in [False,True]:
                s=Chunks(draws,small_raw=fallback);verify(s,draws);s.acknowledge()
                reports.append(dict(n=n,unique=unique,raw_fallback=fallback,operation='initial',ledger=s.ledger()))
                # Property update follows one stable handle; no snapshot, rank,
                # whole-list metadata pass or expanded retained record mirror.
                leaf=next(i for i in tree.subtree(1) if not tree.nodes[i].children);expected=copy.deepcopy(draws)
                for turn in range(64):
                    old_pixels=raster(expected)
                    color=0xff000000|((turn*7919)&0xffffff);s.set(leaf,{9:color});result=s.commit()
                    expected=[(i,g,parent,rect,color if i==leaf else old,res) for i,g,parent,rect,old,res in expected]
                    verify(s,expected);tests+=1
                    new_pixels=raster(expected);l,t,r,b=result['damage']
                    assert all(a==z or l<=i%64<r and t<=i//64<b for i,(a,z) in enumerate(zip(old_pixels,new_pixels)))
                    assert result['counts']['identity_lookups']==1
                    assert result['counts']['dirty_pages']<=1 and result['counts'].get('rows_decoded',0)<=32
                    if turn in [0,1,63]:reports.append(dict(n=n,unique=unique,raw_fallback=fallback,operation=f'paint-{turn}',counts=result['counts'],ledger=s.ledger(),damage=result['damage']))
                    s.acknowledge()
                # Structural oracle has independent parent-child ownership.
                tree2=copy.deepcopy(tree);expected=tree2.draws();s=Chunks(expected,small_raw=fallback)
                for turn in range(40):
                    parent=1;before=tree2.nodes[1].children[0] if tree2.nodes[1].children else None
                    node=tree2.add(parent,at=0,color=0xffff0000,x=1,y=1,w=2,h=2);tree2.recompute(1)
                    rect=tree2.cache[node][3];s.insert(before,node,parent,rect,0xffff0000)
                    result=s.commit();verify(s,tree2.draws());tests+=1
                    if turn in [0,31,39]:reports.append(dict(n=n,unique=unique,raw_fallback=fallback,operation=f'insert-{turn}',counts=result['counts'],ledger=s.ledger()))
                # Remove a whole multi-page subtree, then move another subtree.
                target=tree2.nodes[1].children[0];removed=s.remove(target)
                for i in tree2.subtree(target):del tree2.nodes[i];del tree2.cache[i]
                tree2.nodes[1].children.remove(target);tree2.recompute(1);result=s.commit();verify(s,tree2.draws());tests+=1
                for target in list(tree2.nodes[1].children)[:35]:
                    s.remove(target)
                    for i in tree2.subtree(target):del tree2.nodes[i];del tree2.cache[i]
                    tree2.nodes[1].children.remove(target);tree2.recompute(1);s.commit();verify(s,tree2.draws());tests+=1
                # Move the last root child before the first, preserving identities.
                if len(tree2.nodes[1].children)>1:
                    target=tree2.nodes[1].children[-1];before=tree2.nodes[1].children[0]
                    s.move(target,before,1);tree2.nodes[1].children.remove(target);tree2.nodes[1].children.insert(0,target);tree2.recompute(1)
                    result=s.commit();verify(s,tree2.draws());tests+=1
                    reports.append(dict(n=n,unique=unique,raw_fallback=fallback,operation='move-subtree',counts=result['counts'],ledger=s.ledger()))
    # A non-root subtree crosses at least three chunks. Move and remove it.
    tree=Tree(1,False);group=tree.add(1,w=64,h=64,color=0,clip=True)
    for i in range(96):tree.add(group,x=i%16*4,y=i//16*4,color=0xff000000,w=3,h=3)
    sibling=tree.add(1,x=40,y=40,color=0xffff0000);tree.recompute(1)
    s=Chunks(tree.draws());s.move(group,None,1)
    tree.nodes[1].children.remove(group);tree.nodes[1].children.append(group);tree.recompute(1)
    result=s.commit();verify(s,tree.draws());assert result['counts']['extent_pages']>=6
    reports.append(dict(n=99,unique=False,raw_fallback=False,operation='move-97-node-subtree',counts=result['counts'],ledger=s.ledger()))
    records=s.remove(group)
    for i in tree.subtree(group):del tree.nodes[i];del tree.cache[i]
    tree.nodes[1].children.remove(group);tree.recompute(1);result=s.commit();verify(s,tree.draws());assert len(records)==97
    reports.append(dict(n=99,unique=False,raw_fallback=False,operation='remove-97-node-subtree',counts=result['counts'],ledger=s.ledger()));tests+=2
    # High-entropy values preserve every bit, including float bit-pattern payloads.
    import random
    rng=random.Random(20261029)
    for fallback in [False,True]:
        for n in [1,9,32,256]:
            tree=Tree(n,False);s=Chunks(tree.draws(),small_raw=fallback)
            values={}
            for i in tree.subtree(1):
                values[i]={c:rng.getrandbits(32) for c in [5,6,7,8,9,11]};s.set(i,values[i])
            result=s.commit();before=s.inspect()
            assert len(before)==n and all(len(r)==12 and all(r[c]==v for c,v in values[r[0]].items()) for r in before)
            reports.append(dict(n=n,unique=True,raw_fallback=fallback,operation='high-entropy-exact-words',counts=result['counts'],ledger=s.ledger()));tests+=1
    # Actual dependency closures: clipping, translation and parent flow layout.
    tree=Tree(256,False);s=Chunks(tree.draws());s.acknowledge()
    for op in [('clip',2,3),('translate',2,2),('flow',2),('height',3,5)]:
        old=raster(tree.draws());draws,producer=tree.change(op)
        # The producer's dependency list is explicit. Diffing the full oracle
        # here selects the fixture event; charge it as diagnostic extraction.
        expected={r[0]:r for r in canonical(draws)}
        current=s.inspect();changed=[]
        for r in current:
            new=expected[r[0]]
            if r[5:9]!=new[4:8]:changed.append((r[0],{c:new[c-1] for c in range(5,9)}))
        for i,fields in changed:s.set(i,fields)
        result=s.commit();verify(s,draws);new=raster(draws);l,t,r,b=result['damage']
        assert all(a==z or l<=i%64<r and t<=i//64<b for i,(a,z) in enumerate(zip(old,new)))
        reports.append(dict(n=256,unique=False,raw_fallback=False,operation='dependency-'+op[0],counts=result['counts'],producer=producer,oracle_diff_scan=256,ledger=s.ledger()));tests+=1;s.acknowledge()
    # Independent submitted/visible/eligible ownership. Three overlapping roots.

    shadow=bytearray()
    def upload(publication):
        for offset,data in publication.heap.drain_writes():
            if len(shadow)<offset+len(data):shadow.extend(bytes(offset+len(data)-len(shadow)))
            shadow[offset:offset+len(data)]=data
        assert publication.heap.ledger()['pending_upload_bytes']==0
    def observed(publication,handle):
        a=publication.heap.get(handle);return bytes(shadow[handle[0]:handle[0]+len(a.data)])

    pub=Publication();roots=[];witness=[]
    for i in range(3):
        version=pub.prepare({0:bytes([i])*200},resources={'image':bytes([i+3])*256,'text-mask':bytes([i+7])*63});upload(pub);assert pub.submit(version);roots.append(version)
    assert not pub.present(roots[-1]);oldroot=pub.heap.get(roots[0][1]);oldchildren=oldroot.children
    assert [observed(pub,h)[0] for h in oldchildren]==[0,3,7]
    denied=[]
    for i in range(40):
        v=pub.prepare({0:bytes([i+10])*200});upload(pub);assert not pub.submit(v);denied.append(pub.heap.ledger())
    assert denied[-1]['arena_high_water']==denied[-2]['arena_high_water']
    # Restore an eligible successor after testing a full submission queue.
    pub.signal(roots[2][0]);assert not pub.present(roots[2]);
    successor=pub.prepare({0:b'S'*200});upload(pub);assert pub.submit(successor);pub.signal(successor[0]);assert pub.present(successor);assert not pub.present(roots[0]);assert pub.failed_request()==successor
    # CPU completion notifications arrive out of order. Old bytes still owned.
    pub.signal(roots[1][0]);assert [observed(pub,h)[0] for h in oldchildren]==[0,3,7]
    witness.append(pub.heap.ledger());pub.signal(roots[0][0])
    try:pub.heap.get(roots[0][1])
    except (KeyError,AssertionError):pass
    else:raise AssertionError('retired root remains live')
    for i in range(1000):
        version=pub.prepare({0:bytes([i%256])*200},resources={'image':bytes([(i+3)%256])*256,'text-mask':bytes([(i+7)%256])*63})
        upload(pub);assert pub.submit(version);pub.signal(version[0]);assert pub.present(version)
        if i in [0,9,999]:witness.append(pub.heap.ledger())
    assert witness[-1]['arena_high_water']==witness[-2]['arena_high_water']
    # Namespace authority is independent from coincident numeric offsets/epochs.
    foreign=Publication();v=foreign.prepare({0:b'foreign'});foreign.heap.drain_writes();foreign.submit(v);foreign.signal(v[0]);assert foreign.present(v)
    twin=Publication();twin_version=twin.prepare({0:b'foreign'});twin.heap.drain_writes();twin.submit(twin_version);twin.signal(twin_version[0]);assert twin.present(twin_version)
    assert list(v)==list(twin_version) # identical numeric sequence/root/generation
    assert not foreign.present(twin_version)
    try:foreign.submit(twin_version)
    except AssertionError:pass
    else:raise AssertionError('coincident foreign publication admitted')
    twin.close()
    assert not foreign.present(pub.eligible)
    try:foreign.submit(pub.eligible)
    except AssertionError:pass
    else:raise AssertionError('foreign publication admitted')
    foreign.close()
    pub.close();assert pub.heap.ledger()['live_allocated']==0
    assert not hasattr(pub,'completed') # no unbounded completion-history set
    # Missing submission lease is falsified: old root freed before completion.
    mutant=Publication();a=mutant.prepare({0:b'old'});mutant.submit(a);mutant.heap.release(a[1]);mutant.prepare({0:b'new'})
    try:mutant.heap.get(a[1])
    except (KeyError,AssertionError):lease_mutant=True
    else:raise AssertionError('missing lease mutant survived')
    # One omitted shifted index repair must falsify the incremental certificate.
    tree=Tree(64,False);broken=Chunks(tree.draws());anchor=tree.nodes[1].children[0];old_address=broken.index[anchor]
    new_id=tree.add(1,at=0,color=0xffff0000);tree.recompute(1)
    broken.insert(anchor,new_id,1,tree.cache[new_id][3],0xffff0000);broken.commit();broken.index[anchor]=old_address
    broken.set(anchor,{9:0xff00ff00});broken.commit()
    try:verify(broken,tree.draws())
    except AssertionError:index_mutant=True
    else:raise AssertionError('omitted local index repair survived')
    summary=dict(index_mutant_rejected=index_mutant,tests=tests,rows=reports,lifetime=witness,backpressure=denied,lease_mutant_rejected=lease_mutant,scope='Stage A only; synthetic resource bytes; flat directory cost retained; no GPU overlap or general public binding qualification')
    (out/'results.json').write_text(json.dumps(summary,indent=2));print(json.dumps({k:v for k,v in summary.items() if k not in ['rows','lifetime','backpressure']}))
if __name__=='__main__':main(Path(sys.argv[1]))
