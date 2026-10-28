#[path = "support/graphics.rs"]
mod graphics;
#[path = "support/todos.rs"]
mod todos;
#[path = "support/workspace.rs"]
mod workspace;

fn main() -> Result<(), gpui::Error> {
    let mut win = gpui::Win::new(workspace::Workspace::default())?;
    win.__route_census("workspace_initial")?;
    let _ = win.inspect()?;
    win.click(win.button("Add"))?;
    win.__route_census("workspace_after_add_click")?;
    Ok(())
}
