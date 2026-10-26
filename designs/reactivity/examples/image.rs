//! Syntax sketch of `crates/gpui/examples/legacy/image.rs` + `image_loading.rs`,
//! at the scale those files never reached: a couple thousand photos.
//!
//! Old GPUI:
//!   - `Application.with_assets(AssetSource)` — a process-global string → bytes lookup
//!   - `ImageSource` mega-enum; strings guessed as URI vs path
//!   - `img(move |window, cx| window.use_asset::<Loader>(…))` plus `with_loading` /
//!     `with_fallback` closures that remount trees; load completion `notify`s the owner
//!   - widget-owned `Arc<RenderImage>`; GIFs keep every decoded frame in a `SmallVec`
//!   - `RetainAllImageCache` as an element-local hashmap, no decode-at-size, no
//!     virtualizer, so a scrolling column of `img` decodes everything it constructs
//!
//! New: there is no `.assets()` on `Application` or `Window::document`, and no `AssetSource`
//! crate you install.
//! The source *is* the constructor argument. A catalog with runtime state is a **field**.
//! An optional crate exists only if you want a reusable `MediaProvider` (rust-embed,
//! a blob store) — you depend on it and hold it, the kernel never names it. One scroll
//! vocabulary: `.scroll(Axis::Y)`, never `.pan(…)` (12 §8). A layout-sized decode target is a
//! token, `.decode_at(Decode::Layout)`, not a phase-violating `layout_size()` read (12 §8).

use gpui::prelude::*;

const SKELETON: Asset = asset!("photo-skeleton.svg");
const MISSING: Asset = asset!("photo-missing.svg");

/// Filesystem library — an ordinary field, not an App plugin.
/// Scan fills the `List`. Watching for new files mutates that list; the view is unchanged.
struct PhotoLibrary {
    root: PathBuf,
}

impl PhotoLibrary {
    fn scan(&self) -> impl Iterator<Item = PathBuf> {
        std::fs::read_dir(&self.root)
            .into_iter()
            .flatten()
            .flatten()
            .map(|e| e.path())
    }
}

struct Photo {
    path: PathBuf,
    caption: String,
}

struct Person {
    id: UserId,
    name: String,
}

/// Authenticated avatar fetch. `impl MediaProvider<Still, Request = UserId>` lives
/// in-app, or in a crate the app depends on. Either way it is this field.
#[derive(Copy, Clone)]
struct AvatarStore;

impl AvatarStore {
    fn connect() -> Self {
        Self
    }
    fn media(self, id: UserId) -> impl MediaInput<Still> {
        // sealed request; the runtime acquires. No Window / App in this function.
        AvatarRequest { id }
    }
}

struct Gallery {
    library: PhotoLibrary,
    photos: List<Photo>,
    people: List<Person>,
    avatars: AvatarStore,
    selected: Option<Slot<Photo>>,
}

impl Gallery {
    fn select(&mut self, slot: Slot<Photo>) {
        self.selected = Some(slot);
    }
}

impl Default for Gallery {
    fn default() -> Self {
        let library = PhotoLibrary {
            root: PathBuf::from("~/Pictures"),
        };
        let photos = library
            .scan()
            .enumerate()
            .map(|(n, path)| Photo {
                caption: format!("IMG_{n:04}"),
                path,
            })
            .collect();
        Self {
            library,
            photos,
            people: List::new(),
            avatars: AvatarStore::connect(),
            selected: None,
        }
    }
}

fn thumb(photo: &Photo) -> impl Element + '_ {
    image(&photo.path)
        .fit(ObjectFit::Cover)
        .decode_at(px(160)) // thumbnail variant — not the 4K file
        .placeholder(SKELETON)
        .on_error(MISSING)
        .size(160)
        .rounded_md()
        .on_click(Gallery::select) // Slot<Photo> is ambient
}

impl View for Photo {
    fn view(&self) -> El<'_> {
        column((thumb(self), text(&self.caption).text_xs().text_muted())).gap(4)
    }
}

fn person_row(person: &Person, avatars: AvatarStore) -> impl Element + '_ {
    row((
        image(avatars.media(person.id))
            .fit(ObjectFit::Cover)
            .decode_at(px(32))
            .placeholder(SKELETON)
            .size(32)
            .rounded_full(),
        text(&person.name).text_sm(),
    ))
    .gap(8)
    .items_center()
}

impl View for Gallery {
    fn view(&self) -> El<'_> {
        row((
            column((
                text("Photos").text_xl().semibold(),
                // Same PathBuf as the selected tile: one acquisition, two variants
                // (thumb 160px, hero at layout size). Encoded bytes are shared;
                // decode/residency are not. Gallery::view does not rerun when the
                // hero finishes decoding — the fragment patches.
                self.selected
                    .and_then(|slot| self.photos.get(slot))
                    .map(|photo| {
                        image(&photo.path)
                            .fit(ObjectFit::Contain)
                            .decode_at(Decode::Layout)
                            .placeholder(SKELETON)
                            .on_error(MISSING)
                            .flex_1()
                            .rounded_lg()
                    }),
            ))
            .flex_1()
            .p(16)
            .gap(12),
            column((
                virtual_list(&self.people, person_row)
                    .with(self.avatars) // Copy handle into the row; not a global
                    .scroll(Axis::Y)
                    .h(120),
                virtual_list(&self.photos).scroll(Axis::Y).flex_1(),
            ))
            .w(200)
            .h_full()
            .border_l(1)
            .border_color(theme.border),
        ))
        .bg(theme.background)
    }
}

fn main() {
    Application::run(Window::document(Gallery::default()).title("Photos").size(1100, 720).centered());
    // No .assets(). No set_http_client. Icon chrome uses asset!(); the library is a field.
}
