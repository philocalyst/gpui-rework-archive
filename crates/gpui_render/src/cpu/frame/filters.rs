//! Filters on the retained software frame.
use super::*;

impl Frame {
    pub(in crate::cpu) fn backdrop_filter(&mut self, filter: &gpui::BackdropFilter) {
        let mut filtered = self.clone();
        filtered.apply_filters(&filter.filters, filter.bounds);
        let shape = crate::shaders::host::RoundedRectShader::new(
            filter.bounds,
            filter.corner_radii,
            filter.corner_smoothing,
            filter.corner_smoothing > 0.,
        );
        let (x0, y0, x1, y1) = self.pixel_range(filter.bounds);
        for y in y0..y1 {
            for x in x0..x1 {
                let p = wgsl_rs::std::vec2f(x as f32 + 0.5, y as f32 + 0.5);
                if !contains_fragment(filter.bounds, p)
                    || crate::shaders::host::is_clipped(filter.content_mask, p)
                {
                    continue;
                }
                let mask = crate::shaders::host::content_alpha(filter.content_mask, p);
                let factor = shape.sample(p) * mask * filter.opacity;
                let index = y as usize * self.width as usize + x as usize;
                let blur = filtered.pixels[index];
                self.over_at(
                    x,
                    y,
                    [
                        blur[0] * factor,
                        blur[1] * factor,
                        blur[2] * factor,
                        blur[3] * factor,
                    ],
                );
            }
        }
    }
    pub(in crate::cpu) fn apply_filters(
        &mut self,
        filters: &[gpui::ScaledFilter],
        bounds: Bounds<ScaledPixels>,
    ) {
        // The production filter pass coalesces blur declarations into one maximum radius.
        let radius = filters
            .iter()
            .map(|filter| match filter {
                gpui::ScaledFilter::Blur(radius) => radius.0,
            })
            .fold(0.0, f32::max);
        self.gaussian_blur(radius, bounds);
    }
    pub(in crate::cpu) fn composite_filtered(
        &mut self,
        child: Frame,
        boundary: &gpui::FilterBoundary,
    ) {
        let dilation = gpui::ScaledPixels(
            boundary.max_blur_radius() * crate::blur::GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS,
        );
        let composite_bounds = boundary.bounds.dilate(dilation);
        let (x0, y0, x1, y1) = self.pixel_range(composite_bounds);
        for y in y0..y1 {
            for x in x0..x1 {
                let p = wgsl_rs::std::vec2f(x as f32 + 0.5, y as f32 + 0.5);
                if !contains_fragment(composite_bounds, p)
                    || crate::shaders::host::is_clipped(boundary.content_mask, p)
                {
                    continue;
                }
                let mask = crate::shaders::host::content_alpha(boundary.content_mask, p);
                let factor = mask * boundary.opacity;
                let index = y as usize * self.width as usize + x as usize;
                let src = child.pixels[index];
                self.over_at(
                    x,
                    y,
                    [
                        src[0] * factor,
                        src[1] * factor,
                        src[2] * factor,
                        src[3] * factor,
                    ],
                );
            }
        }
    }
    fn gaussian_blur(&mut self, sigma: f32, bounds: Bounds<ScaledPixels>) {
        if self.width == 0 || self.height == 0 {
            return;
        }
        let Some(kernel) = crate::blur::BlurKernel::for_radius(sigma) else {
            return;
        };
        let width = crate::blur::downsampled_dimension(self.width);
        let height = crate::blur::downsampled_dimension(self.height);
        let dilation = gpui::ScaledPixels(crate::blur::GAUSSIAN_CUTOFF_STANDARD_DEVIATIONS * sigma);
        let scissor = crate::blur::ScissorRectangle::for_blurred_bounds(
            bounds,
            dilation.0,
            self.width,
            self.height,
        );
        if scissor.is_empty() {
            return;
        }
        let mut downsampled = Frame::new(width, height);
        for y in scissor.y..(scissor.y + scissor.height).min(height) {
            for x in scissor.x..(scissor.x + scissor.width).min(width) {
                let u = ((x as f32 + 0.5) / width as f32)
                    .min((self.width as f32 - 0.5) / self.width as f32);
                let v = ((y as f32 + 0.5) / height as f32)
                    .min((self.height as f32 - 0.5) / self.height as f32);
                downsampled.pixels[y as usize * width as usize + x as usize] =
                    sample_frame_linear(self, u, v);
            }
        }
        let horizontal = blur_pass(&downsampled, kernel, true, scissor);
        let vertical = blur_pass(&horizontal, kernel, false, scissor);
        let composite_bounds = bounds.dilate(dilation);
        let (x0, y0, x1, y1) = self.pixel_range(composite_bounds);
        let mut output = Frame::new(self.width, self.height);
        for y in y0..y1 {
            for x in x0..x1 {
                output.pixels[y as usize * self.width as usize + x as usize] = sample_frame_linear(
                    &vertical,
                    (x as f32 + 0.5) / self.width as f32,
                    (y as f32 + 0.5) / self.height as f32,
                );
            }
        }
        self.pixels = output.pixels;
    }
}
