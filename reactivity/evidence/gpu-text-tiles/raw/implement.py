from pathlib import Path
r=Path('/home/user/gpui-gpu-text-tiles-lab/reactivity/crates/gpu/src')
p=r/'renderer.rs';s=p.read_text();a='''    fn submit(&self, output: Output<'_>, bindings: &wgpu::BindGroup) -> wgpu::SubmissionIndex {
        let mut encoder''';b='''    fn submit(&self, output: Output<'_>, bindings: &wgpu::BindGroup) -> wgpu::SubmissionIndex {
        self.submit_regions(output, bindings, None)
    }
    fn submit_regions(
        &self,
        output: Output<'_>,
        bindings: &wgpu::BindGroup,
        regions: Option<&[[u32; 4]]>,
    ) -> wgpu::SubmissionIndex {
        let mut encoder''';assert a in s;s=s.replace(a,b)
s=s.replace('''        if output.damage.is_none_or(|damage| !damage.is_empty()) {''','''        if regions.map_or_else(
            || output.damage.is_none_or(|damage| !damage.is_empty()),
            |regions| !regions.is_empty(),
        ) {''')
a='''            if let Some([left, top, right, bottom]) = output.damage.and_then(|d| d.bounds()) {
                pass.set_scissor_rect(left, top, right - left, bottom - top);
            }
            pass.set_pipeline(&self.pipeline);
            pass.set_bind_group(0, bindings, &[]);
            pass.draw(0..3, 0..1);'''
b='''            pass.set_pipeline(&self.pipeline);
            pass.set_bind_group(0, bindings, &[]);
            if let Some(regions) = regions {
                for &[left, top, right, bottom] in regions {
                    pass.set_scissor_rect(left, top, right - left, bottom - top);
                    pass.draw(0..3, 0..1);
                }
            } else {
                if let Some([left, top, right, bottom]) = output.damage.and_then(|d| d.bounds()) {
                    pass.set_scissor_rect(left, top, right - left, bottom - top);
                }
                pass.draw(0..3, 0..1);
            }''';assert a in s;s=s.replace(a,b);p.write_text(s)
p=r/'renderer/text_packet.rs';s=p.read_text().replace('''    words: Vec<Word>,
}''','''    words: Vec<Word>,
    common_changed: bool,
}
impl Patch {
    fn changes(&self, address: u32, old: &[Word]) -> bool {
        if !self.run.contains(address) {
            return false;
        }
        let offset = 5 + (address - self.run.word.get()) as usize;
        self.common_changed
            || self.words[offset..offset + 2] != old[address as usize..address as usize + 2]
    }
}
// Rows are disjoint. Cap command count; overflow uses the original damage.
fn append_region(regions: &mut Option<Vec<[u32; 4]>>, rect: [u32; 4], damage: [u32; 4]) {
    let [l, t, r, b] = [rect[0].max(damage[0]), rect[1].max(damage[1]),
        rect[2].min(damage[2]), rect[3].min(damage[3])];
    if l >= r || t >= b {
        return;
    }
    let Some(spans) = regions else { return };
    if let Some(last) = spans.last_mut()
        && last[1] == t && last[3] == b && last[2] == l
    {
        last[2] = r;
    } else if spans.len() == 256 {
        *regions = None;
    } else {
        spans.push([l, t, r, b]);
    }
}''')
s=s.replace(''') -> Result<wgpu::SubmissionIndex, TextPacketError> {''',''') -> Result<(wgpu::SubmissionIndex, u64), TextPacketError> {''')
s=s.replace('''        patches.push(Patch { slot, run, words });''','''        let common_changed = words[..5] != state.records[common..word];
        patches.push(Patch { slot, run, words, common_changed });''')
s=s.replace('''    let mut cursor = 0;
    for (tile,''','''    let mut cursor = 0;
    let damage_bounds = output.damage.and_then(|d| d.bounds());
    let mut regions = output.damage.map(|_| Vec::new());
    for (tile,''')
a='''        next_ranges.push([offset as u32, next_references.len() as u32]);
    }'''
b='''        next_ranges.push([offset as u32, next_references.len() as u32]);
        if regions.is_some() && let Some(damage) = damage_bounds {
            let old = if end == UNIFORM_TILE {
                std::slice::from_ref(&start)
            } else {
                &state.references[start as usize..end as usize]
            };
            let next = &next_references[offset..];
            // Both memberships matter: a moved glyph can leave an empty tile.
            // Equal lists only need repaint when a referenced record changed.
            let dirty = old != next || old.iter().chain(next).any(|&address| {
                patches.iter().any(|p| p.changes(address, &state.records))
            });
            if dirty {
                append_region(&mut regions, tile_bounds(tile, columns, width, height), damage);
            }
        }
    }''';assert a in s;s=s.replace(a,b)
a='''    // No semantic validation remains. Revoke replay before the first queue write.''';b='''    let area = |[l, t, r, b]: [u32; 4]| u64::from(r - l) * u64::from(b - t);
    let composited_pixels = regions.as_ref().map_or_else(
        || output.damage.map_or(u64::from(width) * u64::from(height),
            |_| damage_bounds.map_or(0, area)),
        |regions| regions.iter().copied().map(area).sum(),
    );
    // No semantic validation remains. Revoke replay before the first queue write.''';assert a in s;s=s.replace(a,b)
s=s.replace('''    let submitted = context.submit(output, &packet.bindings);''','''    let submitted = context.submit_regions(output, &packet.bindings, regions.as_deref());''').replace('''    Ok(submitted)
}''','''    Ok((submitted, composited_pixels))
}''');p.write_text(s)
p=r/'renderer/retained.rs';s=p.read_text().replace('''        let submitted = text_packet::patch(''','''        let (submitted, composited_pixels) = text_packet::patch(''');a='''            backing.output(target, damage),
        )?;
        self.stats = backing.stats(damage);
        Ok(submitted)''';b='''            backing.output(target, damage),
        )?;
        self.stats = backing.stats(damage);
        self.stats.composited_pixels = composited_pixels;
        Ok(submitted)''';assert a in s;s=s.replace(a,b);p.write_text(s)
