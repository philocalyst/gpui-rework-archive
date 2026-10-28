"""A only: versioned hot paint with the sealed full traversal unchanged."""
from pathlib import Path
from collections import Counter
import json,tracemalloc,struct,sys
from hot import Hot
from radix_jobs import Series,admit,words,deep_size
class HotSeries(Series):
    def __init__(self,path,draws,mode,target,mutant=False):
        super().__init__(path,draws,mode)
        self.hot=Hot(self.pub.namespace,1);self.mutant=mutant
        color=next(d[4] for d in draws if d[0]==target);self.key=self.hot.register(color,1)
        self.store.set(target,{9:self.key.index,10:5});self.store.commit();self.store.acknowledge()
        self.target=target;self.support=self.store.read(target);self.store.c.clear();self.hot.counts();self.extra=[]
    def epochs(self):
        p=self.pub;seq=set(p.submitted)
        for v in [p.visible,p.eligible]:
            if v is not None:seq.add(v.sequence)
        return [(p.namespace,s) for s in seq]
    def edit(self,color):
        self.hot.update(self.key,color,self.pub.sequence+1,self.epochs(),unsafe_round_robin=self.mutant)
        self.store.damage(self.support,self.support)
        return self.store.commit()
    def frame(self,*args,**kwargs):
        hotwrites=[dict(offset=o,words=words(b),payload_bytes=len(b)) for o,b in self.hot.drain()]
        counts=self.hot.counts();super().frame(*args,**kwargs)
        # Candidate hot publication adds one aligned eight-byte staged write.
        frame=self.frames[-1];frame['hot_writes']=hotwrites
        row=self.records[-1];row['hot']=self.hot.ledger();row['hot_work']=counts;row['hot_binding_support_wire_bytes']=16
        row['upload_padded']+=sum(len(w['words'])*4 for w in hotwrites);row['upload_requested']+=sum(w['payload_bytes'] for w in hotwrites)
        row['candidate_python_reachable_bytes']=deep_size(self.store,self.pub,self.hot,self.key,self.support)
        expected=self.path/frame['expected'];data=bytearray(expected.read_bytes());page,slot,_=self.store.index[self.target]
        color=self.hot.read(self.key.index,self.pub.eligible.sequence);struct.pack_into('<I',data,((page*32+slot)*12+9)*4,color);expected.write_bytes(data);self.hot.counts()
    def churn_before_deferred(self):
        # Frame3 already captured the newest submitted pixels. Move its deferred
        # oldest actual submission after seven unsubmitted eligible candidates.
        frame=self.frames[-1];deferred=frame['submit_deferred'];assert len(deferred)==1;frame['submit_deferred']=[]
        p=self.pub;s=self.store
        for turn in range(7):
            seq=p.sequence+1;self.hot.update(self.key,0xff000000|seq,seq,self.epochs(),unsafe_round_robin=self.mutant)
            raw=self.mode in ['overlap-raw','serial-uncompressed'] and len(s.pages)==1
            v=p.prepare({},count=len(s.index),slots=s.next_page*32,first=s.first*32,raw=raw);assert not p.submit(v)
            writes=[dict(offset=o,words=words(b+bytes((-len(b))%4)),payload_bytes=len(b)) for o,b in p.heap.drain_writes()]
            hotwrites=[dict(offset=o,words=words(b),payload_bytes=len(b)) for o,b in self.hot.drain()]
            self.frames.append(dict(id=1000+seq,wait_before=[],writes=writes,hot_writes=hotwrites,authority=[seq,p.namespace],publication_only=True,submit_deferred=deferred if turn==6 else []))
            self.extra.append(dict(sequence=seq,publication=p.record(),hot=self.hot.ledger(),hot_work=self.hot.counts(),upload_bytes=sum(w['payload_bytes'] for w in writes+hotwrites)+8,submission_denied=True))
        # Restore operation counters so ordinary follow-up does not inherit the
        # separately itemized unsubmitted candidate work.
        self.previous=Counter(p.heap.c)
    def finish(self):
        report=super().finish();path=self.path/'jobs.json';jobs=json.loads(path.read_text());jobs['hot_capacity_bytes']=48;path.write_text(json.dumps(jobs,separators=(',',':')))
        path=self.path/'ledger.json';ledger=json.loads(path.read_text());ledger['unsubmitted_hot_candidates']=self.extra;ledger['scope']='A only, restricted public binding, unchanged full traversal, six version slots/key; staged memory; no timing or generic production claim';path.write_text(json.dumps(ledger,indent=2))
        report['submitted_frames']=sum(not f.get('publication_only',False) for f in jobs['frames']);report['mutant']=self.mutant;return report

def point(source,out,n,mode,stress=False,mutant=False):
    public,draws=admit(source/str(n));name=f'hot-{n}-{mode}'+('-stress' if stress else '')+('-mutant' if mutant else '')
    series=HotSeries(out/name,draws,mode,public['target']['identity'],mutant)
    for i,event in enumerate([None]+public['events']):
        series.before(i);pixels=(source/str(n)/('initial.rgba' if event is None else event['pixels'])).read_bytes();tracemalloc.start()
        if event is None:change=dict(journal={p:r.data for p,r in series.store.pages.items()},deleted=(),counts=dict(initial_admission_nodes=n),damage=(0,0,64,64))
        else:change=series.edit(event['color']);assert change['counts']['dirty_pages']==0
        series.frame(i,change,pixels,initial=i==0,rejected=event is not None and event['rejected_invalid_request'])
        if stress and i==3:series.churn_before_deferred()
    return series.finish()
def main(source,out):
    out.mkdir();reports=[]
    for n in [1,9,32,256,1024]:
        for mode in ['overlap-compressed','overlap-raw','serial-uncompressed']:reports.append(point(source,out,n,mode))
    reports.append(point(source,out,9,'overlap-compressed',True));reports.append(point(source,out,9,'overlap-compressed',True,True))
    (out/'summary.json').write_text(json.dumps(reports,indent=2));print(json.dumps(reports))
if __name__=='__main__':main(*map(Path,sys.argv[1:]))
