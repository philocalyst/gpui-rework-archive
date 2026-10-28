from pathlib import Path
root=Path('/home/user/gpui-line-height-lab/reactivity/crates')
def edit(path, f):
 p=root/path;s=p.read_text();p.write_text(f(s))
def replace(s,a,b,n=None):
 assert a in s,a
 if n is not None:assert s.count(a)==n,(a,s.count(a),n)
 return s.replace(a,b)
edit('gpui/src/style.rs',lambda s:replace(replace(s,'    pub(crate) font_size: f32,','    pub(crate) font_size: f32,\n    pub(crate) line_height: Option<f32>,'),'        font_size: 16.0,','        font_size: 16.0,\n        line_height: None,'))
edit('gpui/src/property.rs',lambda s:replace(replace(s,'    Clip = 14,','    Clip = 14,\n    LineHeight = 15,'),'    FOREGROUND, FOREGROUND_DECL,','    LINE_HEIGHT, LINE_HEIGHT_DECL, Option<f32>, LineHeight, "line_height", Dimension, Layout, line_height, |value: &Option<f32>| value.as_ref().map_or(Ok(()), font_size);\n    FOREGROUND, FOREGROUND_DECL,'))
edit('gpui/src/element.rs',lambda s:replace(s,'    pub fn text_xs(self) -> Self {','''    /// Absolute logical line pitch. The default uses the font's metrics.
    /// Like font size, an explicit pitch must be finite and positive.
    pub fn line_height(mut self, height: impl IntoProp<'a, f64>) -> Self {
        self.property_input::<{ PropertyId::LineHeight as u16 }, false, f64, _>(height);
        self
    }
    pub fn text_xs(self) -> Self {'''))
edit('gpui/src/runtime/styles/colours.rs',lambda s:replace(replace(replace(replace(s,'    font_size: f32,','    font_size: f32,\n    line_height: Option<f32>,'),'            font_size: value.font_size,','            font_size: value.font_size,\n            line_height: value.line_height,'),'            font_size: self.font_size,','            font_size: self.font_size,\n            line_height: self.line_height,'),'            && f32::same(&self.font_size, &other.font_size)','            && f32::same(&self.font_size, &other.font_size)\n            && Option::<f32>::same(&self.line_height, &other.line_height)'))
edit('gpui/src/runtime/styles.rs',lambda s:replace(replace(replace(s,'        && f32::same(&a.font_size, &b.font_size)','        && f32::same(&a.font_size, &b.font_size)\n        && Option::<f32>::same(&a.line_height, &b.line_height)'),'let mut changes = [base; 18];','let mut changes = [base; 19];'),'        changes[17].wrap = true;','        changes[17].wrap = true;\n        changes[18].line_height = Some(20.0);'))
edit('gpui/src/runtime/style_ledger.rs',lambda s:replace(replace(replace(s,'[u32; 24]','[u32; 26]'),'let mut key = [0; 24];','let mut key = [0; 26];'),'        key[18..].copy_from_slice(&affine_key(style.transform));','        key[18..24].copy_from_slice(&affine_key(style.transform));').replace('    key\n}', '    key[24] = u32::from(style.line_height.is_some());\n    key[25] = style.line_height.unwrap_or_default().to_bits();\n    key\n}',1))
# Public shaper retains all old signatures and defaults.
p=root/'canvas/src/text.rs';s=p.read_text();a=s.index('    pub fn measure(\n',s.index("impl<'font> TextShaper"));b=s.index('    fn planner(\n',a)
s=s[:a]+'''    pub fn measure(
        &mut self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
    ) -> Result<TextMetrics, Error> {
        self.measure_with_line_height(text, font_size, max_width, None)
    }
    /// Measure with an optional absolute logical line pitch. None preserves
    /// font metrics. A nonpositive or nonfinite pitch is InvalidGeometry.
    pub fn measure_with_line_height(
        &mut self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
        line_height: Option<f32>,
    ) -> Result<TextMetrics, Error> {
        self.planner(text, font_size, max_width, line_height)?
            .measure(text, font_size, max_width, line_height)
    }
    pub fn shape(
        &mut self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
    ) -> Result<TextLayout, Error> {
        self.shape_with_line_height(text, font_size, max_width, None)
    }
    /// Shape with the same absolute line-pitch rules as measure_with_line_height.
    pub fn shape_with_line_height(
        &mut self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
        line_height: Option<f32>,
    ) -> Result<TextLayout, Error> {
        self.shape_mode(text, font_size, max_width, line_height, false)
    }
    /// Requests original-byte, grapheme-safe caret geometry as cold layout data.
    /// This does not create selection state or advertise native range actions.
    pub fn shape_interactive(
        &mut self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
    ) -> Result<TextLayout, Error> {
        self.shape_interactive_with_line_height(text, font_size, max_width, None)
    }
    /// Shape interactive geometry using the same absolute pitch as measurement
    /// and painting. None preserves the existing font-metric default.
    pub fn shape_interactive_with_line_height(
        &mut self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
        line_height: Option<f32>,
    ) -> Result<TextLayout, Error> {
        self.shape_mode(text, font_size, max_width, line_height, true)
    }
    fn shape_mode(
        &mut self,
        text: &str,
        font_size: f32,
        max_width: Option<f32>,
        line_height: Option<f32>,
        interactive: bool,
    ) -> Result<TextLayout, Error> {
        self.planner(text, font_size, max_width, line_height)?
            .shape(text, font_size, max_width, line_height, interactive)
    }
'''+s[b:]
a=s.index('    fn planner(',a);b=s.index('\n}\n',a);part=s[a:b];part=replace(part,'        max_width: Option<f32>,','        max_width: Option<f32>,\n        line_height: Option<f32>,');part=replace(part,'        if max_width.is_some_and','        if line_height.is_some_and(|height| !height.is_finite() || height <= 0.) {\n            return Err(Error::InvalidGeometry);\n        }\n        if max_width.is_some_and');s=s[:a]+part+s[b:];p.write_text(s)
p=root/'canvas/src/text/planner.rs';s=p.read_text();a=s.index('    pub fn shape(');b=s.index('\nfn freeze_line',a);part=s[a:b];part=part.replace('        max_width: Option<f32>,','        max_width: Option<f32>,\n        line_height: Option<f32>,').replace('(text, size, max_width, interactive)','(text, size, max_width, line_height, interactive)').replace('(text, size, max_width, false)','(text, size, max_width, line_height, false)');part=replace(part,'            builder.push_default(StyleProperty::FontSize(size));','''            builder.push_default(StyleProperty::FontSize(size));
            if let Some(height) = line_height {
                builder.push_default(StyleProperty::LineHeight(parley::LineHeight::Absolute(height)));
            }''');part=replace(part,'        Ok(Planned {','''        if !width.is_finite() || !height.is_finite() || !baseline.is_finite() {
            return Err(Error::InvalidGeometry);
        }
        Ok(Planned {''');s=s[:a]+part+s[b:]
for a,b in [('planner.shape(source, 18., width, true)','planner.shape(source, 18., width, None, true)'),('.shape("first paragraph", 18., Some(40.), true)','.shape("first paragraph", 18., Some(40.), None, true)'),('planner.shape(&"W".repeat(MAX_GLYPHS + 1), 18., None, false)','planner.shape(&"W".repeat(MAX_GLYPHS + 1), 18., None, None, false)'),('planner.measure(&"W".repeat(MAX_GLYPHS + 1), 18., None)','planner.measure(&"W".repeat(MAX_GLYPHS + 1), 18., None, None)'),('planner.shape(source, 18., Some(60.), true)','planner.shape(source, 18., Some(60.), None, true)'),('planner.measure(source, 16., width)','planner.measure(source, 16., width, None)'),('planner.shape(source, 16., width, true)','planner.shape(source, 16., width, None, true)'),('planner.plan::<false>(source, 16., width, false)','planner.plan::<false>(source, 16., width, None, false)')]:s=replace(s,a,b)
p.write_text(s)
# GPUI complete paths and cached shape keys.
p=root/'gpui/src/runtime.rs';s=p.read_text();s=replace(s,'struct Shaped {\n    width: Option<u32>,','struct Shaped {\n    width: Option<u32>,\n    line_height: Option<u32>,')
a=s.index('impl TextSite {');b=s.index('\n}\n',a);part=s[a:b]
part=replace(part,'self.measure_text(service, font_size, input, None)','self.measure_text(service, font_size, None, input, None)')
part=replace(part,'        input: WidthMeasureInput,\n        display:','        line_height: Option<f32>,\n        input: WidthMeasureInput,\n        display:')
part=replace(part,'self.shape_text(service, font_size, width, display)?','self.shape_text(service, font_size, line_height, width, display)?')
part=replace(part,'            && shape.layout.font_size() == font_size','            && shape.layout.font_size() == font_size\n            && shape.line_height == line_height.map(f32::to_bits)')
part=replace(part,'Ok(service.measure(display.unwrap_or(&self.value), font_size, width)?)','Ok(service.measure_with_line_height(display.unwrap_or(&self.value), font_size, width, line_height)?)')
part=replace(part,"    fn shape_for<'n>(","    #[cfg(test)]\n    fn shape_for<'n>(")
part=replace(part,'self.shape_text(service, font_size, width, None)','self.shape_text(service, font_size, None, width, None)')
part=replace(part,'        width: Option<f32>,\n        display:','        line_height: Option<f32>,\n        width: Option<f32>,\n        display:')
part=replace(part,'.is_none_or(|shape| shape.width != key || shape.layout.font_size() != font_size)','.is_none_or(|shape| shape.width != key || shape.layout.font_size() != font_size || shape.line_height != line_height.map(f32::to_bits))')
part=replace(part,'service.shape_interactive(display.unwrap_or(&self.value), font_size, width)?','service.shape_interactive_with_line_height(display.unwrap_or(&self.value), font_size, width, line_height)?')
part=replace(part,'Shaped { width: key, layout }','Shaped { width: key, line_height: line_height.map(f32::to_bits), layout }')
s=s[:a]+part+s[b:]
s=replace(s,'if previous_style.font_size != style.font_size\n','if (previous_style.font_size != style.font_size || previous_style.line_height != style.line_height)\n')
s=replace(s,'if id == crate::property::PropertyId::FontSize\n','if matches!(id, crate::property::PropertyId::FontSize | crate::property::PropertyId::LineHeight)\n')
s=replace(s,'                styles.get(index).font_size,\n','                styles.get(index).font_size,\n                styles.get(index).line_height,\n')
s=replace(s,'                    style.font_size,\n','                    style.font_size,\n                    style.line_height,\n')
s=replace(s,'        || a.font_size != b.font_size','        || a.font_size != b.font_size\n        || a.line_height != b.line_height')
s=replace(s,'if before.font_size != after.font_size {','if before.font_size != after.font_size || before.line_height != after.line_height {');p.write_text(s)
edit('gpui/src/runtime/sparse_text.rs',lambda s:replace(s,'            style.font_size,\n','            style.font_size,\n            style.line_height,\n'))
edit('gpui/src/runtime/editing.rs',lambda s:replace(replace(replace(s,'.unwrap().shape_for(','.unwrap().shape_text('),'                self.styles.get(index).font_size,','                self.styles.get(index).font_size,\n                self.styles.get(index).line_height,'),'                Some(width),\n            )?;','                Some(width),\n                None,\n            )?;'))
edit('gpui/examples/zgx_native_lab.rs',lambda s:replace(replace(s,'        .font_size(14)\n','        .font_size(14)\n        .line_height(20)\n'),'label("zgx performance lab", 920., 28.).font_size(20),','label("zgx performance lab", 920., 28.).font_size(20).line_height(28),'))
