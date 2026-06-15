const std = @import("std");
const pg = @import("pg");
const clickzig = @import("clickzig");

test "pg" {
    if (true) return;

    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer std.testing.expect(gpa.deinit() == .ok) catch @panic("leak");
    const allocator = gpa.allocator();

    var threaded: std.Io.Threaded = .init(allocator, .{});
    defer threaded.deinit();
    const io = threaded.io();

    var pool = try pg.Pool.init(io, allocator, .{ .size = 5, .connect = .{
        .port = 5432,
        .host = "10.0.0.1",
    }, .auth = .{
        .username = "...",
        .database = "...",
        .password = "...",
    } });
    defer pool.deinit();

    var result = try pool.query("select id, name from users", .{});
    defer result.deinit();

    while (try result.next()) |row| {
        const id = try row.get([]u8, 0);
        const name = try row.get([]u8, 1);
        const id_hex = try pg.uuidToHex(id);
        std.debug.print("{s} {f}\n", .{ id_hex[0..], std.unicode.fmtUtf8(name) });
    }
}

test "ch" {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer std.testing.expect(gpa.deinit() == .ok) catch @panic("leak");
    // defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var threaded: std.Io.Threaded = .init(allocator, .{});
    defer threaded.deinit();
    const io = threaded.io();

    const client = try clickzig.Client.connectTcp(.{
        .control_allocator = allocator,
        .read_buffer_size = 64 * 1024,
        .write_buffer_size = 4 * 1024,
        .username = "default",
        .password = "",
    }, io, null, null);
    defer client.close();

    const info = client.server_info;
    std.debug.print("connected to {s} {d}.{d}.{d} (revision {d})\n", .{
        info.name,
        info.major_version,
        info.minor_version,
        info.version_patch,
        info.revision,
    });
    if (info.timezone) |tz| std.debug.print("server timezone: {s}\n", .{tz});
    if (info.display_name) |dn| std.debug.print("display name:    {s}\n", .{dn});
    std.debug.print("negotiated protocol revision: {d}\n", .{info.negotiated(clickzig.protocol.CLIENT_REVISION)});
}
