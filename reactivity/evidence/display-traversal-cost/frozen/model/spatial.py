"""B only: conservative tile-to-chunk painter lists. Original record codec.
Point paint skips this index entirely. Structural rebuild costs are deliberate.
"""
import struct
from collections import Counter
from experiment import decode,pack

class Spatial:
    def __init__(self,heap):
        self.heap=heap;self.root=None;self.lists=[[] for _ in range(64)];self.masks={};self.order=[];self.ranks={};self.c=Counter()
    def mask(self,store,page):
        p=store.pages[page];wire=struct.unpack('<'+'I'*(len(p.data)//4),p.data);self.c['encoded_words_copied']+=len(wire)
        self.c['decode_scratch_words_peak']=max(self.c['decode_scratch_words_peak'],len(wire));result=0
        for row in range(p.count):
            l,t,r,b=[decode(wire,row,c) for c in range(5,9)];self.c['bounds_rows_examined']+=1;self.c['bounds_fields_decoded']+=4
            l=min(64,l);t=min(64,t);r=min(64,r);b=min(64,b)
            if l>=r or t>=b:continue
            for y in range(t//8,(b-1)//8+1):
                for x in range(l//8,(r-1)//8+1):result|=1<<(y*8+x);self.c['row_tile_tests']+=1
        return result
    def publish(self,changes):
        if not changes:return self.root
        h=self.heap;roots=list(struct.unpack('<64I',h.get(self.root).data)) if self.root else [0]*64;self.c['root_words_copied']+=64;temporary=[]
        for tile,entries in changes.items():
            old=self.lists[tile];self.c['list_compare_entries_upper_bound']+=len(old)+len(entries)
            if entries==old:continue
            self.lists[tile]=entries
            if entries:
                data=pack([len(entries)]+entries);value=h.alloc(data);temporary.append(value);roots[tile]=value[0];self.c['list_bytes_written']+=len(data);self.c['list_entries_written']+=len(entries)
            else:roots[tile]=0
            self.c['tiles_changed']+=1
        children=tuple((o,h.live[o].generation) for o in roots if o);value=h.alloc(pack(roots),children);self.c['root_bytes_written']+=256
        if self.root:h.release(self.root)
        self.root=value
        for child in temporary:h.release(child)
        return value
    def rebuild(self,store):
        # Explicit full page-order/rank repair and bounds rebuild; never called
        # by a paint update. This first structural policy is intentionally O(N).
        order=[];page=store.first
        while page is not None:
            order.append(page);self.c['order_pages_examined']+=1;page=store.pages[page].next
        assert len(order)==len(store.pages)
        self.order=order;self.ranks={p:i for i,p in enumerate(order)};self.c['rank_entries_written']+=len(order)
        self.masks={p:self.mask(store,p) for p in order};lists=[[] for _ in range(64)]
        for page in order:
            mask=self.masks[page]
            while mask:
                bit=mask&-mask;tile=bit.bit_length()-1;mask^=bit;lists[tile].append(page);self.c['rebuilt_memberships']+=1
        return self.publish(dict(enumerate(lists)))
    def bounds(self,store,pages):
        changes={}
        for page in pages:
            self.c['changed_page_entries_examined']+=1;old=self.masks[page];new=self.mask(store,page);self.masks[page]=new;difference=old^new
            while difference:
                bit=difference&-difference;tile=bit.bit_length()-1;difference^=bit
                if tile not in changes:
                    changes[tile]=self.lists[tile].copy();self.c['list_entries_copied']+=len(changes[tile])
                items=changes[tile]
                if old&bit:
                    for at,value in enumerate(items):
                        self.c['membership_search_entries']+=1
                        if value==page:break
                    else:raise AssertionError('old membership missing')
                    self.c['membership_entries_shifted']+=len(items)-at-1;items.pop(at)
                else:
                    lo=0;hi=len(items)
                    while lo<hi:
                        mid=(lo+hi)//2;self.c['order_comparisons']+=1
                        if self.ranks[items[mid]]<self.ranks[page]:lo=mid+1
                        else:hi=mid
                    self.c['membership_entries_shifted']+=len(items)-lo;items.insert(lo,page)
        return self.publish(changes)
    def counts(self):r=dict(self.c);self.c.clear();return r
    def ledger(self):
        return dict(current_root_bytes=256 if self.root else 0,current_tile_payload_bytes=sum(4+4*len(x) for x in self.lists if x),cpu_membership_wire_bytes=sum(4*len(x) for x in self.lists),cpu_mask_wire_bytes=8*len(self.masks),cpu_order_wire_bytes=4*len(self.order),cpu_rank_key_value_wire_bytes=8*len(self.ranks),tile_memberships=sum(map(len,self.lists)),indexed_pages=len(self.masks))
    def close(self):
        if self.root:self.heap.release(self.root)
        self.root=None;self.lists=[[] for _ in range(64)];self.masks={};self.order=[];self.ranks={}

def entries(heap,root,tile):
    # Diagnostic decode through immutable heap graph, not current CPU list mirror.
    if root is None:return []
    offset=struct.unpack_from('<I',heap.get(root).data,tile*4)[0]
    if not offset:return []
    data=heap.live[offset].data;count=struct.unpack_from('<I',data)[0]
    return list(struct.unpack_from('<'+'I'*count,data,4))
