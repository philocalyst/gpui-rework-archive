from pathlib import Path
import sys,subprocess,shutil
w=Path(sys.argv[1]);r=Path(__file__).parent;assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
g=w/'reactivity/crates/gpui/src';p=g/'native/text_cost.rs';assert not p.exists();shutil.copy2(r/'text_cost.draft.rs',p)
p=g/'native/scroll_bench.rs';s=p.read_text();a='fn run(gpu: &mut GpuSurface) {\n    let case = std::env::var("GPUI_SCROLL_CASE").expect("explicit case");';assert a in s;s=s.replace(a,'''#[path = "text_cost.rs"]
mod text_cost;
fn run(gpu: &mut GpuSurface) {
    let case = std::env::var("GPUI_SCROLL_CASE").expect("explicit case");
    if let Some(options) = text_cost::Options::parse(&case) {
        return text_cost::run(gpu, &case, options);
    }''',1);p.write_text(s)
p=g/'runtime.rs';s=p.read_text();assert 'mod damage_header_ledger' not in s;s+='''
#[cfg(test)]
mod damage_header_ledger {
    use super::*;
    #[test]
    fn runtime_damage_headers() {
        eprintln!("DAMAGE_HEADERS,RuntimeUnit={},Prepared={},TextPatch={},TextResources={}",
            size_of::<Runtime<()>>(),size_of::<Prepared>(),size_of::<text_geometry::TextPatch>(),size_of::<text_geometry::TextResources>());
        #[cfg(feature = "native-core")]
        eprintln!("DAMAGE_NATIVE_HEADERS,SceneDamage={}",size_of::<paint::SceneDamage>());
    }
}
''';p.write_text(s)
p=w/'reactivity/crates/gpu/src/renderer/retained.rs';s=p.read_text();assert 'mod damage_header_ledger' not in s;s+='''
#[cfg(test)]
mod damage_header_ledger {
    use super::*;
    #[test]
    fn retained_damage_headers() {
        eprintln!("DAMAGE_GPU_HEADERS,Output={},Backing={},RetainedRenderer={},Renderer={}",
            size_of::<Output<'_>>(),size_of::<Backing>(),size_of::<RetainedRenderer>(),size_of::<Renderer>());
    }
}
''';p.write_text(s)
files=[g/'native/text_cost.rs',g/'native/scroll_bench.rs',g/'runtime.rs',p]
subprocess.run(['rustfmt','+nightly-2026-10-23','--edition','2024','--config','skip_children=true',*[str(f) for f in files]],check=True)
subprocess.run(['git','add','reactivity/crates'],cwd=w,check=True);subprocess.run(['git','commit','-qm','test: add identical complete small-text cost and storage ledgers'],cwd=w,check=True)
print(w,subprocess.check_output(['git','rev-parse','HEAD'],cwd=w).decode().strip())
