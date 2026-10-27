from pathlib import Path
p=Path('/home/user/gpui-list-source-lab/reactivity/crates/gpui/src/source.rs');s=p.read_text()
start=s.index('trait Field<M> {');at=s.index('    fn write_text(',start);s=s[:at]+'''    fn offset(&self, model: &mut M, value: Option<f64>) -> Result<Revision, BindError>;
'''+s[at:]
start=s.index("impl<M, T: 'static> Field<M> for Source<M, T> {");at=s.index('    fn write_text(',start);s=s[:at]+'''    fn offset(&self, model: &mut M, value: Option<f64>) -> Result<Revision, BindError> {
        let read = (self.read)(model) as *const Signal<T>;
        let signal = (self.write)(model);
        if !std::ptr::eq(read, signal as *const Signal<T>) {
            return Err(BindError::ProjectionMismatch(self.id));
        }
        let signal = (signal as &mut dyn Any).downcast_mut::<Signal<f64>>()
            .ok_or(BindError::TypeMismatch(self.id))?;
        if let Some(value) = value {
            **signal = value;
        }
        Ok(signal.revision())
    }
'''+s[at:]
start=s.index('trait ComponentSchema<M> {');at=s.index('    fn write_text(',start);s=s[:at]+'''    fn offset(&self, model: &mut M, id: FieldId, value: Option<f64>) -> Result<Revision, BindError>;
'''+s[at:]
start=s.index("impl<M: 'static, C: 'static> ComponentSchema<M> for ComponentEntry<M, C> {");at=s.index('    fn write_text(',start);s=s[:at]+'''    fn offset(&self, model: &mut M, id: FieldId, value: Option<f64>) -> Result<Revision, BindError> {
        self.sources.offset(self.component.project_mut(model)?, self.local(id), value)
    }
'''+s[at:]
at=s.index('    pub(crate) fn write_text(');s=s[:at]+'''    // Closed numeric input operation. None validates exclusive projection/type
    // without mutating the signal revision; Some commits one requested offset.
    pub(crate) fn offset(&self, model: &mut M, id: FieldId, value: Option<f64>) -> Result<Revision, BindError> {
        self.check_schema()?;
        if id.scope() == 0 {
            self.get(id)?.offset(model, value)
        } else {
            self.component_for(id)?.offset(model, id, value)
        }
    }
'''+s[at:];p.write_text(s)
