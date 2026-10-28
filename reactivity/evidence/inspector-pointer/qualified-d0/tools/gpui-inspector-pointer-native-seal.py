from pathlib import Path
import subprocess,hashlib,json,os
out=Path('/tmp/gpui-inspector-pointer-final-qualification');meta=json.loads((out/'broad-before.json').read_text());files=meta['files'];h=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest();assert all(h(Path(k))==v for k,v in files.items())
for name in ['/tmp/gpui-inspector-pointer-native-client-v2.py','/tmp/gpui-inspector-pointer-native-client-v3.py','/tmp/gpui-inspector-pointer-native-frozen']:
 files[name]=h(Path(name))
args=['dbus-run-session','--','/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3','/tmp/gpui-inspector-pointer-native-client-v3.py','/tmp/gpui-inspector-pointer-native-frozen','--output',str(out/'public-native-sealed.json'),'--display',':171','--xvfb','/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb','--xdotool','/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool','--atspi-launcher','/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher']
record={'source':meta['source'],'files':files,'argv':args};(out/'native-seal-before.json').write_text(json.dumps(record,indent=2)+'\n')
with(out/'public-native-sealed.log').open('w')as log:code=subprocess.call(args,stdout=log,stderr=subprocess.STDOUT)
record['exit']=code;after={k:h(Path(k)) for k in files};record['unchanged']=after==files;(out/'native-seal-after.json').write_text(json.dumps(after,indent=2)+'\n');(out/'native-seal-metadata.json').write_text(json.dumps(record,indent=2)+'\n');assert code==0;assert record['unchanged'];print(json.dumps({'source':meta['source'],'passed':True,'guarded_files':len(files)}))
