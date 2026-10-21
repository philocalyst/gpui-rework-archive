use zbus::connection::Builder;
struct Status;
#[zbus::interface(name = "org.a11y.Status")]
impl Status {
    #[zbus(property)] fn is_enabled(&self) -> bool { false }
    #[zbus(property)] fn screen_reader_enabled(&self) -> bool { false }
}
async fn serve() -> zbus::Result<()> {
    let _conn = Builder::session()?.name("org.a11y.Bus")?.serve_at("/org/a11y/bus", Status)?.build().await?;
    println!("ready");
    std::future::pending::<()>().await;
    Ok(())
}
fn main() { tokio::runtime::Builder::new_current_thread().enable_io().enable_time().build().unwrap().block_on(serve()).unwrap(); }
