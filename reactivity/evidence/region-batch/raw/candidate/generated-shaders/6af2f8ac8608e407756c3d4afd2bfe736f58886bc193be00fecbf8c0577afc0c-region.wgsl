struct VertexInput {
    @builtin(vertex_index) index: u32,
    @location(0) edges: vec4f
}

@vertex fn vertex(input: VertexInput) -> @builtin(position) vec4f {
    const CORNERS: array<vec2u, 6> = array(vec2u(0u, 0u), vec2u(1u, 0u), vec2u(0u, 1u), vec2u(0u, 1u), vec2u(1u, 0u), vec2u(1u, 1u));
    let corner = CORNERS[u32(input.index)];
    let edges = input.edges;
    return vec4f(select(edges.x, edges.z, (corner.x != 0u)), select(edges.y, edges.w, (corner.y != 0u)), 0.0, 1.0);
}
