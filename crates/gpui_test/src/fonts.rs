use anyhow::{Context, Result, ensure};
use gpui::PlatformTextSystem;
use gpui_ce_parley::{ParleyTextSystem, SystemFonts};
use std::borrow::Cow;

/// Pinned font bytes shared by portable captures and native examples.
pub fn bundled_fonts() -> Vec<Cow<'static, [u8]>> {
    let fonts: [&[u8]; 13] = [
        include_bytes!("../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf"),
        include_bytes!("../assets/fonts/ibm-plex-sans/IBMPlexSans-Italic.ttf"),
        include_bytes!("../assets/fonts/ibm-plex-sans/IBMPlexSans-SemiBold.ttf"),
        include_bytes!("../assets/fonts/ibm-plex-sans/IBMPlexSans-SemiBoldItalic.ttf"),
        include_bytes!("../assets/fonts/lilex/Lilex-Regular.ttf"),
        include_bytes!("../assets/fonts/lilex/Lilex-Bold.ttf"),
        include_bytes!("../assets/fonts/lilex/Lilex-Italic.ttf"),
        include_bytes!("../assets/fonts/lilex/Lilex-BoldItalic.ttf"),
        include_bytes!("../assets/fonts/source-serif-4/SourceSerif4[opsz,wght].ttf"),
        include_bytes!("../assets/fonts/noto-sans/NotoSans[wdth,wght].subset.ttf"),
        include_bytes!("../assets/fonts/noto-sans-arabic/NotoSansArabic-Regular.ttf"),
        include_bytes!("../assets/fonts/noto-sans-hebrew/NotoSansHebrew-Regular.ttf"),
        include_bytes!("../assets/fonts/noto-color-emoji/NotoColorEmoji.subset.ttf"),
    ];
    fonts.into_iter().map(Cow::Borrowed).collect()
}

/// Builds the fixed-fallback Parley text system with the fonts bundled in this crate.
pub fn bundled_text_system() -> Result<ParleyTextSystem> {
    let system = ParleyTextSystem::new_with_system_font(SystemFonts::Skip, "IBM Plex Sans")
        .with_fallback_families([
            "Noto Sans Arabic",
            "Noto Sans Hebrew",
            "Noto Color Emoji",
            "Noto Sans",
            "IBM Plex Sans",
            "Lilex",
        ]);
    system
        .add_fonts(bundled_fonts())
        .context("registering bundled scenario fonts")?;
    for (family, character) in [
        ("Noto Sans Arabic", 'ع'),
        ("Noto Sans Hebrew", 'א'),
        ("Noto Color Emoji", '👩'),
    ] {
        let font_id = system.font_id(&gpui::font(family))?;
        ensure!(
            system.glyph_for_char(font_id, character).is_some(),
            "bundled font {family} does not resolve U+{:04X} ({character})",
            character as u32,
        );
    }
    Ok(system)
}
