"""Measured registered binding patch -> resident GPU completion -> owner ack.
No diagnostic ledger walk, oracle render, or whole scene is inside steady state.
"""
from pathlib import Path
import json,os,subprocess,sys,time,resource,atexit
from chunks import Chunks
from radix import RadixPublication
from radix_jobs import Uncompressed,admit,words,deep_size
from hot import Hot

class Owner:
    def __init__(self,draws,target,role,n):
        self.hot_role=role=='hot';self.raw=role=='raw' or n<=9
        self.store=(Uncompressed if self.raw else Chunks)(draws);self.pub=RadixPublication();self.target=target;self.hot=None;self.key=None;self.support=None
        if self.hot_role:
            self.hot=Hot(self.pub.namespace,1);color=next(d[4] for d in draws if d[0]==target);self.key=self.hot.register(color,1)
            self.store.set(target,{9:self.key.index,10:5});self.store.commit();self.support=self.store.read(target);self.store.c.clear();self.hot.counts()
        self.store.acknowledge();self.version=None;self.capacity=None
    def publish(self,change,initial=False):
        s=self.store;p=self.pub
        self.version=p.prepare({page:(data,s.pages[page].count) for page,data in change['journal'].items()},change['deleted'],count=len(s.index),slots=s.next_page*32,first=s.first*32,raw=self.raw and len(s.pages)==1)
        assert p.submit(self.version)
        if self.capacity is not None:assert p.heap.end<=self.capacity,'fixed arena reserve exceeded'
        return dict(op='frame',writes=[dict(offset=o,words=words(b+bytes((-len(b))%4))) for o,b in p.heap.drain_writes()],hot_writes=[dict(offset=o,words=words(b)) for o,b in self.hot.drain()] if self.hot else [],args=[self.version.root[0],*( (0,0,64,64) if initial else change['damage']),0,0],authority=[self.version.sequence,p.namespace])
    def initial(self):
        s=self.store;result=self.publish(dict(journal={p:r.data for p,r in s.pages.items()},deleted=(),damage=(0,0,64,64)),True);self.capacity=self.pub.heap.end+8192;return result
    def patch(self,color):
        if self.hot:
            epochs=set(self.pub.submitted)
            for v in [self.pub.visible,self.pub.eligible]:
                if v:epochs.add(v.sequence)
            self.hot.update(self.key,color,self.pub.sequence+1,[(self.pub.namespace,e) for e in epochs]);self.store.damage(self.support,self.support)
        else:self.store.set(self.target,{9:color},generation=1)
        return self.publish(self.store.commit())
    def complete(self):
        self.pub.signal(self.version.sequence);assert self.pub.present(self.version);self.store.acknowledge()
    def ledger(self):
        return dict(store=self.store.ledger(),heap=self.pub.heap.ledger(),hot=self.hot.ledger() if self.hot else None,reachable_python_bytes=deep_size(self.store,self.pub,self.hot,self.key,self.support),arena_capacity_bytes=self.capacity)

def main(worker,source,role,output,mode):
    output.mkdir();public,draws=admit(source);n=len(draws);target=public['target']['identity']
    def now():return time.perf_counter_ns()
    event_log=(output/'events.jsonl').open('w',buffering=1);phase='cold'
    cold_start=now();owner=Owner(draws,target,role,n);initial=owner.initial()
    with (output/'worker.err').open('wb') as err:
        process=subprocess.Popen([str(worker)],stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=err,text=True,bufsize=1)
        def reap():
            if not process.stdin.closed:process.stdin.close()
            if process.poll() is None:
                try:process.wait(timeout=30)
                except subprocess.TimeoutExpired:process.kill();process.wait()
        atexit.register(reap)
        def rpc(message):
            encoded=json.dumps(message,separators=(',',':'));process.stdin.write(encoded+'\n');process.stdin.flush();line=process.stdout.readline()
            assert line,f'GPU worker exited {process.poll()}'
            return json.loads(line)
        ready=rpc(dict(op='init',arena_bytes=owner.capacity,hot_bytes=48 if owner.hot else 4,hot=owner.hot_role));assert ready['ready']
        initial_result=rpc(initial);assert initial_result['complete'];owner.complete();cold_ns=now()-cold_start
        assert rpc(dict(op='verify',expected=str(source/'initial.rgba')))['exact']
        preflight=[];samples=[];warmups=[]
        colors=[0xffffffff,0xff0000ff,0xffff0000,0xff000000]
        def iteration(color):
            start=now();message=owner.patch(color);prepared=now();encoded=json.dumps(message,separators=(',',':'));serialized=now();process.stdin.write(encoded+'\n');process.stdin.flush();line=process.stdout.readline();assert line,f'worker exit {process.poll()}'
            response=json.loads(line);received=now();assert response['complete'];owner.complete();done=now()
            row=dict(round_trip_ns=done-start,preparation_ns=prepared-start,serialization_ns=serialized-prepared,transport_response_ns=received-serialized,owner_ack_ns=done-received,request_utf8_bytes=len(encoded)+1,**response)
            event_log.write(json.dumps(dict(phase=phase,**row),separators=(',',':'))+'\n');return row
        if mode=='preflight':
            phase='preflight'
            for i,event in enumerate(public['events']):
                row=iteration(event['color']);assert rpc(dict(op='verify',expected=str(source/event['pixels'])))['exact'];preflight.append(row)
        else:
            assert mode=='timing'
            phase='warmup'
            for i in range(64):warmups.append(iteration(colors[i%4]))
            assert rpc(dict(op='verify',expected=str(source/'paint-3.rgba')))['exact']
            phase='timing'
            for i in range(512):samples.append(iteration(colors[i%4]))
            assert rpc(dict(op='verify',expected=str(source/'paint-3.rgba')))['exact']
        # All walks, RSS queries and logs are outside the timed sample intervals.
        event_log.close();ledger=owner.ledger();assert rpc(dict(op='close'))['closed'];process.stdin.close();process.stdout.close();assert process.wait()==0;owner.pub.close()
    result=dict(role=role,n=n,mode=mode,source=str(source),cold_ns=cold_ns,initial=initial_result,ready=ready,preflight=preflight,warmups=warmups,samples=samples,ledger=ledger,owner_maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,worker_maxrss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,all_fenced_heap_allocations_released=not owner.pub.heap.live,endpoint='registered prototype binding patch through Python preparation/JSON/IPC, actual Vulkan staging/completion, reply and owner acknowledgement; excludes public View/Source dispatch, diagnostic full renderer and scanout')
    (output/'result.json').write_text(json.dumps(result,indent=2));print(role,n,mode,len(samples),flush=True)
if __name__=='__main__':main(Path(sys.argv[1]),Path(sys.argv[2]),sys.argv[3],Path(sys.argv[4]),sys.argv[5])
