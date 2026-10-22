from pathlib import Path
import json,shutil,hashlib,sys
kind,log=sys.argv[1:]; cap=Path('/tmp/gpui-cephal-single-captures'); records=[]
for line in Path(log).read_text().splitlines():
 try:a=json.loads(line)
 except ValueError:continue
 if a.get('reason')!='compiler-artifact':continue
 if a['target']['name'] in ['gpui_reactivity_core','gpui','gpui_cephal_oof_public','gpui-cephal-oof-public','gpui-cephal-oof-driver','unicode_text_measure','gpui-cephal-single-ledger']:
  records.append(a)
  for f in a['filenames']:
   p=Path(f)
   if p.suffix=='.rlib':shutil.copyfile(p,cap/(kind+'-'+p.name))
 if a.get('executable'):
  names={'public':'public-single-owner','core':'single-core-driver','owner':'single-owner','ledger':'single-ledger'}
  shutil.copyfile(a['executable'],cap/names[kind]); (cap/names[kind]).chmod(Path(a['executable']).stat().st_mode)
(cap/(kind+'-build-controls.json')).write_text(json.dumps(records,indent=2)+'\n')
