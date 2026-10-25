trait ComponentRender: 'static {}
struct Component<C: ComponentRender>(C);
struct Borrowed<'a>(&'a mut usize);
impl ComponentRender for Borrowed<'static> {}
fn wrap<'a>(value: &'a mut usize) -> Component<Borrowed<'a>> {
    Component(Borrowed(value))
}
