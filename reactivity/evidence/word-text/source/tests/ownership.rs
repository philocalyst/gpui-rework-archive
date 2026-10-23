use gpui_word_text_spike::WordText;

fn values() -> Vec<String> {
    let mut values = vec![
        String::new(),
        "Play".into(),
        "Pause".into(),
        "éλ".into(),
        "🎵".into(),
    ];
    for length in 1..=24 {
        values.push("a".repeat(length));
        values.push("\0".repeat(length));
        values.push("é".repeat(length));
        values.push("λ".repeat(length));
        values.push("音".repeat(length));
        values.push("🎵".repeat(length));
    }
    values
}

#[test]
fn niche_content_move_clone_and_borrow_agree_with_owned_strings() {
    assert_eq!(size_of::<WordText>(), size_of::<usize>());
    assert_eq!(size_of::<Option<WordText>>(), size_of::<usize>());
    assert_eq!(align_of::<WordText>(), align_of::<usize>());
    let values = values();
    let mut texts = Vec::new();
    for value in &values {
        let original = WordText::from(value.as_str());
        assert_eq!(&*original, value);
        let copy = original.clone();
        assert_eq!(original, copy);
        drop(original);
        assert_eq!(&*copy, value);
        texts.push(copy);
    }
    for (text, value) in texts.iter().zip(&values) {
        assert_eq!(&**text, value);
    }
    for (i, left) in texts.iter().enumerate() {
        for (j, right) in texts.iter().enumerate() {
            assert_eq!(left == right, values[i] == values[j]);
        }
    }
    let copied = texts.clone();
    drop(texts);
    for (text, value) in copied.iter().zip(&values) {
        assert_eq!(&**text, value);
    }
}

#[test]
fn immutable_leases_and_inline_bytes_cross_threads() {
    let expected = values();
    let texts: Vec<_> = expected
        .iter()
        .map(|value| WordText::from(value.as_str()))
        .collect();
    let moved = texts.clone();
    let moved_expected = expected.clone();
    std::thread::scope(|scope| {
        let borrowed = &texts;
        let expected_ref = &expected;
        scope.spawn(move || {
            for (text, value) in borrowed.iter().zip(expected_ref) {
                assert_eq!(&**text, value);
            }
        });
        scope.spawn(move || {
            for (text, value) in moved.into_iter().zip(moved_expected) {
                let clone = text.clone();
                drop(text);
                assert_eq!(&*clone, value);
            }
        });
    });
}

#[cfg(not(miri))]
#[test]
fn allocation_requests_remove_short_payloads_and_preserve_long_arcstr_cost() {
    for value in values() {
        let mut text = None;
        let measured = allocation_counter::measure(|| text = Some(WordText::from(value.as_str())));
        let inline = !value.is_empty() && value.len() < size_of::<usize>();
        assert_eq!(
            measured.count_total,
            u64::from(!inline && !value.is_empty())
        );
        assert_eq!(
            measured.bytes_total,
            if inline || value.is_empty() {
                0
            } else {
                (2 * size_of::<usize>() + value.len()) as u64
            }
        );
        assert_eq!(&**text.as_ref().unwrap(), value);
        let clones = allocation_counter::measure(|| {
            for _ in 0..32 {
                std::hint::black_box(text.as_ref().unwrap().clone());
            }
        });
        assert_eq!(clones.count_total, 0);
    }
}
