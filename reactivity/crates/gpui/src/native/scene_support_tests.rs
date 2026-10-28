//! Full-image witnesses for support accumulated before an external ACK.
use super::*;
use crate::prelude::*;
struct Page {
    values: [Signal<String>; 3],
    invalid: bool,
    shifted: bool,
}
impl Page {
    const F: [Source<Self, String>; 3] = [
        Source::new(FieldId::new(1), "a", |m| &m.values[0], |m| &mut m.values[0]),
        Source::new(FieldId::new(2), "b", |m| &m.values[1], |m| &mut m.values[1]),
        Source::new(FieldId::new(3), "c", |m| &m.values[2], |m| &mut m.values[2]),
    ];
}
impl View for Page {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::F[0])
            .direct(Self::F[1])
            .direct(Self::F[2])
    }
    fn view(&self) -> El<'_> {
        column(self.values.iter().enumerate().map(|(i, value)| {
            div()
                .w(0)
                .h(0)
                .transform(Affine::translation(
                    8. + i as f32 * 72.,
                    if self.shifted { 20. } else { 8. },
                ))
                .child(text(value).font_size(12).w(64).h(20))
        }))
        .w(240)
        .h(64)
        .bg(Color::WHITE)
        .fg(Color::BLACK)
        .rounded(if self.invalid { f32::NAN } else { 0. })
    }
}
fn window() -> Win<Page> {
    Win::recording(
        Page {
            values: std::array::from_fn(|_| Signal::new("0000".into())),
            invalid: false,
            shifted: false,
        },
        WindowOptions {
            size: [240, 64],
            ..Default::default()
        },
    )
    .unwrap()
}
fn repair(owner: &Win<Page>) -> (crate::PresentationToken, crate::PresentationToken, usize) {
    owner
        .with_paint_scene(|_, token, _, damage| {
            let repair = damage
                .repair
                .expect("separated changes retain complete support");
            assert_eq!(repair.to, token);
            assert_eq!(Some(repair.from), damage.base);
            (repair.from, repair.to, repair.regions.regions().len())
        })
        .unwrap()
}
#[test]
fn sequential_source_candidates_keep_the_original_acknowledged_base() {
    let mut owner = window();
    let base = owner.with_scene(|_, t| t).unwrap();
    owner.presented(base).unwrap();
    for i in 0..3 {
        owner.set(Page::F[i], "1111".into()).unwrap();
    }
    let (from, to, count) = repair(&owner);
    assert_eq!(from, base);
    assert_ne!(from, to);
    assert!(count >= 3);
    eprintln!(
        "SUPPORT_HEADERS,SceneDamage={},SceneRepair={}",
        size_of::<crate::runtime::paint::SceneDamage>(),
        size_of::<crate::runtime::paint::SceneRepair>()
    );
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
            label: Some("coalesced scene support oracle"),
            size: wgpu::Extent3d {
                width: 240,
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
    for owner_route in [false, true] {
        let mut owner = window();
        render(gpu, &mut oracle, &mut owner, &texture);
        for tick in 0..4 {
            let value = if tick % 2 == 0 { "1111" } else { "0000" };
            if owner_route {
                owner
                    .update(|m| {
                        for slot in &mut m.values {
                            **slot = value.into()
                        }
                    })
                    .unwrap();
            } else {
                for field in Page::F {
                    owner.set(field, value.into()).unwrap();
                }
            }
            assert!(repair(&owner).2 >= 3);
            render(gpu, &mut oracle, &mut owner, &texture);
            assert!(gpu.renderer.retained_stats().composited_pixels < 240 * 64);
        }
        // This change is ACKed by a different presenter. The GPU must refuse
        // the next precise transition, even though its from/to are valid in Win.
        owner.update(|m| m.shifted = true).unwrap();
        owner
            .presented(owner.with_scene(|_, t| t).unwrap())
            .unwrap();
        for field in Page::F {
            owner.set(field, "2222".into()).unwrap();
        }
        repair(&owner);
        render(gpu, &mut oracle, &mut owner, &texture);
        assert_eq!(gpu.renderer.retained_stats().composited_pixels, 240 * 64);
        // Preserve an older eligible candidate after a newer admission fails.
        for field in Page::F {
            owner.set(field, "3333".into()).unwrap();
        }
        let older = repair(&owner);
        assert!(owner.update(|m| m.invalid = true).is_err());
        assert_eq!(repair(&owner), older);
        render(gpu, &mut oracle, &mut owner, &texture);
        gpu.packet_token = None;
    }
    eprintln!("NATIVE_SCENE_SUPPORT,coalescing/owner/source/stale/failed-newer/full-pixels=pass");
}
