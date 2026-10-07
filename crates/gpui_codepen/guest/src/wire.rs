//! Compact interpreter transport: avoid interpreting serde's JSON formatter for
//! every style field. Rust still constructs the whole component and its state.
use crate::{Frame, MAX_FRAME_BYTES, Node, PROTOCOL_VERSION, Style, Value};

pub fn encode(frame: &Frame) -> Vec<u8> {
    fn number(out: &mut Vec<u8>, value: u32) {
        out.extend_from_slice(&value.to_le_bytes());
    }
    fn string(out: &mut Vec<u8>, value: &str) {
        number(out, value.len() as u32);
        assert!(
            value.len() <= MAX_FRAME_BYTES.saturating_sub(out.len()),
            "component frame exceeds 1 MiB"
        );
        out.extend_from_slice(value.as_bytes());
    }
    fn optional(out: &mut Vec<u8>, value: &Option<String>) {
        if let Some(value) = value {
            string(out, value);
        } else {
            number(out, u32::MAX);
        }
    }
    fn style(out: &mut Vec<u8>, s: &Style) {
        let flags = (s.flex as u32)
            | ((s.column as u32) << 1)
            | ((s.wrap as u32) << 2)
            | ((s.grow as u32) << 3)
            | ((s.full_width as u32) << 4)
            | ((s.full_height as u32) << 5)
            | ((s.bold as u32) << 6)
            | ((s.center as u32) << 7)
            | ((s.justify_center as u32) << 8)
            | ((s.justify_between as u32) << 9)
            | ((s.shadow as u32) << 10)
            | ((s.clip as u32) << 11);
        number(out, flags);
        let values = [
            s.width.map(f32::to_bits),
            s.height.map(f32::to_bits),
            s.padding.map(f32::to_bits),
            s.gap.map(f32::to_bits),
            s.radius.map(f32::to_bits),
            s.border.map(f32::to_bits),
            s.background,
            s.color,
            s.border_color,
            s.font_size.map(f32::to_bits),
            s.opacity.map(f32::to_bits),
        ];
        let mut mask = 0u32;
        for (i, value) in values.iter().enumerate() {
            if value.is_some() {
                mask |= 1 << i;
            }
        }
        number(out, mask);
        for value in values.into_iter().flatten() {
            number(out, value);
        }
    }
    fn node(out: &mut Vec<u8>, n: &Node, depth: usize, remaining: &mut usize) {
        assert!(
            depth <= 48 && *remaining > 0,
            "component exceeds element budget"
        );
        *remaining -= 1;
        assert!(
            out.len() <= MAX_FRAME_BYTES,
            "component frame exceeds 1 MiB"
        );
        match n {
            Node::Text { text } => {
                out.push(0);
                string(out, text);
            }
            Node::Div {
                id,
                style: s,
                hover,
                click,
                children,
            } => {
                out.push(1);
                optional(out, id);
                style(out, s);
                if let Some(hover) = hover {
                    out.push(1);
                    style(out, hover);
                } else {
                    out.push(0);
                }
                optional(out, click);
                number(out, children.len() as u32);
                for child in children {
                    node(out, child, depth + 1, remaining);
                }
            }

        }
    }
    let mut out = Vec::with_capacity(4096);
    number(&mut out, PROTOCOL_VERSION);
    // Write state directly through a bounded writer, avoiding a second,
    // potentially unbounded JSON string allocation in the interpreter.
    struct StateWriter<'a> {
        out: &'a mut Vec<u8>,
        written: usize,
    }
    impl std::io::Write for StateWriter<'_> {
        fn write(&mut self, bytes: &[u8]) -> std::io::Result<usize> {
            if bytes.len() > (64 * 1024usize).saturating_sub(self.written) {
                return Err(std::io::Error::other("component state exceeds 64 KiB"));
            }
            self.out.extend_from_slice(bytes);
            self.written += bytes.len();
            Ok(bytes.len())
        }
        fn flush(&mut self) -> std::io::Result<()> {
            Ok(())
        }
    }
    fn json(out: &mut Vec<u8>, value: &Value) {
        let start = out.len();
        number(out, 0);
        let mut state = StateWriter { out, written: 0 };
        serde_json::to_writer(&mut state, value).expect("component state exceeds 64 KiB");
        let length = state.written as u32;
        out[start..start + 4].copy_from_slice(&length.to_le_bytes());
    }
    json(&mut out, &frame.state);
    node(&mut out, &frame.root, 0, &mut 4096);
    out
}

/// Decode only on the compiled host. All lengths/depths are checked before
/// allocating; the public Frame validator then checks styles and identifiers.
pub fn decode(bytes: &[u8]) -> Result<Frame, String> {
    struct Reader<'a> {
        bytes: &'a [u8],
        nodes: usize,
    }
    impl Reader<'_> {
        fn take(&mut self, len: usize) -> Result<&[u8], String> {
            if len > self.bytes.len() {
                return Err("truncated component frame".into());
            }
            let (value, rest) = self.bytes.split_at(len);
            self.bytes = rest;
            Ok(value)
        }
        fn byte(&mut self) -> Result<u8, String> {
            Ok(self.take(1)?[0])
        }
        fn number(&mut self) -> Result<u32, String> {
            Ok(u32::from_le_bytes(self.take(4)?.try_into().unwrap()))
        }
        fn string(&mut self) -> Result<String, String> {
            let len = self.number()? as usize;
            std::str::from_utf8(self.take(len)?)
                .map(str::to_owned)
                .map_err(|e| e.to_string())
        }
        fn optional(&mut self) -> Result<Option<String>, String> {
            let len = self.number()?;
            if len == u32::MAX {
                Ok(None)
            } else {
                std::str::from_utf8(self.take(len as usize)?)
                    .map(|s| Some(s.to_owned()))
                    .map_err(|e| e.to_string())
            }
        }
        fn style(&mut self) -> Result<Style, String> {
            let flags = self.number()?;
            let mask = self.number()?;
            if flags >> 12 != 0 || mask >> 11 != 0 {
                return Err("invalid style flags".into());
            }
            let mut v = [None; 11];
            for (i, value) in v.iter_mut().enumerate() {
                if mask & (1 << i) != 0 {
                    *value = Some(self.number()?);
                }
            }
            Ok(Style {
                flex: flags & 1 != 0,
                column: flags & 2 != 0,
                wrap: flags & 4 != 0,
                grow: flags & 8 != 0,
                full_width: flags & 16 != 0,
                full_height: flags & 32 != 0,
                bold: flags & 64 != 0,
                center: flags & 128 != 0,
                justify_center: flags & 256 != 0,
                justify_between: flags & 512 != 0,
                shadow: flags & 1024 != 0,
                clip: flags & 2048 != 0,
                width: v[0].map(f32::from_bits),
                height: v[1].map(f32::from_bits),
                padding: v[2].map(f32::from_bits),
                gap: v[3].map(f32::from_bits),
                radius: v[4].map(f32::from_bits),
                border: v[5].map(f32::from_bits),
                background: v[6],
                color: v[7],
                border_color: v[8],
                font_size: v[9].map(f32::from_bits),
                opacity: v[10].map(f32::from_bits),
            })
        }
        fn node(&mut self, depth: usize) -> Result<Node, String> {
            if depth > 48 || self.nodes >= 4096 {
                return Err("component exceeds element budget".into());
            }
            self.nodes += 1;
            match self.byte()? {
                0 => Ok(Node::Text {
                    text: self.string()?,
                }),
                1 => {
                    let id = self.optional()?;
                    let style = self.style()?;
                    let hover = match self.byte()? {
                        0 => None,
                        1 => Some(self.style()?),
                        _ => return Err("invalid hover tag".into()),
                    };
                    let click = self.optional()?;
                    let len = self.number()? as usize;
                    if len > 4096 {
                        return Err("component exceeds element budget".into());
                    }
                    let mut children = Vec::with_capacity(len);
                    for _ in 0..len {
                        children.push(self.node(depth + 1)?);
                    }
                    Ok(Node::Div {
                        id,
                        style,
                        hover,
                        click,
                        children,
                    })
                }
                _ => Err("invalid component node tag".into()),
            }
        }
    }
    if bytes.len() > MAX_FRAME_BYTES {
        return Err("component frame exceeds 1 MiB".into());
    }
    let mut reader = Reader { bytes, nodes: 0 };
    let version = reader.number()?;
    let state = serde_json::from_str(&reader.string()?).map_err(|e| e.to_string())?;
    let root = reader.node(0)?;
    if !reader.bytes.is_empty() {
        return Err("trailing component frame bytes".into());
    }
    let frame = Frame {
        version,
        state,
        root,
    };
    frame.validate()?;
    Ok(frame)
}
