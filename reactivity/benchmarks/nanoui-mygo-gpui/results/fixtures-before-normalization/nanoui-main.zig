//! Native presentation fixture shared with the MyGo and GPUI Linux runs.
const std = @import("std");
const nanoui = @import("nanoui");
const ui = nanoui.ui;

const Bench = struct {
    count: usize,
    virtual: bool,
    io: std.Io,
    started: std.Io.Timestamp,
    report_stages: bool,
    reported_first: bool = false,
    on: bool = false,

    fn view(s: *Bench, c: *ui.Context) void {
        if (s.report_stages and !s.reported_first) {
            s.reported_first = true;
            const elapsed = std.Io.Timestamp.durationTo(s.started, std.Io.Timestamp.now(s.io, .awake)).toMicroseconds();
            std.debug.print("LUNA_VIEW_FIRST_US,{d}\n", .{elapsed});
        }
        ui.column(c, .{ .width = .fill, .height = .fill, .padding = .all(8), .gap = 6 });
        defer ui.end(c);
        ui.row(c, .{ .width = .fill, .height = .{ .px = 48 }, .align_items = .center, .gap = 8 });
        _ = c.leaf(.{ .width = .{ .px = 40 }, .height = .{ .px = 40 }, .background = if (s.on) .hex(0x14be28) else .hex(0xdc141e) }, .none, "marker");
        if (ui.button(c, "Toggle pixel marker", .{ .width = .{ .px = 180 }, .size = 14 }).clicked) {
            s.on = !s.on;
            if (s.report_stages) {
                const elapsed = std.Io.Timestamp.durationTo(s.started, std.Io.Timestamp.now(s.io, .awake)).toMicroseconds();
                std.debug.print("LUNA_VIEW_CLICK_US,{d}\n", .{elapsed});
            }
        }
        ui.textf(c, .{ .size = 13 }, "rows: {d}", .{s.count});
        ui.end(c);
        if (s.virtual) {
            var rows = ui.list(c, .{ .count = s.count, .row_height = 24, .width = .fill, .height = .fill });
            while (rows.next()) |i| ui.textf(c, .{ .size = 12 }, "row {d}", .{i});
            rows.end();
        } else {
            ui.scroll(c, .{ .width = .fill, .height = .fill });
            for (0..s.count) |i| ui.textf(c, .{ .size = 12 }, "row {d}", .{i});
            ui.end(c);
        }
    }
};

pub fn main(init: std.process.Init) !void {
    const env = init.environ_map;
    const count = if (env.get("LUNA_ROWS")) |raw| std.fmt.parseInt(usize, raw, 10) catch 0 else 0;
    const virtual = if (env.get("LUNA_MODE")) |raw| std.mem.eql(u8, raw, "virtual") else false;
    const app = try nanoui.App.create(init, .{ .name = "Luna Benchmark" });
    defer app.destroy();
    var state: Bench = .{ .count = count, .virtual = virtual, .io = init.io, .started = std.Io.Timestamp.now(init.io, .awake), .report_stages = env.get("LUNA_STAGES") != null };
    _ = try app.newWindow(.{ .title = "Luna Benchmark", .width = 800, .height = 600, .content = .{ .view = .init(&state, Bench.view) } });
    try app.run();
}
