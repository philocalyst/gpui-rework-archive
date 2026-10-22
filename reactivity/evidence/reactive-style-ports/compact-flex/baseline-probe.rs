extern crate self as gpui_canvas;
extern crate self as gpui_reactivity_core;
#[derive(Clone,Copy,Debug,PartialEq)]
pub struct Color([u32;4]);
impl Color {pub const fn rgb(_:u8,_:u8,_:u8)->Self{Self([0;4])} pub const fn rgba(_:u8,_:u8,_:u8,_:u8)->Self{Self([0;4])}}
pub fn rgb(_:u32)->Color{Color([0;4])}
#[derive(Clone,Copy,Debug,PartialEq)]
pub struct Affine([f32;6]);
impl Affine {pub const IDENTITY:Self=Self([0.;6]);}
#[path="/tmp/gpui-flex-f019-style.rs"]mod original_style;
fn main(){println!("f019_literal_flex_bytes={}",std::mem::size_of::<original_style::Flex>());}
