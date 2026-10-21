use gpui_retained::{Error, FormatIdentity, Independent, Limits, MAX_TILE_BYTES, Surface};

const LIMITS: Limits = Limits {
    max_pixels: 1024 * 1024,
    max_encoded_bytes: 5 * 1024 * 1024,
};
fn surface(width: u32, height: u32) -> Surface {
    Surface {
        width,
        height,
        format: FormatIdentity(*b"rgba8-test-space"),
    }
}

fn pixels(surface: Surface, mut color: impl FnMut(usize, usize) -> [u8; 4]) -> Vec<u8> {
    let mut output = Vec::new();
    for y in 0..surface.height as usize {
        for x in 0..surface.width as usize {
            output.extend_from_slice(&color(x, y));
        }
    }
    output
}

fn assert_tiles(surface: Surface, rgba: &[u8], mut decode: impl FnMut(usize, &mut [u8])) {
    let columns = (surface.width as usize).div_ceil(16);
    let rows = (surface.height as usize).div_ceil(16);
    let mut tile = [0; MAX_TILE_BYTES];
    // Reverse order proves independent random access, including partial edges.
    for index in (0..columns * rows).rev() {
        let x = index % columns * 16;
        let y = index / columns * 16;
        let w = (surface.width as usize - x).min(16);
        let h = (surface.height as usize - y).min(16);
        decode(index, &mut tile[..w * h * 4]);
        for row in 0..h {
            let start = ((y + row) * surface.width as usize + x) * 4;
            assert_eq!(
                &tile[row * w * 4..(row + 1) * w * 4],
                &rgba[start..start + w * 4]
            );
        }
    }
}

#[test]
fn modes_and_partial_edges_match_raw_oracle_with_hidden_transparent_rgb() {
    for (w, h) in [(1, 1), (1, 33), (33, 1), (16, 16), (17, 31), (63, 65)] {
        let s = surface(w, h);
        let mut random = 1u32;
        for mode in 0..4 {
            let image = pixels(s, |x, y| match mode {
                0 => [21, 66, 127, 0],
                1 => {
                    if x % 3 == 0 {
                        [255, 19, 0, 255]
                    } else {
                        [17, 33, 83, 0]
                    }
                }
                2 => [
                    (x as u8).wrapping_mul(7),
                    (y as u8).wrapping_mul(13),
                    (x + y) as u8,
                    3,
                ],
                _ => {
                    random ^= random << 13;
                    random ^= random >> 17;
                    random ^= random << 5;
                    random.to_le_bytes()
                }
            });
            let encoded = Independent::encode(s, &image, LIMITS).unwrap();
            assert_tiles(s, &image, |index, output| {
                encoded.decode_tile(index, output).unwrap()
            });
            let parsed = Independent::parse(encoded.as_bytes().into(), LIMITS).unwrap();
            assert_tiles(s, &image, |index, output| {
                parsed.decode_tile(index, output).unwrap()
            });
            assert_eq!(parsed.surface(), s);
            if w == 16 && h == 16 {
                let modes = encoded.modes();
                match mode {
                    0 => assert_eq!(modes.solid, 1),
                    1 => assert_eq!(modes.palette_runs, 1),
                    _ => assert_eq!(modes.raw, 1),
                }
            }
        }
    }
}

#[test]
fn direct_copy_uses_exact_bytes_and_charges_the_complete_immutable_base() {
    let s = surface(33, 19);
    let image = pixels(s, |x, y| [(x * 11) as u8, (y * 17) as u8, (x + y) as u8, 0]);
    let base = Independent::encode(s, &image, LIMITS).unwrap();
    let unchanged = base.delta(s, &image, LIMITS).unwrap();
    assert_eq!(unchanged.modes().copied, base.tile_count());
    assert_tiles(s, &image, |index, output| {
        unchanged.decode_tile(index, output).unwrap()
    });
    let storage = unchanged.storage();
    assert_eq!(
        storage.base_resident_bytes,
        base.storage().total_resident_bytes
    );
    assert_eq!(
        storage.total_resident_bytes,
        storage.object_bytes + storage.stream_bytes + storage.base_resident_bytes
    );
    assert_eq!(storage.directory_bytes, (unchanged.tile_count() + 1) * 4);

    let mut changed = image.clone();
    changed[0] ^= 1; // hidden transparent RGB is still exact data, not equal.
    let delta = base.delta(s, &changed, LIMITS).unwrap();
    assert_eq!(delta.modes().copied, base.tile_count() - 1);
    assert_tiles(s, &changed, |index, output| {
        delta.decode_tile(index, output).unwrap()
    });
    assert_tiles(s, &image, |index, output| {
        base.decode_tile(index, output).unwrap()
    });
    let incompatible = Surface {
        format: FormatIdentity([7; 16]),
        ..s
    };
    assert!(matches!(
        base.delta(incompatible, &image, LIMITS),
        Err(Error::IdentityMismatch)
    ));
}

#[test]
fn output_and_input_admission_errors_do_not_partially_publish() {
    let s = surface(17, 17);
    let image = pixels(s, |_, _| [1, 2, 3, 4]);
    assert!(matches!(
        Independent::encode(s, &image[..image.len() - 1], LIMITS),
        Err(Error::PixelLength)
    ));
    assert!(matches!(
        Independent::encode(surface(0, 1), &[], LIMITS),
        Err(Error::Dimensions)
    ));
    assert!(matches!(
        Independent::encode(
            s,
            &image,
            Limits {
                max_pixels: 1,
                ..LIMITS
            }
        ),
        Err(Error::LimitExceeded)
    ));
    assert!(matches!(
        Independent::encode(
            s,
            &image,
            Limits {
                max_encoded_bytes: 1,
                ..LIMITS
            }
        ),
        Err(Error::LimitExceeded)
    ));
    assert!(
        Independent::encode(
            surface(u32::MAX, u32::MAX),
            &[],
            Limits {
                max_pixels: usize::MAX,
                max_encoded_bytes: usize::MAX
            }
        )
        .is_err()
    );
    let checkpoint = Independent::encode(s, &image, LIMITS).unwrap();
    let mut output = [91; MAX_TILE_BYTES];
    assert_eq!(
        checkpoint.decode_tile(99, &mut output),
        Err(Error::TileIndex)
    );
    assert_eq!(output, [91; MAX_TILE_BYTES]);
    assert_eq!(
        checkpoint.decode_tile(3, &mut output),
        Err(Error::OutputLength)
    );
    assert_eq!(output, [91; MAX_TILE_BYTES]);
    // One-pixel raw and solid have equal size: raw wins the tie.
    assert_eq!(
        Independent::encode(surface(1, 1), &[1, 2, 3, 4], LIMITS)
            .unwrap()
            .modes()
            .raw,
        1
    );
}

#[test]
fn malformed_directories_runs_headers_and_external_copy_are_rejected() {
    let s = surface(16, 16);
    let image = pixels(s, |x, _| {
        if x % 2 == 0 {
            [1, 2, 3, 0]
        } else {
            [4, 5, 6, 0]
        }
    });
    let checkpoint = Independent::encode(s, &image, LIMITS).unwrap();
    let bytes = checkpoint.as_bytes();
    for end in 0..bytes.len() {
        assert!(Independent::parse(bytes[..end].into(), LIMITS).is_err());
    }
    for (at, value) in [
        (0, 0),
        (32, 2),
        (36, 0),
        (40, 0),
        (44, 3),
        (45, 0),
        (45, 17),
        (54, 255),
        (55, 255),
    ] {
        let mut invalid = bytes.to_vec();
        invalid[at] = value;
        assert!(
            Independent::parse(invalid.into_boxed_slice(), LIMITS).is_err(),
            "byte {at}"
        );
    }
    let mut trailing = bytes.to_vec();
    trailing.push(0);
    assert!(Independent::parse(trailing.into_boxed_slice(), LIMITS).is_err());
    assert!(matches!(
        Independent::parse(
            bytes.into(),
            Limits {
                max_encoded_bytes: bytes.len() - 1,
                ..LIMITS
            }
        ),
        Err(Error::LimitExceeded)
    ));
}

#[test]
fn mutated_untrusted_streams_never_panic_or_write_outside_exact_output() {
    let s = surface(33, 17);
    let image = pixels(s, |x, _| [x as u8 % 4, 2, 3, 0]);
    let seed = Independent::encode(s, &image, LIMITS).unwrap();
    let mut random = 0x1234_5678u32;
    for _ in 0..10_000 {
        let mut bytes = seed.as_bytes().to_vec();
        for _ in 0..4 {
            random ^= random << 13;
            random ^= random >> 17;
            random ^= random << 5;
            let at = random as usize % bytes.len();
            bytes[at] ^= (random >> 24) as u8;
        }
        if let Ok(parsed) = Independent::parse(bytes.into_boxed_slice(), LIMITS) {
            let mut tile = [0; MAX_TILE_BYTES];
            for index in 0..parsed.tile_count() {
                let (w, h) = parsed.tile_dimensions(index).unwrap();
                parsed.decode_tile(index, &mut tile[..w * h * 4]).unwrap();
            }
        }
    }
}

#[test]
fn encoding_has_no_per_tile_allocation_and_parsing_and_decoding_allocate_nothing() {
    let s = surface(256, 256);
    let image = pixels(s, |x, y| [(x / 4) as u8, (y / 4) as u8, 5, 0]);
    let mut checkpoint = None;
    let encoded = allocation_counter::measure(|| {
        checkpoint = Some(Independent::encode(s, &image, LIMITS).unwrap())
    });
    let checkpoint = checkpoint.unwrap();
    assert!(encoded.count_total <= 2, "{encoded:?}"); // output Vec plus final shrink
    assert_eq!(encoded.count_current, 1);
    assert_eq!(encoded.bytes_current as usize, checkpoint.as_bytes().len());
    let delta = checkpoint.delta(s, &image, LIMITS).unwrap();
    let mut output = [0; MAX_TILE_BYTES];
    let decoded = allocation_counter::measure(|| {
        for index in (0..checkpoint.tile_count()).rev() {
            checkpoint.decode_tile(index, &mut output).unwrap();
            delta.decode_tile(index, &mut output).unwrap();
        }
    });
    assert_eq!(decoded.count_total, 0);
    let bytes: Box<[u8]> = checkpoint.as_bytes().into();
    let mut parsed = None;
    let parsed_allocations =
        allocation_counter::measure(|| parsed = Some(Independent::parse(bytes, LIMITS).unwrap()));
    assert_eq!(parsed_allocations.count_total, 0);
    assert_eq!(parsed.unwrap().surface(), s);
}
