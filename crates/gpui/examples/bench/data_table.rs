//! A deterministic 10,000-row table with sortable headers, selection, and virtualized rows.

#[path = "../shared/prelude.rs"]
mod example_prelude;

use gpui::{
    App, Context, Render, ScrollStrategy, UniformListScrollHandle, Window, div, prelude::*, px,
    rgb, size, uniform_list,
};
use std::ops::Range;
use std::time::Duration;

const ROW_HEIGHT: f32 = 32.;

struct Quote {
    symbol: String,
    name: &'static str,
    price: f64,
    change: f64,
    volume: u32,
}

impl Quote {
    fn sample(index: usize) -> Self {
        let change = ((index * 37 % 900) as f64 - 450.) / 100.;
        Self {
            symbol: format!(
                "{:04}.{}",
                index % 10_000,
                char::from(b'A' + (index % 26) as u8)
            ),
            name: ["Northstar", "Harbor", "Cedar", "Pioneer", "Meridian"][index % 5],
            price: 18. + (index * 73 % 14_000) as f64 / 100.,
            change,
            volume: 100_000 + (index * 91_337 % 90_000_000) as u32,
        }
    }
}

#[derive(Clone, Copy, PartialEq, Eq)]
enum SortBy {
    Symbol,
    Price,
    Change,
    Volume,
}

struct DataTable {
    rows: Vec<Quote>,
    order: Vec<usize>,
    sort_by: SortBy,
    descending: bool,
    selected: Option<usize>,
    scroll: UniformListScrollHandle,
}

impl DataTable {
    fn new() -> Self {
        let rows: Vec<_> = (0..10_000).map(Quote::sample).collect();
        Self {
            order: (0..rows.len()).collect(),
            rows,
            sort_by: SortBy::Symbol,
            descending: false,
            selected: None,
            scroll: UniformListScrollHandle::new(),
        }
    }

    fn sort(&mut self, field: SortBy, cx: &mut Context<Self>) {
        if field == self.sort_by {
            self.descending = !self.descending;
        } else {
            self.sort_by = field;
            self.descending = false;
        }
        let rows = &self.rows;
        let descending = self.descending;
        self.order.sort_by(|left, right| {
            let a = &rows[*left];
            let b = &rows[*right];
            let ordering = match field {
                SortBy::Symbol => a.symbol.cmp(&b.symbol),
                SortBy::Price => a.price.total_cmp(&b.price),
                SortBy::Change => a.change.total_cmp(&b.change),
                SortBy::Volume => a.volume.cmp(&b.volume),
            };
            if descending {
                ordering.reverse()
            } else {
                ordering
            }
        });
        cx.notify();
    }

    fn scroll_offset_y(&self) -> f32 {
        f32::from(self.scroll.0.borrow().base_handle.offset().y)
    }

    fn prices_sorted(&self, descending: bool) -> bool {
        self.order.windows(2).all(|pair| {
            let left = self.rows[pair[0]].price;
            let right = self.rows[pair[1]].price;
            if descending {
                left >= right
            } else {
                left <= right
            }
        })
    }

    fn header(
        &self,
        id: &'static str,
        label: &'static str,
        field: SortBy,
        cx: &mut Context<Self>,
    ) -> gpui::Stateful<gpui::Div> {
        let active = field == self.sort_by;
        let direction = if self.descending { " ↓" } else { " ↑" };
        div()
            .id(id)
            .debug_selector(|| id.into())
            .flex_1()
            .px_3()
            .py_2()
            .text_xs()
            .font_weight(gpui::FontWeight::SEMIBOLD)
            .text_color(if active { rgb(0x1d4ed8) } else { rgb(0x5b6472) })
            .cursor_pointer()
            .child(if active {
                format!("{label}{direction}")
            } else {
                label.to_string()
            })
            .on_click(cx.listener(move |this, _, _, cx| this.sort(field, cx)))
    }
}

impl Render for DataTable {
    fn render(&mut self, _window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let header = div()
            .flex()
            .bg(rgb(0xe9edf3))
            .child(self.header("sort-symbol", "Symbol", SortBy::Symbol, cx))
            .child(div().flex_1().px_3().py_2().text_xs().child("Company"))
            .child(self.header("sort-price", "Price", SortBy::Price, cx))
            .child(self.header("sort-change", "Change", SortBy::Change, cx))
            .child(self.header("sort-volume", "Volume", SortBy::Volume, cx));
        div()
            .size_full()
            .flex()
            .flex_col()
            .gap_2()
            .p_4()
            .bg(rgb(0xf7f8fa))
            .child(div().text_sm().child(format!(
                "{} rows · selected {:?}",
                self.rows.len(),
                self.selected
            )))
            .child(header)
            .child(
                uniform_list(
                    "quotes",
                    self.order.len(),
                    cx.processor(|this, range: Range<usize>, _, cx| {
                        range
                            .map(|position| {
                                let index = this.order[position];
                                let quote = &this.rows[index];
                                let selected = this.selected == Some(index);
                                let symbol = quote.symbol.clone();
                                let company = quote.name;
                                let price = quote.price;
                                let change = quote.change;
                                let volume = quote.volume;
                                let change_color = if change >= 0. {
                                    rgb(0x16834c)
                                } else {
                                    rgb(0xc34242)
                                };
                                div()
                                    .id(("quote", index))
                                    .debug_selector(move || {
                                        format!("quote-row-position-{position}")
                                    })
                                    .flex()
                                    .items_center()
                                    .h(px(ROW_HEIGHT))
                                    .border_b_1()
                                    .border_color(rgb(0xe5e7eb))
                                    .bg(if selected {
                                        rgb(0xdbeafe)
                                    } else if position % 2 == 0 {
                                        rgb(0xffffff)
                                    } else {
                                        rgb(0xf8fafc)
                                    })
                                    .child(div().flex_1().px_3().child(symbol))
                                    .child(div().flex_1().px_3().child(company))
                                    .child(div().flex_1().px_3().child(format!("${price:.2}")))
                                    .child(
                                        div()
                                            .flex_1()
                                            .px_3()
                                            .text_color(change_color)
                                            .child(format!("{change:+.2}%")),
                                    )
                                    .child(
                                        div()
                                            .flex_1()
                                            .px_3()
                                            .text_color(rgb(0x5b6472))
                                            .child(format!("{volume} shares")),
                                    )
                                    .cursor_pointer()
                                    .on_click(cx.listener(move |this, _, _, cx| {
                                        this.selected = Some(index);
                                        cx.notify();
                                    }))
                            })
                            .collect()
                    }),
                )
                .debug_selector(|| "quotes-viewport".into())
                .flex_1()
                .min_h_0()
                .track_scroll(&self.scroll),
            )
    }
}

fn scenario() -> anyhow::Result<gpui_test::Scenario<DataTable>> {
    gpui_test::Scenario::new(
        "data-table",
        "Data table",
        size(px(920.), px(600.)),
        |_, cx: &mut App| cx.new(|_| DataTable::new()),
    )?
    .checkpoint("default", "Symbol-sorted virtual rows", Duration::ZERO)?
    .checkpoint_with(
        "price-sort",
        "Sort by ascending price",
        Duration::from_millis(100),
        |cx, table, window| {
            gpui_test::dispatch_click_on(cx, window.into(), "sort-price")?;
            anyhow::ensure!(
                table.read_with(cx, |table, _| {
                    table.sort_by == SortBy::Price
                        && !table.descending
                        && table.prices_sorted(false)
                }),
                "first price click did not sort rows ascending"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "price-sort-descending",
        "Clicking the active sort reverses it",
        Duration::from_millis(200),
        |cx, table, window| {
            gpui_test::dispatch_click_on(cx, window.into(), "sort-price")?;
            anyhow::ensure!(
                table.read_with(cx, |table, _| table.descending && table.prices_sorted(true)),
                "second price click did not sort rows descending"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "selected-row",
        "Select the first visible quote",
        Duration::from_millis(300),
        |cx, table, window| {
            gpui_test::dispatch_click_on(cx, window.into(), "quote-row-position-0")?;
            anyhow::ensure!(
                table.read_with(cx, |table, _| table.selected
                    == table.order.first().copied()),
                "row click did not select the first visible quote"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "sort-keeps-selection",
        "Sorting keeps selection attached to the same row identity",
        Duration::from_millis(400),
        |cx, table, window| {
            let selected = table.read_with(cx, |table, _| table.selected);
            gpui_test::dispatch_click_on(cx, window.into(), "sort-symbol")?;
            anyhow::ensure!(
                table.read_with(cx, |table, _| table.selected) == selected,
                "sort changed the selected row identity"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "wheel-scroll",
        "Wheel input moves the real virtual-list viewport",
        Duration::from_millis(500),
        |cx, table, window| {
            let bounds = cx
                .debug_bounds(window.into(), "quotes-viewport")?
                .ok_or_else(|| anyhow::anyhow!("virtual-list viewport is missing"))?;
            let before = table.read_with(cx, |table, _| table.scroll_offset_y());
            gpui_test::dispatch_input(
                cx,
                window.into(),
                gpui::PlatformInput::ScrollWheel(gpui::ScrollWheelEvent {
                    position: bounds.center(),
                    delta: gpui::ScrollDelta::Pixels(gpui::point(px(0.), px(-280.))),
                    modifiers: gpui::Modifiers::default(),
                    touch_phase: gpui::TouchPhase::Moved,
                }),
            )?;
            cx.draw_window(window.into())?;
            let (after, scrollable) = table.read_with(cx, |table, _| {
                (table.scroll_offset_y(), table.scroll.is_scrollable())
            });
            anyhow::ensure!(
                after < before,
                "wheel did not move the viewport: before={before}, after={after}, \
                 scrollable={scrollable}, bounds={bounds:?}"
            );
            Ok(())
        },
    )?
    .checkpoint_with(
        "scroll-far",
        "Scroll handle renders a deep virtual row",
        Duration::from_millis(600),
        |cx, table, window| {
            table.update(cx, |table, _| {
                table.scroll.scroll_to_item(500, ScrollStrategy::Top);
            });
            let requested_row =
                table.read_with(cx, |table, _| table.scroll.logical_scroll_top_index());
            anyhow::ensure!(
                requested_row == 500,
                "scroll handle requested row {requested_row}"
            );
            cx.draw_window(window.into())?;
            let (offset, scrollable) = table.read_with(cx, |table, _| {
                (table.scroll_offset_y(), table.scroll.is_scrollable())
            });
            anyhow::ensure!(offset < 0., "wheel input left offset at {offset}");
            anyhow::ensure!(
                cx.debug_bounds(window.into(), "quote-row-position-500")?
                    .is_some(),
                "deep scroll did not mount row 500; offset={offset}, scrollable={scrollable}"
            );
            Ok(())
        },
    )
}

fn main() {
    example_prelude::run_example(scenario().expect("valid table scenario"))
        .expect("run data table example");
}
