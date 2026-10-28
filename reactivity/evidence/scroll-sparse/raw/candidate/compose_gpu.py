from pathlib import Path
w=Path('/home/user/gpui-scroll-sparse-lab');old=Path('/home/user/gpui-scroll-output-lab')
def edit(path,a,b):
 p=w/path;s=p.read_text();assert s.count(a)==1,(path,a,s.count(a));p.write_text(s.replace(a,b))
for p in ['reactivity/crates/canvas/src/canvas/scroll.rs','reactivity/crates/canvas/tests/scroll_copy.rs','reactivity/crates/gpu/src/renderer/scroll_output.rs']:
 assert not (w/p).exists();(w/p).write_bytes((old/p).read_bytes())
edit('reactivity/crates/canvas/src/canvas.rs','mod samples;','mod samples;\nmod scroll;\npub use scroll::ScrollCopy;')
edit('reactivity/crates/canvas/src/lib.rs','RenderStats, SceneStorage,','RenderStats, SceneStorage, ScrollCopy,')
edit('reactivity/crates/gpu/src/renderer.rs','mod retained;','mod retained;\nmod scroll_output;')
p='reactivity/crates/gpu/src/renderer/retained.rs'
edit(p,'use gpui_canvas::{DamageRegion, DamageRegions, SlotEdit};','use gpui_canvas::{DamageRegion, DamageRegions, ScrollCopy, SlotEdit};')
edit(p,'/// Work and explicit image storage of the last successful retained submission.', '''struct ScrollOutput<'a> {
    output: Output<'a>,
    scroll: &'a ScrollCopy,
}
impl Submission for ScrollOutput<'_> {
    #[inline(always)]
    fn view(&self) -> &wgpu::TextureView {
        self.output.view
    }
    #[inline(always)]
    fn submit(self, context: &GpuContext, bindings: &wgpu::BindGroup) -> wgpu::SubmissionIndex {
        context.submit_scroll(self.output, bindings, self.scroll)
    }
}

/// Work and explicit image storage of the last successful retained submission.''')
edit(p,'    /// Repair separated regions certified against the preceding retained image.', '''    /// Copy a proved overlap from the exact preceding image and repair the rest.
    /// The caller must bind the plan to that image. First use/resize/missing image
    /// authority falls back to full rendering, after validating the proposed bounds.
    pub fn render_with_scroll(
        &mut self,
        scene: PreparedScene<'_>,
        target: &wgpu::TextureView,
        damage: Option<DamageRegion>,
        scroll: Option<&ScrollCopy>,
    ) -> Result<wgpu::SubmissionIndex, Error> {
        let Some(scroll) = scroll else {
            return self.render(scene, target, damage);
        };
        let size = [scene.width, scene.height];
        let valid = self.backing.as_ref().is_some_and(|b| b.valid)
            && self.inner.state.packet.is_some();
        if let Some(backing) = &mut self.backing {
            backing.valid = false;
        }
        if size.contains(&0)
            || size.iter().any(|&n| n > 16_384)
            || u64::from(size[0]) * u64::from(size[1]) > MAX_PIXELS as u64
        {
            return Err(Error::ResourceLimit);
        }
        check_target(target, size, self.inner.format())?;
        check_damage(damage, size)?;
        check_scroll(scroll, size)?;
        if !valid || self.backing.as_ref().is_none_or(|b| b.size() != size) {
            return self.render(scene, target, None);
        }
        let backing = self.backing.as_mut().unwrap();
        backing.prepare_scroll(&self.inner.context, scroll);
        let submitted = self.inner.state.render_observed(
            &self.inner.context,
            scene,
            ScrollOutput { output: backing.output(target, None), scroll },
            |_, _, _, _| {},
        )?;
        backing.valid = true;
        let [l, t, r, b] = scroll.source();
        self.stats = RetainedStats {
            composited_pixels: scroll.repairs().iter().map(|r| r.bounds().map_or(0, |[l,t,r,b]| u64::from(r-l) * u64::from(b-t))).sum(),
            ..backing.stats(None)
        };
        self.stats.copied_pixels += 2 * u64::from(r-l) * u64::from(b-t);
        Ok(submitted)
    }
    /// Repair separated regions certified against the preceding retained image.''')
edit(p,'pub(super) struct Backing {','''fn check_scroll(plan: &ScrollCopy, size: [u32; 2]) -> Result<(), Error> {
    let [l, t, r, b] = plan.source();
    let [dl, dt, dr, db] = plan.destination();
    if l >= r || t >= b || dl >= dr || dt >= db
        || r > size[0] || b > size[1] || dr > size[0] || db > size[1]
        || r-l != dr-dl || b-t != db-dt
    {
        return Err(Error::InvalidScene);
    }
    for &repair in plan.repairs() { check_damage(Some(repair), size)?; }
    Ok(())
}

pub(super) struct Backing {''')
edit(p,'    valid: bool,','    valid: bool,\n    scratch: Option<Box<wgpu::Texture>>,')
edit(p,'            valid: false,','            valid: false,\n            scratch: None,')
edit(p,'usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::TEXTURE_BINDING,','usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::TEXTURE_BINDING | wgpu::TextureUsages::COPY_SRC | wgpu::TextureUsages::COPY_DST,')
edit(p,'            image_bytes: pixels\n','            image_bytes: (pixels + self.scratch.as_ref().map_or(0, |s| u64::from(s.width()) * u64::from(s.height())))\n')
old_text=(old/p).read_text();a=old_text.index('    fn prepare_scroll(');b=old_text.index('    pub(super) fn copy(',a);methods=old_text[a:b]
# Bounds are already checked before the full-render fallback as well as allocation.
head=methods.index('        let requested = [r - l, b - t];');methods='''    fn prepare_scroll(&mut self, context: &GpuContext, plan: &ScrollCopy) {
        let [l, t, r, b] = plan.source();
'''+methods[head:]
methods=methods.replace('Some(context.device().create_texture(&wgpu::TextureDescriptor {','Some(Box::new(context.device().create_texture(&wgpu::TextureDescriptor {').replace('            }));','            })));',1).replace('        Ok(())\n','',1)
edit(p,'    pub(super) fn copy(',methods+'    pub(super) fn copy(')
# Add the historical public-interface oracle to the current corrected suite.
p='reactivity/crates/gpu/tests/render.rs';s=(old/p).read_text();marker='#[test]\nfn retained_scroll_copy_matches_full_gpu_and_invalidates_after_failure_or_resize()';assert s.count(marker)==1;addition=s[s.index(marker):].split('\n#[test]',1)[0]+'\n';assert not marker in (w/p).read_text();(w/p).write_text((w/p).read_text()+'\n'+addition)
