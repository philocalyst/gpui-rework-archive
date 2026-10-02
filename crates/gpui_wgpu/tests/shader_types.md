The public shader API accepts composed paints in component style.

```
use gpui::{Styled, div, rgb, shader::color};
let _ = div().bg(color(rgb(0x336699)));
```

Vector arithmetic preserves dimensions.
```compile_fail
use gpui::shader::{Vec2, Vec3};
let _ = Vec2::uniform([1.0, 2.0]) + Vec3::uniform([1.0, 2.0, 3.0]);
```

Dot products also preserve dimensions.
```compile_fail
use gpui::shader::{Vec2, Vec3};
let _ = Vec2::uniform([1.0, 2.0]).dot(Vec3::uniform([1.0, 2.0, 3.0]));
```

Paint masks require scalar coverage, not another color.
```compile_fail
use gpui::shader::color;
let _ = color([1.0, 0.0, 0.0, 1.0]).mask(color([0.0, 0.0, 0.0, 1.0]));
```

Source-over requires a Paint background.
```compile_fail
use gpui::shader::{Scalar, color};
let _ = color([1.0, 0.0, 0.0, 1.0]).over(Scalar::uniform(0.5));
```

Boolean predicates do not support numeric addition.
```compile_fail
use gpui::shader::Scalar;
let p = Scalar::uniform(1.0).gt(0.0);
let _ = p.clone() + p;
```

Raw numeric vectors do not become component backgrounds.
```compile_fail
use gpui::{Styled, div, shader::Vec4};
let _ = div().bg(Vec4::uniform([1.0, 0.0, 0.0, 1.0]));
```
