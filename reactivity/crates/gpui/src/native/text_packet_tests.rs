//! Ordinary source delivery through the actual native packet bridge.
use super::paint_tests::read;
use super::*;
use crate::{Color, El, FieldId, LaneSet, Remote, Signal, Source, Sources, column, text};
struct Labels([Signal<String>; 4]);
impl Labels {
    const F: [Source<Self, String>; 4] = [
        Source::new(FieldId::new(1), "a", |m| &m.0[0], |m| &mut m.0[0]),
        Source::new(FieldId::new(2), "b", |m| &m.0[1], |m| &mut m.0[1]),
        Source::new(FieldId::new(3), "c", |m| &m.0[2], |m| &mut m.0[2]),
        Source::new(FieldId::new(4), "d", |m| &m.0[3], |m| &mut m.0[3]),
    ];
}
impl View for Labels {
    fn sources() -> Sources<Self> {
        Sources::new()
            .direct(Self::F[0])
            .direct(Self::F[1])
            .direct(Self::F[2])
            .direct(Self::F[3])
    }
    fn view(&self) -> El<'_> {
        column((
            column(self.0.iter().map(|v| text(v).w(180).h(20).font_size(12))),
            text("0123456789").w(180).h(20).font_size(12),
        ))
        .w(192)
        .h(128)
        .bg(Color::WHITE)
    }
}
fn fresh(values: [&str; 4]) -> Win<Labels> {
    Win::recording(
        Labels(values.map(|v| Signal::new(v.to_owned()))),
        WindowOptions {
            size: [192, 128],
            ..Default::default()
        },
    )
    .unwrap()
}
fn values<L: LaneSet<Labels>>(owner: &Win<Labels, L>) -> Vec<String> {
    let mut values = Vec::new();
    owner
        .visit(|p| {
            if let Some(t) = p.text() {
                values.push(t.to_owned());
            }
        })
        .unwrap();
    values
}
fn draw<L: LaneSet<Labels>>(
    gpu: &mut GpuSurface,
    oracle: &mut Renderer,
    owner: &mut Win<Labels, L>,
    target: &wgpu::Texture,
    expected: [&str; 4],
) {
    let view = target.create_view(&Default::default());
    let token = owner
        .with_paint_scene(|scene, token, paint, text, damage| {
            gpu.render_damaged(scene, token, paint, text, &view, Some(damage))
                .unwrap();
            token
        })
        .unwrap();
    let actual = read(gpu, target);
    let full = fresh(expected);
    full.with_scene(|scene, _| oracle.render(scene, &view))
        .unwrap()
        .unwrap();
    assert_eq!(
        actual,
        read(gpu, target),
        "native text packet vs fresh full-window GPU output"
    );
    owner.presented(token).unwrap();
    assert_eq!(&values(owner)[..4], &expected.map(str::to_owned));
}
pub(super) fn run(gpu: &mut GpuSurface) {
    gpu.packet_token = None;
    gpu.packet_epoch = None;
    let mut oracle = pollster::block_on(Renderer::new(
        gpu.renderer.device().clone(),
        gpu.renderer.queue().clone(),
        gpu.renderer.format(),
    ))
    .unwrap();
    let initial = ["0011", "1100", "0011", "1100"];
    let owner = fresh(initial);
    let (a, ai) = Remote::bounded(4);
    let (b, bi) = Remote::bounded(4);
    let (c, ci) = Remote::bounded(4);
    let (d, di) = Remote::bounded(4);
    let mut owner = owner
        .with_inbox_for(ai, Labels::F[0], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(bi, Labels::F[1], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(ci, Labels::F[2], |v, n| *v = n)
        .unwrap()
        .with_inbox_for(di, Labels::F[3], |v, n| *v = n)
        .unwrap();
    let remotes = [a, b, c, d];
    let target = gpu
        .renderer
        .device()
        .create_texture(&wgpu::TextureDescriptor {
            label: Some("native text packet oracle"),
            size: wgpu::Extent3d {
                width: 192,
                height: 128,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: gpu.renderer.format(),
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
            view_formats: &[],
        });
    draw(gpu, &mut oracle, &mut owner, &target, initial);
    assert!(!gpu.renderer.stats().packet_reused);
    let mut current = initial;
    for count in [1, 2, 4] {
        let before = values(&owner);
        for (i, remote) in remotes.iter().enumerate().take(count) {
            current[i] = if current[i] == "0011" { "1100" } else { "0011" };
            remote.try_send(current[i].to_owned()).unwrap();
        }
        owner.deliver_ready(8).unwrap();
        assert_eq!(values(&owner), before, "P text must wait for ACK");
        draw(gpu, &mut oracle, &mut owner, &target, current);
        assert!(
            gpu.renderer.stats().packet_reused,
            "native bridge must use the text packet transaction"
        );
        assert_eq!(gpu.renderer.stats().validated_draws, count * 4);
        assert_eq!(gpu.renderer.stats().mask_upload_bytes, 0);
    }
    // Missing one complete transition cannot authorize positional patching.
    remotes[0].try_send("0011".into()).unwrap();
    owner.deliver_ready(8).unwrap();
    remotes[0].try_send("1100".into()).unwrap();
    owner.deliver_ready(8).unwrap();
    current[0] = "1100";
    draw(gpu, &mut oracle, &mut owner, &target, current);
    assert!(
        !gpu.renderer.stats().packet_reused,
        "coalesced C must rebuild"
    );
    // Failed newer source work must leave the older eligible C and its exact
    // predecessor transition usable, independently of ahead-of-P source values.
    current[0] = "0011";
    current[1] = "0011";
    for i in 0..2 {
        remotes[i].try_send(current[i].to_owned()).unwrap();
    }
    owner.deliver_ready(8).unwrap();
    let eligible = owner.with_scene(|_, t| t).unwrap();
    remotes[0].try_send("漢".into()).unwrap();
    remotes[1].try_send("bad".into()).unwrap();
    assert!(owner.deliver_ready(8).is_err());
    assert_eq!(owner.with_scene(|_, t| t).unwrap(), eligible);
    draw(gpu, &mut oracle, &mut owner, &target, current);
    assert!(gpu.renderer.stats().packet_reused);
    // Repair through a new atlas resource takes full preparation.
    current[0] = "ΩΩΩΩ";
    current[1] = "0011";
    for i in 0..2 {
        remotes[i].try_send(current[i].to_owned()).unwrap();
    }
    owner.deliver_ready(8).unwrap();
    draw(gpu, &mut oracle, &mut owner, &target, current);
    assert!(!gpu.renderer.stats().packet_reused);
    draw(gpu, &mut oracle, &mut owner, &target, current);
    assert!(gpu.renderer.stats().packet_reused);
    assert_eq!(gpu.renderer.stats().validated_draws, 0);
    assert_eq!(gpu.renderer.retained_stats().composited_pixels, 0);
    gpu.packet_token = None;
    gpu.packet_epoch = None;
}
