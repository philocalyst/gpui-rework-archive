//! Exact translated contribution proof over two complete staged scenes.
use super::*;

type Bounds = [i32; 4];

/// A checked copy and repair plan for one immediately preceding canvas scene.
/// The caller must separately prove that its backing contains that predecessor;
/// this plan grants no authority over a foreign or stale external image.
#[derive(Clone, Copy, Debug)]
pub struct ScrollCopy {
    source: [u16; 4],
    destination: [u16; 4],
    repairs: [DamageRegion; 4],
}
impl ScrollCopy {
    pub fn source(self) -> [u32; 4] {
        self.source.map(u32::from)
    }
    pub fn destination(self) -> [u32; 4] {
        self.destination.map(u32::from)
    }
    pub fn repairs(&self) -> &[DamageRegion; 4] {
        &self.repairs
    }
}

impl CanvasScene<'_> {
    /// Commit complete commands and optionally prove vertical pixel reuse.
    /// `delta` moves old content in device pixels (negative means upwards).
    /// Invalid or unsupported proposals simply return ordinary damage and no copy.
    pub fn commit_with_scroll_damage(
        self,
        viewport: [u32; 4],
        delta: i32,
    ) -> (DamageRegion, Option<ScrollCopy>) {
        let damage = self.pending.damage_from(self.target);
        let copy = certify(self.target, &self.pending, viewport, delta, damage);
        self.commit();
        (damage, copy)
    }
}

fn certify(
    previous: &Canvas,
    next: &Canvas,
    viewport: [u32; 4],
    delta: i32,
    damage: DamageRegion,
) -> Option<ScrollCopy> {
    let [left, top, right, bottom] = viewport;
    if previous.width != next.width
        || previous.height != next.height
        || previous.color_config != next.color_config
        || previous.clear.map(f32::to_bits) != next.clear.map(f32::to_bits)
        || left >= right
        || top >= bottom
        || right > next.width as u32
        || bottom > next.height as u32
        || delta == 0
        || delta.unsigned_abs() >= bottom - top
        || damage.is_empty()
    {
        return None;
    }
    let area = viewport.map(|v| v as i32);
    let destination = intersection(area, translated(area, delta))?;
    let source = translated(destination, -delta);
    let old_scene = previous.prepared_scene();
    let next_scene = next.prepared_scene();
    let mut old = old_scene.draws();
    let mut new = next_scene.draws();
    loop {
        match (
            contribution(&mut old, source, delta).ok()?,
            contribution(&mut new, destination, 0).ok()?,
        ) {
            (None, None) => break,
            (Some(a), Some(b)) if a.equivalent(&b) => {}
            _ => return None,
        }
    }
    Some(ScrollCopy {
        source: source.map(|v| v as u16),
        destination: destination.map(|v| v as u16),
        repairs: subtract(damage, destination),
    })
}

struct Contribution<'a> {
    area: Bounds,
    color: [u32; 4],
    material: Material<'a>,
}
enum Material<'a> {
    Solid,
    Mask {
        rect: [u32; 4],
        translation: [i32; 2],
        mask: GlyphMask<'a>,
    },
}
impl Contribution<'_> {
    fn equivalent(&self, other: &Contribution<'_>) -> bool {
        self.area == other.area
            && self.color == other.color
            && match (&self.material, &other.material) {
                (Material::Solid, Material::Solid) => true,
                (
                    Material::Mask {
                        rect: a,
                        translation: at,
                        mask: am,
                    },
                    Material::Mask {
                        rect: b,
                        translation: bt,
                        mask: bm,
                    },
                ) => {
                    a == b
                        && at == bt
                        && am.key == bm.key
                        && am.width == bm.width
                        && am.height == bm.height
                        && (std::ptr::eq(am.coverage, bm.coverage) || am.coverage == bm.coverage)
                }
                _ => false,
            }
    }
}

fn contribution<'a>(
    draws: &mut impl Iterator<Item = PreparedDraw<'a>>,
    query: Bounds,
    delta: i32,
) -> Result<Option<Contribution<'a>>, ()> {
    for draw in draws {
        let bounds = integer_rect(draw.bounds).ok_or(())?;
        if intersection(bounds, query).is_none() {
            continue;
        }
        // Translation by integer pixels leaves the 4x4 sample lattice exact.
        // With |translation| <= 1e6 and canvas <= 16384, every mapped eighth
        // remains exactly representable in f32 as well as the CPU's f64.
        let [a, b, c, d, x, y] = draw.inverse;
        if [a, b, c, d] != [1., 0., 0., 1.]
            || [x, y]
                .iter()
                .any(|v| v.fract() != 0. || v.abs() > 1_000_000.)
            || draw.clip_chain.is_some()
        {
            return Err(());
        }
        let clip = integer_rect(draw.clip).ok_or(())?;
        let Some(mut area) = intersection(bounds, query).and_then(|a| intersection(a, clip)) else {
            continue;
        };
        let material = match draw.source {
            PreparedSource::Solid => {
                let local = integer_rect(draw.local_rect).ok_or(())?;
                let world = [
                    local[0] - x as i32,
                    local[1] - y as i32,
                    local[2] - x as i32,
                    local[3] - y as i32,
                ];
                let Some(actual) = intersection(area, world) else {
                    continue;
                };
                area = actual;
                Material::Solid
            }
            PreparedSource::Mask(mask) => Material::Mask {
                rect: [
                    draw.local_rect.x,
                    draw.local_rect.y,
                    draw.local_rect.width,
                    draw.local_rect.height,
                ]
                .map(f32::to_bits),
                translation: [x as i32, y as i32 - delta],
                mask,
            },
            _ => return Err(()),
        };
        return Ok(Some(Contribution {
            area: translated(area, delta),
            color: draw.color.map(f32::to_bits),
            material,
        }));
    }
    Ok(None)
}

fn integer_rect(rect: Rect) -> Option<Bounds> {
    let values = [rect.x, rect.y, rect.width, rect.height];
    if values
        .iter()
        .any(|v| !v.is_finite() || v.fract() != 0. || v.abs() > 2_097_152.)
    {
        return None;
    }
    let [x, y, w, h] = values.map(|v| v as i32);
    Some([x, y, x + w, y + h])
}
fn translated([l, t, r, b]: Bounds, dy: i32) -> Bounds {
    [l, t + dy, r, b + dy]
}
fn intersection(a: Bounds, b: Bounds) -> Option<Bounds> {
    let result = [
        a[0].max(b[0]),
        a[1].max(b[1]),
        a[2].min(b[2]),
        a[3].min(b[3]),
    ];
    (result[0] < result[2] && result[1] < result[3]).then_some(result)
}
fn subtract(damage: DamageRegion, excluded: Bounds) -> [DamageRegion; 4] {
    let d = damage.coordinates().map(i32::from);
    let Some(i) = intersection(d, excluded) else {
        return [
            damage,
            DamageRegion::default(),
            DamageRegion::default(),
            DamageRegion::default(),
        ];
    };
    [
        [d[0], d[1], d[2], i[1]],
        [d[0], i[3], d[2], d[3]],
        [d[0], i[1], i[0], i[3]],
        [i[2], i[1], d[2], i[3]],
    ]
    .map(|b| DamageRegion::checked_canvas_bounds(b.map(|v| v as usize)))
}
