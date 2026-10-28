"""Independent immutable-history oracle for bounded hot-slot lifetime."""
from pathlib import Path
import json,random,struct,sys
from hot import Hot,Key,SLOTS,U32_MAX

def main(path):
    path.mkdir();checks=0;rows=[];rng=random.Random(20261030)
    # One old visible root, three submitted roots and a repeatedly replaced
    # unsubmitted eligible root: five semantic authorities, not just queue depth.
    h=Hot(7,1);key=h.register(0,1);history={1:0};h.drain();held=[1]
    for seq in range(2,5):
        h.update(key,seq,seq,[(7,e) for e in held]);h.drain();history[seq]=seq;held.append(seq)
    current=4
    for seq in range(5,1005):
        value=rng.getrandbits(32);active=held+([current] if current not in held else [])
        update=h.update(key,value,seq,[(7,e) for e in active]);assert update is not None and len(update[1])==8
        h.drain();history[seq]=value
        for epoch in held+[seq]:
            assert h.read(key.index,epoch)==history[max(x for x in history if x<=epoch)];checks+=1
        current=seq
        if seq in [5,104,1004]:rows.append(dict(sequence=seq,ledger=h.ledger(),counts=h.counts()))
    assert len({x['ledger']['live_payload_bytes'] for x in rows})==1
    # Once semantic/fence authorities disappear, versions may be recycled.
    for seq in range(1005,1105):
        active=[current];h.update(key,seq,seq,[(7,e) for e in active]);h.drain();current=seq;assert h.read(key.index,seq)==seq;checks+=1
    before=list(h.cells[key.index].versions);assert h.update(key,current,current+1,[(7,current)]) is None
    assert h.cells[key.index].versions==before and h.drain()==[];checks+=1
    for badseq in [current,0,U32_MAX]:
        try:h.update(key,1,badseq,[(7,current)])
        except AssertionError:checks+=1
        else:raise AssertionError('invalid epoch admitted')
    try:h.update(Key(8,key.index,key.generation),1,current+1,[(7,current)])
    except KeyError:checks+=1
    else:raise AssertionError('foreign binding admitted')
    try:h.update(key,1,current+1,[(8,current)])
    except KeyError:checks+=1
    else:raise AssertionError('foreign frame admitted')
    assert h.cells[key.index].versions==before and h.drain()==[]
    # Retiring a binding while an old cold root can still address it cannot make
    # the key available for another identity, even if the GPU finished newer work.
    h.retire(key,current);h.reclaim([(7,1),(7,current+1)])
    try:h.register(9,current+1)
    except OverflowError:checks+=1
    else:raise AssertionError('old key reused while a live old root exists')
    h.reclaim([(7,current+1)]);replacement=h.register(9,current+1);h.drain()
    assert replacement.index==key.index and replacement.generation!=key.generation
    try:h.update(key,3,current+2,[(7,current+1)])
    except KeyError:checks+=1
    else:raise AssertionError('stale source binding revived')
    assert h.read(replacement.index,current+1)==9;checks+=1
    # Direct shader-style byte shadow is independent from Python's Cell.read.
    for n in [1,9,32,256,1024]:
        table=Hot(100+n,n);keys=[table.register(rng.getrandbits(32),1) for _ in range(n)];shadow=bytearray(n*SLOTS*8)
        def flush():
            for offset,data in table.drain():shadow[offset:offset+len(data)]=data
        flush();expected=[table.cells[k.index].versions[0][1] for k in keys]
        for seq in range(2,66):
            target=(seq*7919)%n;value=rng.getrandbits(32);table.update(keys[target],value,seq,[(table.namespace,seq-1)]);flush();expected[target]=value
            for i in [target,(target+1)%n]:
                pairs=[struct.unpack_from('<II',shadow,i*SLOTS*8+j*8) for j in range(SLOTS)];actual=max((p for p in pairs if p[0]<=seq),key=lambda p:p[0])[1];assert actual==expected[i];checks+=1
        rows.append(dict(dense_keys=n,ledger=table.ledger(),counts=table.counts()))
    # Round-robin is insufficient: an arbitrarily old visible/submitted value
    # must survive newer unsubmitted candidates. Pixel stale suppression alone
    # would not observe this discarded semantic history.
    mutant=Hot(3,1);key=mutant.register(123,1);mutant.drain();found=None
    for seq in range(2,15):
        mutant.update(key,seq,seq,[(3,1),(3,seq-1)],unsafe_round_robin=True);mutant.drain()
        try:old=mutant.read(key.index,1)
        except KeyError:found=seq;break
        if old!=123:found=seq;break
    assert found is not None
    (path/'checks.json').write_text(json.dumps(dict(checks=checks,rows=rows,round_robin_mutant_failed_at=found,scope='CPU hot-slot lifetime only; actual Vulkan integration and timing still pending'),indent=2));print(checks,found)
if __name__=='__main__':main(Path(sys.argv[1]))
