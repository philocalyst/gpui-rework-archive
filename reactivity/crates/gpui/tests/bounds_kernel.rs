use gpui::{Affine, El, Rect, View, Win, WindowOptions, column, div};

// Independent public-consumer copy of the original corner expression. A Part's
// admitted Affine needs no private CoordinateSpace uncertainty access.
fn original_bounds(t: Affine, r: Rect) -> Option<Rect> {
    let [a, b, c, d, tx, ty] = [t.a, t.b, t.c, t.d, t.tx, t.ty].map(f64::from);
    if !r.is_valid()
        || ![a, b, c, d, tx, ty].into_iter().all(f64::is_finite)
        || r.is_empty()
        || a * d - b * c == 0.0
    {
        return None;
    }
    let x = r.x as f64;
    let y = r.y as f64;
    let right = x + r.width as f64;
    let bottom = y + r.height as f64;
    let mut low = [f64::INFINITY; 2];
    let mut high = [f64::NEG_INFINITY; 2];
    for [x, y] in [[x, y], [right, y], [x, bottom], [right, bottom]] {
        let p = [a * x + c * y + tx, b * x + d * y + ty];
        for axis in 0..2 {
            low[axis] = low[axis].min(p[axis]);
            high[axis] = high[axis].max(p[axis]);
        }
    }
    let low = low.map(|v| (v as f32).next_down());
    let high = high.map(|v| (v as f32).next_up());
    let result = Rect::new(
        low[0],
        low[1],
        (high[0] - low[0]).next_up(),
        (high[1] - low[1]).next_up(),
    );
    result.is_valid().then_some(result)
}
fn bits(r: Option<Rect>) -> Option<[u32; 4]> {
    r.map(|r| [r.x, r.y, r.width, r.height].map(f32::to_bits))
}
struct Shapes {
    phase: u32,
}
impl View for Shapes {
    fn view(&self) -> El<'_> {
        column((0..96).map(|index| {
            let angle = (index + self.phase) as f32 * 0.37;
            let a = if index % 7 == 0 { -0.0 } else { angle.cos() };
            div().w(7.25).h(3.125).transform(Affine {
                a,
                b: angle.sin(),
                c: -angle.sin() * 0.75,
                d: angle.cos(),
                tx: index as f32 * -0.125,
                ty: index as f32 * 0.0625,
            })
        }))
        .gap(0.125)
        .transform(Affine::translation(-13.25, 9.125))
    }
}
fn verify(window: &Win<Shapes>) -> u64 {
    let mut hash = 0xcbf2_9ce4_8422_2325u64;
    window
        .visit(|part| {
            let expected = part
                .transform()
                .and_then(|t| original_bounds(t, part.local_bounds()));
            assert_eq!(bits(part.unclipped_bounds()), bits(expected));
            assert_eq!(window.bounds(part.target()).unwrap(), part.bounds());
            assert!(window.query().within(part.target()).count().unwrap() > 0);
            for word in bits(part.unclipped_bounds()).unwrap_or([0; 4]) {
                hash = (hash ^ word as u64).wrapping_mul(0x100_0000_01b3);
            }
        })
        .unwrap();
    hash
}
fn acknowledge(window: &mut Win<Shapes>) {
    let token = window.with_scene(|_, token| token).unwrap();
    window.presented(token).unwrap();
}
#[test]
fn public_geometry_and_queries_match_original_corners_across_pending_sheets_and_resize() {
    let mut window = Win::recording(
        Shapes { phase: 0 },
        WindowOptions {
            size: [320, 480],
            ..Default::default()
        },
    )
    .unwrap();
    acknowledge(&mut window);
    let mut old = verify(&window);
    for phase in 1..6 {
        window.update(|model| model.phase = phase).unwrap();
        assert_eq!(
            verify(&window),
            old,
            "pending sheet must not rewrite old geometry"
        );
        acknowledge(&mut window);
        let new = verify(&window);
        assert_ne!(new, old);
        old = new;
    }
    window.resize([240, 360]).unwrap();
    assert_eq!(verify(&window), old);
    acknowledge(&mut window);
    verify(&window);
}
