mod encoder {
    use alloc::{boxed::Box, vec::Vec};
    use core::ops::Range;

    use hal::{
        AccelerationStructureBarrier, Attachment, BufferBarrier, BufferBinding, BufferCopy,
        BufferTextureCopy, BuildAccelerationStructureDescriptor, ColorAttachment, CommandEncoder,
        ComputePassDescriptor, DepthStencilAttachment, DeviceError, DynRayTracingPipeline, Label,
        MemoryRange, PassTimestampWrites, RayTracingPassDescriptor, Rect, RenderPassDescriptor,
        TextureBarrier, TextureCopy,
    };

    use hal::{
        DynAccelerationStructure, DynBindGroup, DynBuffer, DynCommandBuffer, DynComputePipeline,
        DynPipelineLayout, DynQuerySet, DynRenderPipeline, DynTexture, DynTextureView,
    };

    pub(super) struct EncoderProbe {
        pub(super) inner: Box<dyn hal::DynCommandEncoder>,
        pub(super) events: std::sync::Arc<super::Events>,
    }
    impl core::fmt::Debug for EncoderProbe {
        fn fmt(&self, f: &mut core::fmt::Formatter) -> core::fmt::Result {
            self.inner.fmt(f)
        }
    }
    impl hal::DynResource for EncoderProbe {
        fn as_any(&self) -> &dyn core::any::Any {
            self.inner.as_any()
        }
        fn as_any_mut(&mut self) -> &mut dyn core::any::Any {
            self.inner.as_any_mut()
        }
    }
    impl hal::DynCommandEncoder for EncoderProbe {
        unsafe fn set_index_buffer<'a>(
            &mut self,
            binding: BufferBinding<'a, dyn DynBuffer>,
            format: wgt::IndexFormat,
        ) {
            unsafe { self.inner.set_index_buffer(binding, format) }
        }
        unsafe fn set_vertex_buffer<'a>(
            &mut self,
            index: u32,
            binding: BufferBinding<'a, dyn DynBuffer>,
        ) {
            unsafe { self.inner.set_vertex_buffer(index, binding) }
        }
        unsafe fn build_acceleration_structures<'a>(
            &mut self,
            descriptors: &'a [BuildAccelerationStructureDescriptor<
                'a,
                dyn DynBuffer,
                dyn DynAccelerationStructure,
            >],
        ) {
            unsafe { self.inner.build_acceleration_structures(descriptors) }
        }

        unsafe fn begin_encoding(&mut self, label: Label) -> Result<(), DeviceError> {
            unsafe { self.inner.begin_encoding(label) }
        }
        unsafe fn discard_encoding(&mut self) {
            unsafe { self.inner.discard_encoding() }
        }
        unsafe fn end_encoding(&mut self) -> Result<Box<dyn DynCommandBuffer>, DeviceError> {
            unsafe { self.inner.end_encoding() }
        }
        unsafe fn reset_all(&mut self, command_buffers: Vec<Box<dyn DynCommandBuffer>>) {
            unsafe { self.inner.reset_all(command_buffers) }
        }
        unsafe fn transition_buffers(&mut self, barriers: &[BufferBarrier<'_, dyn DynBuffer>]) {
            unsafe { self.inner.transition_buffers(barriers) }
        }
        unsafe fn transition_textures(&mut self, barriers: &[TextureBarrier<'_, dyn DynTexture>]) {
            unsafe { self.inner.transition_textures(barriers) }
        }
        unsafe fn clear_buffer(&mut self, buffer: &dyn DynBuffer, range: MemoryRange) {
            unsafe { self.inner.clear_buffer(buffer, range) }
        }
        unsafe fn copy_buffer_to_buffer(
            &mut self,
            src: &dyn DynBuffer,
            dst: &dyn DynBuffer,
            regions: &[BufferCopy],
        ) {
            for region in regions {
                self.events.copies.lock().unwrap().push((
                    super::handle(src),
                    super::handle(dst),
                    region.size.get(),
                ));
            }
            unsafe { self.inner.copy_buffer_to_buffer(src, dst, regions) }
        }
        unsafe fn copy_texture_to_texture(
            &mut self,
            src: &dyn DynTexture,
            src_usage: wgt::TextureUses,
            dst: &dyn DynTexture,
            regions: &[TextureCopy],
        ) {
            unsafe {
                self.inner
                    .copy_texture_to_texture(src, src_usage, dst, regions)
            }
        }
        unsafe fn copy_buffer_to_texture(
            &mut self,
            src: &dyn DynBuffer,
            dst: &dyn DynTexture,
            regions: &[BufferTextureCopy],
        ) {
            unsafe { self.inner.copy_buffer_to_texture(src, dst, regions) }
        }
        unsafe fn copy_texture_to_buffer(
            &mut self,
            src: &dyn DynTexture,
            src_usage: wgt::TextureUses,
            dst: &dyn DynBuffer,
            regions: &[BufferTextureCopy],
        ) {
            unsafe {
                self.inner
                    .copy_texture_to_buffer(src, src_usage, dst, regions)
            }
        }
        unsafe fn set_bind_group(
            &mut self,
            layout: &dyn DynPipelineLayout,
            index: u32,
            group: &dyn DynBindGroup,
            dynamic_offsets: &[wgt::DynamicOffset],
        ) {
            unsafe {
                self.inner
                    .set_bind_group(layout, index, group, dynamic_offsets)
            }
        }
        unsafe fn set_immediates(
            &mut self,
            layout: &dyn DynPipelineLayout,
            offset_bytes: u32,
            data: &[u32],
        ) {
            unsafe { self.inner.set_immediates(layout, offset_bytes, data) }
        }
        unsafe fn insert_debug_marker(&mut self, label: &str) {
            unsafe { self.inner.insert_debug_marker(label) }
        }
        unsafe fn begin_debug_marker(&mut self, group_label: &str) {
            unsafe { self.inner.begin_debug_marker(group_label) }
        }
        unsafe fn end_debug_marker(&mut self) {
            unsafe { self.inner.end_debug_marker() }
        }
        unsafe fn begin_query(&mut self, set: &dyn DynQuerySet, index: u32) {
            unsafe { self.inner.begin_query(set, index) }
        }
        unsafe fn end_query(&mut self, set: &dyn DynQuerySet, index: u32) {
            unsafe { self.inner.end_query(set, index) }
        }
        unsafe fn write_timestamp(&mut self, set: &dyn DynQuerySet, index: u32) {
            unsafe { self.inner.write_timestamp(set, index) }
        }
        unsafe fn reset_queries(&mut self, set: &dyn DynQuerySet, range: Range<u32>) {
            unsafe { self.inner.reset_queries(set, range) }
        }
        unsafe fn copy_query_results(
            &mut self,
            set: &dyn DynQuerySet,
            range: Range<u32>,
            buffer: &dyn DynBuffer,
            offset: wgt::BufferAddress,
            stride: wgt::BufferSize,
        ) {
            unsafe {
                self.inner
                    .copy_query_results(set, range, buffer, offset, stride)
            }
        }
        unsafe fn begin_render_pass(
            &mut self,
            desc: &RenderPassDescriptor<dyn DynQuerySet, dyn DynTextureView>,
        ) -> Result<(), DeviceError> {
            unsafe { self.inner.begin_render_pass(desc) }
        }
        unsafe fn end_render_pass(&mut self) {
            unsafe { self.inner.end_render_pass() }
        }
        unsafe fn set_render_pipeline(&mut self, pipeline: &dyn DynRenderPipeline) {
            unsafe { self.inner.set_render_pipeline(pipeline) }
        }
        unsafe fn set_viewport(&mut self, rect: &Rect<f32>, depth_range: Range<f32>) {
            unsafe { self.inner.set_viewport(rect, depth_range) }
        }
        unsafe fn set_scissor_rect(&mut self, rect: &Rect<u32>) {
            unsafe { self.inner.set_scissor_rect(rect) }
        }
        unsafe fn set_stencil_reference(&mut self, value: u32) {
            unsafe { self.inner.set_stencil_reference(value) }
        }
        unsafe fn set_blend_constants(&mut self, color: &[f32; 4]) {
            unsafe { self.inner.set_blend_constants(color) }
        }
        unsafe fn draw(
            &mut self,
            first_vertex: u32,
            vertex_count: u32,
            first_instance: u32,
            instance_count: u32,
        ) {
            unsafe {
                self.inner
                    .draw(first_vertex, vertex_count, first_instance, instance_count)
            }
        }
        unsafe fn draw_indexed(
            &mut self,
            first_index: u32,
            index_count: u32,
            base_vertex: i32,
            first_instance: u32,
            instance_count: u32,
        ) {
            unsafe {
                self.inner.draw_indexed(
                    first_index,
                    index_count,
                    base_vertex,
                    first_instance,
                    instance_count,
                )
            }
        }
        unsafe fn draw_mesh_tasks(
            &mut self,
            group_count_x: u32,
            group_count_y: u32,
            group_count_z: u32,
        ) {
            unsafe {
                self.inner
                    .draw_mesh_tasks(group_count_x, group_count_y, group_count_z)
            }
        }
        unsafe fn draw_indirect(
            &mut self,
            buffer: &dyn DynBuffer,
            offset: wgt::BufferAddress,
            draw_count: u32,
        ) {
            unsafe { self.inner.draw_indirect(buffer, offset, draw_count) }
        }
        unsafe fn draw_indexed_indirect(
            &mut self,
            buffer: &dyn DynBuffer,
            offset: wgt::BufferAddress,
            draw_count: u32,
        ) {
            unsafe { self.inner.draw_indexed_indirect(buffer, offset, draw_count) }
        }
        unsafe fn draw_mesh_tasks_indirect(
            &mut self,
            buffer: &dyn DynBuffer,
            offset: wgt::BufferAddress,
            draw_count: u32,
        ) {
            unsafe {
                self.inner
                    .draw_mesh_tasks_indirect(buffer, offset, draw_count)
            }
        }
        unsafe fn draw_indirect_count(
            &mut self,
            buffer: &dyn DynBuffer,
            offset: wgt::BufferAddress,
            count_buffer: &dyn DynBuffer,
            count_offset: wgt::BufferAddress,
            max_count: u32,
        ) {
            unsafe {
                self.inner.draw_indirect_count(
                    buffer,
                    offset,
                    count_buffer,
                    count_offset,
                    max_count,
                )
            }
        }
        unsafe fn draw_indexed_indirect_count(
            &mut self,
            buffer: &dyn DynBuffer,
            offset: wgt::BufferAddress,
            count_buffer: &dyn DynBuffer,
            count_offset: wgt::BufferAddress,
            max_count: u32,
        ) {
            unsafe {
                self.inner.draw_indexed_indirect_count(
                    buffer,
                    offset,
                    count_buffer,
                    count_offset,
                    max_count,
                )
            }
        }
        unsafe fn draw_mesh_tasks_indirect_count(
            &mut self,
            buffer: &dyn DynBuffer,
            offset: wgt::BufferAddress,
            count_buffer: &dyn DynBuffer,
            count_offset: wgt::BufferAddress,
            max_count: u32,
        ) {
            unsafe {
                self.inner.draw_mesh_tasks_indirect_count(
                    buffer,
                    offset,
                    count_buffer,
                    count_offset,
                    max_count,
                )
            }
        }
        unsafe fn begin_compute_pass(&mut self, desc: &ComputePassDescriptor<dyn DynQuerySet>) {
            unsafe { self.inner.begin_compute_pass(desc) }
        }
        unsafe fn end_compute_pass(&mut self) {
            unsafe { self.inner.end_compute_pass() }
        }
        unsafe fn set_compute_pipeline(&mut self, pipeline: &dyn DynComputePipeline) {
            unsafe { self.inner.set_compute_pipeline(pipeline) }
        }
        unsafe fn dispatch_workgroups(&mut self, count: [u32; 3]) {
            unsafe { self.inner.dispatch_workgroups(count) }
        }
        unsafe fn dispatch_workgroups_indirect(
            &mut self,
            buffer: &dyn DynBuffer,
            offset: wgt::BufferAddress,
        ) {
            unsafe { self.inner.dispatch_workgroups_indirect(buffer, offset) }
        }
        unsafe fn begin_ray_tracing_pass(&mut self, desc: &RayTracingPassDescriptor) {
            unsafe { self.inner.begin_ray_tracing_pass(desc) }
        }
        unsafe fn end_ray_tracing_pass(&mut self) {
            unsafe { self.inner.end_ray_tracing_pass() }
        }
        unsafe fn trace_rays(
            &mut self,
            count: [u32; 3],
            ray_generation_group_data: hal::PipelineGroupData<dyn DynBuffer>,
            miss_group_data: hal::PipelineGroupData<dyn DynBuffer>,
            intersection_group_data: hal::PipelineGroupData<dyn DynBuffer>,
        ) {
            unsafe {
                self.inner.trace_rays(
                    count,
                    ray_generation_group_data,
                    miss_group_data,
                    intersection_group_data,
                )
            }
        }
        unsafe fn set_ray_tracing_pipeline(&mut self, pipeline: &dyn DynRayTracingPipeline) {
            unsafe { self.inner.set_ray_tracing_pipeline(pipeline) }
        }
        unsafe fn place_acceleration_structure_barrier(
            &mut self,
            barrier: AccelerationStructureBarrier,
        ) {
            unsafe { self.inner.place_acceleration_structure_barrier(barrier) }
        }
        unsafe fn copy_acceleration_structure_to_acceleration_structure(
            &mut self,
            src: &dyn DynAccelerationStructure,
            dst: &dyn DynAccelerationStructure,
            copy: wgt::AccelerationStructureCopy,
        ) {
            unsafe {
                self.inner
                    .copy_acceleration_structure_to_acceleration_structure(src, dst, copy)
            }
        }
        unsafe fn read_acceleration_structure_compact_size(
            &mut self,
            acceleration_structure: &dyn DynAccelerationStructure,
            buf: &dyn DynBuffer,
        ) {
            unsafe {
                self.inner
                    .read_acceleration_structure_compact_size(acceleration_structure, buf)
            }
        }
        unsafe fn set_acceleration_structure_dependencies(
            &self,
            command_buffers: &[Box<dyn DynCommandBuffer>],
            dependencies: &[&dyn DynAccelerationStructure],
        ) {
            unsafe {
                self.inner
                    .set_acceleration_structure_dependencies(command_buffers, dependencies)
            }
        }
    }
}
use encoder::EncoderProbe;
