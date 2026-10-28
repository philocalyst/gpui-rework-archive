from pathlib import Path
import gzip,hashlib,json,statistics,tarfile
root=Path(__file__).parent
def sha(data):return hashlib.sha256(data).hexdigest()
original=json.loads((root/'original-files.json').read_text())
with tarfile.open(root/'raw-observations.tar.gz','r:gz') as archive:
 raw={entry.name:archive.extractfile(entry).read() for entry in archive.getmembers() if entry.isfile()}
assert len(raw)==438
for name,expected in original.items():
 if name.startswith('pair'):data=raw[name]
 elif name.endswith('.asm'):data=gzip.decompress((root/(name+'.gz')).read_bytes())
 else:data=(root/name).read_bytes()
 assert len(data)==expected['bytes'] and sha(data)==expected['sha256'],name
capture=json.loads((root/'capture.json').read_text())
assert capture['status']=='incomplete' and len(capture['rows'])==219 and len(capture['pairs'])==109
assert sha((root/'registration.json').read_bytes())==capture['registration_sha256']
assert sha((root/'build-metadata.json').read_bytes())==capture['build_metadata_sha256']
assert sha((root/'capture.py').read_bytes())==capture['capture_runner_sha256']
for row in capture['rows']:
 name=f'pair{row["pair"]}-{row["case"]}-{row["lane"]}-{row["variant"]}'
 observed=json.loads(raw[name+'.stdout'])
 assert not raw[name+'.stderr']
 assert all(row[k]==v for k,v in observed.items())
for pair in capture['pairs']:
 rows={r['variant']:r for r in capture['rows'] if all(r[k]==pair[k] for k in ['pair','case','lane'])}
 assert len(rows)==2
 assert pair['candidate_over_baseline']==rows['candidate']['nanoseconds']/rows['baseline']['nanoseconds']
summary=json.loads((root/'partial-summary.json').read_text())
for cell in summary['cells']:
 ratios=[p['candidate_over_baseline'] for p in capture['pairs'] if p['case']==cell['case'] and p['lane']==cell['lane']]
 assert ratios==cell['ratios'] and len(ratios)==cell['complete_pairs']
 assert statistics.median(ratios)==cell['median_candidate_over_baseline']
 assert cell['qualification_gate']==(('pass' if statistics.median(ratios)<=1.03 else 'fail') if len(ratios)==7 else 'incomplete')
failed=next(c for c in summary['cells'] if c['case']=='origin32k' and c['lane']=='update')
assert failed['complete_pairs']==7 and failed['qualification_gate']=='fail'
build=json.loads((root/'build-metadata.json').read_text())
for original_path,expected in build['fixture'].items():
 relative=Path(original_path).relative_to('/tmp/gpui-text-column-public-control')
 assert sha((root/'fixture'/relative).read_bytes())==expected
assert not summary['qualification_pass'] and not summary['speed_claim']
print(json.dumps({'archive_original_files_verified':len(original),'raw_observation_streams_verified':len(raw),'completed_observations_verified':len(capture['rows']),'complete_pairs_verified':len(capture['pairs']),'frozen_fixture_files_verified':len(build['fixture']),'campaign_status':'incomplete','independent_complete_cell_gate':'origin32k update FAIL'},indent=2))
