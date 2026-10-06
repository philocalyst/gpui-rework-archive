//! Frame-local GPU projection of coordinate mappings and exact clip scopes.

use crate::{Bounds, TransformationMatrix};

/// The role of a frame-local coordinate-space record.
#[doc(hidden)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
#[repr(u32)]
pub enum SpaceKind {
    /// An affine mapping with no additional clip.
    #[default]
    Mapping = 0,
    /// A clipping scope, evaluated in its own coordinates.
    Clip = 1,
    /// A collapsed or non-finite mapping with no visible region.
    Collapsed = 2,
}

/// An interned coordinate-space record in the scene's GPU table.
#[doc(hidden)]
#[derive(Clone, Copy, Debug, PartialEq)]
#[repr(C)]
pub struct RenderSpace {
    pub transform: TransformationMatrix,
    pub inverse: TransformationMatrix,
    pub clip: Bounds<crate::ScaledPixels>,
    pub fade: crate::Edges<crate::ScaledPixels>,
    pub parent: u32,
    pub kind: SpaceKind,
}

impl Default for RenderSpace {
    fn default() -> Self {
        Self {
            transform: TransformationMatrix::unit(),
            inverse: TransformationMatrix::unit(),
            clip: Bounds::default(),
            fade: crate::Edges::default(),
            parent: 0,
            kind: SpaceKind::Mapping,
        }
    }
}

impl RenderSpace {
    /// Skip mappings in the coverage chain: their complete affine composition is
    /// already stored on the active record. Collapsed scopes must remain barriers.
    pub(crate) fn clip_scope(self, id: u32) -> u32 {
        match self.kind {
            SpaceKind::Mapping => self.parent,
            SpaceKind::Clip | SpaceKind::Collapsed => id,
        }
    }

    pub(crate) fn mapping(
        transform: TransformationMatrix,
        inverse: Option<TransformationMatrix>,
        parent: u32,
    ) -> Self {
        let Some(inverse) = inverse else {
            return Self::collapsed(parent);
        };
        Self {
            transform,
            inverse,
            parent,
            ..Default::default()
        }
    }

    pub(crate) fn clipping(
        transform: TransformationMatrix,
        inverse: Option<TransformationMatrix>,
        clip: Bounds<crate::ScaledPixels>,
        fade: crate::Edges<crate::ScaledPixels>,
        parent: u32,
    ) -> Self {
        let Some(inverse) = inverse else {
            return Self::collapsed(parent);
        };
        Self {
            transform,
            inverse,
            clip,
            fade,
            parent,
            kind: SpaceKind::Clip,
        }
    }

    pub(crate) fn collapsed(parent: u32) -> Self {
        Self {
            transform: TransformationMatrix {
                rotation_scale: [[0.0; 2]; 2],
                translation: [0.0; 2],
            },
            inverse: TransformationMatrix::unit(),
            parent,
            kind: SpaceKind::Collapsed,
            ..Default::default()
        }
    }

    pub(crate) fn is_collapsed(&self) -> bool {
        self.kind == SpaceKind::Collapsed
    }

    pub(crate) fn key(&self) -> [u32; 22] {
        let mut key = [0; 22];
        for (i, value) in self
            .transform
            .rotation_scale
            .iter()
            .flatten()
            .chain(self.transform.translation.iter())
            .chain(self.inverse.rotation_scale.iter().flatten())
            .chain(self.inverse.translation.iter())
            .copied()
            .chain([
                self.clip.origin.x.0,
                self.clip.origin.y.0,
                self.clip.size.width.0,
                self.clip.size.height.0,
                self.fade.top.0,
                self.fade.right.0,
                self.fade.bottom.0,
                self.fade.left.0,
            ])
            .enumerate()
        {
            key[i] = value.to_bits();
        }
        key[20] = self.parent;
        key[21] = self.kind as u32;
        key
    }
}
