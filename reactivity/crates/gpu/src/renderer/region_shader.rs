//! Integer repair bounds select coverage; the ordinary fragment stays unchanged.
#[wgsl_rs::wgsl]
pub mod region {
    use wgsl_rs::std::*;

    #[derive(Clone, Copy, Wgsl)]
    pub struct VertexInput {
        #[builtin(vertex_index)]
        pub index: u32,
        #[location(0)]
        pub edges: Vec4f,
    }

    #[vertex]
    pub fn vertex(input: VertexInput) -> Vec4f {
        const CORNERS: [Vec2u; 6] = [
            vec2u(0, 0),
            vec2u(1, 0),
            vec2u(0, 1),
            vec2u(0, 1),
            vec2u(1, 0),
            vec2u(1, 1),
        ];
        let corner = CORNERS[input.index as usize];
        let edges = input.edges;
        vec4f(
            select(edges.x, edges.z, corner.x != 0),
            select(edges.y, edges.w, corner.y != 0),
            0.0,
            1.0,
        )
    }
}
