from pathlib import Path
import hashlib, json, shutil, subprocess, tarfile
root=Path('/root/gpui-ce3')
out=root/'reactivity/evidence/uniform-packet/coverage-setup'
archive=Path('/tmp/gpui-coverage-setup-qualified.tar.gz')
manifest=Path('/tmp/gpui-coverage-setup-capture-manifest.json')
evidence=Path('/tmp/gpui-coverage-setup-evidence')
def sha(p):
 with p.open('rb') as stream:return hashlib.file_digest(stream,'sha256').hexdigest()
assert sha(archive)=='f6456b0a971a492cfc38087e71062bf620f69575589e71a07fba484b2e17a620'
assert sha(manifest)=='f72aff1b7da9805fc18cccd1fb08e2c2f6200e65aacda481437aac2956decc6a'
data=json.loads(manifest.read_text())
assert data['source']=='6158d25e483dea439832399e768ff4fbe1202640'
expected={entry['member']:entry for entry in data['payload_members']}
assert len(expected)==len(data['payload_members'])==446
seen=set(); total=0
with tarfile.open(archive,'r|gz') as stream:
 for member in stream:
  assert member.isfile() and member.name not in seen, member.name
  seen.add(member.name)
  file=stream.extractfile(member)
  h=hashlib.sha256(); size=0
  while block:=file.read(1024*1024):size+=len(block);h.update(block)
  if member.name=='capture-manifest.json':
   assert size==manifest.stat().st_size and h.hexdigest()==sha(manifest)
  else:
   entry=expected[member.name]
   assert size==entry['bytes'] and h.hexdigest()==entry['sha256'], member.name
   total+=size
assert seen==set(expected)|{'capture-manifest.json'}
for entry in data['external_elf']:
 p=Path(entry['source_path'])
 assert p.stat().st_size==entry['bytes'] and sha(p)==entry['sha256'], str(p)
head=subprocess.check_output(['git','-c','safe.directory=/tmp/gpui-coverage-setup-sol','-C','/tmp/gpui-coverage-setup-sol','rev-parse','HEAD'],text=True).strip()
assert head==data['source']
assert not subprocess.check_output(['git','-c','safe.directory=/tmp/gpui-coverage-setup-sol','-C','/tmp/gpui-coverage-setup-sol','status','--porcelain'],text=True).strip()
out.mkdir(parents=True,exist_ok=False)
shutil.copy2(archive,out/'captures.tar.gz')
assert sha(out/'captures.tar.gz')==sha(archive)
shutil.copy2(manifest,out/'capture-manifest.json')
for name in ['README.md','cost-ledger.json','rounded-tree-proof.md','legacy-abi-feasibility.md','summary.json','sealed-functional-summary.json','sealed-negative-control.json','unchanged-authority.json']:
 shutil.copy2(evidence/name,out/name)
report={'source':head,'archive_sha256':sha(archive),'archive_bytes':archive.stat().st_size,'payload_members':len(expected),'payload_bytes':total,'external_elf_verified':len(data['external_elf']),'every_archive_member_independently_stream_hashed':True,'producer_tree_clean':True,'production_source_adopted':False,'scope':'Strict-IEEE correctness, exact readbacks and static costs only; no new timing, hardware runtime, RSS or startup claim.'}
(out/'root-verification.json').write_text(json.dumps(report,indent=2)+'\n')
(out/'ROOT-REVIEW.md').write_text('''# Root review of the borrowed whole-bounds coverage experiment

Root independently verified all 446 payloads, the embedded manifest and all ten externally retained ELF artifacts before copying this archive. The sealed worktree is clean at `6158d25e483dea439832399e768ff4fbe1202640`; no production source is adopted by this evidence update.

The certificate encloses the actual rounded arithmetic tree and borrows each PreparedDraw, avoiding the earlier setup memcpy. It assumes strict Rust IEEE arithmetic. The failed DAZ/FTZ guard attempt and its extra code cost remain archived; it did not establish correctness under externally altered floating-point modes.

Against its exact uniform-packet baseline `a81bc7536b002b1f81e1b36137c1c4de543e2204`, this successor adds152 non-test noncomment core lines and4,176 linked text bytes. Its binning frame grows32 bytes. The whole helper and axis helper are charged separately in the complete symbol/frame ledger. These are branch-local counts, not the current main tree's totals or a measured memory saving.

All52 named public SDR/HDR images and diagnostics match that frozen baseline. The false-certificate control reaches a real pixel assertion, fails, then passes after exact restoration. Default/fallback/offline and installed Apple ARM64/MSVC source compile gates are recorded; foreign runtime and hardware GPUs were not executed.

This correctness result does not supersede the failed11-pair uniform-packet campaign. A separate legacy-packet formulation is being qualified to discard the planes, codec and residency machinery while retaining coverage elimination. It needs its own fixed timing campaign before any performance-based adoption.
''')
print(json.dumps(report,indent=2))
