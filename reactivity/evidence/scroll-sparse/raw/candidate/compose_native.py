from pathlib import Path
w=Path('/home/user/gpui-scroll-sparse-lab');old=Path('/home/user/gpui-scroll-output-lab')
def edit(path,a,b):
 p=w/path;s=p.read_text();assert s.count(a)==1,(path,a,s.count(a));p.write_text(s.replace(a,b))
p='reactivity/crates/gpui/src/runtime/scroll.rs';s=(old/p).read_text();a=s.index('    #[cfg(feature = "native-core")]\n    pub fn scroll_copy_proposal(');b=s.index('    #[cfg(feature = "accessibility")]',a);edit(p,'impl ViewportBuild {','impl ViewportBuild {\n'+s[a:b])
p='reactivity/crates/gpui/src/runtime/paint.rs';edit(p,'/// Damage relative to the exact acknowledged image, including unbound changes.','''#[cfg(feature = "native-core")]
pub(crate) struct ScrollTransition {
    pub(crate) from: PresentationToken,
    pub(crate) to: PresentationToken,
    pub(crate) copy: gpui_canvas::ScrollCopy,
}

/// Damage relative to the exact acknowledged image, including unbound changes.''')
edit(p,"    pub(crate) repair: Option<&'a TextRepair>,","    pub(crate) repair: Option<&'a TextRepair>,\n    pub(crate) scroll: Option<&'a ScrollTransition>,")
edit(p,'            SceneDamage {\n                repair:','''            SceneDamage {
                scroll: runtime.metadata.as_ref()
                    .and_then(|metadata| metadata.scroll_copy.as_deref())
                    .filter(|scroll| scroll.to == token),
                repair:''')
p='reactivity/crates/gpui/src/runtime/metadata.rs';edit(p,'    pub geometry: Option<Box<super::geometry::Geometry>>,','''    pub geometry: Option<Box<super::geometry::Geometry>>,
    #[cfg(feature = "native-core")]
    pub scroll_copy: Option<Box<super::paint::ScrollTransition>>,''')
p='reactivity/crates/gpui/src/runtime.rs';s=(old/p).read_text();a=s.index('        #[cfg(feature = "native-core")]\n        let scroll_proposal = if list_mode');b=s.index('        let geometry_sheet = self',a);edit(p,'        let logical_indices = &self.by_identity;\n        let geometry_sheet = self','        let logical_indices = &self.by_identity;\n'+s[a:b]+'        let geometry_sheet = self')
a=s.index('        #[cfg(feature = "native-core")]\n        let mut scroll_copy = None;');b=s.index('        for (&key, state) in &mut self.viewports {',a);replacement=s[a:b]
pth=w/p;current=pth.read_text();start=current.index('        let damage = if self.automatic_presentation {');end=current.index('        for (&key, state) in &mut self.viewports {',start);pth.write_text(current[:start]+replacement+current[end:])
p='reactivity/crates/gpui/src/native.rs';edit(p,'''        } else {
            self.renderer.render(scene, target, damage)?
        };
        self.packet_token = Some(token);''','''        } else if let Some(scroll) = valid_transition
            .and_then(|d| d.scroll)
            .filter(|scroll| previous == Some(scroll.from) && token == scroll.to)
        {
            self.renderer.render_with_scroll(scene, target, damage, Some(&scroll.copy))?
        } else {
            self.renderer.render(scene, target, damage)?
        };
        self.packet_token = Some(token);''')
p='reactivity/crates/gpui/src/native/scroll_copy_tests.rs';assert not (w/p).exists();s=(old/p).read_text();s=s.replace('        gpu.packet_epoch = None;\n','').replace('    gpu.packet_epoch = None;\n','');assert 'packet_epoch' not in s;(w/p).write_text(s)
p='reactivity/crates/gpui/src/native/paint_tests.rs';edit(p,'use super::*;','use super::*;\n#[path = "scroll_copy_tests.rs"]\nmod scroll_copy_tests;');s=(w/p).read_text();assert s.endswith('    }\n}\n');(w/p).write_text(s[:-2]+'    scroll_copy_tests::run(gpu);\n}\n')
