"""Independent directory paths, exact entropy, old versions and storage controls."""
import json,struct,random,sys
from pathlib import Path
from chunks import Chunks
from experiment import Tree,pack,decode
from radix import RadixPublication,lookup

def get(heap,version,page):
    root=heap.get(version.root).data;pointer,_,count,slots,first,raw=struct.unpack_from('<6I',root)
    if raw:return pointer,struct.unpack_from('<I',root,36)[0]
    root_handle=(pointer,heap.live[pointer].generation)
    return lookup(heap,root_handle,page)
def main(out):
    rng=random.Random(20261030);reports=[];checks=0
    # Point publication has a fixed path, regardless of unrelated resource size.
    for entries in [0,1,32,256,1024]:
        p=RadixPublication();data=pack([0]+[0]*384)
        v=p.prepare({0:(data,32)},resource_changes={i:pack([i])*4 for i in range(entries)},count=32,slots=32,first=0)
        p.heap.drain_writes();p.record();p.submit(v);p.signal(v.sequence);p.present(v)
        for turn in range(50):
            old=v;v=p.prepare({0:(data,32)},count=32,slots=32,first=0);rec=p.record();p.heap.drain_writes();p.submit(v)
            assert rec['publication'].get('resource_entries_examined',0)==0
            assert rec['resource_directory']=={} and rec['node_directory']['entries_examined']==1
            assert rec['node_directory']['root_words_copied']==32 and rec['node_directory']['leaf_words_copied']==64
            assert p.heap.get(old.root).data[4:8]==p.heap.get(v.root).data[4:8]
            p.signal(v.sequence);assert p.present(v);checks+=1
        reports.append(dict(resources=entries,point=rec,heap=p.heap.ledger()));p.close()
    # Bounded directory key boundary and shared old roots survive updates/deletes.
    p=RadixPublication();current={0:b'A'*128,31:b'B'*128,32:b'C'*128,1023:b'D'*128};saved=[]
    for turn in range(3):
        journal={key:(value,1) for key,value in current.items()};v=p.prepare(journal,count=4,slots=32768,first=0);p.heap.drain_writes();p.submit(v);saved.append((v,current.copy()))
        current={k:bytes([ord('E')+turn])*128 for k in current}
    v=p.prepare({31:(b'Z'*128,1)},deleted=[32],count=3,slots=32768,first=0);p.heap.drain_writes();assert not p.submit(v)
    for old,values in saved:
        for key,value in values.items():offset,count=get(p.heap,old,key);assert count==1 and p.heap.live[offset].data==value;checks+=1
    assert get(p.heap,v,32)==(0,0)
    for old,_ in reversed(saved):p.signal(old.sequence);assert not p.present(old)
    assert p.submit(v);p.signal(v.sequence);assert p.present(v);p.close()
    # Tiny raw bypass removes both directory allocations; exact high entropy.
    for n in [1,9,32,256,1024]:
        for fallback in [False,True]:
            s=Chunks(Tree(n,False).draws(),small_raw=fallback);values={}
            for identity in s.index:
                values[identity]={c:rng.getrandbits(32) for c in [5,6,7,8,9,11]};s.set(identity,values[identity])
            s.commit();p=RadixPublication();raw=fallback and n<=32
            v=p.prepare({k:(page.data,page.count) for k,page in s.pages.items()},count=n,slots=s.next_page*32,first=s.first*32,raw=raw)
            for identity,(page,slot,_) in s.index.items():
                offset,count=get(p.heap,v,page);assert slot<count;encoded=p.heap.live[offset].data;wire=struct.unpack('<'+'I'*(len(encoded)//4),encoded)
                assert all(decode(wire,slot,c)==value for c,value in values[identity].items());checks+=1
            assert (p.nodes.root is None)==raw
            reports.append(dict(n=n,fallback=fallback,high_entropy=True,store=s.ledger(),publication=p.record()));p.heap.drain_writes();p.close()
    # Sustained fixed edit churn: graph + free lists/generation metadata bounded.
    p=RadixPublication();samples=[]
    for turn in range(1000):
        v=p.prepare({0:(bytes([turn%256])*564,32)},resource_changes={3:bytes([turn%256])*264,7:bytes([turn%256])*132},count=32,slots=32,first=0)
        p.heap.drain_writes();p.submit(v);p.signal(v.sequence);p.present(v)
        if turn in [9,99,999]:samples.append(p.heap.ledger())
    assert len({x['arena_high_water'] for x in samples})==1
    assert len({x['slot_generation_entries'] for x in samples})==1
    p.close();checks+=1000
    out.mkdir();(out/'checks.json').write_text(json.dumps(dict(checks=checks,rows=reports,churn=samples,all_released=not p.heap.live),indent=2));print(checks)
if __name__=='__main__':main(Path(sys.argv[1]))
