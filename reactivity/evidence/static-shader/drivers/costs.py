"""Count authored code separately from the exact published Core import."""
from pathlib import Path
import hashlib,importlib.util,json,subprocess,sys,tarfile,tempfile
ROOT=Path(__file__).resolve().parents[4]
OUT=ROOT/'reactivity/evidence/static-shader'
BASE='4a5bf18ec3'
SOURCE='a871fc6fa924f31bf08fe2a51248930025582da1'
HELPER=Path('/tmp/gpui-inventory-sol-target/release/inventory-rust')
TOKEI=Path('/nix/store/4m90mv0fyihsdrnidw8gkgmx6zvd5vqm-tokei-15.0.0/bin/tokei')
def git(*args): return subprocess.check_output(['git','-C',str(ROOT),*args])
def digest(path): return {'bytes':path.stat().st_size,'sha256':hashlib.sha256(path.read_bytes()).hexdigest()}
for name in ['inventory','core_lines']:
    spec=importlib.util.spec_from_file_location(name,ROOT/f'reactivity/tools/{name}.py')
    module=importlib.util.module_from_spec(spec);sys.modules[name]=module;spec.loader.exec_module(module)
inventory=sys.modules['inventory'];core=sys.modules['core_lines']
paths=git('diff','--name-only',BASE,SOURCE,'--','reactivity/vendor','reactivity/crates/gpu').decode().splitlines()
paths=[p for p in paths if p.endswith('.rs')]
report={}
for label,ref in [('baseline',BASE),('static',SOURCE)]:
    files=[(path,git('show',f'{ref}:{path}'),'Rust') for path in paths]
    syntax=inventory.rust_analysis(files,HELPER)
    with tempfile.TemporaryDirectory(prefix='gpui-static-lines-') as temp:
        staging=Path(temp);per_file={}
        for path,data,_ in files:
            dest=staging/path;dest.parent.mkdir(parents=True,exist_ok=True)
            dest.write_text(core.without_tests(data.decode(),syntax[path]['test_ranges']))
            per_file[path]={'physical':len(data.splitlines()),'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest(),'unclassified':syntax[path]['unclassified']}
        count=json.loads(subprocess.check_output([str(TOKEI),'--no-ignore','--files','--output','json',str(staging)]))
        for row in count['Rust']['reports']:
            path=Path(row['name']).relative_to(staging).as_posix()
            per_file[path]['non_test_comment_free_code']=row['stats']['code']
    report[label]={'source':git('rev-parse',ref).decode().strip(),'files':per_file}
deltas={path:report['static']['files'][path]['non_test_comment_free_code']-report['baseline']['files'][path]['non_test_comment_free_code'] for path in paths}
report['authored_static_delta']={'per_file':deltas,'gpu':sum(v for p,v in deltas.items() if '/crates/gpu/' in p),'vendor':sum(v for p,v in deltas.items() if '/vendor/' in p),'total':sum(deltas.values()),'scope':'All changed shipping Rust files, comments/blanks/Syn test syntax excluded. Manifest/provenance, test fixture/layer/generator/data separately retained. One upstream compatibility replacement has zero net lines, not zero authored change.'}
archive=Path('/root/.cargo/registry/cache/index.crates.io-1949cf8c6b5b557f/wgpu-core-30.0.1.crate')
with tarfile.open(archive) as package:
    members=[m for m in package.getmembers() if m.isfile()]
    published={m.name.split('/',1)[1]:package.extractfile(m).read() for m in members}
    report['published_core_import']={'commit':'c27929d153','archive':digest(archive),'files':len(published),'bytes':sum(map(len,published.values())),'physical_lines_all_text_except_nonutf8':sum(len(v.splitlines()) for v in published.values() if b'\0' not in v),'rust_physical_lines':sum(len(v.splitlines()) for p,v in published.items() if p.endswith('.rs')),'note':'This upstream package is charged independently of authored deltas and was formerly a registry dependency. UPSTREAM.json adds a per-published-file hash record.'}
report['independent_root_raii_delta']={'commit':'4a5bf18ec3','upstream_root_commit':'ffb4b8f58035330f4034a6891ec87de6574195c0','non_test_comment_free_code_delta':-36,'note':'Exact device.rs ownership patch; source policy query from the optional branch is preserved.'}
report['tools']={'inventory':digest(HELPER),'tokei':digest(TOKEI)}
(OUT/'code-lines.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report['authored_static_delta'],indent=2))
