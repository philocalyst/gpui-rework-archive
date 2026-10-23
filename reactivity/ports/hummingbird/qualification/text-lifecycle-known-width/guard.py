import pathlib,json,hashlib,sys
r=pathlib.Path('/root/gpui-hummingbird-browser-allocation-sol')
e=pathlib.Path('/tmp/gpui-hummingbird-browser-allocation-evidence')
paths=json.loads((e/'same-path-control/candidate-restored-full-source-guard.json').read_text())
actual={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in paths}
f=e/'known-qualification/source-guard.json'
if sys.argv[1]=='create':
 assert not f.exists();f.write_text(json.dumps(actual,indent=2))
else:
 assert actual==json.loads(f.read_text()),'source guard changed'
 print('verified',len(actual),'source paths')
