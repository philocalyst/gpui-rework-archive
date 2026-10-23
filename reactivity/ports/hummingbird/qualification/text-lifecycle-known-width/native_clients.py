import pathlib,sys,subprocess,json,hashlib
root=pathlib.Path('/root/gpui-hummingbird-browser-allocation-sol')
out=pathlib.Path('/tmp/gpui-hummingbird-browser-allocation-evidence/known-qualification')
python='/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3'
binary=out/'native-artifacts/native_service'
manifest=json.loads((out/'native-artifacts.json').read_text())
expected=manifest['native_service']['sha256']

def guard():
    subprocess.run([python,str(out/'guard.py'),'verify'],check=True)
    assert hashlib.file_digest(binary.open('rb'),'sha256').hexdigest()==expected

results=[]
for name,extra in [('default',[]),('collections',['--collections'])]:
    destination=out/('native-client-'+name)
    assert not destination.exists()
    for suffix in ['.command.json','.log','.exit','-after.json']:
        assert not (out/('native-client-'+name+suffix)).exists()
    command=['timeout','--signal=TERM','--kill-after=5s','180s','dbus-run-session','--',python,str(root/'reactivity/ports/hummingbird/native-service.py'),str(binary),str(destination),*extra]
    guard()
    record={'command':command,'binary_sha256':expected}
    (out/('native-client-'+name+'.command.json')).write_text(json.dumps(record,indent=2))
    try:
        with (out/('native-client-'+name+'.log')).open('wb') as log:
            completed=subprocess.run(command,cwd=root/'reactivity/ports/hummingbird',stdout=log,stderr=subprocess.STDOUT)
        record['exit']=completed.returncode
        (out/('native-client-'+name+'.exit')).write_text(str(completed.returncode)+'\n')
    finally:
        guard()
        (out/('native-client-'+name+'-after.json')).write_text(json.dumps({'binary_sha256':hashlib.file_digest(binary.open('rb'),'sha256').hexdigest(),'source_guard':'matched'},indent=2))
    results.append(record)
(out/'native-clients-summary.json').write_text(json.dumps(results,indent=2))
assert all(row['exit']==0 for row in results)
