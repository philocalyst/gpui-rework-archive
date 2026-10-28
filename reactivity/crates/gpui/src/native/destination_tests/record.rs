//! Real X server protocol observation, confined to this explicit native proof.
//! No counters, observer or recorder thread is included in production.
use std::{
    sync::mpsc,
    thread::{self, JoinHandle},
    time::Duration,
};
use x11rb::{
    connection::Connection,
    protocol::{
        record, shm,
        xproto::{self, ConnectionExt as _},
    },
    rust_connection::RustConnection,
    x11_utils::{BigRequests, parse_request_header},
};

#[derive(Debug)]
pub struct Transfer {
    pub kind: &'static str,
    pub rect: [i32; 4],
    /// Image bytes read/copied, excluding server-side solid fills.
    pub pixel_bytes: u64,
    pub request_bytes: usize,
}
pub struct Record {
    pub control: RustConnection,
    pub window: u32,
    context: u32,
    reader: Option<JoinHandle<Vec<Transfer>>>,
}
impl Record {
    pub fn start(window: u32, expect_shm: bool) -> Self {
        let (control, _) = x11rb::connect(None).unwrap();
        record::query_version(&control, 1, 13)
            .unwrap()
            .reply()
            .expect("X RECORD required");
        let extension = control
            .query_extension(b"MIT-SHM")
            .unwrap()
            .reply()
            .unwrap();
        assert_eq!(
            extension.present, expect_shm,
            "explicit proof server SHM profile"
        );
        let opcode = extension.major_opcode;
        let context = control.generate_id().unwrap();
        let range = record::Range {
            core_requests: record::Range8 {
                first: xproto::POLY_FILL_RECTANGLE_REQUEST,
                last: xproto::PUT_IMAGE_REQUEST,
            },
            ext_requests: record::ExtRange {
                major: record::Range8 {
                    first: opcode,
                    last: opcode,
                },
                minor: record::Range16 { first: 3, last: 3 },
            },
            ..Default::default()
        };
        // A resource ID selects its owning client. This excludes the control
        // connection's deliberate damage/obscuration requests to this window.
        record::create_context(&control, context, 0, &[window], &[range])
            .unwrap()
            .check()
            .unwrap();
        let (ready_tx, ready_rx) = mpsc::sync_channel(1);
        let reader = thread::spawn(move || {
            let (connection, _) = x11rb::connect(None).unwrap();
            let replies = record::enable_context(&connection, context).unwrap();
            connection.flush().unwrap();
            let mut pending = Vec::new();
            let mut transfers = Vec::new();
            for reply in replies {
                let reply = reply.unwrap();
                assert!(
                    !reply.client_swapped,
                    "proof uses same-endian local clients"
                );
                if reply.category == 4 {
                    ready_tx.send(()).unwrap();
                    continue;
                }
                assert_eq!(reply.category, 1, "RECORD client-request category");
                pending.extend_from_slice(&reply.data);
                assert!(
                    pending.len() <= 2 * 1024 * 1024,
                    "bounded proof request buffer"
                );
                while let Ok((header, body)) = parse_request_header(&pending, BigRequests::Enabled)
                {
                    let prefix = pending.len() - body.len();
                    let length = prefix + header.remaining_length as usize * 4;
                    if pending.len() < length {
                        break;
                    }
                    let body = &pending[prefix..length];
                    if header.major_opcode == opcode {
                        let request =
                            shm::PutImageRequest::try_parse_request(header, body).unwrap();
                        assert_eq!(request.drawable, window);
                        assert_eq!(
                            (i32::from(request.src_x), i32::from(request.src_y)),
                            (i32::from(request.dst_x), i32::from(request.dst_y))
                        );
                        transfers.push(transfer(
                            "SHM",
                            [
                                i32::from(request.dst_x),
                                i32::from(request.dst_y),
                                i32::from(request.src_width),
                                i32::from(request.src_height),
                            ],
                            length,
                        ));
                    } else if header.major_opcode == xproto::PUT_IMAGE_REQUEST {
                        let request =
                            xproto::PutImageRequest::try_parse_request(header, body).unwrap();
                        assert_eq!(request.drawable, window);
                        transfers.push(transfer(
                            "WIRE",
                            [
                                i32::from(request.dst_x),
                                i32::from(request.dst_y),
                                i32::from(request.width),
                                i32::from(request.height),
                            ],
                            length,
                        ));
                    } else if header.major_opcode == xproto::POLY_FILL_RECTANGLE_REQUEST {
                        let request =
                            xproto::PolyFillRectangleRequest::try_parse_request(header, body)
                                .unwrap();
                        assert_eq!(request.drawable, window);
                        for rect in request.rectangles.iter() {
                            transfers.push(transfer(
                                "SOLID",
                                [
                                    i32::from(rect.x),
                                    i32::from(rect.y),
                                    i32::from(rect.width),
                                    i32::from(rect.height),
                                ],
                                length,
                            ));
                        }
                    }
                    pending.drain(..length);
                }
            }
            assert!(pending.is_empty());
            transfers
        });
        ready_rx
            .recv_timeout(Duration::from_secs(3))
            .expect("RECORD activation deadline");
        Self {
            control,
            window,
            context,
            reader: Some(reader),
        }
    }
    pub fn sync(&self) {
        self.control.get_input_focus().unwrap().reply().unwrap();
    }
    pub fn expose(&self, count: u16) {
        self.control
            .send_event(
                false,
                self.window,
                xproto::EventMask::EXPOSURE,
                xproto::ExposeEvent {
                    response_type: xproto::EXPOSE_EVENT,
                    sequence: 0,
                    window: self.window,
                    x: 80,
                    y: 80,
                    width: 16,
                    height: 16,
                    count,
                },
            )
            .unwrap()
            .check()
            .unwrap();
    }
    pub fn corrupt(&self) {
        let gc = self.control.generate_id().unwrap();
        self.control
            .create_gc(
                gc,
                self.window,
                &xproto::CreateGCAux::new().foreground(0x00ff00ff),
            )
            .unwrap()
            .check()
            .unwrap();
        self.control
            .poly_fill_rectangle(
                self.window,
                gc,
                &[xproto::Rectangle {
                    x: 80,
                    y: 80,
                    width: 16,
                    height: 16,
                }],
            )
            .unwrap()
            .check()
            .unwrap();
        self.control.free_gc(gc).unwrap().check().unwrap();
    }
    pub fn finish(mut self) -> Vec<Transfer> {
        record::disable_context(&self.control, self.context)
            .unwrap()
            .check()
            .unwrap();
        record::free_context(&self.control, self.context)
            .unwrap()
            .check()
            .unwrap();
        self.reader.take().unwrap().join().unwrap()
    }
}
fn transfer(kind: &'static str, rect: [i32; 4], request_bytes: usize) -> Transfer {
    assert!(rect[2] > 0 && rect[3] > 0);
    Transfer {
        kind,
        rect,
        pixel_bytes: if kind == "SOLID" {
            0
        } else {
            rect[2] as u64 * rect[3] as u64 * 4
        },
        request_bytes,
    }
}
