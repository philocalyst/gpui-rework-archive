#!/usr/bin/env python3
"""Ordinary public Window inspector: real X11 clicks and AT-SPI Registry actions."""
import argparse,hashlib,json,os,pathlib,subprocess,tempfile,time,traceback

def wait(predicate, deadline, description):
    while time.monotonic() < deadline:
        result=predicate()
        if result: return result
        time.sleep(0.05) # External observation only; never between Down and Up.
    raise TimeoutError(description)

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('binary',type=pathlib.Path)
    parser.add_argument('--output',type=pathlib.Path,required=True)
    parser.add_argument('--display',default=':171')
    parser.add_argument('--xvfb',type=pathlib.Path,required=True)
    parser.add_argument('--xdotool',type=pathlib.Path,required=True)
    parser.add_argument('--atspi-launcher',type=pathlib.Path,required=True)
    args=parser.parse_args()
    assert os.environ.get('DBUS_SESSION_BUS_ADDRESS'),'Run within an owned dbus-run-session'
    assert not pathlib.Path('/tmp/.X11-unix/X'+args.display.removeprefix(':')).exists()
    binary=args.binary.resolve();processes=[];events=[]
    with tempfile.TemporaryDirectory(prefix='inspector-pointer-native-') as directory:
        directory=pathlib.Path(directory)
        env={**os.environ,'DISPLAY':args.display,'XDG_RUNTIME_DIR':str(directory),'GSETTINGS_BACKEND':'memory'}
        deadline=time.monotonic()+240;native_log=directory/'native.log'
        with native_log.open('w') as log:
            try:
                processes.append(subprocess.Popen([str(args.xvfb),args.display,'-screen','0','1024x1200x24','-nolisten','tcp'],env=env,stdout=log,stderr=log))
                wait(lambda:subprocess.run([str(args.xdotool),'getdisplaygeometry'],env=env,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL).returncode==0,deadline,'Xvfb')
                processes.append(subprocess.Popen([str(args.atspi_launcher),'--launch-immediately','--a11y=1'],env=env,stdout=log,stderr=log))
                def bus(address,*command):
                    output=subprocess.check_output(['busctl','--json=short','--timeout=2','--address='+address,*command],env=env,text=True,stderr=subprocess.PIPE)
                    if not output.strip():return []
                    data=json.loads(output)['data'];return [data] if command[0]=='get-property' else data
                session=env['DBUS_SESSION_BUS_ADDRESS']
                def discover():
                    try:return bus(session,'call','org.a11y.Bus','/org/a11y/bus','org.a11y.Bus','GetAddress')[0]
                    except (subprocess.CalledProcessError,ValueError,KeyError):return None
                address=wait(discover,deadline,'accessibility bus')
                bus(session,'set-property','org.a11y.Bus','/org/a11y/bus','org.a11y.Status','IsEnabled','b','true')
                processes.append(subprocess.Popen([str(binary)],env=env,stdout=log,stderr=log))
                def call(node,interface,method,*args):return bus(address,'call',node[1],node[2],'org.a11y.atspi.'+interface,method,*args)
                def tree():
                    pending=[('org.a11y.atspi.Registry','/org/a11y/atspi/accessible/root')];result=[]
                    while pending:
                        destination,path=pending.pop(0);assert len(result)<1000
                        name=bus(address,'get-property',destination,path,'org.a11y.atspi.Accessible','Name')[0]
                        result.append((name,destination,path));pending.extend(tuple(p) for p in bus(address,'call',destination,path,'org.a11y.atspi.Accessible','GetChildren')[0])
                    return result
                def named(name):
                    try:return next((n for n in tree() if n[0]==name),None)
                    except (subprocess.CalledProcessError,ValueError,KeyError):return None
                def find(name):return wait(lambda:named(name),deadline,'acknowledged '+name)
                def prefix(start):
                    def probe():
                        try:return next((n for n in tree() if n[0].startswith(start)),None)
                        except (subprocess.CalledProcessError,ValueError,KeyError):return None
                    # A native ACK can retire providers during this multi-call tree walk.
                    return wait(probe,deadline,'acknowledged '+start)
                def invoke(node):assert call(node,'Action','DoAction','i','0')==[True]
                def extents(node):return call(node,'Component','GetExtents','u','0')[0]
                def checked(node):return bool(call(node,'Accessible','GetState')[0][0]&(1<<4))
                def focused(node):return bool(call(node,'Accessible','GetState')[0][0]&(1<<12))
                def frames():
                    return [line.split(',')[1:] for line in native_log.read_text().splitlines() if line.startswith('INSPECTOR_FRAME,')]
                def epoch():return int(frames()[-1][1]) if frames() else 0
                def frame_after(previous):wait(lambda:epoch()>previous,deadline,'new acknowledged frame')
                window=wait(lambda:subprocess.run([str(args.xdotool),'search','--onlyvisible','--name','GPUI Inspector Pointer Qualification'],env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.DEVNULL).stdout.strip(),deadline,'ordinary Window')
                window=window.splitlines()[0]
                subprocess.run([str(args.xdotool),'windowfocus','--sync',window],env=env,check=True)
                def click_point(point):
                    subprocess.run([str(args.xdotool),'mousemove',str(point[0]),str(point[1]),'click','1'],env=env,check=True)
                def click(node):
                    b=extents(node);assert b[2]>0 and b[3]>0 and 0<=b[0]<720 and 0<=b[1]<900,b
                    click_point((b[0]+b[2]//2,b[1]+b[3]//2))
                def focus_search():
                    node=find('Search');before=epoch();click(node)
                    wait(lambda:focused(find('Search')),deadline,'input focus')
                    frame_after(before)
                    return find('Search')
                def advance_to(target):
                    while epoch()<target:
                        before=epoch();node=find('Search')
                        assert call(node,'EditableText','SetTextContents','s','epoch '+str(before+1))==[True]
                        frame_after(before)
                    assert epoch()==target,(target,frames())
                    assert focused(find('Search'))
                find('Toggle details');shape=find('Inspected shape');box=extents(shape)
                invoke(find('Pick element'));prefix('Picking:')
                click(shape);prefix('Selected:')
                selected=prefix('Selected:')[0]
                assert 'Generic' in selected,selected
                focus_search();advance_to(9)
                assert 'logical epoch 9' in prefix('Layout:')[0]
                toggle=find('Toggle details');provider=toggle[1:];before_frames=frames()
                assert not checked(toggle)
                # One ordinary complete click. No held-button ACK or delay inside it.
                click(toggle)
                wait(lambda:checked(toggle),deadline,'immediate inspector checkbox release')
                find('Changes: 1');assert epoch()==11,frames()
                assert 'logical epoch 11' in prefix('Layout:')[0]
                assert find('Toggle details')[1:]==provider
                events.append({'stage':'digit_width_rapid_checkbox','before_epoch':9,'after_epoch':epoch(),'provider':provider,'frames_before':before_frames,'frames_after':frames()})
                for expected in [False,True]:
                    subprocess.run([str(args.xdotool),'key','space'],env=env,check=True)
                    wait(lambda:checked(toggle)==expected,deadline,'Space checkbox update')
                assert find('Toggle details')[1:]==provider
                focus_search();advance_to(19)
                height=find('height');height_provider=height[1:]
                click(height)
                prefix('Logical height:');assert epoch()==21,frames()
                assert find('height')[1:]==height_provider
                events.append({'stage':'digit_boundary_panel_action','before_epoch':19,'after_epoch':epoch(),'provider':height_provider})
                # Picking stays active when an exact rounded corner has no shape.
                invoke(find('Pick element'));prefix('Picking:')
                search=find('Search');assert call(search,'Component','GrabFocus')==[True]
                wait(lambda:focused(find('Search')),deadline,'AT input focus while picking')
                wait(lambda:epoch()>=23,deadline,'AT focus caret frame')
                box=extents(find('Inspected shape'));before=epoch()
                click_point((box[0]+1,box[1]+1));frame_after(before)
                assert prefix('Picking:')[0].startswith('Picking:')
                assert prefix('Selected:')[0]==selected
                search=find('Search');before=epoch();assert call(search,'Component','GrabFocus')==[True]
                wait(lambda:focused(find('Search')),deadline,'refocused input')
                frame_after(before)
                shape=find('Inspected shape');shape_provider=shape[1:];before=epoch()
                click(shape)
                wait(lambda:named('Pick element'),deadline,'rounded transformed shape selection')
                assert prefix('Selected:')[0]==selected
                wait(lambda:epoch()==before+2,deadline,'own focus plus selection source steps')
                transform=prefix('Displayed transform @')[0]
                assert '1.0 0.1 0.2 1.0' in transform,transform
                assert find('Inspected shape')[1:]==shape_provider
                events.append({'stage':'rounded_general_basis_picking','outside_corner':list((box[0]+1,box[1]+1)),'bounds':box,'selected':selected,'transform':transform,'provider':shape_provider,'after_epoch':epoch()})
                final_frames=frames();assert final_frames and all(kind=='ReferenceCpu' and s==p for kind,s,p in final_frames),final_frames
                args.output.write_text(json.dumps({'binary_sha256':hashlib.file_digest(binary.open('rb'),'sha256').hexdigest(),'method':'Ordinary public Window::document(...).inspector(), real X11 immediate clicks/Space and actual AT-SPI Registry Action/EditableText/Component; no private host/model seeding or wait between Down/Up; no timing claim.','events':events,'frames':final_frames,'native_log':native_log.read_text()},indent=2)+'\n')
                print('Public native inspector rapid release, digit boundary, panel action and P/C rounded/general-basis picking passed')
            except BaseException:
                args.output.with_suffix('.failure.log').write_text(traceback.format_exc()+'\n'+json.dumps({'events':events},indent=2)+'\n'+native_log.read_text())
                raise
            finally:
                for process in reversed(processes):process.terminate()
                for process in reversed(processes):
                    try:process.wait(timeout=10)
                    except subprocess.TimeoutExpired:process.kill();process.wait()

if __name__=='__main__':main()
