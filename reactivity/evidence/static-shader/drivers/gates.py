"""Qualify one committed source with owned build outputs and per-gate guards."""
from pathlib import Path
import hashlib,json,os,shlex,shutil,subprocess,sys
ROOT=Path(__file__).resolve().parents[4]
WORK=ROOT/'reactivity'
OUT=WORK/'evidence/static-shader/checks'
OUT.mkdir(exist_ok=True)
SOURCE='a871fc6fa924f31bf08fe2a51248930025582da1'
GIT=['git','-C',str(ROOT)]
def sha(path): return hashlib.sha256(path.read_bytes()).hexdigest()
assert subprocess.check_output(GIT+['rev-parse','HEAD'],text=True).strip()==SOURCE
paths=subprocess.check_output(GIT+['ls-files','reactivity/crates','reactivity/vendor','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/.cargo','reactivity/benchmarks/gpu-owner','reactivity/evidence/static-shader'],text=True).splitlines()
def guard():
    result={name:sha(ROOT/name) for name in paths}
    return result
assert not subprocess.check_output(GIT+['diff','--name-only','--',*paths],text=True).strip()
before=guard()
source_path=OUT/'source.json'
if source_path.exists(): assert json.loads(source_path.read_text())['files']==before
else: source_path.write_text(json.dumps({'source':SOURCE,'files':before},indent=2)+'\n')
ENV='source /tmp/gpui-native-env.sh\nexport CARGO_BUILD_JOBS=2 CARGO_TARGET_DIR=/tmp/gpui-static-shader-sol-target GPUI_SPIRV_VAL=/nix/store/z5hs3p3inrq3w8cv71jycz7l4y3ny5xk-spirv-tools-1.4.363.0/bin/spirv-val MESA_SHADER_CACHE_DISABLE=true\n'
results_path=OUT/'results.json'
results=json.loads(results_path.read_text()) if results_path.exists() else {'source':SOURCE,'checks':[]}
def run(name,args,json_output=False,extra=''):
    assert guard()==before
    log=OUT/(name+'.log')
    output=OUT/(name+'.jsonl') if json_output else log
    print(json.dumps({'starting':name,'source':SOURCE}),flush=True)
    command=ENV+extra+'\nexec '+shlex.join(args)
    with output.open('w') as stdout:
        if json_output:
            with log.open('w') as stderr: result=subprocess.run(['bash','-c',command],cwd=WORK,stdout=stdout,stderr=stderr)
        else: result=subprocess.run(['bash','-c',command],cwd=WORK,stdout=stdout,stderr=subprocess.STDOUT)
    record={'name':name,'command':args,'environment_shell':extra,'exit':result.returncode,'log_sha256':sha(log)}
    if json_output: record['json_sha256']=sha(output)
    (OUT/(name+'-result.json')).write_text(json.dumps(record,indent=2)+'\n')
    results['checks'].append(record);results_path.write_text(json.dumps(results,indent=2)+'\n')
    assert guard()==before
    print(json.dumps(record),flush=True)
    assert result.returncode==0,name
    return output
mode=sys.argv[1]
if mode in ['optional','default']:
    features='vulkan-tests,offline-shader' if mode=='optional' else 'vulkan-tests'
    path=run(mode+'-build',['cargo','test','--offline','--locked','--release','-p','gpui_gpu','--all-targets','--features',features,'--no-run','--message-format=json'],True)
    rows=[json.loads(s) for s in path.read_text().splitlines() if s.startswith('{')]
    copied={}
    BIN=Path('/tmp/gpui-static-frozen-bins')/mode
    BIN.mkdir(parents=True,exist_ok=True)
    for name in ['gpui_gpu','presentation','render']:
        matches=[row for row in rows if row.get('reason')=='compiler-artifact' and row['target']['name']==name and row.get('executable')]
        assert len(matches)==1,(name,len(matches))
        original=Path(matches[0]['executable']);binary=BIN/name
        shutil.copyfile(original,binary);binary.chmod(0o755)
        copied[name]={'source':str(original),'copy':str(binary),'sha256':sha(binary)}
        run(mode+'-'+name,[str(binary),'--nocapture','--test-threads=1'])
        assert sha(binary)==copied[name]['sha256']
    (OUT/(mode+'-executables.json')).write_text(json.dumps(copied,indent=2)+'\n')
elif mode in ['clippy-optional','clippy-default']:
    features='vulkan-tests,offline-shader' if mode.endswith('optional') else 'vulkan-tests'
    run(mode,['cargo','clippy','--offline','--locked','--release','-p','gpui_gpu','--all-targets','--features',features,'--','-D','warnings'])
elif mode in ['apple','msvc']:
    target='aarch64-apple-darwin' if mode=='apple' else 'x86_64-pc-windows-msvc'
    run(mode,['cargo','check','--offline','--locked','-p','gpui','--all-targets','--features','desktop,gpui_canvas/parallel,gpui_gpu/offline-shader','--target',target,'-Zbuild-std=std,panic_abort'],extra='export RUSTC_BOOTSTRAP=1\n')
elif mode=='fixture':
    run('fixture-build',['cargo','build','--offline','--locked','--manifest-path','benchmarks/gpu-owner/Cargo.toml','--bin','static-lifetime','--features','offline-shader,trace,noop','--message-format=json'],True)
    run('fixture-clippy',['cargo','clippy','--offline','--locked','--manifest-path','benchmarks/gpu-owner/Cargo.toml','--bin','static-lifetime','--features','offline-shader,trace,noop','--','-D','warnings'])
elif mode in ['owners-optional','owners-default']:
    features=['--features','offline-shader,counts'] if mode.endswith('optional') else ['--features','counts']
    path=run(mode+'-build',['cargo','build','--offline','--locked','--release','--manifest-path','benchmarks/gpu-owner/Cargo.toml','--bin','first','--bin','driver-retained','--message-format=json']+features,True)
    rows=[json.loads(s) for s in path.read_text().splitlines() if s.startswith('{')]
    BIN=Path('/tmp/gpui-static-frozen-bins')/mode;BIN.mkdir(parents=True,exist_ok=True)
    copied={}
    for name in ['first','driver-retained']:
        matches=[r for r in rows if r.get('reason')=='compiler-artifact' and r['target']['name']==name and r.get('executable')]
        assert len(matches)==1
        original=Path(matches[0]['executable']);binary=BIN/name;shutil.copyfile(original,binary);binary.chmod(0o755)
        copied[name]={'source':str(original),'copy':str(binary),'sha256':sha(binary)}
    for case in ['context','renderer']:
        run(mode+'-'+case,[str(BIN/'first'),case])
    if mode.endswith('optional'): run('owners-optional-fallback',[str(BIN/'first'),'renderer','no-feature'])
    for name,item in copied.items(): assert sha(BIN/name)==item['sha256']
    (OUT/(mode+'-executables.json')).write_text(json.dumps(copied,indent=2)+'\n')
else: raise ValueError(mode)
(OUT/(mode+'-source-unchanged.txt')).write_text(SOURCE+'\n')
