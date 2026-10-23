//! Ordinary recording-owner allocation and old-P/old-C failure control.
use gpui::{CaretAffinity, TextOffset, TextPosition, Win, WindowOptions, prelude::*};

struct Page {
    value: String,
    broken: bool,
}
impl View for Page {
    fn view(&self) -> El<'_> {
        row((
            text(&self.value).w(400),
            div().size(4).bg(Color::BLACK).transform(if self.broken {
                Affine::scale(0., 1.)
            } else {
                Affine::IDENTITY
            }),
        ))
    }
}

fn checksum(win: &Win<Page>, expected: u8) -> u64 {
    let mut result = 0xcbf2_9ce4_8422_2325_u64;
    let mut texts = 0;
    win.visit(|part| {
        if let Some(value) = part.text() {
            assert_eq!(value.len(), 32 * 1024);
            assert!(value.bytes().all(|byte| byte == expected));
            texts += 1;
            let geometry = part.text_geometry().unwrap();
            assert_eq!(geometry.layout().text_len(), value.len());
            for byte in [0, value.len() / 2, value.len()] {
                for affinity in [CaretAffinity::Upstream, CaretAffinity::Downstream] {
                    let position = TextPosition {
                        offset: TextOffset::new(byte).unwrap(),
                        affinity,
                    };
                    let rect = geometry.caret_bounds(position).unwrap();
                    for word in [rect.x, rect.y, rect.width, rect.height] {
                        result = (result ^ u64::from(word.to_bits())).wrapping_mul(0x100_0000_01b3);
                    }
                    result ^= geometry.layout().caret_line(position).unwrap() as u64;
                }
            }
        }
    })
    .unwrap();
    assert_eq!(texts, 1);
    result
}

fn report(stage: &str, row: allocation_counter::AllocationInfo, hash: u64) {
    println!(
        "OWNER stage={stage} allocations={} requested={} peak={} retained={} checksum={hash:016x}",
        row.count_total, row.bytes_total, row.bytes_max, row.bytes_current
    );
}

fn main() {
    let mut owner = None;
    let row = allocation_counter::measure(|| {
        owner = Some(
            Win::recording(
                Page {
                    value: "a".repeat(32 * 1024),
                    broken: false,
                },
                WindowOptions::default(),
            )
            .unwrap(),
        );
    });
    let mut win = owner.unwrap();
    win.presented(win.with_scene(|_, token| token).unwrap())
        .unwrap();
    let first = checksum(&win, b'a');
    report("first_c", row, first);
    let row = allocation_counter::measure(|| {
        win.update(|page| page.value = "b".repeat(32 * 1024))
            .unwrap();
    });
    assert_eq!(checksum(&win, b'a'), first);
    report("old_p_new_c", row, first);
    let token = win.with_scene(|_, token| token).unwrap();
    let row = allocation_counter::measure(|| {
        assert!(
            win.update(|page| {
                page.value = "c".repeat(32 * 1024);
                page.broken = true;
            })
            .is_err()
        );
    });
    assert_eq!(checksum(&win, b'a'), first);
    report("old_p_old_c_failed_l", row, first);
    let row = allocation_counter::measure(|| {
        win.presented(token).unwrap();
    });
    report("old_c_ack_failed_l", row, checksum(&win, b'b'));
}
