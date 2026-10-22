use gpui::prelude::*;

const N: usize = 128;

struct Plain;
impl View for Plain {
    fn view(&self) -> El<'_> {
        column((0..N).map(|_| button("Plain")))
    }
}

struct Method {
    calls: usize,
}
impl Method {
    fn activate(&mut self) {
        self.calls += 1;
    }
}
impl View for Method {
    fn view(&self) -> El<'_> {
        column((0..N).map(|_| button("Method").on_click(Self::activate)))
    }
}

struct Captured {
    value: usize,
}
impl View for Captured {
    fn view(&self) -> El<'_> {
        column((0..N).map(|index| {
            button("Captured").on_click(move |model: &mut Self| {
                model.value = model.value.wrapping_add(index);
            })
        }))
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    match std::env::args().nth(1).as_deref() {
        Some("plain") => {
            let win = Win::new(Plain)?;
            let _ = win.inspect()?;
            win.__route_census("plain_128")?;
        }
        Some("method") => {
            let mut win = Win::new(Method { calls: 0 })?;
            win.__route_census("method_128_initial")?;
            win.click(win.button("Method"))?;
            win.__route_census("method_128_after_click")?;
            assert_eq!(win.root()?.calls, 1);
        }
        Some("captured") => {
            let mut win = Win::new(Captured { value: 0 })?;
            win.__route_census("captured_128_initial")?;
            win.click(win.button("Captured"))?;
            win.__route_census("captured_128_after_click")?;
        }
        _ => return Err("pass plain, method or captured".into()),
    }
    Ok(())
}
