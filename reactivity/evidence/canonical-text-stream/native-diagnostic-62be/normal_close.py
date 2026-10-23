# Diagnostic-only fallback WM_DELETE_WINDOW; never linked into the fixture.
import ctypes as C, os
from pathlib import Path

def close():
    path=next(Path(p)/'libX11.so.6' for p in os.environ['LD_LIBRARY_PATH'].split(':') if (Path(p)/'libX11.so.6').exists())
    x=C.CDLL(str(path));u=C.c_ulong;p=C.c_void_p
    signatures={'XOpenDisplay':([C.c_char_p],p),'XDefaultRootWindow':([p],u),'XQueryTree':([p,u,C.POINTER(u),C.POINTER(u),C.POINTER(C.POINTER(u)),C.POINTER(C.c_uint)],C.c_int),'XFetchName':([p,u,C.POINTER(p)],C.c_int),'XFree':([p],C.c_int),'XInternAtom':([p,C.c_char_p,C.c_int],u),'XSendEvent':([p,u,C.c_int,C.c_long,p],C.c_int),'XSync':([p,C.c_int],C.c_int),'XCloseDisplay':([p],C.c_int)}
    for name,(args,result) in signatures.items():getattr(x,name).argtypes=args;getattr(x,name).restype=result
    display=x.XOpenDisplay(None);assert display
    class Data(C.Union):_fields_=[('b',C.c_char*20),('s',C.c_short*10),('l',C.c_long*5)]
    class Client(C.Structure):_fields_=[('type',C.c_int),('serial',u),('send_event',C.c_int),('display',p),('window',u),('message_type',u),('format',C.c_int),('data',Data)]
    class Event(C.Union):_fields_=[('client',Client),('pad',C.c_long*24)]
    try:
        parent=u();root=u();children=C.POINTER(u)();count=C.c_uint()
        assert x.XQueryTree(display,x.XDefaultRootWindow(display),C.byref(root),C.byref(parent),C.byref(children),C.byref(count))
        target=None
        try:
            for index in range(count.value):
                name=p()
                if x.XFetchName(display,children[index],C.byref(name)) and name:
                    try:
                        if C.string_at(name)==b'GPUI canonical text native control':target=children[index]
                    finally:x.XFree(name)
        finally:x.XFree(children)
        assert target is not None,'diagnostic window unavailable'
        event=Event();event.client.type=33;event.client.send_event=1;event.client.display=display;event.client.window=target
        event.client.message_type=x.XInternAtom(display,b'WM_PROTOCOLS',0);event.client.format=32
        event.client.data.l[0]=x.XInternAtom(display,b'WM_DELETE_WINDOW',0)
        assert x.XSendEvent(display,target,0,0,C.byref(event));x.XSync(display,0)
    finally:x.XCloseDisplay(display)
