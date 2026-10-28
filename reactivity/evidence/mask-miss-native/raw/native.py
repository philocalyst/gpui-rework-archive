from pathlib import Path
import os,json,hashlib,subprocess,time,signal,re,random,itertools,sys,statistics
R=Path(__file__).parent;NAMES=['baseline','candidate'];MODES=['idle','stream','scroll','both'];HZ=os.sysconf('SC_CLK_TCK');PAGE=os.sysconf('SC_PAGE_SIZE')
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
def artifact(name):
 g=R/json.loads((R/'build-gates.json').read_text())[name];assert json.loads((g/'guard-after.json').read_text())==[]
 aa=json.loads((g/'build-artifacts.json').read_text());assert len(aa)==1;a=aa[0];assert sha(Path(a['preserved']))==a['sha256'];return a

def run(name,mode,seconds,out,initial=0,capture=False,timed=False,route='exact'):
 out.mkdir(parents=True,exist_ok=False);a=artifact(name);(out/'artifact.json').write_text(json.dumps(a,indent=2))
 env={k:v for k,v in os.environ.items() if not k.startswith(('GPUI_','ZGX_'))}
 env.update({'DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','DBUS_SESSION_BUS_ADDRESS':'unix:path=/nonexistent','ZGX_MODE':mode,'ZGX_SECONDS':str(seconds),'ZGX_INITIAL_TICKS':str(initial),'ZGX_FONT_FILE':'/home/user/zgx-native-profile-lab/comparisons/fonts/DejaVuSans.ttf','GPUI_LAB_RENDERER':'gpu','WINIT_UNIX_BACKEND':'x11','WINIT_X11_SCALE_FACTOR':'1'})
 env.pop('WAYLAND_DISPLAY',None)
 env['GPUI_LAB_TRACE']='1'
 if route=='owner':env['GPUI_LAB_INGRESS']='owner'
 (out/'environment.json').write_text(json.dumps({k:v for k,v in env.items() if k.startswith(('GPUI_','ZGX_','WINIT_')) or k in ['DISPLAY','XDG_RUNTIME_DIR','VK_ICD_FILENAMES','LP_NUM_THREADS','DBUS_SESSION_BUS_ADDRESS']},indent=2))
 commands=[]
 def cmd(args,check=True):
  p=subprocess.run(args,env=env,capture_output=True,text=True,timeout=15);commands.append({'command':args,'exit':p.returncode,'stdout':p.stdout,'stderr':p.stderr})
  if check:assert p.returncode==0,p.stderr
  return p
 cmd(['xdotool','keyup','Alt_L','F4']);cmd(['xdotool','mousemove','0','0'])
 p=None;window=None;visible=None;captured=False;closing=False;samples=[];failure=None;code=None;start=time.monotonic();next_search=start
 try:
  with (out/'app.out').open('w') as stdout,(out/'app.log').open('w') as stderr:
   p=subprocess.Popen([a['preserved']],env=env,stdout=stdout,stderr=stderr,start_new_session=True)
   while p.poll() is None:
    now=time.monotonic()
    if now-start>seconds+45:raise TimeoutError('native process did not finish')
    try:
     s=Path(f'/proc/{p.pid}/stat').read_text().rsplit(') ',1)[1].split()
     samples.append({'at':now-start,'cpu_seconds':(int(s[11])+int(s[12]))/HZ,'rss_bytes':int(s[21])*PAGE,'state':s[0]})
    except FileNotFoundError:pass
    if window is None and now>=next_search:
     q=cmd(['xdotool','search','--onlyvisible','--pid',str(p.pid),'--name','^zgx performance lab$' if name=='zgx' else '^GPUI ZGX lab$'],False)
     assert q.returncode in (0,1)
     if q.returncode==0:
      ids=q.stdout.splitlines();assert len(ids)==1,ids;window=ids[0];visible=time.monotonic()-start
      (out/'geometry.txt').write_text(cmd(['xdotool','getwindowgeometry','--shell',window]).stdout)
      # No activation/movement after visibility during observations.
     next_search=now+.1
    if capture and window is not None and now-start>=visible+1 and not captured:
     cmd(['import','-window',window,str(out/'native.png')]);captured=True
    if name!='zgx' and not closing and 'WORKLOAD_FINISHED' in (out/'app.log').read_text():
     assert window is not None;cmd(['xdotool','windowactivate','--sync',window]);cmd(['xdotool','key','--clearmodifiers','alt+F4']);closing=True
    time.sleep(.02)
   code=p.wait(timeout=10);assert code==0,code;assert visible is not None
   if capture:assert captured
   err=(out/'app.log').read_text();stdout=(out/'app.out').read_text()
   assert 'PRESENTATION_ERROR' not in err and 'workload_error=' not in err
   font=Path(env['ZGX_FONT_FILE']).read_bytes();h=0xcbf29ce484222325
   for b in font:h=((h^b)*0x100000001b3)&((1<<64)-1)
   assert f'font_file_fnv64={h:016x}' in err,(name,'missing font identity')
   geometry=(out/'geometry.txt').read_text();assert 'WIDTH=960\n' in geometry and 'HEIGHT=720\n' in geometry
   if name=='zgx':
    final=[json.loads(line) for line in stdout.splitlines() if line.startswith('{') and '"adapter":"components"' in line];assert len(final)==1
    assert final[0]['renderer']=='gpu';ticks=final[0]['ticks']-initial;native_acks=None
   else:
    matches=re.findall(r'workload_ticks=(\d+) admitted_ticks=(\d+) workload_scroll_offset=([^\n]+)',err);assert len(matches)==1
    total,ticks,offset=matches[0];ticks=int(ticks);assert int(total)==ticks+initial
    ack=re.findall(r'native_acknowledgements=(\d+)',err);assert len(ack)==1;native_acks=int(ack[0]);final={'total_ticks':int(total),'scroll_offset':float(offset)}
   interval=[s for s in samples if visible+1<=s['at']<=visible+6 and s['state']!='Z']
   summary={'name':name,'mode':mode,'route':route,'initial':initial,'ticks':ticks,'native_acknowledgements':native_acks,'reference_or_model_final':final,'visible_seconds':visible,'samples':len(samples),'font_sha256':hashlib.sha256(font).hexdigest()}
   if timed:
    assert len(interval)>=2 and interval[-1]['at']-interval[0]['at']>=4.8,('short interval',len(interval))
    duration=interval[-1]['at']-interval[0]['at'];cpu=interval[-1]['cpu_seconds']-interval[0]['cpu_seconds']
    summary.update({'interval_start':interval[0]['at'],'interval_end':interval[-1]['at'],'interval_seconds':duration,'cpu_seconds':cpu,'cpu_cores':cpu/duration,'mean_rss_bytes':statistics.mean(s['rss_bytes'] for s in interval),'max_rss_bytes':max(s['rss_bytes'] for s in interval)})
   acks=[{'source_epoch':int(a),'presentation_epoch':int(b),'at_ns':int(c)} for a,b,c in re.findall(r'^GPUI_ACK,(\d+),(\d+),(\d+)$',err,re.M)]
   assert len(acks)==native_acks and acks
   assert all(b['at_ns']>=a['at_ns'] for a,b in zip(acks,acks[1:]))
   gaps=[(b['at_ns']/1e9,(b['at_ns']-a['at_ns'])/1e6) for a,b in zip(acks,acks[1:])]
   first=sum(t<1 and gap>25 for t,gap in gaps)
   later=sum(t>=1 and gap>25 for t,gap in gaps)
   summary.update({'cadence_pass':(ticks==0 if mode=='idle' else 58*seconds<=ticks<=61*seconds),'first_second_gaps_over25ms':first,'gap_gate_pass':first<=2 and later==0,'later_gaps_over25ms':later,'total_gaps_over25ms':sum(gap>25 for _,gap in gaps)})
   (out/'acks.json').write_text(json.dumps(acks))
   (out/'summary.json').write_text(json.dumps(summary,indent=2))
 except BaseException as e:
  failure=repr(e);raise
 finally:
  if p is not None:
   if p.poll() is None:
    try:os.killpg(p.pid,signal.SIGTERM)
    except ProcessLookupError:pass
    try:p.wait(timeout=10)
    except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
   code=p.returncode
  (out/'samples.json').write_text(json.dumps(samples));(out/'commands.json').write_text(json.dumps(commands));(out/'status.json').write_text(json.dumps({'exit':code,'failure':failure,'seconds':time.monotonic()-start,'timed':timed}));assert sha(Path(a['preserved']))==a['sha256']
 print(out.relative_to(R),'recorded',flush=True)

if __name__=='__main__':
 stage=sys.argv[1]
 if stage=='preflight':
  for n in NAMES:
   for initial in [0,190]:run(n,'idle',4,R/'preflight'/n/('capture-'+str(initial)),initial=initial,capture=True)
   for mode in ['stream','scroll','both']:run(n,mode,3,R/'preflight'/n/mode)
 elif stage=='timing':
  from guard import check
  check('guard-before-timing.json')
  orders=json.loads((R/'PROCESS_ORDER.json').read_text());assert len(orders)==32
  (R/'timing').mkdir(exist_ok=False)
  try:
   for group in orders:
    for n in group['order']:
     import shutil
     assert shutil.disk_usage('/home/user').free>8*1024**3
     assert not any(p.strip() in ['cargo','rustc','rust-lld','ld.lld','gcc','clang','cc1','clippy-driver'] for p in subprocess.check_output(['ps','-eo','comm='],text=True).splitlines())
     try:run(n,group['mode'],8,R/'timing'/group['mode']/str(group['group'])/n,timed=True)
     except Exception as e:print('FAILED execution',group['mode'],group['group'],n,repr(e),flush=True)
  finally:check('guard-after-timing.json')
 else:raise ValueError(stage)
