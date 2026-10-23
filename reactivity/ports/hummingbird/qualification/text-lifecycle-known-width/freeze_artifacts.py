import pathlib,json,hashlib,shutil,sys
build_log=pathlib.Path(sys.argv[1]);destination=pathlib.Path(sys.argv[2]);destination.mkdir(exist_ok=False)
wanted={'gpui_reactivity_core','gpui_canvas','gpui_reactivity_state','gpui_reactivity_host','gpui_gpu','gpui','hummingbird_gpui_port','authority-constructor-bill','native_service'}
result={}
for line in build_log.read_text().splitlines():
    try: message=json.loads(line)
    except json.JSONDecodeError:continue
    if message.get('reason')!='compiler-artifact' or message['target']['name'] not in wanted:continue
    paths=[pathlib.Path(p) for p in message['filenames'] if p.endswith('.rlib')]
    if message.get('executable'):paths.append(pathlib.Path(message['executable']))
    for path in paths:
        assert path.name not in result
        shutil.copy2(path,destination/path.name)
        if message.get('executable')==str(path):(destination/path.name).chmod(0o555)
        result[path.name]={'original':str(path),'sha256':hashlib.file_digest(path.open('rb'),'sha256').hexdigest(),'features':message['features'],'profile':message['profile'],'package':message['package_id'],'target':message['target']['name']}
assert result
(destination.with_suffix('.json')).write_text(json.dumps(result,indent=2))
print(json.dumps(result,indent=2))
