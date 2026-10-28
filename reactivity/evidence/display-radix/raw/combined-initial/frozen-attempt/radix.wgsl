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
                color=heap[base+2u+ry*heap[base]+rx];
            }else{let paint=field(slot,9u);if (paint>>24u)==255u {color=paint;}}
        }
        slot=field(slot,3u);
    }
    pixels[i]=color;
}
