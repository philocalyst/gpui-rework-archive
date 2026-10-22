/* Adapted from fcitx/xcb-imdkit test/test_server.c, revision
 * 621048bd50e8f3cbf52335f824f7b4d708a21b14.
 * SPDX-FileCopyrightText: 2014 Weng Xuetian <wengxt@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-only
 */
#include "encoding.h"
#include "imdkit.h"
#include "ximproto.h"
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <xcb/xcb.h>
#include <xcb/xproto.h>

static uint8_t qcode, pcode, escape;
static void callback(xcb_im_t *im, xcb_im_client_t *client,
                     xcb_im_input_context_t *ic,
                     const xcb_im_packet_header_fr_t *hdr, void *frame,
                     void *arg, void *user_data) {
    if (hdr->major_opcode == XCB_XIM_SET_IC_FOCUS)
        xcb_im_input_context_set_data(ic, (void *)(uintptr_t)1, NULL);
    if (hdr->major_opcode == XCB_XIM_UNSET_IC_FOCUS) {
        if ((uintptr_t)xcb_im_input_context_get_data(ic) & 2)
            xcb_im_preedit_done_callback(im, ic);
        xcb_im_input_context_set_data(ic, NULL, NULL);
    }
    unsigned window = ic ? xcb_im_input_context_get_client_window(ic) : 0;
    if (ic) {
        const xcb_im_preedit_attr_t *attr = xcb_im_input_context_get_preedit_attr(ic);
        printf("SERVER opcode=%u window=%u style=%u spot=%d,%d\n", hdr->major_opcode,
               window, xcb_im_input_context_get_input_style(ic),
               attr->spot_location.x, attr->spot_location.y);
    } else {
        printf("SERVER opcode=%u window=0\n", hdr->major_opcode);
    }
    if (hdr->major_opcode == XCB_XIM_FORWARD_EVENT) {
        xcb_key_press_event_t *event = arg;
        printf("SERVER KEY window=%u code=%u type=%u\n", window, event->detail,
               event->response_type & 127);
        uintptr_t state = (uintptr_t)xcb_im_input_context_get_data(ic);
        if ((event->response_type & 127) == XCB_KEY_RELEASE) {
            // A composing IME can consume releases of the keys it handled.
            bool composing_key = (event->detail == qcode && !(event->state & XCB_MOD_MASK_CONTROL))
                || event->detail == pcode || event->detail == escape;
            if (!composing_key) xcb_im_forward_event(im, ic, event);
            return;
        }
        if (event->detail == pcode && (state & 1)) {
            xcb_im_preedit_start_callback(im, ic);
            uint32_t feedback = 0;
            xcb_im_preedit_draw_fr_t draw = {0};
            draw.caret = 1;
            draw.length_of_preedit_string = 1;
            draw.preedit_string = (uint8_t *)"x";
            draw.feedback_array.size = 1;
            draw.feedback_array.items = &feedback;
            xcb_im_preedit_draw_callback(im, ic, &draw);
            xcb_im_input_context_set_data(ic, (void *)(state | 2), NULL);
        } else if (event->detail == escape && (state & 2)) {
            xcb_im_preedit_done_callback(im, ic);
            xcb_im_input_context_set_data(ic, (void *)(state & ~2), NULL);
        } else if (event->detail == qcode && (event->response_type & 127) == XCB_KEY_PRESS &&
            (state & 1) && !(event->state & XCB_MOD_MASK_CONTROL)) {
            if (state & 2) {
                xcb_im_preedit_done_callback(im, ic);
                xcb_im_input_context_set_data(ic, (void *)(state & ~2), NULL);
            }
            size_t len;
            char *result = xcb_utf8_to_compound_text("Ω", strlen("Ω"), &len);
            assert(result);
            xcb_im_commit_string(im, ic, XCB_XIM_LOOKUP_CHARS, result, len, 0);
            free(result);
            printf("SERVER COMMIT window=%u text=Ω\n", window);
        } else {
            xcb_im_forward_event(im, ic, event);
        }
    }
}

int main(int argc, char **argv) {
    assert(argc == 5);
    qcode = atoi(argv[1]); pcode = atoi(argv[2]); escape = atoi(argv[3]);
    setvbuf(stdout, NULL, _IOLBF, 0);
    xcb_compound_text_init();
    int screen_number;
    xcb_connection_t *connection = xcb_connect(NULL, &screen_number);
    assert(!xcb_connection_has_error(connection));
    xcb_screen_iterator_t iter = xcb_setup_roots_iterator(xcb_get_setup(connection));
    for (int n = 0; n < screen_number; ++n) xcb_screen_next(&iter);
    xcb_screen_t *screen = iter.data;
    xcb_window_t w = xcb_generate_id(connection);
    xcb_create_window(connection, XCB_COPY_FROM_PARENT, w, screen->root, 0, 0, 1,
                      1, 0, XCB_WINDOW_CLASS_INPUT_OUTPUT, screen->root_visual, 0, NULL);
    uint32_t style_array[] = {
        XCB_IM_PreeditCallbacks | XCB_IM_StatusNothing,
        XCB_IM_PreeditNothing | XCB_IM_StatusNothing,
        XCB_IM_PreeditNone | XCB_IM_StatusNone,
    };
    xcb_im_styles_t styles = {3, style_array};
    char *encoding_array[] = {"COMPOUND_TEXT"};
    xcb_im_encodings_t encodings = {1, encoding_array};
    xcb_im_t *im = xcb_im_create(connection, screen_number, w, argv[4],
        XCB_IM_ALL_LOCALES, &styles, NULL, NULL, &encodings,
        XCB_EVENT_MASK_KEY_PRESS | (getenv("PROBE_FILTER_RELEASE") ? XCB_EVENT_MASK_KEY_RELEASE : 0), callback, NULL);
    assert(xcb_im_open_im(im));
    printf("SERVER READY window=%u\n", w);
    xcb_generic_event_t *event;
    while ((event = xcb_wait_for_event(connection))) {
        xcb_im_filter_event(im, event);
        free(event);
    }
    xcb_im_close_im(im);
    xcb_im_destroy(im);
    xcb_disconnect(connection);
}
