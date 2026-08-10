const std = @import("std");

test "h" {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer std.testing.expect(gpa.deinit() == .ok) catch @panic("leak");
    // defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var threaded: std.Io.Threaded = .init(allocator, .{});
    defer threaded.deinit();
    const io = threaded.io();

    var client: std.http.Client = .{ .allocator = allocator, .io = io };
    defer client.deinit();

    var response_writer = std.Io.Writer.Allocating.init(allocator);
    defer response_writer.deinit();

    const result = try client.fetch(.{
        .location = .{ .url = "https://checkip.global.api.aws" },
        .response_writer = &response_writer.writer,
    });

    if (result.status == .ok) {
        std.debug.print("Response:\n{s}\n", .{response_writer.written()});
    } else {
        std.debug.print("HTTP Error: {}\n", .{result.status});
    }
}
