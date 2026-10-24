//! Untimed syscall control through the real public persistent constructor.
use hummingbird_gpui_port::database::Database;

#[test]
#[ignore = "explicit fresh disk path and external syscall observer required"]
fn public_fresh_library_syscall_control() {
    let path = std::path::PathBuf::from(std::env::var_os("GPUI_SCHEMA_PROBE_PATH").unwrap());
    assert!(
        !path.exists(),
        "control must create a genuinely new database"
    );
    let database = Database::open_library(&path).unwrap();
    let connection = database.connection();
    let foreign_keys: i64 = connection
        .pragma_query_value(None, "foreign_keys", |r| r.get(0))
        .unwrap();
    let synchronous: i64 = connection
        .pragma_query_value(None, "synchronous", |r| r.get(0))
        .unwrap();
    let journal: String = connection
        .pragma_query_value(None, "journal_mode", |r| r.get(0))
        .unwrap();
    let seed: (i64, String, i64, i64) = connection
        .query_row("SELECT id,name,type,position FROM playlist", [], |r| {
            Ok((r.get(0)?, r.get(1)?, r.get(2)?, r.get(3)?))
        })
        .unwrap();
    assert_eq!(foreign_keys, 1);
    assert_eq!(synchronous, 2);
    assert_eq!(journal, "delete");
    assert_eq!(seed, (1, "Liked Songs".into(), 1, 1));
    assert_eq!(
        connection
            .query_row("SELECT version FROM _gpui_library", [], |r| r
                .get::<_, i64>(0))
            .unwrap(),
        1
    );
    println!(
        "CONTROL foreign_keys={foreign_keys} synchronous={synchronous} journal={journal} seed={seed:?}"
    );
    drop(database);
}
