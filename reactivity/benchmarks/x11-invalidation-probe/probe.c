#include <X11/Xlib.h>
#include <stdio.h>
#include <stdlib.h>

static void drain(Display *dpy, const char *phase) {
    XEvent event;
    while (XPending(dpy)) {
        XNextEvent(dpy, &event);
        switch (event.type) {
        case Expose:
            printf("%s Expose x=%d y=%d w=%d h=%d count=%d\n", phase,
                   event.xexpose.x, event.xexpose.y, event.xexpose.width,
                   event.xexpose.height, event.xexpose.count);
            break;
        case MapNotify:
            printf("%s MapNotify\n", phase);
            break;
        case UnmapNotify:
            printf("%s UnmapNotify\n", phase);
            break;
        case ConfigureNotify:
            printf("%s ConfigureNotify x=%d y=%d w=%d h=%d\n", phase,
                   event.xconfigure.x, event.xconfigure.y,
                   event.xconfigure.width, event.xconfigure.height);
            break;
        case VisibilityNotify:
            printf("%s VisibilityNotify state=%d\n", phase,
                   event.xvisibility.state);
            break;
        default:
            printf("%s event=%d\n", phase, event.type);
            break;
        }
    }
}

int main(void) {
    Display *dpy = XOpenDisplay(NULL);
    if (!dpy) {
        fprintf(stderr, "cannot open DISPLAY\n");
        return 2;
    }
    int screen = DefaultScreen(dpy);
    Window window = XCreateSimpleWindow(dpy, RootWindow(dpy, screen), 10, 10,
                                        320, 200, 0,
                                        BlackPixel(dpy, screen),
                                        WhitePixel(dpy, screen));
    XSelectInput(dpy, window, ExposureMask | StructureNotifyMask | VisibilityChangeMask);

    XMapWindow(dpy, window);
    XSync(dpy, False);
    drain(dpy, "initial-map");

    /* A mapped window is removed and remapped. Xvfb has no window manager and
       this test selects the server events directly on the client window. */
    XUnmapWindow(dpy, window);
    XSync(dpy, False);
    drain(dpy, "unmap");

    XMapWindow(dpy, window);
    XSync(dpy, False);
    drain(dpy, "remap");

    XDestroyWindow(dpy, window);
    XSync(dpy, False);
    XCloseDisplay(dpy);
    return 0;
}
