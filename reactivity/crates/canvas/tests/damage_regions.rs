use gpui_canvas::{Affine, Canvas, Color, DamageRegion, DamageRegions, Rect};
fn region(x: f32, y: f32, width: f32, height: f32) -> DamageRegion {
    let mut canvas = Canvas::recording(2048, 32, Default::default()).unwrap();
    let mut scene = canvas.stage();
    scene
        .fill_rect(
            Rect::new(x, y, width, height),
            Affine::IDENTITY,
            Rect::new(0., 0., 2048., 32.),
            Color::WHITE,
        )
        .unwrap();
    scene.commit_with_damage()
}
fn area(region: DamageRegion) -> u64 {
    region
        .bounds()
        .map_or(0, |[l, t, r, b]| u64::from(r - l) * u64::from(b - t))
}
fn separated(regions: &DamageRegions) {
    let rectangles = regions.regions();
    for (i, a) in rectangles.iter().enumerate() {
        for b in &rectangles[i + 1..] {
            let [l, t, r, d] = a.bounds().unwrap();
            let [x, y, right, down] = b.bounds().unwrap();
            assert!(r < x || right < l || d < y || down < t);
        }
    }
}
#[test]
fn merge_restarts_and_preserves_all_input_support_in_every_order() {
    let inputs = [
        region(0., 0., 2., 2.),
        region(6., 6., 2., 2.),
        region(2., 0., 4., 6.),
        region(20., 2., 2., 2.),
    ];
    for order in [[0, 1, 2, 3], [3, 2, 1, 0], [1, 3, 0, 2], [2, 0, 3, 1]] {
        let mut regions = DamageRegions::default();
        for i in order {
            regions.include(inputs[i]);
            separated(&regions);
        }
        assert_eq!(regions.regions().len(), 2);
        for input in inputs {
            let [l, t, r, b] = input.bounds().unwrap();
            assert!(regions.regions().iter().any(|part| {
                part.bounds()
                    .is_some_and(|[x, y, right, down]| x <= l && y <= t && right >= r && down >= b)
            }));
        }
        assert_eq!(
            regions.pixels(),
            area(inputs[0].union(inputs[1]).union(inputs[2])) + area(inputs[3])
        );
    }
}
#[test]
fn inline_region_allocates_nothing_and_overflow_stays_bounded() {
    let first = region(0., 0., 2., 2.);
    let overlapping = region(1., 0., 2., 2.);
    let mut regions = DamageRegions::default();
    let allocation = allocation_counter::measure(|| {
        regions.include(first);
        regions.include(overlapping);
        regions.include(DamageRegion::default());
    });
    assert_eq!(allocation.count_total, 0);
    assert_eq!(regions.regions().len(), 1);
    assert_eq!(regions.pixels(), area(first.union(overlapping)));
    let mut regions = DamageRegions::default();
    let mut expected = DamageRegion::default();
    for i in 0..64 {
        let support = region(i as f32 * 4., 0., 1., 1.);
        expected = expected.union(support);
        regions.include(support);
    }
    assert_eq!(regions.regions().len(), 64);
    separated(&regions);
    let last = region(256., 0., 1., 1.);
    expected = expected.union(last);
    regions.include(last);
    assert_eq!(regions.regions().len(), 1);
    let last = region(300., 5., 1., 1.);
    expected = expected.union(last);
    regions.include(last);
    assert_eq!(regions.regions().len(), 1);
    assert_eq!(regions.bounds(), expected);
    assert_eq!(regions.pixels(), area(expected));
}
