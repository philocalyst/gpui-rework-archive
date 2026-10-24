#!/usr/bin/env python3
"""Actual native MyGo negative controls; run separately from performance capture."""
import argparse,fcntl,json,sys,traceback
from pathlib import Path
import run as campaign


def main():
    p=argparse.ArgumentParser(description=__doc__)
    for key in ('manifest','output','lease','historical-archive'):p.add_argument('--'+key,type=Path,required=True)
    args=p.parse_args()
    if args.output.exists() and any(args.output.iterdir()):p.error('output directory must be empty')
    manifest=json.loads(args.manifest.read_text());campaign.mandatory_historical_audit(args.historical_archive)
    app=manifest['apps']['mygo'];campaign.core.EXPECTED_WINDOW_TITLES['mygo']=app['title']
    campaign.core.XDOTOOL=manifest['xdotool'];args.output.mkdir(parents=True,exist_ok=True)
    original=campaign.core.wait_first_present
    campaign.core.wait_first_present=lambda child,timeout=90:original(child,10)
    cases=[('positive','busy',{}),('duplicate-ticks','animation',{'TODO_TEST_DUPLICATE_TICKS':'1'}),('hover-only-suppressed-callback','busy',{'TODO_TEST_SUPPRESS_COMPLETE':'1','TODO_TEST_HOVER_ONLY':'1'}),('stale-marker','busy',{'TODO_TEST_STALE_MARKER':'1'}),('observer-overflow','busy',{'TODO_TEST_OBSERVER_CAP':'1'}),('term-handled-zero','idle',{'TODO_TEST_TERM_HANDLED_ZERO':'1'}),('missing-present','idle',{'TODO_TEST_SUPPRESS_PRESENT':'1'})]
    results=[]
    with args.lease.open('a+') as lease:
        fcntl.flock(lease,fcntl.LOCK_EX|fcntl.LOCK_NB)
        if campaign.active_builds():raise RuntimeError('fault qualification requires all builds reaped')
        frozen=campaign.fingerprint(manifest)
        receipt=json.loads(Path(app['build_receipt']).read_text())
        if not receipt.get('successful') or receipt['source_after']!=frozen['mygo']['source'] or receipt['binary_sha256']!=frozen['mygo']['binary']:raise RuntimeError('stale MyGo build receipt')
        for name,mode,fault in cases:
            out=args.output/name;out.mkdir();a={**app,'environment':{**app.get('environment',{}),**fault}}
            try:
                row=campaign.run_cell('mygo',a,mode,1,out,2,0)
                row['source_and_binary_unchanged']=campaign.fingerprint(manifest)==frozen
                row['accepted']=campaign.accepted(row)
            except Exception as error:row={'variant':'mygo','mode':mode,'accepted':False,'error':repr(error),'traceback':traceback.format_exc()}
            gates={
                'positive':row.get('accepted') is True,
                'duplicate-ticks':row.get('animation_count_matches_lifetime') is False and row.get('animation_ticks',0)>row.get('animation_expected_ticks_from_lifetime',0)+row.get('animation_tick_tolerance',0),
                'hover-only-suppressed-callback':row.get('ordered_callbacks_matched') is False and row.get('drawable_work_acknowledged') is False,
                'stale-marker':row.get('full_model_matched') is True and row.get('ordered_callbacks_matched') is True and row.get('drawable_work_acknowledged') is False,
                'observer-overflow':row.get('full_model_matched') is True and row.get('present_observer_overflow',0)>0,
                'term-handled-zero':row.get('close_escalated') is True and row.get('graceful_close') is False and row.get('child_exit_code')==0,
                'missing-present':'first successful present marker not observed' in row.get('error',''),
            }
            passed=gates[name] and (name=='positive' or row['accepted'] is False)
            row.update(control=name,fault_environment=fault,control_passed=passed,performance_eligible=False)
            (out/'result.json').write_text(json.dumps(row,indent=2)+'\n')
            results.append({'control':name,'passed':passed,'accepted':row['accepted'],'result':str(out/'result.json')});print(json.dumps(results[-1]),flush=True)
        summary={'all_controls_passed':all(r['passed'] for r in results),'frozen_inputs':frozen,'controls':results,'performance_data_reused':False}
        (args.output/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    return 0 if summary['all_controls_passed'] else 1

if __name__=='__main__':raise SystemExit(main())
