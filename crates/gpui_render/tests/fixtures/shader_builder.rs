//! Private fluent shader builder prototype lowered directly to wgsl-rs IR.
//!
//! This fixture has no public shader functions, source modules, macros, or
//! linker. CPU values become occurrence-based uniform slots; cloning a node
//! shares its identity. Locals keep shared expression DAGs shared in WGSL.
//! This probe does not validate non-finite values or device-specific limits.
#![allow(dead_code)]

use std::{
    collections::{HashMap, HashSet},
    ops::{Add, Mul, Sub},
    sync::Arc,
};

use wgsl_rs::ir::{
    BinOp, Block, Expr, Field, FnArg, FnAttrs, Item, ItemFn, ItemStruct, ItemUniform, Lit, Module,
    ReturnType, ReturnTypeAnnotation, ScalarType, Stmt, Type,
};

fn f32_ty() -> Type {
    Type::Scalar(ScalarType::F32)
}

fn vec2_ty() -> Type {
    Type::Vector {
        elements: 2,
        scalar_ty: Some(ScalarType::F32),
    }
}

fn vec4_ty() -> Type {
    Type::Vector {
        elements: 4,
        scalar_ty: Some(ScalarType::F32),
    }
}

fn ident(name: impl Into<String>) -> Expr {
    Expr::Ident(name.into())
}

fn f32_lit(value: f32) -> Expr {
    let mut text = value.to_string();
    if !text.contains('.') && !text.contains('e') && !text.contains('E') {
        text.push_str(".0");
    }
    Expr::Lit(Lit::Float { text })
}

fn u32_lit(value: usize) -> Expr {
    Expr::Lit(Lit::Int {
        digits: value.to_string(),
        suffix: "u32".to_string(),
    })
}

fn field(base: Expr, name: impl Into<String>) -> Expr {
    Expr::FieldAccess {
        base: Box::new(base),
        field: name.into(),
    }
}

fn binary(lhs: Expr, op: BinOp, rhs: Expr) -> Expr {
    fn group_compound(expr: Expr) -> Expr {
        if matches!(expr, Expr::Binary { .. }) {
            Expr::Paren(Box::new(expr))
        } else {
            expr
        }
    }

    Expr::Binary {
        lhs: Box::new(group_compound(lhs)),
        op,
        rhs: Box::new(group_compound(rhs)),
    }
}

fn call(name: &str, params: Vec<Expr>) -> Expr {
    Expr::FnCall {
        path: wgsl_rs::ir::FnPath::Ident(name.to_string()),
        type_args: vec![],
        params,
    }
}

#[derive(Clone)]
pub struct Scalar(Arc<ScalarNode>);

struct ScalarNode {
    kind: ScalarKind,
}

enum ScalarKind {
    /// A CPU value that changes independently of shader source.
    Uniform(f32),
    /// Explicit opt-in to putting a value into WGSL source.
    Constant(f32),
    UvX,
    UvY,
    Add(Scalar, Scalar),
    Sub(Scalar, Scalar),
    Mul(Scalar, Scalar),
    Sin(Scalar),
    Clamp01(Scalar),
}

impl Scalar {
    pub fn uniform(value: f32) -> Self {
        Self(Arc::new(ScalarNode {
            kind: ScalarKind::Uniform(value),
        }))
    }

    pub fn constant(value: f32) -> Self {
        Self(Arc::new(ScalarNode {
            kind: ScalarKind::Constant(value),
        }))
    }

    fn uv_x() -> Self {
        Self(Arc::new(ScalarNode {
            kind: ScalarKind::UvX,
        }))
    }

    fn uv_y() -> Self {
        Self(Arc::new(ScalarNode {
            kind: ScalarKind::UvY,
        }))
    }

    pub fn sin(self) -> Self {
        Self(Arc::new(ScalarNode {
            kind: ScalarKind::Sin(self),
        }))
    }

    fn clamp01(self) -> Self {
        Self(Arc::new(ScalarNode {
            kind: ScalarKind::Clamp01(self),
        }))
    }

    fn add(self, other: impl Into<Scalar>) -> Self {
        Self(Arc::new(ScalarNode {
            kind: ScalarKind::Add(self, other.into()),
        }))
    }

    fn sub(self, other: impl Into<Scalar>) -> Self {
        Self(Arc::new(ScalarNode {
            kind: ScalarKind::Sub(self, other.into()),
        }))
    }

    fn mul(self, other: impl Into<Scalar>) -> Self {
        Self(Arc::new(ScalarNode {
            kind: ScalarKind::Mul(self, other.into()),
        }))
    }
}

impl From<f32> for Scalar {
    fn from(value: f32) -> Self {
        Self::uniform(value)
    }
}

impl Add<Scalar> for Scalar {
    type Output = Scalar;

    fn add(self, rhs: Scalar) -> Self::Output {
        Scalar::add(self, rhs)
    }
}

impl Add<f32> for Scalar {
    type Output = Scalar;

    fn add(self, rhs: f32) -> Self::Output {
        Scalar::add(self, rhs)
    }
}

impl Sub<Scalar> for Scalar {
    type Output = Scalar;

    fn sub(self, rhs: Scalar) -> Self::Output {
        Scalar::sub(self, rhs)
    }
}

impl Sub<f32> for Scalar {
    type Output = Scalar;

    fn sub(self, rhs: f32) -> Self::Output {
        Scalar::sub(self, rhs)
    }
}

impl Sub<Scalar> for f32 {
    type Output = Scalar;

    fn sub(self, rhs: Scalar) -> Self::Output {
        Scalar::uniform(self).sub(rhs)
    }
}

impl Mul<Scalar> for Scalar {
    type Output = Scalar;

    fn mul(self, rhs: Scalar) -> Self::Output {
        Scalar::mul(self, rhs)
    }
}

impl Mul<f32> for Scalar {
    type Output = Scalar;

    fn mul(self, rhs: f32) -> Self::Output {
        Scalar::mul(self, rhs)
    }
}

#[derive(Clone)]
pub struct Coverage(Scalar);

impl From<Scalar> for Coverage {
    fn from(value: Scalar) -> Self {
        Self(value.clamp01())
    }
}

impl From<f32> for Coverage {
    fn from(value: f32) -> Self {
        Self(Scalar::uniform(value).clamp01())
    }
}

#[derive(Clone)]
pub struct Color(Arc<ColorNode>);

struct ColorNode {
    kind: ColorKind,
}

enum ColorKind {
    /// Straight-alpha RGBA host value, premultiplied at construction.
    Uniform([f32; 4]),
    /// Explicit opt-in to embedding a straight-alpha color in WGSL source.
    Constant([f32; 4]),
    /// Per-fragment straight-alpha channels; lowering premultiplies RGB by A.
    Rgba(Scalar, Scalar, Scalar, Scalar),
    /// WGSL mix semantics: the amount is not implicitly clamped.
    Mix(Color, Color, Scalar),
    /// Premultiplied source-over: front + back * (1 - front.a).
    Over(Color, Color),
    Opacity(Color, Coverage),
    Mask(Color, Coverage),
    /// Sample this child with a shifted fragment UV. Each map has a new
    /// expression domain while uniform leaves retain their node identity.
    ShiftX(Color, Scalar),
}

impl Color {
    /// Construct a color whose value is supplied through a uniform slot.
    pub fn uniform(rgba: [f32; 4]) -> Self {
        Self(Arc::new(ColorNode {
            kind: ColorKind::Uniform(premultiply(rgba)),
        }))
    }

    /// Explicit opt-in to embed a straight-alpha color in shader source.
    pub fn constant(rgba: [f32; 4]) -> Self {
        Self(Arc::new(ColorNode {
            kind: ColorKind::Constant(premultiply(rgba)),
        }))
    }

    pub fn rgba(
        red: impl Into<Scalar>,
        green: impl Into<Scalar>,
        blue: impl Into<Scalar>,
        alpha: impl Into<Scalar>,
    ) -> Self {
        let alpha = Coverage::from(alpha.into()).0;
        Self(Arc::new(ColorNode {
            kind: ColorKind::Rgba(red.into(), green.into(), blue.into(), alpha),
        }))
    }

    pub fn mix(self, other: Color, amount: impl Into<Scalar>) -> Self {
        Self(Arc::new(ColorNode {
            kind: ColorKind::Mix(self, other, amount.into()),
        }))
    }

    pub fn over(self, back: Color) -> Self {
        Self(Arc::new(ColorNode {
            kind: ColorKind::Over(self, back),
        }))
    }

    /// Scale all premultiplied channels by a clamped opacity.
    pub fn opacity(self, amount: impl Into<Coverage>) -> Self {
        Self(Arc::new(ColorNode {
            kind: ColorKind::Opacity(self, amount.into()),
        }))
    }

    /// Apply a clamped coverage mask to this subtree.
    pub fn mask(self, amount: impl Into<Coverage>) -> Self {
        Self(Arc::new(ColorNode {
            kind: ColorKind::Mask(self, amount.into()),
        }))
    }

    /// Translate this subtree's sampling coordinate along x.
    pub fn shift_x(self, amount: impl Into<Scalar>) -> Self {
        Self(Arc::new(ColorNode {
            kind: ColorKind::ShiftX(self, amount.into()),
        }))
    }

    pub fn compile(&self) -> CompiledShader {
        self.lower().compile()
    }

    pub fn lower(&self) -> LoweredShader {
        Lowerer::default().lower(self)
    }
}

fn premultiply(mut rgba: [f32; 4]) -> [f32; 4] {
    rgba[3] = rgba[3].clamp(0.0, 1.0);
    rgba[0] *= rgba[3];
    rgba[1] *= rgba[3];
    rgba[2] *= rgba[3];
    rgba
}

pub fn color(rgba: [f32; 4]) -> Color {
    Color::uniform(rgba)
}

pub fn rgba(
    red: impl Into<Scalar>,
    green: impl Into<Scalar>,
    blue: impl Into<Scalar>,
    alpha: impl Into<Scalar>,
) -> Color {
    Color::rgba(red, green, blue, alpha)
}

#[derive(Clone, Copy)]
pub struct Pixel;

pub struct Uv;

impl Pixel {
    pub fn uv(self) -> Uv {
        Uv
    }
}

impl Uv {
    pub fn x(self) -> Scalar {
        Scalar::uv_x()
    }

    pub fn y(self) -> Scalar {
        Scalar::uv_y()
    }
}

/// A reusable shader constructor. Its closure runs on the CPU to build a
/// concrete Color value; it is not captured or transpiled.
pub fn shader(build: impl FnOnce(Pixel) -> Color) -> Color {
    build(Pixel)
}

#[derive(Clone, Debug, Default)]
pub struct LowerStats {
    pub reachable_nodes: usize,
    pub scalar_nodes: usize,
    pub color_nodes: usize,
    /// Reachable node payload bytes only; excludes Arc headers and allocator data.
    pub node_payload_bytes_lower_bound: usize,
    pub emitted_expressions: usize,
    pub expression_cache_hits: usize,
    pub domain_expressions: usize,
    /// Unique parameter nodes, including equal values at separate occurrences.
    pub uniform_values: usize,
    /// 16-byte vec4 storage slots after packing scalar values into lanes.
    pub uniform_slots: usize,
}

pub struct CompiledShader {
    pub module: Module,
    pub source: String,
    /// Uniform bytes as vec4-aligned chunks. Scalar values fill available lanes.
    pub uniforms: Vec<[f32; 4]>,
    pub stats: LowerStats,
}

pub struct LoweredShader {
    pub module: Module,
    /// One vec4 storage slot per 16-byte uniform chunk after scalar packing.
    pub uniforms: Vec<[f32; 4]>,
    pub stats: LowerStats,
}

impl LoweredShader {
    pub fn emit(&self) -> String {
        self.module.wgsl_source()
    }

    pub fn compile(self) -> CompiledShader {
        let source = self.module.wgsl_source();
        CompiledShader {
            module: self.module,
            source,
            uniforms: self.uniforms,
            stats: self.stats,
        }
    }
}

#[derive(Clone, Copy, Debug, Hash, Eq, PartialEq)]
enum ParamKey {
    Scalar(usize),
    Color(usize),
}

#[derive(Clone, Debug, Default, Hash, Eq, PartialEq)]
struct DomainKey(Vec<usize>);

#[derive(Clone, Debug, Hash, Eq, PartialEq)]
struct ExprKey {
    node: usize,
    domain: DomainKey,
}

#[derive(Clone)]
struct Domain {
    key: DomainKey,
    uv: Expr,
}

impl Domain {
    fn root() -> Self {
        Self {
            key: DomainKey::default(),
            uv: field(ident("fragment"), "uv"),
        }
    }
}

#[derive(Default)]
struct Lowerer {
    statements: Vec<Stmt>,
    uniforms: Vec<[f32; 4]>,
    uniform_locations: HashMap<ParamKey, UniformLocation>,
    scalar_slot_lanes: HashMap<usize, usize>,
    active_scalar_slot: Option<usize>,
    scalar_cache: HashMap<ExprKey, Expr>,
    color_cache: HashMap<ExprKey, Expr>,
    domain_cache: HashMap<DomainKey, Expr>,
    seen_nodes: HashSet<ParamKey>,
    next_local: usize,
    stats: LowerStats,
}

#[derive(Clone, Copy)]
struct UniformLocation {
    slot: usize,
    component: Option<usize>,
}

impl Lowerer {
    fn lower(mut self, root: &Color) -> LoweredShader {
        let root_expr = self.lower_color(root, &Domain::root());
        let shape_coverage = call(
            "clamp",
            vec![
                field(ident("fragment"), "coverage"),
                f32_lit(0.0),
                f32_lit(1.0),
            ],
        );
        self.statements.push(Stmt::Expr {
            expr: binary(root_expr, BinOp::Mul, shape_coverage),
            has_semi: false,
        });
        self.stats.reachable_nodes = self.seen_nodes.len();
        self.stats.scalar_nodes = self
            .seen_nodes
            .iter()
            .filter(|node| matches!(node, ParamKey::Scalar(_)))
            .count();
        self.stats.color_nodes = self
            .seen_nodes
            .iter()
            .filter(|node| matches!(node, ParamKey::Color(_)))
            .count();
        self.stats.node_payload_bytes_lower_bound = self.stats.scalar_nodes
            * std::mem::size_of::<ScalarNode>()
            + self.stats.color_nodes * std::mem::size_of::<ColorNode>();
        self.stats.uniform_values = self.uniform_locations.len();
        self.stats.uniform_slots = self.uniforms.len();

        let fragment = Item::Struct(ItemStruct {
            type_params: vec![],
            const_params: vec![],
            name: "Fragment".to_string(),
            fields: vec![
                Field {
                    inter_stage_io: vec![],
                    name: "uv".to_string(),
                    ty: vec2_ty(),
                    attrs: vec![],
                },
                Field {
                    inter_stage_io: vec![],
                    name: "coverage".to_string(),
                    ty: f32_ty(),
                    attrs: vec![],
                },
            ],
            attrs: vec![],
        });

        let mut items = vec![fragment];
        if !self.uniforms.is_empty() {
            items.push(Item::Struct(ItemStruct {
                type_params: vec![],
                const_params: vec![],
                name: "Params".to_string(),
                fields: vec![Field {
                    inter_stage_io: vec![],
                    name: "values".to_string(),
                    ty: Type::Array {
                        elem: Box::new(vec4_ty()),
                        len: u32_lit(self.uniforms.len()),
                    },
                    attrs: vec![],
                }],
                attrs: vec![],
            }));
            items.push(Item::Uniform(ItemUniform {
                group: 0,
                binding: 0,
                name: "params".to_string(),
                ty: Type::Struct {
                    name: "Params".to_string(),
                    type_args: vec![],
                },
                attrs: vec![],
            }));
        }
        items.push(Item::Fn(ItemFn {
            type_params: vec![],
            const_params: vec![],
            fn_attrs: FnAttrs::None,
            name: "shade".to_string().into(),
            inputs: vec![FnArg {
                inter_stage_io: vec![],
                name: "fragment".to_string(),
                ty: Type::Struct {
                    name: "Fragment".to_string(),
                    type_args: vec![],
                },
                attrs: vec![],
            }],
            return_type: ReturnType::Type {
                annotation: ReturnTypeAnnotation::None,
                ty: vec4_ty(),
            },
            block: Block {
                stmts: self.statements,
            },
            attrs: vec![],
        }));

        let module = Module {
            name: "shader_builder_probe",
            items,
            attrs: vec![],
        };
        LoweredShader {
            module,
            uniforms: self.uniforms,
            stats: self.stats,
        }
    }

    fn lower_scalar(&mut self, scalar: &Scalar, domain: &Domain) -> Expr {
        let pointer = Arc::as_ptr(&scalar.0) as usize;
        self.seen_nodes.insert(ParamKey::Scalar(pointer));
        let key = ExprKey {
            node: pointer,
            domain: domain.key.clone(),
        };
        if let Some(value) = self.scalar_cache.get(&key) {
            self.stats.expression_cache_hits += 1;
            return value.clone();
        }

        let value = match &scalar.0.kind {
            ScalarKind::Uniform(value) => {
                self.uniform(ParamKey::Scalar(pointer), [*value, 0.0, 0.0, 0.0], true)
            }
            ScalarKind::Constant(value) => f32_lit(*value),
            ScalarKind::UvX => field(domain.uv.clone(), "x"),
            ScalarKind::UvY => field(domain.uv.clone(), "y"),
            ScalarKind::Add(lhs, rhs) => binary(
                self.lower_scalar(lhs, domain),
                BinOp::Add,
                self.lower_scalar(rhs, domain),
            ),
            ScalarKind::Sub(lhs, rhs) => binary(
                self.lower_scalar(lhs, domain),
                BinOp::Sub,
                self.lower_scalar(rhs, domain),
            ),
            ScalarKind::Mul(lhs, rhs) => binary(
                self.lower_scalar(lhs, domain),
                BinOp::Mul,
                self.lower_scalar(rhs, domain),
            ),
            ScalarKind::Sin(value) => call("sin", vec![self.lower_scalar(value, domain)]),
            ScalarKind::Clamp01(value) => call(
                "clamp",
                vec![self.lower_scalar(value, domain), f32_lit(0.0), f32_lit(1.0)],
            ),
        };

        let value = if matches!(
            &scalar.0.kind,
            ScalarKind::Add(_, _)
                | ScalarKind::Sub(_, _)
                | ScalarKind::Mul(_, _)
                | ScalarKind::Sin(_)
                | ScalarKind::Clamp01(_)
        ) {
            self.local(f32_ty(), value)
        } else {
            value
        };
        self.scalar_cache.insert(key, value.clone());
        value
    }

    fn lower_color(&mut self, color: &Color, domain: &Domain) -> Expr {
        let pointer = Arc::as_ptr(&color.0) as usize;
        self.seen_nodes.insert(ParamKey::Color(pointer));
        let key = ExprKey {
            node: pointer,
            domain: domain.key.clone(),
        };
        if let Some(value) = self.color_cache.get(&key) {
            self.stats.expression_cache_hits += 1;
            return value.clone();
        }

        let value = match &color.0.kind {
            ColorKind::Uniform(rgba) => self.uniform(ParamKey::Color(pointer), *rgba, false),
            ColorKind::Constant(rgba) => call("vec4f", rgba.iter().copied().map(f32_lit).collect()),
            ColorKind::Rgba(red, green, blue, alpha) => {
                let red = self.lower_scalar(red, domain);
                let green = self.lower_scalar(green, domain);
                let blue = self.lower_scalar(blue, domain);
                let alpha = self.lower_scalar(alpha, domain);
                self.local(
                    vec4_ty(),
                    call(
                        "vec4f",
                        vec![
                            binary(red, BinOp::Mul, alpha.clone()),
                            binary(green, BinOp::Mul, alpha.clone()),
                            binary(blue, BinOp::Mul, alpha.clone()),
                            alpha,
                        ],
                    ),
                )
            }
            ColorKind::Mix(front, back, amount) => {
                let front = self.lower_color(front, domain);
                let back = self.lower_color(back, domain);
                let amount = self.lower_scalar(amount, domain);
                let inverse =
                    self.local(f32_ty(), binary(f32_lit(1.0), BinOp::Sub, amount.clone()));
                let weighted_front = self.local(vec4_ty(), binary(front, BinOp::Mul, inverse));
                let weighted_back = self.local(vec4_ty(), binary(back, BinOp::Mul, amount));
                self.local(vec4_ty(), binary(weighted_front, BinOp::Add, weighted_back))
            }
            ColorKind::Over(front, back) => {
                let front = self.lower_color(front, domain);
                let back = self.lower_color(back, domain);
                let keep_back = self.local(
                    f32_ty(),
                    binary(f32_lit(1.0), BinOp::Sub, field(front.clone(), "w")),
                );
                let faded_back = self.local(vec4_ty(), binary(back, BinOp::Mul, keep_back));
                self.local(vec4_ty(), binary(front, BinOp::Add, faded_back))
            }
            ColorKind::Opacity(child, amount) | ColorKind::Mask(child, amount) => {
                let child = self.lower_color(child, domain);
                let amount = self.lower_scalar(&amount.0, domain);
                self.local(vec4_ty(), binary(child, BinOp::Mul, amount))
            }
            ColorKind::ShiftX(child, offset) => {
                let map_node = Arc::as_ptr(&color.0) as usize;
                let mut mapped_key = domain.key.clone();
                mapped_key.0.push(map_node);
                let uv = if let Some(value) = self.domain_cache.get(&mapped_key) {
                    value.clone()
                } else {
                    let offset = self.lower_scalar(offset, domain);
                    let delta = call("vec2f", vec![offset, f32_lit(0.0)]);
                    let mapped =
                        self.local(vec2_ty(), binary(domain.uv.clone(), BinOp::Add, delta));
                    self.domain_cache.insert(mapped_key.clone(), mapped.clone());
                    self.stats.domain_expressions += 1;
                    mapped
                };
                let mapped_domain = Domain {
                    key: mapped_key,
                    uv,
                };
                self.lower_color(child, &mapped_domain)
            }
        };

        self.color_cache.insert(key, value.clone());
        value
    }

    fn uniform(&mut self, key: ParamKey, value: [f32; 4], scalar: bool) -> Expr {
        let location = if let Some(location) = self.uniform_locations.get(&key) {
            *location
        } else if scalar {
            let (slot, component) = match self.active_scalar_slot {
                Some(slot) if self.scalar_slot_lanes[&slot] < 4 => {
                    let component = self.scalar_slot_lanes[&slot];
                    self.scalar_slot_lanes.insert(slot, component + 1);
                    (slot, component)
                }
                _ => {
                    let slot = self.uniforms.len();
                    self.uniforms.push([0.0; 4]);
                    self.scalar_slot_lanes.insert(slot, 1);
                    self.active_scalar_slot = Some(slot);
                    (slot, 0)
                }
            };
            self.uniforms[slot][component] = value[0];
            let location = UniformLocation {
                slot,
                component: Some(component),
            };
            self.uniform_locations.insert(key, location);
            location
        } else {
            let slot = self.uniforms.len();
            self.uniforms.push(value);
            let location = UniformLocation {
                slot,
                component: None,
            };
            self.uniform_locations.insert(key, location);
            location
        };
        let indexed = Expr::ArrayIndexing {
            lhs: Box::new(field(ident("params"), "values")),
            index: Box::new(u32_lit(location.slot)),
        };
        match location.component {
            Some(0) => field(indexed, "x"),
            Some(1) => field(indexed, "y"),
            Some(2) => field(indexed, "z"),
            Some(3) => field(indexed, "w"),
            None => indexed,
            Some(_) => unreachable!("vec4 uniform lane must be in 0..4"),
        }
    }

    fn local(&mut self, ty: Type, init: Expr) -> Expr {
        let name = format!("v{}", self.next_local);
        self.next_local += 1;
        self.stats.emitted_expressions += 1;
        self.statements.push(Stmt::Local(wgsl_rs::ir::Local {
            mutable: false,
            name: name.clone(),
            ty: Some(ty),
            init: Some(init),
        }));
        ident(name)
    }
}

pub fn bands(pixel: Pixel, phase: f32, tint: [f32; 4]) -> Color {
    let amount = (pixel.uv().x() * 12.0 + phase).sin() * 0.5 + 0.5;
    color(tint).mix(Color::constant([0.94, 0.28, 0.08, 1.0]), amount)
}

pub fn realistic_recipe(
    phase_front: f32,
    tint_front: [f32; 4],
    phase_back: f32,
    tint_back: [f32; 4],
    mask: f32,
) -> Color {
    shader(move |pixel| {
        let back = bands(pixel, phase_back, tint_back)
            .shift_x(0.035)
            .opacity(0.65);
        let shared_front = bands(pixel, phase_front, tint_front);
        let masked = shared_front.clone().mask(mask);
        back.over(masked.clone())
            .mix(shared_front.opacity(0.55), 0.3)
            .over(masked)
    })
}

pub fn diamond_recipe(depth: usize) -> Color {
    shader(|pixel| {
        let mut paint = bands(pixel, 0.29, [0.3, 0.5, 0.7, 1.0]);
        for _ in 0..depth {
            paint = paint.clone().mix(paint, 0.5);
        }
        paint
    })
}

#[cfg(test)]
mod ir_expression_tests {
    use super::*;

    #[test]
    fn nested_binary_ir_keeps_explicit_grouping() {
        let a = || ident("a");
        let b = || ident("b");
        let c = || ident("c");

        let cases = [
            (
                binary(binary(a(), BinOp::Add, b()), BinOp::Mul, c()),
                "(a + b) * c",
            ),
            (
                binary(a(), BinOp::Mul, binary(b(), BinOp::Add, c())),
                "a * (b + c)",
            ),
            (
                binary(a(), BinOp::Sub, binary(b(), BinOp::Sub, c())),
                "a - (b - c)",
            ),
        ];
        for (expr, expected) in cases {
            assert_eq!(wgsl_rs::ir::render_expr(&expr), expected);
        }
    }
}
