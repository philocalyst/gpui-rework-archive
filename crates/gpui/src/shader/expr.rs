use std::sync::Arc;

#[doc(hidden)]
#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
pub(super) enum Type {
    F32,
    Bool,
    Vec2,
    Vec3,
    Vec4,
}

impl Type {
    pub(super) fn components(self) -> usize {
        match self {
            Self::F32 | Self::Bool => 1,
            Self::Vec2 => 2,
            Self::Vec3 => 3,
            Self::Vec4 => 4,
        }
    }
}

#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
pub(super) enum Input {
    Uv,
    Position,
    Size,
}

#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
pub(super) enum UnaryOp {
    Neg,
    Not,
}

#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
pub(super) enum BinaryOp {
    Add,
    Sub,
    Mul,
    Div,
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
    And,
    Or,
}

#[derive(Clone, Copy, Debug, Eq, Hash, PartialEq)]
pub(super) enum Builtin {
    Sin,
    Cos,
    Abs,
    Fract,
    Floor,
    Sqrt,
    Pow,
    Exp,
    Min,
    Max,
    Clamp,
    Smoothstep,
    Dot,
    Length,
    Normalize,
    Dpdx,
    Dpdy,
    Fwidth,
}

#[derive(Clone, Debug)]
pub(super) struct Node {
    pub(super) ty: Type,
    pub(super) kind: Kind,
}

#[derive(Clone, Debug)]
pub(super) enum Kind {
    Uniform([u32; 4]),
    Constant([u32; 4]),
    Input(Input),
    Compose2(Arc<Node>, Arc<Node>),
    Compose3(Arc<Node>, Arc<Node>, Arc<Node>),
    Compose4(Arc<Node>, Arc<Node>, Arc<Node>, Arc<Node>),
    Swizzle(Arc<Node>, &'static str),
    Unary(UnaryOp, Arc<Node>),
    Binary(BinaryOp, Arc<Node>, Arc<Node>),
    Builtin1(Builtin, Arc<Node>),
    Builtin2(Builtin, Arc<Node>, Arc<Node>),
    Builtin3(Builtin, Arc<Node>, Arc<Node>, Arc<Node>),
    Select(Arc<Node>, Arc<Node>, Arc<Node>),
    Rgba(Arc<Node>, Arc<Node>, Arc<Node>, Arc<Node>),
    Mix(Arc<Node>, Arc<Node>, Arc<Node>),
    Over(Arc<Node>, Arc<Node>),
    Opacity(Arc<Node>, Arc<Node>),
    Mask(Arc<Node>, Arc<Node>),
    MapUv(Arc<Node>, Arc<Node>),
    Backdrop(Arc<Node>),
}

pub(super) fn make(ty: Type, kind: Kind) -> Arc<Node> {
    Arc::new(Node { ty, kind })
}

impl Drop for Node {
    fn drop(&mut self) {
        let mut pending = Vec::new();
        take_children(
            std::mem::replace(&mut self.kind, Kind::Constant([0; 4])),
            &mut pending,
        );
        while let Some(child) = pending.pop() {
            if let Ok(mut node) = Arc::try_unwrap(child) {
                take_children(
                    std::mem::replace(&mut node.kind, Kind::Constant([0; 4])),
                    &mut pending,
                );
            }
        }
    }
}

fn take_children(kind: Kind, pending: &mut Vec<Arc<Node>>) {
    match kind {
        Kind::Uniform(_) | Kind::Constant(_) | Kind::Input(_) => {}
        Kind::Compose2(a, b)
        | Kind::Binary(_, a, b)
        | Kind::Builtin2(_, a, b)
        | Kind::Over(a, b)
        | Kind::Opacity(a, b)
        | Kind::Mask(a, b) => {
            pending.push(a);
            pending.push(b);
        }
        Kind::Compose3(a, b, c) | Kind::Builtin3(_, a, b, c) => {
            pending.push(a);
            pending.push(b);
            pending.push(c);
        }
        Kind::Compose4(a, b, c, d) => {
            pending.push(a);
            pending.push(b);
            pending.push(c);
            pending.push(d);
        }
        Kind::Swizzle(value, _)
        | Kind::Unary(_, value)
        | Kind::Builtin1(_, value)
        | Kind::Backdrop(value) => {
            pending.push(value);
        }
        Kind::Select(condition, when_false, when_true) => {
            pending.push(condition);
            pending.push(when_false);
            pending.push(when_true);
        }
        Kind::Rgba(r, g, b, a) => {
            pending.push(r);
            pending.push(g);
            pending.push(b);
            pending.push(a);
        }
        Kind::Mix(front, back, amount) => {
            pending.push(front);
            pending.push(back);
            pending.push(amount);
        }
        Kind::MapUv(paint, uv) => {
            pending.push(paint);
            pending.push(uv);
        }
    }
}
