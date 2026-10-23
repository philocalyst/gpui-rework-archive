//! One collection browser state and one pure worker input; no page entities.
use crate::{
    app::Library,
    search::{SearchInput, Sort, SourceError, Version},
};
use gpui::prelude::*;
use triomphe::Arc;

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum Route {
    #[default]
    Tracks,
    Albums,
    Artists,
    Playlists,
    Album(i64),
    Artist(i64),
    Playlist(i64),
}
impl Route {
    pub fn label(self) -> &'static str {
        match self {
            Self::Tracks => "Tracks",
            Self::Albums => "Albums",
            Self::Artists => "Artists",
            Self::Playlists => "Playlists",
            Self::Album(_) => "Album",
            Self::Artist(_) => "Artist",
            Self::Playlist(_) => "Playlist",
        }
    }
}
/// The private domain counter is never restored from navigation history.
/// Both list domains are replaced before changing to unrelated items.
#[derive(Debug)]
pub struct Navigation {
    history: Vec<Route>,
    cursor: usize,
    domain: u64,
    exhausted: bool,
}
impl Navigation {
    fn new() -> Self {
        Self {
            history: vec![Route::Tracks],
            cursor: 0,
            domain: 1,
            exhausted: false,
        }
    }
    pub fn current(&self) -> Route {
        self.history[self.cursor]
    }
    pub fn len(&self) -> usize {
        self.history.len()
    }
    pub fn is_empty(&self) -> bool {
        self.history.is_empty()
    }
    pub fn can_back(&self) -> bool {
        self.cursor != 0
    }
    pub fn can_forward(&self) -> bool {
        self.cursor + 1 < self.history.len()
    }
    fn renew(&mut self) -> bool {
        if let Some(next) = self.domain.checked_add(2).filter(|n| *n < u64::MAX) {
            self.domain = next;
            true
        } else {
            self.exhausted = true;
            false
        }
    }
    pub fn navigate(&mut self, route: Route) {
        if !self.renew() {
            return;
        }
        self.history.truncate(self.cursor + 1);
        if self.history.len() == 100 {
            self.history.remove(0);
        }
        self.history.push(route);
        self.cursor = self.history.len() - 1;
    }
    pub fn back(&mut self) {
        if self.can_back() && self.renew() {
            self.cursor -= 1;
        }
    }
    pub fn forward(&mut self) {
        if self.can_forward() && self.renew() {
            self.cursor += 1;
        }
    }
    pub fn refresh(&mut self) {
        self.renew();
    }
    pub fn track_list(&self) -> ListId {
        ListId::new(self.domain)
    }
}
#[derive(Debug)]
pub struct Browser {
    navigation: Signal<Navigation>,
    query: Signal<String>,
    sort: Signal<Sort>,
}
impl Browser {
    pub const NAV: Source<Self, Navigation> = Source::new(
        FieldId::new(1),
        "navigation",
        |m| &m.navigation,
        |m| &mut m.navigation,
    );
    pub const QUERY: Source<Self, String> =
        Source::new(FieldId::new(2), "search", |m| &m.query, |m| &mut m.query);
    pub const SORT: Source<Self, Sort> =
        Source::new(FieldId::new(3), "sort", |m| &m.sort, |m| &mut m.sort);
    pub(crate) fn new() -> Self {
        Self {
            navigation: Signal::new(Navigation::new()),
            query: Signal::new(String::new()),
            sort: Signal::new(Sort::Title),
        }
    }
    pub fn navigation(&self) -> &Navigation {
        &self.navigation
    }
    pub fn revisions(&self) -> [u32; 3] {
        [
            self.navigation.revision().get(),
            self.query.revision().get(),
            self.sort.revision().get(),
        ]
    }
    pub fn matches(&self, input: &Input, version: Version) -> bool {
        self.navigation.current() == input.route
            && self.navigation.domain == input.domain
            && *self.query == input.search.query
            && *self.sort == input.search.sort
            && version == input.search.version
    }
    pub(crate) fn navigate(&mut self, route: Route) {
        self.navigation.navigate(route);
    }
    pub(crate) fn source_changed(&mut self) {
        self.navigation.refresh();
    }
}
impl View for Browser {
    fn sources() -> Sources<Self> {
        Sources::new()
            .field(Self::NAV)
            .direct(Self::QUERY)
            .field(Self::SORT)
    }
    fn view(&self) -> El<'_> {
        column((
            row((
                button("Tracks").on_click(Self::NAV.update(|nav| nav.navigate(Route::Tracks))),
                button("Albums").on_click(Self::NAV.update(|nav| nav.navigate(Route::Albums))),
                button("Artists").on_click(Self::NAV.update(|nav| nav.navigate(Route::Artists))),
                button("Playlists")
                    .on_click(Self::NAV.update(|nav| nav.navigate(Route::Playlists))),
                button("Back").on_click(Self::NAV.update(Navigation::back)),
                button("Forward").on_click(Self::NAV.update(Navigation::forward)),
                button("Refresh").on_click(Self::NAV.update(Navigation::refresh)),
            ))
            .gap(8),
            text_input(&self.query)
                .name("Search recordings")
                .description("Search this collection")
                .w(650)
                .h(32),
            row((
                button("Title").on_click(Self::SORT.update(|sort| *sort = Sort::Title)),
                button("Artist").on_click(Self::SORT.update(|sort| *sort = Sort::Artist)),
                button("Longest first").on_click(Self::SORT.update(|sort| *sort = Sort::Longest)),
            ))
            .gap(8),
            text(if self.navigation.exhausted {
                "Navigation identity space exhausted"
            } else {
                ""
            }),
        ))
        .gap(8)
    }
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Input {
    pub route: Route,
    pub(crate) domain: u64,
    pub search: SearchInput,
}
impl Input {
    pub fn freeze(
        navigation: &Navigation,
        query: &str,
        sort: Sort,
        version: Version,
    ) -> Result<Arc<Self>, SourceError> {
        Ok(Arc::new(Self {
            route: navigation.current(),
            domain: navigation.domain,
            search: SearchInput::freeze(query, sort, version)?,
        }))
    }
}
impl std::ops::Deref for Input {
    type Target = SearchInput;
    fn deref(&self) -> &SearchInput {
        &self.search
    }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum RowKey {
    Track(i64),
    PlaylistItem { item: i64, track: i64 },
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct PlayRequest {
    pub input: Arc<Input>,
    pub start: Option<RowKey>,
    pub sequence: u64,
}
#[derive(Debug)]
pub struct PreparedListing {
    pub tracks: Vec<crate::queue::TrackRef>,
    pub start: usize,
}
#[derive(Debug)]
pub struct CollectionRow {
    pub route: Route,
    pub id: i64,
    pub title: String,
    pub detail: String,
}
pub struct TrackRows {
    pub input: Arc<Input>,
    pub rows: Vec<crate::query::TrackSearchRow>,
    /// Playlist item identity is separate from recording identity. Ordinary
    /// track pages do not allocate this lane.
    pub playlist_items: Vec<i64>,
}
impl TrackRows {
    pub fn len(&self) -> usize {
        self.rows.len()
    }
    pub fn is_empty(&self) -> bool {
        self.rows.is_empty()
    }
    pub fn identity(&self, index: usize) -> RowKey {
        let track = self.rows[index].id;
        self.playlist_items
            .get(index)
            .map_or(RowKey::Track(track), |item| RowKey::PlaylistItem {
                item: *item,
                track,
            })
    }
}
pub struct Collections {
    pub input: Arc<Input>,
    pub rows: Vec<CollectionRow>,
}
pub struct Page {
    pub input: Arc<Input>,
    pub title: String,
    pub rows: TrackRows,
    pub collections: Collections,
}
impl Page {
    pub fn ids(&self) -> impl Iterator<Item = i64> + '_ {
        self.rows.rows.iter().map(|row| row.id)
    }
    pub fn track_list(&self) -> ListId {
        ListId::new(self.input.domain)
    }
    pub fn collection_list(&self) -> ListId {
        ListId::new(self.input.domain + 1)
    }
}
impl ItemSource for TrackRows {
    fn len(&self) -> usize {
        self.len()
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(match self.identity(index) {
            RowKey::Track(id) => id,
            RowKey::PlaylistItem { item, .. } => item,
        } as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        (0..self.len()).find(|i| self.key(*i) == key)
    }
    fn row(&self, index: usize) -> El<'_> {
        let track = &self.rows[index];
        let id = track.id;
        let generation = self.input.version.generation;
        let context = self.input.clone();
        let key = self.identity(index);
        #[cfg(feature = "audio")]
        let play = button("Play now")
            .name(format!("Play {} now", track.title))
            .w(76)
            .h(32)
            .on_click(move |model: &mut Library| model.play_now(id, generation));
        #[cfg(not(feature = "audio"))]
        let play = text("");
        #[cfg(feature = "audio")]
        let from = button("Play from here")
            .name(format!("Play from {}", track.title))
            .on_click(move |model: &mut Library| model.play_listing(context.clone(), Some(key)));
        #[cfg(not(feature = "audio"))]
        let from = {
            let _ = (context, key);
            text("")
        };
        row((
            button("Prepare")
                .name(format!("Prepare {}", track.title))
                .w(64)
                .h(32)
                .on_click(move |model: &mut Library| model.prepare(id, generation)),
            play,
            text(track.title.as_str()).w(180).p(6),
            text(track.artist_names.as_deref().unwrap_or("Unknown artist"))
                .w(120)
                .p(6),
            from,
        ))
        .h(32)
        .bg(if index.is_multiple_of(2) {
            rgb(0xf1f5f9)
        } else {
            Color::WHITE
        })
    }
}
impl ItemSource for Collections {
    fn len(&self) -> usize {
        self.rows.len()
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(self.rows[index].id as u64)
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        self.rows.iter().position(|row| row.id as u64 == key.get())
    }
    fn row(&self, index: usize) -> El<'_> {
        let item = &self.rows[index];
        let route = item.route;
        let input = self.input.clone();
        row((
            button(format!("Open {}", item.title))
                .w(260)
                .on_click(move |model: &mut Library| model.open_collection(&input, route)),
            text(item.detail.as_str()).w(330),
        ))
        .h(32)
    }
}
