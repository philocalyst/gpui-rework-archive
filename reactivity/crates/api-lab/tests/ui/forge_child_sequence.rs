use reactivity_api_lab::{ChildSeq, El, shape};

struct Foreign;
impl<'a> ChildSeq<'a, shape::One> for Foreign {
    fn append(self, _: &mut Vec<El<'a>>) {}
}

fn main() {}
