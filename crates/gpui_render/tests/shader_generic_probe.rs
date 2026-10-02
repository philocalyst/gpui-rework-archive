//! Compiler probe for using wgsl-rs generic structs as composable paints.
//!
//! This captures a working one-level composition and a known failure when a
//! generic paint contains another generic paint. Keep the expected failure
//! explicit: it determines whether shader recipes can rely on wgsl-rs
//! monomorphization without a separate composition compiler.

#[allow(dead_code)]
#[wgsl_rs::wgsl]
mod one_level {
    use wgsl_rs::std::*;

    /// Returns premultiplied RGBA for this paint.
    pub trait Paint: Wgsl + Copy {
        fn shade(paint: Self, uv: Vec2f) -> Vec4f;
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct Bands {
        pub frequency: f32,
        pub phase: f32,
        /// Premultiplied RGBA.
        pub color: Vec4f,
    }

    impl Paint for Bands {
        fn shade(paint: Bands, uv: Vec2f) -> Vec4f {
            let amount: f32 = 0.5 + 0.5 * sin(uv.x * paint.frequency + paint.phase);
            paint.color * amount
        }
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct Over<Front: Paint, Back: Paint> {
        pub front: Front,
        pub back: Back,
        pub opacity: f32,
    }

    impl<Front: Paint, Back: Paint> Paint for Over<Front, Back> {
        fn shade(paint: Over<Front, Back>, uv: Vec2f) -> Vec4f {
            let source: Vec4f = Front::shade(paint.front, uv) * paint.opacity;
            let destination: Vec4f = Back::shade(paint.back, uv);
            source + destination * (1.0 - source.w)
        }
    }

    /// A named, typed parameter block stored as one uniform.
    #[derive(Clone, Copy, Wgsl)]
    pub struct Params {
        pub paint: Over<Bands, Bands>,
    }

    uniform!(group(0), binding(0), PAINT_PARAMS: Params);

    pub struct FragmentIn {
        #[builtin(position)]
        pub position: Vec4f,
    }

    #[fragment]
    pub fn fragment(input: FragmentIn) -> Vec4f {
        // Rebuild the concrete recipe from named fields so the same source
        // works with the Rust-side uniform guard and as a WGSL uniform value.
        let paint = Over::<Bands, Bands> {
            front: Bands {
                frequency: get!(PAINT_PARAMS).paint.front.frequency,
                phase: get!(PAINT_PARAMS).paint.front.phase,
                color: get!(PAINT_PARAMS).paint.front.color,
            },
            back: Bands {
                frequency: get!(PAINT_PARAMS).paint.back.frequency,
                phase: get!(PAINT_PARAMS).paint.back.phase,
                color: get!(PAINT_PARAMS).paint.back.color,
            },
            opacity: get!(PAINT_PARAMS).paint.opacity,
        };
        Over::<Bands, Bands>::shade(paint, input.position.xy())
    }
}

#[allow(dead_code)]
#[wgsl_rs::wgsl(skip_validation)]
mod nested {
    use wgsl_rs::std::*;

    /// Returns premultiplied RGBA for this paint.
    pub trait Paint: Wgsl + Copy {
        fn shade(paint: Self, uv: Vec2f) -> Vec4f;
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct Bands {
        pub frequency: f32,
        /// Premultiplied RGBA.
        pub color: Vec4f,
    }

    impl Paint for Bands {
        fn shade(paint: Bands, uv: Vec2f) -> Vec4f {
            let amount: f32 = 0.5 + 0.5 * sin(uv.x * paint.frequency);
            paint.color * amount
        }
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct Tint {
        /// Premultiplied RGBA.
        pub color: Vec4f,
    }

    impl Paint for Tint {
        fn shade(paint: Tint, _uv: Vec2f) -> Vec4f {
            paint.color
        }
    }

    #[derive(Clone, Copy, Wgsl)]
    pub struct Over<Front: Paint, Back: Paint> {
        pub front: Front,
        pub back: Back,
        pub opacity: f32,
    }

    impl<Front: Paint, Back: Paint> Paint for Over<Front, Back> {
        fn shade(paint: Over<Front, Back>, uv: Vec2f) -> Vec4f {
            let source: Vec4f = Front::shade(paint.front, uv) * paint.opacity;
            let destination: Vec4f = Back::shade(paint.back, uv);
            source + destination * (1.0 - source.w)
        }
    }

    /// The uniform makes the nested recipe a realistic named-parameter case.
    #[derive(Clone, Copy, Wgsl)]
    pub struct Params {
        pub paint: Over<Over<Bands, Tint>, Bands>,
    }

    uniform!(group(0), binding(0), PAINT_PARAMS: Params);

    pub struct FragmentIn {
        #[builtin(position)]
        pub position: Vec4f,
    }

    #[fragment]
    pub fn fragment(input: FragmentIn) -> Vec4f {
        let front = Over::<Bands, Tint> {
            front: Bands {
                frequency: get!(PAINT_PARAMS).paint.front.front.frequency,
                color: get!(PAINT_PARAMS).paint.front.front.color,
            },
            back: Tint {
                color: get!(PAINT_PARAMS).paint.front.back.color,
            },
            opacity: get!(PAINT_PARAMS).paint.front.opacity,
        };
        let paint = Over::<Over<Bands, Tint>, Bands> {
            front,
            back: Bands {
                frequency: get!(PAINT_PARAMS).paint.back.frequency,
                color: get!(PAINT_PARAMS).paint.back.color,
            },
            opacity: get!(PAINT_PARAMS).paint.opacity,
        };
        Over::<Over<Bands, Tint>, Bands>::shade(paint, input.position.xy())
    }
}

fn validate_wgsl(source: &str) -> Result<(), String> {
    let module =
        naga::front::wgsl::parse_str(source).map_err(|error| error.emit_to_string(source))?;
    naga::valid::Validator::new(
        naga::valid::ValidationFlags::all(),
        naga::valid::Capabilities::all(),
    )
    .validate(&module)
    .map(|_| ())
    .map_err(|error| error.emit_to_string(source))
}

fn close(actual: f32, expected: f32) {
    assert!(
        (actual - expected).abs() < 0.00001,
        "{actual} != {expected}"
    );
}

#[test]
fn one_level_named_params_compile_to_valid_wgsl_and_run_on_cpu() {
    use wgsl_rs::std::{vec2f, vec4f};

    let wgsl = one_level::WGSL_SOURCE.wgsl_source().unwrap();
    assert!(wgsl.contains("struct Params"), "{wgsl}");
    assert!(wgsl.contains("var<uniform> PAINT_PARAMS: Params"), "{wgsl}");
    assert!(wgsl.contains("fn _2Over_Bands_Bands_shade"), "{wgsl}");
    validate_wgsl(&wgsl).unwrap_or_else(|error| panic!("WGSL failed validation:\n{error}"));

    let front = one_level::Bands {
        frequency: 3.0,
        phase: 0.4,
        color: vec4f(0.8, 0.2, 0.1, 1.0),
    };
    let back = one_level::Bands {
        frequency: 1.5,
        phase: 0.1,
        color: vec4f(0.1, 0.4, 0.9, 1.0),
    };
    let paint = one_level::Over::<one_level::Bands, one_level::Bands> {
        front,
        back,
        opacity: 0.35,
    };
    let uv = vec2f(0.31, 0.47);
    let actual =
        <one_level::Over<one_level::Bands, one_level::Bands> as one_level::Paint>::shade(paint, uv);
    let front_amount = 0.5 + 0.5 * (uv.x * front.frequency + front.phase).sin();
    let back_amount = 0.5 + 0.5 * (uv.x * back.frequency + back.phase).sin();
    let source_alpha = front.color.w * front_amount * paint.opacity;
    for (actual, expected) in [
        (
            actual.x,
            front.color.x * front_amount * paint.opacity
                + back.color.x * back_amount * (1.0 - source_alpha),
        ),
        (
            actual.y,
            front.color.y * front_amount * paint.opacity
                + back.color.y * back_amount * (1.0 - source_alpha),
        ),
        (
            actual.z,
            front.color.z * front_amount * paint.opacity
                + back.color.z * back_amount * (1.0 - source_alpha),
        ),
        (
            actual.w,
            source_alpha + back.color.w * back_amount * (1.0 - source_alpha),
        ),
    ] {
        close(actual, expected);
    }
}

#[test]
fn nested_generic_recipe_emits_unresolved_helper_and_naga_rejects_it() {
    let source = nested::WGSL_SOURCE.wgsl_source().unwrap();
    assert!(source.contains("fn _2Over_Bands_Tint_shade"), "{source}");
    assert!(
        source.contains("let source: vec4f = Over_shade(paint.front, uv) * paint.opacity;"),
        "{source}"
    );
    assert!(!source.contains("fn Over_shade("), "{source}");

    let error = validate_wgsl(&source).expect_err("nested generic helper name must be unresolved");
    assert!(error.contains("Over_shade"), "{error}");
    assert!(
        error.contains("no definition in scope for identifier"),
        "{error}"
    );
}

#[test]
fn nested_generic_recipe_still_evaluates_as_rust() {
    use wgsl_rs::std::{vec2f, vec4f};

    let front = nested::Over::<nested::Bands, nested::Tint> {
        front: nested::Bands {
            frequency: 2.0,
            color: vec4f(0.8, 0.1, 0.2, 1.0),
        },
        back: nested::Tint {
            color: vec4f(0.1, 0.3, 0.9, 1.0),
        },
        opacity: 0.4,
    };
    let paint = nested::Over::<nested::Over<nested::Bands, nested::Tint>, nested::Bands> {
        front,
        back: nested::Bands {
            frequency: 4.0,
            color: vec4f(0.2, 0.8, 0.1, 1.0),
        },
        opacity: 0.7,
    };
    let actual = <nested::Over<
        nested::Over<nested::Bands, nested::Tint>,
        nested::Bands,
    > as nested::Paint>::shade(paint, vec2f(0.25, 0.0));
    let inner_front = 0.5 + 0.5 * (0.25_f32 * 2.0).sin();
    let outer_back = 0.5 + 0.5 * (0.25_f32 * 4.0).sin();
    let inner_source_alpha = inner_front * 0.4;
    let inner_color = [
        0.8 * inner_front * 0.4 + 0.1 * (1.0 - inner_source_alpha),
        0.1 * inner_front * 0.4 + 0.3 * (1.0 - inner_source_alpha),
        0.2 * inner_front * 0.4 + 0.9 * (1.0 - inner_source_alpha),
    ];
    close(actual.x, inner_color[0] * 0.7 + 0.2 * outer_back * 0.3);
    close(actual.y, inner_color[1] * 0.7 + 0.8 * outer_back * 0.3);
    close(actual.z, inner_color[2] * 0.7 + 0.1 * outer_back * 0.3);
    close(actual.w, 0.7 + outer_back * 0.3);
}
