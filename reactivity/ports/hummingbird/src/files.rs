//! One immutable filesystem answer is both the displayed order and the explicit
//! playback lease. No second directory read can silently reorder an action.
use crate::{
    app::Library,
    browser::{Input, Page, PreparedListing, Route, RowKey},
    database::Database,
    indexing,
    queue::{Track, TrackRef},
    search::{Searcher, SourceError},
};
use gpui::prelude::*;
use nucleo_matcher::pattern::{CaseMatching, Normalization, Pattern};
use std::{fs, path::PathBuf};
use triomphe::Arc;

#[derive(Debug)]
pub enum Kind {
    Root(i64),
    Directory,
    Recording,
    Other,
}
#[derive(Debug)]
pub struct Entry {
    pub path: PathBuf,
    pub kind: Kind,
}
impl Entry {
    fn label(&self) -> std::borrow::Cow<'_, str> {
        if matches!(self.kind, Kind::Root(_)) {
            self.path.to_string_lossy()
        } else {
            self.path
                .file_name()
                .unwrap_or(self.path.as_os_str())
                .to_string_lossy()
        }
    }
}
#[derive(Debug)]
pub struct FileListing {
    pub input: Arc<Input>,
    pub entries: Vec<Entry>,
    domain: u64,
}
impl FileListing {
    pub fn list(&self) -> ListId {
        ListId::new(self.domain)
    }
    pub fn recording_count(&self) -> usize {
        self.entries
            .iter()
            .filter(|entry| matches!(entry.kind, Kind::Recording))
            .count()
    }
    pub(crate) fn prepare(&self, start: Option<RowKey>) -> Result<PreparedListing, SourceError> {
        let selected = match start {
            None => None,
            Some(RowKey::File(index))
                if self
                    .entries
                    .get(index)
                    .is_some_and(|entry| matches!(entry.kind, Kind::Recording)) =>
            {
                Some(index)
            }
            _ => return Err(SourceError::NoSelection),
        };
        let mut tracks = Vec::with_capacity(self.recording_count());
        let mut beginning = 0;
        for (index, entry) in self.entries.iter().enumerate() {
            if !matches!(entry.kind, Kind::Recording) {
                continue;
            }
            if selected == Some(index) {
                beginning = tracks.len();
            }
            tracks.push(TrackRef::new(Track {
                path: entry.path.clone(),
                title: entry.label().into_owned(),
                track_id: None,
                album_id: None,
                available_when_prepared: entry.path.is_file(),
            }));
        }
        let track = tracks.get(beginning).ok_or(SourceError::NoSelection)?;
        if !track.available_when_prepared {
            return Err(SourceError::Io {
                path: track.path.clone(),
                error: std::io::Error::from(std::io::ErrorKind::NotFound),
            });
        }
        Ok(PreparedListing {
            tracks,
            start: beginning,
        })
    }
}
/// This wrapper supplies the one Arc needed by row actions. It adds no second
/// path/order representation and disappears when the page and its intent drop.
pub struct FileRows(pub Arc<FileListing>);
impl std::ops::Deref for FileRows {
    type Target = FileListing;
    fn deref(&self) -> &FileListing {
        &self.0
    }
}
impl ItemSource for FileRows {
    fn len(&self) -> usize {
        self.entries.len()
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(index as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        usize::try_from(key.get())
            .ok()
            .filter(|index| *index < self.entries.len())
    }
    fn row(&self, index: usize) -> El<'_> {
        let entry = &self.entries[index];
        let label = entry.label();
        let action = match entry.kind {
            Kind::Root(_) | Kind::Directory => {
                let path = entry.path.clone();
                let input = self.input.clone();
                button(format!("Open {label}")).on_click(move |model: &mut Library| {
                    model.open_collection(&input, Route::Directory(path.clone()))
                })
            }
            Kind::Recording => {
                #[cfg(feature = "audio")]
                {
                    let files = self.0.clone();
                    button(format!("Play from {label}")).on_click(move |model: &mut Library| {
                        model.play_files(files.clone(), Some(RowKey::File(index)))
                    })
                }
                #[cfg(not(feature = "audio"))]
                {
                    match label {
                        std::borrow::Cow::Borrowed(value) => text(value),
                        std::borrow::Cow::Owned(value) => text(value),
                    }
                }
            }
            Kind::Other => match label {
                std::borrow::Cow::Borrowed(value) => text(value),
                std::borrow::Cow::Owned(value) => text(value),
            }
            .description("This entry is not a supported recording or traversable directory"),
        }
        .w(220);
        let remove = if let Kind::Root(id) = entry.kind {
            let input = self.input.clone();
            button("Forget root")
                .description("Keep its indexed recordings")
                .on_click(move |model: &mut Library| model.edit_root(&input, id, false))
        } else {
            text("")
        };
        let remove_recordings = if let Kind::Root(id) = entry.kind {
            let input = self.input.clone();
            button("Remove root + recordings")
                .on_click(move |model: &mut Library| model.edit_root(&input, id, true))
        } else {
            text("")
        };
        row((action, remove, remove_recordings)).gap(8).h(32)
    }
}

fn group(kind: &Kind) -> u8 {
    match kind {
        Kind::Root(_) | Kind::Directory => 0,
        Kind::Recording => 1,
        Kind::Other => 2,
    }
}
pub(crate) fn page(
    database: &Database,
    searcher: &mut Searcher,
    input: Arc<Input>,
    domain: u64,
    mut canceled: impl FnMut() -> bool,
) -> Option<Result<Page, SourceError>> {
    let result = (|| {
        let roots = indexing::roots(database)?;
        let mut entries = Vec::new();
        let pattern = Pattern::parse(&input.query, CaseMatching::Smart, Normalization::Smart);
        match &input.route {
            Route::Files => {
                for root in roots {
                    if canceled() {
                        return Ok(None);
                    }
                    if searcher.matches(&pattern, &root.path.to_string_lossy(), None) {
                        entries.push(Entry {
                            path: root.path,
                            kind: Kind::Root(root.id),
                        });
                    }
                }
            }
            Route::Directory(path) => {
                let directory = fs::canonicalize(path).map_err(|error| SourceError::Io {
                    path: path.clone(),
                    error,
                })?;
                if !roots.iter().any(|root| directory.starts_with(&root.path)) {
                    return Err(SourceError::OutsideLibraryRoots(directory));
                }
                let children = fs::read_dir(&directory).map_err(|error| SourceError::Io {
                    path: directory.clone(),
                    error,
                })?;
                for child in children {
                    if canceled() {
                        return Ok(None);
                    }
                    let child = child.map_err(|error| SourceError::Io {
                        path: directory.clone(),
                        error,
                    })?;
                    let path = child.path();
                    let kind = child.file_type().map_err(|error| SourceError::Io {
                        path: path.clone(),
                        error,
                    })?;
                    let kind = if kind.is_dir() {
                        Kind::Directory
                    } else if kind.is_file() && crate::metadata::supported(&path) {
                        Kind::Recording
                    } else {
                        Kind::Other
                    };
                    if searcher.matches(&pattern, &child.file_name().to_string_lossy(), None) {
                        entries.push(Entry { path, kind });
                    }
                }
                entries.sort_by(|a, b| {
                    group(&a.kind).cmp(&group(&b.kind)).then_with(|| {
                        a.path
                            .file_name()
                            .cmp(&b.path.file_name())
                            .then_with(|| a.path.cmp(&b.path))
                    })
                });
            }
            _ => return Err(SourceError::MissingCollection),
        }
        Ok(Some(Page::Files(FileRows(Arc::new(FileListing {
            input,
            entries,
            domain,
        })))))
    })();
    if canceled() { None } else { result.transpose() }
}

/// Path editing is a normal nested public SourcePath. The Library owns worker
/// authority and actions; this component holds no service clone or result lane.
pub struct Roots {
    path: Signal<String>,
}
impl Roots {
    pub const PATH: Source<Self, String> = Source::new(
        FieldId::new(1),
        "library root path",
        |m| &m.path,
        |m| &mut m.path,
    );
    pub(crate) fn new() -> Self {
        Self {
            path: Signal::new(String::new()),
        }
    }
    pub fn path(&self) -> &str {
        &self.path
    }
}
impl View for Roots {
    fn sources() -> Sources<Self> {
        Sources::new().direct(Self::PATH)
    }
    fn view(&self) -> El<'_> {
        text_input(&self.path)
            .name("Library root path")
            .description("Absolute folder to index; no playback is started")
            .w(650)
            .h(32)
    }
}
