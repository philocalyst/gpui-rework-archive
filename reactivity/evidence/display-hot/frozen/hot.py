"""Bounded per-binding hot values. GPU transport is staged, never coherent RAM.
Six immutable-for-live-epochs slots; ordinary updates touch exactly one entry.
"""
from dataclasses import dataclass
from collections import Counter
import struct
U32_MAX=0xffffffff
SLOTS=6
@dataclass(frozen=True)
class Key:
    namespace:int
    index:int
    generation:int
@dataclass
class Cell:
    generation:int
    born:int
    versions:list
    retired:int|None=None
class Hot:
    def __init__(self,namespace,capacity):
        assert 0<namespace<U32_MAX and 0<capacity<=32768
        self.namespace=namespace;self.capacity=capacity;self.cells={};self.available=[];self.next_index=0;self.generations={};self.writes=[];self.c=Counter()
    def register(self,value,sequence):
        assert 0<=value<=U32_MAX and 0<sequence<U32_MAX
        if not self.available and self.next_index==self.capacity:raise OverflowError('hot capacity exhausted')
        if self.available:index=self.available.pop()
        else:index=self.next_index;self.next_index+=1
        generation=self.generations.get(index,0)+1;self.generations[index]=generation
        versions=[(sequence,value)]+[(U32_MAX,0)]*(SLOTS-1);self.cells[index]=Cell(generation,sequence,versions)
        self.writes.append((index*SLOTS*8,struct.pack('<12I',*(x for pair in versions for x in pair))));self.c['registered_keys']+=1
        return Key(self.namespace,index,generation)
    def cell(self,key):
        self.c['key_lookups']+=1
        if key.namespace!=self.namespace:raise KeyError('foreign hot namespace')
        cell=self.cells.get(key.index)
        if cell is None or cell.generation!=key.generation or cell.retired is not None:raise KeyError('stale hot binding')
        return cell
    def active(self,epochs):
        result=set()
        for ns,sequence in epochs:
            self.c['authority_entries_examined']+=1
            if ns!=self.namespace:raise KeyError('foreign frame namespace')
            assert 0<sequence<U32_MAX
            result.add(sequence)
        assert len(result)<=5
        return result
    def selected(self,cell,sequence):
        found=None
        for i,(epoch,_) in enumerate(cell.versions):
            self.c['version_entries_examined']+=1
            if epoch<=sequence and (found is None or epoch>cell.versions[found][0]):found=i
        return found
    def update(self,key,value,sequence,epochs,*,unsafe_round_robin=False):
        # Validate before publishing an upload; the private unsafe mutant changes
        # the eviction decision only. No rollback of application source state.
        assert 0<=value<=U32_MAX and 0<sequence<U32_MAX
        cell=self.cell(key);active=self.active(epochs)
        assert all(e<sequence for e in active)
        latest=max((p for p in cell.versions if p[0]!=U32_MAX),key=lambda p:p[0]);self.c['latest_entries_examined']+=SLOTS
        assert sequence>latest[0]
        if latest[1]==value:self.c['same_value_skips']+=1;return None
        protected=set()
        for epoch in active:
            selected=self.selected(cell,epoch)
            if selected is not None:protected.add(selected)
        candidates=[i for i in range(SLOTS) if i not in protected];self.c['victim_entries_examined']+=SLOTS
        assert candidates # at most5 live epochs, at least one unneeded slot.
        index=(sequence-1)%SLOTS if unsafe_round_robin else min(candidates,key=lambda i:cell.versions[i][0] if cell.versions[i][0]!=U32_MAX else -1)
        cell.versions[index]=(sequence,value);data=struct.pack('<II',sequence,value);offset=key.index*SLOTS*8+index*8
        self.writes.append((offset,data));self.c['updated_keys']+=1;self.c['payload_bytes_written']+=8
        return offset,data
    def read(self,index,sequence):
        # Diagnostic semantic lookup. A real shader reads staged words at the
        # same direct index and chooses by frame epoch; no CPU expanded mirror.
        assert 0<sequence<U32_MAX;cell=self.cells[index];selected=self.selected(cell,sequence)
        if selected is None:raise KeyError('binding not born at this epoch')
        return cell.versions[selected][1]
    def retire(self,key,sequence):
        cell=self.cell(key);assert sequence>=cell.born;cell.retired=sequence;self.c['retired_keys']+=1
    def reclaim(self,epochs):
        active=self.active(epochs)
        # Explicit maintenance scan, NOT the ordinary property path. A future
        # intrusive retirement queue can compete if teardown becomes material.
        for index,cell in list(self.cells.items()):
            self.c['retirement_entries_examined']+=1
            if cell.retired is not None and all(epoch>cell.retired for epoch in active):
                del self.cells[index];self.available.append(index);self.c['reclaimed_keys']+=1
    def drain(self):result=self.writes;self.writes=[];return result
    def counts(self):result=dict(self.c);self.c.clear();return result
    def ledger(self):
        return dict(capacity_keys=self.capacity,gpu_capacity_bytes=self.capacity*SLOTS*8,live_keys=len(self.cells),live_version_slots=len(self.cells)*SLOTS,live_payload_bytes=len(self.cells)*SLOTS*8,pending_upload_bytes=sum(len(v) for _,v in self.writes),key_generation_entries=len(self.generations),free_key_entries=len(self.available))
