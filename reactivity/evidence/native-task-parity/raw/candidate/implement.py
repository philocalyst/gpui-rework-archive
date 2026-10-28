from pathlib import Path
p=Path('/home/user/gpui-native-task-parity-lab/reactivity/crates/gpui/examples/zgx_native_lab.rs');s=p.read_text().replace('use std::time::{Duration, Instant};','use std::{collections::VecDeque, time::{Duration, Instant}};')
s=s.replace('    done: i32,\n}', '    done: i32,\n    controls: Controls,\n}',1)
a=s.index('impl Lab {')
s=s[:a]+'''// Match the reference's spawn + yield_now: one poll yields, the next applies.
// Only the wake is coalesced; every queued operation remains UI-owned and FIFO.
#[derive(Clone, Copy, Debug)]
enum Control {
    Append,
    Rewrite,
}
struct ControlTask {
    operation: Control,
    yielded: bool,
}
#[derive(Default)]
struct Controls {
    pending: VecDeque<ControlTask>,
    wake: Option<Remote<()>>,
    trace: bool,
}
impl Controls {
    fn schedule(&mut self) {
        if let Some(wake) = &self.wake {
            match wake.try_send(()) {
                Ok(()) | Err(SendError::Full(())) => {}
                Err(SendError::Closed(())) => self.pending.clear(),
            }
        }
    }
}
''' +s[a:]
s=s.replace('            done: 0,\n', '            done: 0,\n            controls: Controls::default(),\n',1)
a=s.index('    fn control(&mut self, id: usize) {');b=s.index('\n}\n// This state',a)
s=s[:a]+'''    fn control(&mut self, id: usize) {
        let operation = match id {
            0 => Control::Append,
            1 => Control::Rewrite,
            _ => {
                self.done = 999;
                if self.controls.trace {
                    eprintln!("GPUI_CONTROL,immediate,999,{},{}", self.items.len(), self.done);
                }
                return;
            }
        };
        self.controls.pending.push_back(ControlTask { operation, yielded: false });
        if self.controls.trace {
            eprintln!("GPUI_CONTROL,queued,{operation:?},{},{}", self.items.len(), self.done);
        }
        self.controls.schedule();
    }
    fn poll_controls(&mut self, (): ()) {
        // deliver_ready freezes the inbox before callbacks. A self-wake here
        // belongs to a later delivery, even when that caller has a large budget.
        let ready = self.controls.pending.len();
        for _ in 0..ready {
            let mut task = self.controls.pending.pop_front().unwrap();
            if task.yielded {
                self.apply_control(task.operation);
                if self.controls.trace {
                    eprintln!("GPUI_CONTROL,applied,{:?},{},{}", task.operation, self.items.len(), self.done);
                }
            } else {
                task.yielded = true;
                if self.controls.trace {
                    eprintln!("GPUI_CONTROL,yielded,{:?},{},{}", task.operation, self.items.len(), self.done);
                }
                self.controls.pending.push_back(task);
            }
        }
        if !self.controls.pending.is_empty() { self.controls.schedule(); }
    }
    fn apply_control(&mut self, operation: Control) {
        self.done = match operation {
            Control::Append => {
                let mut result = 0;
                for value in [1, 2, 3] {
                    if self.items.len() == 4 {
                        result = -1;
                        break;
                    }
                    self.items.push(value);
                }
                result
            }
            Control::Rewrite => match self.items.first_mut() {
                Some(first) => {
                    *first = 99;
                    *first = 99;
                    0
                }
                None => -1,
            },
        };
    }
''' +s[b:]
s=s.replace('    let model = Lab::new(&work);','    let mut model = Lab::new(&work);',1)
needle='    let trace = std::env::var_os("GPUI_LAB_TRACE").is_some();';s=s.replace(needle,needle+'''
    let (control_wake, control_inbox) = Remote::bounded(1);
    model.controls.wake = Some(control_wake);
    model.controls.trace = trace;''',1)
s=s.replace('    let window = Window::document(model)\n','    let window = Window::document(model)\n        .with_inbox(control_inbox, Lab::poll_controls)\n',1)
p.write_text(s)
