"""Generate actual byte-consumption jobs from public source edits and real assets.
GPU audit/diagnostic copies are separate from candidate storage operations.
"""
from pathlib import Path
import json,struct,sys
from chunks import Chunks,Publication,verify
from experiment import raster,pack

def main(source,out):
    out.mkdir(parents=True,exist_ok=True);public=json.loads((source/'direct.json').read_text());assets=json.loads((source/'assets.json').read_text());draws=[]
    nodes=public['initial_snapshot']['nodes'];assert len(nodes)==len(public['initial_draws'])
    for node,draw in zip(nodes,public['initial_draws'],strict=True):
        rect=tuple(int(x) for x in draw['rect']);assert list(rect)==draw['rect'];x,y,w,h=node['bounds'];assert x<=rect[0] and y<=rect[1] and x+w>=rect[2] and y+h>=rect[3]
        assert node['transform']==[1.,0.,0.,1.,float(rect[0]),float(rect[1])]
        color=int.from_bytes(bytes(int(c*255) for c in draw['color']),'little')
        draws.append((node['identity'],1,nodes[node['parent']]['identity'] if node['parent'] is not None else None,rect,color,0))
    assert pack(raster(draws))==(source/'initial.rgba').read_bytes()
    target=public['target']['identity'];assert target in {d[0] for d in draws}
    reports=[]
    for mode,raw,mutant in [('serial',False,False),('overlap',False,False),('overlap-raw',True,False),('missing-resource-lease',False,True)]:
        path=out/mode;path.mkdir();store=Chunks(draws,small_raw=raw);current=draws.copy();pub=Publication(resource_leases=not mutant)
        frames=[];records=[];live={};events=[];initial={p:page.data for p,page in store.pages.items()};waits=[]
        all_events=[None]+public['events'];deferred=None
        for frame_id,event in enumerate(all_events):
            # Serial baseline completes before producing the next update. The
            # overlap case queues three, deliberately submitting the oldest last.
            waits=[]
            if mode=='serial' or frame_id%3==0:
                order=list(live)
                if mode!='serial':order=list(reversed(order))
                for old in order:
                    version=live.pop(old);pub.signal(version.sequence);eligible=pub.present(version)
                    events.append(dict(fence=old,eligible_present=eligible,phase='before'));waits.append(old)
                if order:store.acknowledge()
            if event is None:journal=initial;counts=dict(initial_admission_nodes=len(draws));deleted=set()
            else:
                assert event['candidate_snapshot_reads']==event['candidate_draw_enumerations']==0
                assert event['target']==public['target'];store.set(target,{9:event['color']},generation=1);change=store.commit();journal=change['journal'];deleted=change['deleted'];counts=change['counts']
                current=[(i,g,parent,rect,event['color'] if i==target else color,res) for i,g,parent,rect,color,res in current]
                verify(store,current);assert pack(raster(current))==(source/event['pixels']).read_bytes()
                assert counts['identity_lookups']==1 and counts['dirty_pages']<=1
            resources={f"{r['kind']}-{j}":(source/r['file']).read_bytes() for j,r in enumerate(assets['cases'][frame_id%3]['resources'])}
            version=pub.prepare(journal,deleted,resources);assert pub.submit(version);live[frame_id]=version
            # Snapshot only the explicit publication's child ranges for the GPU
            # audit, not a candidate whole-tree geometry snapshot or mirror.
            children=list(pub.current_pages.values())+list(pub.current_resources.values())
            payloads=[pub.heap.get(h).data for h in children];expected=b''.join(payloads);name=f'expected-{frame_id}.bin';(path/name).write_bytes(expected)
            writes=[]
            for offset,data in pub.heap.drain_writes():
                padded=data+bytes((-len(data))%4);writes.append(dict(offset=offset,words=list(struct.unpack('<'+'I'*(len(padded)//4),padded)),payload_bytes=len(data)))
            is_deferred=mode!='serial' and frame_id%3==0 and frame_id+1<len(all_events)
            if is_deferred:deferred=frame_id
            submit=[]
            if deferred is not None and (frame_id%3==2 or frame_id==len(all_events)-1):submit=[deferred];deferred=None
            frames.append(dict(id=frame_id,wait_before=waits,writes=writes,root=version.root[0],lengths=[len(p) for p in payloads],expected=name,defer=is_deferred,submit_deferred=submit))
            records.append(dict(frame=frame_id,source_counts=counts,source_oracle_nodes=len(current),candidate_initial_snapshot_reads=1 if event is None else 0,resource_payload_bytes=sum(map(len,resources.values())),heap=pub.heap.ledger(),store=store.ledger(),padded_upload_bytes=sum(len(w['words'])*4 for w in writes),requested_upload_bytes=sum(w['payload_bytes'] for w in writes),authority_sequence=version.sequence))
        end=list(reversed(live))
        for old in end:
            version=live.pop(old);pub.signal(version.sequence);events.append(dict(fence=old,eligible_present=pub.present(version),phase='end'))
        high=pub.heap.end;pub.close()
        script=dict(arena_bytes=high,frames=frames,end_waits=end)
        (path/'jobs.json').write_text(json.dumps(script,separators=(',',':')))
        (path/'ledger.json').write_text(json.dumps(dict(mode=mode,mutant=mutant,frames=records,authority=events,all_allocations_released=not pub.heap.live,scope='real resource-byte audit; public fixture direct paint binding; flat publication directory; no combined native renderer or shared-memory claim'),indent=2))
        reports.append(dict(mode=mode,frames=len(frames),arena_bytes=high,mutant=mutant))
    (out/'summary.json').write_text(json.dumps(reports,indent=2));print(json.dumps(reports))
if __name__=='__main__':main(Path(sys.argv[1]),Path(sys.argv[2]))
