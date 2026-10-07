#![allow(non_snake_case)]
#![allow(non_camel_case_types)]

//! Thin macOS CoreMedia and CoreVideo wrappers used by GPUI's media pipeline.
//!
//! The public modules exist only on macOS. Their Core Foundation wrappers own retained
//! references, while `*_Ref` aliases represent borrowed raw framework pointers. The safe methods
//! expose common sample-buffer, H.264, and Metal-texture operations; APIs that accept raw pointers
//! remain `unsafe` because the framework validates pointer type, lifetime, device, and plane
//! requirements at runtime. Keep source buffers and the Metal device alive for the duration
//! required by CoreVideo, and propagate `Result` failures when the framework returns a nonzero
//! status.
//!
//! `core_media` provides sample metadata and block data. `core_video` bridges a
//! `CVImageBuffer` plane into a Metal texture. These wrappers do not decode or encode frames on
//! their own; they expose the native resources used by the higher-level media implementation.

mod bindings;

#[cfg(target_os = "macos")]
pub mod core_media {
    #![allow(non_snake_case)]

    //! CoreMedia sample-buffer timing, format descriptions, and compressed frame bytes.
    //!
    //! The Rust wrappers retain their native objects. Slices returned from a format description
    //! or block buffer borrow the native storage and must not outlive that wrapper.

    pub use crate::bindings::{
        CMItemIndex, CMSampleTimingInfo, CMTime, CMTimeMake, CMVideoCodecType,
        kCMSampleAttachmentKey_NotSync, kCMTimeInvalid, kCMVideoCodecType_H264,
    };
    use anyhow::Result;
    use core_foundation::{
        array::{CFArray, CFArrayRef},
        base::{CFTypeID, OSStatus, TCFType},
        declare_TCFType,
        dictionary::CFDictionary,
        impl_CFTypeDescription, impl_TCFType,
        string::CFString,
    };
    use core_video::image_buffer::{CVImageBuffer, CVImageBufferRef};
    use std::{ffi::c_void, ptr};

    #[repr(C)]
    /// Opaque CoreMedia sample-buffer type used by [`CMSampleBufferRef`].
    pub struct __CMSampleBuffer(c_void);
    /// Borrowed raw reference to a CoreMedia sample buffer.
    pub type CMSampleBufferRef = *const __CMSampleBuffer;

    declare_TCFType!(CMSampleBuffer, CMSampleBufferRef);
    impl_TCFType!(CMSampleBuffer, CMSampleBufferRef, CMSampleBufferGetTypeID);
    impl_CFTypeDescription!(CMSampleBuffer);

    impl CMSampleBuffer {
        /// Returns retained sample-attachment dictionaries, creating the attachment array if needed.
        pub fn attachments(&self) -> Vec<CFDictionary<CFString>> {
            unsafe {
                let attachments =
                    CMSampleBufferGetSampleAttachmentsArray(self.as_concrete_TypeRef(), true);
                CFArray::<CFDictionary>::wrap_under_get_rule(attachments)
                    .into_iter()
                    .map(|attachments| {
                        CFDictionary::wrap_under_get_rule(attachments.as_concrete_TypeRef())
                    })
                    .collect()
            }
        }

        /// Retains and returns the sample's image buffer, if it contains one.
        pub fn image_buffer(&self) -> Option<CVImageBuffer> {
            unsafe {
                let ptr = CMSampleBufferGetImageBuffer(self.as_concrete_TypeRef());
                if ptr.is_null() {
                    None
                } else {
                    Some(CVImageBuffer::wrap_under_get_rule(ptr))
                }
            }
        }

        /// Returns timing values for sample `index`, or the CoreMedia status error.
        ///
        /// A successful result may still contain `kCMTimeInvalid` for timing values the sample
        /// does not provide. The index must refer to a sample in this buffer.
        pub fn sample_timing_info(&self, index: usize) -> Result<CMSampleTimingInfo> {
            unsafe {
                let mut timing_info = CMSampleTimingInfo {
                    duration: kCMTimeInvalid,
                    presentationTimeStamp: kCMTimeInvalid,
                    decodeTimeStamp: kCMTimeInvalid,
                };
                let result = CMSampleBufferGetSampleTimingInfo(
                    self.as_concrete_TypeRef(),
                    index as CMItemIndex,
                    &mut timing_info,
                );
                anyhow::ensure!(
                    result == 0,
                    "error getting sample timing info, code {result}"
                );
                Ok(timing_info)
            }
        }

        /// Returns the sample's format description with a retained Core Foundation reference.
        pub fn format_description(&self) -> CMFormatDescription {
            unsafe {
                CMFormatDescription::wrap_under_get_rule(CMSampleBufferGetFormatDescription(
                    self.as_concrete_TypeRef(),
                ))
            }
        }

        /// Returns the sample's data block with a retained Core Foundation reference.
        pub fn data(&self) -> CMBlockBuffer {
            unsafe {
                CMBlockBuffer::wrap_under_get_rule(CMSampleBufferGetDataBuffer(
                    self.as_concrete_TypeRef(),
                ))
            }
        }
    }

    #[link(name = "CoreMedia", kind = "framework")]
    unsafe extern "C" {
        fn CMSampleBufferGetTypeID() -> CFTypeID;
        fn CMSampleBufferGetSampleAttachmentsArray(
            buffer: CMSampleBufferRef,
            create_if_necessary: bool,
        ) -> CFArrayRef;
        fn CMSampleBufferGetImageBuffer(buffer: CMSampleBufferRef) -> CVImageBufferRef;
        fn CMSampleBufferGetSampleTimingInfo(
            buffer: CMSampleBufferRef,
            index: CMItemIndex,
            timing_info_out: *mut CMSampleTimingInfo,
        ) -> OSStatus;
        fn CMSampleBufferGetFormatDescription(buffer: CMSampleBufferRef) -> CMFormatDescriptionRef;
        fn CMSampleBufferGetDataBuffer(sample_buffer: CMSampleBufferRef) -> CMBlockBufferRef;
    }

    #[repr(C)]
    /// Opaque CoreMedia format-description type used by [`CMFormatDescriptionRef`].
    pub struct __CMFormatDescription(c_void);
    /// Borrowed raw reference to a CoreMedia format description.
    pub type CMFormatDescriptionRef = *const __CMFormatDescription;

    declare_TCFType!(CMFormatDescription, CMFormatDescriptionRef);
    impl_TCFType!(
        CMFormatDescription,
        CMFormatDescriptionRef,
        CMFormatDescriptionGetTypeID
    );
    impl_CFTypeDescription!(CMFormatDescription);

    impl CMFormatDescription {
        /// Returns the number of H.264 parameter sets reported by CoreMedia.
        ///
        /// CoreMedia status failures panic in this convenience method. Use it only with a valid
        /// H.264 video format description.
        pub fn h264_parameter_set_count(&self) -> usize {
            unsafe {
                let mut count = 0;
                let result = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(
                    self.as_concrete_TypeRef(),
                    0,
                    ptr::null_mut(),
                    ptr::null_mut(),
                    &mut count,
                    ptr::null_mut(),
                );
                assert_eq!(result, 0);
                count
            }
        }

        /// Borrows the H.264 parameter-set bytes at `index` from this format description.
        ///
        /// The returned slice is tied to the format description's storage. Keep `self` alive and
        /// pass a valid parameter-set index.
        pub fn h264_parameter_set_at_index(&self, index: usize) -> Result<&[u8]> {
            unsafe {
                let mut bytes = ptr::null();
                let mut len = 0;
                let result = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(
                    self.as_concrete_TypeRef(),
                    index,
                    &mut bytes,
                    &mut len,
                    ptr::null_mut(),
                    ptr::null_mut(),
                );
                anyhow::ensure!(result == 0, "error getting parameter set, code: {result}");
                Ok(std::slice::from_raw_parts(bytes, len))
            }
        }
    }

    #[link(name = "CoreMedia", kind = "framework")]
    unsafe extern "C" {
        fn CMFormatDescriptionGetTypeID() -> CFTypeID;
        fn CMVideoFormatDescriptionGetH264ParameterSetAtIndex(
            video_desc: CMFormatDescriptionRef,
            parameter_set_index: usize,
            parameter_set_pointer_out: *mut *const u8,
            parameter_set_size_out: *mut usize,
            parameter_set_count_out: *mut usize,
            NALUnitHeaderLengthOut: *mut isize,
        ) -> OSStatus;
    }

    #[repr(C)]
    /// Opaque CoreMedia block-buffer type used by [`CMBlockBufferRef`].
    pub struct __CMBlockBuffer(c_void);
    /// Borrowed raw reference to a CoreMedia block buffer.
    pub type CMBlockBufferRef = *const __CMBlockBuffer;

    declare_TCFType!(CMBlockBuffer, CMBlockBufferRef);
    impl_TCFType!(CMBlockBuffer, CMBlockBufferRef, CMBlockBufferGetTypeID);
    impl_CFTypeDescription!(CMBlockBuffer);

    impl CMBlockBuffer {
        /// Borrows the block buffer's contiguous bytes.
        ///
        /// This convenience method asserts that CoreMedia can expose the data as one contiguous
        /// pointer. Keep the block buffer alive while using the returned slice.
        pub fn bytes(&self) -> &[u8] {
            unsafe {
                let mut bytes = ptr::null();
                let mut len = 0;
                let result = CMBlockBufferGetDataPointer(
                    self.as_concrete_TypeRef(),
                    0,
                    &mut 0,
                    &mut len,
                    &mut bytes,
                );
                assert!(result == 0, "could not get block buffer data");
                std::slice::from_raw_parts(bytes, len)
            }
        }
    }

    #[link(name = "CoreMedia", kind = "framework")]
    unsafe extern "C" {
        fn CMBlockBufferGetTypeID() -> CFTypeID;
        fn CMBlockBufferGetDataPointer(
            buffer: CMBlockBufferRef,
            offset: usize,
            length_at_offset_out: *mut usize,
            total_length_out: *mut usize,
            data_pointer_out: *mut *const u8,
        ) -> OSStatus;
    }
}

#[cfg(target_os = "macos")]
pub mod core_video {
    #![allow(non_snake_case)]

    //! CoreVideo pixel formats and the bridge from image-buffer planes to Metal textures.
    //!
    //! The cache and texture wrappers retain native references. Raw input pointers remain the
    //! caller's responsibility and must satisfy CoreVideo's format, device, and lifetime rules.

    #[cfg(target_os = "macos")]
    use core_foundation::{
        base::{CFTypeID, TCFType},
        declare_TCFType, impl_CFTypeDescription, impl_TCFType,
    };
    #[cfg(target_os = "macos")]
    use std::ffi::c_void;

    use crate::bindings::{CVReturn, kCVReturnSuccess};
    pub use crate::bindings::{
        kCVPixelFormatType_32BGRA, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
        kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, kCVPixelFormatType_420YpCbCr8Planar,
    };
    use anyhow::Result;
    use core_foundation::{
        base::kCFAllocatorDefault, dictionary::CFDictionaryRef, mach_port::CFAllocatorRef,
    };
    use foreign_types::ForeignTypeRef;

    use metal::{MTLDevice, MTLPixelFormat};
    use std::ptr;

    #[repr(C)]
    /// Opaque CoreVideo Metal texture-cache type used by [`CVMetalTextureCacheRef`].
    pub struct __CVMetalTextureCache(c_void);
    /// Borrowed raw reference to a CoreVideo Metal texture cache.
    pub type CVMetalTextureCacheRef = *const __CVMetalTextureCache;

    declare_TCFType!(CVMetalTextureCache, CVMetalTextureCacheRef);
    impl_TCFType!(
        CVMetalTextureCache,
        CVMetalTextureCacheRef,
        CVMetalTextureCacheGetTypeID
    );
    impl_CFTypeDescription!(CVMetalTextureCache);

    impl CVMetalTextureCache {
        /// Creates a texture cache for a live Metal device.
        ///
        /// # Safety
        ///
        /// `metal_device` must be a valid Metal device pointer accepted by
        /// `CVMetalTextureCacheCreate`. The caller must keep the device alive as required by
        /// Metal and CoreVideo.
        ///
        /// Returns an error if CoreVideo reports a non-success status.
        pub unsafe fn new(metal_device: *mut MTLDevice) -> Result<Self> {
            let mut this = ptr::null();
            let result = unsafe {
                CVMetalTextureCacheCreate(
                    kCFAllocatorDefault,
                    ptr::null(),
                    metal_device,
                    ptr::null(),
                    &mut this,
                )
            };
            anyhow::ensure!(
                result == kCVReturnSuccess,
                "could not create texture cache, code: {result}"
            );
            unsafe { Ok(CVMetalTextureCache::wrap_under_create_rule(this)) }
        }

        /// Creates a Metal texture for one plane of a CoreVideo image buffer.
        ///
        /// # Safety
        ///
        /// `source`, `texture_attributes`, the pixel format, dimensions, and `plane_index` must
        /// satisfy `CVMetalTextureCacheCreateTextureFromImage` for this cache and source image.
        /// In particular, the plane index and dimensions must be valid for the image's pixel
        /// format. The caller must keep the source image alive for the required framework
        /// lifetime.
        ///
        /// Returns an error if CoreVideo reports a non-success status.
        pub unsafe fn create_texture_from_image(
            &self,
            source: ::core_video::image_buffer::CVImageBufferRef,
            texture_attributes: CFDictionaryRef,
            pixel_format: MTLPixelFormat,
            width: usize,
            height: usize,
            plane_index: usize,
        ) -> Result<CVMetalTexture> {
            let mut this = ptr::null();
            let result = unsafe {
                CVMetalTextureCacheCreateTextureFromImage(
                    kCFAllocatorDefault,
                    self.as_concrete_TypeRef(),
                    source,
                    texture_attributes,
                    pixel_format,
                    width,
                    height,
                    plane_index,
                    &mut this,
                )
            };
            anyhow::ensure!(
                result == kCVReturnSuccess,
                "could not create texture, code: {result}"
            );
            unsafe { Ok(CVMetalTexture::wrap_under_create_rule(this)) }
        }
    }

    #[link(name = "CoreVideo", kind = "framework")]
    unsafe extern "C" {
        fn CVMetalTextureCacheGetTypeID() -> CFTypeID;
        fn CVMetalTextureCacheCreate(
            allocator: CFAllocatorRef,
            cache_attributes: CFDictionaryRef,
            metal_device: *const MTLDevice,
            texture_attributes: CFDictionaryRef,
            cache_out: *mut CVMetalTextureCacheRef,
        ) -> CVReturn;
        fn CVMetalTextureCacheCreateTextureFromImage(
            allocator: CFAllocatorRef,
            texture_cache: CVMetalTextureCacheRef,
            source_image: ::core_video::image_buffer::CVImageBufferRef,
            texture_attributes: CFDictionaryRef,
            pixel_format: MTLPixelFormat,
            width: usize,
            height: usize,
            plane_index: usize,
            texture_out: *mut CVMetalTextureRef,
        ) -> CVReturn;
    }

    #[repr(C)]
    /// Opaque CoreVideo Metal texture type used by [`CVMetalTextureRef`].
    pub struct __CVMetalTexture(c_void);
    /// Borrowed raw reference to a CoreVideo Metal texture.
    pub type CVMetalTextureRef = *const __CVMetalTexture;

    declare_TCFType!(CVMetalTexture, CVMetalTextureRef);
    impl_TCFType!(CVMetalTexture, CVMetalTextureRef, CVMetalTextureGetTypeID);
    impl_CFTypeDescription!(CVMetalTexture);

    impl CVMetalTexture {
        /// Returns the Metal texture retained by this CoreVideo texture wrapper.
        ///
        /// Keep `self` alive while using the borrowed texture reference.
        pub fn as_texture_ref(&self) -> &metal::TextureRef {
            unsafe {
                let texture = CVMetalTextureGetTexture(self.as_concrete_TypeRef());
                metal::TextureRef::from_ptr(texture as *mut _)
            }
        }
    }

    #[link(name = "CoreVideo", kind = "framework")]
    unsafe extern "C" {
        fn CVMetalTextureGetTypeID() -> CFTypeID;
        fn CVMetalTextureGetTexture(texture: CVMetalTextureRef) -> *mut c_void;
    }
}
