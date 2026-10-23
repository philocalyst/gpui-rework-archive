from pathlib import Path
import gzip,hashlib,json,shutil,subprocess
root=Path('/root/gpui-monotonic-caret-borrowed');out=root/'reactivity/evidence/monotonic-caret-stream/final-borrowed';out.mkdir(parents=True,exist_ok=True)
base='1d5bc3061cce3beb3c4857102ed651da501b5cfd';pin='81bd9e53b7a18161903dad3816d494ed1afdfce3';git=['git','-c',f'safe.directory={root}','-C',str(root)];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def put(name,data):
 dest=out/name;dest.parent.mkdir(parents=True,exist_ok=True)
 with gzip.GzipFile(filename=str(dest),mode='wb',mtime=0) as f:f.write(data)
m=json.loads(Path('/tmp/gpui-monotonic-final-release-metadata.json').read_text());assert m['source']==pin;assert sha(Path(m['binary']))==m['sha256'];assert all(sha(root/n)==h for n,h in m['guard'].items())
for prefix in ['gpui-monotonic-final-','gpui-monotonic-public-final-']:
 for p in Path('/tmp').glob(prefix+'*'):
  if p.is_file() and p.suffix in {'.json','.log','.diff','.txt','.asm'}:put(p.name+'.gz',p.read_bytes())
for name in ['gpui-monotonic-shipping-input-closure.json','gpui-monotonic-baseline-vendor-strict.log','gpui-monotonic-borrowed-vendor-strict.log']:
 put(name+'.gz',Path('/tmp',name).read_bytes())
put('public-transcript.bin.gz',Path('/tmp/gpui-monotonic-public-final.bin').read_bytes())
fixture=Path('/tmp/gpui-monotonic-public-borrowed')
for p in fixture.rglob('*'):
 if p.is_file():
  dest=out/'public'/p.relative_to(fixture);dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,dest)
for name in ['freeze-monotonic-final.py','inspect-monotonic-final.py','capture-monotonic-public-final.py','archive-monotonic-final.py']:
 dest=out/'capture'/name;dest.parent.mkdir(exist_ok=True);shutil.copy2(Path('/tmp',name),dest)
source=subprocess.check_output(git+['diff','--binary',base,pin,'--','reactivity/crates','reactivity/vendor']);put('source.patch.gz',source)
support=subprocess.check_output(git+['diff','--binary',base,'98b68895c9','--','reactivity/evidence/monotonic-caret-span']);put('support.patch.gz',support)
repair=subprocess.check_output(git+['diff','--binary','0cbd09c9d7c6f932c1e54ae28296262fb25904b9',pin,'--','reactivity/crates','reactivity/vendor']);put('repair.patch.gz',repair)
(out/'source-bill.json').write_text(json.dumps(dict(base=base,source=pin,source_patch_sha256=hashlib.sha256(source).hexdigest(),source_patch_bytes=len(source),support_patch_sha256=hashlib.sha256(support).hexdigest(),support_patch_bytes=len(support),repair_patch_sha256=hashlib.sha256(repair).hexdigest(),repair_patch_bytes=len(repair),binary_sha256=m['sha256'],guards=len(m['guard'])),indent=2)+'\n')
print(out)
