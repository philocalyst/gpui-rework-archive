use hummingbird_gpui_port::{
    database::Database,
    query::{TrackColumn, tracks},
};

#[test]
fn original_three_track_fixture_preserves_artist_album_and_liked_joins() {
    let database = Database::fixture().unwrap();
    let connection = database.connection();
    assert_eq!(
        tracks()
            .from_artist(1)
            .sort_asc(TrackColumn::Title)
            .fetch_ids(connection)
            .unwrap(),
        [1, 3, 2]
    );
    assert_eq!(
        tracks()
            .from_album(10)
            .sort_asc(TrackColumn::TrackNumber)
            .fetch_ids(connection)
            .unwrap(),
        [1, 3]
    );
    assert_eq!(
        tracks().liked_by_artist(1).fetch_ids(connection).unwrap(),
        [2]
    );
    assert_eq!(
        tracks()
            .standalone_for_artist(1)
            .fetch_ids(connection)
            .unwrap(),
        [2]
    );
    assert_eq!(
        tracks()
            .from_artist(2)
            .sort_asc(TrackColumn::Title)
            .fetch_ids(connection)
            .unwrap(),
        [13, 11, 21]
    );
}

#[test]
fn projection_is_not_matching_and_nullable_track_artist_is_not_album_artist() {
    let database = Database::fixture().unwrap();
    let rows = tracks()
        .sort_asc(TrackColumn::Title)
        .for_search()
        .fetch_rows(database.connection())
        .unwrap();
    assert_eq!(rows.len(), 9);
    let original = rows.iter().find(|row| row.id == 1).unwrap();
    assert_eq!(original.title, "Album Track");
    assert_eq!(original.album_id, Some(10));
    assert_eq!(original.artist_names, None);
    assert_eq!(
        rows.iter().find(|row| row.id == 90).unwrap().artist_names,
        None
    );
    assert_eq!(
        rows.iter()
            .find(|row| row.id == 44)
            .unwrap()
            .artist_names
            .as_deref(),
        Some("Μαρία")
    );
    let playback = tracks()
        .by_id(21)
        .for_playback()
        .fetch_rows(database.connection())
        .unwrap();
    assert_eq!(playback.len(), 1);
    assert_eq!(playback[0].id, 21);
    assert_eq!(playback[0].location.to_str(), Some("/music/z.flac"));
    let queued = tracks()
        .by_id(21)
        .for_queue()
        .fetch_rows(database.connection())
        .unwrap();
    assert_eq!(queued[0].id, playback[0].id);
    assert_eq!(queued[0].location, playback[0].location);
    assert_eq!(queued[0].title, "Café Étude");
    assert_eq!(
        tracks()
            .at_path(&playback[0].location)
            .fetch_ids(database.connection())
            .unwrap(),
        [21]
    );
    assert_eq!(
        tracks()
            .at_locations(["/music/z.flac".into(), "/music/44.flac".into()])
            .sort_asc(TrackColumn::Title)
            .fetch_ids(database.connection())
            .unwrap(),
        [21, 44]
    );
}

#[test]
fn actual_sql_ordering_preserves_ties_gapped_ids_and_upstream_title_desc_quirk() {
    let database = Database::fixture().unwrap();
    let connection = database.connection();
    for (column, expected) in [
        (TrackColumn::Title, vec![1, 13, 11, 21, 3, 2, 90, 44, 1001]),
        (TrackColumn::Artist, vec![90, 2, 1, 3, 11, 13, 21, 44, 1001]),
        (TrackColumn::Genres, vec![3, 2, 44, 1001, 1, 90, 13, 11, 21]),
    ] {
        assert_eq!(
            tracks().sort_asc(column).fetch_ids(connection).unwrap(),
            expected,
            "{column:?}"
        );
    }
    // Pinned upstream compatibility: title stays ASC; only its location tie
    // breaker changes direction. Do not silently "fix" this as a Vec reverse.
    assert_eq!(
        tracks()
            .sort_desc(TrackColumn::Title)
            .fetch_ids(connection)
            .unwrap(),
        [1, 13, 21, 11, 3, 2, 90, 44, 1001]
    );
    assert_eq!(
        tracks()
            .sort_desc(TrackColumn::Length)
            .fetch_ids(connection)
            .unwrap(),
        [13, 11, 21, 90, 44, 1001, 1, 3, 2]
    );
}
