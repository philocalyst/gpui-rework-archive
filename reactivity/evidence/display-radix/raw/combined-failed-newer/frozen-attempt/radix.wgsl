// Bounded COW directory, immutable submitted roots, shared current authority.
@group(0) @binding(0) var<storage, read> heap: array<u32>;
@group(0) @binding(1) var<storage, read> args: array<u32>;
@group(0) @binding(2) var<storage, read> authority: array<u32>;
@group(0) @binding(3) var<storage, read_write> pixels: array<u32>;
@group(0) @binding(4) var<storage, read_write> decoded: array<u32>;
fn entry(directory:u32,key:u32)->vec2<u32> {
    if directory==0u { return vec2<u32>(0u); }
    let leaf=heap[directory/4u+key/32u];
    if leaf==0u {return vec2<u32>(0u);}
    return vec2<u32>(heap[leaf/4u+(key%32u)*2u],heap[leaf/4u+(key%32u)*2u+1u]);
}
fn field(slot:u32,col:u32)->u32 {
    let root=args[0]/4u;var e=vec2<u32>(heap[root],heap[root+9u]);
    if heap[root+5u]==0u {e=entry(heap[root],slot/32u+select(0u,1u,args[5]==2u));}
    if heap[root+5u]!=0u && slot/32u!=heap[root+4u]/32u {return 0u;}
    let row=slot%32u;
    if args[5]==3u && e.y>0u {e.y-=1u;}
    if e.x==0u || row>=e.y {return 0u;}
    let base=e.x/4u;
    if heap[base]==0u {return heap[base+1u+row*12u+col];}
    let h=base+1u+col*3u;let origin=heap[h];let bits=heap[h+1u];
    if bits==0u {return origin;}
    let bit=row*bits;let start=base+heap[h+2u]+bit/32u;let shift=bit%32u;
    var value=heap[start]>>shift;
    if shift+bits>32u {value|=heap[start+1u]<<(32u-shift);}
    if bits<32u {value&=(1u<<bits)-1u;}
    return origin+value;
}
@compute @workgroup_size(64)
fn audit(@builtin(global_invocation_id) tid:vec3<u32>){
    let i=tid.x;let root=args[0]/4u;let record_words=heap[root+3u]*12u;
    if i<record_words {decoded[i]=field(i/12u,i%12u);return;}
    // Explicit audit list is diagnostic, never used by publication/rendering.
    var offset=i-record_words;
    for(var j=0u;j<args[6];j++){
        let key=args[7u+j*2u];let length=args[8u+j*2u];
        if offset<length {let e=entry(heap[root+1u],key);decoded[i]=(heap[(e.x+offset)/4u]>>(((e.x+offset)%4u)*8u))&255u;return;}
        offset-=length;
    }
}
// Exact admitted opaque endpoint RGB, 1:1 integer geometry, Linear sampling.
// 16 subpixel samples * 4 bilinear texel loads; denominator1024. Unsupported
// alpha/arbitrary color/scaling is rejected by fixture admission, not approximated.
const SRGB:array<u32,1025>=array<u32,1025>(
0u,3u,6u,10u,13u,15u,18u,20u,22u,23u,25u,27u,28u,30u,31u,32u,34u,35u,36u,37u,38u,39u,40u,41u,42u,43u,44u,45u,46u,47u,48u,49u,49u,50u,51u,52u,53u,53u,54u,55u,56u,56u,57u,58u,58u,59u,60u,60u,61u,62u,62u,63u,64u,64u,65u,66u,66u,67u,67u,68u,68u,69u,70u,70u,71u,71u,72u,72u,73u,73u,74u,74u,75u,75u,76u,77u,77u,77u,78u,78u,79u,79u,80u,80u,81u,81u,82u,82u,83u,83u,84u,84u,85u,85u,85u,86u,86u,87u,87u,88u,88u,88u,89u,89u,90u,90u,91u,91u,91u,92u,92u,93u,93u,93u,94u,94u,95u,95u,95u,96u,96u,96u,97u,97u,98u,98u,98u,99u,99u,99u,100u,100u,101u,101u,101u,102u,102u,102u,103u,103u,103u,104u,104u,104u,105u,105u,105u,106u,106u,106u,107u,107u,107u,108u,108u,108u,109u,109u,109u,110u,110u,110u,111u,111u,111u,112u,112u,112u,113u,113u,113u,114u,114u,114u,115u,115u,115u,115u,116u,116u,116u,117u,117u,117u,118u,118u,118u,118u,119u,119u,119u,120u,120u,120u,120u,121u,121u,121u,122u,122u,122u,122u,123u,123u,123u,124u,124u,124u,124u,125u,125u,125u,126u,126u,126u,126u,127u,127u,127u,127u,128u,128u,128u,129u,129u,129u,129u,130u,130u,130u,130u,131u,131u,131u,131u,132u,132u,132u,132u,133u,133u,133u,133u,134u,134u,134u,134u,135u,135u,135u,135u,136u,136u,136u,136u,137u,137u,137u,137u,138u,138u,138u,138u,139u,139u,139u,139u,140u,140u,140u,140u,141u,141u,141u,141u,142u,142u,142u,142u,142u,143u,143u,143u,143u,144u,144u,144u,144u,145u,145u,145u,145u,145u,146u,146u,146u,146u,147u,147u,147u,147u,147u,148u,148u,148u,148u,149u,149u,149u,149u,149u,150u,150u,150u,150u,151u,151u,151u,151u,151u,152u,152u,152u,152u,153u,153u,153u,153u,153u,154u,154u,154u,154u,154u,155u,155u,155u,155u,155u,156u,156u,156u,156u,157u,157u,157u,157u,157u,158u,158u,158u,158u,158u,159u,159u,159u,159u,159u,160u,160u,160u,160u,160u,161u,161u,161u,161u,161u,162u,162u,162u,162u,162u,163u,163u,163u,163u,163u,164u,164u,164u,164u,164u,165u,165u,165u,165u,165u,166u,166u,166u,166u,166u,166u,167u,167u,167u,167u,167u,168u,168u,168u,168u,168u,169u,169u,169u,169u,169u,170u,170u,170u,170u,170u,170u,171u,171u,171u,171u,171u,172u,172u,172u,172u,172u,172u,173u,173u,173u,173u,173u,174u,174u,174u,174u,174u,174u,175u,175u,175u,175u,175u,176u,176u,176u,176u,176u,176u,177u,177u,177u,177u,177u,177u,178u,178u,178u,178u,178u,179u,179u,179u,179u,179u,179u,180u,180u,180u,180u,180u,180u,181u,181u,181u,181u,181u,181u,182u,182u,182u,182u,182u,183u,183u,183u,183u,183u,183u,184u,184u,184u,184u,184u,184u,185u,185u,185u,185u,185u,185u,186u,186u,186u,186u,186u,186u,187u,187u,187u,187u,187u,187u,188u,188u,188u,188u,188u,188u,188u,189u,189u,189u,189u,189u,189u,190u,190u,190u,190u,190u,190u,191u,191u,191u,191u,191u,191u,192u,192u,192u,192u,192u,192u,193u,193u,193u,193u,193u,193u,193u,194u,194u,194u,194u,194u,194u,195u,195u,195u,195u,195u,195u,195u,196u,196u,196u,196u,196u,196u,197u,197u,197u,197u,197u,197u,198u,198u,198u,198u,198u,198u,198u,199u,199u,199u,199u,199u,199u,199u,200u,200u,200u,200u,200u,200u,201u,201u,201u,201u,201u,201u,201u,202u,202u,202u,202u,202u,202u,202u,203u,203u,203u,203u,203u,203u,204u,204u,204u,204u,204u,204u,204u,205u,205u,205u,205u,205u,205u,205u,206u,206u,206u,206u,206u,206u,206u,207u,207u,207u,207u,207u,207u,207u,208u,208u,208u,208u,208u,208u,208u,209u,209u,209u,209u,209u,209u,209u,210u,210u,210u,210u,210u,210u,210u,211u,211u,211u,211u,211u,211u,211u,212u,212u,212u,212u,212u,212u,212u,213u,213u,213u,213u,213u,213u,213u,214u,214u,214u,214u,214u,214u,214u,214u,215u,215u,215u,215u,215u,215u,215u,216u,216u,216u,216u,216u,216u,216u,217u,217u,217u,217u,217u,217u,217u,217u,218u,218u,218u,218u,218u,218u,218u,219u,219u,219u,219u,219u,219u,219u,219u,220u,220u,220u,220u,220u,220u,220u,221u,221u,221u,221u,221u,221u,221u,221u,222u,222u,222u,222u,222u,222u,222u,223u,223u,223u,223u,223u,223u,223u,223u,224u,224u,224u,224u,224u,224u,224u,224u,225u,225u,225u,225u,225u,225u,225u,226u,226u,226u,226u,226u,226u,226u,226u,227u,227u,227u,227u,227u,227u,227u,227u,228u,228u,228u,228u,228u,228u,228u,228u,229u,229u,229u,229u,229u,229u,229u,229u,230u,230u,230u,230u,230u,230u,230u,230u,231u,231u,231u,231u,231u,231u,231u,231u,232u,232u,232u,232u,232u,232u,232u,232u,233u,233u,233u,233u,233u,233u,233u,233u,234u,234u,234u,234u,234u,234u,234u,234u,235u,235u,235u,235u,235u,235u,235u,235u,236u,236u,236u,236u,236u,236u,236u,236u,236u,237u,237u,237u,237u,237u,237u,237u,237u,238u,238u,238u,238u,238u,238u,238u,238u,239u,239u,239u,239u,239u,239u,239u,239u,239u,240u,240u,240u,240u,240u,240u,240u,240u,241u,241u,241u,241u,241u,241u,241u,241u,242u,242u,242u,242u,242u,242u,242u,242u,242u,243u,243u,243u,243u,243u,243u,243u,243u,243u,244u,244u,244u,244u,244u,244u,244u,244u,245u,245u,245u,245u,245u,245u,245u,245u,245u,246u,246u,246u,246u,246u,246u,246u,246u,246u,247u,247u,247u,247u,247u,247u,247u,247u,248u,248u,248u,248u,248u,248u,248u,248u,248u,249u,249u,249u,249u,249u,249u,249u,249u,249u,250u,250u,250u,250u,250u,250u,250u,250u,250u,251u,251u,251u,251u,251u,251u,251u,251u,251u,252u,252u,252u,252u,252u,252u,252u,252u,252u,253u,253u,253u,253u,253u,253u,253u,253u,253u,254u,254u,254u,254u,254u,254u,254u,254u,254u,255u,255u,255u,255u,255u);
fn image_color(base:u32,rx:u32,ry:u32)->u32 {
    var total=vec3<u32>(0u);let width=heap[base];let height=heap[base+1u];
    for(var sy=0u;sy<4u;sy++) {for(var sx=0u;sx<4u;sx++) {
        let left=i32(rx)-select(0,1,sx<2u);let top=i32(ry)-select(0,1,sy<2u);
        let fx=(sx*2u+5u)%8u;let fy=(sy*2u+5u)%8u;
        for(var dy=0u;dy<2u;dy++){for(var dx=0u;dx<2u;dx++){
            let x=u32(clamp(left+i32(dx),0,i32(width)-1));let y=u32(clamp(top+i32(dy),0,i32(height)-1));
            let texel=heap[base+2u+y*width+x];let weight=select(8u-fx,fx,dx==1u)*select(8u-fy,fy,dy==1u);
            total+=vec3<u32>((texel&255u)/255u,((texel>>8u)&255u)/255u,((texel>>16u)&255u)/255u)*weight;
        }}
    }}
    return SRGB[total.x]|(SRGB[total.y]<<8u)|(SRGB[total.z]<<16u)|0xff000000u;
}
@compute @workgroup_size(64)
fn render(@builtin(global_invocation_id) tid:vec3<u32>){
    let i=tid.x;let root=args[0]/4u;
    if i>=4096u {return;}
    if args[5]!=1u && (heap[root+6u]!=authority[0] || heap[root+7u]!=authority[1]) {return;}
    let x=i%64u;let y=i/64u;
    if x<args[1]||y<args[2]||x>=args[3]||y>=args[4] {return;}
    var color=heap[root+8u];var slot=heap[root+4u];
    for(var n=0u;n<heap[root+2u];n++){
        let live=field(slot,10u);
        if live!=0u && x>=field(slot,5u)&&y>=field(slot,6u)&&x<field(slot,7u)&&y<field(slot,8u){
            if (live&2u)!=0u {
                let e=entry(heap[root+1u],field(slot,11u));let base=e.x/4u;
                let rx=x-field(slot,5u);let ry=y-field(slot,6u);
                color=image_color(base,rx,ry);
            }else{let paint=field(slot,9u);if (paint>>24u)==255u {color=paint;}}
        }
        slot=field(slot,3u);
    }
    pixels[i]=color;
}
