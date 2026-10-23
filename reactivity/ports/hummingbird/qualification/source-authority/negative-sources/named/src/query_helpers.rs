fn push_filter_prefix(query: &mut Statement, has_filter: &mut bool) {
    query.push(if *has_filter { " AND " } else { " WHERE " });
    *has_filter = true;
}

fn push_artist_filter(query: &mut Statement, filter: ArtistFilter) {
    match filter {
        ArtistFilter::Credited(artist_id) => push_artist_credit(query, artist_id),
        ArtistFilter::Liked(artist_id) => {
            query.push(
                "EXISTS (
                    SELECT 1
                    FROM playlist_item
                    WHERE playlist_item.track_id = track.id
                      AND playlist_item.playlist_id = 1
                ) AND ",
            );
            push_artist_credit(query, artist_id);
        }
        ArtistFilter::Standalone(artist_id) => {
            query
                .push(
                    "track.id IN (
                        SELECT track_artist.track_id
                        FROM track_artist
                        WHERE track_artist.artist_id = ",
                )
                .push_bind(artist_id)
                .push(
                    "
                    ) AND NOT EXISTS (
                        SELECT 1
                        FROM album_artist
                        WHERE album_artist.album_id = track.album_id
                          AND album_artist.artist_id = ",
                )
                .push_bind(artist_id)
                .push(")");
        }
    }
}

fn push_artist_credit(query: &mut Statement, artist_id: i64) {
    query
        .push(
            "track.id IN (
                SELECT album_track.id
                FROM album_artist
                JOIN track AS album_track ON album_track.album_id = album_artist.album_id
                WHERE album_artist.artist_id = ",
        )
        .push_bind(artist_id)
        .push(
            "
            UNION
                SELECT track_artist.track_id
                FROM track_artist
                WHERE track_artist.artist_id = ",
        )
        .push_bind(artist_id)
        .push(")");
}

fn push_ordering_key(
    query: &mut Statement,
    ordering: TrackOrdering,
    artist_filter: Option<ArtistFilter>,
    is_primary: bool,
) {
    let direction = ordering.direction.sql();
    match ordering.key {
        TrackOrderingKey::Column(TrackColumn::Title) => {
            if matches!(
                artist_filter,
                Some(ArtistFilter::Liked(_) | ArtistFilter::Standalone(_))
            ) {
                query.push("track.title_sortable").push(direction);
            } else if is_primary {
                // Preserve the legacy library-table ordering: its title key is always ascending.
                query.push("track.title_sortable ASC");
            } else {
                query.push("track.title_sortable").push(direction);
            }
        }
        TrackOrderingKey::Column(TrackColumn::Artist) => {
            query
                .push("COALESCE(album.artist_sort, track.artist_sort, track.artist_names) COLLATE NOCASE")
                .push(direction);
        }
        TrackOrderingKey::Column(TrackColumn::Album) => {
            query
                .push("album.title_sortable COLLATE NOCASE")
                .push(direction);
        }
        TrackOrderingKey::Column(TrackColumn::Length) => {
            query.push("track.duration").push(direction);
        }
        TrackOrderingKey::Column(TrackColumn::TrackNumber) => {
            query
                .push("track.disc_number")
                .push(direction)
                .push(", track.track_number")
                .push(direction)
                .push(", track.track_section ASC");
        }
        TrackOrderingKey::Column(TrackColumn::Genres) => {
            query
                .push("COALESCE(genres.genre_sort, '') COLLATE NOCASE")
                .push(direction);
        }
        TrackOrderingKey::ReleaseDate => {
            if matches!(artist_filter, Some(ArtistFilter::Standalone(_))) {
                query
                    .push("track.release_date")
                    .push(direction)
                    .push(", track.id")
                    .push(direction);
            } else if let Some(ArtistFilter::Liked(artist_id)) = artist_filter {
                query.push("CASE WHEN ");
                push_album_credit_exists(query, artist_id);
                query.push(" THEN 0 ELSE 1 END ASC, CASE WHEN ");
                push_album_credit_exists(query, artist_id);
                query
                    .push(" THEN COALESCE(album.release_date, track.release_date) ELSE track.release_date END")
                    .push(direction)
                    .push(", CASE WHEN ");
                push_album_credit_exists(query, artist_id);
                query
                    .push(" THEN album.id ELSE track.id END")
                    .push(direction);
            } else {
                query
                    .push("CASE WHEN track.album_id IS NULL THEN 1 ELSE 0 END ASC")
                    .push(", COALESCE(album.release_date, track.release_date)")
                    .push(direction)
                    .push(", COALESCE(album.id, track.id)")
                    .push(direction);
            }
            query
                .push(", track.disc_number")
                .push(direction)
                .push(", track.track_number")
                .push(direction)
                .push(", track.track_section ASC");
        }
        TrackOrderingKey::RecentlyAdded => {
            if matches!(artist_filter, Some(ArtistFilter::Liked(_))) {
                query.push(
                    "(SELECT playlist_item.created_at
                      FROM playlist_item
                      WHERE playlist_item.track_id = track.id
                        AND playlist_item.playlist_id = 1
                      LIMIT 1)",
                );
            } else {
                query.push("track.created_at");
            }
            query.push(direction);
        }
    }
}

fn push_album_credit_exists(query: &mut Statement, artist_id: i64) {
    query
        .push(
            "EXISTS (
                SELECT 1
                FROM album_artist
                WHERE album_artist.album_id = track.album_id
                  AND album_artist.artist_id = ",
        )
        .push_bind(artist_id)
        .push(")");
}

fn push_tie_breakers(
    query: &mut Statement,
    primary: TrackOrdering,
    artist_filter: Option<ArtistFilter>,
) {
    match primary.key {
        TrackOrderingKey::Column(TrackColumn::Title) => {
            if matches!(
                artist_filter,
                Some(ArtistFilter::Liked(_) | ArtistFilter::Standalone(_))
            ) {
                query.push(", track.id ASC");
            } else {
                query
                    .push(", track.album_id ASC, track.location COLLATE NOCASE")
                    .push(primary.direction.sql())
                    .push(", track.id ASC");
            }
        }
        TrackOrderingKey::Column(TrackColumn::Artist) => {
            query.push(
                ", album.title_sortable COLLATE NOCASE ASC,
                 track.disc_number ASC,
                 track.track_number ASC,
                 track.track_section ASC,
                 track.id ASC",
            );
        }
        TrackOrderingKey::Column(TrackColumn::Album) => {
            query.push(
                ", track.disc_number ASC,
                 track.track_number ASC,
                 track.track_section ASC,
                 track.id ASC",
            );
        }
        TrackOrderingKey::Column(TrackColumn::Length) => {
            query.push(", track.title_sortable COLLATE NOCASE ASC, track.id ASC");
        }
        TrackOrderingKey::Column(TrackColumn::TrackNumber) | TrackOrderingKey::ReleaseDate => {
            query.push(", track.id ASC");
        }
        TrackOrderingKey::Column(TrackColumn::Genres) => {
            query.push(
                ", track.title_sortable COLLATE NOCASE ASC,
                 track.album_id ASC,
                 track.location COLLATE NOCASE ASC,
                 track.id ASC",
            );
        }
        TrackOrderingKey::RecentlyAdded => {
            query.push(", track.id ASC");
        }
    }
}
