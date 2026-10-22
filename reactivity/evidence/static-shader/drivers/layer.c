// Test-only single-device Vulkan layer. Never enable for allocator captures.
// VkLayer* ABI is supplied by the pinned Khronos vk_layer.h, not redeclared.
#include <vulkan/vk_layer.h>
#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

static PFN_vkGetInstanceProcAddr next_instance;
static VkInstance active_instance;
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
    pthread_mutex_lock(&lock); graphics += count; int fail = fail_pipeline; pthread_mutex_unlock(&lock);
    if (fail) { for (uint32_t n = 0; n < count; n++) out[n] = VK_NULL_HANDLE; return VK_ERROR_OUT_OF_HOST_MEMORY; }
    return create_graphics(device, cache, count, info, alloc, out);
}

static VkResult VKAPI_CALL probe_compute(VkDevice device, VkPipelineCache cache, uint32_t count,
    const VkComputePipelineCreateInfo *info, const VkAllocationCallbacks *alloc, VkPipeline *out) {
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
