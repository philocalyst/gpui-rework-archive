//! GPUI subject hooks require an explicit path or import, never a matching trait name.
//!
//! A proc macro cannot resolve arbitrary glob imports or re-exports. Monomorphic types can still
//! use linked discovery; generic subject implementations should name/import the GPUI trait.
use std::collections::{HashMap, HashSet, hash_map::Entry};

use syn::{Item, Path, UseTree};

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub(super) enum SubjectTrait {
    Element,
    View,
    RenderOnce,
}

#[derive(Clone, Debug, Eq, PartialEq)]
struct ImportPath {
    segments: Vec<String>,
    absolute: bool,
}

#[derive(Default)]
pub(super) struct SubjectTraits {
    // None represents a conditional or conflicting binding. Keep the original paths rather
    // than preclassifying aliases: a later foreign `use ... as gpui` must invalidate its users.
    imports: HashMap<String, Option<ImportPath>>,
    declarations: HashSet<String>,
}

impl SubjectTraits {
    pub(super) fn new(items: &[Item]) -> Self {
        let mut result = Self::default();
        for item in items {
            match item {
                Item::Use(item) => {
                    let conditional = !super::cfg_attrs(&item.attrs).is_empty();
                    result.import_tree(&item.tree, &[], item.leading_colon.is_some(), conditional);
                }
                Item::ExternCrate(item) => {
                    let name = item.rename.as_ref().map_or(&item.ident, |(_, name)| name);
                    let source = ImportPath {
                        segments: vec![item.ident.to_string()],
                        absolute: true,
                    };
                    let conditional = !super::cfg_attrs(&item.attrs).is_empty();
                    result.bind(name.to_string(), (!conditional).then_some(source));
                }
                _ => {
                    let name = match item {
                        Item::Enum(item) => Some(&item.ident),
                        Item::Mod(item) => Some(&item.ident),
                        Item::Struct(item) => Some(&item.ident),
                        Item::Trait(item) => Some(&item.ident),
                        Item::TraitAlias(item) => Some(&item.ident),
                        Item::Type(item) => Some(&item.ident),
                        Item::Union(item) => Some(&item.ident),
                        _ => None,
                    };
                    if let Some(name) = name {
                        result.declarations.insert(name.to_string());
                    }
                }
            }
        }
        result
    }

    pub(super) fn resolve(&self, path: &Path) -> Option<SubjectTrait> {
        let mut source = ImportPath {
            segments: path
                .segments
                .iter()
                .map(|segment| segment.ident.to_string())
                .collect(),
            absolute: path.leading_colon.is_some(),
        };
        // Every step consumes one alias. The bound rejects cycles without allocating a visited
        // set, and resolving on demand keeps source order from affecting the result.
        for _ in 0..=self.imports.len() {
            let first = source.segments.first()?;
            if !source.absolute {
                if self.declarations.contains(first) {
                    return None;
                }
                if let Some(binding) = self.imports.get(first) {
                    let binding = binding.as_ref()?;
                    // `use gpui::{self, View}` keeps the external root's own name.
                    // It is an identity binding, not a cycle through another alias.
                    if binding.absolute
                        || binding.segments.as_slice() != std::slice::from_ref(first)
                    {
                        let mut segments = binding.segments.clone();
                        segments.extend_from_slice(&source.segments[1..]);
                        source = ImportPath {
                            segments,
                            absolute: binding.absolute,
                        };
                        continue;
                    }
                }
            }
            return match source.segments.as_slice() {
                [root, name] if root == "gpui" => match name.as_str() {
                    "Element" => Some(SubjectTrait::Element),
                    "View" => Some(SubjectTrait::View),
                    "RenderOnce" => Some(SubjectTrait::RenderOnce),
                    _ => None,
                },
                _ => None,
            };
        }
        None
    }

    fn bind(&mut self, name: String, source: Option<ImportPath>) {
        match self.imports.entry(name) {
            Entry::Vacant(entry) => {
                entry.insert(source);
            }
            Entry::Occupied(mut entry) if entry.get() != &source => {
                entry.insert(None);
            }
            Entry::Occupied(_) => {}
        }
    }

    fn import_tree(
        &mut self,
        tree: &UseTree,
        prefix: &[String],
        absolute: bool,
        conditional: bool,
    ) {
        match tree {
            UseTree::Path(path) => {
                let mut prefix = prefix.to_vec();
                prefix.push(path.ident.to_string());
                self.import_tree(&path.tree, &prefix, absolute, conditional);
            }
            UseTree::Group(group) => {
                for tree in &group.items {
                    self.import_tree(tree, prefix, absolute, conditional);
                }
            }
            UseTree::Name(name) => {
                let mut segments = prefix.to_vec();
                if name.ident != "self" {
                    segments.push(name.ident.to_string());
                }
                if let Some(name) = segments.last().cloned() {
                    self.bind(
                        name,
                        (!conditional).then_some(ImportPath { segments, absolute }),
                    );
                }
            }
            UseTree::Rename(rename) => {
                let mut segments = prefix.to_vec();
                if rename.ident != "self" {
                    segments.push(rename.ident.to_string());
                }
                self.bind(
                    rename.rename.to_string(),
                    (!conditional).then_some(ImportPath { segments, absolute }),
                );
            }
            UseTree::Glob(_) => {}
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use syn::parse_quote;

    fn resolver(items: Vec<Item>) -> SubjectTraits {
        SubjectTraits::new(&items)
    }

    fn subject(path: Path, expected: SubjectTrait) {
        assert_eq!(resolver(Vec::new()).resolve(&path), Some(expected));
    }

    #[test]
    fn recognizes_gpui_paths_and_explicit_imports() {
        subject(parse_quote!(gpui::Element), SubjectTrait::Element);
        subject(parse_quote!(::gpui::View), SubjectTrait::View);

        let resolver = resolver(vec![parse_quote!(
            use gpui::{View, RenderOnce as Component};
        )]);
        assert_eq!(
            resolver.resolve(&parse_quote!(View)),
            Some(SubjectTrait::View)
        );
        assert_eq!(
            resolver.resolve(&parse_quote!(Component)),
            Some(SubjectTrait::RenderOnce)
        );
    }

    #[test]
    fn recognizes_module_aliases_and_chains() {
        let resolver = resolver(vec![
            parse_quote!(
                use gpui as g;
            ),
            parse_quote!(
                use g::View as V;
            ),
            parse_quote!(
                use gpui::{self as api};
            ),
            parse_quote!(
                use api::RenderOnce as Component;
            ),
        ]);
        assert_eq!(
            resolver.resolve(&parse_quote!(g::View)),
            Some(SubjectTrait::View)
        );
        assert_eq!(resolver.resolve(&parse_quote!(V)), Some(SubjectTrait::View));
        assert_eq!(
            resolver.resolve(&parse_quote!(Component)),
            Some(SubjectTrait::RenderOnce)
        );
    }

    #[test]
    fn alias_origins_are_checked_after_all_imports_are_known() {
        let foreign_root = resolver(vec![
            parse_quote!(
                use gpui::View;
            ),
            parse_quote!(
                use domain as gpui;
            ),
        ]);
        assert_eq!(foreign_root.resolve(&parse_quote!(View)), None);
        assert_eq!(foreign_root.resolve(&parse_quote!(gpui::View)), None);

        let reversed = resolver(vec![
            parse_quote!(
                use api::View as V;
            ),
            parse_quote!(
                use gpui as api;
            ),
        ]);
        assert_eq!(reversed.resolve(&parse_quote!(V)), Some(SubjectTrait::View));

        let cycle = resolver(vec![
            parse_quote!(
                use b as a;
            ),
            parse_quote!(
                use a as b;
            ),
        ]);
        assert_eq!(cycle.resolve(&parse_quote!(a::View)), None);
    }

    #[test]
    fn unrenamed_self_imports_preserve_the_external_root() {
        let resolver = resolver(vec![parse_quote!(
            use gpui::{self, View};
        )]);
        assert_eq!(
            resolver.resolve(&parse_quote!(View)),
            Some(SubjectTrait::View)
        );
        assert_eq!(
            resolver.resolve(&parse_quote!(gpui::Element)),
            Some(SubjectTrait::Element)
        );
    }

    #[test]
    fn rejects_local_foreign_and_glob_names() {
        let local = resolver(vec![parse_quote!(
            trait View {}
        )]);
        assert_eq!(local.resolve(&parse_quote!(View)), None);

        let foreign = resolver(vec![parse_quote!(
            use domain::View as Element;
        )]);
        assert_eq!(foreign.resolve(&parse_quote!(Element)), None);

        let glob = resolver(vec![parse_quote!(
            use gpui::*;
        )]);
        assert_eq!(glob.resolve(&parse_quote!(View)), None);
    }

    #[test]
    fn rejects_shadowed_gpui_module_and_accepts_absolute_root() {
        let resolver = resolver(vec![
            parse_quote!(
                mod gpui {
                    pub trait View {}
                }
            ),
            parse_quote!(
                use gpui::View as LocalView;
            ),
        ]);
        assert_eq!(resolver.resolve(&parse_quote!(gpui::View)), None);
        assert_eq!(resolver.resolve(&parse_quote!(LocalView)), None);
        assert_eq!(
            resolver.resolve(&parse_quote!(::gpui::View)),
            Some(SubjectTrait::View)
        );
    }

    #[test]
    fn duplicate_aliases_and_conditional_imports_are_ambiguous() {
        let duplicates = resolver(vec![
            parse_quote!(
                use gpui::View as Subject;
            ),
            parse_quote!(
                use domain::Element as Subject;
            ),
        ]);
        assert_eq!(duplicates.resolve(&parse_quote!(Subject)), None);

        let conditional = resolver(vec![
            parse_quote!(
                use gpui::View as Subject;
            ),
            parse_quote!(
                #[cfg(feature = "view")]
                use domain::Element as Subject;
            ),
        ]);
        assert_eq!(conditional.resolve(&parse_quote!(Subject)), None);

        let conditional_declaration = resolver(vec![
            parse_quote!(
                use gpui::View;
            ),
            parse_quote!(
                #[cfg(feature = "view")]
                trait View {}
            ),
        ]);
        assert_eq!(conditional_declaration.resolve(&parse_quote!(View)), None);
    }
}
