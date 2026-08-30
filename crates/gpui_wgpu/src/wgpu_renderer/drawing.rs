use gpui::{
    AtlasTextureId, MonochromeSprite, Path, PolychromeSprite, Quad, ScaledPixels, Shadow,
    SubpixelSprite, Underline,
};

use crate::shaders::interface as shader_interface;

use super::{WgpuRenderer, buffers::InstanceUpload, frame, path_types, pipelines};

impl WgpuRenderer {
    pub(super) fn draw_quads(
        &self,
        quads: &[Quad],
        instances: &mut InstanceUpload,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        self.draw_instances(
            shader_interface::slice_as_bytes(quads),
            quads.len() as u32,
            &self.resources().pipelines.quads,
            instances,
            pass,
        )
    }

    pub(super) fn draw_shadows(
        &self,
        shadows: &[Shadow],
        instances: &mut InstanceUpload,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        self.draw_instances(
            shader_interface::slice_as_bytes(shadows),
            shadows.len() as u32,
            &self.resources().pipelines.shadows,
            instances,
            pass,
        )
    }

    pub(super) fn draw_underlines(
        &self,
        underlines: &[Underline],
        instances: &mut InstanceUpload,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        self.draw_instances(
            shader_interface::slice_as_bytes(underlines),
            underlines.len() as u32,
            &self.resources().pipelines.underlines,
            instances,
            pass,
        )
    }

    pub(super) fn draw_monochrome_sprites(
        &self,
        sprites: &[MonochromeSprite],
        texture_id: AtlasTextureId,
        instances: &mut InstanceUpload,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let texture = self.atlas.get_texture_info(texture_id);
        self.draw_instances_with_texture(
            shader_interface::slice_as_bytes(sprites),
            sprites.len() as u32,
            &texture.view,
            &self.resources().pipelines.monochrome_sprites,
            instances,
            pass,
        )
    }

    pub(super) fn draw_subpixel_sprites(
        &self,
        sprites: &[SubpixelSprite],
        texture_id: AtlasTextureId,
        instances: &mut InstanceUpload,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let texture = self.atlas.get_texture_info(texture_id);
        let resources = self.resources();
        let pipeline = resources
            .pipelines
            .subpixel_sprites
            .as_ref()
            .unwrap_or(&resources.pipelines.monochrome_sprites);
        self.draw_instances_with_texture(
            shader_interface::slice_as_bytes(sprites),
            sprites.len() as u32,
            &texture.view,
            pipeline,
            instances,
            pass,
        )
    }

    pub(super) fn draw_polychrome_sprites(
        &self,
        sprites: &[PolychromeSprite],
        texture_id: AtlasTextureId,
        instances: &mut InstanceUpload,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let texture = self.atlas.get_texture_info(texture_id);
        self.draw_instances_with_texture(
            shader_interface::slice_as_bytes(sprites),
            sprites.len() as u32,
            &texture.view,
            &self.resources().pipelines.polychrome_sprites,
            instances,
            pass,
        )
    }

    fn draw_instances(
        &self,
        data: &[u8],
        instance_count: u32,
        pipeline: &pipelines::WgpuRenderPipeline,
        instances: &mut InstanceUpload,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        if instance_count == 0 {
            return Ok(());
        }
        let Some(slice) = instances.write(data) else {
            return Err(frame::DrawError::CapacityPlanningInvariant);
        };
        let resources = self.resources();
        let bind_group = resources
            .bind_group_layouts
            .create_instances(&resources.device, resources.instances.binding(slice));
        pass.set_pipeline(pipeline);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.globals_bind_group,
            &[],
        );
        pass.set_bind_group(shader_interface::DATA_BIND_GROUP, &bind_group, &[]);
        pass.draw(0..pipeline.fixed_vertex_count(), 0..instance_count);
        Ok(())
    }

    fn draw_instances_with_texture(
        &self,
        data: &[u8],
        instance_count: u32,
        texture_view: &wgpu::TextureView,
        pipeline: &pipelines::WgpuRenderPipeline,
        instances: &mut InstanceUpload,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        if instance_count == 0 {
            return Ok(());
        }
        let Some(slice) = instances.write(data) else {
            return Err(frame::DrawError::CapacityPlanningInvariant);
        };
        let resources = self.resources();
        let bind_group = resources.bind_group_layouts.create_textured_instances(
            &resources.device,
            resources.instances.binding(slice),
            texture_view,
            &resources.atlas_sampler,
        );
        pass.set_pipeline(pipeline);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.globals_bind_group,
            &[],
        );
        pass.set_bind_group(shader_interface::DATA_BIND_GROUP, &bind_group, &[]);
        pass.draw(0..pipeline.fixed_vertex_count(), 0..instance_count);
        Ok(())
    }

    pub(super) fn draw_paths_from_intermediate(
        &self,
        paths: &[Path<ScaledPixels>],
        instances: &mut InstanceUpload,
        pass: &mut wgpu::RenderPass<'_>,
    ) -> frame::DrawResult {
        let sprites = path_types::sprites(paths);
        let resources = self.resources();
        let Some(path_intermediate_view) = resources.path_intermediate_view.as_ref() else {
            return Err(frame::DrawError::MissingIntermediateTarget);
        };
        self.draw_instances_with_texture(
            shader_interface::slice_as_bytes(&sprites),
            sprites.len() as u32,
            path_intermediate_view,
            &resources.pipelines.paths,
            instances,
            pass,
        )
    }

    pub(super) fn draw_paths_to_intermediate(
        &self,
        encoder: &mut wgpu::CommandEncoder,
        paths: &[Path<ScaledPixels>],
        instances: &mut InstanceUpload,
    ) -> frame::DrawResult {
        let vertices = path_types::rasterization_vertices(paths);
        if vertices.is_empty() {
            return Ok(());
        }

        let Some(vertex_slice) = instances.write(shader_interface::slice_as_bytes(&vertices))
        else {
            return Err(frame::DrawError::CapacityPlanningInvariant);
        };
        let resources = self.resources();
        let data_bind_group = resources
            .bind_group_layouts
            .create_instances(&resources.device, resources.instances.binding(vertex_slice));
        let Some(path_intermediate_view) = resources.path_intermediate_view.as_ref() else {
            return Err(frame::DrawError::MissingIntermediateTarget);
        };
        let (target_view, resolve_target) = if let Some(msaa_view) = &resources.path_msaa_view {
            (msaa_view, Some(path_intermediate_view))
        } else {
            (path_intermediate_view, None)
        };

        let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
            label: Some("path_rasterization_pass"),
            color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                view: target_view,
                resolve_target,
                ops: wgpu::Operations {
                    load: wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
                    store: wgpu::StoreOp::Store,
                },
                depth_slice: None,
            })],
            depth_stencil_attachment: None,
            ..Default::default()
        });
        pass.set_pipeline(&resources.pipelines.path_rasterization);
        pass.set_bind_group(
            shader_interface::GLOBAL_BIND_GROUP,
            &resources.path_globals_bind_group,
            &[],
        );
        pass.set_bind_group(shader_interface::DATA_BIND_GROUP, &data_bind_group, &[]);
        pass.draw(0..vertices.len() as u32, 0..1);
        Ok(())
    }
}
