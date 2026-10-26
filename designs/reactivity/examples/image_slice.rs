//! Bevy `ui_texture_slice` / `ui_texture_atlas` + Slint `colorize`, as 07 image policy.
//!
//! Two paint verbs that look similar and are not:
//!   - `.colorize(brush)` — alpha mask → brush (icons, SVG, mask PNGs)
//!   - `.tint(color)`     — multiply on a decoded photo (white = identity)
//! A mask that is also tinted is a located error naming both.
//!
//! 9-slice / tile / atlas / crop / flip do not change acquisition. Auto/None fit
//! installs a Taffy measure fn from the texture; slice/tile/Fill clear it.

use gpui::prelude::*;

const PANEL: Asset = asset!("chrome/panel.png");
const GRID: Asset = asset!("chrome/grid.png");
const ICONS: Asset = asset!("icons.png");
const PHOTO: Asset = asset!("photo.jpg");

struct Chrome {
    photo: PathBuf,
}

impl Default for Chrome {
    fn default() -> Self {
        Self {
            photo: PathBuf::from("photo.jpg"),
        }
    }
}

impl View for Chrome {
    fn view(&self) -> El<'_> {
        column((
            // Desktop chrome: corners stay sharp, center stretches.
            // Measure fn is cleared (Bevy ImageMeasure); size comes from style.
            image(PANEL).slice(NineSlice::px(12)).w(pct(100)).h(120),
            text("Title").text_color(theme.accent.on),
            // Wallpaper / pattern.
            image(GRID).tile(Tile::XY).h(80),
            row((
                image(ICONS).atlas(16, 16).index(0),
                image(ICONS).atlas(16, 16).index(3).flip(true, false),
                icon(Magnifier).colorize(theme.accent.on),
            ))
            .gap_2(),
            // Photo: multiply tint is not colorize.
            image(&self.photo).fit(Fit::Cover).tint(0x88aaff).size(160, 100),
            // Debug / tests: no file.
            image(SolidColor(theme.surface.weak)).size(40, 40),
        ))
        .w(vw(50))
        .min_h(vmin(40))
        .gap_4()
        .p_4()
    }
}

fn main() {
    Application::run(Window::document(Chrome::default()).title("Slice").size(640, 480));
}
