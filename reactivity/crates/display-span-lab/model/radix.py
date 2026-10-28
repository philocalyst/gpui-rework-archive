"""Persistent bounded GPU address directories over the fence-owned heap.
Only explicitly changed keys are visited; all32 root/64 leaf word copies count.
"""
import struct
from collections import Counter
from chunks import Heap,Version,Publication
from experiment import pack,NIL

class Directory:
    FANOUT=32
    CAPACITY=1024
    def __init__(self,heap,child_leases=True):self.child_leases=child_leases;self.heap=heap;self.root=None;self.leaves={};self.c=Counter()
    def handle_at(self,offset):
        allocation=self.heap.live[offset];return (offset,allocation.generation)
    def update(self,changes):
        if not changes:return self.root
        assert all(0<=i<self.CAPACITY for i in changes)
        h=self.heap;groups={}
        for key,value in changes.items():groups.setdefault(key//32,{})[key%32]=value;self.c['entries_examined']+=1
        roots=list(struct.unpack('<32I',h.get(self.root).data)) if self.root else [0]*32
        self.c['root_words_copied']+=32;temporary=[]
        for group,edits in groups.items():
            old=self.leaves.get(group);words=list(struct.unpack('<64I',h.get(old).data)) if old else [0]*64
            self.c['leaf_words_copied']+=64
            for slot,entry in edits.items():
                words[slot*2:slot*2+2]=[entry[0][0],entry[1]] if entry else [0,0]
            children=tuple(self.handle_at(words[i]) for i in range(0,64,2) if words[i])
            if children:
                new=h.alloc(pack(words),children if self.child_leases else ());temporary.append(new);self.leaves[group]=new;roots[group]=new[0];self.c['leaf_allocations']+=1
            else:self.leaves.pop(group,None);roots[group]=0
        children=tuple(self.handle_at(v) for v in roots if v)
        new=h.alloc(pack(roots),children);self.c['root_allocations']+=1
        if self.root:h.release(self.root)
        self.root=new
        for handle in temporary:h.release(handle)
        return new
    def close(self):
        if self.root:self.heap.release(self.root)
        self.root=None;self.leaves={}
    def reset_counts(self):result=dict(self.c);self.c.clear();return result

class RadixPublication(Publication):
    """Each submitted root owns node/resource directories and thus all payloads.
    CPU current-value maps are maintained in place with delta edits. No root
    snapshot clones those maps; immutable directory paths carry GPU ownership.
    """
    def __init__(self,resource_leases=True):
        super().__init__();self.heap.end=16 # offset0 is a null directory pointer
        self.nodes=Directory(self.heap);self.resources=Directory(self.heap,resource_leases);self.c=Counter()
        self.current_pages={};self.current_resources={};self.raw=False
    def prepare(self,journal,deleted=(),resource_changes=None,resource_deleted=(),*,count,slots,first,raw=False,clear=0xffffffff,spatial_root=None):
        if self.sequence==NIL:raise OverflowError('publication sequence exhausted')
        assert 1<=count<=32768 and count<=slots<=32768 and 0<=first<slots
        resource_changes={} if resource_changes is None else resource_changes
        assert all(0<=p<1024 for p in journal) and all(0<=p<1024 for p in deleted)
        assert all(0<=p<1024 for p in resource_changes) and all(0<=p<1024 for p in resource_deleted)
        h=self.heap;node_changes={};res_changes={}
        for page in deleted:
            self.c['page_entries_examined']+=1
            if page in self.current_pages:
                old,_=self.current_pages.pop(page);h.release(old);node_changes[page]=None
        for page,(data,rows) in journal.items():
            self.c['page_entries_examined']+=1;assert 0<rows<=32
            old=self.current_pages.get(page);value=h.alloc(data);self.current_pages[page]=(value,rows);node_changes[page]=(value,rows)
            if old:h.release(old[0])
        for key in resource_deleted:
            self.c['resource_entries_examined']+=1
            if key in self.current_resources:h.release(self.current_resources.pop(key)[0]);res_changes[key]=None
        for key,data in resource_changes.items():
            self.c['resource_entries_examined']+=1
            value=h.alloc(data);old=self.current_resources.get(key);self.current_resources[key]=(value,len(data));res_changes[key]=(value,len(data))
            if old:h.release(old[0])
        # Switching between tiny raw and radix is explicitly O(current pages),
        # and is charged. Steady-state raw/raw and radix/radix avoid that scan.
        if raw:
            assert len(self.current_pages)==1 and first//32 in self.current_pages
            if not self.raw:self.nodes.close();self.c['mode_switch_pages_examined']+=len(self.current_pages)
            pointer,raw_count=self.current_pages[first//32]
            assert count==raw_count
        else:
            if self.raw:
                node_changes=self.current_pages.copy();self.c['mode_switch_pages_examined']+=len(self.current_pages)
            pointer=self.nodes.update(node_changes);assert pointer is not None;raw_count=0
        resources=self.resources.update(res_changes)
        self.raw=raw;self.sequence+=1
        # Exactly16 words; damage/current authority are submission arguments.
        words=[pointer[0],resources[0] if resources else 0,count,slots,first,int(raw),self.sequence,self.namespace,clear,raw_count,len(self.current_resources),64,64,spatial_root[0] if spatial_root else 0,0,0]
        children=((pointer,resources) if resources else (pointer,))+((spatial_root,) if spatial_root else ())
        root=h.alloc(pack(words),children);self.c['fixed_root_bytes_written']+=64
        if self.eligible:h.release(self.eligible.root)
        self.eligible=Version(self.namespace,self.sequence,root);self.eligible_complete=False
        return self.eligible
    def record(self):
        result=dict(publication=dict(self.c),node_directory=self.nodes.reset_counts(),resource_directory=self.resources.reset_counts(),heap=self.heap.ledger())
        self.c.clear();return result
    def close(self):
        assert not self.submitted
        if self.visible:self.heap.release(self.visible.root);self.visible=None
        if self.eligible:self.heap.release(self.eligible.root);self.eligible=None
        self.nodes.close();self.resources.close()
        for h,_ in self.current_pages.values():self.heap.release(h)
        for h,_ in self.current_resources.values():self.heap.release(h)
        self.current_pages={};self.current_resources={};assert not self.heap.live

def lookup(heap,root,key):
    if not root:return (0,0)
    root_data=heap.get(root).data;leaf=struct.unpack_from('<I',root_data,key//32*4)[0]
    if not leaf:return (0,0)
    a=heap.live[leaf];return struct.unpack_from('<II',a.data,key%32*8)
