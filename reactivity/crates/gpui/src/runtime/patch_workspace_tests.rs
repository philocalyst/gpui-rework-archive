use super::*;
use crate::prelude::*;
struct Page {
    value: Signal<String>,
    visible: bool,
}
impl Page {
    const VALUE: Source<Self, String> =
        Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::VALUE)
    }
    fn view(&self) -> El<'_> {
        column(
            [
                text(&self.value).font_size(16).w(290).h(28),
                text("0123456789").font_size(16).w(290).h(28),
            ]
            .into_iter()
            .take(if self.visible { 2 } else { 0 }),
        )
        .w(320)
        .h(120)
        .bg(Color::WHITE)
        .fg(Color::BLACK)
    }
}
fn ack(win: &mut Win<Page>) {
    let t = win.with_scene(|_, t| t).unwrap();
    win.presented(t).unwrap();
}
#[test]
fn workspace_reuses_allocation_retires_payload_and_is_reclaimed_with_text() {
    assert_eq!(
        size_of::<text_geometry::TextPatch>(),
        if cfg!(feature = "native-core") {
            96
        } else {
            40
        }
    );
    assert_eq!(size_of::<text_geometry::TextResources>(), 168);
    let mut win = Win::recording(
        Page {
            value: Signal::new("000000 000000".into()),
            visible: true,
        },
        WindowOptions {
            size: [320, 120],
            ..Default::default()
        },
    )
    .unwrap();
    ack(&mut win);
    win.set(Page::VALUE, "000001 000002".into()).unwrap();
    let address = {
        let r = win.runtime().unwrap();
        let p = r
            .text
            .as_ref()
            .unwrap()
            .patch
            .as_deref()
            .expect("sparse candidate");
        assert!(p.content.is_some());
        std::ptr::from_ref(p) as usize
    };
    #[cfg(feature = "native-core")]
    let regions = {
        let r = win.runtime().unwrap();
        let p = r.text.as_ref().unwrap().patch.as_deref().unwrap();
        assert!(p.repair.regions.regions().len() > 1);
        p.repair.regions.regions().as_ptr() as usize
    };
    ack(&mut win);
    assert!(
        win.runtime()
            .unwrap()
            .text
            .as_ref()
            .unwrap()
            .patch
            .as_ref()
            .unwrap()
            .content
            .is_none()
    );
    #[cfg(feature = "native-core")]
    win.with_paint_scene(|_, _, _, damage| assert!(damage.repair.is_none()))
        .unwrap();
    for i in 0..8 {
        win.set(
            Page::VALUE,
            if i % 2 == 0 {
                "000003 000004"
            } else {
                "000001 000002"
            }
            .into(),
        )
        .unwrap();
        let r = win.runtime().unwrap();
        let patch = r.text.as_ref().unwrap().patch.as_deref().unwrap();
        assert!(patch.content.is_some());
        assert_eq!(std::ptr::from_ref(patch) as usize, address);
        #[cfg(feature = "native-core")]
        {
            assert_eq!(patch.repair.regions.regions().as_ptr() as usize, regions);
            assert!(patch.repair.regions.regions().len() <= 64);
        }
        ack(&mut win);
        assert!(
            win.runtime()
                .unwrap()
                .text
                .as_ref()
                .unwrap()
                .patch
                .as_ref()
                .unwrap()
                .content
                .is_none()
        );
    }
    win.update(|m| m.visible = false).unwrap();
    ack(&mut win);
    assert!(
        win.runtime().unwrap().text.is_none(),
        "unused text service must reclaim publication capacity"
    );
}
