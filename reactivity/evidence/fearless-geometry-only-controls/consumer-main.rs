use gpui_canvas::{Affine, AlphaMode, Canvas, Color, ColorConfig, Image, ImageSampling, OutputProfile, Point, Rect, TextSystem};
use std::hint::black_box;
fn digest(bytes: &[u8]) -> u64 { bytes.iter().fold(0, |h: u64, &b| h.wrapping_mul(16777619) ^ u64::from(b)) }
fn main() {
    let mut blank=None;
    let construction=allocation_counter::measure(|| { blank=Some(Canvas::recording(33,17,ColorConfig::default()).unwrap()); });
    let mut blank=blank.unwrap();
    let header=std::mem::size_of_val(&blank);
    let first=allocation_counter::measure(|| { black_box(blank.pixels()); });
    blank.set_tile_proofs(false);
    let warm=allocation_counter::measure(|| { black_box(blank.pixels()); });
    println!("blank header={header} construction={}:{} first={}:{} warm={}:{} output={} hash={}",construction.count_total,construction.bytes_total,first.count_total,first.bytes_total,warm.count_total,warm.bytes_total,blank.output_bytes(),digest(blank.pixels()));
    let mut text=TextSystem::bundled().unwrap();
    let label=text.shape("Ag café",9.5,None).unwrap();
    let image=Image::linear_srgb(2,2,AlphaMode::Premultiplied,vec![[0.25,-0.125,1.5,0.5],[0.0;4],[-0.0,0.25,1.0,1.0],[1.0,0.0,0.5,0.75]].into_boxed_slice()).unwrap();
    for hdr in [false,true] {
        let config=if hdr {ColorConfig::linear_hdr(OutputProfile::Srgb,203.0).unwrap()}else{ColorConfig::default()};
        let mut canvas=Canvas::recording(33,17,config).unwrap();
        canvas.clear(Color::WHITE);
        let clip=Rect::new(0.125,0.375,32.5,16.5);
        let map=Affine{a:1.0,b:0.125,c:-0.25,d:0.9,tx:3.125,ty:1.375};
        canvas.fill_rect(Rect::new(0.125,0.375,18.75,13.25),map,clip,Color::oklch(0.7,0.3,137.5,0.625).unwrap()).unwrap();
        canvas.fill_rounded_rect(Rect::new(0.375,0.125,14.25,12.75),3.25,map,clip,Color::linear_srgb(2.5,-0.125,0.3,0.75).unwrap()).unwrap();
        canvas.draw_image(&image,Rect::new(0.125,0.375,11.75,9.25),map,clip,ImageSampling::Linear).unwrap();
        canvas.draw_text(&mut text,&label,Point{x:1.125,y:7.375},Affine::IDENTITY,clip,Color::rgba(17,91,137,193)).unwrap();
        let first=allocation_counter::measure(||{black_box(canvas.pixels());});
        canvas.set_tile_proofs(false);
        let warm=allocation_counter::measure(||{black_box(canvas.pixels());});
        println!("scene hdr={hdr} first={}:{} warm={}:{} output={} hash={}",first.count_total,first.bytes_total,warm.count_total,warm.bytes_total,canvas.output_bytes(),digest(canvas.pixels()));
        if !hdr { let mut bgrx=vec![0;33*17]; canvas.render_bgrx(&mut bgrx).unwrap(); println!("bgrx hash={}",bgrx.iter().fold(0u64,|h,&v|h.wrapping_mul(16777619)^u64::from(v))); }
    }
}
