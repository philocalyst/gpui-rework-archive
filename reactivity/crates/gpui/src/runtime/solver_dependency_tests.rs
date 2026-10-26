//! Real solver propagation, without a duplicate potential parent/child SCC.
use super::*;
use crate::{column, div, image, text, rgb, Image, ImageProfile, AlphaMode};
use gpui_reactivity_core::change::FullReasons;
const COUNT:usize=128;
const SIZE:[u32;2]=[128,128];
fn solid(red:u8,blue:u8)->Image {Image::rgba8(1,1,ImageProfile::Srgb,AlphaMode::Straight,vec![red,17,blue,255].into_boxed_slice()).unwrap()}
struct Images {current:Image,stable:Image}
impl View for Images {
    fn view(&self)->El<'_> {
        column((0..COUNT).map(|index|image(if index==0{&self.current}else{&self.stable})))
            .w(16).h((COUNT*8) as f32)
    }
}
fn options()->WindowOptions {WindowOptions{size:SIZE,..Default::default()}}
fn ack<M:View+'static>(win:&mut Win<M>){let token=win.with_scene(|_,t|t).unwrap();win.presented(token).unwrap();}
fn pixels<M:View+'static>(win:&mut Win<M>)->Vec<u32>{let mut out=vec![0;SIZE[0] as usize*SIZE[1] as usize];win.render_bgrx(&mut out).unwrap();out}
fn rows<M:View+'static>(win:&Win<M>)->Vec<SnapshotNode>{let mut rows=win.snapshot().unwrap().nodes;for row in &mut rows{row.identity=0;row.target=None;}rows}
#[test]
fn same_metric_image_change_does_not_premark_unrelated_measured_peers() {
    let red=solid(220,17);let blue=solid(17,220);
    let mut win=Win::recording(Images{current:red.clone(),stable:red.clone()},options()).unwrap();ack(&mut win);
    let old=win.snapshot().unwrap().nodes;let before=pixels(&mut win);win.reset_counters().unwrap();
    let answers=win.runtime().unwrap().layout.stats().computed_answers;
    win.update(|model|model.current=blue.clone()).unwrap();
    let work=win.counters();assert_eq!(work.source_operations,1);assert!(work.paint_passes>0);
    let computed=win.runtime().unwrap().layout.stats().computed_answers-answers;
    assert!(computed>0,"the changed intrinsic image owner must enter the actual solver");
    assert!(computed < COUNT as u64/2,"count actual computed answers, not compute invocations; unrelated cached peers must not be premarked: {computed}");
    assert_eq!(win.snapshot().unwrap().nodes,old);ack(&mut win);
    let mut cold=Win::with_options(Images{current:blue,stable:red},options()).unwrap();
    let after=pixels(&mut win);assert_ne!(after,before,"genuine source pixels changed");assert_eq!(after,pixels(&mut cold));assert_eq!(rows(&win),rows(&cold));
    win.with_change_scene(|frame,_|assert!(frame.batch().full.contains(FullReasons::UNKNOWN_DEPENDENCY),"actual solved output feed is not yet a clean sparse-layout claim")).unwrap();
}
struct Wrap {width:Signal<f64>}
impl Wrap {const WIDTH:Source<Self,f64>=Source::new(FieldId::new(1),"width",|m|&m.width,|m|&mut m.width);}
impl View for Wrap {
    fn sources()->Sources<Self>{Sources::new().direct(Self::WIDTH)}
    fn view(&self)->El<'_>{column((text("ordinary paragraph wraps and moves following siblings").font_size(12),div().h(8).bg(rgb(0x4080a0)))).w(&self.width)}
}
#[test]
fn parent_width_child_rewrap_and_sibling_placement_match_full_cold_output() {
    let mut win=Win::recording(Wrap{width:Signal::new(100.)},options()).unwrap();ack(&mut win);
    let initial=pixels(&mut win);
    for width in [40.,80.,100.] {
        win.set(Wrap::WIDTH,width).unwrap();ack(&mut win);
        win.with_change_scene(|frame,_|assert!(frame.batch().full.contains(FullReasons::UNKNOWN_DEPENDENCY))).unwrap();
        let mut cold=Win::with_options(Wrap{width:Signal::new(width)},options()).unwrap();
        assert_eq!(rows(&win),rows(&cold));assert_eq!(pixels(&mut win),pixels(&mut cold));
    }
    assert_eq!(pixels(&mut win),initial);
}
