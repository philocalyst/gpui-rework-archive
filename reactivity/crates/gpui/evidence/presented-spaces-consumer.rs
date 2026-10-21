//! Ordinary downstream consumer used to inspect borrowed geometry codegen.
use gpui::{Affine, Color, El, View, Win, column, div};
struct Panels { count: usize, mode: u8 }
impl View for Panels {
    fn view(&self) -> El<'_> {
        column((0..self.count).map(|index| {
            let a=match self.mode {0=>1.0,1=>1.0+(index%2) as f32,_=>1.0+index as f32};
            div().size(1).bg(Color::BLACK).transform(Affine::scale(a,1.0))
        }))
    }
}
#[inline(never)]
fn inspect(window: &Win<Panels>) -> usize {
    let mut count=0;
    window.visit(|part| {
        std::hint::black_box((part.transform(),part.local_bounds(),part.unclipped_bounds()));
        count+=1;
    }).unwrap();
    count
}
fn main() {
    let count=std::env::args().nth(1).map(|arg|arg.parse().unwrap()).unwrap_or(128);
    for mode in 0..3 {
        let window=Win::with_size(Panels {count,mode},64,64).unwrap();
        println!("consumer,{mode},{}",inspect(&window));
    }
}
