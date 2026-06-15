const std = @import("std");
const pg = @import("pg");

test "pg" {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer std.testing.expect(gpa.deinit() == .ok) catch @panic("leak");
    // defer _ = gpa.deinit();
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
        .timeout = 10_000,
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
