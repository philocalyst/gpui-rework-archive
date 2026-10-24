//! Resource ownership control using ordinary Canvas APIs. This is not a runtime
//! implementation or a qualified native Todo result.
#[path = "support/todo_five.rs"]
#[expect(
    dead_code,
    reason = "The owner control reads the exact Todo corpus; native Todo owns domain actions."
)]
mod todos;
use gpui::{Win, WindowOptions};
use gpui_canvas::{
    Affine, Canvas, Color, FontFace, OwnedTextLayout, Point, Rect, TextLayout, TextSystem,
};
use std::{cmp::Ordering, hint::black_box, mem::size_of, sync::Arc, time::Instant};

// A physical-page-sized payload budget and an independent packed-index bound.
// Large resources get singleton chunks and never pin smaller neighbors.
const CHUNK_BYTES: usize = 4096;
const SLOT_BITS: u32 = 8;
const SLOT_MASK: u32 = (1 << SLOT_BITS) - 1;
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Key(u32);
impl Key {
    fn new(chunk: usize, slot: usize) -> Self {
        assert!(chunk <= (u32::MAX >> SLOT_BITS) as usize && slot <= SLOT_MASK as usize);
        Self(((chunk as u32) << SLOT_BITS) | slot as u32)
    }
    fn chunk(self) -> usize {
        (self.0 >> SLOT_BITS) as usize
    }
    fn slot(self) -> usize {
        (self.0 & SLOT_MASK) as usize
    }
}
#[derive(Clone)]
struct Spec {
    value: String,
    size: f32,
    width: Option<f32>,
}
fn compare(a: (&str, u32, Option<u32>), b: (&str, u32, Option<u32>)) -> Ordering {
    a.cmp(&b)
}
impl Spec {
    fn key(&self) -> (&str, u32, Option<u32>) {
        (
            &self.value,
            self.size.to_bits(),
            self.width.map(f32::to_bits),
        )
    }
}
struct Resource {
    value: Box<str>,
    shape: OwnedTextLayout,
    width: Option<u32>,
}
impl Resource {
    fn key(&self) -> (&str, u32, Option<u32>) {
        (&self.value, self.shape.font_size().to_bits(), self.width)
    }
    fn bytes(&self) -> usize {
        size_of::<Self>() + self.value.len() + self.shape.buffer_capacity_bytes()
    }
}
struct Page {
    chunks: Box<[Arc<[Resource]>]>,
    index: Box<[Key]>,
    font: FontFace,
}
impl Page {
    fn get(&self, key: Key) -> &Resource {
        &self.chunks[key.chunk()][key.slot()]
    }
    fn find(&self, spec: &Spec) -> Option<Key> {
        self.index
            .binary_search_by(|&key| compare(self.get(key).key(), spec.key()))
            .ok()
            .map(|n| self.index[n])
    }
}
struct Snapshot {
    page: Arc<Page>,
    rows: Box<[Key]>,
}
struct Row<'a> {
    page: &'a Page,
    key: Key,
}
impl Row<'_> {
    fn value(&self) -> &str {
        &self.page.get(self.key).value
    }
    fn shape(&self) -> &OwnedTextLayout {
        &self.page.get(self.key).shape
    }
}
impl Snapshot {
    fn row(&self, index: usize) -> Row<'_> {
        Row {
            page: &self.page,
            key: self.rows[index],
        }
    }
    fn retained(&self) -> (usize, usize, usize, usize) {
        let mut used: Vec<_> = self
            .page
            .chunks
            .iter()
            .map(|chunk| vec![false; chunk.len()])
            .collect();
        for &key in &self.rows {
            used[key.chunk()][key.slot()] = true;
        }
        let mut bytes = 0;
        let mut stale = 0;
        let mut resources = 0;
        for (chunk, live) in self.page.chunks.iter().zip(used) {
            let total: usize = chunk.iter().map(Resource::bytes).sum();
            assert!(total <= CHUNK_BYTES || chunk.len() == 1);
            for (resource, used) in chunk.iter().zip(live) {
                bytes += resource.bytes();
                resources += 1;
                if !used {
                    stale += resource.bytes();
                }
            }
        }
        (self.page.chunks.len(), resources, bytes, stale)
    }
}
struct Builder<'a> {
    old: Option<&'a Page>,
    chunks: Vec<Arc<[Resource]>>,
    open: Vec<Resource>,
    bytes: usize,
}
impl Builder<'_> {
    fn old_count(&self) -> usize {
        self.old.map_or(0, |page| page.chunks.len())
    }
    fn seal(&mut self) {
        if !self.open.is_empty() {
            self.chunks.push(Arc::from(std::mem::take(&mut self.open)));
            self.bytes = 0;
        }
    }
    fn push(&mut self, resource: Resource) -> Key {
        let bytes = resource.bytes();
        if self.bytes + bytes > CHUNK_BYTES || self.open.len() == (1 << SLOT_BITS) {
            self.seal();
        }
        let key = Key::new(self.old_count() + self.chunks.len(), self.open.len());
        self.open.push(resource);
        self.bytes += bytes;
        if bytes > CHUNK_BYTES {
            self.seal();
        }
        key
    }
    fn finish(mut self, mut rows: Vec<Key>, mut index: Vec<Key>, font: FontFace) -> Snapshot {
        self.seal();
        let old_count = self.old_count();
        let mut remap = vec![usize::MAX; old_count + self.chunks.len()];
        for key in &rows {
            remap[key.chunk()] = 0;
        }
        let mut chunks = Vec::new();
        for (n, remapped) in remap.iter_mut().enumerate() {
            if *remapped == usize::MAX {
                continue;
            }
            *remapped = chunks.len();
            chunks.push(if n < old_count {
                self.old.unwrap().chunks[n].clone()
            } else {
                self.chunks[n - old_count].clone()
            });
        }
        for key in rows.iter_mut().chain(&mut index) {
            *key = Key::new(remap[key.chunk()], key.slot());
        }
        Snapshot {
            page: Arc::new(Page {
                chunks: chunks.into_boxed_slice(),
                index: index.into_boxed_slice(),
                font,
            }),
            rows: rows.into_boxed_slice(),
        }
    }
}
fn build(
    specs: &[Spec],
    font: &FontFace,
    old: Option<&Page>,
) -> Result<Snapshot, gpui_canvas::Error> {
    let old = old.filter(|page| page.font.same_face(font));
    let mut sorted: Vec<_> = (0..specs.len()).collect();
    sorted.sort_unstable_by(|&a, &b| compare(specs[a].key(), specs[b].key()));
    let mut builder = Builder {
        old,
        chunks: Vec::new(),
        open: Vec::new(),
        bytes: 0,
    };
    let mut rows = vec![Key(0); specs.len()];
    let mut index = Vec::new();
    let mut shaper = font.shaper();
    let mut cursor = 0;
    while cursor < sorted.len() {
        let spec = &specs[sorted[cursor]];
        let key = if let Some(key) = old.and_then(|page| page.find(spec)) {
            key
        } else {
            let shape = shaper.shape_owned_interactive(&spec.value, spec.size, spec.width)?;
            builder.push(Resource {
                value: spec.value.as_str().into(),
                shape,
                width: spec.width.map(f32::to_bits),
            })
        };
        index.push(key);
        loop {
            rows[sorted[cursor]] = key;
            cursor += 1;
            if cursor == sorted.len() || specs[sorted[cursor]].key() != spec.key() {
                break;
            }
        }
    }
    Ok(builder.finish(rows, index, font.clone()))
}
struct SharedSite {
    value: arcstr::ArcStr,
    shape: TextLayout,
    width: Option<u32>,
    field: Option<gpui::FieldId>,
}
struct SharedEntry {
    row: u32,
    origin: Point,
    map: Arc<gpui_canvas::TextGeometry>,
}
struct SharedSnapshot {
    sites: Vec<SharedSite>,
    values: Vec<arcstr::ArcStr>,
    geometry: Vec<SharedEntry>,
}
fn shared(specs: &[Spec], font: &FontFace) -> SharedSnapshot {
    let mut shaper = font.shaper();
    let mut sites = Vec::with_capacity(specs.len());
    let mut values = Vec::with_capacity(specs.len());
    let mut geometry = Vec::with_capacity(specs.len());
    for (row, spec) in specs.iter().enumerate() {
        let value = arcstr::ArcStr::from(spec.value.as_str());
        let shape = shaper
            .shape_interactive(&spec.value, spec.size, spec.width)
            .unwrap();
        values.push(value.clone());
        geometry.push(SharedEntry {
            row: row as u32,
            origin: Point::default(),
            map: shape.retain_geometry().unwrap(),
        });
        sites.push(SharedSite {
            value,
            shape,
            width: spec.width.map(f32::to_bits),
            field: None,
        });
    }
    SharedSnapshot {
        sites,
        values,
        geometry,
    }
}
fn measured<T>(phase: &str, action: impl FnOnce() -> T) -> T {
    let mut result = None;
    let start = Instant::now();
    let cost = allocation_counter::measure(|| result = Some(action()));
    println!(
        "PAGE_COST,{}",
        serde_json::json!({"phase":phase,"wall_ns":start.elapsed().as_nanos(),"allocations":cost.count_total,"requested_bytes":cost.bytes_total,"retained_delta_bytes":cost.bytes_current,"peak_extra_bytes":cost.bytes_max})
    );
    result.unwrap()
}
fn corpus(mode: &str, count: usize) -> Vec<Spec> {
    let values = if mode == "todo" {
        let mut win =
            Win::recording(todos::Todos::seeded(count, false), WindowOptions::default()).unwrap();
        let token = win.with_scene(|_, token| token).unwrap();
        win.presented(token).unwrap();
        let mut values = Vec::new();
        win.visit(|part| {
            if let Some(text) = part.text() {
                assert!(part.text_geometry().is_some());
                values.push(text.to_owned());
            }
        })
        .unwrap();
        win.close().unwrap();
        values
    } else {
        (0..count)
            .map(|n| match mode {
                "unique" => format!("Task {:04}", n + 1),
                "repeated" => "office abc".to_owned(),
                "unicode" => "office אבג\r\nالعربية a\u{301}".to_owned(),
                "large" => "a".repeat(32768),
                _ => panic!("unknown corpus"),
            })
            .collect()
    };
    values
        .into_iter()
        .map(|value| Spec {
            value,
            size: 16.,
            width: Some(204.),
        })
        .collect()
}
fn lifecycle(specs: &mut [Spec], font: &FontFace, p: Snapshot) {
    if specs.is_empty() {
        return;
    }
    let old_value = specs[0].value.clone();
    specs[0].value = "a replacement office אבג".into();
    let c1 = measured("old_p_new_c", || build(specs, font, Some(&p.page)).unwrap());
    assert_eq!(p.row(0).value(), old_value);
    assert_eq!(c1.row(0).value(), specs[0].value);
    let stable = measured("unchanged_page_root", || c1.page.clone());
    assert!(Arc::ptr_eq(&stable, &c1.page));
    drop(stable);
    specs[0].value = "\u{1}".into();
    assert!(measured("failed_newer", || build(specs, font, Some(&c1.page))).is_err());
    assert_eq!(p.row(0).value(), old_value);
    assert_eq!(c1.row(0).value(), "a replacement office אבג");
    println!(
        "PAGE_LIVE,{}",
        serde_json::json!({"p":p.retained(),"c":c1.retained()})
    );
    let job_page = c1.page.clone();
    let job_key = c1.rows[0];
    let weak = Arc::downgrade(&job_page);
    let worker = std::thread::spawn(move || {
        let resource = job_page.get(job_key);
        assert_eq!(resource.value.as_ref(), "a replacement office אבג");
        assert!(resource.shape.runs().count() > 0);
        assert_eq!(
            resource.shape.geometry().unwrap().text_len(),
            resource.value.len()
        );
        let mut service = TextSystem::from_font(job_page.font.clone());
        let mut scene = Canvas::new(240, 80).unwrap();
        scene
            .draw_text(
                &mut service,
                &resource.shape,
                Point::default(),
                Affine::IDENTITY,
                Rect::new(0., 0., 240., 80.),
                Color::BLACK,
            )
            .unwrap();
        drop(job_page);
        // The current implementation still leases packed glyphs per scene run;
        // this control charges that retained owner rather than claiming deletion.
        assert!(scene.pixels().iter().any(|&byte| byte != 0));
    });
    drop(c1);
    drop(p);
    worker.join().unwrap();
    assert!(weak.upgrade().is_none());
}
fn main() {
    let args: Vec<_> = std::env::args().collect();
    let mode = args.get(1).map_or("unique", String::as_str);
    let count = args.get(2).map_or(10000, |n| n.parse().unwrap());
    let mut specs = corpus(mode, count);
    let font = FontFace::bundled().unwrap();
    println!(
        "PAGE_SCOPE,{}",
        serde_json::json!({"mode":mode,"requested_rows":count,"text_specs":specs.len(),"size":16,"width":204,"scope":"owner-column component control; Todo strings use ordinary complete public recording queries but uniform Canvas placement is not native Todo qualification","resource_header":size_of::<Resource>(),"key":size_of::<Key>(),"page":size_of::<Page>(),"shared_site":size_of::<SharedSite>(),"shared_entry":size_of::<SharedEntry>(),"owned_layout":size_of::<OwnedTextLayout>(),"shared_layout":size_of::<TextLayout>()})
    );
    let baseline = measured("shared_columns_mount", || shared(&specs, &font));
    let snapshot = measured("owned_pages_mount", || build(&specs, &font, None).unwrap());
    for (index, spec) in specs.iter().enumerate() {
        let row = snapshot.row(index);
        assert_eq!(row.value(), spec.value);
        assert_eq!(row.shape().font_size(), spec.size);
        assert_eq!(baseline.sites[index].value.as_str(), row.value());
        assert_eq!(baseline.values[index].as_str(), row.value());
        assert_eq!(baseline.geometry[index].row, index as u32);
        assert_eq!(baseline.geometry[index].origin, Point::default());
        assert_eq!(baseline.sites[index].width, spec.width.map(f32::to_bits));
        assert!(baseline.sites[index].field.is_none());
        assert_eq!(
            baseline.sites[index].shape.glyphs().collect::<Vec<_>>(),
            row.shape().glyphs().collect::<Vec<_>>()
        );
        assert_eq!(
            format!("{:?}", baseline.geometry[index].map),
            format!("{:?}", row.shape().geometry().unwrap())
        );
    }
    black_box(&baseline);
    println!(
        "PAGE_LIVE,{}",
        serde_json::json!({"mounted":snapshot.retained()})
    );
    measured("shared_columns_drop", || drop(baseline));
    lifecycle(&mut specs, &font, snapshot);
}
