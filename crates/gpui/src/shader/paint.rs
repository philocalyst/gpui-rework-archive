use std::{
    fmt,
    sync::{Arc, OnceLock},
};

use crate::color::{Hsla, Rgba, hsla_to_rgba};

use super::{
    compiler::{CompiledPaint, ShaderError, compile},
    expr::{self, Input, Kind, Node, Type},
    field::{Field, Scalar, Vec2, Vec3, constant},
};

/// A closed paint value built from typed shader expressions.
///
/// A `Paint` has no bounds or canvas state. Components pass it to a style
/// destination, which supplies its own geometry and compositing behavior.
#[derive(Clone)]
pub struct Paint {
    inner: Arc<PaintInner>,
}

struct PaintInner {
    node: Arc<Node>,
    compiled: OnceLock<Result<CompiledPaint, ShaderError>>,
}

impl PartialEq for Paint {
    fn eq(&self, other: &Self) -> bool {
        Arc::ptr_eq(self.node(), other.node()) || super::compiler::paint_eq(self, other)
    }
}

impl fmt::Debug for Paint {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("Paint").finish_non_exhaustive()
    }
}

impl Paint {
    pub(super) fn from_node(node: Arc<Node>) -> Self {
        debug_assert_eq!(node.ty, Type::Vec4);
        Self {
            inner: Arc::new(PaintInner {
                node,
                compiled: OnceLock::new(),
            }),
        }
    }

    pub(super) fn node(&self) -> &Arc<Node> {
        &self.inner.node
    }

    /// Blend this paint over the back paint using premultiplied source-over.
    pub fn over(&self, back: impl Into<Paint>) -> Paint {
        let back = back.into();
        Paint::from_node(expr::make(
            Type::Vec4,
            Kind::Over(self.node().clone(), back.node().clone()),
        ))
    }

    /// Interpolate premultiplied color values with WGSL `mix` semantics.
    ///
    /// The amount is not clamped, so values outside `[0, 1]` extrapolate.
    pub fn mix(&self, other: impl Into<Paint>, amount: impl Into<Scalar>) -> Paint {
        let other = other.into();
        let amount = amount.into();
        Paint::from_node(expr::make(
            Type::Vec4,
            Kind::Mix(self.node().clone(), other.node().clone(), amount.node),
        ))
    }

    /// Scale all premultiplied color channels by clamped opacity.
    pub fn opacity(&self, amount: impl Into<Scalar>) -> Paint {
        let amount = amount.into();
        Paint::from_node(expr::make(
            Type::Vec4,
            Kind::Opacity(self.node().clone(), amount.node),
        ))
    }

    /// Apply a clamped scalar coverage mask to this subtree.
    pub fn mask(&self, amount: impl Into<Scalar>) -> Paint {
        let amount = amount.into();
        Paint::from_node(expr::make(
            Type::Vec4,
            Kind::Mask(self.node().clone(), amount.node),
        ))
    }

    /// Re-evaluate this paint at a transformed normalized UV coordinate.
    ///
    /// `uv` is the current fragment's normalized coordinate. The mapped paint
    /// shares its source values with other mapped or unmapped uses.
    pub fn map_uv(&self, map: impl FnOnce(Vec2) -> Vec2) -> Paint {
        let uv = Field::from_arc(expr::make(Type::Vec2, Kind::Input(Input::Uv)));
        let mapped = map(uv);
        Paint::from_node(expr::make(
            Type::Vec4,
            Kind::MapUv(self.node().clone(), mapped.node),
        ))
    }

    /// Read the red channel as straight-alpha GPUI sRGB numeric data.
    pub fn red(&self) -> Scalar {
        unpremultiply_component(self.node(), "x")
    }

    /// Read the green channel as straight-alpha GPUI sRGB numeric data.
    pub fn green(&self) -> Scalar {
        unpremultiply_component(self.node(), "y")
    }

    /// Read the blue channel as straight-alpha GPUI sRGB numeric data.
    pub fn blue(&self) -> Scalar {
        unpremultiply_component(self.node(), "z")
    }

    /// Read the alpha channel.
    pub fn alpha(&self) -> Scalar {
        Field::from_arc(expr::make(
            Type::F32,
            Kind::Swizzle(self.node().clone(), "w"),
        ))
    }

    /// Read straight-alpha GPUI sRGB numeric channels.
    pub fn rgb(&self) -> Vec3 {
        let premultiplied: Vec3 = Field::from_arc(expr::make(
            Type::Vec3,
            Kind::Swizzle(self.node().clone(), "xyz"),
        ));
        let alpha = self.alpha();
        let positive = alpha.gt(0.0);
        let safe_alpha = positive.select(&alpha, constant(1.0));
        let straight = premultiplied / safe_alpha;
        positive.select(straight, constant([0.0, 0.0, 0.0]))
    }

    /// Compile and validate this paint, reusing a cached program when possible.
    pub fn compile(&self) -> Result<CompiledPaint, ShaderError> {
        self.inner.compiled.get_or_init(|| compile(self)).clone()
    }
}

impl From<&Paint> for Paint {
    fn from(value: &Paint) -> Self {
        value.clone()
    }
}

fn unpremultiply_component(node: &Arc<Node>, component: &'static str) -> Scalar {
    let raw = Scalar::from_arc(expr::make(
        Type::F32,
        Kind::Swizzle(node.clone(), component),
    ));
    let alpha = Scalar::from_arc(expr::make(Type::F32, Kind::Swizzle(node.clone(), "w")));
    let positive = alpha.gt(0.0);
    let safe_alpha = positive.select(&alpha, constant(1.0));
    let straight = raw / safe_alpha;
    positive.select(straight, constant(0.0))
}

/// A fragment coordinate and geometry context passed to [`shader`].
#[derive(Clone, Debug)]
pub struct Pixel {
    uv: Vec2,
    position: Vec2,
    size: Vec2,
}

impl Pixel {
    pub(super) fn new() -> Self {
        Self {
            uv: Field::from_arc(expr::make(Type::Vec2, Kind::Input(Input::Uv))),
            position: Field::from_arc(expr::make(Type::Vec2, Kind::Input(Input::Position))),
            size: Field::from_arc(expr::make(Type::Vec2, Kind::Input(Input::Size))),
        }
    }

    /// Normalized component UV. Its origin is the painted box's top-left.
    pub fn uv(&self) -> Vec2 {
        self.uv.clone()
    }

    /// Local logical-pixel coordinate, measured from the painted box's top-left.
    pub fn position(&self) -> Vec2 {
        self.position.clone()
    }

    /// Painted box size in logical pixels.
    pub fn size(&self) -> Vec2 {
        self.size.clone()
    }

    /// A backdrop sampler for refraction and glass effects.
    pub fn backdrop(&self) -> Backdrop {
        Backdrop
    }
}

/// Build a concrete paint value from a Rust closure over fragment inputs.
///
/// The closure runs on the CPU to assemble typed expressions; it is not parsed
/// or transpiled. Ordinary Rust helper functions can return and compose paints.
pub fn shader(build: impl FnOnce(Pixel) -> Paint) -> Paint {
    build(Pixel::new())
}

/// A paint source that samples the already-rendered scene behind a component.
#[derive(Clone, Copy, Debug, Default)]
pub struct Backdrop;

impl Backdrop {
    /// Sample the backdrop using normalized component coordinates. The
    /// renderer maps them through the component bounds into the scene texture.
    pub fn sample(&self, uv: impl Into<Vec2>) -> Paint {
        let uv = uv.into();
        Paint::from_node(expr::make(Type::Vec4, Kind::Backdrop(uv.node)))
    }
}

/// Return the current scene as a source for glass and refraction paints.
pub fn backdrop() -> Backdrop {
    Backdrop
}

/// Convert a supported GPUI color into a dynamic paint value.
pub fn color(color: impl IntoPaintColor) -> Paint {
    let [r, g, b, a] = color.into_rgba();
    Paint::from_node(expr::make(
        Type::Vec4,
        Kind::Uniform([
            (r * a).to_bits(),
            (g * a).to_bits(),
            (b * a).to_bits(),
            a.to_bits(),
        ]),
    ))
}

/// Convert straight-alpha channels into a premultiplied fragment paint.
///
/// The channel expressions use GPUI's sRGB numeric channel space. Alpha is
/// clamped to `[0, 1]` before premultiplication.
pub fn rgba(
    red: impl Into<Scalar>,
    green: impl Into<Scalar>,
    blue: impl Into<Scalar>,
    alpha: impl Into<Scalar>,
) -> Paint {
    let red = red.into();
    let green = green.into();
    let blue = blue.into();
    let alpha = alpha.into().clamp(constant(0.0), constant(1.0));
    Paint::from_node(expr::make(
        Type::Vec4,
        Kind::Rgba(red.node, green.node, blue.node, alpha.node),
    ))
}

/// Values accepted by [`color`].
pub trait IntoPaintColor: color_sealed::Sealed + Copy + Send + Sync + 'static {
    #[doc(hidden)]
    fn into_rgba(self) -> [f32; 4];
}

mod color_sealed {
    pub trait Sealed {}
    impl Sealed for crate::color::Hsla {}
    impl Sealed for crate::color::Rgba {}
    impl Sealed for [f32; 4] {}
}

impl IntoPaintColor for Hsla {
    fn into_rgba(self) -> [f32; 4] {
        let converted = hsla_to_rgba(self);
        clamp_rgba([
            converted.color.red,
            converted.color.green,
            converted.color.blue,
            converted.alpha,
        ])
    }
}

impl IntoPaintColor for Rgba {
    fn into_rgba(self) -> [f32; 4] {
        clamp_rgba([
            self.color.red,
            self.color.green,
            self.color.blue,
            self.alpha,
        ])
    }
}

impl IntoPaintColor for [f32; 4] {
    fn into_rgba(self) -> [f32; 4] {
        clamp_rgba(self)
    }
}

fn clamp_rgba(mut rgba: [f32; 4]) -> [f32; 4] {
    if rgba[3].is_finite() {
        rgba[3] = rgba[3].clamp(0.0, 1.0);
    }
    rgba
}
