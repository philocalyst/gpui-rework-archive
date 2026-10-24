from pathlib import Path
import hashlib,json,fontTools
from fontTools import subset
from fontTools.ttLib import TTFont
root=Path('/tmp/gpui-ime-font-sources');out=root/'fixtures-v2';out.mkdir()
records=[]
for name,codepoints,pin,url,license in [
 ('cjk',set(range(0x20,0x7f))|{0xe9,0x306b,0x65e5,0x672c,0x8a9e,0x4f60,0x597d},'f8d157532fbfaeda587e826d4cd5b21a49186f7c','https://github.com/notofonts/noto-cjk/blob/f8d157532fbfaeda587e826d4cd5b21a49186f7c/Sans/OTF/Japanese/NotoSansCJKjp-Regular.otf','CJK-OFL.txt'),
 ('emoji',{0x20,0x200d,0xfe0f,0x1f469,0x1f4bb,0x1f3fd},'e7db6ca603fd4862010383ff17ffd6cc4ffac1c0','https://github.com/google/fonts/blob/e7db6ca603fd4862010383ff17ffd6cc4ffac1c0/ofl/notoemoji/NotoEmoji%5Bwght%5D.ttf','Emoji-OFL.txt')]:
 source=root/('NotoSansCJKjp-Regular.otf' if name=='cjk' else 'NotoEmoji.ttf');font=TTFont(source,recalcTimestamp=False)
 options=subset.Options();options.layout_features=['*'];options.name_IDs=['*'];options.name_legacy=True;options.name_languages=['*'];options.notdef_outline=True;options.recalc_timestamp=False
 tool=subset.Subsetter(options);tool.populate(unicodes=codepoints);tool.subset(font)
 # Identify these modified test-only fixtures clearly, independent of RFN scope.
 for record in font['name'].names:
  if record.nameID in [1,2,3,4,6,16,17]:
   value='GPUI IME '+name+' fixture' if record.nameID!=6 else 'GPUIIME'+name+'Fixture'
   record.string=value.encode(record.getEncoding(),errors='replace')
 destination=out/(name+('.otf' if name=='cjk' else '.ttf'));font.save(destination,reorderTables=True)
 (out/license).write_bytes((root/license).read_bytes())
 parsed=TTFont(destination);records.append({'name':name,'source':url,'upstream_commit':pin,'source_bytes':source.stat().st_size,'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'fixture':destination.name,'fixture_bytes':destination.stat().st_size,'fixture_sha256':hashlib.sha256(destination.read_bytes()).hexdigest(),'unicode_subset':[hex(n) for n in sorted(codepoints)],'glyphs':len(parsed.getGlyphOrder()),'tables':list(parsed.keys()),'license':license,'license_sha256':hashlib.sha256((out/license).read_bytes()).hexdigest()})
(out/'provenance.json').write_text(json.dumps({'fonttools_version':fontTools.__version__,'subsets':records,'scope':'Modified genuine upstream outline fonts for public IME tests; not a shipping font fallback bundle. All layout features and dependency glyph closure retained. Names identify modified fixtures.'},indent=2)+'\n');print(json.dumps(records),flush=True)
