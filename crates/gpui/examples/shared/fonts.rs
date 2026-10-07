use std::borrow::Cow;

use gpui::App;

fn bundled_fonts() -> Vec<Cow<'static, [u8]>> {
    let fonts: [&[u8]; 13] = [
        include_bytes!("../../../../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf"),
        include_bytes!("../../../../assets/fonts/ibm-plex-sans/IBMPlexSans-Italic.ttf"),
        include_bytes!("../../../../assets/fonts/ibm-plex-sans/IBMPlexSans-SemiBold.ttf"),
        include_bytes!("../../../../assets/fonts/ibm-plex-sans/IBMPlexSans-SemiBoldItalic.ttf"),
        include_bytes!("../../../../assets/fonts/lilex/Lilex-Regular.ttf"),
        include_bytes!("../../../../assets/fonts/lilex/Lilex-Bold.ttf"),
        include_bytes!("../../../../assets/fonts/lilex/Lilex-Italic.ttf"),
        include_bytes!("../../../../assets/fonts/lilex/Lilex-BoldItalic.ttf"),
        include_bytes!("../../../../assets/fonts/source-serif-4/SourceSerif4[opsz,wght].ttf"),
        include_bytes!("../../../../assets/fonts/noto-sans/NotoSans[wdth,wght].subset.ttf"),
        include_bytes!("../../../../assets/fonts/noto-sans-arabic/NotoSansArabic-Regular.ttf"),
        include_bytes!("../../../../assets/fonts/noto-sans-hebrew/NotoSansHebrew-Regular.ttf"),
        include_bytes!("../../../../assets/fonts/noto-color-emoji/NotoColorEmoji.subset.ttf"),
    ];
    fonts.into_iter().map(Cow::Borrowed).collect()
}

pub fn load_fonts(cx: &App) -> bool {
    if let Err(error) = cx.text_system().add_fonts(bundled_fonts()) {
        #[cfg(target_family = "wasm")]
        web_sys::console::error_1(&format!("failed to load example fonts: {error:#}").into());
        #[cfg(not(target_family = "wasm"))]
        eprintln!("failed to load example fonts: {error:#}");
        false
    } else {
        true
    }
}
