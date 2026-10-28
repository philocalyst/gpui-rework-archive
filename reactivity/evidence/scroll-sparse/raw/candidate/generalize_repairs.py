from pathlib import Path

w = Path('/home/user/gpui-scroll-sparse-lab') / 'reactivity/crates'
def edit(relative, old, new):
    p = w / relative
    s = p.read_text()
    assert s.count(old) == 1, (relative, old, s.count(old))
    p.write_text(s.replace(old, new))

edit('canvas/src/canvas/scroll.rs', '#[derive(Clone, Copy, Debug)]', '#[derive(Debug)]')
edit('canvas/src/canvas/scroll.rs', '    repairs: [DamageRegion; 4],', '    repairs: crate::DamageRegions,')
edit('canvas/src/canvas/scroll.rs', 'pub fn source(self)', 'pub fn source(&self)')
edit('canvas/src/canvas/scroll.rs', 'pub fn destination(self)', 'pub fn destination(&self)')
edit('canvas/src/canvas/scroll.rs', '''    pub fn repairs(&self) -> &[DamageRegion; 4] {
        &self.repairs
    }''', '''    /// At most four pieces per bounded repair region. No returned rectangle
    /// intersects the copied destination, and no extra collection is allocated.
    pub fn repairs(&self) -> impl Iterator<Item = DamageRegion> + '_ {
        let destination = self.destination.map(i32::from);
        self.repairs
            .regions()
            .iter()
            .flat_map(move |&region| subtract(region, destination))
            .filter(|region| !region.is_empty())
    }''')
edit('canvas/src/canvas/scroll.rs', '''        repairs: subtract(damage, destination),''', '''        repairs: outside_damage(previous, next, destination, damage),''')
edit('canvas/src/canvas/scroll.rs', '\nstruct Contribution', '''
// The bounding-repair ablation shares representation, iteration and submission
// with the precise variant; only this derivation differs between alternatives.
fn outside_damage(
    _previous: &Canvas,
    _next: &Canvas,
    _destination: Bounds,
    damage: DamageRegion,
) -> crate::DamageRegions {
    let mut regions = crate::DamageRegions::default();
    regions.include(damage);
    regions
}

struct Contribution''')
edit('canvas/tests/scroll_copy.rs', 'for &repair in plan.repairs()', 'for repair in plan.repairs()')
edit('gpu/src/renderer/scroll_output.rs', 'scroll.repairs().iter().any(|repair| !repair.is_empty())', 'scroll.repairs().next().is_some()')
edit('gpu/src/renderer/retained.rs', '                .repairs()\n                .iter()', '                .repairs()')
edit('gpu/src/renderer/retained.rs', 'for &repair in plan.repairs()', 'for repair in plan.repairs()')
edit('gpui/src/native/scroll_copy_tests.rs', '''                    let copy = damage
                        .scroll''', '''                    let copy = &damage
                        .scroll''')
