use gpui::{PlatformTextSystem, SharedString, TextRun, TextSystem, WindowTextSystem, font, px};
use gpui_ce_wgpu::CosmicTextSystem;
use std::{borrow::Cow, sync::Arc};

const IBM_PLEX: &[u8] =
    include_bytes!("../../../assets/fonts/ibm-plex-sans/IBMPlexSans-Regular.ttf");
const LILEX: &[u8] = include_bytes!("../../../assets/fonts/lilex/Lilex-Regular.ttf");

fn window_text_system() -> WindowTextSystem {
    let platform = Arc::new(CosmicTextSystem::new_without_system_fonts("IBM Plex Sans"));
    platform
        .add_fonts(vec![Cow::Borrowed(IBM_PLEX), Cow::Borrowed(LILEX)])
        .expect("test fonts should load");
    let platform: Arc<dyn PlatformTextSystem> = platform;
    WindowTextSystem::new(Arc::new(TextSystem::new(platform)))
}

#[test]
fn multiline_text_keeps_font_runs_aligned_across_unicode_paragraphs() {
    let text_system = window_text_system();
    let text: SharedString = "ab\nlonger\ncafé\n".into();
    let ibm_plex = font("IBM Plex Sans");
    let lilex = font("Lilex");
    let runs = [
        TextRun {
            len: "ab\n".len(),
            font: ibm_plex.clone(),
            ..Default::default()
        },
        TextRun {
            len: "longer\n".len(),
            font: lilex.clone(),
            ..Default::default()
        },
        TextRun {
            len: "café\n".len(),
            font: ibm_plex.clone(),
            ..Default::default()
        },
    ];

    let lines = text_system
        .shape_text(text, px(16.), &runs, None, None)
        .expect("text should shape");

    assert_eq!(lines.len(), 4);
    assert_eq!(
        lines
            .iter()
            .map(|line| line.text.as_ref())
            .collect::<Vec<_>>(),
        ["ab", "longer", "café", ""]
    );
    assert_eq!(
        lines.iter().map(|line| line.len()).collect::<Vec<_>>(),
        [2, 6, 5, 0]
    );

    let expected_fonts = [
        text_system.resolve_font(&ibm_plex),
        text_system.resolve_font(&lilex),
        text_system.resolve_font(&ibm_plex),
    ];
    for (line, expected_font) in lines.iter().zip(expected_fonts) {
        assert!(line.width() > px(0.));
        assert!(
            !line.runs().is_empty(),
            "nonempty text should produce shaped glyph runs"
        );
        assert!(line.runs().iter().all(|run| run.font_id == expected_font));
    }

    assert!(lines[3].runs().is_empty());
    assert_eq!(lines[3].width(), px(0.));
}
