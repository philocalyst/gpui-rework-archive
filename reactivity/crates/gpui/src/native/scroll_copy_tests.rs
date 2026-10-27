use super::*;
use crate::{ItemKey, ItemSource, ListId, prelude::*};
// Exercise the actual application model and UI-thread workload operation.
#[allow(dead_code)]
#[path = "../../examples/zgx_native_lab.rs"]
mod workload_port;
const LIST: ListId = ListId::new(1);
struct Rows {
    offset: Signal<f64>,
    controlled: bool,
    revision: u8,
}
impl Rows {
    const OFFSET: Source<Self, f64> =
        Source::new(FieldId::new(1), "offset", |m| &m.offset, |m| &mut m.offset);
}
impl ItemSource for Rows {
    fn len(&self) -> usize {
        1000
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        usize::try_from(key.get()).ok().filter(|i| *i < self.len())
    }
    fn row(&self, index: usize) -> El<'_> {
        div()
            .w(60)
            .h(12)
            .bg(Color::rgb((index * 31 % 255) as u8, 100, 180))
            .child(
                text(format!("r{index}/{}", self.revision))
                    .font_size(9)
                    .line_height(12)
                    .h(12),
            )
    }
}
impl View for Rows {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::OFFSET)
    }
    fn view(&self) -> El<'_> {
        uniform_list(LIST, self, 12)
            .overscan(2)
            .w(60)
            .h(48)
            .bg(Color::WHITE)
            .apply(|list| {
                if self.controlled {
                    list.scroll_offset(&self.offset)
                } else {
                    list
                }
            })
    }
}
fn window(controlled: bool) -> Win<Rows> {
    Win::recording(
        Rows {
            offset: Signal::new(0.),
            controlled,
            revision: 0,
        },
        WindowOptions {
            size: [80, 64],
            ..Default::default()
        },
    )
    .unwrap()
}
fn ack(owner: &mut Win<Rows>) {
    let token = owner.with_scene(|_, t| t).unwrap();
    owner.presented(token).unwrap();
}
fn has_copy(owner: &Win<Rows>) -> bool {
    owner
        .with_paint_scene(|_, _, _, d| d.scroll.is_some())
        .unwrap()
}

#[test]
fn public_list_scroll_certifies_exact_tokens_and_discards_pending_or_fractional_proposals() {
    for controlled in [false, true] {
        let mut owner = window(controlled);
        assert!(!has_copy(&owner));
        ack(&mut owner);
        let list = owner.list(LIST).unwrap();
        let previous = owner.with_scene(|_, t| t).unwrap();
        owner.scroll(list, 6.).unwrap();
        owner
            .with_paint_scene(|_, token, _, damage| {
                let transition = damage.scroll.expect("ordinary public scroll must certify");
                assert_eq!((transition.from, transition.to), (previous, token));
                assert_ne!(previous, token);
                assert_eq!(transition.copy.source(), [0, 6, 60, 48]);
                assert_eq!(transition.copy.destination(), [0, 0, 60, 42]);
            })
            .unwrap();
        assert_eq!(
            owner.snapshot().unwrap().source_epoch,
            u64::from(controlled)
        );
        owner.update(|m| m.revision += 1).unwrap();
        assert!(
            !has_copy(&owner),
            "a coalesced newer scene cannot reuse a previous plan"
        );
        ack(&mut owner);
        owner.scroll(list, 0.5).unwrap();
        assert!(!has_copy(&owner));
    }
}

pub(super) fn run(gpu: &mut GpuSurface) {
    let mut oracle = pollster::block_on(Renderer::new(
        gpu.renderer.device().clone(),
        gpu.renderer.queue().clone(),
        gpu.renderer.format(),
    ))
    .unwrap();
    let texture = gpu
        .renderer
        .device()
        .create_texture(&wgpu::TextureDescriptor {
            label: Some("native scroll copy oracle"),
            size: wgpu::Extent3d {
                width: 80,
                height: 64,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: gpu.renderer.format(),
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
            view_formats: &[],
        });
    for controlled in [false, true] {
        let mut owner = window(controlled);
        render(gpu, &mut oracle, &mut owner, &texture);
        let list = owner.list(LIST).unwrap();
        for _ in 0..3 {
            owner.scroll(list, 6.).unwrap();
            assert!(has_copy(&owner));
            render(gpu, &mut oracle, &mut owner, &texture);
            assert_eq!(
                gpu.renderer.retained_stats().copied_pixels,
                80 * 64 + 2 * 60 * 42
            );
            assert!(gpu.renderer.retained_stats().composited_pixels < 80 * 64);
        }
        // Another presenter may ACK a scene that this GPU has never rendered.
        // For an unbound list every source epoch is still zero. A token guard
        // must reject copying this stale GPU image despite matching source epochs.
        owner.scroll(list, 6.).unwrap();
        ack(&mut owner);
        owner.scroll(list, 6.).unwrap();
        assert!(has_copy(&owner));
        render(gpu, &mut oracle, &mut owner, &texture);
        assert_eq!(gpu.renderer.retained_stats().copied_pixels, 80 * 64);
        owner.scroll(list, 6.).unwrap();
        owner.update(|m| m.revision += 1).unwrap();
        assert!(!has_copy(&owner));
        render(gpu, &mut oracle, &mut owner, &texture);
        assert_eq!(gpu.renderer.retained_stats().copied_pixels, 80 * 64);
        if controlled {
            owner.set(Rows::OFFSET, 42.).unwrap();
            assert!(has_copy(&owner));
            assert!(owner.set(Rows::OFFSET, f64::NAN).is_err());
            render(gpu, &mut oracle, &mut owner, &texture);
            owner.set(Rows::OFFSET, 48.).unwrap();
            render(gpu, &mut oracle, &mut owner, &texture);
        }
        gpu.packet_token = None;
        gpu.packet_epoch = None;
    }
    let texture = gpu
        .renderer
        .device()
        .create_texture(&wgpu::TextureDescriptor {
            label: Some("native complete workload scroll oracle"),
            size: wgpu::Extent3d {
                width: 960,
                height: 720,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: gpu.renderer.format(),
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
            view_formats: &[],
        });
    workload_port::visit_scroll_frames(|owner, tick| {
        owner
            .with_paint_scene(|_, _, _, damage| {
                if tick == 0 {
                    assert!(damage.scroll.is_none());
                } else {
                    let copy = damage
                        .scroll
                        .expect("the actual 100K-row workload must certify")
                        .copy;
                    assert_eq!(copy.source(), [20, 304, 940, 690]);
                    assert_eq!(copy.destination(), [20, 290, 940, 676]);
                }
            })
            .unwrap();
        render(gpu, &mut oracle, owner, &texture);
        if tick > 0 {
            assert_eq!(
                gpu.renderer.retained_stats().copied_pixels,
                960 * 720 + 2 * 920 * 386
            );
        }
    });
    gpu.packet_token = None;
    gpu.packet_epoch = None;
}
