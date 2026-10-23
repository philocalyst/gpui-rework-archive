use alloc::{boxed::Box, vec::Vec};

use hal::{
    AccelerationStructureBuildSizes, AccelerationStructureDescriptor, BindGroupDescriptor,
    BindGroupLayoutDescriptor, BufferDescriptor, BufferMapping, CommandEncoderDescriptor,
    ComputePipelineDescriptor, DeviceError, FenceValue,
    GetAccelerationStructureBuildSizesDescriptor, Label, MemoryRange, PipelineCacheDescriptor,
    PipelineCacheError, PipelineError, PipelineLayoutDescriptor, RayTracingPipelineDescriptor,
    RenderPipelineDescriptor, SamplerDescriptor, ShaderError, ShaderInput, ShaderModuleDescriptor,
    TextureDescriptor, TextureViewDescriptor, TlasInstance,
};

use hal::{
    DynAccelerationStructure, DynBindGroup, DynBindGroupLayout, DynBuffer, DynCommandEncoder,
    DynComputePipeline, DynFence, DynPipelineCache, DynPipelineLayout, DynQuerySet, DynQueue,
    DynRayTracingPipeline, DynRenderPipeline, DynSampler, DynShaderModule, DynTexture,
    DynTextureView,
};

impl hal::DynDevice for Probe {
    unsafe fn create_buffer(
        &self,
        desc: &BufferDescriptor,
    ) -> Result<Box<dyn DynBuffer>, DeviceError> {
        self.before("create_buffer", || self.error())?;
        let value = unsafe { self.inner.create_buffer(desc) }?;
        self.record_handle("create_buffer", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_buffer(&self, buffer: Box<dyn DynBuffer>) {
        self.record_handle("destroy_buffer", handle(buffer.as_ref()));
        unsafe { self.inner.destroy_buffer(buffer) }
    }
    unsafe fn add_raw_buffer(&self, buffer: &dyn DynBuffer) {
        self.record_handle("create_buffer", handle(buffer));
        unsafe { self.inner.add_raw_buffer(buffer) }
    }
    unsafe fn map_buffer(
        &self,
        buffer: &dyn DynBuffer,
        range: MemoryRange,
    ) -> Result<BufferMapping, DeviceError> {
        unsafe { self.inner.map_buffer(buffer, range) }
    }
    unsafe fn unmap_buffer(&self, buffer: &dyn DynBuffer) {
        unsafe { self.inner.unmap_buffer(buffer) }
    }
    unsafe fn flush_mapped_ranges(&self, buffer: &dyn DynBuffer, ranges: &[MemoryRange]) {
        unsafe { self.inner.flush_mapped_ranges(buffer, ranges) }
    }
    unsafe fn invalidate_mapped_ranges(&self, buffer: &dyn DynBuffer, ranges: &[MemoryRange]) {
        unsafe { self.inner.invalidate_mapped_ranges(buffer, ranges) }
    }
    unsafe fn create_texture(
        &self,
        desc: &TextureDescriptor,
    ) -> Result<Box<dyn DynTexture>, DeviceError> {
        self.before("create_texture", || self.error())?;
        let value = unsafe { self.inner.create_texture(desc) }?;
        self.record_handle("create_texture", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_texture(&self, texture: Box<dyn DynTexture>) {
        self.record_handle("destroy_texture", handle(texture.as_ref()));
        unsafe { self.inner.destroy_texture(texture) }
    }
    unsafe fn add_raw_texture(&self, texture: &dyn DynTexture) {
        unsafe { self.inner.add_raw_texture(texture) }
    }
    unsafe fn create_texture_view(
        &self,
        texture: &dyn DynTexture,
        desc: &TextureViewDescriptor,
    ) -> Result<Box<dyn DynTextureView>, DeviceError> {
        self.before("create_texture_view", || self.error())?;
        let value = unsafe { self.inner.create_texture_view(texture, desc) }?;
        self.record_handle("create_texture_view", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_texture_view(&self, view: Box<dyn DynTextureView>) {
        self.record_handle("destroy_texture_view", handle(view.as_ref()));
        unsafe { self.inner.destroy_texture_view(view) }
    }
    unsafe fn create_sampler(
        &self,
        desc: &SamplerDescriptor,
    ) -> Result<Box<dyn DynSampler>, DeviceError> {
        self.before("create_sampler", || self.error())?;
        let value = unsafe { self.inner.create_sampler(desc) }?;
        self.record_handle("create_sampler", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_sampler(&self, sampler: Box<dyn DynSampler>) {
        self.record_handle("destroy_sampler", handle(sampler.as_ref()));
        unsafe { self.inner.destroy_sampler(sampler) }
    }
    unsafe fn create_command_encoder(
        &self,
        desc: &CommandEncoderDescriptor<dyn DynQueue>,
    ) -> Result<Box<dyn DynCommandEncoder>, DeviceError> {
        self.before("create_command_encoder", || self.error())?;
        let value = unsafe { self.inner.create_command_encoder(desc) }?;
        self.record_handle("create_command_encoder", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn create_bind_group_layout(
        &self,
        desc: &BindGroupLayoutDescriptor,
    ) -> Result<Box<dyn DynBindGroupLayout>, DeviceError> {
        self.before("create_bind_group_layout", || self.error())?;
        let value = unsafe { self.inner.create_bind_group_layout(desc) }?;
        self.record_handle("create_bind_group_layout", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_bind_group_layout(&self, bg_layout: Box<dyn DynBindGroupLayout>) {
        self.record_handle("destroy_bind_group_layout", handle(bg_layout.as_ref()));
        unsafe { self.inner.destroy_bind_group_layout(bg_layout) }
    }
    unsafe fn create_pipeline_layout(
        &self,
        desc: &PipelineLayoutDescriptor<dyn DynBindGroupLayout>,
    ) -> Result<Box<dyn DynPipelineLayout>, DeviceError> {
        self.events.layout_flags.lock().unwrap().push(desc.flags);
        self.before("create_pipeline_layout", || self.error())?;
        let value = unsafe { self.inner.create_pipeline_layout(desc) }?;
        self.record_handle("create_pipeline_layout", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_pipeline_layout(&self, pipeline_layout: Box<dyn DynPipelineLayout>) {
        self.record_handle("destroy_pipeline_layout", handle(pipeline_layout.as_ref()));
        unsafe { self.inner.destroy_pipeline_layout(pipeline_layout) }
    }
    unsafe fn create_bind_group(
        &self,
        desc: &BindGroupDescriptor<
            dyn DynBindGroupLayout,
            dyn DynBuffer,
            dyn DynSampler,
            dyn DynTextureView,
            dyn DynAccelerationStructure,
        >,
    ) -> Result<Box<dyn DynBindGroup>, DeviceError> {
        self.before("create_bind_group", || self.error())?;
        let value = unsafe { self.inner.create_bind_group(desc) }?;
        self.record_handle("create_bind_group", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_bind_group(&self, group: Box<dyn DynBindGroup>) {
        self.record_handle("destroy_bind_group", handle(group.as_ref()));
        unsafe { self.inner.destroy_bind_group(group) }
    }
    unsafe fn create_shader_module(
        &self,
        desc: &ShaderModuleDescriptor,
        shader: ShaderInput,
    ) -> Result<Box<dyn DynShaderModule>, ShaderError> {
        self.before("create_shader_module", || ShaderError::Device(self.error()))?;
        let value = unsafe { self.inner.create_shader_module(desc, shader) }?;
        self.record_handle("create_shader_module", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_shader_module(&self, module: Box<dyn DynShaderModule>) {
        self.record_handle("destroy_shader_module", handle(module.as_ref()));
        unsafe { self.inner.destroy_shader_module(module) }
    }
    unsafe fn create_render_pipeline(
        &self,
        desc: &RenderPipelineDescriptor<
            dyn DynPipelineLayout,
            dyn DynShaderModule,
            dyn DynPipelineCache,
        >,
    ) -> Result<Box<dyn DynRenderPipeline>, PipelineError> {
        self.before("create_render_pipeline", || {
            PipelineError::Device(self.error())
        })?;
        let value = unsafe { self.inner.create_render_pipeline(desc) }?;
        self.record_handle("create_render_pipeline", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_render_pipeline(&self, pipeline: Box<dyn DynRenderPipeline>) {
        self.record_handle("destroy_render_pipeline", handle(pipeline.as_ref()));
        unsafe { self.inner.destroy_render_pipeline(pipeline) }
    }
    unsafe fn create_compute_pipeline(
        &self,
        desc: &ComputePipelineDescriptor<
            dyn DynPipelineLayout,
            dyn DynShaderModule,
            dyn DynPipelineCache,
        >,
    ) -> Result<Box<dyn DynComputePipeline>, PipelineError> {
        self.before("create_compute_pipeline", || {
            PipelineError::Device(self.error())
        })?;
        let value = unsafe { self.inner.create_compute_pipeline(desc) }?;
        self.record_handle("create_compute_pipeline", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_compute_pipeline(&self, pipeline: Box<dyn DynComputePipeline>) {
        self.record_handle("destroy_compute_pipeline", handle(pipeline.as_ref()));
        unsafe { self.inner.destroy_compute_pipeline(pipeline) }
    }
    unsafe fn create_ray_tracing_pipeline(
        &self,
        desc: &RayTracingPipelineDescriptor<
            dyn DynPipelineLayout,
            dyn DynShaderModule,
            dyn DynPipelineCache,
        >,
    ) -> Result<Box<dyn DynRayTracingPipeline>, PipelineError> {
        self.before("create_ray_tracing_pipeline", || {
            PipelineError::Device(self.error())
        })?;
        let value = unsafe { self.inner.create_ray_tracing_pipeline(desc) }?;
        self.record_handle("create_ray_tracing_pipeline", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_ray_tracing_pipeline(&self, pipeline: Box<dyn DynRayTracingPipeline>) {
        self.record_handle("destroy_ray_tracing_pipeline", handle(pipeline.as_ref()));
        unsafe { self.inner.destroy_ray_tracing_pipeline(pipeline) }
    }
    unsafe fn get_raytracing_pipeline_group_data(
        &self,
        pipeline: &dyn DynRayTracingPipeline,
        groups: core::ops::Range<u32>,
    ) -> Result<Vec<u8>, DeviceError> {
        unsafe {
            self.inner
                .get_raytracing_pipeline_group_data(pipeline, groups)
        }
    }
    unsafe fn create_pipeline_cache(
        &self,
        desc: &PipelineCacheDescriptor<'_>,
    ) -> Result<Box<dyn DynPipelineCache>, PipelineCacheError> {
        self.before("create_pipeline_cache", || {
            PipelineCacheError::Device(self.error())
        })?;
        let value = unsafe { self.inner.create_pipeline_cache(desc) }?;
        self.record_handle("create_pipeline_cache", handle(value.as_ref()));
        Ok(value)
    }
    fn pipeline_cache_validation_key(&self) -> Option<[u8; 16]> {
        self.inner.pipeline_cache_validation_key()
    }
    unsafe fn destroy_pipeline_cache(&self, cache: Box<dyn DynPipelineCache>) {
        self.record_handle("destroy_pipeline_cache", handle(cache.as_ref()));
        unsafe { self.inner.destroy_pipeline_cache(cache) }
    }
    unsafe fn create_query_set(
        &self,
        desc: &wgt::QuerySetDescriptor<Label>,
    ) -> Result<Box<dyn DynQuerySet>, DeviceError> {
        self.before("create_query_set", || self.error())?;
        let value = unsafe { self.inner.create_query_set(desc) }?;
        self.record_handle("create_query_set", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_query_set(&self, set: Box<dyn DynQuerySet>) {
        self.record_handle("destroy_query_set", handle(set.as_ref()));
        unsafe { self.inner.destroy_query_set(set) }
    }
    unsafe fn create_fence(&self) -> Result<Box<dyn DynFence>, DeviceError> {
        self.before("create_fence", || self.error())?;
        let value = unsafe { self.inner.create_fence() }?;
        self.record_handle("create_fence", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn destroy_fence(&self, fence: Box<dyn DynFence>) {
        self.record_handle("destroy_fence", handle(fence.as_ref()));
        unsafe { self.inner.destroy_fence(fence) }
    }
    unsafe fn get_fence_value(&self, fence: &dyn DynFence) -> Result<FenceValue, DeviceError> {
        unsafe { self.inner.get_fence_value(fence) }
    }
    unsafe fn wait(
        &self,
        fence: &dyn DynFence,
        value: FenceValue,
        timeout: Option<core::time::Duration>,
    ) -> Result<bool, DeviceError> {
        unsafe { self.inner.wait(fence, value, timeout) }
    }
    unsafe fn start_graphics_debugger_capture(&self) -> bool {
        unsafe { self.inner.start_graphics_debugger_capture() }
    }
    unsafe fn stop_graphics_debugger_capture(&self) {
        unsafe { self.inner.stop_graphics_debugger_capture() }
    }
    unsafe fn pipeline_cache_get_data(&self, cache: &dyn DynPipelineCache) -> Option<Vec<u8>> {
        unsafe { self.inner.pipeline_cache_get_data(cache) }
    }
    unsafe fn create_acceleration_structure(
        &self,
        desc: &AccelerationStructureDescriptor,
    ) -> Result<Box<dyn DynAccelerationStructure>, DeviceError> {
        self.before("create_acceleration_structure", || self.error())?;
        let value = unsafe { self.inner.create_acceleration_structure(desc) }?;
        self.record_handle("create_acceleration_structure", handle(value.as_ref()));
        Ok(value)
    }
    unsafe fn get_acceleration_structure_build_sizes(
        &self,
        desc: &GetAccelerationStructureBuildSizesDescriptor<dyn DynBuffer>,
    ) -> AccelerationStructureBuildSizes {
        unsafe { self.inner.get_acceleration_structure_build_sizes(desc) }
    }
    unsafe fn get_acceleration_structure_device_address(
        &self,
        acceleration_structure: &dyn DynAccelerationStructure,
    ) -> wgt::BufferAddress {
        unsafe {
            self.inner
                .get_acceleration_structure_device_address(acceleration_structure)
        }
    }
    unsafe fn destroy_acceleration_structure(
        &self,
        acceleration_structure: Box<dyn DynAccelerationStructure>,
    ) {
        self.record_handle(
            "destroy_acceleration_structure",
            handle(acceleration_structure.as_ref()),
        );
        unsafe {
            self.inner
                .destroy_acceleration_structure(acceleration_structure)
        }
    }
    fn tlas_instance_to_bytes(&self, instance: TlasInstance) -> Vec<u8> {
        self.inner.tlas_instance_to_bytes(instance)
    }
    fn get_internal_counters(&self) -> wgt::HalCounters {
        self.inner.get_internal_counters()
    }
    fn generate_allocator_report(&self) -> Option<wgt::AllocatorReport> {
        self.inner.generate_allocator_report()
    }
    fn check_if_oom(&self) -> Result<(), DeviceError> {
        self.inner.check_if_oom()
    }
}
