use crate::{
    device::DeviceError,
    pipeline::{CreateComputePipelineError, CreateShaderModuleError},
};
use alloc::boxed::Box;
use thiserror::Error;

mod dispatch;
mod draw;
mod utils;

/// Owns a HAL acquisition until it is committed to its final owner. HAL resources
/// require explicit destruction; dropping their boxes alone does not release them.
/// Stack order releases dependent acquisitions before the objects they reference,
/// including when a later HAL call returns an error or unwinds.
pub(crate) struct Pending<T, F: FnOnce(T)> {
    value: Option<T>,
    cleanup: Option<F>,
}

impl<T, F: FnOnce(T)> Pending<T, F> {
    pub(crate) fn new(value: T, cleanup: F) -> Self {
        Self {
            value: Some(value),
            cleanup: Some(cleanup),
        }
    }

    pub(crate) fn commit(mut self) -> T {
        self.value.take().unwrap()
    }
}

impl<T, F: FnOnce(T)> core::ops::Deref for Pending<T, F> {
    type Target = T;
    fn deref(&self) -> &T {
        self.value.as_ref().unwrap()
    }
}

impl<T, F: FnOnce(T)> Drop for Pending<T, F> {
    fn drop(&mut self) {
        if let Some(value) = self.value.take() {
            self.cleanup.take().unwrap()(value);
        }
    }
}

pub(crate) use dispatch::Dispatch;
pub(crate) use draw::{Draw, DrawBatcher, DrawResources};

#[derive(Clone, Debug, Error)]
#[non_exhaustive]
enum CreateIndirectValidationPipelineError {
    #[error(transparent)]
    DeviceError(#[from] DeviceError),
    #[error(transparent)]
    ShaderModule(#[from] CreateShaderModuleError),
    #[error(transparent)]
    ComputePipeline(#[from] CreateComputePipelineError),
}

pub(crate) struct IndirectValidation {
    pub(crate) dispatch: Dispatch,
    pub(crate) draw: Draw,
}

impl IndirectValidation {
    pub(crate) fn new(
        device: &dyn hal::DynDevice,
        required_limits: &wgt::Limits,
        required_features: &wgt::Features,
        instance_flags: wgt::InstanceFlags,
        backend: wgt::Backend,
    ) -> Result<Self, DeviceError> {
        let dispatch = match Dispatch::new(device, instance_flags, required_limits) {
            Ok(dispatch) => dispatch,
            Err(e) => {
                log::error!("indirect-validation error: {e:?}");
                return Err(DeviceError::Lost);
            }
        };
        let dispatch = Pending::new(dispatch, |dispatch: Dispatch| dispatch.dispose(device));
        let draw = match Draw::new(
            device,
            required_features,
            instance_flags,
            backend,
            required_limits,
        ) {
            Ok(draw) => draw,
            Err(e) => {
                log::error!("indirect-draw-validation error: {e:?}");
                return Err(DeviceError::Lost);
            }
        };
        Ok(Self {
            dispatch: dispatch.commit(),
            draw,
        })
    }

    pub(crate) fn dispose(self, device: &dyn hal::DynDevice) {
        let Self { dispatch, draw } = self;

        dispatch.dispose(device);
        draw.dispose(device);
    }
}

#[derive(Debug)]
pub(crate) struct BindGroups {
    pub(crate) dispatch: Box<dyn hal::DynBindGroup>,
    draw: Box<dyn hal::DynBindGroup>,
}

impl BindGroups {
    /// `Ok(None)` will only be returned if `buffer_size` is `0`.
    pub(crate) fn new(
        indirect_validation: &IndirectValidation,
        device: &crate::device::Device,
        buffer_size: u64,
        buffer: &dyn hal::DynBuffer,
    ) -> Result<Option<Self>, DeviceError> {
        let dispatch = indirect_validation.dispatch.create_src_bind_group(
            device.raw(),
            &device.limits,
            buffer_size,
            buffer,
            device.instance_flags,
        )?;
        let dispatch = Pending::new(dispatch, |group| {
            if let Some(group) = group {
                // SAFETY: This unpublished group has no remaining users.
                unsafe { device.raw().destroy_bind_group(group) };
            }
        });
        let draw = indirect_validation.draw.create_src_bind_group(
            device.raw(),
            &device.adapter.limits(),
            buffer_size,
            buffer,
            device.instance_flags,
        )?;

        match (dispatch.commit(), draw) {
            (None, None) => Ok(None),
            (None, Some(_)) => unreachable!(),
            (Some(_), None) => unreachable!(),
            (Some(dispatch), Some(draw)) => Ok(Some(Self { dispatch, draw })),
        }
    }

    pub(crate) fn dispose(self, device: &dyn hal::DynDevice) {
        let Self { dispatch, draw } = self;

        unsafe {
            device.destroy_bind_group(dispatch);
            device.destroy_bind_group(draw);
        }
    }
}
