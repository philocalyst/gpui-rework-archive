import hashlib,json,pathlib,subprocess,sys
root=pathlib.Path(sys.argv[2] if len(sys.argv)>2 else '/tmp/gpui-mapped-properties-sol')
files=sorted(set(subprocess.check_output(['git','-c','safe.directory='+str(root),'-C',str(root),'ls-files','--cached','--others','--exclude-standard'],text=True).splitlines()))
rows={p:hashlib.sha256((root/p).read_bytes()).hexdigest() for p in files if p.startswith('reactivity/') and (root/p).is_file()}
result={'scope':'all tracked/unignored files under reactivity; target ignored','sha256':hashlib.sha256(json.dumps(rows,sort_keys=True).encode()).hexdigest(),'files':rows}
path=pathlib.Path(sys.argv[1]);path.write_text(json.dumps(result,indent=2)+'\n');print(result['sha256'],len(rows))
