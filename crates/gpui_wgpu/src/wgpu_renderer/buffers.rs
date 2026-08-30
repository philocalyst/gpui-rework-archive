use crate::shaders::interface::{self as shader_interface, BufferData};
use std::{
    cell::{Cell, RefCell},
    marker::PhantomData,
    num::NonZeroU64,
};

#[derive(Clone, Copy)]
pub(super) struct BufferSlice {
    pub(super) offset: u64,
    pub(super) size: NonZeroU64,
}

/// A single mapped staging allocation containing every instance payload for one frame.
pub(super) struct InstanceUpload {
    staging: Option<wgpu::QueueWriteBufferView>,
    cursor: u64,
    size: u64,
    alignment: u64,
}

impl InstanceUpload {
    pub(super) fn write(&mut self, data: &[u8]) -> Option<BufferSlice> {
        let offset = self.cursor.next_multiple_of(self.alignment);
        let size = (data.len() as u64).max(16);
        if offset + size > self.size {
            return None;
        }
        let staging = self
            .staging
            .as_mut()
            .expect("non-empty frame uploads have mapped staging memory");
        let mut destination = staging.slice(offset as usize..(offset + size) as usize);
        destination.fill(0);
        destination.slice(..data.len()).copy_from_slice(data);
        self.cursor = offset + size;
        Some(BufferSlice {
            offset,
            size: NonZeroU64::new(size).expect("instance slices are at least 16 bytes"),
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

    pub(super) fn finish_upload(&self) {
        self.staging.take();
    }

    pub(super) fn write(&self, value: &T) -> BufferSlice {
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
        BufferSlice {
            offset,
            size: NonZeroU64::new(std::mem::size_of::<T>() as u64)
                .expect("uniform types are non-empty"),
        }
    }
}

/// One frame's zero-copy scene data arena.
pub(super) struct InstanceBufferArena {
    buffer: wgpu::Buffer,
    capacity: u64,
    maximum_size: u64,
    alignment: u64,
}

impl InstanceBufferArena {
    const INITIAL_CAPACITY: u64 = 2 * 1024 * 1024;

    pub(super) fn new(device: &wgpu::Device) -> Self {
        let maximum_size = device
            .limits()
            .max_buffer_size
            .min(device.limits().max_storage_buffer_binding_size);
        let capacity = Self::INITIAL_CAPACITY.min(maximum_size);
        Self {
            buffer: create_buffer(
                device,
                "instance_buffer",
                capacity,
                wgpu::BufferUsages::STORAGE,
            ),
            capacity,
            maximum_size,
            alignment: device.limits().min_storage_buffer_offset_alignment as u64,
        }
    }

    pub(super) fn alignment(&self) -> u64 {
        self.alignment
    }

    pub(super) fn ensure_capacity(&mut self, device: &wgpu::Device, required: u64) -> bool {
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
            alignment: self.alignment,
        })
    }

    pub(super) fn binding(&self, slice: BufferSlice) -> wgpu::BufferBinding<'_> {
        wgpu::BufferBinding {
            buffer: &self.buffer,
            offset: slice.offset,
            size: Some(slice.size),
        }
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
