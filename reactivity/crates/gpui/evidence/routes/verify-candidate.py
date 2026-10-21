from pathlib import Path
import hashlib,json,re,subprocess,time

ROOT=Path('/root/gpui-pan-viewports')
OUT=ROOT/'reactivity/crates/gpui/evidence/routes'
OUT.mkdir(parents=True,exist_ok=True)
report={'source_commit':subprocess.check_output(['git','-c',f'safe.directory={ROOT}','-C',str(ROOT),'rev-parse','HEAD'],text=True).strip(),'scope':'Dense current routes and reused cold viewport owner, actual Linux X11 Todo/Library and AccessKit schema; prototype source, not integrated main.','checks':[]}
base=['cargo','test','--manifest-path','reactivity/Cargo.toml','--locked','--offline','-p','gpui']
checks=[('owners-native-schema',base+['--features','x11','--tests']),('native-todo',base+['--features','x11','--lib','native_todo_port','--','--ignored','--nocapture']),('native-library',base+['--features','x11','--lib','native_library_250k','--','--ignored','--nocapture']),('clippy',['cargo','clippy','--manifest-path','reactivity/Cargo.toml','--locked','--offline','-p','gpui','--all-targets','--features','x11,wayland','--','-D','warnings']),('fmt',['cargo','fmt','--manifest-path','reactivity/Cargo.toml','-p','gpui','--check'])]
for name,argv in checks:
    print(name,flush=True); start=time.monotonic()
    result=subprocess.run(argv,cwd=ROOT,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    log=OUT/f'{name}.txt'; log.write_text(result.stdout)
    entry=dict(check=name,argv=argv,exit_code=result.returncode,elapsed_seconds=round(time.monotonic()-start,3),log=log.name,log_sha256=hashlib.sha256(log.read_bytes()).hexdigest())
    if name not in ['clippy','fmt']:
        entry['passed_tests']=sum(map(int,re.findall(r'test result: ok\. (\d+) passed;',result.stdout)))
        if not result.returncode and not entry['passed_tests']: entry['exit_code']=1
    report['checks'].append(entry); (OUT/'checks.json').write_text(json.dumps(report,indent=2)+'\n');print(entry,flush=True)
    if entry['exit_code']:
        print(result.stdout[-5000:]);raise SystemExit(1)
