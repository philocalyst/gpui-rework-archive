// Test-only single-device Vulkan layer. Never enable for allocator captures.
// VkLayer* ABI is supplied by the pinned Khronos vk_layer.h, not redeclared.
#define VK_ENABLE_BETA_EXTENSIONS
#include <vulkan/vk_layer.h>
#include <vulkan/vulkan_beta.h>
#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

static PFN_vkGetInstanceProcAddr next_instance;
static VkInstance active_instance;

static void metadata_device(VkPhysicalDevice physical, const VkDeviceCreateInfo *info) {
    PFN_vkGetPhysicalDeviceProperties get_properties = (PFN_vkGetPhysicalDeviceProperties)next_instance(active_instance, "vkGetPhysicalDeviceProperties");
    VkPhysicalDeviceProperties properties;
    get_properties(physical, &properties);
    fprintf(stderr, "META_DEVICE api=%u driver=%u vendor=%u device=%u name=%s\n", properties.apiVersion, properties.driverVersion, properties.vendorID, properties.deviceID, properties.deviceName);
    fprintf(stderr, "META_CACHE_UUID ");
    for (unsigned n = 0; n < VK_UUID_SIZE; n++) fprintf(stderr, "%02x", properties.pipelineCacheUUID[n]);
    fprintf(stderr, "\n");
    for (uint32_t n = 0; n < info->enabledExtensionCount; n++) fprintf(stderr, "META_EXTENSION %s\n", info->ppEnabledExtensionNames[n]);
    if (info->pEnabledFeatures) {
        fprintf(stderr, "META_BASE robustBufferAccess=%u\n", info->pEnabledFeatures->robustBufferAccess);
        fprintf(stderr, "META_BASE fullDrawIndexUint32=%u\n", info->pEnabledFeatures->fullDrawIndexUint32);
        fprintf(stderr, "META_BASE imageCubeArray=%u\n", info->pEnabledFeatures->imageCubeArray);
        fprintf(stderr, "META_BASE independentBlend=%u\n", info->pEnabledFeatures->independentBlend);
        fprintf(stderr, "META_BASE geometryShader=%u\n", info->pEnabledFeatures->geometryShader);
        fprintf(stderr, "META_BASE tessellationShader=%u\n", info->pEnabledFeatures->tessellationShader);
        fprintf(stderr, "META_BASE sampleRateShading=%u\n", info->pEnabledFeatures->sampleRateShading);
        fprintf(stderr, "META_BASE dualSrcBlend=%u\n", info->pEnabledFeatures->dualSrcBlend);
        fprintf(stderr, "META_BASE logicOp=%u\n", info->pEnabledFeatures->logicOp);
        fprintf(stderr, "META_BASE multiDrawIndirect=%u\n", info->pEnabledFeatures->multiDrawIndirect);
        fprintf(stderr, "META_BASE drawIndirectFirstInstance=%u\n", info->pEnabledFeatures->drawIndirectFirstInstance);
        fprintf(stderr, "META_BASE depthClamp=%u\n", info->pEnabledFeatures->depthClamp);
        fprintf(stderr, "META_BASE depthBiasClamp=%u\n", info->pEnabledFeatures->depthBiasClamp);
        fprintf(stderr, "META_BASE fillModeNonSolid=%u\n", info->pEnabledFeatures->fillModeNonSolid);
        fprintf(stderr, "META_BASE depthBounds=%u\n", info->pEnabledFeatures->depthBounds);
        fprintf(stderr, "META_BASE wideLines=%u\n", info->pEnabledFeatures->wideLines);
        fprintf(stderr, "META_BASE largePoints=%u\n", info->pEnabledFeatures->largePoints);
        fprintf(stderr, "META_BASE alphaToOne=%u\n", info->pEnabledFeatures->alphaToOne);
        fprintf(stderr, "META_BASE multiViewport=%u\n", info->pEnabledFeatures->multiViewport);
        fprintf(stderr, "META_BASE samplerAnisotropy=%u\n", info->pEnabledFeatures->samplerAnisotropy);
        fprintf(stderr, "META_BASE textureCompressionETC2=%u\n", info->pEnabledFeatures->textureCompressionETC2);
        fprintf(stderr, "META_BASE textureCompressionASTC_LDR=%u\n", info->pEnabledFeatures->textureCompressionASTC_LDR);
        fprintf(stderr, "META_BASE textureCompressionBC=%u\n", info->pEnabledFeatures->textureCompressionBC);
        fprintf(stderr, "META_BASE occlusionQueryPrecise=%u\n", info->pEnabledFeatures->occlusionQueryPrecise);
        fprintf(stderr, "META_BASE pipelineStatisticsQuery=%u\n", info->pEnabledFeatures->pipelineStatisticsQuery);
        fprintf(stderr, "META_BASE vertexPipelineStoresAndAtomics=%u\n", info->pEnabledFeatures->vertexPipelineStoresAndAtomics);
        fprintf(stderr, "META_BASE fragmentStoresAndAtomics=%u\n", info->pEnabledFeatures->fragmentStoresAndAtomics);
        fprintf(stderr, "META_BASE shaderTessellationAndGeometryPointSize=%u\n", info->pEnabledFeatures->shaderTessellationAndGeometryPointSize);
        fprintf(stderr, "META_BASE shaderImageGatherExtended=%u\n", info->pEnabledFeatures->shaderImageGatherExtended);
        fprintf(stderr, "META_BASE shaderStorageImageExtendedFormats=%u\n", info->pEnabledFeatures->shaderStorageImageExtendedFormats);
        fprintf(stderr, "META_BASE shaderStorageImageMultisample=%u\n", info->pEnabledFeatures->shaderStorageImageMultisample);
        fprintf(stderr, "META_BASE shaderStorageImageReadWithoutFormat=%u\n", info->pEnabledFeatures->shaderStorageImageReadWithoutFormat);
        fprintf(stderr, "META_BASE shaderStorageImageWriteWithoutFormat=%u\n", info->pEnabledFeatures->shaderStorageImageWriteWithoutFormat);
        fprintf(stderr, "META_BASE shaderUniformBufferArrayDynamicIndexing=%u\n", info->pEnabledFeatures->shaderUniformBufferArrayDynamicIndexing);
        fprintf(stderr, "META_BASE shaderSampledImageArrayDynamicIndexing=%u\n", info->pEnabledFeatures->shaderSampledImageArrayDynamicIndexing);
        fprintf(stderr, "META_BASE shaderStorageBufferArrayDynamicIndexing=%u\n", info->pEnabledFeatures->shaderStorageBufferArrayDynamicIndexing);
        fprintf(stderr, "META_BASE shaderStorageImageArrayDynamicIndexing=%u\n", info->pEnabledFeatures->shaderStorageImageArrayDynamicIndexing);
        fprintf(stderr, "META_BASE shaderClipDistance=%u\n", info->pEnabledFeatures->shaderClipDistance);
        fprintf(stderr, "META_BASE shaderCullDistance=%u\n", info->pEnabledFeatures->shaderCullDistance);
        fprintf(stderr, "META_BASE shaderFloat64=%u\n", info->pEnabledFeatures->shaderFloat64);
        fprintf(stderr, "META_BASE shaderInt64=%u\n", info->pEnabledFeatures->shaderInt64);
        fprintf(stderr, "META_BASE shaderInt16=%u\n", info->pEnabledFeatures->shaderInt16);
        fprintf(stderr, "META_BASE shaderResourceResidency=%u\n", info->pEnabledFeatures->shaderResourceResidency);
        fprintf(stderr, "META_BASE shaderResourceMinLod=%u\n", info->pEnabledFeatures->shaderResourceMinLod);
        fprintf(stderr, "META_BASE sparseBinding=%u\n", info->pEnabledFeatures->sparseBinding);
        fprintf(stderr, "META_BASE sparseResidencyBuffer=%u\n", info->pEnabledFeatures->sparseResidencyBuffer);
        fprintf(stderr, "META_BASE sparseResidencyImage2D=%u\n", info->pEnabledFeatures->sparseResidencyImage2D);
        fprintf(stderr, "META_BASE sparseResidencyImage3D=%u\n", info->pEnabledFeatures->sparseResidencyImage3D);
        fprintf(stderr, "META_BASE sparseResidency2Samples=%u\n", info->pEnabledFeatures->sparseResidency2Samples);
        fprintf(stderr, "META_BASE sparseResidency4Samples=%u\n", info->pEnabledFeatures->sparseResidency4Samples);
        fprintf(stderr, "META_BASE sparseResidency8Samples=%u\n", info->pEnabledFeatures->sparseResidency8Samples);
        fprintf(stderr, "META_BASE sparseResidency16Samples=%u\n", info->pEnabledFeatures->sparseResidency16Samples);
        fprintf(stderr, "META_BASE sparseResidencyAliased=%u\n", info->pEnabledFeatures->sparseResidencyAliased);
        fprintf(stderr, "META_BASE variableMultisampleRate=%u\n", info->pEnabledFeatures->variableMultisampleRate);
        fprintf(stderr, "META_BASE inheritedQueries=%u\n", info->pEnabledFeatures->inheritedQueries);
    }
    for (const VkBaseInStructure *node = (const VkBaseInStructure *)info->pNext; node; node = node->pNext) {
        switch (node->sType) {
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_16BIT_STORAGE_FEATURES: {
            const VkPhysicalDevice16BitStorageFeatures *value = (const VkPhysicalDevice16BitStorageFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDevice16BitStorageFeatures.storageBuffer16BitAccess=%u\n", value->storageBuffer16BitAccess);
            fprintf(stderr, "META_FEATURE VkPhysicalDevice16BitStorageFeatures.uniformAndStorageBuffer16BitAccess=%u\n", value->uniformAndStorageBuffer16BitAccess);
            fprintf(stderr, "META_FEATURE VkPhysicalDevice16BitStorageFeatures.storagePushConstant16=%u\n", value->storagePushConstant16);
            fprintf(stderr, "META_FEATURE VkPhysicalDevice16BitStorageFeatures.storageInputOutput16=%u\n", value->storageInputOutput16);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ACCELERATION_STRUCTURE_FEATURES_KHR: {
            const VkPhysicalDeviceAccelerationStructureFeaturesKHR *value = (const VkPhysicalDeviceAccelerationStructureFeaturesKHR *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceAccelerationStructureFeaturesKHR.accelerationStructure=%u\n", value->accelerationStructure);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceAccelerationStructureFeaturesKHR.accelerationStructureCaptureReplay=%u\n", value->accelerationStructureCaptureReplay);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceAccelerationStructureFeaturesKHR.accelerationStructureIndirectBuild=%u\n", value->accelerationStructureIndirectBuild);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceAccelerationStructureFeaturesKHR.accelerationStructureHostCommands=%u\n", value->accelerationStructureHostCommands);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceAccelerationStructureFeaturesKHR.descriptorBindingAccelerationStructureUpdateAfterBind=%u\n", value->descriptorBindingAccelerationStructureUpdateAfterBind);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BUFFER_DEVICE_ADDRESS_FEATURES: {
            const VkPhysicalDeviceBufferDeviceAddressFeatures *value = (const VkPhysicalDeviceBufferDeviceAddressFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceBufferDeviceAddressFeatures.bufferDeviceAddress=%u\n", value->bufferDeviceAddress);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceBufferDeviceAddressFeatures.bufferDeviceAddressCaptureReplay=%u\n", value->bufferDeviceAddressCaptureReplay);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceBufferDeviceAddressFeatures.bufferDeviceAddressMultiDevice=%u\n", value->bufferDeviceAddressMultiDevice);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_MATRIX_FEATURES_KHR: {
            const VkPhysicalDeviceCooperativeMatrixFeaturesKHR *value = (const VkPhysicalDeviceCooperativeMatrixFeaturesKHR *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceCooperativeMatrixFeaturesKHR.cooperativeMatrix=%u\n", value->cooperativeMatrix);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceCooperativeMatrixFeaturesKHR.cooperativeMatrixRobustBufferAccess=%u\n", value->cooperativeMatrixRobustBufferAccess);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_INDEXING_FEATURES: {
            const VkPhysicalDeviceDescriptorIndexingFeatures *value = (const VkPhysicalDeviceDescriptorIndexingFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.shaderInputAttachmentArrayDynamicIndexing=%u\n", value->shaderInputAttachmentArrayDynamicIndexing);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.shaderUniformTexelBufferArrayDynamicIndexing=%u\n", value->shaderUniformTexelBufferArrayDynamicIndexing);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.shaderStorageTexelBufferArrayDynamicIndexing=%u\n", value->shaderStorageTexelBufferArrayDynamicIndexing);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.shaderUniformBufferArrayNonUniformIndexing=%u\n", value->shaderUniformBufferArrayNonUniformIndexing);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.shaderSampledImageArrayNonUniformIndexing=%u\n", value->shaderSampledImageArrayNonUniformIndexing);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.shaderStorageBufferArrayNonUniformIndexing=%u\n", value->shaderStorageBufferArrayNonUniformIndexing);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.shaderStorageImageArrayNonUniformIndexing=%u\n", value->shaderStorageImageArrayNonUniformIndexing);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.shaderInputAttachmentArrayNonUniformIndexing=%u\n", value->shaderInputAttachmentArrayNonUniformIndexing);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.shaderUniformTexelBufferArrayNonUniformIndexing=%u\n", value->shaderUniformTexelBufferArrayNonUniformIndexing);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.shaderStorageTexelBufferArrayNonUniformIndexing=%u\n", value->shaderStorageTexelBufferArrayNonUniformIndexing);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.descriptorBindingUniformBufferUpdateAfterBind=%u\n", value->descriptorBindingUniformBufferUpdateAfterBind);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.descriptorBindingSampledImageUpdateAfterBind=%u\n", value->descriptorBindingSampledImageUpdateAfterBind);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.descriptorBindingStorageImageUpdateAfterBind=%u\n", value->descriptorBindingStorageImageUpdateAfterBind);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.descriptorBindingStorageBufferUpdateAfterBind=%u\n", value->descriptorBindingStorageBufferUpdateAfterBind);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.descriptorBindingUniformTexelBufferUpdateAfterBind=%u\n", value->descriptorBindingUniformTexelBufferUpdateAfterBind);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.descriptorBindingStorageTexelBufferUpdateAfterBind=%u\n", value->descriptorBindingStorageTexelBufferUpdateAfterBind);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.descriptorBindingUpdateUnusedWhilePending=%u\n", value->descriptorBindingUpdateUnusedWhilePending);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.descriptorBindingPartiallyBound=%u\n", value->descriptorBindingPartiallyBound);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.descriptorBindingVariableDescriptorCount=%u\n", value->descriptorBindingVariableDescriptorCount);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceDescriptorIndexingFeatures.runtimeDescriptorArray=%u\n", value->runtimeDescriptorArray);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADER_BARYCENTRIC_FEATURES_KHR: {
            const VkPhysicalDeviceFragmentShaderBarycentricFeaturesKHR *value = (const VkPhysicalDeviceFragmentShaderBarycentricFeaturesKHR *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceFragmentShaderBarycentricFeaturesKHR.fragmentShaderBarycentric=%u\n", value->fragmentShaderBarycentric);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_ROBUSTNESS_FEATURES: {
            const VkPhysicalDeviceImageRobustnessFeatures *value = (const VkPhysicalDeviceImageRobustnessFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceImageRobustnessFeatures.robustImageAccess=%u\n", value->robustImageAccess);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_4_FEATURES: {
            const VkPhysicalDeviceMaintenance4Features *value = (const VkPhysicalDeviceMaintenance4Features *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceMaintenance4Features.maintenance4=%u\n", value->maintenance4);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_FEATURES_EXT: {
            const VkPhysicalDeviceMeshShaderFeaturesEXT *value = (const VkPhysicalDeviceMeshShaderFeaturesEXT *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceMeshShaderFeaturesEXT.taskShader=%u\n", value->taskShader);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceMeshShaderFeaturesEXT.meshShader=%u\n", value->meshShader);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceMeshShaderFeaturesEXT.multiviewMeshShader=%u\n", value->multiviewMeshShader);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceMeshShaderFeaturesEXT.primitiveFragmentShadingRateMeshShader=%u\n", value->primitiveFragmentShadingRateMeshShader);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceMeshShaderFeaturesEXT.meshShaderQueries=%u\n", value->meshShaderQueries);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_FEATURES: {
            const VkPhysicalDeviceMultiviewFeatures *value = (const VkPhysicalDeviceMultiviewFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceMultiviewFeatures.multiview=%u\n", value->multiview);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceMultiviewFeatures.multiviewGeometryShader=%u\n", value->multiviewGeometryShader);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceMultiviewFeatures.multiviewTessellationShader=%u\n", value->multiviewTessellationShader);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PORTABILITY_SUBSET_FEATURES_KHR: {
            const VkPhysicalDevicePortabilitySubsetFeaturesKHR *value = (const VkPhysicalDevicePortabilitySubsetFeaturesKHR *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.constantAlphaColorBlendFactors=%u\n", value->constantAlphaColorBlendFactors);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.events=%u\n", value->events);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.imageViewFormatReinterpretation=%u\n", value->imageViewFormatReinterpretation);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.imageViewFormatSwizzle=%u\n", value->imageViewFormatSwizzle);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.imageView2DOn3DImage=%u\n", value->imageView2DOn3DImage);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.multisampleArrayImage=%u\n", value->multisampleArrayImage);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.mutableComparisonSamplers=%u\n", value->mutableComparisonSamplers);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.pointPolygons=%u\n", value->pointPolygons);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.samplerMipLodBias=%u\n", value->samplerMipLodBias);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.separateStencilMaskRef=%u\n", value->separateStencilMaskRef);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.shaderSampleRateInterpolationFunctions=%u\n", value->shaderSampleRateInterpolationFunctions);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.tessellationIsolines=%u\n", value->tessellationIsolines);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.tessellationPointMode=%u\n", value->tessellationPointMode);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.triangleFans=%u\n", value->triangleFans);
            fprintf(stderr, "META_FEATURE VkPhysicalDevicePortabilitySubsetFeaturesKHR.vertexAttributeAccessBeyondStride=%u\n", value->vertexAttributeAccessBeyondStride);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_QUERY_FEATURES_KHR: {
            const VkPhysicalDeviceRayQueryFeaturesKHR *value = (const VkPhysicalDeviceRayQueryFeaturesKHR *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceRayQueryFeaturesKHR.rayQuery=%u\n", value->rayQuery);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_PIPELINE_FEATURES_KHR: {
            const VkPhysicalDeviceRayTracingPipelineFeaturesKHR *value = (const VkPhysicalDeviceRayTracingPipelineFeaturesKHR *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceRayTracingPipelineFeaturesKHR.rayTracingPipeline=%u\n", value->rayTracingPipeline);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceRayTracingPipelineFeaturesKHR.rayTracingPipelineShaderGroupHandleCaptureReplay=%u\n", value->rayTracingPipelineShaderGroupHandleCaptureReplay);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceRayTracingPipelineFeaturesKHR.rayTracingPipelineShaderGroupHandleCaptureReplayMixed=%u\n", value->rayTracingPipelineShaderGroupHandleCaptureReplayMixed);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceRayTracingPipelineFeaturesKHR.rayTracingPipelineTraceRaysIndirect=%u\n", value->rayTracingPipelineTraceRaysIndirect);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceRayTracingPipelineFeaturesKHR.rayTraversalPrimitiveCulling=%u\n", value->rayTraversalPrimitiveCulling);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_POSITION_FETCH_FEATURES_KHR: {
            const VkPhysicalDeviceRayTracingPositionFetchFeaturesKHR *value = (const VkPhysicalDeviceRayTracingPositionFetchFeaturesKHR *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceRayTracingPositionFetchFeaturesKHR.rayTracingPositionFetch=%u\n", value->rayTracingPositionFetch);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ROBUSTNESS_2_FEATURES_KHR: {
            const VkPhysicalDeviceRobustness2FeaturesKHR *value = (const VkPhysicalDeviceRobustness2FeaturesKHR *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceRobustness2FeaturesKHR.robustBufferAccess2=%u\n", value->robustBufferAccess2);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceRobustness2FeaturesKHR.robustImageAccess2=%u\n", value->robustImageAccess2);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceRobustness2FeaturesKHR.nullDescriptor=%u\n", value->nullDescriptor);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_YCBCR_CONVERSION_FEATURES: {
            const VkPhysicalDeviceSamplerYcbcrConversionFeatures *value = (const VkPhysicalDeviceSamplerYcbcrConversionFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceSamplerYcbcrConversionFeatures.samplerYcbcrConversion=%u\n", value->samplerYcbcrConversion);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_FLOAT_FEATURES_EXT: {
            const VkPhysicalDeviceShaderAtomicFloatFeaturesEXT *value = (const VkPhysicalDeviceShaderAtomicFloatFeaturesEXT *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.shaderBufferFloat32Atomics=%u\n", value->shaderBufferFloat32Atomics);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.shaderBufferFloat32AtomicAdd=%u\n", value->shaderBufferFloat32AtomicAdd);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.shaderBufferFloat64Atomics=%u\n", value->shaderBufferFloat64Atomics);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.shaderBufferFloat64AtomicAdd=%u\n", value->shaderBufferFloat64AtomicAdd);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.shaderSharedFloat32Atomics=%u\n", value->shaderSharedFloat32Atomics);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.shaderSharedFloat32AtomicAdd=%u\n", value->shaderSharedFloat32AtomicAdd);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.shaderSharedFloat64Atomics=%u\n", value->shaderSharedFloat64Atomics);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.shaderSharedFloat64AtomicAdd=%u\n", value->shaderSharedFloat64AtomicAdd);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.shaderImageFloat32Atomics=%u\n", value->shaderImageFloat32Atomics);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.shaderImageFloat32AtomicAdd=%u\n", value->shaderImageFloat32AtomicAdd);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.sparseImageFloat32Atomics=%u\n", value->sparseImageFloat32Atomics);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicFloatFeaturesEXT.sparseImageFloat32AtomicAdd=%u\n", value->sparseImageFloat32AtomicAdd);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_INT64_FEATURES: {
            const VkPhysicalDeviceShaderAtomicInt64Features *value = (const VkPhysicalDeviceShaderAtomicInt64Features *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicInt64Features.shaderBufferInt64Atomics=%u\n", value->shaderBufferInt64Atomics);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderAtomicInt64Features.shaderSharedInt64Atomics=%u\n", value->shaderSharedInt64Atomics);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_DRAW_PARAMETERS_FEATURES: {
            const VkPhysicalDeviceShaderDrawParametersFeatures *value = (const VkPhysicalDeviceShaderDrawParametersFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderDrawParametersFeatures.shaderDrawParameters=%u\n", value->shaderDrawParameters);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_FLOAT16_INT8_FEATURES: {
            const VkPhysicalDeviceShaderFloat16Int8Features *value = (const VkPhysicalDeviceShaderFloat16Int8Features *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderFloat16Int8Features.shaderFloat16=%u\n", value->shaderFloat16);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderFloat16Int8Features.shaderInt8=%u\n", value->shaderInt8);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_IMAGE_ATOMIC_INT64_FEATURES_EXT: {
            const VkPhysicalDeviceShaderImageAtomicInt64FeaturesEXT *value = (const VkPhysicalDeviceShaderImageAtomicInt64FeaturesEXT *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderImageAtomicInt64FeaturesEXT.shaderImageInt64Atomics=%u\n", value->shaderImageInt64Atomics);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderImageAtomicInt64FeaturesEXT.sparseImageInt64Atomics=%u\n", value->sparseImageInt64Atomics);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_INTEGER_DOT_PRODUCT_FEATURES: {
            const VkPhysicalDeviceShaderIntegerDotProductFeatures *value = (const VkPhysicalDeviceShaderIntegerDotProductFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceShaderIntegerDotProductFeatures.shaderIntegerDotProduct=%u\n", value->shaderIntegerDotProduct);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBGROUP_SIZE_CONTROL_FEATURES: {
            const VkPhysicalDeviceSubgroupSizeControlFeatures *value = (const VkPhysicalDeviceSubgroupSizeControlFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceSubgroupSizeControlFeatures.subgroupSizeControl=%u\n", value->subgroupSizeControl);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceSubgroupSizeControlFeatures.computeFullSubgroups=%u\n", value->computeFullSubgroups);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TEXTURE_COMPRESSION_ASTC_HDR_FEATURES: {
            const VkPhysicalDeviceTextureCompressionASTCHDRFeatures *value = (const VkPhysicalDeviceTextureCompressionASTCHDRFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceTextureCompressionASTCHDRFeatures.textureCompressionASTC_HDR=%u\n", value->textureCompressionASTC_HDR);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TIMELINE_SEMAPHORE_FEATURES: {
            const VkPhysicalDeviceTimelineSemaphoreFeatures *value = (const VkPhysicalDeviceTimelineSemaphoreFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceTimelineSemaphoreFeatures.timelineSemaphore=%u\n", value->timelineSemaphore);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_MEMORY_MODEL_FEATURES: {
            const VkPhysicalDeviceVulkanMemoryModelFeatures *value = (const VkPhysicalDeviceVulkanMemoryModelFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceVulkanMemoryModelFeatures.vulkanMemoryModel=%u\n", value->vulkanMemoryModel);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceVulkanMemoryModelFeatures.vulkanMemoryModelDeviceScope=%u\n", value->vulkanMemoryModelDeviceScope);
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceVulkanMemoryModelFeatures.vulkanMemoryModelAvailabilityVisibilityChains=%u\n", value->vulkanMemoryModelAvailabilityVisibilityChains);
            break;
        }
        case VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ZERO_INITIALIZE_WORKGROUP_MEMORY_FEATURES: {
            const VkPhysicalDeviceZeroInitializeWorkgroupMemoryFeatures *value = (const VkPhysicalDeviceZeroInitializeWorkgroupMemoryFeatures *)node;
            fprintf(stderr, "META_FEATURE VkPhysicalDeviceZeroInitializeWorkgroupMemoryFeatures.shaderZeroInitializeWorkgroupMemory=%u\n", value->shaderZeroInitializeWorkgroupMemory);
            break;
        }
        case VK_STRUCTURE_TYPE_LOADER_DEVICE_CREATE_INFO: break;
        default: fprintf(stderr, "META_OTHER_STYPE %u\n", node->sType); break;
        }
    }
}

static PFN_vkGetDeviceProcAddr next_device;
static PFN_vkCreateShaderModule create_module;
static PFN_vkDestroyShaderModule destroy_module;
static PFN_vkCreateGraphicsPipelines create_graphics;
static PFN_vkCreateComputePipelines create_compute;
static PFN_vkCreateRayTracingPipelinesKHR create_ray;
static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
static uint64_t created, destroyed, module_calls, graphics, compute, ray, live;
static uint64_t fail_module;
static int fail_pipeline;

// Fixture calls only between phases, after all worker threads have joined.
__attribute__((visibility("default")))
void gpui_shader_probe_phase(const char *name, uint64_t module, int pipeline) {
    pthread_mutex_lock(&lock);
    fprintf(stderr, "PROBE_END created=%lu destroyed=%lu calls=%lu graphics=%lu compute=%lu ray=%lu live=%lu\n",
        created, destroyed, module_calls, graphics, compute, ray, live);
    created = destroyed = module_calls = graphics = compute = ray = 0;
    fail_module = module;
    fail_pipeline = pipeline;
    fprintf(stderr, "PROBE_BEGIN %s fail_module=%lu fail_pipeline=%d live=%lu\n", name, module, pipeline, live);
    pthread_mutex_unlock(&lock);
}

static VkResult VKAPI_CALL probe_create_module(VkDevice device,
    const VkShaderModuleCreateInfo *info, const VkAllocationCallbacks *alloc, VkShaderModule *module) {
    pthread_mutex_lock(&lock);
    uint64_t call = ++module_calls;
    int fail = fail_module && call == fail_module;
    pthread_mutex_unlock(&lock);
    VkResult result = fail ? VK_ERROR_OUT_OF_HOST_MEMORY : create_module(device, info, alloc, module);
    pthread_mutex_lock(&lock);
    if (result == VK_SUCCESS) { created++; live++; }
    fprintf(stderr, "PROBE_MODULE call=%lu bytes=%zu result=%d handle=%p\n", call, info->codeSize,
        result, result == VK_SUCCESS ? (void *)(uintptr_t)*module : NULL);
    pthread_mutex_unlock(&lock);
    return result;
}

static void VKAPI_CALL probe_destroy_module(VkDevice device, VkShaderModule module,
    const VkAllocationCallbacks *alloc) {
    destroy_module(device, module, alloc);
    pthread_mutex_lock(&lock);
    if (module != VK_NULL_HANDLE) { destroyed++; live--; }
    fprintf(stderr, "PROBE_DESTROY handle=%p live=%lu\n", (void *)(uintptr_t)module, live);
    pthread_mutex_unlock(&lock);
}

static VkResult VKAPI_CALL probe_graphics(VkDevice device, VkPipelineCache cache, uint32_t count,
    const VkGraphicsPipelineCreateInfo *info, const VkAllocationCallbacks *alloc, VkPipeline *out) {
    fprintf(stderr, "META_PIPELINE_CACHE graphics=%p\n", (void *)(uintptr_t)cache);
    pthread_mutex_lock(&lock); graphics += count; int fail = fail_pipeline; pthread_mutex_unlock(&lock);
    if (fail) { for (uint32_t n = 0; n < count; n++) out[n] = VK_NULL_HANDLE; return VK_ERROR_OUT_OF_HOST_MEMORY; }
    return create_graphics(device, cache, count, info, alloc, out);
}

static VkResult VKAPI_CALL probe_compute(VkDevice device, VkPipelineCache cache, uint32_t count,
    const VkComputePipelineCreateInfo *info, const VkAllocationCallbacks *alloc, VkPipeline *out) {
    fprintf(stderr, "META_PIPELINE_CACHE compute=%p\n", (void *)(uintptr_t)cache);
    pthread_mutex_lock(&lock); compute += count; int fail = fail_pipeline; pthread_mutex_unlock(&lock);
    if (fail) { for (uint32_t n = 0; n < count; n++) out[n] = VK_NULL_HANDLE; return VK_ERROR_OUT_OF_HOST_MEMORY; }
    return create_compute(device, cache, count, info, alloc, out);
}

static VkResult VKAPI_CALL probe_ray(VkDevice device, VkDeferredOperationKHR operation,
    VkPipelineCache cache, uint32_t count, const VkRayTracingPipelineCreateInfoKHR *info,
    const VkAllocationCallbacks *alloc, VkPipeline *out) {
    pthread_mutex_lock(&lock); ray += count; int fail = fail_pipeline; pthread_mutex_unlock(&lock);
    if (fail) { for (uint32_t n = 0; n < count; n++) out[n] = VK_NULL_HANDLE; return VK_ERROR_OUT_OF_HOST_MEMORY; }
    return create_ray(device, operation, cache, count, info, alloc, out);
}

static VkResult VKAPI_CALL probe_create_instance(const VkInstanceCreateInfo *info,
    const VkAllocationCallbacks *alloc, VkInstance *instance) {
    fprintf(stderr, "META_INSTANCE api=%u\n", info->pApplicationInfo ? info->pApplicationInfo->apiVersion : 0);
    VkLayerInstanceCreateInfo *chain = (VkLayerInstanceCreateInfo *)info->pNext;
    while (chain && (chain->sType != VK_STRUCTURE_TYPE_LOADER_INSTANCE_CREATE_INFO || chain->function != VK_LAYER_LINK_INFO))
        chain = (VkLayerInstanceCreateInfo *)chain->pNext;
    if (!chain) return VK_ERROR_INITIALIZATION_FAILED;
    next_instance = chain->u.pLayerInfo->pfnNextGetInstanceProcAddr;
    PFN_vkCreateInstance next = (PFN_vkCreateInstance)next_instance(VK_NULL_HANDLE, "vkCreateInstance");
    chain->u.pLayerInfo = chain->u.pLayerInfo->pNext;
    VkResult result = next(info, alloc, instance);
    if (result == VK_SUCCESS) active_instance = *instance;
    return result;
}

static VkResult VKAPI_CALL probe_create_device(VkPhysicalDevice physical, const VkDeviceCreateInfo *info,
    const VkAllocationCallbacks *alloc, VkDevice *device) {
    metadata_device(physical, info);
    VkLayerDeviceCreateInfo *chain = (VkLayerDeviceCreateInfo *)info->pNext;
    while (chain && (chain->sType != VK_STRUCTURE_TYPE_LOADER_DEVICE_CREATE_INFO || chain->function != VK_LAYER_LINK_INFO))
        chain = (VkLayerDeviceCreateInfo *)chain->pNext;
    if (!chain) return VK_ERROR_INITIALIZATION_FAILED;
    PFN_vkGetInstanceProcAddr instance_fn = chain->u.pLayerInfo->pfnNextGetInstanceProcAddr;
    next_device = chain->u.pLayerInfo->pfnNextGetDeviceProcAddr;
    PFN_vkCreateDevice next = (PFN_vkCreateDevice)instance_fn(active_instance, "vkCreateDevice");
    chain->u.pLayerInfo = chain->u.pLayerInfo->pNext;
    VkResult result = next(physical, info, alloc, device);
    if (result != VK_SUCCESS) return result;
    create_module = (PFN_vkCreateShaderModule)next_device(*device, "vkCreateShaderModule");
    destroy_module = (PFN_vkDestroyShaderModule)next_device(*device, "vkDestroyShaderModule");
    create_graphics = (PFN_vkCreateGraphicsPipelines)next_device(*device, "vkCreateGraphicsPipelines");
    create_compute = (PFN_vkCreateComputePipelines)next_device(*device, "vkCreateComputePipelines");
    create_ray = (PFN_vkCreateRayTracingPipelinesKHR)next_device(*device, "vkCreateRayTracingPipelinesKHR");
    return result;
}

static PFN_vkVoidFunction VKAPI_CALL probe_get_device(VkDevice device, const char *name) {
    if (!strcmp(name, "vkGetDeviceProcAddr")) return (PFN_vkVoidFunction)probe_get_device;
    if (!strcmp(name, "vkCreateShaderModule")) return (PFN_vkVoidFunction)probe_create_module;
    if (!strcmp(name, "vkDestroyShaderModule")) return (PFN_vkVoidFunction)probe_destroy_module;
    if (!strcmp(name, "vkCreateGraphicsPipelines")) return (PFN_vkVoidFunction)probe_graphics;
    if (!strcmp(name, "vkCreateComputePipelines")) return (PFN_vkVoidFunction)probe_compute;
    if (!strcmp(name, "vkCreateRayTracingPipelinesKHR") && create_ray) return (PFN_vkVoidFunction)probe_ray;
    return next_device(device, name);
}

static PFN_vkVoidFunction VKAPI_CALL probe_get_instance(VkInstance instance, const char *name) {
    if (!strcmp(name, "vkGetInstanceProcAddr")) return (PFN_vkVoidFunction)probe_get_instance;
    if (!strcmp(name, "vkGetDeviceProcAddr")) return (PFN_vkVoidFunction)probe_get_device;
    if (!strcmp(name, "vkCreateInstance")) return (PFN_vkVoidFunction)probe_create_instance;
    if (!strcmp(name, "vkCreateDevice")) return (PFN_vkVoidFunction)probe_create_device;
    return next_instance(instance, name);
}

VKAPI_ATTR VkResult VKAPI_CALL vkNegotiateLoaderLayerInterfaceVersion(VkNegotiateLayerInterface *version) {
    if (version->loaderLayerInterfaceVersion > 2) version->loaderLayerInterfaceVersion = 2;
    version->pfnGetInstanceProcAddr = probe_get_instance;
    version->pfnGetDeviceProcAddr = probe_get_device;
    version->pfnGetPhysicalDeviceProcAddr = NULL;
    return VK_SUCCESS;
}
