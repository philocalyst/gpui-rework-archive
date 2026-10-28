# Read-only Vulkan 1.0 loader query; not part of either GUI or any timed process.
import ctypes as C,json
class InstanceCreateInfo(C.Structure):
 _fields_=[('sType',C.c_uint32),('pNext',C.c_void_p),('flags',C.c_uint32),('pApplicationInfo',C.c_void_p),('enabledLayerCount',C.c_uint32),('ppEnabledLayerNames',C.c_void_p),('enabledExtensionCount',C.c_uint32),('ppEnabledExtensionNames',C.c_void_p)]
class Properties(C.Structure):
 # The standard fixed header; overallocate/aligned storage for limits/sparse tail.
 _fields_=[('apiVersion',C.c_uint32),('driverVersion',C.c_uint32),('vendorID',C.c_uint32),('deviceID',C.c_uint32),('deviceType',C.c_uint32),('deviceName',C.c_char*256),('pipelineCacheUUID',C.c_ubyte*16),('tail',C.c_uint64*1024)]
v=C.CDLL('libvulkan.so.1');v.vkCreateInstance.argtypes=[C.POINTER(InstanceCreateInfo),C.c_void_p,C.POINTER(C.c_void_p)];v.vkCreateInstance.restype=C.c_int32;v.vkDestroyInstance.argtypes=[C.c_void_p,C.c_void_p];v.vkDestroyInstance.restype=None
v.vkEnumeratePhysicalDevices.argtypes=[C.c_void_p,C.POINTER(C.c_uint32),C.POINTER(C.c_void_p)];v.vkEnumeratePhysicalDevices.restype=C.c_int32;v.vkGetPhysicalDeviceProperties.argtypes=[C.c_void_p,C.POINTER(Properties)];v.vkGetPhysicalDeviceProperties.restype=None
instance=C.c_void_p();create=InstanceCreateInfo(sType=1);assert v.vkCreateInstance(C.byref(create),None,C.byref(instance))==0
try:
 count=C.c_uint32();assert v.vkEnumeratePhysicalDevices(instance,C.byref(count),None)==0
 devices=(C.c_void_p*count.value)();assert v.vkEnumeratePhysicalDevices(instance,C.byref(count),devices)==0
 rows=[]
 for d in devices:
  p=Properties();v.vkGetPhysicalDeviceProperties(d,C.byref(p));rows.append({'name':p.deviceName.decode(),'type':p.deviceType,'vendor_id':p.vendorID,'device_id':p.deviceID,'api_version':p.apiVersion,'driver_version':p.driverVersion,'pipeline_cache_uuid':bytes(p.pipelineCacheUUID).hex()})
 assert len(rows)==1 and rows[0]['type']==4 and 'llvmpipe' in rows[0]['name'],rows
 print(json.dumps({'vulkan_physical_devices':rows,'query':'Vulkan 1.0 loader, same VK_ICD_FILENAMES as native observations'},indent=2))
finally:v.vkDestroyInstance(instance,None)
