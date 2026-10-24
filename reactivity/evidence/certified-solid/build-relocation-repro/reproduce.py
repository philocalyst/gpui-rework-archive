from pathlib import Path
import json,os,subprocess,time
root=Path(__file__).parent
cargo='/tmp/gpui-nightly-2026-10-23/bin/cargo'
manifest='[workspace]\nmembers = ["crates/probe"]\nresolver = "3"\n'
package='[package]\nname="gpui_relocation_probe"\nversion="0.1.0"\nedition="2024"\n'
main='fn main() { println!("{}", include_str!(concat!(env!("OUT_DIR"), "/shader.txt"))); }\n'
build='#[path="src/shader.rs"] mod shader;\nfn main() {\n    println!("cargo::rerun-if-changed=src");\n    let out = std::path::PathBuf::from(std::env::var_os("OUT_DIR").unwrap());\n    std::fs::write(out.join("shader.txt"), shader::SOURCE).unwrap();\n}\n'
rows=[]
for variant,source in [('relative',build),('manifest_env',build.replace('println!("cargo::rerun-if-changed=src");','println!("cargo::rerun-if-changed={}/src", env!("CARGO_MANIFEST_DIR"));'))]:
    for name,value in [('a','A'),('b','B')]:
        base=root/variant/name;crate=base/'crates/probe';(crate/'src').mkdir(parents=True,exist_ok=True)
        files={base/'Cargo.toml':manifest,crate/'Cargo.toml':package,crate/'build.rs':source,crate/'src/main.rs':main,crate/'src/shader.rs':f'pub const SOURCE: &str = "{value}";\n'}
        for path,text in files.items():path.write_text(text);os.utime(path,(1_700_000_000,1_700_000_000))
    for name,expected in [('a','A'),('b','B')]:
        base=root/variant/name;env=os.environ.copy();env.update(CARGO_TARGET_DIR=str(root/variant/'target'),CARGO_BUILD_JOBS='1')
        argv=[cargo,'run','--offline','--manifest-path',str(base/'Cargo.toml'),'--message-format=json']
        result=subprocess.run(argv,cwd=base,env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=60)
        (root/f'{variant}-{name}.stdout').write_text(result.stdout);(root/f'{variant}-{name}.stderr').write_text(result.stderr)
        assert result.returncode==0,result.stderr
        output=result.stdout.splitlines()[-1];artifacts=[json.loads(line) for line in result.stdout.splitlines() if line.startswith('{')]
        row={'variant':variant,'tree':name,'expected':expected,'actual':output,'source_mtime':1_700_000_000,'argv':argv,'build_script_artifacts':[j for j in artifacts if j.get('reason')=='compiler-artifact' and 'custom-build' in j['target']['kind']]};rows.append(row);print(json.dumps({k:v for k,v in row.items() if k!='build_script_artifacts'}),flush=True)
(root/'result.json').write_text(json.dumps({'rows':rows,'scope':'Standalone Cargo 1.101-nightly path-relocation/mtime build-script reproducer; no renderer timing.'},indent=2)+'\n')
