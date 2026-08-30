use crate::shaders::{
    common::SurfaceColorFormat, interface as shader_interface, surface::SurfaceUniforms,
};
use gpui::PaintSurface;

use super::{WgpuRenderer, frame};

impl WgpuRenderer {
    #[cfg(any(target_os = "macos", target_os = "linux", target_os = "freebsd"))]
    fn draw_surface_views(
        &self,
        surface: &PaintSurface,
        color_view: &wgpu::TextureView,
        chroma_view: &wgpu::TextureView,
        uses_yuv_color: bool,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let uniforms = SurfaceUniforms {
            bounds: surface.bounds.into(),
            content_mask: surface.content_mask.bounds.into(),
            color_format: if uses_yuv_color {
                SurfaceColorFormat::Yuv
            } else {
                SurfaceColorFormat::Rgba
            },
            padding0: 0,
            padding1: 0,
            padding2: 0,
        };
        let resources = self.resources();
        let uniform_offset = resources.surface_uniforms.write(&uniforms);
        let bind_group = resources.bind_group_layouts.create_surface(
            &resources.device,
            wgpu::BufferBinding {
                buffer: &resources.surface_uniforms.buffer,
                offset: 0,
                size: std::num::NonZeroU64::new(std::mem::size_of::<SurfaceUniforms>() as u64),
            },
            color_view,
            chroma_view,
            &resources.surface_sampler,
        );

        pass.set_pipeline(&resources.pipelines.surfaces);
        pass.set_bind_group(
            shader_interface::DATA_BIND_GROUP,
            &bind_group,
            &[uniform_offset],
        );
        pass.draw(0..resources.pipelines.surfaces.fixed_vertex_count(), 0..1);
        Ok(())
    }

    #[cfg(any(target_os = "linux", target_os = "freebsd"))]
    pub(super) fn draw_surfaces(
        &self,
        surfaces: &[PaintSurface],
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        for surface in surfaces {
            let Some(texture) = surface.texture.downcast_ref::<wgpu::Texture>() else {
                continue;
            };
            let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
            self.draw_surface_views(surface, &view, &view, false, pass)?;
        }
        Ok(())
    }

    #[cfg(target_os = "macos")]
    pub(super) fn draw_surfaces(
        &self,
        surfaces: &[PaintSurface],
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        use core_foundation::base::TCFType as _;
        use core_video::{
            metal_texture::CVMetalTextureGetTexture,
            pixel_buffer::kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
        };

        let resources = self.resources();
        for surface in surfaces {
            if surface.image_buffer.get_pixel_format()
                != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
            {
                log::error!("unsupported CoreVideo surface pixel format");
                return Err(frame::DrawError::ExternalSurface);
            }
            let luma = resources
                .core_video_texture_cache
                .create_texture_from_image(
                    surface.image_buffer.as_concrete_TypeRef(),
                    None,
                    metal::MTLPixelFormat::R8Unorm,
                    surface.image_buffer.get_width_of_plane(0),
                    surface.image_buffer.get_height_of_plane(0),
                    0,
                )
                .map_err(|error| {
                    log::error!("failed to create CoreVideo luma texture: {error}");
                    frame::DrawError::ExternalSurface
                })?;
            let chroma = resources
                .core_video_texture_cache
                .create_texture_from_image(
                    surface.image_buffer.as_concrete_TypeRef(),
                    None,
                    metal::MTLPixelFormat::RG8Unorm,
                    surface.image_buffer.get_width_of_plane(1),
                    surface.image_buffer.get_height_of_plane(1),
                    1,
                )
                .map_err(|error| {
                    log::error!("failed to create CoreVideo chroma texture: {error}");
                    frame::DrawError::ExternalSurface
                })?;

            let luma_size = plane_size(surface, 0);
            let chroma_size = plane_size(surface, 1);
            // SAFETY: CoreVideo created these planes from the Metal device exposed by this wgpu
            // device, and each descriptor exactly matches its plane.
            let Some(luma_texture) = (unsafe {
                import_core_video_texture(
                    &resources.device,
                    CVMetalTextureGetTexture(luma.as_concrete_TypeRef()).cast(),
                    wgpu::TextureFormat::R8Unorm,
                    luma_size,
                )
            }) else {
                return Err(frame::DrawError::ExternalSurface);
            };
            let Some(chroma_texture) = (unsafe {
                import_core_video_texture(
                    &resources.device,
                    CVMetalTextureGetTexture(chroma.as_concrete_TypeRef()).cast(),
                    wgpu::TextureFormat::Rg8Unorm,
                    chroma_size,
                )
            }) else {
                return Err(frame::DrawError::ExternalSurface);
            };
            let luma_view = luma_texture.create_view(&wgpu::TextureViewDescriptor::default());
            let chroma_view = chroma_texture.create_view(&wgpu::TextureViewDescriptor::default());
            self.draw_surface_views(surface, &luma_view, &chroma_view, true, pass)?;
        }
        Ok(())
    }

    #[cfg(not(any(target_os = "macos", target_os = "linux", target_os = "freebsd")))]
    pub(super) fn draw_surfaces(
        &self,
        _surfaces: &[PaintSurface],
        _pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        Ok(())
    }
}

#[cfg(target_os = "macos")]
fn plane_size(surface: &PaintSurface, plane: usize) -> wgpu::Extent3d {
    wgpu::Extent3d {
        width: surface.image_buffer.get_width_of_plane(plane) as u32,
        height: surface.image_buffer.get_height_of_plane(plane) as u32,
        depth_or_array_layers: 1,
    }
}

#[cfg(target_os = "macos")]
unsafe fn import_core_video_texture(
    device: &wgpu::Device,
    raw_texture: *mut objc2::runtime::AnyObject,
    format: wgpu::TextureFormat,
    size: wgpu::Extent3d,
) -> Option<wgpu::Texture> {
    use objc2::{rc::Retained, runtime::ProtocolObject};

    // SAFETY: CoreVideo returned a live MTLTexture. Its retain count is transferred into the HAL
    // texture so it outlives the CVMetalTexture wrapper.
    let object = unsafe { Retained::retain(raw_texture) }?;
    let raw =
        unsafe { Retained::cast_unchecked::<ProtocolObject<dyn objc2_metal::MTLTexture>>(object) };
    let hal_texture = unsafe {
        wgpu::hal::metal::Device::texture_from_raw(
            raw,
            format,
            objc2_metal::MTLTextureType::Type2D,
            1,
            1,
            size.into(),
        )
    };
    Some(unsafe {
        device.create_texture_from_hal::<wgpu::hal::api::Metal>(
            hal_texture,
            &wgpu::TextureDescriptor {
                label: Some("core_video_surface_plane"),
                size,
                mip_level_count: 1,
                sample_count: 1,
                dimension: wgpu::TextureDimension::D2,
                format,
                usage: wgpu::TextureUsages::TEXTURE_BINDING,
                view_formats: &[],
            },
        )
    })
}
