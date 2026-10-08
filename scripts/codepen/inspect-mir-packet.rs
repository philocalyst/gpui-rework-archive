#![feature(rustc_private)]
extern crate rustc_driver;
extern crate rustc_serialize;
extern crate rustc_span;
use rustc_serialize::{Decodable, opaque::MemDecoder};
use rustc_span::def_id::{DefPathHash, StableCrateId};
fn main() {
    for path in std::env::args().skip(1) {
        let bytes = std::fs::read(&path).unwrap();
        let mut decoder = MemDecoder::new(&bytes, 0).unwrap();
        let format = String::decode(&mut decoder);
        let cross = bool::decode(&mut decoder);
        let origin = StableCrateId::decode(&mut decoder);
        let root_hash = Option::<String>::decode(&mut decoder);
        let keys = Vec::<DefPathHash>::decode(&mut decoder);
        let contract = Vec::<u8>::decode(&mut decoder);
        println!("{path}: {format}; cross={cross}; origin={origin:?}; root={root_hash:?}; keys={keys:?}; contract={} bytes", contract.len());
        std::fs::write(format!("{path}.contract"), contract).unwrap();
    }
}
