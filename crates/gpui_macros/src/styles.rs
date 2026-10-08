use proc_macro::TokenStream;
use proc_macro2::TokenStream as TokenStream2;
use quote::{format_ident, quote};
use syn::{
    Attribute, Token, Visibility, braced,
    parse::{Parse, ParseStream, Result},
    parse_macro_input,
};

#[derive(Debug)]
struct StyleableMacroInput {
    method_visibility: Visibility,
    method_docs: Vec<(syn::Ident, Vec<Attribute>)>,
}

impl Parse for StyleableMacroInput {
    fn parse(input: ParseStream) -> Result<Self> {
        if input.is_empty() {
            return Ok(Self {
                method_visibility: Visibility::Inherited,
                method_docs: Vec::new(),
            });
        }

        if input.peek(syn::token::Brace) {
            let content;
            braced!(content in input);
            return parse_styleable_items(&content);
        }
        parse_styleable_items(input)
    }
}

fn parse_styleable_items(content: ParseStream) -> Result<StyleableMacroInput> {
    let mut method_visibility = None;
    let mut method_docs = Vec::new();

    while !content.is_empty() {
        let ident: syn::Ident = content.parse()?;
        if ident == "visibility" {
            let _colon: Token![:] = content.parse()?;
            method_visibility = Some(content.parse()?);
        } else if ident == "docs" {
            let docs;
            braced!(docs in content);
            while !docs.is_empty() {
                let method: syn::Ident = docs.parse()?;
                let _colon: Token![:] = docs.parse()?;
                let attrs = Attribute::parse_outer(&docs).map_err(|error| {
                    syn::Error::new(method.span(), format!("invalid style helper docs: {error}"))
                })?;
                if attrs.is_empty() {
                    return Err(syn::Error::new(
                        method.span(),
                        "expected at least one attribute",
                    ));
                }
                method_docs.push((method, attrs));
                if docs.peek(Token![,]) {
                    docs.parse::<Token![,]>()?;
                }
            }
        } else {
            return Err(syn::Error::new(
                ident.span(),
                "expected `visibility` or `docs`",
            ));
        }
        if content.peek(Token![,]) {
            content.parse::<Token![,]>()?;
        }
    }

    Ok(StyleableMacroInput {
        method_visibility: method_visibility.unwrap_or(Visibility::Inherited),
        method_docs,
    })
}

pub fn style_helpers(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as StyleableMacroInput);
    let methods = generate_methods();
    let known: std::collections::HashSet<String> = methods
        .iter()
        .map(|method| {
            syn::parse2::<syn::TraitItemFn>(method.clone())
                .expect("generated style helper")
                .sig
                .ident
                .to_string()
        })
        .collect();
    let mut seen = std::collections::HashSet::new();
    for (name, _) in &input.method_docs {
        if !known.contains(&name.to_string()) {
            return syn::Error::new(name.span(), format!("unknown style helper `{name}`"))
                .to_compile_error()
                .into();
        }
        if !seen.insert(name.to_string()) {
            return syn::Error::new(
                name.span(),
                format!("duplicate style helper docs for `{name}`"),
            )
            .to_compile_error()
            .into();
        }
    }
    let methods = methods.into_iter().map(|method| {
        let mut method: syn::TraitItemFn = syn::parse2(method).expect("generated style helper");
        if let Some((_, attrs)) = input
            .method_docs
            .iter()
            .find(|(name, _)| name == &method.sig.ident)
        {
            method.attrs.extend(attrs.iter().cloned());
        }
        quote!(#method)
    });
    let output = quote! {
        #(#methods)*
    };

    output.into()
}

struct StyleTransitionSpec {
    name: &'static str,
    fields: Vec<StyleTransitionField>,
}

struct StyleTransitionField {
    path: TokenStream2,
    kind: StyleTransitionFieldKind,
}

struct CanonicalStyleTransitionField {
    config_name: syn::Ident,
    path: TokenStream2,
    kind: StyleTransitionFieldKind,
}

#[derive(Clone, Copy, PartialEq, Eq)]
enum StyleTransitionFieldKind {
    Required,
    Optional,
    InsetTop,
    InsetRight,
    InsetBottom,
    InsetLeft,
    AutoSizeWidth,
    AutoSizeHeight,
    CornerRadius,
}

impl StyleTransitionField {
    fn required(path: TokenStream2) -> Self {
        Self {
            path,
            kind: StyleTransitionFieldKind::Required,
        }
    }

    fn optional(path: TokenStream2) -> Self {
        Self {
            path,
            kind: StyleTransitionFieldKind::Optional,
        }
    }

    fn required_or_special_length(path: TokenStream2) -> Self {
        let kind = match style_transition_key(&path).as_str() {
            "size.width" => StyleTransitionFieldKind::AutoSizeWidth,
            "size.height" => StyleTransitionFieldKind::AutoSizeHeight,
            "inset.top" => StyleTransitionFieldKind::InsetTop,
            "inset.right" => StyleTransitionFieldKind::InsetRight,
            "inset.bottom" => StyleTransitionFieldKind::InsetBottom,
            "inset.left" => StyleTransitionFieldKind::InsetLeft,
            _ => StyleTransitionFieldKind::Required,
        };
        Self { path, kind }
    }

    fn corner_radius(path: TokenStream2) -> Self {
        Self {
            path,
            kind: StyleTransitionFieldKind::CornerRadius,
        }
    }
}

fn style_transition_key(path: &TokenStream2) -> String {
    path.to_string().split_whitespace().collect()
}

fn style_transition_config_name(key: &str) -> syn::Ident {
    format_ident!("transition_{}", key.replace('.', "_"))
}

fn canonical_style_transition_fields(
    specs: &[StyleTransitionSpec],
) -> Vec<CanonicalStyleTransitionField> {
    let mut fields = Vec::<CanonicalStyleTransitionField>::new();
    let mut field_indices = std::collections::HashMap::<String, usize>::new();
    let mut config_names = std::collections::HashMap::<String, String>::new();

    for field in specs.iter().flat_map(|spec| &spec.fields) {
        let key = style_transition_key(&field.path);
        if let Some(index) = field_indices.get(&key).copied() {
            let canonical = &fields[index];
            if canonical.kind != field.kind {
                panic!("style transition field `{key}` has conflicting metadata");
            }
            continue;
        }

        let config_name = style_transition_config_name(&key);
        let config_name_string = config_name.to_string();
        if let Some(existing_key) = config_names.insert(config_name_string.clone(), key.clone())
            && existing_key != key
        {
            panic!(
                "style transition fields `{existing_key}` and `{key}` map to the same config field `{config_name_string}`"
            );
        }

        field_indices.insert(key.clone(), fields.len());
        fields.push(CanonicalStyleTransitionField {
            config_name,
            path: field.path.clone(),
            kind: field.kind,
        });
    }

    fields
}

pub fn style_transitions(input: TokenStream) -> TokenStream {
    let _ = parse_macro_input!(input as StyleableMacroInput);
    let specs = style_transition_specs();
    let canonical_fields = canonical_style_transition_fields(&specs);

    let config_fields = canonical_fields.iter().map(|field| {
        let name = &field.config_name;
        quote! {
            #name: Option<crate::AnyMotion>
        }
    });

    let builders = specs.iter().map(|spec| {
        let name = format_ident!("{}", spec.name);
        let docs = style_transition_docs(spec.name)
            .replace("[`Styled::", "[`crate::Styled::")
            .replace("[`StyleTransitions::", "[`crate::StyleTransitions::");
        let config_names = spec
            .fields
            .iter()
            .map(|field| style_transition_config_name(&style_transition_key(&field.path)));
        quote! {
            #[doc = #docs]
            pub fn #name(mut self, motion: impl Into<crate::AnyMotion>) -> Self {
                let motion = motion.into();
                #(self.#config_names = Some(motion.clone());)*
                self
            }
        }
    });

    let applications = canonical_fields.iter().map(generate_transition_application);

    quote! {
        /// Configures motion for selected style properties when their authored values change.
        ///
        /// Add this to a [`Div`](crate::Div) with `transitions`. Each builder selects a property
        /// group, and accepts a [`Motion`](crate::Motion), a spring configuration, or a duration
        /// converted with [`MotionDurationExt`](crate::MotionDurationExt). Configure separate
        /// groups independently; when builders overlap, the later builder replaces the motion
        /// only for the overlapping properties. GPUI retains transition state per element, so the
        /// element must keep a stable identity across renders for motion to continue. See
        /// [`Styled`](crate::Styled) for the style
        /// helpers that author the values being transitioned. Reduced-motion preference presents
        /// the authored endpoint without interpolation. Optional properties temporarily use their
        /// value type's default while a transition is active, then return to the authored option.
        #[derive(Default)]
        pub struct StyleTransitions {
            #(#config_fields,)*
        }

        impl StyleTransitions {
            /// Creates an empty configuration. No properties animate until a builder selects them.
            pub fn new() -> Self {
                Self::default()
            }

            #(#builders)*

            /// Applies configured transitions to `style`.
            ///
            /// Returns whether any transition remains active and requires another frame.
            pub(crate) fn apply(
                &self,
                style: &mut crate::Style,
                state: &mut StyleTransitionState,
                context: StyleTransitionContext,
                now: scheduler::Instant,
                reduce_motion: bool,
            ) -> bool {
                let mut in_progress = false;
                #(#applications)*
                in_progress
            }
        }

    }
    .into()
}

fn style_transition_docs(name: &str) -> &'static str {
    match name {
        "m" => {
            "Transitions changes made by [`Styled::m`] and its side/axis variants. The selected motion applies to all four margins; narrower builders can override individual sides."
        }
        "mt" => "Transitions changes made by [`Styled::mt`]. Selects only the top margin.",
        "mb" => "Transitions changes made by [`Styled::mb`]. Selects only the bottom margin.",
        "my" => "Transitions changes made by [`Styled::my`]. Selects the top and bottom margins.",
        "mx" => "Transitions changes made by [`Styled::mx`]. Selects the left and right margins.",
        "ml" => "Transitions changes made by [`Styled::ml`]. Selects only the left margin.",
        "mr" => "Transitions changes made by [`Styled::mr`]. Selects only the right margin.",
        "p" => {
            "Transitions changes made by [`Styled::p`] and its side/axis variants. The selected motion applies to all four padding edges."
        }
        "pt" => "Transitions changes made by [`Styled::pt`]. Selects only the top padding.",
        "pb" => "Transitions changes made by [`Styled::pb`]. Selects only the bottom padding.",
        "px" => "Transitions changes made by [`Styled::px`]. Selects left and right padding.",
        "py" => "Transitions changes made by [`Styled::py`]. Selects top and bottom padding.",
        "pl" => "Transitions changes made by [`Styled::pl`]. Selects only the left padding.",
        "pr" => "Transitions changes made by [`Styled::pr`]. Selects only the right padding.",
        "inset" => {
            "Transitions top, right, bottom, and left offsets set by [`Styled::inset`]. Use side builders to choose different motions per edge. Relative offsets are resolved against the containing block; auto offsets use the current laid-out position as their starting or ending value."
        }
        "top" => {
            "Transitions the top offset set by [`Styled::top`]. Relative lengths resolve against the containing block; auto uses the current laid-out position when available."
        }
        "right" => {
            "Transitions the right offset set by [`Styled::right`]. Relative lengths resolve against the containing block; auto uses the current laid-out position when available."
        }
        "bottom" => {
            "Transitions the bottom offset set by [`Styled::bottom`]. Relative lengths resolve against the containing block; auto uses the current laid-out position when available."
        }
        "left" => {
            "Transitions the left offset set by [`Styled::left`]. Relative lengths resolve against the containing block; auto uses the current laid-out position when available."
        }
        "w" => {
            "Transitions absolute width changes made by [`Styled::w`]. Pixels and rems resolve to pixels; auto uses retained layout bounds. Relative widths are presented immediately rather than interpolated."
        }
        "h" => {
            "Transitions absolute height changes made by [`Styled::h`]. Pixels and rems resolve to pixels; auto uses retained layout bounds. Relative heights are presented immediately rather than interpolated."
        }
        "size" => {
            "Transitions width and height set by [`Styled::size`]. Absolute lengths resolve to pixels and auto uses retained layout bounds. Relative dimensions are presented immediately rather than interpolated."
        }
        "min_size" => "Transitions the minimum width and height set by [`Styled::min_size`].",
        "min_w" => "Transitions the minimum width set by [`Styled::min_w`].",
        "min_h" => "Transitions the minimum height set by [`Styled::min_h`].",
        "max_size" => "Transitions the maximum width and height set by [`Styled::max_size`].",
        "max_w" => "Transitions the maximum width set by [`Styled::max_w`].",
        "max_h" => "Transitions the maximum height set by [`Styled::max_h`].",
        "gap" => "Transitions horizontal and vertical child gaps set by [`Styled::gap`].",
        "gap_x" => "Transitions the horizontal child gap set by [`Styled::gap_x`].",
        "gap_y" => "Transitions the vertical child gap set by [`Styled::gap_y`].",
        "rounded" => {
            "Transitions all corner radii set by [`Styled::rounded`]. Lengths resolve using the current root font size, then each radius is limited to half the smaller element dimension while the transition runs."
        }
        "rounded_t" => {
            "Transitions the top-left and top-right radii set by [`Styled::rounded_t`]. Radii are limited to half the smaller element dimension while the transition runs."
        }
        "rounded_b" => {
            "Transitions the bottom-left and bottom-right radii set by [`Styled::rounded_b`]. Radii are limited to half the smaller element dimension while the transition runs."
        }
        "rounded_r" => {
            "Transitions the right-side radii set by [`Styled::rounded_r`]. Radii are limited to half the smaller element dimension while the transition runs."
        }
        "rounded_l" => {
            "Transitions the left-side radii set by [`Styled::rounded_l`]. Radii are limited to half the smaller element dimension while the transition runs."
        }
        "rounded_tl" => {
            "Transitions the top-left radius set by [`Styled::rounded_tl`]. The radius is limited to half the smaller element dimension while the transition runs."
        }
        "rounded_tr" => {
            "Transitions the top-right radius set by [`Styled::rounded_tr`]. The radius is limited to half the smaller element dimension while the transition runs."
        }
        "rounded_bl" => {
            "Transitions the bottom-left radius set by [`Styled::rounded_bl`]. The radius is limited to half the smaller element dimension while the transition runs."
        }
        "rounded_br" => {
            "Transitions the bottom-right radius set by [`Styled::rounded_br`]. The radius is limited to half the smaller element dimension while the transition runs."
        }
        "border" => {
            "Transitions all four border widths set by [`Styled::border`]. Numbered presets use logical pixels; custom absolute lengths preserve their unit."
        }
        "border_t" => {
            "Transitions the top border width set by [`Styled::border_t`]. Numbered presets use logical pixels; custom absolute lengths preserve their unit."
        }
        "border_b" => {
            "Transitions the bottom border width set by [`Styled::border_b`]. Numbered presets use logical pixels; custom absolute lengths preserve their unit."
        }
        "border_r" => {
            "Transitions the right border width set by [`Styled::border_r`]. Numbered presets use logical pixels; custom absolute lengths preserve their unit."
        }
        "border_l" => {
            "Transitions the left border width set by [`Styled::border_l`]. Numbered presets use logical pixels; custom absolute lengths preserve their unit."
        }
        "border_x" => {
            "Transitions left and right border widths set by [`Styled::border_x`]. Numbered presets use logical pixels; custom absolute lengths preserve their unit."
        }
        "border_y" => {
            "Transitions top and bottom border widths set by [`Styled::border_y`]. Numbered presets use logical pixels; custom absolute lengths preserve their unit."
        }
        "scrollbar_width" => {
            "Transitions the scrollbar width. This is layout space reserved for scroll overflow, in logical pixels."
        }
        "aspect_ratio" => "Transitions the optional aspect ratio set by [`Styled::aspect_ratio`].",
        "flex_basis" => {
            "Transitions the preferred main-axis size set by [`Styled::flex_basis`]; flex growth and shrinkage can still change the final size."
        }
        "flex_grow" => {
            "Transitions the flex growth factor set by [`Styled::flex_grow`]. This is a unitless share of positive free space, not a size."
        }
        "flex_shrink" => {
            "Transitions the flex shrink factor set by [`Styled::flex_shrink`]. This is a unitless weight used when the line has negative free space."
        }
        "bg" => {
            "Transitions the background set by [`Styled::bg`]. Solid backgrounds interpolate as colors; gradients and other backgrounds do not have a color interpolation path and switch at the endpoint."
        }
        "border_color" => {
            "Transitions the border background set by [`Styled::border_color`]. Solid colors interpolate; gradients and other backgrounds switch at the endpoint."
        }
        "ring" => {
            "Transitions the outer ring width and color. Use [`StyleTransitions::ring_color`] to select a separate color motion; builder order controls the motion for the overlapping color field."
        }
        "ring_color" => {
            "Transitions the outer ring color set by [`Styled::ring_color`]. Solid colors interpolate; gradients and other backgrounds switch at the endpoint."
        }
        "inset_ring" => {
            "Transitions the inset ring width and color. Use [`StyleTransitions::inset_ring_color`] to select a separate color motion."
        }
        "inset_ring_color" => {
            "Transitions the inset ring color set by [`Styled::inset_ring_color`]. Solid colors interpolate; gradients and other backgrounds switch at the endpoint."
        }
        "text_color" => {
            "Transitions the optional text color set by [`Styled::text_color`]. Colors interpolate through sRGB; see [`Lerp`](crate::Lerp)."
        }
        "text_bg" => "Transitions the optional text background color set by [`Styled::text_bg`].",
        "text_size" => "Transitions the optional font size set by [`Styled::text_size`].",
        "line_height" => "Transitions the optional line height set by [`Styled::line_height`].",
        "letter_spacing" => {
            "Transitions the optional letter spacing set by [`Styled::letter_spacing`]."
        }
        "line_clamp" => {
            "Transitions the optional line clamp count set by [`Styled::line_clamp`]. The interpolated numeric value is converted back to an integer at each sample."
        }
        "opacity" => "Transitions the optional opacity set by [`Styled::opacity`].",
        "rounded_smoothing" => {
            "Transitions the corner-smoothing factor set by [`Styled::rounded_smoothing`], from 0 (circular corners) toward 1 (maximum smoothing)."
        }
        _ => "Transitions the corresponding style property when its authored value changes.",
    }
}

fn generate_transition_application(field: &CanonicalStyleTransitionField) -> TokenStream2 {
    let motion_name = &field.config_name;
    let path = &field.path;

    match field.kind {
        StyleTransitionFieldKind::Required => quote! {
            in_progress |= apply_required(
                &mut state.#path,
                &mut style.#path,
                self.#motion_name.as_ref(),
                now,
                reduce_motion,
            );
        },
        StyleTransitionFieldKind::Optional => quote! {
            in_progress |= apply_optional(
                &mut state.#path,
                &mut style.#path,
                self.#motion_name.as_ref(),
                now,
                reduce_motion,
            );
        },
        StyleTransitionFieldKind::InsetTop
        | StyleTransitionFieldKind::InsetRight
        | StyleTransitionFieldKind::InsetBottom
        | StyleTransitionFieldKind::InsetLeft => {
            let edge = match field.kind {
                StyleTransitionFieldKind::InsetTop => quote! { StyleTransitionEdge::Top },
                StyleTransitionFieldKind::InsetRight => quote! { StyleTransitionEdge::Right },
                StyleTransitionFieldKind::InsetBottom => quote! { StyleTransitionEdge::Bottom },
                StyleTransitionFieldKind::InsetLeft => quote! { StyleTransitionEdge::Left },
                _ => unreachable!(),
            };
            quote! {
            in_progress |= apply_inset(
                &mut state.#path,
                &mut style.#path,
                #edge,
                self.#motion_name.as_ref(),
                context,
                now,
                reduce_motion,
            );
            }
        }
        StyleTransitionFieldKind::AutoSizeWidth => quote! {
            in_progress |= apply_auto_size(
                &mut state.#path,
                &mut style.#path,
                StyleTransitionAxis::Width,
                self.#motion_name.as_ref(),
                context,
                now,
                reduce_motion,
            );
        },
        StyleTransitionFieldKind::AutoSizeHeight => quote! {
            in_progress |= apply_auto_size(
                &mut state.#path,
                &mut style.#path,
                StyleTransitionAxis::Height,
                self.#motion_name.as_ref(),
                context,
                now,
                reduce_motion,
            );
        },
        StyleTransitionFieldKind::CornerRadius => quote! {
            let target = context.bounds.map(|bounds| {
                let max_corner_radius = std::cmp::min(
                    bounds.size.width,
                    bounds.size.height,
                ) / 2.0;

                crate::AbsoluteLength::Pixels(std::cmp::min(
                    style.#path.to_pixels(context.rem_size),
                    max_corner_radius,
                ))
            });

            in_progress |= apply_required_target(
                &mut state.#path,
                &mut style.#path,
                target,
                self.#motion_name.as_ref(),
                now,
                reduce_motion,
            );
        },
    }
}

fn style_transition_specs() -> Vec<StyleTransitionSpec> {
    let mut specs = Vec::new();

    for prefix in box_prefixes()
        .into_iter()
        .chain(margin_box_style_prefixes())
        .chain(padding_box_style_prefixes())
        .chain(position_box_style_prefixes())
    {
        specs.push(StyleTransitionSpec {
            name: prefix.prefix,
            fields: prefix
                .fields
                .into_iter()
                .map(StyleTransitionField::required_or_special_length)
                .collect(),
        });
    }

    for prefix in corner_prefixes() {
        specs.push(StyleTransitionSpec {
            name: prefix.prefix,
            fields: prefix
                .fields
                .into_iter()
                .map(StyleTransitionField::corner_radius)
                .collect(),
        });
    }

    for prefix in border_prefixes() {
        specs.push(StyleTransitionSpec {
            name: prefix.prefix,
            fields: prefix
                .fields
                .into_iter()
                .map(StyleTransitionField::required)
                .collect(),
        });
    }

    specs.extend([
        StyleTransitionSpec {
            name: "scrollbar_width",
            fields: vec![StyleTransitionField::required(quote! { scrollbar_width })],
        },
        StyleTransitionSpec {
            name: "aspect_ratio",
            fields: vec![StyleTransitionField::optional(quote! { aspect_ratio })],
        },
        StyleTransitionSpec {
            name: "flex_basis",
            fields: vec![StyleTransitionField::required(quote! { flex_basis })],
        },
        StyleTransitionSpec {
            name: "flex_grow",
            fields: vec![StyleTransitionField::required(quote! { flex_grow })],
        },
        StyleTransitionSpec {
            name: "flex_shrink",
            fields: vec![StyleTransitionField::required(quote! { flex_shrink })],
        },
        StyleTransitionSpec {
            name: "bg",
            fields: vec![StyleTransitionField::optional(quote! { background })],
        },
        StyleTransitionSpec {
            name: "border_color",
            fields: vec![StyleTransitionField::optional(quote! { border_color })],
        },
        StyleTransitionSpec {
            name: "ring",
            fields: vec![
                StyleTransitionField::required(quote! { ring.width }),
                StyleTransitionField::required(quote! { ring.color }),
            ],
        },
        StyleTransitionSpec {
            name: "ring_color",
            fields: vec![StyleTransitionField::required(quote! { ring.color })],
        },
        StyleTransitionSpec {
            name: "inset_ring",
            fields: vec![
                StyleTransitionField::required(quote! { inset_ring.width }),
                StyleTransitionField::required(quote! { inset_ring.color }),
            ],
        },
        StyleTransitionSpec {
            name: "inset_ring_color",
            fields: vec![StyleTransitionField::required(quote! { inset_ring.color })],
        },
        StyleTransitionSpec {
            name: "text_color",
            fields: vec![StyleTransitionField::optional(quote! { text.color })],
        },
        StyleTransitionSpec {
            name: "text_bg",
            fields: vec![StyleTransitionField::optional(
                quote! { text.background_color },
            )],
        },
        StyleTransitionSpec {
            name: "text_size",
            fields: vec![StyleTransitionField::optional(quote! { text.font_size })],
        },
        StyleTransitionSpec {
            name: "line_height",
            fields: vec![StyleTransitionField::optional(quote! { text.line_height })],
        },
        StyleTransitionSpec {
            name: "letter_spacing",
            fields: vec![StyleTransitionField::optional(
                quote! { text.letter_spacing },
            )],
        },
        StyleTransitionSpec {
            name: "line_clamp",
            fields: vec![StyleTransitionField::optional(quote! { text.line_clamp })],
        },
        StyleTransitionSpec {
            name: "opacity",
            fields: vec![StyleTransitionField::optional(quote! { opacity })],
        },
        StyleTransitionSpec {
            name: "rounded_smoothing",
            fields: vec![StyleTransitionField::optional(quote! { corner_smoothing })],
        },
    ]);

    specs
}

pub fn visibility_style_methods(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as StyleableMacroInput);
    let visibility = input.method_visibility;
    let output = quote! {
        /// Paints the element normally and keeps it in layout.
        /// [Docs](https://tailwindcss.com/docs/visibility)
        #visibility fn visible(mut self) -> Self {
            self.style().visibility = Some(gpui::Visibility::Visible);
            self
        }

        /// Hides the element's drawing while preserving its layout space and child layout.
        /// Use [`crate::Display::None`] when the element should be omitted from layout entirely.
        /// [Docs](https://tailwindcss.com/docs/visibility)
        #visibility fn invisible(mut self) -> Self {
            self.style().visibility = Some(gpui::Visibility::Hidden);
            self
        }
    };

    output.into()
}

pub fn margin_style_methods(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as StyleableMacroInput);
    let methods = generate_box_style_methods(
        margin_box_style_prefixes(),
        box_style_suffixes(),
        input.method_visibility,
    );
    let output = quote! {
        #(#methods)*
    };

    output.into()
}

pub fn padding_style_methods(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as StyleableMacroInput);
    let methods = generate_box_style_methods(
        padding_box_style_prefixes(),
        box_style_suffixes(),
        input.method_visibility,
    );
    let output = quote! {
        #(#methods)*
    };

    output.into()
}

pub fn position_style_methods(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as StyleableMacroInput);
    let visibility = input.method_visibility;
    let methods = generate_box_style_methods(
        position_box_style_prefixes(),
        box_style_suffixes(),
        visibility.clone(),
    );
    let output = quote! {
        /// Keeps the element in normal layout and applies inset offsets after layout.
        /// Offsets do not move neighboring elements. Relative is GPUI's default position mode.
        /// [Docs](https://tailwindcss.com/docs/position)
        #visibility fn relative(mut self) -> Self {
            self.style().position = Some(gpui::Position::Relative);
            self
        }

        /// Positions the element independently of its siblings within its layout parent.
        ///
        /// The parent does not reserve space for it. Set offsets with [`Self::top`],
        /// [`Self::left`], or their counterparts; its size still follows layout constraints.
        /// Use [`crate::Display::None`] to remove both layout and painting.
        /// [Docs](https://tailwindcss.com/docs/position)
        #visibility fn absolute(mut self) -> Self {
            self.style().position = Some(gpui::Position::Absolute);
            self
        }

        #(#methods)*
    };

    output.into()
}

pub fn overflow_style_methods(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as StyleableMacroInput);
    let visibility = input.method_visibility;
    let output = quote! {
        /// Clips overflowing content on both axes. Unlike `invisible`, clipping does not hide the
        /// element itself; unlike [`crate::Display::None`], it does not remove layout space.
        /// [Docs](https://tailwindcss.com/docs/overflow#hiding-content-that-overflows)
        #visibility fn overflow_hidden(mut self) -> Self {
            self.style().overflow.x = Some(gpui::Overflow::Hidden);
            self.style().overflow.y = Some(gpui::Overflow::Hidden);
            self
        }

        /// Clips horizontal overflow while leaving the vertical overflow setting unchanged.
        /// [Docs](https://tailwindcss.com/docs/overflow#hiding-content-that-overflows)
        #visibility fn overflow_x_hidden(mut self) -> Self {
            self.style().overflow.x = Some(gpui::Overflow::Hidden);
            self
        }

        /// Clips vertical overflow while leaving the horizontal overflow setting unchanged.
        /// [Docs](https://tailwindcss.com/docs/overflow#hiding-content-that-overflows)
        #visibility fn overflow_y_hidden(mut self) -> Self {
            self.style().overflow.y = Some(gpui::Overflow::Hidden);
            self
        }
    };

    output.into()
}

pub fn cursor_style_methods(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as StyleableMacroInput);
    let visibility = input.method_visibility;
    let output = quote! {
        /// Sets the pointer cursor used while the pointer hovers over this element.
        #visibility fn cursor(mut self, cursor: CursorStyle) -> Self {
            self.style().mouse_cursor = Some(cursor);
            self
        }

        /// Uses the platform's default arrow cursor while hovering this element.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_default(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::Arrow);
            self
        }

        /// Uses a pointing-hand cursor while hovering this element.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_pointer(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::PointingHand);
            self
        }

        /// Uses a text insertion cursor while hovering this element.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_text(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::IBeam);
            self
        }

        /// Uses GPUI's closed-hand cursor while hovering this element (the platform's grabbing cursor).
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_move(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ClosedHand);
            self
        }

        /// Uses the platform's operation-not-allowed cursor while hovering this element.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_not_allowed(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::OperationNotAllowed);
            self
        }

        /// Uses the platform's contextual-menu cursor while hovering this element.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_context_menu(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ContextualMenu);
            self
        }

        /// Uses a crosshair cursor while hovering this element.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_crosshair(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::Crosshair);
            self
        }

        /// Uses the vertical-layout text cursor while hovering this element.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_vertical_text(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::IBeamCursorForVerticalLayout);
            self
        }

        /// Uses GPUI's drag-link cursor while hovering this element.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_alias(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::DragLink);
            self
        }

        /// Uses GPUI's drag-copy cursor while hovering this element.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_copy(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::DragCopy);
            self
        }

        /// Uses the same operation-not-allowed cursor as [`cursor_not_allowed`](Styled::cursor_not_allowed).
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_no_drop(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::OperationNotAllowed);
            self
        }

        /// Uses an open-hand cursor while hovering this element (the platform's grab cursor).
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_grab(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::OpenHand);
            self
        }

        /// Uses a closed-hand cursor while hovering this element (the platform's grabbing cursor).
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_grabbing(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ClosedHand);
            self
        }

        /// Sets cursor style when hovering over an element to `ew-resize`.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_ew_resize(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ResizeLeftRight);
            self
        }

        /// Sets cursor style when hovering over an element to `ns-resize`.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_ns_resize(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ResizeUpDown);
            self
        }

        /// Sets cursor style when hovering over an element to `nesw-resize`.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_nesw_resize(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ResizeUpRightDownLeft);
            self
        }

        /// Sets cursor style when hovering over an element to `nwse-resize`.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_nwse_resize(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ResizeUpLeftDownRight);
            self
        }

        /// Sets cursor style when hovering over an element to `col-resize`.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_col_resize(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ResizeColumn);
            self
        }

        /// Sets cursor style when hovering over an element to `row-resize`.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_row_resize(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ResizeRow);
            self
        }

        /// Sets cursor style when hovering over an element to `n-resize`.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_n_resize(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ResizeUp);
            self
        }

        /// Sets cursor style when hovering over an element to `e-resize`.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_e_resize(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ResizeRight);
            self
        }

        /// Sets cursor style when hovering over an element to `s-resize`.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_s_resize(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ResizeDown);
            self
        }

        /// Sets cursor style when hovering over an element to `w-resize`.
        /// [Docs](https://tailwindcss.com/docs/cursor)
        #visibility fn cursor_w_resize(mut self) -> Self {
            self.style().mouse_cursor = Some(gpui::CursorStyle::ResizeLeft);
            self
        }

    };

    output.into()
}

pub fn border_style_methods(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as StyleableMacroInput);
    let visibility = input.method_visibility;

    let mut methods = Vec::new();

    for border_style_prefix in border_prefixes() {
        methods.push(generate_custom_value_setter(
            visibility.clone(),
            border_style_prefix.prefix,
            quote! { AbsoluteLength },
            &border_style_prefix.fields,
            border_style_prefix.doc_string_prefix,
        ));

        for border_style_suffix in border_suffixes() {
            methods.push(generate_predefined_setter(
                visibility.clone(),
                border_style_prefix.prefix,
                border_style_suffix.suffix,
                &border_style_prefix.fields,
                &border_style_suffix.width_tokens,
                false,
                &format!(
                    "{prefix}\n\n{suffix}",
                    prefix = border_style_prefix.doc_string_prefix,
                    suffix = border_style_suffix.doc_string_suffix,
                ),
            ));
        }
    }

    let output = quote! {
        /// Sets the background painted in the border. This accepts a solid color or gradient;
        /// width and border style are configured separately.
        #visibility fn border_color<C>(mut self, border_color: C) -> Self
        where
            C: Into<gpui::Background>,
            Self: Sized,
        {
            self.style().border_color = Some(border_color.into());
            self
        }

        #(#methods)*
    };

    output.into()
}

pub fn box_shadow_style_methods(input: TokenStream) -> TokenStream {
    let input = parse_macro_input!(input as StyleableMacroInput);
    let visibility = input.method_visibility;
    let ring_width_methods = border_suffixes()
        .into_iter()
        .filter(|suffix| matches!(suffix.suffix, "0" | "1" | "2" | "4" | "8"))
        .flat_map(|suffix| {
            let visibility = visibility.clone();
            ["ring", "inset_ring"].map(move |prefix| {
                let visibility = visibility.clone();
                let width = suffix.width_tokens.clone();
                let width_doc = suffix.doc_string_suffix;
                let method = format_ident!("{}_{}", prefix, suffix.suffix);
                let field = format_ident!("{}", prefix);
                quote! {
                    #[doc = concat!("Sets the ", #prefix, " width to ", #width_doc, ". The unit is logical pixels. Ring color remains unchanged.")]
                    /// [Docs](https://tailwindcss.com/docs/box-shadow)
                    #visibility fn #method(mut self) -> Self {
                        use gpui::px;
                        self.style().#field.width = Some(#width);
                        self
                    }
                }
            })
        });

    let output = quote! {
        /// Replaces the element's box-shadow list with `shadows`. Use multiple [`BoxShadow`](gpui::BoxShadow) values for layered shadows; use [`shadow_none`](Styled::shadow_none) to clear them.
        /// [Docs](https://tailwindcss.com/docs/box-shadow)
        #visibility fn shadow(mut self, shadows: std::vec::Vec<gpui::BoxShadow>) -> Self {
            self.style().box_shadow = Some(shadows);
            self
        }

        /// Replaces the box-shadow list with an empty list, clearing all shadows.
        /// [Docs](https://tailwindcss.com/docs/box-shadow)
        #visibility fn shadow_none(mut self) -> Self {
            self.style().box_shadow = Some(Default::default());
            self
        }

        /// Sets the outer ring width in logical pixels. The ring is painted outside the border;
        /// this leaves its color unchanged.
        /// [Docs](https://tailwindcss.com/docs/box-shadow#using-a-custom-value)
        #visibility fn ring(mut self, width: impl Into<gpui::Pixels>) -> Self {
            self.style().ring.width = Some(width.into());
            self
        }

        /// Sets the outer ring color or gradient, leaving its width unchanged.
        /// [Docs](https://tailwindcss.com/docs/box-shadow#setting-the-ring-color)
        #visibility fn ring_color<C>(mut self, color: C) -> Self
        where
            C: Into<gpui::Background>,
            Self: Sized,
        {
            self.style().ring.color = Some(gpui::RingColor::Color(color.into()));
            self
        }

        /// Sets the inset ring width in logical pixels. The ring is painted inside the border;
        /// this leaves its color unchanged.
        /// [Docs](https://tailwindcss.com/docs/box-shadow#using-a-custom-value)
        #visibility fn inset_ring(mut self, width: impl Into<gpui::Pixels>) -> Self {
            self.style().inset_ring.width = Some(width.into());
            self
        }

        /// Sets the inset ring color or gradient, leaving its width unchanged.
        /// [Docs](https://tailwindcss.com/docs/box-shadow#setting-the-inset-ring-color)
        #visibility fn inset_ring_color<C>(mut self, color: C) -> Self
        where
            C: Into<gpui::Background>,
            Self: Sized,
        {
            self.style().inset_ring.color = Some(gpui::RingColor::Color(color.into()));
            self
        }

        #(#ring_width_methods)*

        /// Replaces all existing shadows with a small, low-opacity preset shadow.
        /// [Docs](https://tailwindcss.com/docs/box-shadow)
        #visibility fn shadow_2xs(mut self) -> Self {
            use gpui::{BoxShadow, hsla, px};
            use std::vec;

            self.style().box_shadow = Some(vec![
                BoxShadow::new(px(0.), px(1.), hsla(0., 0., 0., 0.05))
            ]);
            self
        }

        /// Replaces all existing shadows with a compact preset shadow.
        /// [Docs](https://tailwindcss.com/docs/box-shadow)
        #visibility fn shadow_xs(mut self) -> Self {
            use gpui::{BoxShadow, hsla, px};
            use std::vec;

            self.style().box_shadow = Some(vec![
                BoxShadow::new(px(0.), px(1.), hsla(0., 0., 0., 0.05)).blur_radius(px(2.))
            ]);
            self
        }

        /// Replaces all existing shadows with a two-layer small preset shadow.
        /// [Docs](https://tailwindcss.com/docs/box-shadow)
        #visibility fn shadow_sm(mut self) -> Self {
            use gpui::{BoxShadow, hsla, px};
            use std::vec;

            self.style().box_shadow = Some(vec![
                BoxShadow::new(px(0.), px(1.), hsla(0., 0., 0., 0.1)).blur_radius(px(3.)),
                BoxShadow::new(px(0.), px(1.), hsla(0., 0., 0., 0.1)).blur_radius(px(2.)).spread_radius(px(-1.)),
            ]);
            self
        }

        /// Replaces all existing shadows with a two-layer medium preset shadow.
        /// [Docs](https://tailwindcss.com/docs/box-shadow)
        #visibility fn shadow_md(mut self) -> Self {
            use gpui::{BoxShadow, hsla, px};
            use std::vec;

            self.style().box_shadow = Some(vec![
                BoxShadow::new(px(0.), px(4.), hsla(0., 0., 0., 0.1)).blur_radius(px(6.)).spread_radius(px(-1.)),
                BoxShadow::new(px(0.), px(2.), hsla(0., 0., 0., 0.1)).blur_radius(px(4.)).spread_radius(px(-2.)),
            ]);
            self
        }

        /// Replaces all existing shadows with a two-layer large preset shadow.
        /// [Docs](https://tailwindcss.com/docs/box-shadow)
        #visibility fn shadow_lg(mut self) -> Self {
            use gpui::{BoxShadow, hsla, px};
            use std::vec;

            self.style().box_shadow = Some(vec![
                BoxShadow::new(px(0.), px(10.), hsla(0., 0., 0., 0.1)).blur_radius(px(15.)).spread_radius(px(-3.)),
                BoxShadow::new(px(0.), px(4.), hsla(0., 0., 0., 0.1)).blur_radius(px(6.)).spread_radius(px(-4.)),
            ]);
            self
        }

        /// Replaces all existing shadows with a two-layer extra-large preset shadow.
        /// [Docs](https://tailwindcss.com/docs/box-shadow)
        #visibility fn shadow_xl(mut self) -> Self {
            use gpui::{BoxShadow, hsla, px};
            use std::vec;

            self.style().box_shadow = Some(vec![
                BoxShadow::new(px(0.), px(20.), hsla(0., 0., 0., 0.1)).blur_radius(px(25.)).spread_radius(px(-5.)),
                BoxShadow::new(px(0.), px(8.), hsla(0., 0., 0., 0.1)).blur_radius(px(10.)).spread_radius(px(-6.)),
            ]);
            self
        }

        /// Replaces all existing shadows with a large, diffuse preset shadow.
        /// [Docs](https://tailwindcss.com/docs/box-shadow)
        #visibility fn shadow_2xl(mut self) -> Self {
            use gpui::{BoxShadow, hsla, px};
            use std::vec;

            self.style().box_shadow = Some(vec![
                BoxShadow::new(px(0.), px(25.), hsla(0., 0., 0., 0.25)).blur_radius(px(50.)).spread_radius(px(-12.))
            ]);
            self
        }
    };

    output.into()
}

struct BoxStylePrefix {
    prefix: &'static str,
    auto_allowed: bool,
    fields: Vec<TokenStream2>,
    doc_string_prefix: &'static str,
}

struct BoxStyleSuffix {
    suffix: &'static str,
    length_tokens: TokenStream2,
    doc_string_suffix: &'static str,
}

struct CornerStylePrefix {
    prefix: &'static str,
    fields: Vec<TokenStream2>,
    doc_string_prefix: &'static str,
}

struct CornerStyleSuffix {
    suffix: &'static str,
    radius_tokens: TokenStream2,
    doc_string_suffix: &'static str,
}

struct CornerSmoothingStyleSuffix {
    suffix: &'static str,
    amount_tokens: TokenStream2,
    doc_string: &'static str,
}

struct BorderStylePrefix {
    prefix: &'static str,
    fields: Vec<TokenStream2>,
    doc_string_prefix: &'static str,
}

struct BorderStyleSuffix {
    suffix: &'static str,
    width_tokens: TokenStream2,
    doc_string_suffix: &'static str,
}

fn generate_box_style_methods(
    prefixes: Vec<BoxStylePrefix>,
    suffixes: Vec<BoxStyleSuffix>,
    visibility: Visibility,
) -> Vec<TokenStream2> {
    let mut methods = Vec::new();

    for box_style_prefix in prefixes {
        methods.push(generate_custom_value_setter(
            visibility.clone(),
            box_style_prefix.prefix,
            if box_style_prefix.auto_allowed {
                quote! { Length }
            } else {
                quote! { DefiniteLength }
            },
            &box_style_prefix.fields,
            box_style_prefix.doc_string_prefix,
        ));

        for box_style_suffix in &suffixes {
            if box_style_suffix.suffix != "auto" || box_style_prefix.auto_allowed {
                methods.push(generate_predefined_setter(
                    visibility.clone(),
                    box_style_prefix.prefix,
                    box_style_suffix.suffix,
                    &box_style_prefix.fields,
                    &box_style_suffix.length_tokens,
                    false,
                    &format!(
                        "{prefix}\n\nPreset: {suffix}. Pixel equivalents for rem values assume a 16px root font size; see [`Rems`](gpui::Rems).",
                        prefix = box_style_prefix.doc_string_prefix,
                        suffix = box_style_suffix.doc_string_suffix,
                    ),
                ));
            }

            if box_style_suffix.suffix != "auto" {
                methods.push(generate_predefined_setter(
                    visibility.clone(),
                    box_style_prefix.prefix,
                    box_style_suffix.suffix,
                    &box_style_prefix.fields,
                    &box_style_suffix.length_tokens,
                    true,
                    &format!(
                        "{prefix}\n\nPreset: {suffix}. Pixel equivalents for rem values assume a 16px root font size; see [`Rems`](gpui::Rems).",
                        prefix = box_style_prefix.doc_string_prefix,
                        suffix = box_style_suffix.doc_string_suffix,
                    ),
                ));
            }
        }
    }

    methods
}

fn generate_methods() -> Vec<TokenStream2> {
    let visibility = Visibility::Inherited;
    let mut methods =
        generate_box_style_methods(box_prefixes(), box_style_suffixes(), visibility.clone());

    for corner_style_prefix in corner_prefixes() {
        methods.push(generate_custom_value_setter(
            visibility.clone(),
            corner_style_prefix.prefix,
            quote! { AbsoluteLength },
            &corner_style_prefix.fields,
            &format!(
                "{} Presets use the current root rem size; custom values accept `AbsoluteLength` in pixels or rems, not percentages. Rendering limits radii to fit the element's bounds.",
                corner_style_prefix.doc_string_prefix
            ),
        ));

        for corner_style_suffix in corner_suffixes() {
            methods.push(generate_predefined_setter(
                visibility.clone(),
                corner_style_prefix.prefix,
                corner_style_suffix.suffix,
                &corner_style_prefix.fields,
                &corner_style_suffix.radius_tokens,
                false,
                    &format!(
                        "{prefix}\n\n{suffix}\n\nCorner presets use the current root rem size except `none` (zero) and `full` (a 9999 logical-pixel radius). Rendering limits radii to fit the element's bounds.",
                        prefix = corner_style_prefix.doc_string_prefix,
                        suffix = corner_style_suffix.doc_string_suffix,
                ),
            ));
        }
    }

    methods.extend(generate_corner_smoothing_methods(visibility));

    methods
}

fn generate_corner_smoothing_methods(visibility: Visibility) -> Vec<TokenStream2> {
    corner_smoothing_suffixes()
        .into_iter()
        .map(|suffix| {
            let method_name = format_ident!("rounded_smoothing_{}", suffix.suffix);
            let amount_tokens = suffix.amount_tokens;
            let doc_string = format!(
                "{} Values range from 0 (circular corners) to 1 (maximum smoothing); this adjusts the shape of drawn corners, not their radius.",
                suffix.doc_string
            );

            quote! {
                #[doc = #doc_string]
                #visibility fn #method_name(mut self) -> Self {
                    self.style().corner_smoothing = Some(#amount_tokens);
                    self
                }
            }
        })
        .collect()
}

fn generate_predefined_setter(
    visibility: Visibility,
    name: &'static str,
    length: &'static str,
    fields: &[TokenStream2],
    length_tokens: &TokenStream2,
    negate: bool,
    doc_string: &str,
) -> TokenStream2 {
    let (negation_qualifier, negation_token) = if negate {
        ("_neg", quote! { - })
    } else {
        ("", quote! {})
    };

    let method_name = if length.is_empty() {
        format_ident!("{name}{negation_qualifier}")
    } else {
        format_ident!("{name}{negation_qualifier}_{length}")
    };

    let field_assignments = fields
        .iter()
        .map(|field_tokens| {
            quote! {
                style.#field_tokens = Some((#negation_token gpui::#length_tokens).into());
            }
        })
        .collect::<Vec<_>>();

    let doc_string = if negate {
        format!("{doc_string}\n\nSets the negative of the listed value.")
    } else {
        doc_string.to_owned()
    };

    let method = quote! {
        #[doc = #doc_string]
        #visibility fn #method_name(mut self) -> Self {
            let style = self.style();
            #(#field_assignments)*
            self
        }
    };

    method
}

fn generate_custom_value_setter(
    visibility: Visibility,
    prefix: &str,
    length_type: TokenStream2,
    fields: &[TokenStream2],
    doc_string: &str,
) -> TokenStream2 {
    let method_name = format_ident!("{}", prefix);

    let mut iter = fields.iter();
    let last = iter.next_back().unwrap();
    let field_assignments = iter
        .map(|field_tokens| {
            quote! {
                style.#field_tokens = Some(length.clone().into());
            }
        })
        .chain(std::iter::once(quote! {
            style.#last = Some(length.into());
        }))
        .collect::<Vec<_>>();

    let method = quote! {
        #[doc = #doc_string]
        #visibility fn #method_name(mut self, length: impl std::clone::Clone + Into<gpui::#length_type>) -> Self {
            let style = self.style();
            #(#field_assignments)*
            self
        }
    };

    method
}

fn margin_box_style_prefixes() -> Vec<BoxStylePrefix> {
    vec![
        BoxStylePrefix {
            prefix: "m",
            auto_allowed: true,
            fields: vec![
                quote! { margin.top },
                quote! { margin.bottom },
                quote! { margin.left },
                quote! { margin.right },
            ],
            doc_string_prefix: "Sets all four margins. Accepts pixels, rems, relative lengths, or `auto`; see [`Length`](gpui::Length). [Margin notation](https://tailwindcss.com/docs/margin)",
        },
        BoxStylePrefix {
            prefix: "mt",
            auto_allowed: true,
            fields: vec![quote! { margin.top }],
            doc_string_prefix: "Sets the top margin, preserving the other sides. Accepts pixels, rems, relative lengths, or `auto`. [Margin notation](https://tailwindcss.com/docs/margin#add-margin-to-a-single-side)",
        },
        BoxStylePrefix {
            prefix: "mb",
            auto_allowed: true,
            fields: vec![quote! { margin.bottom }],
            doc_string_prefix: "Sets the bottom margin, preserving the other sides. Accepts pixels, rems, relative lengths, or `auto`. [Margin notation](https://tailwindcss.com/docs/margin#add-margin-to-a-single-side)",
        },
        BoxStylePrefix {
            prefix: "my",
            auto_allowed: true,
            fields: vec![quote! { margin.top }, quote! { margin.bottom }],
            doc_string_prefix: "Sets top and bottom margins, preserving left and right. Accepts pixels, rems, relative lengths, or `auto`. [Margin notation](https://tailwindcss.com/docs/margin#add-vertical-margin)",
        },
        BoxStylePrefix {
            prefix: "mx",
            auto_allowed: true,
            fields: vec![quote! { margin.left }, quote! { margin.right }],
            doc_string_prefix: "Sets left and right margins, preserving top and bottom. Accepts pixels, rems, relative lengths, or `auto`. [Margin notation](https://tailwindcss.com/docs/margin#add-horizontal-margin)",
        },
        BoxStylePrefix {
            prefix: "ml",
            auto_allowed: true,
            fields: vec![quote! { margin.left }],
            doc_string_prefix: "Sets the left margin, preserving the other sides. Accepts pixels, rems, relative lengths, or `auto`. [Margin notation](https://tailwindcss.com/docs/margin#add-margin-to-a-single-side)",
        },
        BoxStylePrefix {
            prefix: "mr",
            auto_allowed: true,
            fields: vec![quote! { margin.right }],
            doc_string_prefix: "Sets the right margin, preserving the other sides. Accepts pixels, rems, relative lengths, or `auto`. [Margin notation](https://tailwindcss.com/docs/margin#add-margin-to-a-single-side)",
        },
    ]
}

fn padding_box_style_prefixes() -> Vec<BoxStylePrefix> {
    vec![
        BoxStylePrefix {
            prefix: "p",
            auto_allowed: false,
            fields: vec![
                quote! { padding.top },
                quote! { padding.bottom },
                quote! { padding.left },
                quote! { padding.right },
            ],
            doc_string_prefix: "Sets the padding of the element. [Docs](https://tailwindcss.com/docs/padding)",
        },
        BoxStylePrefix {
            prefix: "pt",
            auto_allowed: false,
            fields: vec![quote! { padding.top }],
            doc_string_prefix: "Sets the top padding of the element. [Docs](https://tailwindcss.com/docs/padding#add-padding-to-a-single-side)",
        },
        BoxStylePrefix {
            prefix: "pb",
            auto_allowed: false,
            fields: vec![quote! { padding.bottom }],
            doc_string_prefix: "Sets the bottom padding of the element. [Docs](https://tailwindcss.com/docs/padding#add-padding-to-a-single-side)",
        },
        BoxStylePrefix {
            prefix: "px",
            auto_allowed: false,
            fields: vec![quote! { padding.left }, quote! { padding.right }],
            doc_string_prefix: "Sets the horizontal padding of the element. [Docs](https://tailwindcss.com/docs/padding#add-horizontal-padding)",
        },
        BoxStylePrefix {
            prefix: "py",
            auto_allowed: false,
            fields: vec![quote! { padding.top }, quote! { padding.bottom }],
            doc_string_prefix: "Sets the vertical padding of the element. [Docs](https://tailwindcss.com/docs/padding#add-vertical-padding)",
        },
        BoxStylePrefix {
            prefix: "pl",
            auto_allowed: false,
            fields: vec![quote! { padding.left }],
            doc_string_prefix: "Sets the left padding of the element. [Docs](https://tailwindcss.com/docs/padding#add-padding-to-a-single-side)",
        },
        BoxStylePrefix {
            prefix: "pr",
            auto_allowed: false,
            fields: vec![quote! { padding.right }],
            doc_string_prefix: "Sets the right padding of the element. [Docs](https://tailwindcss.com/docs/padding#add-padding-to-a-single-side)",
        },
    ]
}

fn position_box_style_prefixes() -> Vec<BoxStylePrefix> {
    vec![
        BoxStylePrefix {
            prefix: "inset",
            auto_allowed: true,
            fields: vec![
                quote! { inset.top },
                quote! { inset.right },
                quote! { inset.bottom },
                quote! { inset.left },
            ],
            doc_string_prefix: "Sets all four offsets of a positioned element. Offsets require `relative()` or `absolute()`; relative lengths resolve against the containing block, and `auto` leaves that edge to layout. [Docs](https://tailwindcss.com/docs/top-right-bottom-left)",
        },
        BoxStylePrefix {
            prefix: "top",
            auto_allowed: true,
            fields: vec![quote! { inset.top }],
            doc_string_prefix: "Sets the top offset of a positioned element. Offsets require `relative()` or `absolute()`; relative lengths resolve against the containing block, and `auto` leaves that edge to layout. [Docs](https://tailwindcss.com/docs/top-right-bottom-left)",
        },
        BoxStylePrefix {
            prefix: "bottom",
            auto_allowed: true,
            fields: vec![quote! { inset.bottom }],
            doc_string_prefix: "Sets the bottom offset of a positioned element. Offsets require `relative()` or `absolute()`; relative lengths resolve against the containing block, and `auto` leaves that edge to layout. [Docs](https://tailwindcss.com/docs/top-right-bottom-left)",
        },
        BoxStylePrefix {
            prefix: "left",
            auto_allowed: true,
            fields: vec![quote! { inset.left }],
            doc_string_prefix: "Sets the left offset of a positioned element. Offsets require `relative()` or `absolute()`; relative lengths resolve against the containing block, and `auto` leaves that edge to layout. [Docs](https://tailwindcss.com/docs/top-right-bottom-left)",
        },
        BoxStylePrefix {
            prefix: "right",
            auto_allowed: true,
            fields: vec![quote! { inset.right }],
            doc_string_prefix: "Sets the right offset of a positioned element. Offsets require `relative()` or `absolute()`; relative lengths resolve against the containing block, and `auto` leaves that edge to layout. [Docs](https://tailwindcss.com/docs/top-right-bottom-left)",
        },
    ]
}

fn box_prefixes() -> Vec<BoxStylePrefix> {
    vec![
        BoxStylePrefix {
            prefix: "w",
            auto_allowed: true,
            fields: vec![quote! { size.width }],
            doc_string_prefix: "Sets preferred width. Flex layout may shrink it to satisfy available space unless constrained by minimum width. `auto` uses intrinsic/layout sizing. [Docs](https://tailwindcss.com/docs/width)",
        },
        BoxStylePrefix {
            prefix: "h",
            auto_allowed: true,
            fields: vec![quote! { size.height }],
            doc_string_prefix: "Sets preferred height. Flex layout may shrink it to satisfy available space unless constrained by minimum height. `auto` uses intrinsic/layout sizing. [Docs](https://tailwindcss.com/docs/height)",
        },
        BoxStylePrefix {
            prefix: "size",
            auto_allowed: true,
            fields: vec![quote! {size.width}, quote! {size.height}],
            doc_string_prefix: "Sets preferred width and height. Flex layout may shrink either dimension to satisfy available space unless constrained by minimum size. `auto` uses intrinsic/layout sizing.",
        },
        BoxStylePrefix {
            prefix: "min_size",
            auto_allowed: true,
            fields: vec![quote! {min_size.width}, quote! {min_size.height}],
            doc_string_prefix: "Sets the lower bounds on width and height. These constraints can prevent flex shrinkage from reducing the element below the chosen size.",
        },
        BoxStylePrefix {
            prefix: "min_w",
            auto_allowed: true,
            fields: vec![quote! { min_size.width }],
            doc_string_prefix: "Sets the lower bound on width. This constraint can prevent flex shrinkage from reducing the element below the chosen size. [Docs](https://tailwindcss.com/docs/min-width)",
        },
        // TODO: These don't use the same size ramp as the others
        // see https://tailwindcss.com/docs/max-width
        BoxStylePrefix {
            prefix: "min_h",
            auto_allowed: true,
            fields: vec![quote! { min_size.height }],
            doc_string_prefix: "Sets the lower bound on height. This constraint can prevent flex shrinkage from reducing the element below the chosen size. [Docs](https://tailwindcss.com/docs/min-height)",
        },
        BoxStylePrefix {
            prefix: "max_size",
            auto_allowed: true,
            fields: vec![quote! {max_size.width}, quote! {max_size.height}],
            doc_string_prefix: "Sets the upper bounds on width and height; layout does not grow either dimension beyond these limits.",
        },
        // TODO: These don't use the same size ramp as the others
        // see https://tailwindcss.com/docs/max-width
        BoxStylePrefix {
            prefix: "max_w",
            auto_allowed: true,
            fields: vec![quote! { max_size.width }],
            doc_string_prefix: "Sets the upper bound on width; layout does not grow the element beyond this limit. [Docs](https://tailwindcss.com/docs/max-width)",
        },
        // TODO: These don't use the same size ramp as the others
        // see https://tailwindcss.com/docs/max-width
        BoxStylePrefix {
            prefix: "max_h",
            auto_allowed: true,
            fields: vec![quote! { max_size.height }],
            doc_string_prefix: "Sets the upper bound on height; layout does not grow the element beyond this limit. [Docs](https://tailwindcss.com/docs/max-height)",
        },
        BoxStylePrefix {
            prefix: "gap",
            auto_allowed: false,
            fields: vec![quote! { gap.width }, quote! { gap.height }],
            doc_string_prefix: "Sets horizontal and vertical gaps between adjacent children in flex and grid layouts. Horizontal means left-to-right; vertical means top-to-bottom. [Docs](https://tailwindcss.com/docs/gap)",
        },
        BoxStylePrefix {
            prefix: "gap_x",
            auto_allowed: false,
            fields: vec![quote! { gap.width }],
            doc_string_prefix: "Sets the horizontal (left-to-right) gap between adjacent children in flex and grid layouts. In a row flow this is the main-axis gap; in a column flow it is the cross-axis gap. [Docs](https://tailwindcss.com/docs/gap#changing-row-and-column-gaps-independently)",
        },
        BoxStylePrefix {
            prefix: "gap_y",
            auto_allowed: false,
            fields: vec![quote! { gap.height }],
            doc_string_prefix: "Sets the vertical (top-to-bottom) gap between adjacent children in flex and grid layouts. In a column flow this is the main-axis gap; in a row flow it is the cross-axis gap. [Docs](https://tailwindcss.com/docs/gap#changing-row-and-column-gaps-independently)",
        },
    ]
}

fn box_style_suffixes() -> Vec<BoxStyleSuffix> {
    vec![
        BoxStyleSuffix {
            suffix: "0",
            length_tokens: quote! { px(0.) },
            doc_string_suffix: "0px",
        },
        BoxStyleSuffix {
            suffix: "0p5",
            length_tokens: quote! { rems(0.125) },
            doc_string_suffix: "2px (0.125rem)",
        },
        BoxStyleSuffix {
            suffix: "1",
            length_tokens: quote! { rems(0.25) },
            doc_string_suffix: "4px (0.25rem)",
        },
        BoxStyleSuffix {
            suffix: "1p5",
            length_tokens: quote! { rems(0.375) },
            doc_string_suffix: "6px (0.375rem)",
        },
        BoxStyleSuffix {
            suffix: "2",
            length_tokens: quote! { rems(0.5) },
            doc_string_suffix: "8px (0.5rem)",
        },
        BoxStyleSuffix {
            suffix: "2p5",
            length_tokens: quote! { rems(0.625) },
            doc_string_suffix: "10px (0.625rem)",
        },
        BoxStyleSuffix {
            suffix: "3",
            length_tokens: quote! { rems(0.75) },
            doc_string_suffix: "12px (0.75rem)",
        },
        BoxStyleSuffix {
            suffix: "3p5",
            length_tokens: quote! { rems(0.875) },
            doc_string_suffix: "14px (0.875rem)",
        },
        BoxStyleSuffix {
            suffix: "4",
            length_tokens: quote! { rems(1.) },
            doc_string_suffix: "16px (1rem)",
        },
        BoxStyleSuffix {
            suffix: "5",
            length_tokens: quote! { rems(1.25) },
            doc_string_suffix: "20px (1.25rem)",
        },
        BoxStyleSuffix {
            suffix: "6",
            length_tokens: quote! { rems(1.5) },
            doc_string_suffix: "24px (1.5rem)",
        },
        BoxStyleSuffix {
            suffix: "7",
            length_tokens: quote! { rems(1.75) },
            doc_string_suffix: "28px (1.75rem)",
        },
        BoxStyleSuffix {
            suffix: "8",
            length_tokens: quote! { rems(2.0) },
            doc_string_suffix: "32px (2rem)",
        },
        BoxStyleSuffix {
            suffix: "9",
            length_tokens: quote! { rems(2.25) },
            doc_string_suffix: "36px (2.25rem)",
        },
        BoxStyleSuffix {
            suffix: "10",
            length_tokens: quote! { rems(2.5) },
            doc_string_suffix: "40px (2.5rem)",
        },
        BoxStyleSuffix {
            suffix: "11",
            length_tokens: quote! { rems(2.75) },
            doc_string_suffix: "44px (2.75rem)",
        },
        BoxStyleSuffix {
            suffix: "12",
            length_tokens: quote! { rems(3.) },
            doc_string_suffix: "48px (3rem)",
        },
        BoxStyleSuffix {
            suffix: "16",
            length_tokens: quote! { rems(4.) },
            doc_string_suffix: "64px (4rem)",
        },
        BoxStyleSuffix {
            suffix: "20",
            length_tokens: quote! { rems(5.) },
            doc_string_suffix: "80px (5rem)",
        },
        BoxStyleSuffix {
            suffix: "24",
            length_tokens: quote! { rems(6.) },
            doc_string_suffix: "96px (6rem)",
        },
        BoxStyleSuffix {
            suffix: "32",
            length_tokens: quote! { rems(8.) },
            doc_string_suffix: "128px (8rem)",
        },
        BoxStyleSuffix {
            suffix: "40",
            length_tokens: quote! { rems(10.) },
            doc_string_suffix: "160px (10rem)",
        },
        BoxStyleSuffix {
            suffix: "48",
            length_tokens: quote! { rems(12.) },
            doc_string_suffix: "192px (12rem)",
        },
        BoxStyleSuffix {
            suffix: "56",
            length_tokens: quote! { rems(14.) },
            doc_string_suffix: "224px (14rem)",
        },
        BoxStyleSuffix {
            suffix: "64",
            length_tokens: quote! { rems(16.) },
            doc_string_suffix: "256px (16rem)",
        },
        BoxStyleSuffix {
            suffix: "72",
            length_tokens: quote! { rems(18.) },
            doc_string_suffix: "288px (18rem)",
        },
        BoxStyleSuffix {
            suffix: "80",
            length_tokens: quote! { rems(20.) },
            doc_string_suffix: "320px (20rem)",
        },
        BoxStyleSuffix {
            suffix: "96",
            length_tokens: quote! { rems(24.) },
            doc_string_suffix: "384px (24rem)",
        },
        BoxStyleSuffix {
            suffix: "112",
            length_tokens: quote! { rems(28.) },
            doc_string_suffix: "448px (28rem)",
        },
        BoxStyleSuffix {
            suffix: "128",
            length_tokens: quote! { rems(32.) },
            doc_string_suffix: "512px (32rem)",
        },
        BoxStyleSuffix {
            suffix: "auto",
            length_tokens: quote! { auto() },
            doc_string_suffix: "Auto",
        },
        BoxStyleSuffix {
            suffix: "px",
            length_tokens: quote! { px(1.) },
            doc_string_suffix: "1px",
        },
        BoxStyleSuffix {
            suffix: "full",
            length_tokens: quote! { relative(1.) },
            doc_string_suffix: "100%",
        },
        BoxStyleSuffix {
            suffix: "1_2",
            length_tokens: quote! { relative(0.5) },
            doc_string_suffix: "50% (1/2)",
        },
        BoxStyleSuffix {
            suffix: "1_3",
            length_tokens: quote! { relative(1./3.) },
            doc_string_suffix: "one third of the reference dimension (1/3)",
        },
        BoxStyleSuffix {
            suffix: "2_3",
            length_tokens: quote! { relative(2./3.) },
            doc_string_suffix: "two thirds of the reference dimension (2/3)",
        },
        BoxStyleSuffix {
            suffix: "1_4",
            length_tokens: quote! { relative(0.25) },
            doc_string_suffix: "25% (1/4)",
        },
        BoxStyleSuffix {
            suffix: "2_4",
            length_tokens: quote! { relative(0.5) },
            doc_string_suffix: "50% (2/4)",
        },
        BoxStyleSuffix {
            suffix: "3_4",
            length_tokens: quote! { relative(0.75) },
            doc_string_suffix: "75% (3/4)",
        },
        BoxStyleSuffix {
            suffix: "1_5",
            length_tokens: quote! { relative(0.2) },
            doc_string_suffix: "20% (1/5)",
        },
        BoxStyleSuffix {
            suffix: "2_5",
            length_tokens: quote! { relative(0.4) },
            doc_string_suffix: "40% (2/5)",
        },
        BoxStyleSuffix {
            suffix: "3_5",
            length_tokens: quote! { relative(0.6) },
            doc_string_suffix: "60% (3/5)",
        },
        BoxStyleSuffix {
            suffix: "4_5",
            length_tokens: quote! { relative(0.8) },
            doc_string_suffix: "80% (4/5)",
        },
        BoxStyleSuffix {
            suffix: "1_6",
            length_tokens: quote! { relative(1./6.) },
            doc_string_suffix: "one sixth of the reference dimension (1/6)",
        },
        BoxStyleSuffix {
            suffix: "5_6",
            length_tokens: quote! { relative(5./6.) },
            doc_string_suffix: "five sixths of the reference dimension (5/6)",
        },
        BoxStyleSuffix {
            suffix: "1_12",
            length_tokens: quote! { relative(1./12.) },
            doc_string_suffix: "one twelfth of the reference dimension (1/12)",
        },
    ]
}

fn corner_prefixes() -> Vec<CornerStylePrefix> {
    vec![
        CornerStylePrefix {
            prefix: "rounded",
            fields: vec![
                quote! { corner_radii.top_left },
                quote! { corner_radii.top_right },
                quote! { corner_radii.bottom_right },
                quote! { corner_radii.bottom_left },
            ],
            doc_string_prefix: "Sets the border radius of the element. [Docs](https://tailwindcss.com/docs/border-radius)",
        },
        CornerStylePrefix {
            prefix: "rounded_t",
            fields: vec![
                quote! { corner_radii.top_left },
                quote! { corner_radii.top_right },
            ],
            doc_string_prefix: "Sets the border radius of the top side of the element. [Docs](https://tailwindcss.com/docs/border-radius#rounding-sides-separately)",
        },
        CornerStylePrefix {
            prefix: "rounded_b",
            fields: vec![
                quote! { corner_radii.bottom_left },
                quote! { corner_radii.bottom_right },
            ],
            doc_string_prefix: "Sets the border radius of the bottom side of the element. [Docs](https://tailwindcss.com/docs/border-radius#rounding-sides-separately)",
        },
        CornerStylePrefix {
            prefix: "rounded_r",
            fields: vec![
                quote! { corner_radii.top_right },
                quote! { corner_radii.bottom_right },
            ],
            doc_string_prefix: "Sets the border radius of the right side of the element. [Docs](https://tailwindcss.com/docs/border-radius#rounding-sides-separately)",
        },
        CornerStylePrefix {
            prefix: "rounded_l",
            fields: vec![
                quote! { corner_radii.top_left },
                quote! { corner_radii.bottom_left },
            ],
            doc_string_prefix: "Sets the border radius of the left side of the element. [Docs](https://tailwindcss.com/docs/border-radius#rounding-sides-separately)",
        },
        CornerStylePrefix {
            prefix: "rounded_tl",
            fields: vec![quote! { corner_radii.top_left }],
            doc_string_prefix: "Sets the border radius of the top left corner of the element. [Docs](https://tailwindcss.com/docs/border-radius#rounding-corners-separately)",
        },
        CornerStylePrefix {
            prefix: "rounded_tr",
            fields: vec![quote! { corner_radii.top_right }],
            doc_string_prefix: "Sets the border radius of the top right corner of the element. [Docs](https://tailwindcss.com/docs/border-radius#rounding-corners-separately)",
        },
        CornerStylePrefix {
            prefix: "rounded_bl",
            fields: vec![quote! { corner_radii.bottom_left }],
            doc_string_prefix: "Sets the border radius of the bottom left corner of the element. [Docs](https://tailwindcss.com/docs/border-radius#rounding-corners-separately)",
        },
        CornerStylePrefix {
            prefix: "rounded_br",
            fields: vec![quote! { corner_radii.bottom_right }],
            doc_string_prefix: "Sets the border radius of the bottom right corner of the element. [Docs](https://tailwindcss.com/docs/border-radius#rounding-corners-separately)",
        },
    ]
}

fn corner_suffixes() -> Vec<CornerStyleSuffix> {
    vec![
        CornerStyleSuffix {
            suffix: "none",
            radius_tokens: quote! { px(0.) },
            doc_string_suffix: "0px",
        },
        CornerStyleSuffix {
            suffix: "xs",
            radius_tokens: quote! { rems(0.125) },
            doc_string_suffix: "2px (0.125rem)",
        },
        CornerStyleSuffix {
            suffix: "sm",
            radius_tokens: quote! { rems(0.25) },
            doc_string_suffix: "4px (0.25rem)",
        },
        CornerStyleSuffix {
            suffix: "md",
            radius_tokens: quote! { rems(0.375) },
            doc_string_suffix: "6px (0.375rem)",
        },
        CornerStyleSuffix {
            suffix: "lg",
            radius_tokens: quote! { rems(0.5) },
            doc_string_suffix: "8px (0.5rem)",
        },
        CornerStyleSuffix {
            suffix: "xl",
            radius_tokens: quote! { rems(0.75) },
            doc_string_suffix: "12px (0.75rem)",
        },
        CornerStyleSuffix {
            suffix: "2xl",
            radius_tokens: quote! { rems(1.) },
            doc_string_suffix: "16px (1rem)",
        },
        CornerStyleSuffix {
            suffix: "3xl",
            radius_tokens: quote! { rems(1.5) },
            doc_string_suffix: "24px (1.5rem)",
        },
        CornerStyleSuffix {
            suffix: "full",
            radius_tokens: quote! {  px(9999.) },
            doc_string_suffix: "9999px",
        },
    ]
}

fn corner_smoothing_suffixes() -> Vec<CornerSmoothingStyleSuffix> {
    vec![
        CornerSmoothingStyleSuffix {
            suffix: "0",
            amount_tokens: quote! { 0.0 },
            doc_string: "Keeps circular corners by setting rounded corner smoothing to `0.0`.",
        },
        CornerSmoothingStyleSuffix {
            suffix: "0p1",
            amount_tokens: quote! { 0.1 },
            doc_string: "Sets rounded corner smoothing to `0.1`.",
        },
        CornerSmoothingStyleSuffix {
            suffix: "0p2",
            amount_tokens: quote! { 0.2 },
            doc_string: "Sets rounded corner smoothing to `0.2`.",
        },
        CornerSmoothingStyleSuffix {
            suffix: "0p3",
            amount_tokens: quote! { 0.3 },
            doc_string: "Sets rounded corner smoothing to `0.3`.",
        },
        CornerSmoothingStyleSuffix {
            suffix: "0p4",
            amount_tokens: quote! { 0.4 },
            doc_string: "Sets rounded corner smoothing to `0.4`.",
        },
        CornerSmoothingStyleSuffix {
            suffix: "0p5",
            amount_tokens: quote! { 0.5 },
            doc_string: "Sets rounded corner smoothing to `0.5`.",
        },
        CornerSmoothingStyleSuffix {
            suffix: "0p6",
            amount_tokens: quote! { 0.6 },
            doc_string: "Sets rounded corner smoothing to `0.6`.",
        },
        CornerSmoothingStyleSuffix {
            suffix: "0p7",
            amount_tokens: quote! { 0.7 },
            doc_string: "Sets rounded corner smoothing to `0.7`.",
        },
        CornerSmoothingStyleSuffix {
            suffix: "0p8",
            amount_tokens: quote! { 0.8 },
            doc_string: "Sets rounded corner smoothing to `0.8`.",
        },
        CornerSmoothingStyleSuffix {
            suffix: "0p9",
            amount_tokens: quote! { 0.9 },
            doc_string: "Sets rounded corner smoothing to `0.9`.",
        },
        CornerSmoothingStyleSuffix {
            suffix: "1",
            amount_tokens: quote! { 1.0 },
            doc_string: "Requests maximum rounded corner smoothing by setting it to `1.0`.",
        },
    ]
}

fn border_prefixes() -> Vec<BorderStylePrefix> {
    vec![
        BorderStylePrefix {
            prefix: "border",
            fields: vec![
                quote! { border_widths.top },
                quote! { border_widths.right },
                quote! { border_widths.bottom },
                quote! { border_widths.left },
            ],
            doc_string_prefix: "Sets all four border widths. Numbered presets are logical pixels; custom values accept `AbsoluteLength` (pixels or rems), not percentages. Border color and border style are set separately. [Docs](https://tailwindcss.com/docs/border-width)",
        },
        BorderStylePrefix {
            prefix: "border_t",
            fields: vec![quote! { border_widths.top }],
            doc_string_prefix: "Sets the top border width. Numbered presets are logical pixels; custom values accept `AbsoluteLength` (pixels or rems), not percentages. [Docs](https://tailwindcss.com/docs/border-width#individual-sides)",
        },
        BorderStylePrefix {
            prefix: "border_b",
            fields: vec![quote! { border_widths.bottom }],
            doc_string_prefix: "Sets the bottom border width. Numbered presets are logical pixels; custom values accept `AbsoluteLength` (pixels or rems), not percentages. [Docs](https://tailwindcss.com/docs/border-width#individual-sides)",
        },
        BorderStylePrefix {
            prefix: "border_r",
            fields: vec![quote! { border_widths.right }],
            doc_string_prefix: "Sets the right border width. Numbered presets are logical pixels; custom values accept `AbsoluteLength` (pixels or rems), not percentages. [Docs](https://tailwindcss.com/docs/border-width#individual-sides)",
        },
        BorderStylePrefix {
            prefix: "border_l",
            fields: vec![quote! { border_widths.left }],
            doc_string_prefix: "Sets the left border width. Numbered presets are logical pixels; custom values accept `AbsoluteLength` (pixels or rems), not percentages. [Docs](https://tailwindcss.com/docs/border-width#individual-sides)",
        },
        BorderStylePrefix {
            prefix: "border_x",
            fields: vec![
                quote! { border_widths.left },
                quote! { border_widths.right },
            ],
            doc_string_prefix: "Sets left and right border widths (the vertical edges). Numbered presets are logical pixels; custom values accept `AbsoluteLength` (pixels or rems), not percentages. [Docs](https://tailwindcss.com/docs/border-width#horizontal-and-vertical-sides)",
        },
        BorderStylePrefix {
            prefix: "border_y",
            fields: vec![
                quote! { border_widths.top },
                quote! { border_widths.bottom },
            ],
            doc_string_prefix: "Sets top and bottom border widths (the horizontal edges). Numbered presets are logical pixels; custom values accept `AbsoluteLength` (pixels or rems), not percentages. [Docs](https://tailwindcss.com/docs/border-width#horizontal-and-vertical-sides)",
        },
    ]
}

fn border_suffixes() -> Vec<BorderStyleSuffix> {
    vec![
        BorderStyleSuffix {
            suffix: "0",
            width_tokens: quote! { px(0.)},
            doc_string_suffix: "0px",
        },
        BorderStyleSuffix {
            suffix: "1",
            width_tokens: quote! { px(1.) },
            doc_string_suffix: "1px",
        },
        BorderStyleSuffix {
            suffix: "2",
            width_tokens: quote! { px(2.) },
            doc_string_suffix: "2px",
        },
        BorderStyleSuffix {
            suffix: "3",
            width_tokens: quote! { px(3.) },
            doc_string_suffix: "3px",
        },
        BorderStyleSuffix {
            suffix: "4",
            width_tokens: quote! { px(4.) },
            doc_string_suffix: "4px",
        },
        BorderStyleSuffix {
            suffix: "5",
            width_tokens: quote! { px(5.) },
            doc_string_suffix: "5px",
        },
        BorderStyleSuffix {
            suffix: "6",
            width_tokens: quote! { px(6.) },
            doc_string_suffix: "6px",
        },
        BorderStyleSuffix {
            suffix: "7",
            width_tokens: quote! { px(7.) },
            doc_string_suffix: "7px",
        },
        BorderStyleSuffix {
            suffix: "8",
            width_tokens: quote! { px(8.) },
            doc_string_suffix: "8px",
        },
        BorderStyleSuffix {
            suffix: "9",
            width_tokens: quote! { px(9.) },
            doc_string_suffix: "9px",
        },
        BorderStyleSuffix {
            suffix: "10",
            width_tokens: quote! { px(10.) },
            doc_string_suffix: "10px",
        },
        BorderStyleSuffix {
            suffix: "11",
            width_tokens: quote! { px(11.) },
            doc_string_suffix: "11px",
        },
        BorderStyleSuffix {
            suffix: "12",
            width_tokens: quote! { px(12.) },
            doc_string_suffix: "12px",
        },
        BorderStyleSuffix {
            suffix: "16",
            width_tokens: quote! { px(16.) },
            doc_string_suffix: "16px",
        },
        BorderStyleSuffix {
            suffix: "20",
            width_tokens: quote! { px(20.) },
            doc_string_suffix: "20px",
        },
        BorderStyleSuffix {
            suffix: "24",
            width_tokens: quote! { px(24.) },
            doc_string_suffix: "24px",
        },
        BorderStyleSuffix {
            suffix: "32",
            width_tokens: quote! { px(32.) },
            doc_string_suffix: "32px",
        },
    ]
}
