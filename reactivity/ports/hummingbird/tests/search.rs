use hummingbird_gpui_port::{
    database::Database,
    search::{SearchInput, Searcher, Sort, SourceError, Version},
};

fn input(query: &str) -> SearchInput {
    SearchInput {
        query: query.into(),
        sort: Sort::Title,
        version: Version::default(),
    }
}

#[test]
fn real_nucleo_smart_matching_uses_title_plus_nullable_artist_and_unicode() {
    let database = Database::fixture().unwrap();
    let mut searcher = Searcher::default();
    for (query, ids) in [
        ("Alpha", vec![2]),
        ("cafe", vec![13, 11, 21]),
        ("CAFE", vec![13]),
        ("μαρ", vec![44]),
        ("نور", vec![1001]),
        ("cafe zoe", vec![13, 11, 21]),
        ("^other", vec![3]),
        // Upstream matcher0.3.1's case-sensitive ASCII prefix path compares
        // the whole corpus; preserve that observed dependency behavior here.
        ("^Other", vec![]),
        ("None", vec![]),
    ] {
        let page = searcher
            .search(&database, input(query), || false)
            .unwrap()
            .unwrap();
        assert_eq!(page.ids().collect::<Vec<_>>(), ids, "{query:?}");
    }
}

#[test]
fn cancellation_discards_partial_sql_and_matching_results_and_next_query_recovers() {
    let database = Database::fixture().unwrap();
    let mut searcher = Searcher::default();
    let mut checks = 0;
    assert!(
        searcher
            .search(&database, input(""), || {
                checks += 1;
                checks == 4
            })
            .is_none()
    );
    assert_eq!(checks, 4);
    let mut checks = 0;
    assert!(
        searcher
            .search(&database, input(""), || {
                checks += 1;
                // Nine rows now match during retrieval, followed by the final
                // cancellation check before returning the completed page.
                checks == 11
            })
            .is_none()
    );
    let page = searcher
        .search(&database, input("Standalone"), || false)
        .unwrap()
        .unwrap();
    assert_eq!(page.ids().collect::<Vec<_>>(), [2]);
    assert!(matches!(
        searcher
            .search(&database, input(&"α".repeat(513)), || false)
            .unwrap(),
        Err(SourceError::QueryTooLong)
    ));
}

#[test]
fn nonmatching_rows_still_validate_sqlite_text_before_skipping_owned_storage() {
    let database = Database::fixture().unwrap();
    database
        .connection()
        .execute(
            "UPDATE track SET title = CAST(X'FF' AS TEXT) WHERE id = 1",
            [],
        )
        .unwrap();
    let result = Searcher::default()
        .search(&database, input("no matching recording"), || false)
        .unwrap();
    assert!(matches!(result, Err(SourceError::Sqlite(_))));
}
