import hashlib,json,pathlib,subprocess,sys,tempfile
root=pathlib.Path('/tmp/gpui-mapped-properties-sol')
sys.path.insert(0,str(root/'reactivity/tools'))
import inventory,core_lines
path='reactivity/crates/inline-call/src/lib.rs'
data=(root/path).read_bytes()
helper=pathlib.Path('/tmp/gpui-inventory-sol-target/release/inventory-rust')
tokei=pathlib.Path('/tmp/gpui-qualified-tokei-root/bin/tokei')
analysis=inventory.rust_analysis([(path,data,'Rust')],helper)[path]
stripped=core_lines.without_tests(data.decode(),analysis['test_ranges'])
with tempfile.TemporaryDirectory() as tmp:
 p=pathlib.Path(tmp)/'lib.rs';p.write_text(stripped)
 raw=json.loads(subprocess.check_output([str(tokei),'--no-ignore','--files','--output','json',str(p)],text=True))
 code=raw['Rust']['reports'][0]['stats']['code']
result={'path':path,'source_sha256':hashlib.sha256(data).hexdigest(),'core_non_test_noncomment_code_lines':code,'physical_lines':len(data.splitlines()),'build_scripts':[],'build_script_code_lines':0,'method':'existing inventory-rust test ranges; core_lines.without_tests; qualified Tokei own-file stats, same shipping six-library policy','rust_helper_sha256':hashlib.sha256(helper.read_bytes()).hexdigest(),'tokei_sha256':hashlib.sha256(tokei.read_bytes()).hexdigest(),'test_ranges':analysis['test_ranges']}
(root.parent/'gpui-mapped-properties-sol-evidence/helper-core-lines.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k not in ['test_ranges']}))
