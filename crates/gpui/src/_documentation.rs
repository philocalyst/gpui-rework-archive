//! The GPUI book: a tutorial, task guides, concept explanations and design notes.
//!
//! The API reference tells you what each item does. These pages tell you how to put
//! the items together and why GPUI works the way it does.
//!
//! | If you want to… | Read |
//! | --- | --- |
//! | Learn GPUI from scratch by building an app | [The tutorial](tutorial) |
//! | Get a specific job done | [The guides](guides) |
//! | Understand how GPUI works | [The concepts](concepts) |
//! | Run and read complete programs | [The examples](examples) |
//! | Know why GPUI is designed this way | [Design](design) |
//! | Choose between GPUI and another toolkit | [Comparison](comparison) |
//! | Check what runs where | [Platforms](platforms) |
//! | Port code from Zed's GPUI | [Upstream](upstream) |

// Each page is the outer documentation of an empty module, so rustdoc resolves
// a page's links in the module that contains it. Importing the crate there lets
// pages write [`Entity`] instead of [`Entity`](crate::Entity).
#![allow(unused_imports)]
use crate::*;

macro_rules! pages {
    ($($name:ident => $path:literal,)*) => {$(
        #[doc = include_str!(concat!("../docs/", $path))]
        pub mod $name {}
    )*};
}

#[doc = include_str!("../docs/tutorial/index.md")]
pub mod tutorial {
    use crate::*;

    pages! {
        ch1_hello_window => "tutorial/1-hello-window.md",
        ch2_state => "tutorial/2-state.md",
        ch3_layout_and_style => "tutorial/3-layout-and-style.md",
        ch4_text_input => "tutorial/4-text-input.md",
        ch5_components => "tutorial/5-components.md",
        ch6_background_work => "tutorial/6-background-work.md",
        ch7_polish => "tutorial/7-polish.md",
        ch8_testing => "tutorial/8-testing.md",
    }
}

#[doc = include_str!("../docs/guides/index.md")]
pub mod guides {
    use crate::*;

    pages! {
        start_a_project => "guides/start-a-project.md",
        keyboard => "guides/keyboard.md",
        focus => "guides/focus.md",
        mouse_and_touch => "guides/mouse-and-touch.md",
        text => "guides/text.md",
        text_input => "guides/text-input.md",
        lists_and_scrolling => "guides/lists-and-scrolling.md",
        sharing_state => "guides/sharing-state.md",
        async_work => "guides/async-work.md",
        animation => "guides/animation.md",
        custom_drawing => "guides/custom-drawing.md",
        images_and_assets => "guides/images-and-assets.md",
        windows => "guides/windows.md",
        platform_services => "guides/platform-services.md",
        accessibility => "guides/accessibility.md",
        testing => "guides/testing.md",
        performance => "guides/performance.md",
        web => "guides/web.md",
        hot_reload => "guides/hot-reload.md",
        troubleshooting => "guides/troubleshooting.md",
    }
}

#[doc = include_str!("../docs/concepts/index.md")]
pub mod concepts {
    use crate::*;

    pages! {
        ownership => "concepts/ownership.md",
        contexts => "concepts/contexts.md",
        the_frame => "concepts/the-frame.md",
        elements => "concepts/elements.md",
        layout_and_style => "concepts/layout-and-style.md",
        input_dispatch => "concepts/input-dispatch.md",
        executors => "concepts/executors.md",
    }
}

pages! {
    design => "design.md",
    comparison => "comparison.md",
    platforms => "platforms.md",
    upstream => "upstream.md",
    examples => "examples.md",
}
