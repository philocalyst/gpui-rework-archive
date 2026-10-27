//! Actual native bridge authority after another presenter advances P.
use super::*;
use crate::{ItemKey, ItemSource, ListId, prelude::*};
const LIST: ListId = ListId::new(918);
struct Page {
    label: Signal<String>,
    invalid: bool,
}
impl Page {
    const LABEL: Source<Self, String> =
        Source::new(FieldId::new(1), "label", |m| &m.label, |m| &mut m.label);
}
impl ItemSource for Page {
    fn len(&self) -> usize {
        1000
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        usize::try_from(key.get()).ok().filter(|&i| i < 1000)
    }
    fn row(&self, index: usize) -> El<'_> {
        div().w(220).h(8).bg(if index.is_multiple_of(2) {
            Color::WHITE
        } else {
            Color::BLACK
        })
    }
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::LABEL)
    }
    fn view(&self) -> El<'_> {
        column((
            text(&self.label).w(220).h(24),
            text("0123456789").w(220).h(24),
            uniform_list(LIST, self, 8).w(220).h(64),
        ))
        .w(240)
        .rounded(if self.invalid { f32::NAN } else { 0. })
        .h(144)
        .bg(Color::rgb(23, 31, 47))
    }
}
fn window() -> Win<Page> {
    Win::recording(
        Page {
            label: Signal::new("000000 000000".into()),
            invalid: false,
        },
        WindowOptions {
            size: [240, 144],
            ..Default::default()
        },
    )
    .unwrap()
}
fn ack(owner: &mut Win<Page>) {
    owner
        .presented(owner.with_scene(|_, t| t).unwrap())
        .unwrap();
}
fn render(gpu: &mut GpuSurface, owner: &mut Win<Page>) {
    let texture = gpu
        .renderer
        .device()
        .create_texture(&wgpu::TextureDescriptor {
            label: Some("native sparse text authority"),
            size: wgpu::Extent3d {
                width: 240,
                height: 144,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: gpu.renderer.format(),
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
            view_formats: &[],
        });
    let view = texture.create_view(&Default::default());
    let token = owner
        .with_paint_scene(|scene, token, paint, damage| {
            gpu.render_damaged(scene, token, paint, &view, Some(damage))
                .unwrap();
            token
        })
        .unwrap();
    let actual = super::paint_tests::read(gpu, &texture);
    let mut full = pollster::block_on(Renderer::new(
        gpu.renderer.device().clone(),
        gpu.renderer.queue().clone(),
        gpu.renderer.format(),
    ))
    .unwrap();
    owner
        .with_scene(|scene, _| full.render(scene, &view))
        .unwrap()
        .unwrap();
    assert!(
        actual == super::paint_tests::read(gpu, &texture),
        "native sparse text differs from full GPU after publication transition"
    );
    owner.presented(token).unwrap();
}
pub(super) fn run(gpu: &mut GpuSurface) {
    let mut owner = window();
    render(gpu, &mut owner);
    owner.set(Page::LABEL, "000001 000002".into()).unwrap();
    render(gpu, &mut owner);
    assert!(gpu.renderer.retained_stats().composited_pixels < 240 * 144);
    let old_epoch = owner.snapshot().unwrap().source_epoch;
    let old_token = gpu.packet_token;
    let list = owner.list(LIST).unwrap();
    owner.scroll(list, 8.).unwrap();
    ack(&mut owner);
    assert_eq!(owner.snapshot().unwrap().source_epoch, old_epoch);
    let acknowledged = owner.with_scene(|_, token| token).unwrap();
    owner.set(Page::LABEL, "000003 000004".into()).unwrap();
    owner
        .with_paint_scene(|_, _, _, damage| {
            assert_eq!(damage.base, Some(acknowledged));
            assert_ne!(damage.base, old_token);
        })
        .unwrap();
    render(gpu, &mut owner);
    assert_eq!(gpu.renderer.retained_stats().composited_pixels, 240 * 144);
    // A second unseen scroll plus coalescing exercises ordinary damage too.
    owner.scroll(list, 8.).unwrap();
    ack(&mut owner);
    owner.set(Page::LABEL, "000005 000006".into()).unwrap();
    owner.set(Page::LABEL, "000007 000008".into()).unwrap();
    render(gpu, &mut owner);
    // A failed newer preparation must not revoke the older eligible C.
    owner.set(Page::LABEL, "000001 000009".into()).unwrap();
    let older = owner.with_scene(|_, token| token).unwrap();
    assert!(owner.update(|m| m.invalid = true).is_err());
    assert_eq!(owner.with_scene(|_, token| token).unwrap(), older);
    render(gpu, &mut owner);
    eprintln!("NATIVE_TEXT_REPAIR,stale-predecessor/coalescing/failed-newer/full-pixels=pass");
}
