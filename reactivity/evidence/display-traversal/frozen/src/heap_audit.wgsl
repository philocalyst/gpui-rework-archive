// Read each byte through the immutable root's child offsets. Length metadata is
// explicit per submission; this is a lifetime audit, not a text/image renderer.
@group(0) @binding(0) var<storage, read> heap: array<u32>;
@group(0) @binding(1) var<storage, read> args: array<u32>;
@group(0) @binding(2) var<storage, read_write> output: array<u32>;
@compute @workgroup_size(64)
fn audit(@builtin(global_invocation_id) tid: vec3<u32>) {
    let i=tid.x;
    if i>=args[2] { return; }
    let root=args[0];
    if heap[root]+heap[root+1u]!=args[1] { output[i]=256u; return; }
    var local=i;
    for(var child=0u;child<args[1];child++) {
        let size=args[3u+child];
        if local<size {
            let address=heap[root+2u+child]+local;
            output[i]=(heap[address/4u]>>((address&3u)*8u))&255u;
            return;
        }
        local-=size;
    }
    output[i]=257u;
}
