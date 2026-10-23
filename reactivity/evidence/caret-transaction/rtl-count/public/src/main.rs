use gpui::prelude::*;
use gpui::{CaretAffinity, Rect, TextOffset, TextPosition, Win, WindowOptions};
use std::{fs::File, io::{BufWriter, Write}};

struct Page {
    value: Signal<String>,
    width: f64,
    mode: u8,
}
impl Page {
    const VALUE: Source<Self, String> = Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);
}
impl View for Page {
    fn sources() -> Sources<Self> { Sources::new().direct(Self::VALUE) }
    fn view(&self) -> El<'_> {
        match self.mode {
            0 => row((text(self.value.as_str()).w(self.width), div().size(4))),
            1 => column((text(self.value.as_str()), div().size(4))).w(self.width),
            _ => text_input(&self.value).w(self.width).p(3),
        }
    }
}
fn word(out: &mut impl Write, value: usize) { out.write_all(&(value as u64).to_le_bytes()).unwrap(); }
fn bytes(out: &mut impl Write, value: &[u8]) { word(out,value.len());out.write_all(value).unwrap(); }
fn floats(out: &mut impl Write, values: impl IntoIterator<Item=f32>) {
    for value in values { out.write_all(&value.to_bits().to_le_bytes()).unwrap(); }
}
fn rect(out: &mut impl Write, r: Rect) { floats(out,[r.x,r.y,r.width,r.height]); }
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut out=BufWriter::new(File::create(std::env::args().nth(1).expect("output path"))?);
    let mut cases=Vec::new();
    for value in ["", "a", "office ffi café words", "אבג العربية office", "a\r\n\r\nb\n", "a\u{2028}b\u{2028}", "a\u{2067}אב12\u{2069}z", "漢", "a\u{fe0f}"] {
        for width in [0.,40.,400.] {
            for mode in 0..3 { cases.push((value.to_owned(),width,mode)); }
        }
    }
    cases.push(("a".repeat(32*1024),400.,0));
    cases.push((format!("a{}","\u{301}".repeat(1024)),40.,2));
    word(&mut out,cases.len());
    for (value,width,mode) in cases {
        bytes(&mut out,value.as_bytes());floats(&mut out,[width as f32]);word(&mut out,mode as usize);
        let mut win=match Win::recording(Page{value:Signal::new(value),width,mode},WindowOptions::default()) {
            Ok(win)=>{word(&mut out,1);win}
            Err(error)=>{word(&mut out,0);bytes(&mut out,format!("{error:?}").as_bytes());continue}
        };
        let token=win.with_scene(|scene,token| {
            word(&mut out,scene.draws().len());
            for draw in scene.draws() {
                rect(&mut out,draw.local_rect);rect(&mut out,draw.clip);rect(&mut out,draw.bounds);floats(&mut out,draw.color);
                for value in draw.inverse { out.write_all(&value.to_bits().to_le_bytes()).unwrap(); }
                if let Some(mask)=draw.source.mask() {word(&mut out,1);word(&mut out,mask.width);word(&mut out,mask.height);bytes(&mut out,mask.coverage)} else {word(&mut out,0)}
            }
            token
        })?;
        win.presented(token)?;
        let mut semantic=Vec::new();win.semantics()?.write_json(&mut semantic)?;bytes(&mut out,&semantic);
        win.visit(|part| {
            word(&mut out,1);
            if let Some(geometry)=part.text_geometry() {
                word(&mut out,1);let map=geometry.layout();word(&mut out,map.text_len());
                for byte in 0..=map.text_len() {
                    for affinity in [CaretAffinity::Upstream,CaretAffinity::Downstream] {
                        let position=TextPosition{offset:TextOffset::new(byte).unwrap(),affinity};
                        if let Some(bounds)=map.caret_bounds(position) {word(&mut out,1);rect(&mut out,bounds);word(&mut out,map.caret_line(position).unwrap())} else {word(&mut out,0)}
                    }
                }
            } else {word(&mut out,0)}
        })?;
        word(&mut out,0);
    }
    out.flush()?;Ok(())
}
