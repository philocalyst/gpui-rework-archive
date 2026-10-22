"""Read actual Vulkan device creation parameters with a test-only layer variant."""
from pathlib import Path
import hashlib,json,re,shlex,subprocess,xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parents[4];WORK=ROOT/'reactivity';OUT=WORK/'evidence/static-shader';CHECKS=OUT/'checks'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
snapshot=json.loads((CHECKS/'source.json').read_text())
def guard():assert {p:sha(ROOT/p) for p in snapshot['files']}==snapshot['files']
guard()
headers=Path('/nix/store/y5cj46l7dvhhz63rwgqd71h723i3q8c0-vulkan-headers-1.4.341.0');registry=headers/'share/vulkan/registry/vk.xml'
xml=ET.parse(registry).getroot();types={t.get('name') or t.findtext('name'):t for t in xml.find('types')}
def resolve(name):
 while types[name].get('alias'):name=types[name].get('alias')
 return name,types[name]
adapter=(WORK/'vendor/wgpu-hal/src/vulkan/adapter.rs').read_text()
names=sorted(set('Vk'+name for name in re.findall(r'vk::(PhysicalDevice\w*Features\w*)<',adapter)))
base=types['VkPhysicalDeviceFeatures']
base_lines=['    if (info->pEnabledFeatures) {']
for member in base.findall('member'):
 if member.findtext('type')=='VkBool32':
  field=member.findtext('name');base_lines.append(f'        fprintf(stderr, "META_BASE {field}=%u\\n", info->pEnabledFeatures->{field});')
base_lines.append('    }')
cases=[];seen=set()
for name in names:
 canonical,node=resolve(name);members=node.findall('member');stype=members[0].get('values')
 if not stype or stype in seen:continue
 seen.add(stype)
 fields=[m.findtext('name') for m in members if m.findtext('type')=='VkBool32']
 if not fields:continue
 cases.append(f'        case {stype}: {{\n            const {canonical} *value = (const {canonical} *)node;')
 for field in fields:cases.append(f'            fprintf(stderr, "META_FEATURE {canonical}.{field}=%u\\n", value->{field});')
 cases.append('            break;\n        }')
helper='''
static void metadata_device(VkPhysicalDevice physical, const VkDeviceCreateInfo *info) {
    PFN_vkGetPhysicalDeviceProperties get_properties = (PFN_vkGetPhysicalDeviceProperties)next_instance(active_instance, "vkGetPhysicalDeviceProperties");
    VkPhysicalDeviceProperties properties;
    get_properties(physical, &properties);
    fprintf(stderr, "META_DEVICE api=%u driver=%u vendor=%u device=%u name=%s\\n", properties.apiVersion, properties.driverVersion, properties.vendorID, properties.deviceID, properties.deviceName);
    fprintf(stderr, "META_CACHE_UUID ");
    for (unsigned n = 0; n < VK_UUID_SIZE; n++) fprintf(stderr, "%02x", properties.pipelineCacheUUID[n]);
    fprintf(stderr, "\\n");
    for (uint32_t n = 0; n < info->enabledExtensionCount; n++) fprintf(stderr, "META_EXTENSION %s\\n", info->ppEnabledExtensionNames[n]);
'''+ '\n'.join(base_lines)+'''
    for (const VkBaseInStructure *node = (const VkBaseInStructure *)info->pNext; node; node = node->pNext) {
        switch (node->sType) {
'''+ '\n'.join(cases)+'''
        case VK_STRUCTURE_TYPE_LOADER_DEVICE_CREATE_INFO: break;
        default: fprintf(stderr, "META_OTHER_STYPE %u\\n", node->sType); break;
        }
    }
}
'''
source=(OUT/'drivers/layer.c').read_text().replace('#include <vulkan/vk_layer.h>', '#define VK_ENABLE_BETA_EXTENSIONS\n#include <vulkan/vk_layer.h>\n#include <vulkan/vulkan_beta.h>').replace('static VkInstance active_instance;','static VkInstance active_instance;\n'+helper)
source=source.replace('''    VkLayerInstanceCreateInfo *chain = (VkLayerInstanceCreateInfo *)info->pNext;''','''    fprintf(stderr, "META_INSTANCE api=%u\\n", info->pApplicationInfo ? info->pApplicationInfo->apiVersion : 0);
    VkLayerInstanceCreateInfo *chain = (VkLayerInstanceCreateInfo *)info->pNext;''')
source=source.replace('''    VkLayerDeviceCreateInfo *chain = (VkLayerDeviceCreateInfo *)info->pNext;''','''    metadata_device(physical, info);
    VkLayerDeviceCreateInfo *chain = (VkLayerDeviceCreateInfo *)info->pNext;''')
source=source.replace('''    pthread_mutex_lock(&lock); graphics += count;''','''    fprintf(stderr, "META_PIPELINE_CACHE graphics=%p\\n", (void *)(uintptr_t)cache);
    pthread_mutex_lock(&lock); graphics += count;''')
source=source.replace('''    pthread_mutex_lock(&lock); compute += count;''','''    fprintf(stderr, "META_PIPELINE_CACHE compute=%p\\n", (void *)(uintptr_t)cache);
    pthread_mutex_lock(&lock); compute += count;''')
path=OUT/'metadata-layer.c';path.write_text(source)
lib=Path('/tmp/gpui-static-metadata-layer.so');manifest_dir=Path('/tmp/gpui-static-metadata-layer');manifest_dir.mkdir(exist_ok=True)
command=['clang','-std=c11','-Wall','-Wextra','-Werror','-shared','-fPIC','-pthread','-I'+str(headers/'include'),str(path),'-o',str(lib)]
with (CHECKS/'metadata-layer-build.log').open('w') as log:r=subprocess.run(['bash','-c','source /tmp/gpui-native-env.sh\nexec '+shlex.join(command)],stdout=log,stderr=subprocess.STDOUT)
assert r.returncode==0
manifest={'file_format_version':'1.2.0','layer':{'name':'VK_LAYER_GPUI_static_probe','type':'GLOBAL','library_path':str(lib),'api_version':'1.4.341','implementation_version':'1','description':'Test-only exact device parameter observer'}}
(manifest_dir/'VkLayer_GPUI_static_probe.json').write_text(json.dumps(manifest,indent=2)+'\n')
results={}
for case,binary in [('static',Path('/tmp/gpui-static-frozen-bins/owners-optional/first')),('raw',Path('/tmp/gpui-offline-shader-controls/bea848dbe4/first-artifact-counts'))]:
 before=sha(binary);guard();logpath=CHECKS/('metadata-'+case+'.log')
 shell='source /tmp/gpui-native-env.sh\nexport MESA_SHADER_CACHE_DISABLE=true VK_LAYER_PATH='+str(manifest_dir)+' VK_INSTANCE_LAYERS=VK_LAYER_GPUI_static_probe\nexec '+shlex.join([str(binary),'context'])
 with logpath.open('w') as log:r=subprocess.run(['bash','-c',shell],stdout=log,stderr=subprocess.STDOUT,cwd=WORK)
 assert r.returncode==0 and sha(binary)==before;guard()
 lines=logpath.read_text().splitlines();metadata=[line for line in lines if line.startswith('META_')]
 assert not any(line.startswith('META_OTHER_STYPE') for line in metadata),metadata
 results[case]={'binary':str(binary),'sha256':before,'exit':r.returncode,'metadata':metadata,'log_sha256':sha(logpath)}
# Enabled device state is identical; instance API and cache UUID are observed,
# not inferred from adapter support. Ignore ordering of independently-built chains.
relevant=lambda row:sorted(line for line in row['metadata'] if not line.startswith('META_PIPELINE_CACHE'))
assert relevant(results['static'])==relevant(results['raw'])
for case,row in results.items():assert all('=(nil)' in line for line in row['metadata'] if line.startswith('META_PIPELINE_CACHE'))
(CHECKS/'metadata-results.json').write_text(json.dumps({'shipping_source':snapshot['source'],'raw_runtime_source':'bea848dbe4cf9901fa7469eca836f92fe267af0b','source_sha256':sha(path),'layer_sha256':sha(lib),'build':command,'registry_sha256':sha(registry),'feature_structs_taken_from_pinned_HAL_adapter_source':names,'cases':results,'enabled_device_state_identical':True,'pipeline_caches':'all null; no cache objects used','measurement_scope':'Additional observation only. Layer is absent from Rust/DHAT captures.'},indent=2)+'\n')
print(json.dumps({'actual_enabled_device_state_identical':True,'source':snapshot['source']}))
