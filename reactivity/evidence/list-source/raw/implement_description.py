from pathlib import Path
base=Path('/home/user/gpui-list-source-lab/reactivity/crates/gpui/src')
p=base/'list.rs';s=p.read_text();old='''    pub map: Option<RowMap>,
    pub overscan: usize,
}''';assert old in s;s=s.replace(old,'''    pub options: Option<Box<ListOptions<'a>>>,
}
#[derive(Default)]
pub(crate) struct ListOptions<'a> {
    pub map: Option<RowMap>,
    pub overscan: usize,
    pub offset: Option<&'a crate::Signal<f64>>,
}
impl<'a> ListSpec<'a> {
    pub fn options_mut(&mut self) -> &mut ListOptions<'a> {
        self.options.get_or_insert_with(Default::default)
    }
}''').replace('pub(crate) struct ListPlan {','pub(crate) struct ListPlan {\n    pub offset_field: Option<crate::FieldId>,');p.write_text(s)
p=base/'element.rs';s=p.read_text().replace('                map: None,\n                overscan: 0,','                options: None,').replace('spec.overscan = rows;','spec.options_mut().overscan = rows;')
at='    /// Uniform circular corners for this element\'s background';assert at in s;s=s.replace(at,'''    /// Control a uniform list with a registered offset source. The source is
    /// the absolute requested position; layout clamps it to the viewport. Wheel
    /// and public scroll operations write their clamped offset back to the same
    /// source. Ignored on other elements; the source borrow ends with description.
    pub fn scroll_offset(mut self, offset: &'a crate::Signal<f64>) -> Self {
        if let Some(spec) = self.extra.as_deref_mut().and_then(|extra| extra.list_mut()) {
            spec.options_mut().offset = Some(offset);
        }
        self
    }

'''+at)
s=s.replace('                let previous = spec.map.take();','                let options = spec.options_mut();\n                let previous = options.map.take();').replace('                spec.map = Some(Box::new(move |row:', '                options.map = Some(Box::new(move |row:')
s=s.replace('|_, _, _, _, _| {\n            Err(crate::ListError::MissingViewport)','|_, _, _, _, _, _, _| {\n            Err(crate::ListError::MissingViewport.into())')
s=s.replace('''        mut plan: impl FnMut(
            crate::ListId,''','''        mut plan: impl FnMut(
            usize,
            crate::ListId,''').replace('''            usize,
        ) -> Result<crate::list::ListPlan, crate::ListError>,''','''            usize,
            Option<&crate::Signal<f64>>,
        ) -> Result<crate::list::ListPlan, crate::Error>,''')
s=s.replace('''                let mut list_plan = plan(
                    spec.id,''','''                let options = spec.options.as_deref();
                let mut list_plan = plan(
                    index as usize,
                    spec.id,''').replace('''                    spec.overscan,
                )?;''','''                    options.map_or(0, |options| options.overscan),
                    options.and_then(|options| options.offset),
                )?;''').replace('if let Some(map) = &spec.map {','if let Some(map) = options.and_then(|options| options.map.as_ref()) {');p.write_text(s)
p=base/'runtime/list.rs';s=p.read_text().replace('    pub identity: u64,','    pub identity: u64,\n    pub offset_field: Option<FieldId>,',1).replace('    Ok(ListPlan {','    Ok(ListPlan {\n        offset_field: None,');p.write_text(s)
p=base/'runtime.rs';s=p.read_text().replace('|id, style, source, row_height, overscan| {','|node, id, style, source, row_height, overscan, offset| {').replace('return Err(ListError::DuplicateList(id));','return Err(ListError::DuplicateList(id).into());')
needle='''                let previous = previous.map(|(_, state)| state);
                list::plan(''';assert needle in s;s=s.replace(needle,'''                let previous = previous.map(|(_, state)| state);
                let offset_field = offset.map(|signal| {
                    self.sources.resolve(&self.model, signal)?
                        .ok_or(Error::UnregisteredInput { node })
                }).transpose()?;
                if offset.is_some_and(|offset| !offset.is_finite() || offset.abs() > (1_u64 << 40) as f64) {
                    return Err(ListError::InvalidDelta.into());
                }
                let mut plan = list::plan(''')
needle='''                        .map(|request| request.position),
                )
            },''';assert needle in s;s=s.replace(needle,'''                        .map(|request| request.position)
                        .or_else(|| offset.map(|offset| list::ScrollPosition::Offset(**offset))),
                )?;
                plan.offset_field = offset_field;
                Ok(plan)
            },''')
s=s.replace('''                ViewportState::List(ListState {
                    identity,''','''                ViewportState::List(ListState {
                    identity,
                    offset_field: draft.plan.offset_field,''');p.write_text(s)
p=base/'runtime/turn.rs';s=p.read_text().replace('''                    && !questions_changed
                    && !self.runtime.sources.invalidates_owner(field)?''','''                    && !questions_changed
                    && !self.runtime.list_offset_depends_on(field)
                    && !self.runtime.sources.invalidates_owner(field)?''');p.write_text(s)
p=base/'runtime/scroll.rs';s=p.read_text();needle='''    pub(super) fn list_by_id(&self, id: ListId)''';assert needle in s;s=s.replace(needle,'''    pub(super) fn list_offset_depends_on(&self, field: FieldId) -> bool {
        self.viewports.iter().take_while(|(key, _)| matches!(key, ViewportKey::List(_)))
            .any(|(_, state)| state.list().is_some_and(|list| list.offset_field == Some(field)))
    }
    pub(super) fn list_by_id(&self, id: ListId)''');p.write_text(s)
p=base/'runtime/background.rs';s=p.read_text().replace('|_, _, _, _, _| unreachable!()','|_, _, _, _, _, _, _| unreachable!()');p.write_text(s)
