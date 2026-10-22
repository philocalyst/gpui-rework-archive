from pathlib import Path
import hashlib,json
base=Path('/root/gpui-designer-gamut/reactivity/crates/canvas/src');lib=(base/'lib.rs').read_text();a=lib.index('#[derive(Clone, Debug, PartialEq, Eq)]\npub enum Error');b=lib.index('\nimpl std::fmt::Display for Error',a);error=lib[a:b];canvas=(base/'canvas.rs').read_text();a=canvas.index('pub(crate) trait PixelWriter');b=canvas.index('\n}',a)+2;trait=canvas[a:b]
for label,path in [('fixed','/root/gpui-designer-gamut'),('lattice','/root/gpui-gamut-lattice'),('adaptive','/root/gpui-gamut-adaptive')]:
 p=Path('/tmp/gpui-gamut-count-'+label);(p/'src/color').mkdir(parents=True,exist_ok=True);src=Path(path)/'reactivity/crates/canvas/src';color=(src/'color.rs').read_text();gamut=(src/'color/gamut.rs').read_text();pins={str(src/f):hashlib.sha256((src/f).read_bytes()).hexdigest() for f in ['color.rs','color/gamut.rs']}
 (p/'source-pins.json').write_text(json.dumps(pins,indent=2)+'\n')
 (p/'Cargo.toml').write_text('[package]\nname="gamut_count"\nversion="0.1.0"\nedition="2024"\n[features]\ndefault=["simd"]\nsimd=[]\n[dependencies]\nfearless_simd={version="=1.1.0",features=["force_support_fallback"]}\nfearless_simd_macros="=0.1.0"\n')
 (p/'src/lib.rs').write_text(error+'\nmod color;\npub use color::*;\nmod canvas {\n'+trait+'\n}\npub fn take_count()->usize { color::gamut::EVALUATIONS.with(|n|n.replace(0)) }\n')
 (p/'src/color.rs').write_text(color.replace('mod gamut;', 'pub(crate) mod gamut;',1))
 marker='    fn evaluate(self, t: f64x4<S>) -> f64x4<S> {'
 assert marker in gamut
 gamut=gamut.replace(marker,marker+'\n        EVALUATIONS.with(|n| n.set(n.get()+1));',1)
 gamut='std::thread_local! { pub(crate) static EVALUATIONS: std::cell::Cell<usize> = const { std::cell::Cell::new(0) }; }\n'+gamut.replace('//! Designer unit-cube limits, separate from output mapping and composition.','// Instrumented diagnostic copy: only Polynomial.evaluate counts are used.')
 (p/'src/color/gamut.rs').write_text(gamut)
 main=Path('/tmp/gpui-gamut-lattice-parity-old/src/main.rs').read_text().replace('use gpui_canvas::OutputProfile;','use gamut_count::OutputProfile;').replace('''    println!("{kind},{index},{profile:?},{},{},{}",l.to_bits(),h.to_bits(),cap.to_bits());''','''    let evaluations=gamut_count::take_count();
    println!("{kind},{index},{profile:?},{},{},{},{}",l.to_bits(),h.to_bits(),cap.to_bits(),evaluations);''').replace('kind,index,profile,L_bits,h_bits,cap_bits','kind,index,profile,L_bits,h_bits,cap_bits,evaluations')
 (p/'src/main.rs').write_text(main)
