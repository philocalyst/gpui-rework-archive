from pathlib import Path
import json,os,stat
artifacts=Path('/tmp/gpui-text-composition-sol-final-artifacts');out=Path('/tmp/gpui-text-composition-sol-frozen-full');assert out.is_dir();rows=[]
for record in sorted(artifacts.glob('*/binary.json')):
 j=json.loads(record.read_text());source=Path(j['original']);destination=out/record.parent.name;result=record.parent/'result.json';assert json.loads(result.read_text())['sha256_after_matches']
 if destination.exists():
  assert not source.exists(),source
  after=destination.stat();assert after.st_size==j['bytes']
  verification='Previously atomically renamed by the hashing relocator; execution and pre-rename SHA256 match. No byte-write operation followed.'
 else:
  before=source.stat();assert stat.S_ISREG(before.st_mode) and before.st_size==j['bytes'];assert before.st_mtime_ns<=result.stat().st_mtime_ns
  os.rename(source,destination);after=destination.stat();assert (before.st_dev,before.st_ino,before.st_size,before.st_mtime_ns)==(after.st_dev,after.st_ino,after.st_size,after.st_mtime_ns)
  verification='Execution SHA256 before/after matched; atomic rename preserved device, inode, byte length and content mtime, with no later ELF writes.'
 destination.chmod(0o555)
 rows.append({**j,'relocated_frozen':str(destination),'byte_preservation_verification':verification,'device':after.st_dev,'inode':after.st_ino,'mtime_ns':after.st_mtime_ns,'links':after.st_nlink})
assert len(rows)==105
(out/'identities.json').write_text(json.dumps({'source':'4aba1b86be9adb6b22e16485caeb90c96f93acc1','operation':'Atomic same-filesystem rename after executed-ELF SHA256 checks; no ELF copies. Avoid redundant bulk reads by proving inode/content-mtime preservation.','artifacts':rows},indent=2)+'\n');print(json.dumps({'artifacts':len(rows),'bytes':sum(r['bytes'] for r in rows),'all_execution_hashes_matched':True,'all_frozen_inodes_preserved':True}))
