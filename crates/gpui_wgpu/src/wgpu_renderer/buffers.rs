use crate::shaders::interface::{self as shader_interface, BufferData};
use collections::FxHashMap;
use gpui::AtlasTextureId;
use std::{
    cell::{Cell, RefCell},
    marker::PhantomData,
    num::NonZeroU64,
    ops::Range,
};

use super::pipelines::WgpuBindGroupLayouts;

pub(super) struct InstanceSlice<T> {
    first: u32,
    count: u32,
    value: PhantomData<T>,
}

impl<T> InstanceSlice<T> {
    pub(super) fn range(&self) -> Range<u32> {
        self.first..self.first + self.count
    }
}

/// A single mapped staging allocation containing every instance payload for one frame.
pub(super) struct InstanceUpload {
    staging: Option<wgpu::QueueWriteBufferView>,
    cursor: u64,
    size: u64,
}

impl InstanceUpload {
    pub(super) fn write<T: BufferData>(&mut self, values: &[T]) -> Option<InstanceSlice<T>> {
        let stride = std::mem::size_of::<T>() as u64;
        let offset = self.cursor.next_multiple_of(stride);
        let data = shader_interface::slice_as_bytes(values);
        let size = data.len() as u64;
        if offset + size > self.size {
            return None;
        }
        let staging = self
            .staging
            .as_mut()
            .expect("non-empty frame uploads have mapped staging memory");
        staging
            .slice(offset as usize..(offset + size) as usize)
            .copy_from_slice(data);
        self.cursor = offset + size;
        Some(InstanceSlice {
            first: u32::try_from(offset / stride).ok()?,
            count: u32::try_from(values.len()).ok()?,
            value: PhantomData,
        })
    }

    pub(super) fn write_iter<T: BufferData>(
        &mut self,
        count: usize,
        values: impl IntoIterator<Item = T>,
    ) -> Option<InstanceSlice<T>> {
        let stride = std::mem::size_of::<T>() as u64;
        let offset = self.cursor.next_multiple_of(stride);
        let size = stride.checked_mul(count as u64)?;
        if offset + size > self.size {
            return None;
        }
        let staging = self
            .staging
            .as_mut()
            .expect("non-empty frame uploads have mapped staging memory");
        let mut destination = staging.slice(offset as usize..(offset + size) as usize);
        let mut values = values.into_iter();
        for index in 0..count {
            let value = values.next()?;
            destination
                .slice(index * stride as usize..(index + 1) * stride as usize)
                .copy_from_slice(shader_interface::bytes_of(&value));
        }
        if values.next().is_some() {
            return None;
        }
        self.cursor = offset + size;
        Some(InstanceSlice {
            first: u32::try_from(offset / stride).ok()?,
            count: u32::try_from(count).ok()?,
            value: PhantomData,
        })
    }

    pub(super) fn finish(&mut self) {
        // Dropping the mapped view schedules its one buffer copy before the next queue submission.
        self.staging.take();
    }
}

/// Alignment-aware uniform storage with frame-local slot allocation.
pub(super) struct DynamicUniformBuffer<T> {
    pub(super) buffer: wgpu::Buffer,
    label: &'static str,
    stride: u64,
    capacity: u64,
    generation: u64,
    next_slot: Cell<u64>,
    staging: RefCell<Option<wgpu::QueueWriteBufferView>>,
    value: PhantomData<T>,
}

impl<T: BufferData> DynamicUniformBuffer<T> {
    pub(super) fn new(
        device: &wgpu::Device,
        label: &'static str,
        initial_capacity: u64,
        uniform_alignment: u64,
    ) -> Self {
        let stride = (std::mem::size_of::<T>() as u64).next_multiple_of(uniform_alignment);
        let buffer = create_buffer(
            device,
            label,
            stride * initial_capacity,
            wgpu::BufferUsages::UNIFORM,
        );
        Self {
            buffer,
            label,
            stride,
            capacity: initial_capacity,
            generation: 0,
            next_slot: Cell::new(0),
            staging: RefCell::new(None),
            value: PhantomData,
        }
    }

    pub(super) fn ensure_capacity(
        &mut self,
        device: &wgpu::Device,
        required_capacity: u64,
        maximum_buffer_size: u64,
    ) -> bool {
        if required_capacity <= self.capacity {
            return true;
        }

        let new_capacity = required_capacity.next_power_of_two();
        let Some(new_size) = self.stride.checked_mul(new_capacity) else {
            return false;
        };
        if new_size > maximum_buffer_size || new_size > u32::MAX as u64 {
            return false;
        }

        self.buffer = create_buffer(device, self.label, new_size, wgpu::BufferUsages::UNIFORM);
        self.capacity = new_capacity;
        self.generation = self.generation.wrapping_add(1);
        true
    }

    pub(super) fn begin_upload(&self, queue: &wgpu::Queue, required_capacity: u64) -> bool {
        if required_capacity > self.capacity {
            return false;
        }
        self.next_slot.set(0);
        let Some(size) = NonZeroU64::new(self.stride * required_capacity) else {
            self.staging.take();
            return true;
        };
        let Some(mut staging) = queue.write_buffer_with(&self.buffer, 0, size) else {
            return false;
        };
        staging.slice(..).fill(0);
        self.staging.replace(Some(staging));
        true
    }

    pub(super) fn generation(&self) -> u64 {
        self.generation
    }

    pub(super) fn finish_upload(&self) {
        self.staging.take();
    }

    pub(super) fn write(&self, value: &T) -> u32 {
        let slot = self.next_slot.get();
        assert!(
            slot < self.capacity,
            "{} capacity must be ensured before rendering",
            self.label
        );
        self.next_slot.set(slot + 1);
        let offset = slot * self.stride;
        let bytes = shader_interface::bytes_of(value);
        self.staging
            .borrow_mut()
            .as_mut()
            .expect("uniform uploads must begin before rendering")
            .slice(offset as usize..offset as usize + bytes.len())
            .copy_from_slice(bytes);
        u32::try_from(offset).expect("dynamic uniform offsets are limited to u32")
    }
}

/// One frame's zero-copy scene data arena.
pub(super) struct InstanceBufferArena {
    buffer: wgpu::Buffer,
    bind_group: wgpu::BindGroup,
    textured_bind_groups: RefCell<TexturedBindGroups>,
    capacity: u64,
    maximum_size: u64,
}

#[derive(Default)]
struct TexturedBindGroups {
    atlas_generation: Option<u64>,
    groups: FxHashMap<AtlasTextureId, wgpu::BindGroup>,
    path: Option<wgpu::BindGroup>,
}

impl InstanceBufferArena {
    // Large scenes grow geometrically; ordinary UI frames fit without a permanent 2 MiB floor.
    const INITIAL_CAPACITY: u64 = 64 * 1024;

    pub(super) fn new(device: &wgpu::Device, layouts: &WgpuBindGroupLayouts) -> Self {
        let maximum_size = device
            .limits()
            .max_buffer_size
            .min(device.limits().max_storage_buffer_binding_size);
        let capacity = Self::INITIAL_CAPACITY.min(maximum_size);
        let buffer = create_buffer(
            device,
            "instance_buffer",
            capacity,
            wgpu::BufferUsages::STORAGE,
        );
        let bind_group = layouts.create_instances(device, whole_buffer(&buffer));
        Self {
            buffer,
            bind_group,
            textured_bind_groups: RefCell::default(),
            capacity,
            maximum_size,
        }
    }

    pub(super) fn ensure_capacity(
        &mut self,
        device: &wgpu::Device,
        layouts: &WgpuBindGroupLayouts,
        required: u64,
    ) -> bool {
        if required <= self.capacity {
            return true;
        }
        if required > self.maximum_size {
            log::error!(
                "scene requires {required} storage bytes, exceeding the GPU limit of {}",
                self.maximum_size
            );
            return false;
        }

        self.capacity = required.next_power_of_two().min(self.maximum_size);
        self.buffer = create_buffer(
            device,
            "instance_buffer",
            self.capacity,
            wgpu::BufferUsages::STORAGE,
        );
        self.bind_group = layouts.create_instances(device, whole_buffer(&self.buffer));
        *self.textured_bind_groups.get_mut() = TexturedBindGroups::default();
        log::info!("increased instance buffer size to {}", self.capacity);
        true
    }

    pub(super) fn begin_upload(
        &self,
        queue: &wgpu::Queue,
        required: u64,
    ) -> Option<InstanceUpload> {
        if required > self.capacity {
            return None;
        }
        let staging = if let Some(size) = NonZeroU64::new(required) {
            Some(queue.write_buffer_with(&self.buffer, 0, size)?)
        } else {
            None
        };
        Some(InstanceUpload {
            staging,
            cursor: 0,
            size: required,
        })
    }

    pub(super) fn bind_group(&self) -> &wgpu::BindGroup {
        &self.bind_group
    }

    pub(super) fn textured_bind_group(
        &self,
        device: &wgpu::Device,
        layouts: &WgpuBindGroupLayouts,
        texture_id: AtlasTextureId,
        atlas_generation: u64,
        texture: &wgpu::TextureView,
        sampler: &wgpu::Sampler,
    ) -> wgpu::BindGroup {
        let mut cache = self.textured_bind_groups.borrow_mut();
        if cache.atlas_generation != Some(atlas_generation) {
            cache.groups.clear();
            cache.atlas_generation = Some(atlas_generation);
        }
        cache
            .groups
            .entry(texture_id)
            .or_insert_with(|| {
                layouts.create_textured_instances(
                    device,
                    whole_buffer(&self.buffer),
                    texture,
                    sampler,
                )
            })
            .clone()
    }

    pub(super) fn path_bind_group(
        &self,
        device: &wgpu::Device,
        layouts: &WgpuBindGroupLayouts,
        texture: &wgpu::TextureView,
        sampler: &wgpu::Sampler,
    ) -> wgpu::BindGroup {
        let mut cache = self.textured_bind_groups.borrow_mut();
        cache
            .path
            .get_or_insert_with(|| {
                layouts.create_textured_instances(
                    device,
                    whole_buffer(&self.buffer),
                    texture,
                    sampler,
                )
            })
            .clone()
    }

    pub(super) fn invalidate_texture_bindings(&self) {
        *self.textured_bind_groups.borrow_mut() = TexturedBindGroups::default();
    }
}

fn whole_buffer(buffer: &wgpu::Buffer) -> wgpu::BufferBinding<'_> {
    wgpu::BufferBinding {
        buffer,
        offset: 0,
        size: None,
    }
}

fn create_buffer(
    device: &wgpu::Device,
    label: &str,
    size: u64,
    primary_usage: wgpu::BufferUsages,
) -> wgpu::Buffer {
    device.create_buffer(&wgpu::BufferDescriptor {
        label: Some(label),
        size,
        usage: primary_usage | wgpu::BufferUsages::COPY_DST,
        mapped_at_creation: false,
    })
}
