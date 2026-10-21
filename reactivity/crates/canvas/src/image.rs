//! Immutable caller-owned pixels. Decoding and I/O belong outside the UI core.
use crate::{Color, Error};
use std::sync::{
    Arc,
    atomic::{AtomicU64, Ordering},
};

mod transfer;

/// Maximum sum of distinct image payload bytes in one logical/canonical scene.
/// Old presentation cohorts, application leases and GPU storage are separate
/// owners; this is not a whole-window or process memory budget.
pub const MAX_IMAGE_SCENE_BYTES: usize = 64 * 1024 * 1024;

const MAX_PIXELS: usize = 4 * 1024 * 1024;
const MAX_SIDE: u32 = 16_384;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ImageProfile {
    Srgb,
    DisplayP3,
}

/// Alpha interpretation in the supplied channel space. Encoded premultiplied
/// RGB is unpremultiplied before transfer decoding, then premultiplied in linear
/// light. A zero-alpha texel contributes transparent black when sampled.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum AlphaMode {
    Straight,
    Premultiplied,
}

/// Reconstruction happens in premultiplied linear light, before compositing.
/// Both modes retain the canvas's correlated 4×4 coverage samples. Linear uses
/// texel-center bilinear reconstruction with clamped edge texels, not mipmaps.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum ImageSampling {
    Nearest,
    #[default]
    Linear,
}

/// Material reconstruction and optional local analytic shape. A zero radius
/// retains the ordinary rectangle path; a positive radius rounds only this
/// image placement, without changing or duplicating its immutable pixels.
#[derive(Clone, Copy, Debug)]
pub struct ImageOptions {
    pub sampling: ImageSampling,
    pub corner_radius: f32,
}
impl Default for ImageOptions {
    fn default() -> Self {
        Self {
            sampling: ImageSampling::Linear,
            corner_radius: 0.0,
        }
    }
}

/// Exact immutable allocation identity, never a content hash or external key.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct ImageKey(u64);

enum Pixels {
    Rgba8 {
        bytes: Box<[u8]>,
        profile: ImageProfile,
        alpha: AlphaMode,
    },
    Linear(Box<[[f32; 4]]>),
}
struct ImageData {
    key: ImageKey,
    width: u32,
    height: u32,
    pixels: Pixels,
}

/// An immutable, explicitly leased resource. Cloning leases the same pixels;
/// constructing a new image creates a distinct identity, even for equal bytes.
/// RGBA8 remains four bytes per texel; linear HDR is explicitly sixteen.
#[derive(Clone)]
pub struct Image(Arc<ImageData>);
impl std::fmt::Debug for Image {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Image")
            .field("key", &self.0.key)
            .field("width", &self.width())
            .field("height", &self.height())
            .field("pixel_bytes", &self.pixel_bytes())
            .finish()
    }
}
impl PartialEq for Image {
    fn eq(&self, other: &Self) -> bool {
        self.0.key == other.0.key
    }
}
impl Eq for Image {}

fn count(width: u32, height: u32) -> Result<usize, Error> {
    let pixels = u64::from(width) * u64::from(height);
    if width == 0 || height == 0 || width > MAX_SIDE || height > MAX_SIDE {
        return Err(Error::InvalidDimensions);
    }
    if pixels > MAX_PIXELS as u64 {
        return Err(Error::ResourceLimit);
    }
    Ok(pixels as usize)
}
impl Image {
    /// Packed row-major R,G,B,A, with no row padding. Premultiplied encoded
    /// input requires each RGB byte ≤ alpha; alpha zero then requires RGB zero.
    /// Straight input may retain hidden RGB, but zero alpha samples as black.
    pub fn rgba8(
        width: u32,
        height: u32,
        profile: ImageProfile,
        alpha: AlphaMode,
        bytes: Box<[u8]>,
    ) -> Result<Self, Error> {
        let count = count(width, height)?;
        if bytes.len() != count.checked_mul(4).ok_or(Error::ResourceLimit)? {
            return Err(Error::InvalidImageLength);
        }
        if alpha == AlphaMode::Premultiplied
            && bytes
                .chunks_exact(4)
                .any(|p| p[..3].iter().any(|&v| v > p[3]))
        {
            return Err(Error::InvalidImageAlpha);
        }
        Self::new(
            width,
            height,
            Pixels::Rgba8 {
                bytes,
                profile,
                alpha,
            },
        )
    }

    /// Scene-relative extended linear sRGB, with neutral 1 using the scene's
    /// reference white. Finite RGB magnitude ≤ 1e20 and alpha in [0,1].
    /// Straight input is canonicalized in place to premultiplied working pixels;
    /// this constructor does not promise original straight-channel bit identity.
    /// Premultiplied zero-alpha input must have zero RGB. Zero-alpha samples are
    /// transparent black, irrespective of signed-zero payloads.
    pub fn linear_srgb(
        width: u32,
        height: u32,
        alpha: AlphaMode,
        mut pixels: Box<[[f32; 4]]>,
    ) -> Result<Self, Error> {
        if pixels.len() != count(width, height)? {
            return Err(Error::InvalidImageLength);
        }
        for pixel in pixels.iter() {
            if pixel.iter().any(|v| !v.is_finite()) || !(0.0..=1.0).contains(&pixel[3]) {
                return Err(Error::InvalidColor);
            }
            if pixel[..3].iter().any(|v| v.abs() > 1e20) {
                return Err(Error::ColorOutOfRange);
            }
            if alpha == AlphaMode::Premultiplied
                && pixel[3] == 0.0
                && pixel[..3].iter().any(|&v| v != 0.0)
            {
                return Err(Error::InvalidImageAlpha);
            }
        }
        for pixel in pixels.iter_mut() {
            if pixel[3] == 0.0 {
                *pixel = [0.0; 4];
            } else if alpha == AlphaMode::Straight {
                let opacity = pixel[3];
                for channel in &mut pixel[..3] {
                    *channel *= opacity;
                }
            }
        }
        Self::new(width, height, Pixels::Linear(pixels))
    }
    fn new(width: u32, height: u32, pixels: Pixels) -> Result<Self, Error> {
        static NEXT: AtomicU64 = AtomicU64::new(1);
        let key = NEXT
            .fetch_update(Ordering::Relaxed, Ordering::Relaxed, |id| id.checked_add(1))
            .map_err(|_| Error::ResourceLimit)?;
        Ok(Self(Arc::new(ImageData {
            key: ImageKey(key),
            width,
            height,
            pixels,
        })))
    }
    pub fn width(&self) -> u32 {
        self.0.width
    }
    pub fn height(&self) -> u32 {
        self.0.height
    }
    pub fn key(&self) -> ImageKey {
        self.0.key
    }
    pub fn pixel_bytes(&self) -> usize {
        match &self.0.pixels {
            Pixels::Rgba8 { bytes, .. } => bytes.len(),
            Pixels::Linear(pixels) => pixels.len() * 16,
        }
    }
    pub fn view(&self) -> ImageView<'_> {
        ImageView {
            key: self.key(),
            width: self.width(),
            height: self.height(),
            pixels: match &self.0.pixels {
                Pixels::Rgba8 {
                    bytes,
                    profile,
                    alpha,
                } => ImagePixels::Rgba8 {
                    bytes,
                    profile: *profile,
                    alpha: *alpha,
                },
                Pixels::Linear(pixels) => ImagePixels::LinearPremultiplied(pixels),
            },
        }
    }
}

#[derive(Clone, Copy, Debug)]
pub enum ImagePixels<'a> {
    Rgba8 {
        bytes: &'a [u8],
        profile: ImageProfile,
        alpha: AlphaMode,
    },
    LinearPremultiplied(&'a [[f32; 4]]),
}
/// Borrowed validated resource; no Arc increment and no temporary pixel copy.
#[derive(Clone, Copy, Debug)]
pub struct ImageView<'a> {
    key: ImageKey,
    width: u32,
    height: u32,
    pixels: ImagePixels<'a>,
}
impl<'a> ImageView<'a> {
    pub fn key(self) -> ImageKey {
        self.key
    }
    pub fn width(self) -> u32 {
        self.width
    }
    pub fn height(self) -> u32 {
        self.height
    }
    pub fn pixels(self) -> ImagePixels<'a> {
        self.pixels
    }
    pub fn pixel_bytes(self) -> usize {
        match self.pixels {
            ImagePixels::Rgba8 { bytes, .. } => bytes.len(),
            ImagePixels::LinearPremultiplied(pixels) => pixels.len() * 16,
        }
    }
    pub(crate) fn needs_decode_memo(self) -> bool {
        matches!(
            self.pixels,
            ImagePixels::Rgba8 {
                profile: ImageProfile::DisplayP3,
                ..
            } | ImagePixels::Rgba8 {
                alpha: AlphaMode::Premultiplied,
                ..
            }
        )
    }
    pub(crate) fn texel(self, x: usize, y: usize) -> [f32; 4] {
        let index = y * self.width as usize + x;
        match self.pixels {
            ImagePixels::LinearPremultiplied(pixels) => pixels[index],
            ImagePixels::Rgba8 {
                bytes,
                profile,
                alpha,
            } => {
                let mut p: [f32; 4] = std::array::from_fn(|i| bytes[index * 4 + i] as f32 / 255.0);
                if p[3] == 0.0 {
                    return [0.0; 4];
                }
                if alpha == AlphaMode::Straight && profile == ImageProfile::Srgb {
                    return [
                        f32::from_bits(transfer::SRGB_BYTE[bytes[index * 4] as usize]) * p[3],
                        f32::from_bits(transfer::SRGB_BYTE[bytes[index * 4 + 1] as usize]) * p[3],
                        f32::from_bits(transfer::SRGB_BYTE[bytes[index * 4 + 2] as usize]) * p[3],
                        p[3],
                    ];
                }
                if alpha == AlphaMode::Premultiplied {
                    let opacity = p[3];
                    for channel in &mut p[..3] {
                        *channel /= opacity;
                    }
                }
                // Byte input and validated encoded premultiplication keep every
                // straight channel in [0,1], hence Color admission cannot fail.
                match profile {
                    ImageProfile::Srgb => Color::srgb(p[0], p[1], p[2], p[3]),
                    ImageProfile::DisplayP3 => Color::display_p3(p[0], p[1], p[2], p[3]),
                }
                .expect("validated encoded texel")
                .premultiplied()
            }
        }
    }
    pub(crate) fn sample(
        self,
        x: f64,
        y: f64,
        width: f64,
        height: f64,
        sampling: ImageSampling,
    ) -> Option<[f32; 4]> {
        self.sample_with(x, y, width, height, sampling, |x, y| self.texel(x, y))
    }
    fn sample_with(
        self,
        x: f64,
        y: f64,
        width: f64,
        height: f64,
        sampling: ImageSampling,
        mut texel: impl FnMut(usize, usize) -> [f32; 4],
    ) -> Option<[f32; 4]> {
        if x < 0.0 || y < 0.0 || x >= width || y >= height {
            return None;
        }
        let x = x * (f64::from(self.width) / width);
        let y = y * (f64::from(self.height) / height);
        if sampling == ImageSampling::Nearest {
            return Some(texel(
                (x as usize).min(self.width as usize - 1),
                (y as usize).min(self.height as usize - 1),
            ));
        }
        let (x, y) = (x - 0.5, y - 0.5);
        let (left, top) = (x.floor(), y.floor());
        let (fx, fy) = ((x - left) as f32, (y - top) as f32);
        let column = |x: f64| x.max(0.0).min(f64::from(self.width - 1)) as usize;
        let row = |y: f64| y.max(0.0).min(f64::from(self.height - 1)) as usize;
        let a = texel(column(left), row(top));
        let b = texel(column(left + 1.0), row(top));
        let c = texel(column(left), row(top + 1.0));
        let d = texel(column(left + 1.0), row(top + 1.0));
        Some(lerp(lerp(a, b, fx), lerp(c, d, fx), fy))
    }
}

// Shared by scalar and separable sampling. Keep both multiplications and the
// addition even when the endpoints match: replacing them changes rounding.
#[inline]
pub(crate) fn lerp(a: [f32; 4], b: [f32; 4], fraction: f32) -> [f32; 4] {
    std::array::from_fn(|i| a[i] * (1.0 - fraction) + b[i] * fraction)
}

/// Tile-scoped exact decode memoization. No decoded image survives the render
/// call, and the cache never borrows or clones an owning lease. Collisions only
/// repeat conversion; a matching full texel index is required for reuse.
pub(crate) struct ImageSampler<'image, 'scratch> {
    image: ImageView<'image>,
    cache: &'scratch mut [Decoded; 256],
}
#[derive(Clone, Copy)]
struct Decoded {
    index: usize,
    color: [f32; 4],
}
pub(crate) fn with_decode_memo<R>(
    image: ImageView<'_>,
    render: impl FnOnce(&mut ImageSampler<'_, '_>) -> R,
) -> R {
    let mut cache = [Decoded {
        index: usize::MAX,
        color: [0.; 4],
    }; 256];
    render(&mut ImageSampler {
        image,
        cache: &mut cache,
    })
}
impl ImageSampler<'_, '_> {
    pub(crate) fn sample(
        &mut self,
        x: f64,
        y: f64,
        width: f64,
        height: f64,
        sampling: ImageSampling,
    ) -> Option<[f32; 4]> {
        let image = self.image;
        image.sample_with(x, y, width, height, sampling, |x, y| self.texel(x, y))
    }
    pub(crate) fn texel(&mut self, x: usize, y: usize) -> [f32; 4] {
        let image = self.image;
        let index = y * image.width as usize + x;
        // Full indices prove hits; collisions only repeat conversion.
        let slot = (x & 15) | ((y & 15) << 4);
        let cached = &mut self.cache[slot];
        if cached.index != index {
            *cached = Decoded {
                index,
                color: image.texel(x, y),
            };
        }
        cached.color
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn byte_table_preserves_existing_color_bits_for_every_channel_and_alpha() {
        for channel in 0..=255u8 {
            for alpha in 0..=255u8 {
                let bytes = [channel, 255 - channel, channel ^ 85, alpha];
                let image = ImageView {
                    key: ImageKey(1),
                    width: 1,
                    height: 1,
                    pixels: ImagePixels::Rgba8 {
                        bytes: &bytes,
                        profile: ImageProfile::Srgb,
                        alpha: AlphaMode::Straight,
                    },
                };
                let expected = if alpha == 0 {
                    [0.; 4]
                } else {
                    Color::rgba(bytes[0], bytes[1], bytes[2], alpha).premultiplied()
                };
                assert_eq!(
                    image.texel(0, 0).map(f32::to_bits),
                    expected.map(f32::to_bits)
                );
            }
        }
    }
    #[test]
    fn tile_decode_cache_is_exact_under_collisions_profiles_alpha_and_filters() {
        for profile in [ImageProfile::Srgb, ImageProfile::DisplayP3] {
            for alpha in [AlphaMode::Straight, AlphaMode::Premultiplied] {
                let bytes = (0..33 * 17)
                    .flat_map(|i| {
                        let a = [0, 17, 127, 255][i % 4];
                        let c = [(i * 29) as u8, (i * 57) as u8, (i * 13) as u8].map(|c| {
                            if alpha == AlphaMode::Premultiplied {
                                c.min(a)
                            } else {
                                c
                            }
                        });
                        [c[0], c[1], c[2], a]
                    })
                    .collect::<Vec<_>>()
                    .into_boxed_slice();
                let image = Image::rgba8(33, 17, profile, alpha, bytes).unwrap();
                let view = image.view();
                with_decode_memo(view, |cached| {
                    for sampling in [ImageSampling::Nearest, ImageSampling::Linear] {
                        for i in 0..4000 {
                            let x = (i * 37 % 1024) as f64 / 31.;
                            let y = (i * 67 % 1024) as f64 / 59.;
                            assert_eq!(
                                cached
                                    .sample(x, y, 33., 17., sampling)
                                    .map(|v| v.map(f32::to_bits)),
                                view.sample(x, y, 33., 17., sampling)
                                    .map(|v| v.map(f32::to_bits))
                            );
                        }
                    }
                });
            }
        }
    }
    #[test]
    fn rejects_bad_lengths_alpha_and_nonfinite_hdr_before_publication() {
        assert_eq!(count(0, 1), Err(Error::InvalidDimensions));
        assert_eq!(count(4096, 4096), Err(Error::ResourceLimit));
        assert!(matches!(
            Image::rgba8(
                1,
                1,
                ImageProfile::Srgb,
                AlphaMode::Straight,
                vec![0; 3].into_boxed_slice()
            ),
            Err(Error::InvalidImageLength)
        ));
        assert!(matches!(
            Image::rgba8(
                1,
                1,
                ImageProfile::Srgb,
                AlphaMode::Premultiplied,
                vec![128, 0, 0, 127].into_boxed_slice()
            ),
            Err(Error::InvalidImageAlpha)
        ));
        assert!(matches!(
            Image::linear_srgb(
                1,
                1,
                AlphaMode::Straight,
                vec![[f32::NAN, 0., 0., 1.]].into_boxed_slice()
            ),
            Err(Error::InvalidColor)
        ));
        assert!(matches!(
            Image::linear_srgb(
                1,
                1,
                AlphaMode::Premultiplied,
                vec![[1., 0., 0., 0.]].into_boxed_slice()
            ),
            Err(Error::InvalidImageAlpha)
        ));
    }
    #[test]
    fn encoded_premultiplication_is_undone_before_linear_conversion() {
        for profile in [ImageProfile::Srgb, ImageProfile::DisplayP3] {
            let image = Image::rgba8(
                1,
                1,
                profile,
                AlphaMode::Premultiplied,
                vec![64, 32, 16, 128].into_boxed_slice(),
            )
            .unwrap();
            let a = 128. / 255.;
            let c = [64. / 255. / a, 32. / 255. / a, 16. / 255. / a];
            let reference = match profile {
                ImageProfile::Srgb => Color::srgb(c[0], c[1], c[2], a),
                ImageProfile::DisplayP3 => Color::display_p3(c[0], c[1], c[2], a),
            }
            .unwrap()
            .premultiplied();
            assert_eq!(
                image.view().texel(0, 0).map(f32::to_bits),
                reference.map(f32::to_bits)
            );
            assert_eq!(image.pixel_bytes(), 4);
        }
    }
    #[test]
    fn immutable_ids_and_hdr_working_pixels_keep_their_leases() {
        assert_eq!(size_of::<Image>(), size_of::<usize>());
        eprintln!(
            "Image={} ImageData={} ImageView={} PreparedSource={} PreparedDraw={} PreparedPlacement={} Canvas={}",
            size_of::<Image>(),
            size_of::<ImageData>(),
            size_of::<ImageView<'_>>(),
            size_of::<crate::PreparedSource<'_>>(),
            size_of::<crate::PreparedDraw<'_>>(),
            size_of::<crate::PreparedPlacement<'_>>(),
            size_of::<crate::Canvas>()
        );
        let image = Image::linear_srgb(
            1,
            1,
            AlphaMode::Straight,
            vec![[4., -0.5, 2., 0.25]].into_boxed_slice(),
        )
        .unwrap();
        let lease = image.clone();
        assert_eq!(image, lease);
        assert_eq!(image.view().texel(0, 0), [1., -0.125, 0.5, 0.25]);
        assert_eq!(image.pixel_bytes(), 16);
        drop(image);
        assert_eq!(lease.view().texel(0, 0), [1., -0.125, 0.5, 0.25]);
        let other = Image::linear_srgb(
            1,
            1,
            AlphaMode::Premultiplied,
            vec![[1., -0.125, 0.5, 0.25]].into_boxed_slice(),
        )
        .unwrap();
        assert_ne!(lease, other);
    }
    #[test]
    fn bilinear_reconstruction_is_linear_premultiplied_and_clamps_texel_edges() {
        let image = Image::rgba8(
            2,
            1,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            vec![255, 0, 0, 255, 0, 0, 255, 0].into_boxed_slice(),
        )
        .unwrap();
        let view = image.view();
        assert_eq!(
            view.sample(1., 0.5, 2., 1., ImageSampling::Linear),
            Some([0.5, 0., 0., 0.5])
        );
        assert_eq!(
            view.sample(0., 0., 2., 1., ImageSampling::Linear),
            Some([1., 0., 0., 1.])
        );
        assert_eq!(view.sample(2., 0., 2., 1., ImageSampling::Linear), None);
        let gray = Image::rgba8(
            2,
            1,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            vec![0, 0, 0, 255, 255, 255, 255, 255].into_boxed_slice(),
        )
        .unwrap();
        assert_eq!(
            gray.view().sample(1., 0.5, 2., 1., ImageSampling::Linear),
            Some([0.5, 0.5, 0.5, 1.])
        );
    }
    #[test]
    fn scenes_lease_each_distinct_image_once_and_failed_candidates_keep_old_leases() {
        use crate::{Affine, Canvas, Color, Rect};
        let mut canvas = Canvas::new(4, 4).unwrap();
        let image = Image::rgba8(
            1,
            1,
            ImageProfile::Srgb,
            AlphaMode::Straight,
            vec![255, 0, 0, 255].into_boxed_slice(),
        )
        .unwrap();
        let weak = Arc::downgrade(&image.0);
        for sampling in [ImageSampling::Nearest, ImageSampling::Linear] {
            canvas
                .draw_image(
                    &image,
                    Rect::new(0., 0., 4., 4.),
                    Affine::IDENTITY,
                    Rect::new(0., 0., 4., 4.),
                    sampling,
                )
                .unwrap();
        }
        assert_eq!(canvas.prepared_scene().images().count(), 1);
        drop(image);
        assert_eq!(weak.strong_count(), 1);
        let before = canvas.pixels().to_vec();
        {
            let mut candidate = canvas.stage();
            candidate.clear(Color::WHITE);
            assert!(
                candidate
                    .fill_rect(
                        Rect::new(0., 0., f32::NAN, 1.),
                        Affine::IDENTITY,
                        Rect::new(0., 0., 4., 4.),
                        Color::BLACK
                    )
                    .is_err()
            );
        }
        assert_eq!(weak.strong_count(), 1);
        assert_eq!(canvas.pixels(), before);
        canvas.clear(Color::WHITE);
        assert_eq!(weak.strong_count(), 0);
    }
}
