use accesskit::{Node, Role};
fn main() {
    println!("case,units,escapes,source_bytes,construct_allocations,construct_retained,construct_peak,construct_total,clone_allocations,clone_retained,u32_payload_allocations,u32_payload_retained");
    for (name, units) in [("ordinary",vec![1u32;1024]),("mixed",{let mut v=vec![1u32;1024];v[511]=401;v}),("huge",vec![8193u32])] {
        let mut value=String::new();
        for &n in &units {
            if n==1 { value.push('x'); }
            else { value.push('a'); value.extend(std::iter::repeat_n('\u{301}',(n as usize-1)/2)); }
        }
        let source_bytes=value.len();
        let mut node=Node::new(Role::TextRun);
        node.set_value(value);
        let construct=allocation_counter::measure(|| assert!(node.set_text_character_lengths(units.iter().copied())));
        let mut cloned=None;
        let clone=allocation_counter::measure(|| cloned=Some(node.clone()));
        let mut widened=None;
        let full_u32=allocation_counter::measure(|| widened=Some(units.clone()));
        assert_eq!(node.decoded_character_lengths().unwrap().collect::<Vec<_>>(),units.iter().map(|&n|n as usize).collect::<Vec<_>>());
        println!("{name},{},{},{source_bytes},{},{},{},{},{},{},{},{}",units.len(),units.iter().filter(|&&n|n>255).count(),construct.count_total,construct.bytes_current,construct.bytes_max,construct.bytes_total,clone.count_total,clone.bytes_current,full_u32.count_total,full_u32.bytes_current);
        std::hint::black_box((cloned,widened));
    }
}
