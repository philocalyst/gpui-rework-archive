//! Ordinary public queue consumer. Explicit controls expose selection and range
//! operations until modified-click/drag metadata has a portable public route.
use crate::{
    queue::{EntryKey, QueueError, Repeat, Track, TrackRef},
    queue_playback::PlaybackQueue,
};
use gpui::prelude::*;

pub struct QueueScreen {
    playback: PlaybackQueue,
    selected: Vec<EntryKey>,
    anchor: Option<EntryKey>,
    list: ListId,
    notice: String,
}
fn available(track: &Track) -> bool {
    track.available_when_prepared
}
fn draw(upper: usize) -> usize {
    fastrand::usize(..upper)
}
impl QueueScreen {
    /// `list` names this queue's key domain. Reconstructing a screen in the same
    /// window requires a fresh ListId; ordinary edits keep monotonically fresh
    /// entry keys and preserve this domain. One Library owns one screen.
    pub fn new(list: ListId) -> Result<Self, QueueError> {
        Ok(Self {
            playback: PlaybackQueue::new()?,
            selected: Vec::new(),
            anchor: None,
            list,
            notice: String::new(),
        })
    }
    pub fn list_id(&self) -> ListId {
        self.list
    }
    pub fn playback(&self) -> &PlaybackQueue {
        &self.playback
    }
    pub fn selected(&self) -> &[EntryKey] {
        &self.selected
    }
    pub fn enqueue(&mut self, track: TrackRef) {
        let result = self.playback.append(vec![track], &available, &mut draw);
        self.changed(result.map(|_| ()));
    }
    fn changed(&mut self, result: Result<(), QueueError>) {
        match result {
            Ok(()) => {
                // Original queue-update notification clears selection too.
                self.selected.clear();
                self.anchor = None;
                self.notice.clear();
            }
            Err(error) => self.notice = format!("Queue rejected: {error:?}"),
        }
    }
    pub fn select(&mut self, key: EntryKey) {
        if self.playback.queue().entry(key).is_some() {
            self.selected.clear();
            self.selected.push(key);
            self.anchor = Some(key);
        }
    }
    pub fn toggle(&mut self, key: EntryKey) {
        if self.playback.queue().entry(key).is_none() {
            return;
        }
        match self.selected.binary_search(&key) {
            Ok(index) => {
                self.selected.remove(index);
                if self.anchor == Some(key) {
                    self.anchor = self.selected.first().copied();
                }
            }
            Err(index) => {
                self.selected.insert(index, key);
                self.anchor = Some(key);
            }
        }
    }
    pub fn range(&mut self, key: EntryKey) {
        let queue = self.playback.queue();
        let Some(index) = queue.index_of(key) else {
            return;
        };
        let anchor = self.anchor.or(queue.current()).unwrap_or(key);
        let Some(start) = queue.index_of(anchor) else {
            return;
        };
        self.anchor = Some(anchor);
        self.selected = (start.min(index)..=start.max(index))
            .map(|index| queue.at(index).unwrap().key)
            .collect();
        self.selected.sort_unstable();
    }
    fn play(&mut self, key: EntryKey) {
        let result = self.playback.play(key, &available);
        self.changed(result.and_then(|accepted| {
            if accepted {
                Ok(())
            } else {
                Err(QueueError::Unavailable)
            }
        }));
    }
    fn next(&mut self) {
        let result = self.playback.next(&available, &mut draw);
        self.changed(result);
    }
    fn previous(&mut self) {
        let result = self.playback.previous(&available, &mut draw);
        self.changed(result);
    }
    fn remove(&mut self) {
        let result = self.playback.remove(&self.selected, &available);
        self.changed(result.map(|_| ()));
    }
    fn move_to(&mut self, destination: usize) {
        let result = self
            .playback
            .move_entries(&self.selected, destination, &available);
        self.changed(result.map(|_| ()));
    }
    fn shuffle(&mut self) {
        let result = self.playback.toggle_shuffle(&available, &mut draw);
        self.changed(result);
    }
    fn repeat(&mut self) {
        let next = match self.playback.queue().repeat() {
            Repeat::Off => Repeat::All,
            Repeat::All => Repeat::One,
            Repeat::One => Repeat::Off,
        };
        let result = self.playback.set_repeat(next, &available);
        self.changed(result.map(|_| ()));
    }
    fn undo(&mut self) {
        let result = self.playback.undo(&available);
        self.changed(result.map(|_| ()));
    }
    fn clear(&mut self) {
        let result = self.playback.clear(true, &available);
        self.changed(result);
    }
}
impl ItemSource for QueueScreen {
    fn len(&self) -> usize {
        self.playback.queue().len()
    }
    fn key(&self, index: usize) -> ItemKey {
        ItemKey::new(self.playback.queue().at(index).unwrap().key.get())
    }
    fn index_of(&self, key: ItemKey) -> Option<usize> {
        let queue = self.playback.queue();
        queue.index_of(queue.key(key.get())?)
    }
    fn row(&self, index: usize) -> El<'_> {
        let entry = self.playback.queue().at(index).unwrap();
        let key = entry.key;
        let play = button("Prepare")
            .name(format!("Prepare queue entry {}", key.get()))
            .w(80);
        row((
            checkbox(
                entry.track.title.as_str(),
                self.selected.binary_search(&key).is_ok(),
            )
            .name(format!("Select queue entry {}", key.get()))
            .w(240)
            .on_click(move |model: &mut Self| model.toggle(key)),
            button("Only")
                .name(format!("Select only queue entry {}", key.get()))
                .w(55)
                .on_click(move |model: &mut Self| model.select(key)),
            button("Range")
                .name(format!("Select range to queue entry {}", key.get()))
                .w(70)
                .on_click(move |model: &mut Self| model.range(key)),
            if available(&entry.track) {
                play.on_click(move |model: &mut Self| model.play(key))
            } else {
                play.description("Path was unavailable when prepared by the library worker")
            },
        ))
        .h(40)
        .bg(if self.playback.queue().current() == Some(key) {
            rgb(0xe0f2fe)
        } else {
            Color::WHITE
        })
    }
}
impl View for QueueScreen {
    fn view(&self) -> El<'_> {
        let last = self.playback.queue().len();
        column((
            text(format!("Queue — {} entries", last)).font_size(20),
            text("Decoder plans only; audio output is not attached"),
            row((
                button("Previous").on_click(Self::previous),
                button("Next").on_click(Self::next),
                checkbox("Shuffle queue", self.playback.queue().shuffled()).on_click(Self::shuffle),
                button(format!("Repeat: {:?}", self.playback.queue().repeat()))
                    .on_click(Self::repeat),
                button("Undo queue edit").on_click(Self::undo),
                button("Clear upcoming").on_click(Self::clear),
            ))
            .gap(8),
            row((
                button("Remove selected").on_click(Self::remove),
                button("Move selected first").on_click(|model: &mut Self| model.move_to(0)),
                button("Move selected last").on_click(move |model: &mut Self| model.move_to(last)),
            ))
            .gap(8),
            uniform_list(self.list, self, 40)
                .name("Playback queue")
                .w(650)
                .h(160),
            text(self.playback.plan().map_or_else(
                || "No decoder plan".into(),
                |plan| {
                    format!(
                        "Prepared queue entry {} — {}",
                        plan.current.key.get(),
                        plan.current.track.path.display()
                    )
                },
            )),
            text(self.notice.as_str()),
        ))
        .gap(6)
    }
}
