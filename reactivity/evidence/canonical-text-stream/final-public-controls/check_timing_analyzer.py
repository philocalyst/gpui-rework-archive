from pathlib import Path
import hashlib,json,subprocess,tempfile
base=Path(__file__).parent
reg=json.loads((base/'timing-final-registration.json').read_text())
source=(base/'analyze_final_timing.py').read_bytes()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
results={}
with tempfile.TemporaryDirectory(prefix='canonical-text-SYNTHETIC-gate-') as tmp:
    root=Path(tmp);out=root/'timing-final-capture';out.mkdir()
    (root/'analyze_final_timing.py').write_bytes(source)
    reg['analysis_runner_sha256']=sha(root/'analyze_final_timing.py')
    (root/'timing-final-registration.json').write_text(json.dumps(reg))
    log=out/'SYNTHETIC.log';log.write_text('SYNTHETIC ANALYZER VALIDATION, NO TIMING\n')
    def trial(name,alter,expected):
        records=[]
        for pair in range(11):
            for cell in reg['cells']:
                for label in ['baseline','candidate']:
                    if cell['kind']=='ordinary':value={'elapsed_ns':cell['count']*1000}
                    else:value={'elapsed_ns':[1000]*128,'host_ack_elapsed_ns':[1000]*128,'provider_60hz_budget_exceeded':0,'host_ack_60hz_budget_exceeded':0}
                    alter(pair,cell,label,value)
                    records.append({'pair':pair,'cell_id':cell['id'],'label':label,'raw_output':value,'observable_guard':'PASS','log':str(log),'log_sha256':sha(log)})
        capture={'registration_sha256':sha(root/'timing-final-registration.json'),'status':'complete; SYNTHETIC','observations':records}
        (out/'metadata.json').write_text(json.dumps(capture))
        subprocess.run(['/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3',str(root/'analyze_final_timing.py')],check=True,stdout=subprocess.DEVNULL)
        result=json.loads((out/'analysis.json').read_text())
        assert result['all_independent_gates_pass']==expected,(name,result)
        results[name]={'all_gates_pass':result['all_independent_gates_pass'],'speed_claim':result['speed_claim_gate'],'first_gate':result['cells'][0]['metrics']['elapsed_ns/count']['gate'],'native_budget_gate':result['cells'][60]['metrics']['provider_60hz_budget_exceeded']['gate']}
    trial('exact_equality',lambda *args:None,True)
    def regress(pair,cell,label,value):
        if cell['id']==0 and label=='candidate' and pair<9:value['elapsed_ns']*=1.001
    trial('nine_positive_inside_one_percent_rejected',regress,False)
    def equivalent(pair,cell,label,value):
        if cell['id']==0 and label=='candidate' and pair<8:value['elapsed_ns']*=1.001
    trial('eight_positive_inside_bound_equivalent',equivalent,True)
    def unproven(pair,cell,label,value):
        if cell['id']==0 and label=='candidate' and pair<8:value['elapsed_ns']*=1.02
    trial('eight_positive_outside_bound_unproven',unproven,False)
    def budget(pair,cell,label,value):
        if cell['id']==60 and label=='candidate' and pair<9:value['provider_60hz_budget_exceeded']=1
    trial('native_budget_regression_rejected',budget,False)
(base/'timing-analyzer-selfcheck.json').write_text(json.dumps({'status':'SYNTHETIC analysis gate checks PASS; no measurement/timing','runner_sha256':sha(Path(__file__)),'analysis_sha256':hashlib.sha256(source).hexdigest(),'cases':results},indent=2)+'\n')
print(json.dumps(results,indent=2))
