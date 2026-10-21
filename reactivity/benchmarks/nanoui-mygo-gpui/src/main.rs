use std::{
    ops::{Deref, DerefMut},
    os::fd::AsFd,
    process::{Child, Command, Stdio},
    time::{Duration, Instant},
};

use rustix::event::{PollFd, PollFlags, Timespec, poll};
use x11rb::{
    connection::Connection,
    protocol::{
        Event,
        damage::{ConnectionExt as DamageExt, ReportLevel},
        xproto::{AtomEnum, ConnectionExt as XprotoExt, EventMask, ImageFormat},
        xtest,
    },
    rust_connection::RustConnection,
};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = std::env::args().skip(1).collect::<Vec<_>>();
    if args.len() < 2 {
        return Err("usage: luna-x11-observer TITLE /path/to/app [args...]".into());
    }
    let title = &args[0];
    let starts: usize = std::env::var("LUNA_STARTS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(20);
    let clicks_per_start: usize = std::env::var("LUNA_CLICKS_PER_START")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(10);
    let memory_starts: usize = std::env::var("LUNA_MEMORY_STARTS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(5)
        .min(starts);
    let preflight = std::env::var_os("LUNA_PREFLIGHT").is_some();
    let app = std::env::var("LUNA_APP").unwrap_or_else(|_| "unknown".into());
    let rows: usize = std::env::var("LUNA_ROWS")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(0);
    let mode = std::env::var("LUNA_MODE").unwrap_or_else(|_| "eager".into());
    let (conn, screen_num) = x11rb::connect(None)?;
    conn.damage_query_version(1, 1)?.reply()?;
    let screen = &conn.setup().roots[screen_num];
    let root = screen.root;
    let visual = screen
        .allowed_depths
        .iter()
        .flat_map(|depth| depth.visuals.iter())
        .find(|visual| visual.visual_id == screen.root_visual)
        .ok_or("root visual missing")?;
    let masks = (visual.red_mask, visual.green_mask, visual.blue_mask);
    println!(
        "X11_VISUAL,{},{},{},{}",
        visual.visual_id, masks.0, masks.1, masks.2
    );
    if preflight {
        println!(
            "X11_SCREEN,{},{},{},{},{}",
            screen.width_in_pixels,
            screen.height_in_pixels,
            screen.width_in_millimeters,
            screen.height_in_millimeters,
            screen.root_depth
        );
    }
    conn.change_window_attributes(
        root,
        &x11rb::protocol::xproto::ChangeWindowAttributesAux::new()
            .event_mask(EventMask::SUBSTRUCTURE_NOTIFY),
    )?
    .check()?;
    conn.flush()?;
    let wm_name = conn.intern_atom(false, b"WM_NAME")?.reply()?.atom;
    let net_name = conn.intern_atom(false, b"_NET_WM_NAME")?.reply()?.atom;
    let utf8 = conn.intern_atom(false, b"UTF8_STRING")?.reply()?.atom;
    let mut startup = Vec::with_capacity(starts);
    let mut click_latencies = Vec::with_capacity(starts * clicks_per_start);

    for sample in 0..starts {
        let start = Instant::now();
        let mut command = if let Ok(loader) = std::env::var("LUNA_INTERPRETER") {
            let library_path = std::env::var("LUNA_LIBRARY_PATH").unwrap_or_default();
            let mut command = Command::new(loader);
            command
                .arg("--library-path")
                .arg(library_path)
                .arg(&args[1]);
            command.args(&args[2..]);
            command
        } else {
            let mut command = Command::new(&args[1]);
            command.args(&args[2..]);
            command
        };
        let mut child = ChildGuard(
            command
                .stdout(Stdio::inherit())
                .stderr(Stdio::inherit())
                .spawn()?,
        );
        let win = find_window(&conn, root, &mut child, title, wm_name, net_name, utf8)?;

        // Geometry and coordinate queries follow the startup acknowledgement. Damage
        // tracking is the only extra setup before the first exact marker read.
        let damage_id = conn.generate_id()?;
        conn.damage_create(damage_id, win, ReportLevel::NON_EMPTY)?
            .check()?;
        conn.flush()?;
        let first_pixel = wait_for_pixel(
            &conn,
            win,
            damage_id,
            false,
            screen.root_depth,
            masks,
            start + Duration::from_secs(25),
        )?;
        let first_ack = start.elapsed();
        startup.push(first_ack);
        println!("STARTUP,{sample},{},{}", first_ack.as_nanos(), first_pixel);

        let geometry = conn.get_geometry(win)?.reply()?;
        let translated = conn.translate_coordinates(win, root, 0, 0)?.reply()?;
        if preflight {
            if geometry.width != 800 || geometry.height != 600 {
                return Err(format!(
                    "preflight failed: expected 800x600 client, got {}x{}",
                    geometry.width, geometry.height
                )
                .into());
            }
            println!(
                "WINDOW_GEOMETRY,{sample},{},{},{},{},{},{},{},{}",
                win,
                geometry.x,
                geometry.y,
                geometry.width,
                geometry.height,
                translated.dst_x,
                translated.dst_y,
                geometry.depth
            );
            if let Ok(path) = std::env::var("LUNA_SCREENSHOT_PATH") {
                let image = conn
                    .get_image(
                        ImageFormat::Z_PIXMAP,
                        win,
                        0,
                        0,
                        geometry.width,
                        geometry.height,
                        u32::MAX,
                    )?
                    .reply()?
                    .data;
                let ppm = ppm_from_ximage(
                    &image,
                    geometry.width as usize,
                    geometry.height as usize,
                    geometry.depth,
                    masks,
                )?;
                std::fs::write(&path, ppm)?;
                println!("SCREENSHOT,{sample},{path}");
            }
            let image = conn
                .get_image(
                    ImageFormat::Z_PIXMAP,
                    win,
                    0,
                    0,
                    geometry.width,
                    geometry.height,
                    u32::MAX,
                )?
                .reply()?
                .data;
            let button_ink = dark_pixel_count(
                &image,
                geometry.width as usize,
                geometry.height as usize,
                (56, 8, 296, 48),
                masks,
            );
            let body_ink = dark_pixel_count(
                &image,
                geometry.width as usize,
                geometry.height as usize,
                (8, 62, 792, 86),
                masks,
            );
            if button_ink == 0 || (rows > 0 && body_ink == 0) {
                return Err(format!(
                    "preflight failed: no visible glyph ink in button/body text rectangles (button={button_ink}, body={body_ink}, rows={rows}); refusing to benchmark invisible text"
                )
                .into());
            }
            let visible = rows.min(530usize.div_ceil(24));
            let materialized = if rows == 0 {
                0
            } else if mode == "virtual" {
                match app.as_str() {
                    "gpui" => visible,
                    "mygo" => visible + 2,
                    "nanoui" => visible + 5,
                    _ => visible,
                }
            } else {
                rows
            };
            let visible_ids = if visible == 0 {
                "none".to_owned()
            } else {
                format!("0..{}", visible - 1)
            };
            println!(
                "PREFLIGHT_TEXT,{sample},button_dark_pixels={button_ink},first_row_dark_pixels={body_ink}"
            );
            println!(
                "PREFLIGHT_ROWS,{sample},app={app},mode={mode},requested={rows},visible_ids={visible_ids},materialized_expected={materialized},viewport=784x530,row_height=24"
            );
        }
        if sample < memory_starts {
            let idle_ms: u64 = std::env::var("LUNA_IDLE_MS")
                .ok()
                .and_then(|s| s.parse().ok())
                .unwrap_or(750);
            std::thread::sleep(Duration::from_millis(idle_ms));
            let (rss_kib, pss_kib, threads) = proc_memory(child.id())?;
            println!("IDLE,{sample},{rss_kib},{pss_kib},{threads}");
        }

        // XTEST button events do not move the pointer. Establish the button location
        // before timing, round-trip to the server, then clear hover/exposure damage.
        let root_x = translated.dst_x + 176;
        let root_y = translated.dst_y + 24;
        xtest::fake_input(
            &conn,
            x11rb::protocol::xproto::MOTION_NOTIFY_EVENT,
            0,
            0,
            root,
            root_x,
            root_y,
            0,
        )?;
        conn.flush()?;
        conn.get_input_focus()?.reply()?;
        drain_damage(&conn, damage_id, win, screen.root_depth)?;
        if !pixel_matches(pixel(&conn, win, 28, 28, screen.root_depth)?, false, masks) {
            return Err(
                format!("sample {sample}: marker changed while positioning pointer").into(),
            );
        }

        let mut expected_green = false;
        for click in 0..clicks_per_start {
            conn.damage_subtract(damage_id, 0u32, 0u32)?.check()?;
            conn.flush()?;
            let before = Instant::now();
            xtest::fake_input(
                &conn,
                x11rb::protocol::xproto::BUTTON_PRESS_EVENT,
                1,
                0,
                root,
                root_x,
                root_y,
                0,
            )?;
            xtest::fake_input(
                &conn,
                x11rb::protocol::xproto::BUTTON_RELEASE_EVENT,
                1,
                0,
                root,
                root_x,
                root_y,
                0,
            )?;
            conn.flush()?;
            expected_green = !expected_green;
            let deadline = before + Duration::from_secs(5);
            loop {
                if let Some(event) = conn.poll_for_event()? {
                    if let Event::DamageNotify(e) = event {
                        if e.damage == damage_id {
                            // NON_EMPTY reports only once until subtraction. Ack every
                            // event before reading, including events with the old color.
                            conn.damage_subtract(damage_id, 0u32, 0u32)?.check()?;
                            conn.flush()?;
                            let observed = pixel(&conn, win, 28, 28, screen.root_depth)?;
                            if pixel_matches(observed, expected_green, masks) {
                                let elapsed = before.elapsed();
                                click_latencies.push(elapsed);
                                println!(
                                    "CLICK,{sample},{click},{},{}",
                                    elapsed.as_nanos(),
                                    observed
                                );
                                break;
                            }
                        }
                    }
                } else if !wait_readable(conn.stream(), deadline)? {
                    let current = pixel(&conn, win, 28, 28, screen.root_depth)?;
                    let _ = conn.damage_destroy(damage_id);
                    let _ = child.kill();
                    let _ = child.wait();
                    return Err(format!("sample {sample} click {click}: timed out waiting for exact marker pixel; current={current:#x}").into());
                }
            }
        }
        let _ = conn.damage_destroy(damage_id)?.check();
        let _ = child.kill();
        let _ = child.wait();
        println!("WINDOW,{sample},{},{}", geometry.width, geometry.height);
    }
    emit_summary("STARTUP", &mut startup);
    emit_summary("CLICK", &mut click_latencies);
    Ok(())
}

struct ChildGuard(Child);

impl Deref for ChildGuard {
    type Target = Child;
    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl DerefMut for ChildGuard {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}

impl Drop for ChildGuard {
    fn drop(&mut self) {
        let _ = self.0.kill();
        let _ = self.0.wait();
    }
}

fn find_window(
    conn: &RustConnection,
    root: u32,
    child: &mut Child,
    title: &str,
    wm_name: u32,
    net_name: u32,
    utf8: u32,
) -> Result<u32, Box<dyn std::error::Error>> {
    let deadline = Instant::now() + Duration::from_secs(25);
    let mut candidates = Vec::new();
    while Instant::now() < deadline {
        if child.try_wait()?.is_some() {
            return Err("application exited before creating titled window".into());
        }
        while let Some(event) = conn.poll_for_event()? {
            match event {
                Event::MapNotify(map) => {
                    candidates.push(map.window);
                    let matched =
                        window_title_matches(conn, map.window, title, wm_name, net_name, utf8)?;
                    if std::env::var_os("LUNA_DEBUG_X11").is_some() {
                        eprintln!("MAP_NOTIFY window={} title_match={matched}", map.window);
                    }
                    if matched {
                        return Ok(map.window);
                    }
                    conn.change_window_attributes(
                        map.window,
                        &x11rb::protocol::xproto::ChangeWindowAttributesAux::new()
                            .event_mask(EventMask::PROPERTY_CHANGE),
                    )?
                    .check()?;
                    conn.flush()?;
                    // Close the race where the title is assigned between the first
                    // property query and selecting PropertyNotify on the candidate.
                    if window_title_matches(conn, map.window, title, wm_name, net_name, utf8)? {
                        return Ok(map.window);
                    }
                }
                Event::PropertyNotify(property) if candidates.contains(&property.window) => {
                    if window_title_matches(conn, property.window, title, wm_name, net_name, utf8)?
                    {
                        return Ok(property.window);
                    }
                }
                _ => {}
            }
        }
        // The short poll timeout is only for detecting child exit/title setup; no timed
        // loop or fixed sleep is used for presentation acknowledgement.
        let check_deadline = (Instant::now() + Duration::from_millis(50)).min(deadline);
        let _ = wait_readable(conn.stream(), check_deadline)?;
    }
    let _ = root; // Root SubstructureNotify supplies each newly mapped top-level.
    Err("timed out waiting for native window".into())
}

fn window_title_matches<C: Connection>(
    conn: &C,
    w: u32,
    title: &str,
    wm_name: u32,
    net_name: u32,
    utf8: u32,
) -> Result<bool, Box<dyn std::error::Error>> {
    let classic = conn
        .get_property(false, w, wm_name, AtomEnum::STRING, 0, 2048)?
        .reply()
        .ok()
        .map(|p| String::from_utf8_lossy(&p.value).into_owned())
        .unwrap_or_default();
    let modern = conn
        .get_property(false, w, net_name, utf8, 0, 2048)?
        .reply()
        .ok()
        .map(|p| String::from_utf8_lossy(&p.value).into_owned())
        .unwrap_or_default();
    Ok(classic.contains(title) || modern.contains(title))
}

fn pixel<C: Connection>(
    conn: &C,
    window: u32,
    x: i16,
    y: i16,
    depth: u8,
) -> Result<u32, Box<dyn std::error::Error>> {
    let data = conn
        .get_image(ImageFormat::Z_PIXMAP, window, x, y, 1, 1, u32::MAX)?
        .reply()?
        .data;
    if data.len() < 4 {
        return Err(format!(
            "unexpected XImage byte count {} at depth {depth}",
            data.len()
        )
        .into());
    }
    Ok(u32::from_ne_bytes([data[0], data[1], data[2], data[3]]))
}

fn ppm_from_ximage(
    data: &[u8],
    width: usize,
    height: usize,
    depth: u8,
    masks: (u32, u32, u32),
) -> Result<Vec<u8>, Box<dyn std::error::Error>> {
    let bytes_per_pixel = 4usize;
    let stride = width
        .checked_mul(bytes_per_pixel)
        .ok_or("image row overflow")?;
    if data.len() < stride.checked_mul(height).ok_or("image length overflow")? {
        return Err(format!(
            "short XImage: {} bytes for {width}x{height} depth {depth}",
            data.len()
        )
        .into());
    }
    let mut ppm = Vec::with_capacity(32 + width * height * 3);
    ppm.extend_from_slice(format!("P6\n{width} {height}\n255\n").as_bytes());
    for y in 0..height {
        for x in 0..width {
            let i = y * stride + x * bytes_per_pixel;
            let raw = u32::from_ne_bytes([data[i], data[i + 1], data[i + 2], data[i + 3]]);
            ppm.push(decode_channel(raw, masks.0));
            ppm.push(decode_channel(raw, masks.1));
            ppm.push(decode_channel(raw, masks.2));
        }
    }
    Ok(ppm)
}

fn dark_pixel_count(
    data: &[u8],
    width: usize,
    height: usize,
    rect: (usize, usize, usize, usize),
    masks: (u32, u32, u32),
) -> usize {
    let (x0, y0, x1, y1) = rect;
    if x1 > width || y1 > height || data.len() < width.saturating_mul(height).saturating_mul(4) {
        return 0;
    }
    let mut dark = 0;
    for y in y0..y1 {
        for x in x0..x1 {
            let i = (y * width + x) * 4;
            let raw = u32::from_ne_bytes([data[i], data[i + 1], data[i + 2], data[i + 3]]);
            let r = decode_channel(raw, masks.0);
            let g = decode_channel(raw, masks.1);
            let b = decode_channel(raw, masks.2);
            // Black and antialiased text remain well below this threshold. The
            // marker is red with a high red channel and lies outside both boxes.
            if r < 160 && g < 160 && b < 160 {
                dark += 1;
            }
        }
    }
    dark
}

fn decode_channel(pixel: u32, mask: u32) -> u8 {
    if mask == 0 {
        return 0;
    }
    let shift = mask.trailing_zeros();
    let max = mask >> shift;
    ((((pixel & mask) >> shift) * 255 + max / 2) / max) as u8
}

fn expected_pixel(green: bool, masks: (u32, u32, u32)) -> u32 {
    let rgb = if green {
        (20u32, 190u32, 40u32)
    } else {
        (220u32, 20u32, 30u32)
    };
    encode_channel(rgb.0, masks.0) | encode_channel(rgb.1, masks.1) | encode_channel(rgb.2, masks.2)
}

fn pixel_matches(pixel: u32, green: bool, masks: (u32, u32, u32)) -> bool {
    let rgb_mask = masks.0 | masks.1 | masks.2;
    pixel & rgb_mask == expected_pixel(green, masks)
}

fn encode_channel(value: u32, mask: u32) -> u32 {
    if mask == 0 {
        return 0;
    }
    let shift = mask.trailing_zeros();
    let max = mask >> shift;
    (((value * max + 127) / 255) << shift) & mask
}

fn wait_for_pixel(
    conn: &RustConnection,
    win: u32,
    damage_id: u32,
    green: bool,
    depth: u8,
    masks: (u32, u32, u32),
    deadline: Instant,
) -> Result<u32, Box<dyn std::error::Error>> {
    let expected = expected_pixel(green, masks);
    let mut last_observed = pixel(conn, win, 28, 28, depth)?;
    if pixel_matches(last_observed, green, masks) {
        return Ok(last_observed);
    }
    loop {
        while let Some(event) = conn.poll_for_event()? {
            if matches!(event, Event::DamageNotify(ref e) if e.damage == damage_id) {
                conn.damage_subtract(damage_id, 0u32, 0u32)?.check()?;
                conn.flush()?;
                let observed = pixel(conn, win, 28, 28, depth)?;
                last_observed = observed;
                if pixel_matches(observed, green, masks) {
                    return Ok(observed);
                }
            }
        }
        if !wait_readable(conn.stream(), deadline)? {
            return Err(format!("timed out waiting for exact startup pixel: expected={expected:#x}, last_observed={last_observed:#x}").into());
        }
    }
}

fn drain_damage<C: Connection>(
    conn: &C,
    damage_id: u32,
    win: u32,
    depth: u8,
) -> Result<(), Box<dyn std::error::Error>> {
    while let Some(event) = conn.poll_for_event()? {
        if matches!(event, Event::DamageNotify(ref e) if e.damage == damage_id) {
            conn.damage_subtract(damage_id, 0u32, 0u32)?.check()?;
            conn.flush()?;
            let _ = pixel(conn, win, 28, 28, depth)?;
        }
    }
    Ok(())
}

fn wait_readable<C: AsFd>(conn: &C, deadline: Instant) -> Result<bool, Box<dyn std::error::Error>> {
    loop {
        let remaining = deadline.saturating_duration_since(Instant::now());
        if remaining.is_zero() {
            return Ok(false);
        }
        let timeout = Timespec {
            tv_sec: remaining.as_secs() as i64,
            tv_nsec: remaining.subsec_nanos() as _,
        };
        let mut fds = [PollFd::new(conn, PollFlags::IN)];
        match poll(&mut fds, Some(&timeout)) {
            Ok(n) => return Ok(n != 0),
            Err(rustix::io::Errno::INTR) => continue,
            Err(err) => return Err(err.into()),
        }
    }
}

fn emit_summary(label: &str, values: &mut [Duration]) {
    values.sort();
    for (p, q) in [(50, 0.50), (95, 0.95), (99, 0.99)] {
        let d = values[((values.len() - 1) as f64 * q).round() as usize];
        println!("{label}_P{p}_NS,{},{}", values.len(), d.as_nanos());
    }
}

fn proc_memory(pid: u32) -> Result<(u64, u64, u64), Box<dyn std::error::Error>> {
    let status = std::fs::read_to_string(format!("/proc/{pid}/status"))?;
    let smaps = std::fs::read_to_string(format!("/proc/{pid}/smaps_rollup"))?;
    let value = |text: &str, key: &str| -> Option<u64> {
        text.lines()
            .find(|l| l.starts_with(key))?
            .split_whitespace()
            .nth(1)?
            .parse()
            .ok()
    };
    Ok((
        value(&status, "VmRSS:").ok_or("missing VmRSS")?,
        value(&smaps, "Pss:").ok_or("missing Pss")?,
        value(&status, "Threads:").ok_or("missing Threads")?,
    ))
}
