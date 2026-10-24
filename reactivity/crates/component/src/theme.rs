//! Semantic palette and scales, owned by the application and passed by borrow.
use gpui::Color;

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum Size {
    XSmall,
    Small,
    #[default]
    Medium,
    Large,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Space {
    Optical,
    Part,
    Related,
    Group,
    Section,
    Region,
}

/// One complete semantic snapshot; custom scales persist with their owner.
#[derive(Clone, Debug)]
pub struct Theme {
    background: Color,
    surface: Color,
    raised: Color,
    foreground: Color,
    muted: Color,
    accent: Color,
    on_accent: Color,
    border: Color,
    focus: Color,
    danger: Color,
    success: Color,
    base_font: f64,
    radius: f32,
}
impl Theme {
    pub fn halloween() -> Self {
        fn c(l: f32, chroma: f32, hue: f32) -> Color {
            Color::oklch(l, chroma, hue, 1.0).expect("finite theme token")
        }
        Self {
            background: c(0.16, 0.018, 295.0),
            surface: c(0.21, 0.022, 295.0),
            raised: c(0.27, 0.028, 295.0),
            foreground: c(0.94, 0.025, 80.0),
            muted: c(0.72, 0.022, 295.0),
            accent: c(0.77, 0.15, 60.0),
            on_accent: c(0.19, 0.035, 50.0),
            border: c(0.39, 0.025, 295.0),
            focus: c(0.86, 0.10, 80.0),
            danger: c(0.73, 0.15, 25.0),
            success: c(0.77, 0.10, 150.0),
            base_font: 14.0,
            radius: 6.0,
        }
    }
    pub fn light() -> Self {
        fn c(l: f32, chroma: f32, hue: f32) -> Color {
            Color::oklch(l, chroma, hue, 1.0).expect("finite theme token")
        }
        Self {
            background: c(0.98, 0.006, 80.0),
            surface: c(0.94, 0.008, 80.0),
            raised: c(0.89, 0.012, 80.0),
            foreground: c(0.22, 0.018, 295.0),
            muted: c(0.48, 0.018, 295.0),
            accent: c(0.55, 0.14, 50.0),
            on_accent: c(0.98, 0.006, 80.0),
            border: c(0.74, 0.015, 295.0),
            focus: c(0.48, 0.14, 50.0),
            danger: c(0.51, 0.17, 25.0),
            success: c(0.43, 0.10, 150.0),
            base_font: 14.0,
            radius: 6.0,
        }
    }
    pub fn with_base_font(mut self, size: f64) -> Self {
        assert!(size.is_finite() && size > 0.0);
        self.base_font = size;
        self
    }
    pub fn with_radius(mut self, radius: f32) -> Self {
        assert!(radius.is_finite() && radius >= 0.0);
        self.radius = radius;
        self
    }
    pub fn with_accent(mut self, accent: Color, foreground: Color) -> Self {
        self.accent = accent;
        self.on_accent = foreground;
        self
    }
    pub fn background(&self) -> Color {
        self.background
    }
    pub fn surface(&self) -> Color {
        self.surface
    }
    pub fn raised(&self) -> Color {
        self.raised
    }
    pub fn foreground(&self) -> Color {
        self.foreground
    }
    pub fn muted(&self) -> Color {
        self.muted
    }
    pub fn accent(&self) -> Color {
        self.accent
    }
    pub fn on_accent(&self) -> Color {
        self.on_accent
    }
    pub fn border(&self) -> Color {
        self.border
    }
    pub fn focus(&self) -> Color {
        self.focus
    }
    pub fn danger(&self) -> Color {
        self.danger
    }
    pub fn success(&self) -> Color {
        self.success
    }
    pub fn radius(&self) -> f32 {
        self.radius
    }
    pub fn font_size(&self) -> f64 {
        self.base_font
    }
    pub fn rem(&self, value: f64) -> f64 {
        self.base_font * value
    }
    pub fn space(&self, space: Space) -> f64 {
        self.rem(match space {
            Space::Optical => 1.0 / 7.0,
            Space::Part => 2.0 / 7.0,
            Space::Related => 4.0 / 7.0,
            Space::Group => 6.0 / 7.0,
            Space::Section => 12.0 / 7.0,
            Space::Region => 16.0 / 7.0,
        })
    }
    pub fn control_height(&self, size: Size) -> f64 {
        self.rem(match size {
            Size::XSmall => 10.0 / 7.0,
            Size::Small => 12.0 / 7.0,
            Size::Medium => 16.0 / 7.0,
            Size::Large => 22.0 / 7.0,
        })
    }
    pub fn control_font(&self, size: Size) -> f64 {
        self.rem(match size {
            Size::XSmall | Size::Small => 6.0 / 7.0,
            Size::Medium => 1.0,
            Size::Large => 8.0 / 7.0,
        })
    }
}
impl Default for Theme {
    fn default() -> Self {
        Self::light()
    }
}
