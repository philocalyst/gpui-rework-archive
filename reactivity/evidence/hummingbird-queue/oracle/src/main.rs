//! Executes the exact pinned QueueManager. UI entity/metadata and settings not
//! read by that manager are shims, not a claim to run the old audio/UI stack.
use std::{
    path::PathBuf,
    sync::{Arc, RwLock},
};
#[path = "../upstream/queue_manager.rs"]
mod queue_manager;

pub mod settings {
    pub mod playback {
        #[derive(Default)]
        pub struct PlaybackSettings {
            pub always_repeat: bool,
        }
    }
}
pub mod playback {
    pub mod events {
        #[derive(Clone, Copy, Debug, Default, PartialEq)]
        pub enum RepeatState {
            #[default]
            NotRepeating,
            Repeating,
            RepeatingOne,
        }
    }
    pub mod queue {
        use std::{
            path::PathBuf,
            sync::{Arc, RwLock},
        };
        #[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
        pub struct QueueItemData {
            #[serde(skip)]
            data: Arc<RwLock<Option<()>>>,
            db_id: Option<i64>,
            db_album_id: Option<i64>,
            path: PathBuf,
        }
        impl PartialEq for QueueItemData {
            fn eq(&self, other: &Self) -> bool {
                self.db_id == other.db_id
                    && self.db_album_id == other.db_album_id
                    && self.path == other.path
            }
        }
        impl QueueItemData {
            pub fn get_path(&self) -> &PathBuf {
                &self.path
            }
            pub fn get_db_id(&self) -> Option<i64> {
                self.db_id
            }
            pub fn get_db_album_id(&self) -> Option<i64> {
                self.db_album_id
            }
        }
    }
    pub mod session_storage {
        #[derive(Default)]
        pub struct PlaybackSessionData {
            pub queue: Vec<super::queue::QueueItemData>,
            pub original_queue: Vec<super::queue::QueueItemData>,
            pub queue_position: Option<usize>,
            pub shuffle: bool,
            pub repeat: super::events::RepeatState,
        }
    }
}
use playback::{events::RepeatState, queue::QueueItemData, session_storage::PlaybackSessionData};
use queue_manager::{QueueManager, QueueNavigationResult};
fn item(id: i64, directory: &std::path::Path) -> QueueItemData {
    serde_json::from_value(
        serde_json::json!({"db_id":id,"db_album_id":1,"path":directory.join(format!("{id}.flac"))}),
    )
    .unwrap()
}
fn manager(items: Vec<QueueItemData>) -> QueueManager {
    let (sender, _receiver) = tokio::sync::watch::channel(PlaybackSessionData::default());
    QueueManager::new(
        Arc::new(RwLock::new(items)),
        Default::default(),
        Default::default(),
        sender,
    )
}
fn navigation(result: QueueNavigationResult) -> String {
    match result {
        QueueNavigationResult::Changed { path, .. } => {
            format!("changed:{}", path.file_stem().unwrap().to_str().unwrap())
        }
        QueueNavigationResult::Unchanged { path } => {
            format!("repeat:{}", path.file_stem().unwrap().to_str().unwrap())
        }
        QueueNavigationResult::EndOfQueue => "end".into(),
    }
}
struct Directory(PathBuf);
impl Drop for Directory {
    fn drop(&mut self) {
        let _ = std::fs::remove_dir_all(&self.0);
    }
}
fn main() {
    let directory = Directory(
        std::env::temp_dir().join(format!("hummingbird-queue-oracle-{}", std::process::id())),
    );
    std::fs::create_dir(&directory.0).unwrap();
    for id in [1, 3] {
        std::fs::write(
            directory.0.join(format!("{id}.flac")),
            b"path existence only",
        )
        .unwrap();
    }
    let mut queue = manager(
        [1, 2, 3]
            .into_iter()
            .map(|id| item(id, &directory.0))
            .collect(),
    );
    println!("next={}", navigation(queue.next(false)));
    queue.set_repeat(RepeatState::RepeatingOne);
    println!("repeat_one={}", navigation(queue.next(false)));
    println!("manual_next={}", navigation(queue.next(true)));
    println!("manual_end={}", navigation(queue.next(true)));
    queue.set_repeat(RepeatState::Repeating);
    println!("wrap_next={}", navigation(queue.next(false)));
    println!("wrap_previous={}", navigation(queue.previous()));
    let missing = queue.jump(1);
    println!(
        "missing_jump={}",
        matches!(missing, queue_manager::JumpResult::OutOfBounds)
    );

    let mut queue = manager(vec![item(1, &directory.0), item(3, &directory.0)]);
    println!(
        "legacy_remove_without_current={}",
        matches!(
            queue.dequeue(0),
            queue_manager::DequeueResult::RemovedCurrent { .. }
        )
    );
    let mut queue = manager(vec![item(1, &directory.0), item(3, &directory.0)]);
    queue.toggle_shuffle();
    queue.toggle_shuffle();
    println!("legacy_unshuffle_current={:?}", queue.current_position());
    let mut queue = manager(vec![
        item(1, &directory.0),
        item(3, &directory.0),
        item(1, &directory.0),
    ]);
    queue.set_position(2);
    queue.toggle_shuffle();
    queue.toggle_shuffle();
    println!("legacy_duplicate_current={:?}", queue.current_position());
}

#[cfg(test)]
mod compatibility_negatives {
    use super::*;
    #[test]
    #[ignore = "expected pinned legacy failure; replacement preserves NoCurrent"]
    fn remove_zero_without_current_must_not_request_playback() {
        let mut queue = manager(vec![
            item(1, std::path::Path::new("/absent")),
            item(3, std::path::Path::new("/absent")),
        ]);
        assert!(matches!(
            queue.dequeue(0),
            queue_manager::DequeueResult::Removed { .. }
        ));
    }
    #[test]
    #[ignore = "expected pinned legacy failure; replacement preserves NoCurrent"]
    fn unshuffle_without_current_must_not_select_row_zero() {
        let mut queue = manager(vec![
            item(1, std::path::Path::new("/absent")),
            item(3, std::path::Path::new("/absent")),
        ]);
        queue.toggle_shuffle();
        queue.toggle_shuffle();
        assert_eq!(queue.current_position(), None);
    }
    #[test]
    #[ignore = "expected pinned legacy failure; replacement uses unique EntryKey"]
    fn unshuffle_must_preserve_the_selected_duplicate_occurrence() {
        let mut queue = manager(vec![
            item(1, std::path::Path::new("/absent")),
            item(3, std::path::Path::new("/absent")),
            item(1, std::path::Path::new("/absent")),
        ]);
        queue.set_position(2);
        queue.toggle_shuffle();
        queue.toggle_shuffle();
        assert_eq!(queue.current_position(), Some(2));
    }
}
