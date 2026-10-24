The bundled primary face is Noto Sans 2.015 at width 100 and weight 400.
`NotoSans-default.ttf` is a derived full static instance: all 4,515 source glyphs,
original glyph IDs, Unicode mappings, scripts and shaping features are retained.
It is not a subset. The library embeds only this primary asset. `NotoSans.ttf`
is the unmodified variable source retained for reproducible generation and
caller-supplied variable-font regression tests.

Source: https://github.com/google/fonts/blob/2984c575fdce412ee02b2baaba67672b9a9434d8/ofl/notosans/NotoSans%5Bwdth%2Cwght%5D.ttf

- Original: 2,049,096 bytes, SHA-256 `bfb7bb691513f12e734dc346c03a03f784912432d7e3fa8e56efcf906fe86b3d`.
- Static instance: 646,160 bytes, SHA-256 `16a1ee5229882c1ba577d265014a85d8a4ddbcf5e45bd30bcfbabfdaf89cabf3`.
- Generator: fontTools 4.67.0, wheel SHA-256 `4304f03ed7f4ba000a8dcc941ad854bfa52e2f3b6112b8f099b6f431cf98e701`.
- Wheel: https://files.pythonhosted.org/packages/3d/61/4161946319472aaa9b897bd18ad5108a5b10f5ebaa503d921a001ac4fff9/fonttools-4.67.0-py3-none-any.whl

To reproduce, download that exact wheel and run:

```sh
python3 crates/canvas/assets/generate-default-font.py /path/to/fonttools-4.67.0-py3-none-any.whl
cargo run -p gpui_canvas --example coverage_table -- crates/canvas/assets/font-coverage.bin
```

The script verifies source, tool and output hashes. It pins both axes at their
declared defaults with `instantiateVariableFont`, `inplace=False`,
`optimize=False`, `recalcTimestamp=False`, and `reorderTables=False`. No package
installation, download at build time, or runtime font transformation is involved.
The 585-byte coverage certificate must be regenerated from the derived asset
and both fallback fonts; its exhaustive scalar test guards future changes.

Copyright 2022 The Noto Project Authors. Both original and derived font software
are distributed under SIL Open Font License 1.1, reproduced with attribution in
`OFL.txt`. The original copyright header declares no Reserved Font Name. The
derived instance retains Noto Sans/Regular naming and its embedded copyright
and OFL license records; it remains under OFL, independently of the library's
Apache license. Keep this notice and `OFL.txt` when redistributing either font.

`TextSystem::bundled()` selects this fixed default face. `TextSystem::new` and
`FontFace::new` still accept caller-supplied variable fonts at their own declared
default instance. A future axis-selection API must explicitly own a variable
font and select matching shaping and raster coordinates; changing the bundled
static face cannot provide axis selection. No absolute path is embedded.
