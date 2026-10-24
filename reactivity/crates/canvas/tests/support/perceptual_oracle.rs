//! Independent authored-color f64 oracle. Never reads prepared packet words.
use gpui_canvas::{Color, ColorSpace, HueInterpolation as Hue, Interpolation as Mode};
fn mul(m: [[f64; 3]; 3], x: [f64; 3]) -> [f64; 3] {
    m.map(|r| r[0] * x[0] + r[1] * x[1] + r[2] * x[2])
}
fn linear(color: Color) -> [f64; 3] {
    let ch = color.channels();
    let mut rgb = [f64::from(ch[0]), f64::from(ch[1]), f64::from(ch[2])];
    if matches!(color.space(), ColorSpace::Srgb | ColorSpace::DisplayP3) {
        rgb = rgb.map(|x| {
            x.signum()
                * if x.abs() <= 0.04045 {
                    x.abs() / 12.92
                } else {
                    ((x.abs() + 0.055) / 1.055).powf(2.4)
                }
        });
    }
    if matches!(
        color.space(),
        ColorSpace::DisplayP3 | ColorSpace::LinearDisplayP3
    ) {
        rgb = mul(
            [
                [1.2249401762805598, -0.2249401762805598, 0.0],
                [-0.0420569547096882, 1.0420569547096882, 0.0],
                [-0.0196375545903344, -0.0786360455506319, 1.0982736001409663],
            ],
            rgb,
        );
    }
    rgb
}
fn lab(color: Color) -> [f64; 3] {
    if color.space() == ColorSpace::Oklch {
        let c = color.channels();
        let angle = f64::from(c[2]).to_radians();
        return [
            f64::from(c[0]),
            f64::from(c[1]) * angle.cos(),
            f64::from(c[1]) * angle.sin(),
        ];
    }
    let rgb = linear(color);
    if rgb[0] == rgb[1] && rgb[1] == rgb[2] {
        return [rgb[0].cbrt(), 0.0, 0.0];
    }
    let xyz = mul(
        [
            [506752.0 / 1228815.0, 87881.0 / 245763.0, 12673.0 / 70218.0],
            [87098.0 / 409605.0, 175762.0 / 245763.0, 12673.0 / 175545.0],
            [7918.0 / 409605.0, 87881.0 / 737289.0, 1001167.0 / 1053270.0],
        ],
        rgb,
    );
    let lms = mul(
        [
            [0.819022437996703, 0.3619062600528904, -0.1288737815209879],
            [0.0329836539323885, 0.9292868615863434, 0.0361446663506424],
            [0.0481771893596242, 0.2642395317527308, 0.6335478284694309],
        ],
        xyz,
    )
    .map(f64::cbrt);
    mul(
        [
            [0.210454268309314, 0.7936177747023054, -0.0040720430116193],
            [1.9779985324311684, -2.42859224204858, 0.450593709617411],
            [0.0259040424655478, 0.7827717124575296, -0.8086757549230774],
        ],
        lms,
    )
}
fn inverse(lab: [f64; 3]) -> [f64; 3] {
    let lms = mul(
        [
            [1.0, 0.3963377773761749, 0.2158037573099136],
            [1.0, -0.1055613458156586, -0.0638541728258133],
            [1.0, -0.0894841775298119, -1.2914855480194092],
        ],
        lab,
    )
    .map(|x| x * x * x);
    let xyz = mul(
        [
            [1.2268798758459243, -0.5578149944602171, 0.2813910456659647],
            [-0.0405757452148008, 1.112286803280317, -0.0717110580655164],
            [-0.0763729366746601, -0.4214933324022432, 1.5869240198367816],
        ],
        lms,
    );
    mul(
        [
            [12831.0 / 3959.0, -329.0 / 214.0, -1974.0 / 3959.0],
            [
                -851781.0 / 878810.0,
                1648619.0 / 878810.0,
                36519.0 / 878810.0,
            ],
            [705.0 / 12673.0, -2585.0 / 12673.0, 705.0 / 667.0],
        ],
        xyz,
    )
}
fn author_rgb(color: Color) -> [f64; 3] {
    if color.space() == ColorSpace::Oklch {
        inverse(lab(color))
    } else {
        linear(color)
    }
}
fn identity_or_fade(left: Color, right: Color, t: f64, alpha: f64) -> [f64; 4] {
    let a = author_rgb(left);
    let b = author_rgb(right);
    let weight_a = (1.0 - t) * f64::from(left.alpha());
    let weight_b = t * f64::from(right.alpha());
    [
        a[0] * weight_a + b[0] * weight_b,
        a[1] * weight_a + b[1] * weight_b,
        a[2] * weight_a + b[2] * weight_b,
        alpha,
    ]
}
pub fn interpolate(left: Color, right: Color, t: f64, mode: Mode) -> [f64; 4] {
    let alpha0 = f64::from(left.alpha());
    let alpha1 = f64::from(right.alpha());
    let alpha = (1.0 - t) * alpha0 + t * alpha1;
    if alpha == 0.0 {
        return [0.0; 4];
    }
    let mut a = lab(left);
    let mut b = lab(right);
    if let Mode::Oklch { hue } = mode {
        let polar = |color: Color, lab: [f64; 3]| {
            if color.space() == ColorSpace::Oklch {
                let c = color.channels();
                [f64::from(c[0]), f64::from(c[1]), f64::from(c[2])]
            } else {
                [
                    lab[0],
                    lab[1].hypot(lab[2]),
                    lab[2].atan2(lab[1]).to_degrees().rem_euclid(360.0),
                ]
            }
        };
        a = polar(left, a);
        b = polar(right, b);
        let missing_a = a[1] <= 0.000004;
        let missing_b = b[1] <= 0.000004;
        match (missing_a, missing_b) {
            (true, true) => {
                a[2] = 0.0;
                b[2] = 0.0;
            }
            (true, false) => a[2] = b[2],
            (false, true) => b[2] = a[2],
            _ => {}
        }
        let diff = b[2] - a[2];
        // Written independently as a signed route length, not endpoint fixup.
        let d = if missing_a && missing_b {
            0.0
        } else {
            match hue {
                Hue::Shorter => {
                    if diff > 180.0 {
                        diff - 360.0
                    } else if diff < -180.0 {
                        diff + 360.0
                    } else {
                        diff
                    }
                }
                Hue::Longer => {
                    if diff > 0.0 && diff < 180.0 {
                        diff - 360.0
                    } else if diff > -180.0 && diff <= 0.0 {
                        diff + 360.0
                    } else {
                        diff
                    }
                }
                Hue::Increasing => {
                    if diff < 0.0 {
                        diff + 360.0
                    } else {
                        diff
                    }
                }
                Hue::Decreasing => {
                    if diff > 0.0 {
                        diff - 360.0
                    } else {
                        diff
                    }
                }
            }
        };
        if d == 0.0 && (alpha0 == 0.0 || alpha1 == 0.0 || (a[0] == b[0] && a[1] == b[1])) {
            return identity_or_fade(left, right, t, alpha);
        }
        let l = ((1.0 - t) * alpha0 * a[0] + t * alpha1 * b[0]) / alpha;
        let c = ((1.0 - t) * alpha0 * a[1] + t * alpha1 * b[1]) / alpha;
        let angle = (a[2] + t * d).to_radians();
        a = [l, c * angle.cos(), c * angle.sin()];
    } else {
        if a == b || alpha0 == 0.0 || alpha1 == 0.0 {
            return identity_or_fade(left, right, t, alpha);
        }
        a = std::array::from_fn(|i| ((1.0 - t) * alpha0 * a[i] + t * alpha1 * b[i]) / alpha);
    }
    let rgb = inverse(a);
    [rgb[0] * alpha, rgb[1] * alpha, rgb[2] * alpha, alpha]
}
